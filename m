Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944Ab3H2SnN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 14:43:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8473 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756462Ab3H2SnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 14:43:10 -0400
Date: Thu, 29 Aug 2013 14:43:04 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tomoki Sekiyama <tomoki.sekiyama@hds.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, seiji.aguchi@hds.com,
        majianpeng@gmail.com, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] elevator: Fix a race in elevator switching and md device
 initialization
Message-ID: <20130829184304.GC6171@redhat.com>
References: <20130826134515.2298.55571.stgit@outback>
 <20130829183310.GB6171@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130829183310.GB6171@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 02:33:10PM -0400, Vivek Goyal wrote:
> On Mon, Aug 26, 2013 at 09:45:15AM -0400, Tomoki Sekiyama wrote:
> > The soft lockup below happes at the boot time of the system using dm
> > multipath and automated elevator switching udev rules.
> > 
> > [  356.127001] BUG: soft lockup - CPU#3 stuck for 22s! [sh:483]
> > [  356.127001] RIP: 0010:[<ffffffff81072a7d>]  [<ffffffff81072a7d>] lock_timer_base.isra.35+0x1d/0x50
> > ...
> > [  356.127001] Call Trace:
> > [  356.127001]  [<ffffffff81073810>] try_to_del_timer_sync+0x20/0x70
> > [  356.127001]  [<ffffffff8118b08a>] ? kmem_cache_alloc_node_trace+0x20a/0x230
> > [  356.127001]  [<ffffffff810738b2>] del_timer_sync+0x52/0x60
> > [  356.127001]  [<ffffffff812ece22>] cfq_exit_queue+0x32/0xf0
> > [  356.127001]  [<ffffffff812c98df>] elevator_exit+0x2f/0x50
> > [  356.127001]  [<ffffffff812c9f21>] elevator_change+0xf1/0x1c0
> > [  356.127001]  [<ffffffff812caa50>] elv_iosched_store+0x20/0x50
> > [  356.127001]  [<ffffffff812d1d09>] queue_attr_store+0x59/0xb0
> > [  356.127001]  [<ffffffff812143f6>] sysfs_write_file+0xc6/0x140
> > [  356.127001]  [<ffffffff811a326d>] vfs_write+0xbd/0x1e0
> > [  356.127001]  [<ffffffff811a3ca9>] SyS_write+0x49/0xa0
> > [  356.127001]  [<ffffffff8164e899>] system_call_fastpath+0x16/0x1b
> > 
> 
> Tokomi, 
> 
> As you noticed, there is a fedora bug open with similar signature. May
> be this patch will fix that issue also.
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=902012
> 
> 
> > This is caused by a race between md device initialization and sysfs knob
> > to switch the scheduler.
> > 
> > * multipathd:
> >  SyS_ioctl -> do_vfs_ioctl -> dm_ctl_ioctl -> ctl_ioctl ->  table_load
> >   -> dm_setup_md_queue -> blk_init_allocated_queue -> elevator_init:
> > 
> >     q->elevator = elevator_alloc(q, e); // not yet initialized
> > 
> > * sh -c 'echo deadline > /sys/$DEVPATH/queue/scheduler'
> >  SyS_write -> vfs_write -> sysfs_write_file -> queue_attr_store
> >      ( mutex_lock(&q->sysfs_lock) here. )
> >   -> elv_iosched_store -> elevator_change:
> > 
> >   elevator_exit(old); // try to de-init uninitialized elevator and hang up
> > 

If problem in this case is that we are trying to exit() the elevator
which has not been properly initialized, then we should not attach
the elevator to the queue yet.

In cfq_init_queue(), can we move following code towards the end of
function.

        spin_lock_irq(q->queue_lock);
        q->elevator = eq;
        spin_unlock_irq(q->queue_lock);

So till elevator is initialized, we will not attach it to queue and 
elevator_switch() will return as it will not find a valid elevator
on the queue.

elevator_change() {
	        if (!q->elevator)
                return -ENXIO;
}

Thanks
Vivek
