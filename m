Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870AbaHODfV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 23:35:21 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:23771 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754265AbaHODfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 23:35:19 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtUGABx/7VN5LDJ8/2dsb2JhbABZgw1TV68QAQEBAQEBBp5Uh1EBgRIXd4QEAQU6HCMQCAMYCSUPBSUDIROIQcU+FxiFZIlQB4RMBY8KhjmCOYFugk6BM5NMg24rL4JPAQEB
Date: Fri, 15 Aug 2014 13:34:48 +1000
From: Dave Chinner <david@fromorbit.com>
To: Waiman Long <waiman.long@hp.com>
Cc: Jason Low <jason.low2@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Davidlohr Bueso <davidlohr@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH 2/7] locking/rwsem: more aggressive use of optimistic
 spinning
Message-ID: <20140815033447.GJ20518@dastard>
References: <1407119782-41119-1-git-send-email-Waiman.Long@hp.com>
 <1407119782-41119-3-git-send-email-Waiman.Long@hp.com>
 <1407125450.4710.38.camel@j-VirtualBox>
 <53DFAA53.4010003@hp.com>
 <20140813055153.GD20518@dastard>
 <53EB9522.2070804@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53EB9522.2070804@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 12:41:06PM -0400, Waiman Long wrote:
> On 08/13/2014 01:51 AM, Dave Chinner wrote:
> >On Mon, Aug 04, 2014 at 11:44:19AM -0400, Waiman Long wrote:
> >>On 08/04/2014 12:10 AM, Jason Low wrote:
> >>>On Sun, 2014-08-03 at 22:36 -0400, Waiman Long wrote:
> >>>>The rwsem_can_spin_on_owner() function currently allows optimistic
> >>>>spinning only if the owner field is defined and is running. That is
> >>>>too conservative as it will cause some tasks to miss the opportunity
> >>>>of doing spinning in case the owner hasn't been able to set the owner
> >>>>field in time or the lock has just become available.
> >>>>
> >>>>This patch enables more aggressive use of optimistic spinning by
> >>>>assuming that the lock is spinnable unless proved otherwise.
> >>>>
> >>>>Signed-off-by: Waiman Long<Waiman.Long@hp.com>
> >>>>---
> >>>>  kernel/locking/rwsem-xadd.c |    2 +-
> >>>>  1 files changed, 1 insertions(+), 1 deletions(-)
> >>>>
> >>>>diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
> >>>>index d058946..dce22b8 100644
> >>>>--- a/kernel/locking/rwsem-xadd.c
> >>>>+++ b/kernel/locking/rwsem-xadd.c
> >>>>@@ -285,7 +285,7 @@ static inline bool rwsem_try_write_lock_unqueued(struct rw_semaphore *sem)
> >>>>  static inline bool rwsem_can_spin_on_owner(struct rw_semaphore *sem)
> >>>>  {
> >>>>  	struct task_struct *owner;
> >>>>-	bool on_cpu = false;
> >>>>+	bool on_cpu = true;	/* Assume spinnable unless proved not to be */
> >>>Hi,
> >>>
> >>>So "on_cpu = true" was recently converted to "on_cpu = false" in order
> >>>to address issues such as a 5x performance regression in the xfs_repair
> >>>workload that was caused by the original rwsem optimistic spinning code.
> >>>
> >>>However, patch 4 in this patchset does address some of the problems with
> >>>spinning when there are readers. CC'ing Dave Chinner, who did the
> >>>testing with the xfs_repair workload.
> >>>
> >>This patch set enables proper reader spinning and so the problem
> >>that we see with xfs_repair workload should go away. I should have
> >>this patch after patch 4 to make it less confusing. BTW, patch 3 can
> >>significantly reduce spinlock contention in rwsem. So I believe the
> >>xfs_repair workload should run faster with this patch than both 3.15
> >>and 3.16.
> >I see lots of handwaving. I documented the test I ran when I
> >reported the problem so anyone with a 16p system and an SSD can
> >reproduce it. I don't have the bandwidth to keep track of the lunacy
> >of making locks scale these days - that's what you guys are doing.
> >
> >I gave you a simple, reliable workload that is extremely sensitive
> >to rwsem perturbations, so you should be adding it to your
> >regression tests rather than leaving it for others to notice you
> >screwed up....
> >
> >Cheers,
> >
> >Dave.
> 
> If you can send me a rwsem workload that I can use for testing
> purpose, it will be highly appreciated.

<create sparse vm image file of 500TB on ssd with XFS on it>
xfs_io -f -c "truncate 500t" -c "extsize 1m" /path/to/vm/image/file

<start 16p/16GB RAM vm with image file configured as:
-drive file=/path/to/vm/image/file,if=virtio,cache=none >

In vm:

download and build fsmark from here:

git://oss.sgi.com/dgc/fs_mark

download and install xfsprogs v3.2.1 from here:

git://oss.sgi.com/xfs/cmds/xfsprogs.git tags/v3.2.1

Setup up the target filesystem:

# mkfs.xfs -f -m "crc=1,finobt=1" /dev/vda
# mount -o logbsize=262144,nobarrier /dev/vda /mnt/scratch


Run:

# fs_mark  -D  10000  -S0  -n  50000  -s  0  -L  32 \
        -d  /mnt/scratch/0  -d  /mnt/scratch/1 \
        -d  /mnt/scratch/2  -d  /mnt/scratch/3 \
        -d  /mnt/scratch/4  -d  /mnt/scratch/5 \
        -d  /mnt/scratch/6  -d  /mnt/scratch/7 \
        -d  /mnt/scratch/8  -d  /mnt/scratch/9 \
        -d  /mnt/scratch/10  -d  /mnt/scratch/11 \
        -d  /mnt/scratch/12  -d  /mnt/scratch/13 \
        -d  /mnt/scratch/14  -d  /mnt/scratch/15 \

If you've got everything set up right, that should run at around
200-250,000 file creates/s. When finished, unmount and run:

# xfs_repair -o bhash=500000 /dev/vda

And that should spend quite a long while pounding on the mmap_sem
until the the userspace buffer cache stops growing.

I just ran the above on 3.16, saw this from perf:

  37.30%  [kernel]  [k] _raw_spin_unlock_irqrestore
   - _raw_spin_unlock_irqrestore
      - 62.00% rwsem_wake
         - call_rwsem_wake
            + 83.52% sys_mprotect
            + 16.23% __do_page_fault
      + 35.15% try_to_wake_up
      + 0.96% update_blocked_averages
      + 0.61% pagevec_lru_move_fn
-  23.35%  [kernel]  [k] _raw_spin_unlock_irq
   - _raw_spin_unlock_irq
      + 51.37% finish_task_switch
      + 39.37% rwsem_down_write_failed
      + 8.49% rwsem_down_read_failed
        0.62% run_timer_softirq
+   5.22%  [kernel]  [k] native_read_tsc
+   3.89%  [kernel]  [k] rwsem_down_write_failed
.....

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
