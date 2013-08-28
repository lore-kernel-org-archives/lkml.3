Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130Ab3H1N5y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 09:57:54 -0400
Received: from a9-62.smtp-out.amazonses.com ([54.240.9.62]:58734 "EHLO
	a9-62.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753621Ab3H1N5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 09:57:52 -0400
X-Greylist: delayed 682 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Aug 2013 09:57:52 EDT
Date: Wed, 28 Aug 2013 13:46:28 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
cc: Tejun Heo <tj@kernel.org>,
        "akpm@linuxfoundation.org" <akpm@linuxfoundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: [guv v2 28/31] arc: Replace __get_cpu_var uses throughout the
 kernel
In-Reply-To: <C2D7FE5348E1B147BCA15975FBA23075140D73@IN01WEMBXA.internal.synopsys.com>
Message-ID: <00000140c52ce057-1a54cd79-c1df-4a59-a050-179620acf4df-000000@email.amazonses.com>
References: <20130826204351.725357339@linux.com> <00000140bca09c39-5b837fed-8e34-417d-a62d-031f0b5c8107-000000@email.amazonses.com> <521C2A9F.3070400@synopsys.com> <00000140c05d28b7-f0a2bc86-fe85-40f7-b627-32664cd616a4-000000@email.amazonses.com>
 <C2D7FE5348E1B147BCA15975FBA23075140D73@IN01WEMBXA.internal.synopsys.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.08.28-54.240.9.62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Aug 2013, Vineet Gupta wrote:

> On 08/27/2013 08:51 PM, Christoph Lameter wrote:
> > On Tue, 27 Aug 2013, Vineet Gupta wrote:
> >
> >> The other thread about merging logistics doesn't seem to have concluded yet so for
> >> now I'll let it sit with you - please let me know if it needs to be routed via the
> >> arc tree.
> > Please route via the arc tree. I will marge the last patch when all the
> > bits are in.
> >
>
> Done - although it is missing you SOB line ?

Sorry about that. Here is an updated version

Subject: arc: Replace __get_cpu_var uses
Cc: Vineet Gupta <vgupta@synopsys.com>

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

	memcpy(this_cpu_ptr(&x), y, sizeof(x));


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



Acked-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/arch/arc/kernel/kprobes.c
===================================================================
--- linux.orig/arch/arc/kernel/kprobes.c	2013-08-26 13:28:53.000000000 -0500
+++ linux/arch/arc/kernel/kprobes.c	2013-08-26 13:29:19.285103021 -0500
@@ -87,13 +87,13 @@ static void __kprobes save_previous_kpro

 static void __kprobes restore_previous_kprobe(struct kprobe_ctlblk *kcb)
 {
-	__get_cpu_var(current_kprobe) = kcb->prev_kprobe.kp;
+	__this_cpu_write(current_kprobe, kcb->prev_kprobe.kp);
 	kcb->kprobe_status = kcb->prev_kprobe.status;
 }

 static inline void __kprobes set_current_kprobe(struct kprobe *p)
 {
-	__get_cpu_var(current_kprobe) = p;
+	__this_cpu_write(current_kprobe, p);
 }

 static void __kprobes resume_execution(struct kprobe *p, unsigned long addr,
@@ -237,7 +237,7 @@ int __kprobes arc_kprobe_handler(unsigne

 		return 1;
 	} else if (kprobe_running()) {
-		p = __get_cpu_var(current_kprobe);
+		p = __this_cpu_read(current_kprobe);
 		if (p->break_handler && p->break_handler(p, regs)) {
 			setup_singlestep(p, regs);
 			kcb->kprobe_status = KPROBE_HIT_SS;
Index: linux/arch/arc/kernel/time.c
===================================================================
--- linux.orig/arch/arc/kernel/time.c	2013-08-26 13:28:53.000000000 -0500
+++ linux/arch/arc/kernel/time.c	2013-08-26 13:29:19.285103021 -0500
@@ -206,7 +206,7 @@ static DEFINE_PER_CPU(struct clock_event

 static irqreturn_t timer_irq_handler(int irq, void *dev_id)
 {
-	struct clock_event_device *clk = &__get_cpu_var(arc_clockevent_device);
+	struct clock_event_device *clk = this_cpu_ptr(&arc_clockevent_device);

 	arc_timer_event_ack(clk->mode == CLOCK_EVT_MODE_PERIODIC);
 	clk->event_handler(clk);
