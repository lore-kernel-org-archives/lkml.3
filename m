Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208Ab3H2U3a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 16:29:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45233 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659Ab3H2U33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 16:29:29 -0400
Date: Thu, 29 Aug 2013 16:29:24 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tomoki Sekiyama <tomoki.sekiyama@hds.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, seiji.aguchi@hds.com,
        majianpeng@gmail.com
Subject: Re: [PATCH] elevator: Fix a race in elevator switching and md device
 initialization
Message-ID: <20130829202924.GD6171@redhat.com>
References: <20130826134515.2298.55571.stgit@outback>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130826134515.2298.55571.stgit@outback>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 09:45:15AM -0400, Tomoki Sekiyama wrote:
> The soft lockup below happes at the boot time of the system using dm
> multipath and automated elevator switching udev rules.
> 
> [  356.127001] BUG: soft lockup - CPU#3 stuck for 22s! [sh:483]
> [  356.127001] RIP: 0010:[<ffffffff81072a7d>]  [<ffffffff81072a7d>] lock_timer_base.isra.35+0x1d/0x50
> ...
> [  356.127001] Call Trace:
> [  356.127001]  [<ffffffff81073810>] try_to_del_timer_sync+0x20/0x70
> [  356.127001]  [<ffffffff8118b08a>] ? kmem_cache_alloc_node_trace+0x20a/0x230
> [  356.127001]  [<ffffffff810738b2>] del_timer_sync+0x52/0x60
> [  356.127001]  [<ffffffff812ece22>] cfq_exit_queue+0x32/0xf0
> [  356.127001]  [<ffffffff812c98df>] elevator_exit+0x2f/0x50
> [  356.127001]  [<ffffffff812c9f21>] elevator_change+0xf1/0x1c0
> [  356.127001]  [<ffffffff812caa50>] elv_iosched_store+0x20/0x50
> [  356.127001]  [<ffffffff812d1d09>] queue_attr_store+0x59/0xb0
> [  356.127001]  [<ffffffff812143f6>] sysfs_write_file+0xc6/0x140
> [  356.127001]  [<ffffffff811a326d>] vfs_write+0xbd/0x1e0
> [  356.127001]  [<ffffffff811a3ca9>] SyS_write+0x49/0xa0
> [  356.127001]  [<ffffffff8164e899>] system_call_fastpath+0x16/0x1b
> 
> This is caused by a race between md device initialization and sysfs knob
> to switch the scheduler.

I think we can also improve changelog a bit. So IIUC, softlockup 
happens because one thread called del_timer_sync() on a timer which
was not even initilized. Timer initialization should have happened
in cfq_init_queue() using init_timer(). But before init_timer()
could be called, elevator switch path called del_timer_sync().

del_timer_sync() in turn calls lock_timer_base() which will loop
infinitely if timer->base == NULL. And because we have not called
init_timer() yet, I am assuming timer->base is null?

Is this right analysis? If yes, then this patch should most likely
fix following bz.

https://bugzilla.redhat.com/show_bug.cgi?id=902012

I had concluded that some how timer->base is NULL but could not understand
how come timer base is NULL when we have called init_timer() on it.

Thanks
Vivek
