Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155AbaFTTbc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 15:31:32 -0400
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:54320
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752666AbaFTTba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 15:31:30 -0400
Message-Id: <20140620193124.967726355@linux.com>
Date: Fri, 20 Jun 2014 14:31:16 -0500
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, akpm@linux-foundation.org
Subject: [PATCH 01/31] kernel misc: Replace __get_cpu_var uses
References: <20140620193115.547427118@linux.com>
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
--- linux.orig/kernel/printk/printk.c	2014-06-16 09:11:49.095901488 -0500
+++ linux/kernel/printk/printk.c	2014-06-16 09:11:49.091901567 -0500
@@ -2578,7 +2578,7 @@
 	preempt_disable();
 	if (waitqueue_active(&log_wait)) {
 		this_cpu_or(printk_pending, PRINTK_PENDING_WAKEUP);
-		irq_work_queue(&__get_cpu_var(wake_up_klogd_work));
+		irq_work_queue(this_cpu_ptr(&wake_up_klogd_work));
 	}
 	preempt_enable();
 }
@@ -2594,7 +2594,7 @@
 	va_end(args);
 
 	__this_cpu_or(printk_pending, PRINTK_PENDING_OUTPUT);
-	irq_work_queue(&__get_cpu_var(wake_up_klogd_work));
+	irq_work_queue(this_cpu_ptr(&wake_up_klogd_work));
 	preempt_enable();
 
 	return r;
Index: linux/kernel/smp.c
===================================================================
--- linux.orig/kernel/smp.c	2014-06-16 09:11:49.095901488 -0500
+++ linux/kernel/smp.c	2014-06-16 09:11:49.091901567 -0500
@@ -146,7 +146,7 @@
 	if (!csd) {
 		csd = &csd_stack;
 		if (!wait)
-			csd = &__get_cpu_var(csd_data);
+			csd = this_cpu_ptr(&csd_data);
 	}
 
 	csd_lock(csd);
@@ -187,7 +187,7 @@
 	struct call_single_data *csd, *csd_next;
 	static bool warned;
 
-	entry = llist_del_all(&__get_cpu_var(call_single_queue));
+	entry = llist_del_all(this_cpu_ptr(&call_single_queue));
 	entry = llist_reverse_order(entry);
 
 	/*
@@ -369,7 +369,7 @@
 		return;
 	}
 
-	cfd = &__get_cpu_var(cfd_data);
+	cfd = this_cpu_ptr(&cfd_data);
 
 	cpumask_and(cfd->cpumask, mask, cpu_online_mask);
 	cpumask_clear_cpu(this_cpu, cfd->cpumask);

