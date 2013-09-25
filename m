Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750997Ab3IYE2f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 00:28:35 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:53515 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab3IYE2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 00:28:34 -0400
MIME-Version: 1.0
In-Reply-To: <1380014422.31179.4.camel@AMDC1943>
References: <1378889944-23192-1-git-send-email-k.kozlowski@samsung.com>
	<5237FDCC.5010109@oracle.com>
	<20130923220757.GC16191@variantweb.net>
	<1380014422.31179.4.camel@AMDC1943>
Date: Wed, 25 Sep 2013 12:28:33 +0800
Message-ID: <CAA_GA1f_vpJ+Ou3ANcrK5_Bd-vu+-cnCgEhQ3USiW3MpNX7Opw@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] mm: migrate zbud pages
From: Bob Liu <lliubbo@gmail.com>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>, Bob Liu <bob.liu@oracle.com>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Dave Hansen <dave.hansen@intel.com>, Minchan Kim <minchan@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 24, 2013 at 5:20 PM, Krzysztof Kozlowski
<k.kozlowski@samsung.com> wrote:
> Hi,
>
> On pon, 2013-09-23 at 17:07 -0500, Seth Jennings wrote:
>> On Tue, Sep 17, 2013 at 02:59:24PM +0800, Bob Liu wrote:
>> > Mel mentioned several problems about zswap/zbud in thread "[PATCH v6
>> > 0/5] zram/zsmalloc promotion".
>> >
>> > Like "it's clunky as hell and the layering between zswap and zbud is
>> > twisty" and "I think I brought up its stalling behaviour during review
>> > when it was being merged. It would have been preferable if writeback
>> > could be initiated in batches and then waited on at the very least..
>> >  It's worse that it uses _swap_writepage directly instead of going
>> > through a writepage ops.  It would have been better if zbud pages
>> > existed on the LRU and written back with an address space ops and
>> > properly handled asynchonous writeback."
>> >
>> > So I think it would be better if we can address those issues at first
>> > and it would be easier to address these issues before adding more new
>> > features. Welcome any ideas.
>>
>> I just had an idea this afternoon to potentially kill both these birds with one
>> stone: Replace the rbtree in zswap with an address_space.
>>
>> Each swap type would have its own page_tree to organize the compressed objects
>> by type and offset (radix tree is more suited for this anyway) and a_ops that
>> could be called by shrink_page_list() (writepage) or the migration code
>> (migratepage).
>>
>> Then zbud pages could be put on the normal LRU list, maybe at the beginning of
>> the inactive LRU so they would live for another cycle through the list, then be
>> reclaimed in the normal way with the mapping->a_ops->writepage() pointing to a
>> zswap_writepage() function that would decompress the pages and call
>> __swap_writepage() on them.
>
> How exactly the address space can be used here? Do you want to point to
> zbud pages in address_space.page_tree? If yes then which index should be
> used?
>

I didn't get the point neither. I think introduce address_space is enough.
1. zbud.c:
static struct address_space_operations zbud_aops = {
.writepage= zswap_write_page,
};
struct address_space zbud_space = {
.a_ops = &zbud_aops,
};

zbud_alloc() {
zbud_page = alloc_page();
zbud_page->mapping = (struct address_space *)&zbud_space;
set_page_private(page, (unsigned long)pool);
lru_add_anon(zbud_page);
}

2. zswap.c
static int zswap_writepage(struct page *page, struct writeback_control *wbc)
{
handle = encode_handle(page_address(page), FIRST));
zswap_writeback_entry(pool, handle);

handle = encode_handle(page_address(page), LAST));
zswap_writeback_entry(pool, handle);
}

Of course it may need lots of work for core MM subsystem can maintain
zbud pages.
But in this way, we can get rid of the clunky reclaiming layer and
integrate zswap closely with core MM subsystem which knows better how
many zbud pages can be used and when should trigger the zbud pages
reclaim.

-- 
Regards,
--Bob
