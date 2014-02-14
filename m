Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633AbaBNUcW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 15:32:22 -0500
Received: from qmta07.emeryville.ca.mail.comcast.net ([76.96.30.64]:41910 "EHLO
	qmta07.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752940AbaBNUT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 15:19:27 -0500
Message-Id: <20140214201904.862885166@linux.com>
Date: Fri, 14 Feb 2014 14:18:50 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, akpm@linux-foundation.org
Subject: [PATCH 09/48] kernel misc: Replace __get_cpu_var uses
References: <20140214201841.826179349@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=this_misc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace uses of __get_cpu_var for address calculation with this_cpu_ptr.

Cc: akpm@linux-foundation.org
Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/kernel/printk/printk.c
===================================================================
--- linux.orig/kernel/printk/printk.c	2014-02-03 13:20:17.278906256 -0600
+++ linux/kernel/printk/printk.c	2014-02-03 13:20:17.278906256 -0600
@@ -2446,7 +2446,7 @@
 	int pending = __this_cpu_xchg(printk_pending, 0);
 
 	if (pending & PRINTK_PENDING_SCHED) {
-		char *buf = __get_cpu_var(printk_sched_buf);
+		char *buf = this_cpu_ptr(printk_sched_buf);
 		pr_warn("[sched_delayed] %s", buf);
 	}
 
@@ -2464,7 +2464,7 @@
 	preempt_disable();
 	if (waitqueue_active(&log_wait)) {
 		this_cpu_or(printk_pending, PRINTK_PENDING_WAKEUP);
-		irq_work_queue(&__get_cpu_var(wake_up_klogd_work));
+		irq_work_queue(this_cpu_ptr(&wake_up_klogd_work));
 	}
 	preempt_enable();
 }
@@ -2477,14 +2477,14 @@
 	int r;
 
 	local_irq_save(flags);
-	buf = __get_cpu_var(printk_sched_buf);
+	buf = this_cpu_ptr(printk_sched_buf);
 
 	va_start(args, fmt);
 	r = vsnprintf(buf, PRINTK_BUF_SIZE, fmt, args);
 	va_end(args);
 
 	__this_cpu_or(printk_pending, PRINTK_PENDING_SCHED);
-	irq_work_queue(&__get_cpu_var(wake_up_klogd_work));
+	irq_work_queue(this_cpu_ptr(&wake_up_klogd_work));
 	local_irq_restore(flags);
 
 	return r;
Index: linux/kernel/smp.c
===================================================================
--- linux.orig/kernel/smp.c	2014-02-03 13:20:17.278906256 -0600
+++ linux/kernel/smp.c	2014-02-03 13:20:48.918248998 -0600
@@ -158,7 +158,7 @@
 	 */
 	WARN_ON_ONCE(!cpu_online(smp_processor_id()));
 
-	entry = llist_del_all(&__get_cpu_var(call_single_queue));
+	entry = llist_del_all(this_cpu_ptr(&call_single_queue));
 	entry = llist_reverse_order(entry);
 
 	while (entry) {
@@ -218,7 +218,7 @@
 			struct call_single_data *csd = &d;
 
 			if (!wait)
-				csd = &__get_cpu_var(csd_data);
+				csd = this_cpu_ptr(&csd_data);
 
 			csd_lock(csd);
 
@@ -366,7 +366,7 @@
 		return;
 	}
 
-	cfd = &__get_cpu_var(cfd_data);
+	cfd = this_cpu_ptr(&cfd_data);
 
 	cpumask_and(cfd->cpumask, mask, cpu_online_mask);
 	cpumask_clear_cpu(this_cpu, cfd->cpumask);

