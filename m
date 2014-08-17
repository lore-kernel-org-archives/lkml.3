Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696AbaHQRat (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 13:30:49 -0400
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:32964
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751368AbaHQRai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 13:30:38 -0400
Message-Id: <20140817173033.080582670@linux.com>
Date: Sun, 17 Aug 2014 12:30:24 -0500
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, akpm@linux-foundation.org
Subject: [PATCH 01/35] [PATCH 02/36] kernel misc: Replace __get_cpu_var uses
References: <20140817173023.439660246@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0002-kernel-misc-Replace-__get_cpu_var-uses.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace uses of __get_cpu_var for address calculation with this_cpu_ptr.

Cc: akpm@linux-foundation.org
Signed-off-by: Christoph Lameter <cl@linux.com>
---
 kernel/printk/printk.c | 4 ++--
 kernel/smp.c           | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

Index: linux/kernel/printk/printk.c
===================================================================
--- linux.orig/kernel/printk/printk.c
+++ linux/kernel/printk/printk.c
@@ -2628,7 +2628,7 @@ void wake_up_klogd(void)
 	preempt_disable();
 	if (waitqueue_active(&log_wait)) {
 		this_cpu_or(printk_pending, PRINTK_PENDING_WAKEUP);
-		irq_work_queue(&__get_cpu_var(wake_up_klogd_work));
+		irq_work_queue(this_cpu_ptr(&wake_up_klogd_work));
 	}
 	preempt_enable();
 }
@@ -2644,7 +2644,7 @@ int printk_deferred(const char *fmt, ...
 	va_end(args);
 
 	__this_cpu_or(printk_pending, PRINTK_PENDING_OUTPUT);
-	irq_work_queue(&__get_cpu_var(wake_up_klogd_work));
+	irq_work_queue(this_cpu_ptr(&wake_up_klogd_work));
 	preempt_enable();
 
 	return r;
Index: linux/kernel/smp.c
===================================================================
--- linux.orig/kernel/smp.c
+++ linux/kernel/smp.c
@@ -164,7 +164,7 @@ static int generic_exec_single(int cpu,
 	if (!csd) {
 		csd = &csd_stack;
 		if (!wait)
-			csd = &__get_cpu_var(csd_data);
+			csd = this_cpu_ptr(&csd_data);
 	}
 
 	csd_lock(csd);
@@ -229,7 +229,7 @@ static void flush_smp_call_function_queu
 
 	WARN_ON(!irqs_disabled());
 
-	head = &__get_cpu_var(call_single_queue);
+	head = this_cpu_ptr(&call_single_queue);
 	entry = llist_del_all(head);
 	entry = llist_reverse_order(entry);
 
@@ -419,7 +419,7 @@ void smp_call_function_many(const struct
 		return;
 	}
 
-	cfd = &__get_cpu_var(cfd_data);
+	cfd = this_cpu_ptr(&cfd_data);
 
 	cpumask_and(cfd->cpumask, mask, cpu_online_mask);
 	cpumask_clear_cpu(this_cpu, cfd->cpumask);

