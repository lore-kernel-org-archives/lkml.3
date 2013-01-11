Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab3AKIx7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 03:53:59 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:43348 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212Ab3AKIx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 03:53:58 -0500
MIME-Version: 1.0
In-Reply-To: <1357566094.10284.83.camel@gandalf.local.home>
References: <1357207949-3349-1-git-send-email-kpark3469@gmail.com>
	<1357207949-3349-2-git-send-email-kpark3469@gmail.com>
	<20130103103815.GL2631@n2100.arm.linux.org.uk>
	<CA+KhAHbmjD7zTw+wcw84Abg3V1dD=0Ea4kUpYdGENQf1UOWphw@mail.gmail.com>
	<1357220165.10284.30.camel@gandalf.local.home>
	<20130103141301.GQ2631@n2100.arm.linux.org.uk>
	<1357229038.10284.46.camel@gandalf.local.home>
	<20130103162359.GR2631@n2100.arm.linux.org.uk>
	<1357232337.10284.67.camel@gandalf.local.home>
	<CA+KhAHYbDU0Ajr5uPEjPxX2ECitvnK2ENOjmqjC=3G657GvG7w@mail.gmail.com>
	<1357566094.10284.83.camel@gandalf.local.home>
Date: Fri, 11 Jan 2013 17:53:57 +0900
Message-ID: <CA+KhAHbOu8JxMuwajZYBAkex7pZag3oaTvz=EoLOQz5iZtUfsQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] arm: make return_address available for ARM_UNWIND
From: Keun-O Park <kpark3469@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, fweisbec@gmail.com,
        mingo@redhat.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, sahara <keun-o.park@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 7, 2013 at 10:41 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Fri, 2013-01-04 at 17:45 +0900, Keun-O Park wrote:
>
> > With "CFLAGS_REMOVE_unwind.o = -pg" and with CONFIG_PROVE_LOCKING
> > turned on, I confirmed that
> > there's no trace output like Steve mentioned.
> > However, if I turn off CONFIG_PROVE_LOCKING, "irqsoff" and
> > "preemptirqsoff" ftracer prints these lines :
> >
> > kernel_text_address <-unwind_frame
> > core_kernel_text <-unwind_frame
> > search_index <-unwind_frame
> >
> > While I investigated the reason, I just found out there's two function
> > with same name, trace_hardirqs_off.
> > One in kernel/trace/trace_irqsoff.c and another in kernel/lockdep.c.
> > And both symbols are exported.
> > I am wondering whether it is intentionally maintained code to
> > manipulate ftrace and lockdep or not.
> > I guess it's probably not.
>
> Both the irqsoff tracer from ftrace and lockdep came from the -rt patch.
> The two were very integrated at the time. When they were ported over to
> mainline, they still used the same infrastructure to hook into the
> locations of interrupts being disabled or enabled.
>
> trace_hardirqs_on/off() is the function that is called for both lockdep
> and ftrace's irqsoff tracer. So this was intentional. That way we didn't
> need to have two different callers at every location. But if lockdep
> isn't defined and ftrace irqsoff is, then ftrace would define the
> trace_hardirqs_on/off() routines, otherwise lockdep does. (These
> routines are within CONFIG_PROVE_LOCKING #ifdefs in
> kernel/trace/trace_irqsoff.c)
>
> When both lockdep and irqsoff tracer are configured, then lockdep
> defines the trace_hardirqs_off_caller(), and calls time_hardirqs_off()
> in trace_irqsoff.c which does the same thing as the trace_hardirqs_off()
> does without lockdep.
>
> I'm not sure why one would add the annotations while adding
> PROVE_LOCKING doesn't. They both seems to use CALLER_ADDR0, but maybe
> there's another path that uses CALLER_ADDR1 without it.
>
> -- Steve
>
>

Hello Steve,

Much obliged for your explaining this.
As your guess, there's another path that uses CALLER_ADDR1 without
CONFIG_PROVE_LOCKING though both lockdep and ftrace's irqsoff tracer
is turned on. In this case, ftrace's trace_hardirqs_on/off() would be
called.
And, as you said to me, if lockdep is off and ftrace's irqsoff is on,
ftrace's trace_hardirqs_on/off() would be called.
I think the proper way to avoid calling CALLER_ADDR1 will be calling
trace_hardirqs_off_caller() instead of calling stop_critical_timing()
directly in trace_hardirqs_off(). And, this will suppress the message
outputs of unwind_frame.
If you think this idea is okay, I will push the patch v2 to you.
In my test result, it looks it's functionally correct.

Thanks.

-- kpark


diff --git a/arch/arm/include/asm/ftrace.h b/arch/arm/include/asm/ftrace.h
index f89515a..3552ad9 100644
--- a/arch/arm/include/asm/ftrace.h
+++ b/arch/arm/include/asm/ftrace.h
@@ -32,13 +32,11 @@ extern void ftrace_call_old(void);

 #ifndef __ASSEMBLY__

