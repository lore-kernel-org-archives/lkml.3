Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166Ab3CFPvh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 10:51:37 -0500
Received: from mail1.windriver.com ([147.11.146.13]:56569 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452Ab3CFPvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 10:51:33 -0500
Date: Wed, 6 Mar 2013 10:49:17 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: <linux-rt-users@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Threaded irqs + 100% CPU RT task = RCU stall
Message-ID: <20130306154917.GA15249@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It turns out that if a person enables threaded irqs, takes a
100% CPU using task, binds it to a core, and then chrt's it,
they will get an RCU stall.

This was seen on 3.6-RT (which implicitly forces "threadirqs=1") and
then reproduced on vanilla 3.6.11, 3.8 and 3.9-rc1 when explicitly
using threadirqs=1

The problem (if you want to call it that, vs. an "educational issue")
is that Joe Average will never correlate the mysterious RCU stall
to the underlying root cause of that core's ksoftirqd never being run.

It wasn't immediately evident to me either, I had to "cheat" by
doing a pseudo bisect on RT which got me looking at RT's patch
called "genirq-force-threading.patch", and then things all started
to make more sense.

To be more specific, say we have user "Joe" who has a busy polling
loop in his RT task, and since Joe isn't that bright, he doesn't
ever bother to briefly yield the core, or change other system thread
priorities.

We can simulate what Joe does by doing this:

-boot 3.9-rc1 SMP box with threadirqs=1 on kernel command line and run:

   echo "main() { for(;;);}" > eatme-simple.c
   gcc eatme-simple.c -o eatme-simple
   taskset -c 1 ./eatme-simple  &
   chrt -p 80 `pgrep eatme`

   <wait ~2m>

   INFO: rcu_preempt self-detected stall on CPU
   INFO: rcu_preempt detected stalls on CPUs/tasks: { 1} (detected by 4, t=60002 jiffies, g=314, c=313, q=2800)
   Task dump for CPU 1:
   eatme-simple    R  running task        0  1485   1428 0x00000000
    ffff88042b7a7f70 ffffffff81316396 ffff88042a90ad30 ffff88042b7a7fd8
    0000000000010b00 ffff88042b7a7fd8 ffff88042dac2050 ffff88042a90ad30
    0000000000000000 0000000000000000 0000000000000000 ffff88043fc4ceb0
   Call Trace:
    [<ffffffff81316396>] ? __schedule+0x617/0x74b
    [<ffffffff810a4dfc>] ? dput+0x20/0x15c
    [<ffffffff8109577c>] ? __fput+0x1a1/0x1c8
    [<ffffffff810aaf4b>] ? mntput_no_expire+0x13/0x11f
    { 1}  (t=60010 jiffies g=314 c=313 q=2800)
   Pid: 1485, comm: eatme-simple Not tainted 3.9.0-rc1 #15
   Call Trace:
    <IRQ>  [<ffffffff8105c2fc>] ? rcu_check_callbacks+0x1de/0x5ab
    [<ffffffff8102ce08>] ? update_process_times+0x31/0x5c
    [<ffffffff8104b947>] ? tick_handle_periodic+0x18/0x52
    [<ffffffff8101616c>] ? smp_apic_timer_interrupt+0x7d/0x8f
    [<ffffffff813189ca>] ? apic_timer_interrupt+0x6a/0x70

What happens is that the threadirqs=1 option makes the difference in
the invoke_softirq() function -- it will either call do_softirq()
directly, or if threading is on, it will instead call the
wakeup_softirqd() (i.e. defer it to the ksoftirqd.)  But the default
prio for ksoftirqd on that core won't ever trump Joe's eatme task.
So we never do any do_softirq work at all on that core.  Eventually
the rcu stall detection sees it from sched tick:

scheduling-clock interrupt
  --> rcu_check_callbacks
      --> if (rcu_pending)    <--- Stall message!
          --> invoke_rcu_core
              --> raise_softirq(RCU_SOFTIRQ)

The stall comes rom rcu_pending as follows:

rcu_pending
  --> __rcu_pending
      --> check_cpu_stall
          --> print_cpu_stall
              --> printk "self-detected stall.."

Note that softirq isn't implicated at all in the above path, and hence
even if Joe does a bit of digging, he probably still has no idea why
things don't work.  He thinks this is just some as yet undiscovered
kernel/RCU bug.

To confirm that I was properly understanding what was really happening,
I added a quick hack (below) that set a hard upper limit on the number
of times we'd allow continuous defer to wakeup_softirqd() vs. running
do_softirq() directly.  Choosing an arbitrary limit of ~8k showed that
we'd hit it in roughly ~5s intervals with the busy loop program executing.
And we'd avoid the stalls by forcing it when we hit that limit.

So, I guess the question is, whether we want to try and make the system
fail in a more meaningful way -- kind of like the rt throttling message
does - as it lets users know they've hit the wall?  Something watching
for kstat_incr_softirqs traffic perhaps?  Or other options?

Paul.
--

diff --git a/kernel/softirq.c b/kernel/softirq.c
index b4d252f..a1ded00 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -205,6 +205,8 @@ EXPORT_SYMBOL(local_bh_enable_ip);
  */
 #define MAX_SOFTIRQ_TIME  msecs_to_jiffies(2)
 
+DEFINE_PER_CPU(unsigned long, defer_count);
+
 asmlinkage void __do_softirq(void)
 {
 	struct softirq_action *h;
@@ -271,6 +273,9 @@ restart:
 		wakeup_softirqd();
 	}
 
+	/* we've really run the queue, so reset counter */
+	this_cpu_write(defer_count, 0);
+
 	lockdep_softirq_exit();
 
 	account_irq_exit_time(current);
@@ -321,19 +326,30 @@ void irq_enter(void)
 	__irq_enter();
 }
 
+/*
+ * if we've gone too many iterations without having really run,
+ * then genuinely force it, otherwise we'll be setting ourselves
+ * up for a backlog, and get rcu stalls and so on.
+ */
+#define MAX_DEFER 8192
 static inline void invoke_softirq(void)
 {
-	if (!force_irqthreads) {
+	bool overdue = (this_cpu_read(defer_count) > MAX_DEFER);
+
+	if (!force_irqthreads || overdue) {
 #ifdef __ARCH_IRQ_EXIT_IRQS_DISABLED
 		__do_softirq();
 #else
 		do_softirq();
 #endif
+		if (overdue)
+			printk("defer limit reached: softirq execution was forced\n");
 	} else {
 		__local_bh_disable((unsigned long)__builtin_return_address(0),
 				SOFTIRQ_OFFSET);
 		wakeup_softirqd();
 		__local_bh_enable(SOFTIRQ_OFFSET);
+		this_cpu_inc(defer_count);
 	}
 }
 
-- 
1.8.1.2


