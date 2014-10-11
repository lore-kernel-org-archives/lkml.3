Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673AbaJKPxH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 11:53:07 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:36589 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbaJKPxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 11:53:04 -0400
Date: Sat, 11 Oct 2014 08:52:57 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: "David S. Miller" <davem@davemloft.net>, tgraf@suug.ch,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: rhashtable: hang while running tests on boot
Message-ID: <20141011155257.GA4880@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <5437E1B3.6020409@oracle.com>
 <20141010142247.GU4880@linux.vnet.ibm.com>
 <54392576.30707@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54392576.30707@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14101115-0005-0000-0000-00000591168A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 11, 2014 at 08:41:26AM -0400, Sasha Levin wrote:
> On 10/10/2014 10:22 AM, Paul E. McKenney wrote:
> > I am guessing that this happens only when running the resizable hashtable
> > tests -- if that guess is incorrect, please let me know.
> 
> Paul, I'm not sure if it's related or not - but I'm also seeing quite a few
> unexplainable (read: which I can't explain) RCU stalls:
> 
> [ 2121.852211] INFO: rcu_preempt detected stalls on CPUs/tasks:
> [ 2121.852233]  0: (244 ticks this GP) idle=1f7/140000000000002/0 softirq=18045/18045 last_accelerate: 7794/c7aa, nonlazy_posted: 576737, ..
> [ 2121.852260]  (detected by 7, t=20502 jiffies, g=16439, c=16438, q=63119)
> [ 2121.852265] Task dump for CPU 0:
> [ 2121.852294] ksoftirqd/0     R  running task    13504     3      2 0x10080008
> [ 2121.852307]  ffff880068203d88 ffffffff8efe9a34 ffff880068203d48 0000000000000000
> [ 2121.852317]  ffff8800681c3000 ffff880068200010 ffff880068200000 000001bae312d5a9
> [ 2121.852327]  ffff880064a5b000 ffff880064a5b000 ffff880068203d78 0000000000000000
> [ 2121.852330] Call Trace:
> [ 2121.852354]  [<ffffffff8efe9a34>] ? __schedule+0x614/0xdd0
> [ 2121.852364]  [<ffffffff8efea230>] schedule+0x40/0xb0
> [ 2121.852378]  [<ffffffff8a1fe4a8>] smpboot_thread_fn+0x1b8/0x420
> [ 2121.852389]  [<ffffffff8a1c7a90>] ? tasklet_init+0x70/0x70
> [ 2121.852399]  [<ffffffff8a1fe2f0>] ? SyS_setgroups+0x1e0/0x1e0
> [ 2121.852410]  [<ffffffff8a1f7aa4>] kthread+0x144/0x170
> [ 2121.852420]  [<ffffffff8efec2cf>] ? wait_for_completion+0x10f/0x160
> [ 2121.852431]  [<ffffffff8a1f7960>] ? flush_kthread_work+0x1d0/0x1d0
> [ 2121.852440]  [<ffffffff8eff4a3c>] ret_from_fork+0x7c/0xb0
> [ 2121.852450]  [<ffffffff8a1f7960>] ? flush_kthread_work+0x1d0/0x1d0

Does the following patch help?  (If you kernel does not have a
rcu_note_voluntary_context_switch(), replace this with
rcu_note_context_switch().)

							Thanx, Paul

------------------------------------------------------------------------

workqueue: Add quiescent state between work items

Similar to the stop_machine deadlock scenario on !PREEMPT kernels
addressed in b22ce2785d97 "workqueue: cond_resched() after processing
each work item", kworker threads requeueing back-to-back with zero jiffy
delay can stall RCU. The cond_resched call introduced in that fix will
yield only iff there are other higher priority tasks to run, so force a
quiescent RCU state between work items.

Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
Link: https://lkml.kernel.org/r/20140926105227.01325697@jlaw-desktop.mno.stratus.com
Link: https://lkml.kernel.org/r/20140929115445.40221d8e@jlaw-desktop.mno.stratus.com
Fixes: b22ce2785d97 ("workqueue: cond_resched() after processing each work item")
Cc: <stable@vger.kernel.org>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 5dbe22aa3efd..345bec95e708 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2043,8 +2043,10 @@ __acquires(&pool->lock)
 	 * kernels, where a requeueing work item waiting for something to
 	 * happen could deadlock with stop_machine as such work item could
 	 * indefinitely requeue itself while all other CPUs are trapped in
-	 * stop_machine.
+	 * stop_machine. At the same time, report a quiescent RCU state so
+	 * the same condition doesn't freeze RCU.
 	 */
+	rcu_note_voluntary_context_switch(current);
 	cond_resched();
 
 	spin_lock_irq(&pool->lock);

