Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662Ab3HZVZv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 17:25:51 -0400
Received: from a194-110.smtp-out.amazonses.com ([199.255.194.110]:27262 "EHLO
	a194-110.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752214Ab3HZVZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 17:25:49 -0400
X-Greylist: delayed 571 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Aug 2013 17:25:49 EDT
Message-Id: <00000140bc7bfb6c-aba98d04-0ee5-42f9-9eb3-54ea66a26e84-000000@email.amazonses.com>
User-Agent: quilt/0.50-1
Date: Mon, 26 Aug 2013 21:16:17 +0000
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>
Cc: linux-arch@vger.kernel.org
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [guv v2 26/31] alpha: Replace __get_cpu_var
References: <20130826204351.725357339@linux.com>
X-SES-Outgoing: 199.255.194.110
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




Index: linux/arch/alpha/kernel/perf_event.c
===================================================================
--- linux.orig/arch/alpha/kernel/perf_event.c	2013-08-26 13:55:35.904436503 -0500
+++ linux/arch/alpha/kernel/perf_event.c	2013-08-26 13:55:35.896436587 -0500
@@ -422,7 +422,7 @@ static void maybe_change_configuration(s
  */
 static int alpha_pmu_add(struct perf_event *event, int flags)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
 	int n0;
 	int ret;
@@ -474,7 +474,7 @@ static int alpha_pmu_add(struct perf_eve
  */
 static void alpha_pmu_del(struct perf_event *event, int flags)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
 	unsigned long irq_flags;
 	int j;
@@ -522,7 +522,7 @@ static void alpha_pmu_read(struct perf_e
 static void alpha_pmu_stop(struct perf_event *event, int flags)
 {
 	struct hw_perf_event *hwc = &event->hw;
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 
 	if (!(hwc->state & PERF_HES_STOPPED)) {
 		cpuc->idx_mask &= ~(1UL<<hwc->idx);
@@ -542,7 +542,7 @@ static void alpha_pmu_stop(struct perf_e
 static void alpha_pmu_start(struct perf_event *event, int flags)
 {
 	struct hw_perf_event *hwc = &event->hw;
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 
 	if (WARN_ON_ONCE(!(hwc->state & PERF_HES_STOPPED)))
 		return;
@@ -713,7 +713,7 @@ static int alpha_pmu_event_init(struct p
  */
 static void alpha_pmu_enable(struct pmu *pmu)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 
 	if (cpuc->enabled)
 		return;
@@ -739,7 +739,7 @@ static void alpha_pmu_enable(struct pmu
 
 static void alpha_pmu_disable(struct pmu *pmu)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 
 	if (!cpuc->enabled)
 		return;
@@ -804,7 +804,7 @@ static void alpha_perf_event_irq_handler
 	int idx, j;
 
 	__this_cpu_inc(irq_pmi_count);
-	cpuc = &__get_cpu_var(cpu_hw_events);
+	cpuc = this_cpu_ptr(&cpu_hw_events);
 
 	/* Completely counting through the PMC's period to trigger a new PMC
 	 * overflow interrupt while in this interrupt routine is utterly
Index: linux/arch/alpha/kernel/time.c
===================================================================
--- linux.orig/arch/alpha/kernel/time.c	2013-08-26 13:55:35.904436503 -0500
+++ linux/arch/alpha/kernel/time.c	2013-08-26 13:55:35.896436587 -0500
@@ -86,9 +86,9 @@ unsigned long est_cycle_freq;
 
 DEFINE_PER_CPU(u8, irq_work_pending);
 
-#define set_irq_work_pending_flag()  __get_cpu_var(irq_work_pending) = 1
-#define test_irq_work_pending()      __get_cpu_var(irq_work_pending)
-#define clear_irq_work_pending()     __get_cpu_var(irq_work_pending) = 0
+#define set_irq_work_pending_flag()  __this_cpu_write(irq_work_pending, 1)
+#define test_irq_work_pending()      __this_cpu_read(irq_work_pending)
+#define clear_irq_work_pending()     __this_cpu_writeirq_work_pending, 0)
 
 void arch_irq_work_raise(void)
 {

