Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751306AbaFXDZ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 23:25:29 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:57589 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbaFXDZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 23:25:28 -0400
Date: Mon, 23 Jun 2014 23:25:21 -0400
From: Tejun Heo <tj@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Austin Schuh <austin@peloton-tech.com>, xfs <xfs@oss.sgi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: On-stack work item completion race? (was Re: XFS crash?)
Message-ID: <20140624032521.GA12164@htj.dyndns.org>
References: <CANGgnMb=2dYGQO4K36pQ9LEb8E4rT6S_VskLF+n=ndd0_kJr_g@mail.gmail.com>
 <CANGgnMa80WwQ8zSkL52yYegmQURVQeZiBFv41=FQXMZJ_NaEDw@mail.gmail.com>
 <20140513034647.GA5421@dastard>
 <CANGgnMZ0q9uE3NHj2i0SBK1d0vdKLx7QBJeFNb+YwP-5EAmejQ@mail.gmail.com>
 <20140513063943.GQ26353@dastard>
 <CANGgnMYn++1++UyX+D2d9GxPxtytpQJv0ThFwdxM-yX7xDWqiA@mail.gmail.com>
 <20140513090321.GR26353@dastard>
 <CANGgnMZqQc_NeaDpO_aX+bndmHrQ9VWo9mkfxhPBkRD-J=N6sQ@mail.gmail.com>
 <CANGgnMZ8OwzfBj5m9H7c6q2yahGhU7oFZLsJfVxnWoqZExkZmQ@mail.gmail.com>
 <20140624030240.GB9508@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140624030240.GB9508@dastard>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Jun 24, 2014 at 01:02:40PM +1000, Dave Chinner wrote:
> start_flush_work() is effectively a special queue_work()
> implementation, so if if it's not safe to call complete() from the
> workqueue as the above patch implies then this code has the same
> problem.
> 
> Tejun - is this "do it yourself completion" a known issue w.r.t.
> workqueues? I can't find any documentation that says "don't do
> that" so...?

It's more complex than using flush_work() but there's nothing
fundamentally wrong with it.  A work item is completely unlinked
before its execution starts.  It's safe to free the work item once its
work function started, whether through kfree() or returning.

One difference between flush_work() and manual completion would be
that if the work item gets requeued, flush_work() would wait for the
queued one to finish but given the work item is one-shot this doesn't
make any difference.

I can see no reason why manual completion would behave differently
from flush_work() in this case.

> As I understand it, what then happens is that the workqueue code
> grabs another kworker thread and runs the next work item in it's
> queue. IOWs, work items can block, but doing that does not prevent
> execution of other work items queued on other work queues or even on
> the same work queue. Tejun, did I get that correct?

Yes, as long as the workqueue is under its @max_active limit and has
access to an existing kworker or can create a new one, it'll start
executing the next work item immediately; however, the guaranteed
level of concurrency is 1 even for WQ_RECLAIM workqueues.  IOW, the
work items queued on a workqueue must be able to make forward progress
with single work item if the work items are being depended upon for
memory reclaim.

> Hence the work on the xfs-data queue will block until another
> kworker processes the item on the xfs-alloc-wq which means progress
> is made and the inode gets unlocked. Then the kworker for the work
> on the xfs-data queue will get the lock, complete it's work and
> everything has resolved itself.

As long as a WQ_RECLAIM workqueue dosen't depend upon itself,
forward-progress is guaranteed.

Thanks.

-- 
tejun
