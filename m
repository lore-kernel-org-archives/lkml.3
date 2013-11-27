Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759738Ab3K0B2z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:28:55 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:44782 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757366Ab3K0B2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 20:28:51 -0500
MIME-Version: 1.0
In-Reply-To: <20131125180030.GA23396@cerebellum.variantweb.net>
References: <1384976973-32722-1-git-send-email-ddstreet@ieee.org>
 <20131122172916.GB6477@cerebellum.variantweb.net> <20131125180030.GA23396@cerebellum.variantweb.net>
From: Dan Streetman <ddstreet@ieee.org>
Date: Tue, 26 Nov 2013 20:28:29 -0500
X-Google-Sender-Auth: Q5hCx7OPQZPTwlRnu2g1Dg6VSLA
Message-ID: <CALZtONCW1Gxa-aT25Yf7PP6R=sW_6KBu5XPKoU75pJgvmAknbg@mail.gmail.com>
Subject: Re: [PATCH v2] mm/zswap: change zswap to writethrough cache
To: Seth Jennings <sjennings@variantweb.net>
Cc: linux-mm@kvack.org, linux-kernel <linux-kernel@vger.kernel.org>,
        Bob Liu <bob.liu@oracle.com>, Minchan Kim <minchan@kernel.org>,
        Weijie Yang <weijie.yang@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 1:00 PM, Seth Jennings <sjennings@variantweb.net> wrote:
> On Fri, Nov 22, 2013 at 11:29:16AM -0600, Seth Jennings wrote:
>> On Wed, Nov 20, 2013 at 02:49:33PM -0500, Dan Streetman wrote:
>> > Currently, zswap is writeback cache; stored pages are not sent
>> > to swap disk, and when zswap wants to evict old pages it must
>> > first write them back to swap cache/disk manually.  This avoids
>> > swap out disk I/O up front, but only moves that disk I/O to
>> > the writeback case (for pages that are evicted), and adds the
>> > overhead of having to uncompress the evicted pages, and adds the
>> > need for an additional free page (to store the uncompressed page)
>> > at a time of likely high memory pressure.  Additionally, being
>> > writeback adds complexity to zswap by having to perform the
>> > writeback on page eviction.
>> >
>> > This changes zswap to writethrough cache by enabling
>> > frontswap_writethrough() before registering, so that any
>> > successful page store will also be written to swap disk.  All the
>> > writeback code is removed since it is no longer needed, and the
>> > only operation during a page eviction is now to remove the entry
>> > from the tree and free it.
>>
>> I like it.  It gets rid of a lot of nasty writeback code in zswap.
>>
>> I'll have to test before I ack, hopefully by the end of the day.
>>
>> Yes, this will increase writes to the swap device over the delayed
>> writeback approach.  I think it is a good thing though.  I think it
>> makes the difference between zswap and zram, both in operation and in
>> application, more apparent. Zram is the better choice for embedded where
>> write wear is a concern, and zswap being better if you need more
>> flexibility to dynamically manage the compressed pool.
>
> One thing I realized while doing my testing was that making zswap
> writethrough also impacts synchronous reclaim.  Zswap, as it is now,
> makes the swapcache page clean during swap_writepage() which allows
> shrink_page_list() to immediately reclaim it.  Making zswap writethrough
> eliminates this advantage and swapcache pages must be scanned again
> before they can be reclaimed, as is the case with normal swapping.

Yep, I thought about that as well, and it is true, but only while
zswap is not full.  With writeback, once zswap fills up, page stores
will frequently have to reclaim pages by writing compressed pages to
disk.  With writethrough, the zbud reclaim should be quick, as it only
has to evict the pages, not write them to disk.  So I think basically
writeback should speed up (compared to no-zswap case) swap_writepage()
while zswap is not full, but (theoretically) slow it down (compared to
no-zswap case) while zswap is full, while writethrough should slow
down swap_writepage() slightly (the time it takes to compress/store
the page) but consistently, almost the same amount before it's full vs
when it's full.  Theoretically :-)  Definitely something to think
about and test for.

Another idea that I was going to bring up after/if writethrough was
added, was to move the page compression out of the store, maybe using
a mempool and worker thread (or something), so that the zswap store is
very fast.  Testing would of course be needed to see if that really
improved things or not...





>
> Just something I am thinking about.
>
> Seth
