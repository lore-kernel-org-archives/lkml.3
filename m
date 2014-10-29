Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934230AbaJ2QRJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 12:17:09 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:49126 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932994AbaJ2QRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 12:17:06 -0400
Date: Wed, 29 Oct 2014 17:16:57 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: LKP <lkp@01.org>, linux-kernel@vger.kernel.org, oleg@redhat.com,
        ebiederm@xmission.com, davem@davemloft.net
Subject: [PATCH] netdev: Fix sleeping inside wait event
Message-ID: <20141029161657.GF3337@twins.programming.kicks-ass.net>
References: <20141028142541.GA19097@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141028142541.GA19097@wfg-t540p.sh.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 10:25:41PM +0800, Fengguang Wu wrote:
> [  122.247299] ------------[ cut here ]------------
> [  122.247328] WARNING: CPU: 0 PID: 61 at kernel/sched/core.c:7312 __might_sleep+0x50/0x249()
> [  122.247334] do not call blocking ops when !TASK_RUNNING; state=2 set at [<c106ffd9>] prepare_to_wait+0x3c/0x5f
> [  122.247339] Modules linked in:
> [  122.247349] CPU: 0 PID: 61 Comm: kworker/u2:1 Not tainted 3.18.0-rc2-00037-g24574709 #136
> [  122.247350] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [  122.247368] Workqueue: netns cleanup_net
> [  122.247377]  c1071d83 d2b83dd8 d2b83dac c15887b1 d2b83dc8 c104c4c6 00001c90 c1068ebf
> [  122.247383]  00000000 c17b67e3 0000026d d2b83de0 c104c508 00000009 d2b83dd8 c17b5d4b
> [  122.247388]  d2b83df4 d2b83e0c c1068ebf c17b5cec 00001c90 c17b5d4b 00000002 c106ffd9
> [  122.247389] Call Trace:
> [  122.247393]  [<c1071d83>] ? down_trylock+0x23/0x2c
> [  122.247402]  [<c15887b1>] dump_stack+0x16/0x18
> [  122.247413]  [<c104c4c6>] warn_slowpath_common+0x66/0x7d
> [  122.247416]  [<c1068ebf>] ? __might_sleep+0x50/0x249
> [  122.247419]  [<c104c508>] warn_slowpath_fmt+0x2b/0x2f
> [  122.247422]  [<c1068ebf>] __might_sleep+0x50/0x249
> [  122.247424]  [<c106ffd9>] ? prepare_to_wait+0x3c/0x5f
> [  122.247426]  [<c106ffd9>] ? prepare_to_wait+0x3c/0x5f
> [  122.247432]  [<c158c364>] mutex_lock_nested+0x23/0x347
> [  122.247436]  [<c1075105>] ? trace_hardirqs_on+0xb/0xd
> [  122.247439]  [<c158eb0c>] ? _raw_spin_unlock_irqrestore+0x66/0x78
> [  122.247445]  [<c1570e10>] rtnl_lock+0x14/0x16
> [  122.247449]  [<c156516b>] default_device_exit_batch+0x54/0xf3
> [  122.247452]  [<c1570e1f>] ? rtnl_unlock+0xd/0xf
> [  122.247454]  [<c1070233>] ? __wake_up_sync+0x12/0x12
> [  122.247461]  [<c155e35d>] ops_exit_list+0x20/0x40
> [  122.247464]  [<c155ec96>] cleanup_net+0xbe/0x140
> [  122.247473]  [<c105ffe4>] process_one_work+0x29e/0x643
> [  122.247479]  [<c1061215>] worker_thread+0x23a/0x311
> [  122.247482]  [<c1060fdb>] ? rescuer_thread+0x204/0x204
> [  122.247486]  [<c10648cc>] kthread+0xbe/0xc3
> [  122.247490]  [<c158f4c0>] ret_from_kernel_thread+0x20/0x30
> [  122.247492]  [<c106480e>] ? kthread_stop+0x364/0x364
> [  122.247495] ---[ end trace 2073c37ae3c8b3b4 ]---

Ah, more of that. Thanks!

Dave, this relies on bits currently in tip/sched/core, if you're ok I'll
merge it through that tree.

---
Subject: netdev: Fix sleeping inside wait event
From: Peter Zijlstra <peterz@infradead.org>
Date: Wed Oct 29 17:04:56 CET 2014

rtnl_lock_unregistering() takes rtnl_lock() -- a mutex -- inside a
wait loop. The wait loop relies on current->state to function, but so
does mutex_lock(), nesting them makes for the inner to destroy the
outer state.

Fix this using the new wait_woken() bits.

Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: David Miller <davem@davemloft.net>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 net/core/dev.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -7196,11 +7196,10 @@ static void __net_exit rtnl_lock_unregis
 	 */
 	struct net *net;
 	bool unregistering;
-	DEFINE_WAIT(wait);
+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 
+	add_wait_queue(&netdev_unregistering_wq, &wait);
 	for (;;) {
-		prepare_to_wait(&netdev_unregistering_wq, &wait,
-				TASK_UNINTERRUPTIBLE);
 		unregistering = false;
 		rtnl_lock();
 		list_for_each_entry(net, net_list, exit_list) {
@@ -7212,9 +7211,10 @@ static void __net_exit rtnl_lock_unregis
 		if (!unregistering)
 			break;
 		__rtnl_unlock();
-		schedule();
+
+		wait_woken(&wait, TASK_UNINTERRUPTIBLE, MAX_SCHEDULE_TIMEOUT);
 	}
-	finish_wait(&netdev_unregistering_wq, &wait);
+	remove_wait_queue(&netdev_unregistering_wq, &wait);
 }
 
 static void __net_exit default_device_exit_batch(struct list_head *net_list)
