Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751329Ab3I0KQo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 06:16:44 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:13700 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab3I0KQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 06:16:41 -0400
X-AuditID: cbfec7f4-b7f0a6d000007b1b-24-52455b088df7
Message-id: <52455B05.1010603@samsung.com>
Date: Fri, 27 Sep 2013 12:16:37 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
MIME-version: 1.0
Newsgroups: gmane.linux.kernel.mm,gmane.linux.kernel
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Bob Liu <bob.liu@oracle.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Dave Hansen <dave.hansen@intel.com>, Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH v2 0/5] mm: migrate zbud pages
References: <1378889944-23192-1-git-send-email-k.kozlowski@samsung.com>
 <5237FDCC.5010109@oracle.com> <20130923220757.GC16191@variantweb.net>
 <524318DE.7070106@samsung.com> <20130925215744.GA25852@variantweb.net>
In-reply-to: <20130925215744.GA25852@variantweb.net>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOLMWRmVeSWpSXmKPExsVy+t/xq7oc0a5BBo+vCFjMWb+GzWLjjPWs
	Fl2nprJYfHr5gNHi9QtDi7NNb9gtLu+aw2Zxb81/Vou1R+6yW0x+94zRYtnX9+wWh/atYnfg
	8Vi85yWTx6ZVnWwemz5NYvc4MeM3i8eDQ5tZPD4+vcXi0bdlFaPH5tPVHp83yQVwRnHZpKTm
	ZJalFunbJXBlvPnbyl6wSrti/pt2xgbGOUpdjJwcEgImEru62lghbDGJC/fWs3UxcnEICSxl
	lFjd9JkZwvnMKPFr7lomkCpeAS2JMytfgHWwCKhKPHt+gwXEZgOadGzJZ0YQW1QgQuLP6X2s
	EPWCEj8m3wOr4QOqmbi7lxnEFhHQl+ievQJsAbPAWmaJD/Ovs4MkhAWMJO7uPswOsfkGo8T/
	GyfZQBKcQN2PGv+AbWAW0JHY3zqNDcKWl9i85i3zBEbBWUgWzkJSNgtJ2QJG5lWMoqmlyQXF
	Sem5hnrFibnFpXnpesn5uZsYIZH1ZQfj4mNWhxgFOBiVeHgzslyChFgTy4orcw8xSnAwK4nw
	LvB0DRLiTUmsrEotyo8vKs1JLT7EyMTBKdXAmHiaY0lzxdz5PdMFu+0P+E/9y38k3l5m5/st
	/PYzN3I9dJ+kH9Bi7dJ9Y5mb+fO+TzLBVSav9OIN3k7vfe5sPnVe3Q3d0rzvc/paAneoVReJ
	tl05Pkm8bMUi035b7yY2fc7+fY+SL6hPuFTF4ps+52/lgSZF05cl33ht9G/pMmjZXzcuazuh
	xFKckWioxVxUnAgAHVNN7YoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2013 11:57 PM, Seth Jennings wrote:
