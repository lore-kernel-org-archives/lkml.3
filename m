Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206AbaELBlv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:41:51 -0400
Received: from 1wt.eu ([62.212.114.60]:34410 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752058AbaELBlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:41:49 -0400
Message-Id: <20140512003200.721088351@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:32:02 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>, Tejun Heo <tj@kernel.org>,
        Pekka Riikonen <priikone@iki.fi>,
        Eric Dumazet <eric.dumazet@gmail.com>, stable@kernel.org,
        Ben Hutchings <ben@decadent.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 002/143] Fix lockup related to stop_machine being stuck in __do_softirq.
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Greear <greearb@candelatech.com>

The stop machine logic can lock up if all but one of the migration
threads make it through the disable-irq step and the one remaining
thread gets stuck in __do_softirq.  The reason __do_softirq can hang is
that it has a bail-out based on jiffies timeout, but in the lockup case,
jiffies itself is not incremented.

To work around this, re-add the max_restart counter in __do_irq and stop
processing irqs after 10 restarts.

Thanks to Tejun Heo and Rusty Russell and others for helping me track
this down.

This was introduced in 3.9 by commit c10d73671ad3 ("softirq: reduce
latencies").

It may be worth looking into ath9k to see if it has issues with its irq
handler at a later date.

The hang stack traces look something like this:

    ------------[ cut here ]------------
    WARNING: at kernel/watchdog.c:245 watchdog_overflow_callback+0x9c/0xa7()
    Watchdog detected hard LOCKUP on cpu 2
    Modules linked in: ath9k ath9k_common ath9k_hw ath mac80211 cfg80211 nfsv4 auth_rpcgss nfs fscache nf_nat_ipv4 nf_nat veth 8021q garp stp mrp llc pktgen lockd sunrpc]
    Pid: 23, comm: migration/2 Tainted: G         C   3.9.4+ #11
    Call Trace:
     <NMI>   warn_slowpath_common+0x85/0x9f
      warn_slowpath_fmt+0x46/0x48
      watchdog_overflow_callback+0x9c/0xa7
      __perf_event_overflow+0x137/0x1cb
      perf_event_overflow+0x14/0x16
      intel_pmu_handle_irq+0x2dc/0x359
      perf_event_nmi_handler+0x19/0x1b
      nmi_handle+0x7f/0xc2
      do_nmi+0xbc/0x304
      end_repeat_nmi+0x1e/0x2e
     <<EOE>>
      cpu_stopper_thread+0xae/0x162
      smpboot_thread_fn+0x258/0x260
      kthread+0xc7/0xcf
      ret_from_fork+0x7c/0xb0
    ---[ end trace 4947dfa9b0a4cec3 ]---
    BUG: soft lockup - CPU#1 stuck for 22s! [migration/1:17]
    Modules linked in: ath9k ath9k_common ath9k_hw ath mac80211 cfg80211 nfsv4 auth_rpcgss nfs fscache nf_nat_ipv4 nf_nat veth 8021q garp stp mrp llc pktgen lockd sunrpc]
    irq event stamp: 835637905
    hardirqs last  enabled at (835637904): __do_softirq+0x9f/0x257
    hardirqs last disabled at (835637905): apic_timer_interrupt+0x6d/0x80
    softirqs last  enabled at (5654720): __do_softirq+0x1ff/0x257
    softirqs last disabled at (5654725): irq_exit+0x5f/0xbb
    CPU 1
    Pid: 17, comm: migration/1 Tainted: G        WC   3.9.4+ #11 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M.
    RIP: tasklet_hi_action+0xf0/0xf0
    Process migration/1
    Call Trace:
     <IRQ>
      __do_softirq+0x117/0x257
      irq_exit+0x5f/0xbb
      smp_apic_timer_interrupt+0x8a/0x98
      apic_timer_interrupt+0x72/0x80
     <EOI>
      printk+0x4d/0x4f
      stop_machine_cpu_stop+0x22c/0x274
      cpu_stopper_thread+0xae/0x162
      smpboot_thread_fn+0x258/0x260
      kthread+0xc7/0xcf
      ret_from_fork+0x7c/0xb0

Signed-off-by: Ben Greear <greearb@candelatech.com>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Pekka Riikonen <priikone@iki.fi>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: stable@kernel.org
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
(cherry picked from commit 34376a50fb1fa095b9d0636fa41ed2e73125f214)
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 kernel/softirq.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index d75c136..e4d5d8c 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -194,8 +194,12 @@ void local_bh_enable_ip(unsigned long ip)
 EXPORT_SYMBOL(local_bh_enable_ip);
 
 /*
- * We restart softirq processing for at most 2 ms,
- * and if need_resched() is not set.
+ * We restart softirq processing for at most MAX_SOFTIRQ_RESTART times,
+ * but break the loop if need_resched() is set or after 2 ms.
+ * The MAX_SOFTIRQ_TIME provides a nice upper bound in most cases, but in
+ * certain cases, such as stop_machine(), jiffies may cease to
+ * increment and so we need the MAX_SOFTIRQ_RESTART limit as
+ * well to make sure we eventually return from this method.
  *
  * These limits have been established via experimentation.
  * The two things to balance is latency against fairness -
@@ -203,6 +207,7 @@ EXPORT_SYMBOL(local_bh_enable_ip);
  * should not be able to lock up the box.
  */
 #define MAX_SOFTIRQ_TIME  msecs_to_jiffies(2)
+#define MAX_SOFTIRQ_RESTART 10
 
 asmlinkage void __do_softirq(void)
 {
@@ -210,6 +215,7 @@ asmlinkage void __do_softirq(void)
 	__u32 pending;
 	unsigned long end = jiffies + MAX_SOFTIRQ_TIME;
 	int cpu;
+	int max_restart = MAX_SOFTIRQ_RESTART;
 
 	pending = local_softirq_pending();
 	account_system_vtime(current);
@@ -254,7 +260,8 @@ restart:
 
 	pending = local_softirq_pending();
 	if (pending) {
-		if (time_before(jiffies, end) && !need_resched())
+		if (time_before(jiffies, end) && !need_resched() &&
+		    --max_restart)
 			goto restart;
 
 		wakeup_softirqd();
-- 
1.7.12.2.21.g234cd45.dirty



