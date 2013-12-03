Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656Ab3LCXjJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 18:39:09 -0500
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:41148 "EHLO
	qmta08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754649Ab3LCXiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 18:38:55 -0500
Message-Id: <20131203233246.975768605@linux.com>
User-Agent: quilt/0.60-1
Date: Tue, 03 Dec 2013 17:32:36 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 04/41] kernel misc: Replace __get_cpu_var uses
References: <20131203233232.928771708@linux.com>
Content-Disposition: inline; filename=this_misc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace uses of __get_cpu_var for address calculation with this_cpu_ptr.

Cc: akpm@linux-foundation.org
Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/kernel/printk/printk.c
===================================================================
--- linux.orig/kernel/printk/printk.c	2013-12-02 16:07:47.434699125 -0600
+++ linux/kernel/printk/printk.c	2013-12-02 16:07:47.434699125 -0600
@@ -2447,7 +2447,7 @@ static void wake_up_klogd_work_func(stru
 	int pending = __this_cpu_xchg(printk_pending, 0);
 
 	if (pending & PRINTK_PENDING_SCHED) {
-		char *buf = __get_cpu_var(printk_sched_buf);
+		char *buf = this_cpu_ptr(printk_sched_buf);
 		pr_warn("[sched_delayed] %s", buf);
 	}
 
@@ -2465,7 +2465,7 @@ void wake_up_klogd(void)
 	preempt_disable();
 	if (waitqueue_active(&log_wait)) {
 		this_cpu_or(printk_pending, PRINTK_PENDING_WAKEUP);
-		irq_work_queue(&__get_cpu_var(wake_up_klogd_work));
+		irq_work_queue(this_cpu_ptr(&wake_up_klogd_work));
 	}
 	preempt_enable();
 }
@@ -2478,14 +2478,14 @@ int printk_sched(const char *fmt, ...)
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
--- linux.orig/kernel/smp.c	2013-12-02 16:07:47.434699125 -0600
+++ linux/kernel/smp.c	2013-12-02 16:07:47.434699125 -0600
@@ -177,7 +177,7 @@ static void generic_exec_single(int cpu,
  */
 void generic_smp_call_function_single_interrupt(void)
 {
-	struct call_single_queue *q = &__get_cpu_var(call_single_queue);
+	struct call_single_queue *q = this_cpu_ptr(&call_single_queue);
 	LIST_HEAD(list);
 
 	/*
@@ -245,7 +245,7 @@ int smp_call_function_single(int cpu, sm
 			struct call_single_data *csd = &d;
 
 			if (!wait)
-				csd = &__get_cpu_var(csd_data);
+				csd = this_cpu_ptr(&csd_data);
 
 			csd_lock(csd);
 
@@ -393,7 +393,7 @@ void smp_call_function_many(const struct
 		return;
 	}
 
-	cfd = &__get_cpu_var(cfd_data);
+	cfd = this_cpu_ptr(&cfd_data);
 
 	cpumask_and(cfd->cpumask, mask, cpu_online_mask);
 	cpumask_clear_cpu(this_cpu, cfd->cpumask);

