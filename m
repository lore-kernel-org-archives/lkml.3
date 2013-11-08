Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671Ab3KHJVB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 04:21:01 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:34656 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab3KHJUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 04:20:54 -0500
Date: Fri, 8 Nov 2013 01:21:06 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Kleikamp <dave.kleikamp@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Jens Axboe <axboe@kernel.dk>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zach Brown <zab@zabbo.net>, Olof Johansson <olof@lixom.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: manual merge of the block tree with the  tree
Message-ID: <20131108092106.GA30271@kmo-pixel>
References: <20131108125307.613427c04a7527c4359e6443@canb.auug.org.au>
 <20131108020805.GI3842@kmo>
 <527C4D35.8000907@oracle.com>
 <20131108073324.GA31662@infradead.org>
 <20131108073959.GA17807@kmo-pixel>
 <20131108074445.GA11595@infradead.org>
 <20131108075617.GB17807@kmo-pixel>
 <20131108080221.GA31866@infradead.org>
 <20131108081737.GA27885@kmo-pixel>
 <20131108083251.GA20121@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131108083251.GA20121@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 08, 2013 at 12:32:51AM -0800, Christoph Hellwig wrote:
> On Fri, Nov 08, 2013 at 12:17:37AM -0800, Kent Overstreet wrote:
> > The core issue isn't whether the IO is going to a block based filesystem
> > (but thanks for pointing out that that's not necessarily true!) but
> > whether we want to work with pinned pages or not. If pinned pages are ok
> > for everything, then bios as a common interface work - likely evolving
> > them a bit to be more general (it's just bi_bdev and bi_sector that's
> > actually block specific) - and IMO that would be far preferable to this
> > abstraction layer.
> > 
> > If OTOH we need a common interface that's also for places where we can't
> > afford the overhead of pinning user pages - that's a different story,
> > and maybe we do need all this infrastructure then. That's why I'm asking
> > about the stuff you meantioned, I'm honestly not sure.
> 
> For both of them we will deal with kernel-allocated pages that are never
> mapped to userspace.  This is likely to be true for all the consumers
> of in-kernel aio/dio as the existing interfaces handle user pages just
> fine.

Ok, that's good to know.

> > What I'm working towards though is a clean separation between buffered
> > and direct code paths, so that buffered IO can continue work with iovs
> > and for O_DIRECT the first thing you do is fill out a bio with pinned
> > pages and send it down to filesystem code or wherever it's going to go.
> 
> I don't think pushing bios above the fs interface is a good idea. Note
> that the iovecs come from userspace for the user pages cases, so there
> is little we can do about that, and non-bio based direct I/O
> implementations generally work directly at just that level and never
> even touch the direct-io.c code.

Bios can point to userspage pages just fine (and they do today for DIO
to block devices/block based filesystems today). Don't think of bios as
"block device IOs", just think of them as the equivalent of an iovec +
iov_iter except instead of (potentially userspace) pointers you have
page pointers. That's the core part of what they do (and even if we
don't standardize on bios for that we should standardize on _something_
for that functionality).

Here's the helper function I wrote for my dio rewrite - it should really
take an iov_iter instead of uaddr and len, but user iovec -> bio is the
easy bit:

http://evilpiepirate.org/git/linux-bcache.git/commit/?h=block_stuff&id=4462c03167767c656986afaf981f891705fd5d3b

> If you want to redo the ->direct_IO address_space operation and
> generic_file_direct_write and the direct I/O side of
> generic_file_aio_read (both of which aren't anywhere near as generic as
> the name claims) I'm all for it, but it really won't affect the consumer
> of the in-kernel aio/dio code.

I'm skeptical, but I'm way too tired to make good arguments and this
touches on too much code that I'm less familiar with.

also the flow of control in this code is such a goddamn clusterfuck I
don't even know what to say.

I'll dig more into the ecryptfs and target aio stuff tomorrow though.

> > That make sense? I can show you more concretely what I'm working on if
> > you want. Or if I'm full of crap and this is useless for what you guys
> > want I'm sure you'll let me know :)
> 
> It sounds interesting, but also a little confusing at this point, at
> least from the non-block side of view.

Zack, you want to chime in? He was involved in the discussion yesterday,
he might be able to explain this stuff better than I.
