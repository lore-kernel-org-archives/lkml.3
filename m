Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994Ab3F0Ccx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 22:32:53 -0400
Received: from mail-qe0-f46.google.com ([209.85.128.46]:64102 "EHLO
	mail-qe0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897Ab3F0Ccv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 22:32:51 -0400
Date: Wed, 26 Jun 2013 19:32:45 -0700
From: Tejun Heo <tj@kernel.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Dave Jones <davej@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrey Vagin <avagin@openvz.org>, Steven Rostedt <rostedt@goodmis.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: frequent softlockups with 3.10rc6.
Message-ID: <20130627023245.GI4536@htj.dyndns.org>
References: <20130622215905.GA28238@redhat.com>
 <20130623143634.GA2000@redhat.com>
 <20130623150603.GA32313@redhat.com>
 <20130623160452.GA11740@redhat.com>
 <20130624155758.GA5993@redhat.com>
 <20130624173510.GA1321@redhat.com>
 <20130625153520.GA7784@redhat.com>
 <20130626191853.GA29049@redhat.com>
 <20130627002255.GA16553@redhat.com>
 <87ppv82wgq.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ppv82wgq.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jun 26, 2013 at 06:06:45PM -0700, Eric W. Biederman wrote:
> Just based on the last trace and your observation that it seems to be
> vfs/block layer related I am going to mildly suggest that Jens and Tejun
> might have a clue.  Tejun made a transformation of the threads used for
> writeback from a custom thread pool to the generic mechanism.  So it
> seems worth asking the question could it have been in Jens block merge
> of 4de13d7aa8f4d02f4dc99d4609575659f92b3c5a.

If workqueue was suffering deadlock or starvation, it'd lock up in a
lot more boring places, unless it's somehow completely messing up blk
softirq completion logic.

Given the wide variety of places, it's likely something lower level.
Maybe something is raising an interrupt and then its softirq raises it
again right away so that it evades the screaming irq detection but
still live-locks the CPU?  It'd definitely be interesting to watch the
interrupt and softirq counters.  Something like the following may
help.

Thanks.

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 05039e3..21d4e82 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -261,6 +261,49 @@ static void watchdog_interrupt_count(void)
 static int watchdog_nmi_enable(unsigned int cpu);
 static void watchdog_nmi_disable(unsigned int cpu);
 
+#include <linux/irq.h>
+#include <linux/irqdesc.h>
+#include <linux/kernel_stat.h>
+static void dump_irqs(void)
+{
+	static u64 hirq_sums[NR_IRQS];
+	static u64 sirq_sums[NR_SOFTIRQS];
+	int i, cpu;
+
+	for (i = 0; i < nr_irqs; i++) {
+		struct irq_desc *desc = irq_to_desc(i);
+		u64 sum = 0;
+
+		if (!desc)
+			continue;
+
+		for_each_online_cpu(cpu)
+			sum += kstat_irqs_cpu(i, cpu);
+		if (sum == hirq_sums[i])
+			continue;
+
+		printk("XXX HIRQ %2d %8s : sum_delta=%8llu on_this_cpu=%8u\n",
+		       i, desc->action ? desc->action->name : "",
+		       sum - hirq_sums[i],
+		       kstat_irqs_cpu(i, smp_processor_id()));
+		hirq_sums[i] = sum;
+	}
+
+	for (i = 0; i < NR_SOFTIRQS; i++) {
+		u64 sum = 0;
+
+		for_each_online_cpu(cpu)
+			sum += kstat_softirqs_cpu(i, cpu);
+		if (sum == sirq_sums[i])
+			continue;
+
+		printk("XXX SIRQ %2d %8s : sum_delta=%8llu on_this_cpu=%8u\n",
+		       i, softirq_to_name[i], sum - sirq_sums[i],
+		       kstat_softirqs_cpu(i, smp_processor_id()));
+		sirq_sums[i] = sum;
+	}
+}
+
 /* watchdog kicker functions */
 static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 {
@@ -301,6 +344,8 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 	 */
 	duration = is_softlockup(touch_ts);
 	if (unlikely(duration)) {
+		static int warned_on_cpu = -1;
+
 		/*
 		 * If a virtual machine is stopped by the host it can look to
 		 * the watchdog like a soft lockup, check to see if the host
@@ -309,10 +354,14 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 		if (kvm_check_and_clear_guest_paused())
 			return HRTIMER_RESTART;
 
-		/* only warn once */
-		if (__this_cpu_read(soft_watchdog_warn) == true)
+		/* let's follow the first cpu */
+		if (warned_on_cpu >= 0 && warned_on_cpu != smp_processor_id())
 			return HRTIMER_RESTART;
 
+		/* only warn once */
+		//if (__this_cpu_read(soft_watchdog_warn) == true)
+		//	return HRTIMER_RESTART;
+
 		printk(KERN_EMERG "BUG: soft lockup - CPU#%d stuck for %us! [%s:%d]\n",
 			smp_processor_id(), duration,
 			current->comm, task_pid_nr(current));
@@ -323,6 +372,8 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 		else
 			dump_stack();
 
+		dump_irqs();
+
 		if (softlockup_panic)
 			panic("softlockup: hung tasks");
 		__this_cpu_write(soft_watchdog_warn, true);
