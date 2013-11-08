Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993Ab3KHR4r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 12:56:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47554 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757426Ab3KHR4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 12:56:45 -0500
Date: Fri, 8 Nov 2013 09:56:08 -0800
From: Zach Brown <zab@redhat.com>
To: Kent Overstreet <kmo@daterainc.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Jens Axboe <axboe@kernel.dk>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: manual merge of the block tree with the  tree
Message-ID: <20131108175608.GK6710@lenny.home.zabbo.net>
References: <20131108020805.GI3842@kmo>
 <527C4D35.8000907@oracle.com>
 <20131108073324.GA31662@infradead.org>
 <20131108073959.GA17807@kmo-pixel>
 <20131108074445.GA11595@infradead.org>
 <20131108075617.GB17807@kmo-pixel>
 <20131108080221.GA31866@infradead.org>
 <20131108081737.GA27885@kmo-pixel>
 <20131108083251.GA20121@infradead.org>
 <20131108092106.GA30271@kmo-pixel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131108092106.GA30271@kmo-pixel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > That make sense? I can show you more concretely what I'm working on if
> > > you want. Or if I'm full of crap and this is useless for what you guys
> > > want I'm sure you'll let me know :)
> > 
> > It sounds interesting, but also a little confusing at this point, at
> > least from the non-block side of view.
> 
> Zach, you want to chime in? He was involved in the discussion yesterday,
> he might be able to explain this stuff better than I.

I can try.  I may not do the *best* job because I've been on the
periphery of most of this since I left the proof of concept back at
Oracle :).

The first part is passing in pages instead of mapped addresses.  That's
where the iov_iter argument came from.  A ham-fisted proof of concept to
try to abstract iterating over any old type of memory.  But it's not
*really* abstract because dio magically knows (look for gross
iov_iter_has_iovec() callers) whether the memory is in iovecs or bio
pages when its verifying alignment, pinning or not, etc.  In the end
it's little more than syntactic sugar to try and pretend that two
interfaces are one.

For expedience, this iov_iter approach used the loop's bio to store the
pages in the iov_iter rather than translating the bio's pages to a page
array in the iov_iter.

So the first part of what I think Kent is picturing is to take that to
its logical conclusion and have the caller describe the io memory and
offset with a bio instead of explicit address and offset arguments.
This way dio can do nice bio management operations to kick off its
device bios rather than having to clumsily build them from either
incoming pages or mapped user addresses that are hidden in iov_iter.

I'm imagining cutting the current dio up in to two phases.  One that
pins user pages and puts them in bios and one that maps those file bios
to device bios and submits them.  Then the fop method becomes the second
phase so that loop can call it with its file bios.  Call it
->submit_file_bio() instead of ->do_direct_IO(), maybe?

The other part of this series that isn't getting as much attention,
though, is async submission and completion.  This patch introduces a
weird in-kernel aio submission interface that adds special cases to aio.
In this new bio world order we could get rid of that complication by
relying on the bio's ->bi_end_io() for completion.

I suppose a high level view of this strategy is to move more towards a
stack where layers have matching inputs and outputs.  If both dio and
loop take bios as input and translate them into submitted output bios
then the stacking becomes more natural.

That's the blue sky fantasy anyway.  There's a lot of detail being
glossed over.  I want to see what the patches look like.

- z