> On Wed, Sep 25, 2013 at 07:09:50PM +0200, Tomasz Stanislawski wrote:
>>> I just had an idea this afternoon to potentially kill both these birds with one
>>> stone: Replace the rbtree in zswap with an address_space.
>>>
>>> Each swap type would have its own page_tree to organize the compressed objects
>>> by type and offset (radix tree is more suited for this anyway) and a_ops that
>>> could be called by shrink_page_list() (writepage) or the migration code
>>> (migratepage).
>>>
>>> Then zbud pages could be put on the normal LRU list, maybe at the beginning of
>>> the inactive LRU so they would live for another cycle through the list, then be
>>> reclaimed in the normal way with the mapping->a_ops->writepage() pointing to a
>>> zswap_writepage() function that would decompress the pages and call
>>> __swap_writepage() on them.
>>>
>>> This might actually do away with the explicit pool size too as the compressed
>>> pool pages wouldn't be outside the control of the MM anymore.
>>>
>>> I'm just starting to explore this but I think it has promise.
>>>
>>> Seth
>>>
>>
>> Hi Seth,
>> There is a problem with the proposed idea.
>> The radix tree used 'struct address_space' is a part of
>> a bigger data structure.
>> The radix tree is used to translate an offset to a page.
>> That is ok for zswap. But struct page has a field named 'index'.
>> The MM assumes that this index is an offset in radix tree
>> where one can find the page. A lot is done by MM to sustain
>> this consistency.
> 
> Yes, this is how it is for page cache pages.  However, the MM is able to
> work differently with anonymous pages.  In the case of an anonymous
> page, the mapping field points to an anon_vma struct, or, if ksm in
> enabled and dedup'ing the page, a private ksm tracking structure.  If
> the anonymous page is fully unmapped and resides only in the swap cache,
> the page mapping is NULL.  So there is precedent for the fields to mean
> other things.

Hi Seth,
You are right that page->mapping is NULL for pages in swap_cache but
page_mapping() is not NULL in such a case. The mapping is taken from
struct address_space swapper_spaces[]. It is still an address space,
and it should preserve constraints for struct address_space.
The same happen for page->index and page_index().

> 
> The question is how to mark and identify zbud pages among the other page
> types that will be on the LRU.  There are many ways.  The question is
> what is the best and most acceptable way.
> 

If you consider hacking I have some idea how address_space could utilized for ZBUD.
One solution whould be using tags in a radix tree. Every entry in a radix tree
can have a few bits assigned to it. Currently 3 bits are supported:

>From include/linux/fs.h
#define PAGECACHE_TAG_DIRTY  0
#define PAGECACHE_TAG_WRITEBACK      1
#define PAGECACHE_TAG_TOWRITE        2

You could add a new bit or utilize one of existing ones.

The other idea is use a trick from a RB trees and scatter-gather lists.
I mean using the last bits of pointers to keep some metadata.
Values of 'struct page *' variables are aligned to a pointer alignment which is
4 for 32-bit CPUs and 8 for 64-bit ones (not sure). This means that one could
could use the last bit of page pointer in a radix tree to track if a swap entry
refers to a lower or a higher part of a ZBUD page.
I think it is a serious hacking/obfuscation but it may work with the minimal
amount of changes to MM. Adding only (x&~3) while extracting page pointer is
probably enough.

What do you think about this idea?

>>
>> In case of zbud, there are two swap offset pointing to
>> the same page. There might be more if zsmalloc is used.
>> What is worse it is possible that one swap entry could
>> point to data that cross a page boundary.
> 
> We just won't set page->index since it doesn't have a good meaning in
> our case.  Swap cache pages also don't use index, although is seems to
> me that they could since there is a 1:1 mapping of a swap cache page to
> a swap offset and the index field isn't being used for anything else.
> But I digress...

OK.

> 
>>
>> Of course, one could try to modify MM to support
>> multiple mapping of a page in the radix tree.
>> But I think that MM guys will consider this as a hack
>> and they will not accept it.
> 
> Yes, it will require some changes to the MM to handle zbud pages on the
> LRU.  I'm thinking that it won't be too intrusive, depending on how we
> choose to mark zbud pages.
> 

Anyway, I think that zswap should use two index engines.
I mean index in Data Base meaning.
One index is used to translate swap_entry to compressed page.
And another one to be used by reclaim and migration by MM,
probably address_space is a best choice.
Zbud would responsible for keeping consistency
between mentioned indexes.

Regards,
Tomasz Stanislawski

> Seth
> 
>>
>> Regards,
>> Tomasz Stanislawski
>>
>>
>>> --
>>> To unsubscribe, send a message with 'unsubscribe linux-mm' in
>>> the body to majordomo@kvack.org.  For more info on Linux MM,
>>> see: http://www.linux-mm.org/ .
>>> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>>>
>>
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 

