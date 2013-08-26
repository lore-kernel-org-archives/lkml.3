Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab3HZUt5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 16:49:57 -0400
Received: from a9-62.smtp-out.amazonses.com ([54.240.9.62]:35723 "EHLO
	a9-62.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752341Ab3HZUtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 16:49:55 -0400
X-Greylist: delayed 315 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Aug 2013 16:49:55 EDT
Message-ID: <00000140bc5f0749-fc84c079-fa85-429d-8622-77482738335c-000000@email.amazonses.com>
User-Agent: quilt/0.50-1
Date: Mon, 26 Aug 2013 20:44:39 +0000
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org
Cc: linux-arch@vger.kernel.org
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [guv v2 13/31] kernel misc: Replace __get_cpu_var uses
References: <20130826204351.725357339@linux.com>
X-SES-Outgoing: 2013.08.26-54.240.9.62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__get_cpu_var() is used for multiple purposes in the kernel source. One of them is
address calculation via the form &__get_cpu_var(x). This calculates the address for
the instance of the percpu variable of the current processor based on an offset.

Others usage cases are for storing and retrieving data from the current processors percpu area.
__get_cpu_var() can be used as an lvalue when writing data or on the right side of an assignment.

__get_cpu_var() is defined as :


#define __get_cpu_var(var) (*this_cpu_ptr(&(var)))



__get_cpu_var() always only does a address determination. However, store and retrieve operations
could use a segment prefix (or global register on other platforms) to avoid the address calculation.

this_cpu_write() and this_cpu_read() can directly take an offset into a percpu area and use
optimized assembly code to read and write per cpu variables.


This patch converts __get_cpu_var into either and explicit address calculation using this_cpu_ptr()
or into a use of this_cpu operations that use the offset. Thereby address calcualtions are avoided
and less registers are used when code is generated.

At the end of the patchset all uses of __get_cpu_var have been removed so the macro is removed too.

The patchset includes passes over all arches as well. Once these operations are used throughout then
specialized macros can be defined in non -x86 arches as well in order to optimize per cpu access by
f.e. using a global register that may be set to the per cpu base.




Transformations done to __get_cpu_var()


1. Determine the address of the percpu instance of the current processor.

	DEFINE_PER_CPU(int, y);
	int *x = &__get_cpu_var(y);

    Converts to

	int *x = this_cpu_ptr(&y);


2. Same as #1 but this time an array structure is involved.

	DEFINE_PER_CPU(int, y[20]);
	int *x = __get_cpu_var(y);

    Converts to

	int *x = this_cpu_ptr(y);


3. Retrieve the content of the current processors instance of a per cpu variable.

	DEFINE_PER_CPU(int, u);
	int x = __get_cpu_var(y)

   Converts to

	int x = __this_cpu_read(y);


4. Retrieve the content of a percpu struct

	DEFINE_PER_CPU(struct mystruct, y);
	struct mystruct x = __get_cpu_var(y);

   Converts to

	memcpy(this_cpu_ptr(&y), x, sizeof(x));


5. Assignment to a per cpu variable

	DEFINE_PER_CPU(int, y)
	__get_cpu_var(y) = x;

   Converts to

	this_cpu_write(y, x);


6. Increment/Decrement etc of a per cpu variable

	DEFINE_PER_CPU(int, y);
	__get_cpu_var(y)++

   Converts to

	this_cpu_inc(y)


Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/kernel/printk/printk.c
===================================================================
--- linux.orig/kernel/printk/printk.c	2013-08-26 14:30:25.846490787 -0500
+++ linux/kernel/printk/printk.c	2013-08-26 14:30:25.846490787 -0500
@@ -2441,7 +2441,7 @@ static void wake_up_klogd_work_func(stru
 	int pending = __this_cpu_xchg(printk_pending, 0);
 
 	if (pending & PRINTK_PENDING_SCHED) {
-		char *buf = __get_cpu_var(printk_sched_buf);
+		char *buf = this_cpu_ptr(printk_sched_buf);
 		printk(KERN_WARNING "[sched_delayed] %s", buf);
 	}
 
@@ -2459,7 +2459,7 @@ void wake_up_klogd(void)
 	preempt_disable();
 	if (waitqueue_active(&log_wait)) {
 		this_cpu_or(printk_pending, PRINTK_PENDING_WAKEUP);
-		irq_work_queue(&__get_cpu_var(wake_up_klogd_work));
+		irq_work_queue(this_cpu_ptr(&wake_up_klogd_work));
 	}
 	preempt_enable();
 }
@@ -2472,14 +2472,14 @@ int printk_sched(const char *fmt, ...)
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
--- linux.orig/kernel/smp.c	2013-08-26 14:30:25.846490787 -0500
+++ linux/kernel/smp.c	2013-08-26 14:30:25.846490787 -0500
@@ -172,7 +172,7 @@ void generic_exec_single(int cpu, struct
  */
 void generic_smp_call_function_single_interrupt(void)
 {
-	struct call_single_queue *q = &__get_cpu_var(call_single_queue);
+	struct call_single_queue *q = this_cpu_ptr(&call_single_queue);
 	LIST_HEAD(list);
 
 	/*
@@ -252,7 +252,7 @@ int smp_call_function_single(int cpu, sm
 			struct call_single_data *csd = &d;
 
 			if (!wait)
-				csd = &__get_cpu_var(csd_data);
+				csd = this_cpu_ptr(&csd_data);
 
 			csd_lock(csd);
 
@@ -401,7 +401,7 @@ void smp_call_function_many(const struct
 		return;
 	}
 
-	cfd = &__get_cpu_var(cfd_data);
+	cfd = this_cpu_ptr(&cfd_data);
 
 	cpumask_and(cfd->cpumask, mask, cpu_online_mask);
 	cpumask_clear_cpu(this_cpu, cfd->cpumask);

