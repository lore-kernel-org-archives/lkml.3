Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751645AbaFDUQk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 16:16:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42992 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944AbaFDUQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 16:16:39 -0400
Date: Wed, 4 Jun 2014 22:16:33 +0200
From: Jan Kara <jack@suse.cz>
To: Daniel Phillips <d.phillips@partner.samsung.com>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [RFC][PATCH 1/2] Add a super operation for writeback
Message-ID: <20140604201633.GB22927@quack.suse.cz>
References: <538B9DEE.20800@phunq.net>
 <20140602031526.GS14410@dastard>
 <538CD855.90804@phunq.net>
 <20140603033322.GA14410@dastard>
 <538D72B7.3010700@phunq.net>
 <20140603075209.GD14410@dastard>
 <20140603140531.GB30706@quack.suse.cz>
 <20140603141444.GA21273@infradead.org>
 <20140603152155.GD30706@quack.suse.cz>
 <19f0e788-f6f2-4547-9cb2-a74d70d75cd0@partner.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f0e788-f6f2-4547-9cb2-a74d70d75cd0@partner.samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 03-06-14 15:37:39, Daniel Phillips wrote:
> On Tuesday, June 3, 2014 8:21:55 AM PDT, Jan Kara wrote:
> >On Tue 03-06-14 07:14:44, Christoph Hellwig wrote:
> >>On Tue, Jun 03, 2014 at 04:05:31PM +0200, Jan Kara wrote:
> >And I agree we went for per-bdi
> >flushing to avoid two threads congesting a single device leading to
> >suboptimal IO patterns during background writeback.
> 
> A proposal is on the table to implement s_ops->writeback() as a per-sb
> operation in such a way that nothing changes in the current per-inode path.
> Good or bad approach?
  Having s_ops->writeback() is fine. But I just hate how you hook in that
callback into the writeback code (and Dave has expressed similar concerns).
The way you hook it up, filesystem still has to have one inode in the dirty
list so that __writeback_inodes_wb() can find that inode, get superblock
from it and ask for writeback to be done via callback. That's really ugly
and no-go for me.

> >So currently I'm convinced we want to go for per-sb dirty tracking. That
> >also makes some speedups in that code noticeably simpler. I'm not
> convinced
> >about the per-sb flushing thread - if we don't regress the multiple sb on
> >bdi case when we just let the threads from different superblocks contend
> >for IO, then that would be a natural thing to do. But once we have to
> >introduce some synchronization between threads to avoid regressions, I
> >think it might be easier to just stay with per-bdi thread which switches
> >between superblocks.
> 
> Could you elaborate on the means of switching between superblocks?  Do
> you mean a new fs-writeback path just for data=journal class filesystems,
> or are you suggesting changing the way all filesystems are driven?
  So I suggest changing the way all filesystems are driven to a per-sb one.
That makes sense for other reasons as well and allows clean incorporation
of your writeback callback (either a fs will use generic callback which
would do what generic writeback code does now, only with per-sb dirty lists
instead of current per-bdi ones, or the fs can do its own stuff). I can
write something (the switch isn't really that complex) but it will need
quite some testing to verify we don't regress somewhere...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
