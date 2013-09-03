Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933173Ab3ICTc3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 15:32:29 -0400
Received: from a9-42.smtp-out.amazonses.com ([54.240.9.42]:45918 "EHLO
	a9-42.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753889Ab3ICTcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 15:32:23 -0400
Message-ID: <00000140e54fb0bf-9197ad52-1637-4a8c-b854-ee1fa9b5fe42-000000@email.amazonses.com>
User-Agent: quilt/0.50-1
Date: Tue, 3 Sep 2013 19:32:21 +0000
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, Jens Axboe <axboe@kernel.dk>
Cc: linux-arch@vger.kernel.org
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Subject: [gcv v4 12/38] block: Replace __get_cpu_var uses
References: <20130903190014.794420260@linux.com>
X-SES-Outgoing: 2013.09.03-54.240.9.42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__get_cpu_var() is used for multiple purposes in the kernel source. One of them is
address calculation via the form &__get_cpu_var(x). This calculates the address for
the instance of the percpu variable of the current processor based on an offset.

Other use cases are for storing and retrieving data from the current processors percpu area.
__get_cpu_var() can be used as an lvalue when writing data or on the right side of an assignment.

__get_cpu_var() is defined as :


#define __get_cpu_var(var) (*this_cpu_ptr(&(var)))



__get_cpu_var() always only does an address determination. However, store and retrieve operations
could use a segment prefix (or global register on other platforms) to avoid the address calculation.

this_cpu_write() and this_cpu_read() can directly take an offset into a percpu area and use
optimized assembly code to read and write per cpu variables.


This patch converts __get_cpu_var into either an explicit address calculation using this_cpu_ptr()
or into a use of this_cpu operations that use the offset. Thereby address calculations are avoided
and less registers are used when code is generated.

At the end of the patch set all uses of __get_cpu_var have been removed so the macro is removed too.

The patch set includes passes over all arches as well. Once these operations are used throughout then
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

	DEFINE_PER_CPU(int, y);
	int x = __get_cpu_var(y)

   Converts to

	int x = __this_cpu_read(y);


4. Retrieve the content of a percpu struct

	DEFINE_PER_CPU(struct mystruct, y);
	struct mystruct x = __get_cpu_var(y);

   Converts to

	memcpy(&x, this_cpu_ptr(&y), sizeof(x));


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

Index: linux/block/blk-iopoll.c
===================================================================
--- linux.orig/block/blk-iopoll.c	2013-08-26 14:36:07.858875667 -0500
+++ linux/block/blk-iopoll.c	2013-08-26 14:36:07.850875751 -0500
@@ -35,7 +35,7 @@ void blk_iopoll_sched(struct blk_iopoll
 	unsigned long flags;
 
 	local_irq_save(flags);
-	list_add_tail(&iop->list, &__get_cpu_var(blk_cpu_iopoll));
+	list_add_tail(&iop->list, this_cpu_ptr(&blk_cpu_iopoll));
 	__raise_softirq_irqoff(BLOCK_IOPOLL_SOFTIRQ);
 	local_irq_restore(flags);
 }
@@ -79,7 +79,7 @@ EXPORT_SYMBOL(blk_iopoll_complete);
 
 static void blk_iopoll_softirq(struct softirq_action *h)
 {
-	struct list_head *list = &__get_cpu_var(blk_cpu_iopoll);
+	struct list_head *list = this_cpu_ptr(&blk_cpu_iopoll);
 	int rearm = 0, budget = blk_iopoll_budget;
 	unsigned long start_time = jiffies;
 
@@ -201,7 +201,7 @@ static int blk_iopoll_cpu_notify(struct
 
 		local_irq_disable();
 		list_splice_init(&per_cpu(blk_cpu_iopoll, cpu),
-				 &__get_cpu_var(blk_cpu_iopoll));
+				 this_cpu_ptr(&blk_cpu_iopoll));
 		__raise_softirq_irqoff(BLOCK_IOPOLL_SOFTIRQ);
 		local_irq_enable();
 	}
Index: linux/block/blk-softirq.c
===================================================================
--- linux.orig/block/blk-softirq.c	2013-08-26 14:36:07.858875667 -0500
+++ linux/block/blk-softirq.c	2013-08-26 14:36:07.854875709 -0500
@@ -23,7 +23,7 @@ static void blk_done_softirq(struct soft
 	struct list_head *cpu_list, local_list;
 
 	local_irq_disable();
-	cpu_list = &__get_cpu_var(blk_cpu_done);
+	cpu_list = this_cpu_ptr(&blk_cpu_done);
 	list_replace_init(cpu_list, &local_list);
 	local_irq_enable();
 
@@ -44,7 +44,7 @@ static void trigger_softirq(void *data)
 	struct list_head *list;
 
 	local_irq_save(flags);
-	list = &__get_cpu_var(blk_cpu_done);
+	list = this_cpu_ptr(&blk_cpu_done);
 	list_add_tail(&rq->csd.list, list);
 
 	if (list->next == &rq->csd.list)
@@ -90,7 +90,7 @@ static int blk_cpu_notify(struct notifie
 
 		local_irq_disable();
 		list_splice_init(&per_cpu(blk_cpu_done, cpu),
-				 &__get_cpu_var(blk_cpu_done));
+				 this_cpu_ptr(&blk_cpu_done));
 		raise_softirq_irqoff(BLOCK_SOFTIRQ);
 		local_irq_enable();
 	}
@@ -135,7 +135,7 @@ void __blk_complete_request(struct reque
 	if (ccpu == cpu || shared) {
 		struct list_head *list;
 do_local:
-		list = &__get_cpu_var(blk_cpu_done);
+		list = this_cpu_ptr(&blk_cpu_done);
 		list_add_tail(&req->csd.list, list);
 
 		/*
Index: linux/fs/fscache/object.c
===================================================================
--- linux.orig/fs/fscache/object.c	2013-08-26 14:36:07.858875667 -0500
+++ linux/fs/fscache/object.c	2013-08-26 14:36:07.854875709 -0500
@@ -796,7 +796,7 @@ void fscache_enqueue_object(struct fscac
  */
 bool fscache_object_sleep_till_congested(signed long *timeoutp)
 {
-	wait_queue_head_t *cong_wq = &__get_cpu_var(fscache_object_cong_wait);
+	wait_queue_head_t *cong_wq = this_cpu_ptr(&fscache_object_cong_wait);
 	DEFINE_WAIT(wait);
 
 	if (fscache_object_congested())