-#if defined(CONFIG_FRAME_POINTER) && !defined(CONFIG_ARM_UNWIND)
+#if defined(CONFIG_FRAME_POINTER) || defined(CONFIG_ARM_UNWIND)
 /*
  * return_address uses walk_stackframe to do it's work.  If both
  * CONFIG_FRAME_POINTER=y and CONFIG_ARM_UNWIND=y walk_stackframe uses unwind
- * information.  For this to work in the function tracer many functions would
- * have to be marked with __notrace.  So for now just depend on
- * !CONFIG_ARM_UNWIND.
+ * information.
  */

 void *return_address(unsigned int);
diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
index 5bbec7b..675fd62 100644
--- a/arch/arm/kernel/Makefile
+++ b/arch/arm/kernel/Makefile
@@ -9,6 +9,9 @@ ifdef CONFIG_FUNCTION_TRACER
 CFLAGS_REMOVE_ftrace.o = -pg
 CFLAGS_REMOVE_insn.o = -pg
 CFLAGS_REMOVE_patch.o = -pg
+ifdef CONFIG_ARM_UNWIND
+CFLAGS_REMOVE_unwind.o = -pg
+endif
 endif

 CFLAGS_REMOVE_return_address.o = -pg
diff --git a/arch/arm/kernel/return_address.c b/arch/arm/kernel/return_address.c
index fafedd8..f202bc0 100644
--- a/arch/arm/kernel/return_address.c
+++ b/arch/arm/kernel/return_address.c
@@ -11,7 +11,7 @@
 #include <linux/export.h>
 #include <linux/ftrace.h>

-#if defined(CONFIG_FRAME_POINTER) && !defined(CONFIG_ARM_UNWIND)
+#if defined(CONFIG_FRAME_POINTER) || defined(CONFIG_ARM_UNWIND)
 #include <linux/sched.h>

 #include <asm/stacktrace.h>
@@ -57,17 +57,13 @@ void *return_address(unsigned int level)
 		return NULL;
 }

-#else /* if defined(CONFIG_FRAME_POINTER) && !defined(CONFIG_ARM_UNWIND) */
-
-#if defined(CONFIG_ARM_UNWIND)
-#warning "TODO: return_address should use unwind tables"
-#endif
+#else /* CONFIG_FRAME_POINTER || CONFIG_ARM_UNWIND */

 void *return_address(unsigned int level)
 {
 	return NULL;
 }

-#endif /* if defined(CONFIG_FRAME_POINTER) &&
!defined(CONFIG_ARM_UNWIND) / else */
+#endif /* CONFIG_FRAME_POINTER || CONFIG_ARM_UNWIND */

 EXPORT_SYMBOL_GPL(return_address);
diff --git a/arch/arm/kernel/stacktrace.c b/arch/arm/kernel/stacktrace.c
index 00f79e5..aab144b 100644
--- a/arch/arm/kernel/stacktrace.c
+++ b/arch/arm/kernel/stacktrace.c
@@ -6,6 +6,9 @@

 #if defined(CONFIG_FRAME_POINTER) && !defined(CONFIG_ARM_UNWIND)
 /*
+ * If both CONFIG_FRAME_POINTER=y and CONFIG_ARM_UNWIND=y walk_stackframe uses
+ * unwind information. So for now just depend on !CONFIG_ARM_UNWIND.
+ *
  * Unwind the current stack frame and store the new register values in the
  * structure passed as argument. Unwinding is equivalent to a function return,
  * hence the new PC value rather than LR should be used for backtrace.
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index 713a2ca..6f207ed 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -483,20 +483,6 @@ inline void print_irqtrace_events(struct task_struct *curr)
 /*
  * We are only interested in hardirq on/off events:
  */
-void trace_hardirqs_on(void)
-{
-	if (!preempt_trace() && irq_trace())
-		stop_critical_timing(CALLER_ADDR0, CALLER_ADDR1);
-}
-EXPORT_SYMBOL(trace_hardirqs_on);
-
-void trace_hardirqs_off(void)
-{
-	if (!preempt_trace() && irq_trace())
-		start_critical_timing(CALLER_ADDR0, CALLER_ADDR1);
-}
-EXPORT_SYMBOL(trace_hardirqs_off);
-
 void trace_hardirqs_on_caller(unsigned long caller_addr)
 {
 	if (!preempt_trace() && irq_trace())
@@ -504,6 +490,12 @@ void trace_hardirqs_on_caller(unsigned long caller_addr)
 }
 EXPORT_SYMBOL(trace_hardirqs_on_caller);

+void trace_hardirqs_on(void)
+{
+	trace_hardirqs_on_caller(CALLER_ADDR0);
+}
+EXPORT_SYMBOL(trace_hardirqs_on);
+
 void trace_hardirqs_off_caller(unsigned long caller_addr)
 {
 	if (!preempt_trace() && irq_trace())
@@ -511,6 +503,12 @@ void trace_hardirqs_off_caller(unsigned long caller_addr)
 }
 EXPORT_SYMBOL(trace_hardirqs_off_caller);

+void trace_hardirqs_off(void)
+{
+	trace_hardirqs_off_caller(CALLER_ADDR0);
+}
+EXPORT_SYMBOL(trace_hardirqs_off);
+
 #endif /* CONFIG_PROVE_LOCKING */
 #endif /*  CONFIG_IRQSOFF_TRACER */
