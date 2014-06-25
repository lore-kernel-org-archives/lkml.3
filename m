Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007AbaFYF4r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 01:56:47 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:50263 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754624AbaFYF4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 01:56:46 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhBFAMVjqlN5LEioPGdsb2JhbABagw2IUKMmBpk6AYEQFwQBAQEBODWEAwEBBAE6HCMFCwgDDgoJJQ8FJQMHGhOIOgfIVRcWhU2IQlcHhEMFmlCXQCuBMg
Date: Wed, 25 Jun 2014 15:56:41 +1000
From: Dave Chinner <david@fromorbit.com>
To: Tejun Heo <tj@kernel.org>
Cc: Austin Schuh <austin@peloton-tech.com>, xfs <xfs@oss.sgi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: On-stack work item completion race? (was Re: XFS crash?)
Message-ID: <20140625055641.GL9508@dastard>
References: <CANGgnMa80WwQ8zSkL52yYegmQURVQeZiBFv41=FQXMZJ_NaEDw@mail.gmail.com>
 <20140513034647.GA5421@dastard>
 <CANGgnMZ0q9uE3NHj2i0SBK1d0vdKLx7QBJeFNb+YwP-5EAmejQ@mail.gmail.com>
 <20140513063943.GQ26353@dastard>
 <CANGgnMYn++1++UyX+D2d9GxPxtytpQJv0ThFwdxM-yX7xDWqiA@mail.gmail.com>
 <20140513090321.GR26353@dastard>
 <CANGgnMZqQc_NeaDpO_aX+bndmHrQ9VWo9mkfxhPBkRD-J=N6sQ@mail.gmail.com>
 <CANGgnMZ8OwzfBj5m9H7c6q2yahGhU7oFZLsJfVxnWoqZExkZmQ@mail.gmail.com>
 <20140624030240.GB9508@dastard>
 <20140624032521.GA12164@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140624032521.GA12164@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 11:25:21PM -0400, Tejun Heo wrote:
> Hello,
> 
> On Tue, Jun 24, 2014 at 01:02:40PM +1000, Dave Chinner wrote:
> > As I understand it, what then happens is that the workqueue code
> > grabs another kworker thread and runs the next work item in it's
> > queue. IOWs, work items can block, but doing that does not prevent
> > execution of other work items queued on other work queues or even on
> > the same work queue. Tejun, did I get that correct?
> 
> Yes, as long as the workqueue is under its @max_active limit and has
> access to an existing kworker or can create a new one, it'll start
> executing the next work item immediately; however, the guaranteed
> level of concurrency is 1 even for WQ_RECLAIM workqueues.  IOW, the
> work items queued on a workqueue must be able to make forward progress
> with single work item if the work items are being depended upon for
> memory reclaim.

Hmmm - that's different from my understanding of what the original
behaviour WQ_MEM_RECLAIM gave us. i.e. that WQ_MEM_RECLAIM
workqueues had a rescuer thread created to guarantee that the
*workqueue* could make forward progress executing work in a
reclaim context.

The concept that the *work being executed* needs to guarantee
forwards progress is something I've never heard stated before.
That worries me a lot, especially with all the memory reclaim
problems that have surfaced in the past couple of months....

> As long as a WQ_RECLAIM workqueue dosen't depend upon itself,
> forward-progress is guaranteed.

I can't find any documentation that actually defines what
WQ_MEM_RECLAIM means, so I can't tell when or how this requirement
came about. If it's true, then I suspect most of the WQ_MEM_RECLAIM
workqueues in filesystems violate it. Can you point me at
documentation/commits/code describing the constraints of
WQ_MEM_RECLAIM and the reasons for it?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
