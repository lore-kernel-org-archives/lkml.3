Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757675AbaEIVFs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 17:05:48 -0400
Received: from mail-qg0-f50.google.com ([209.85.192.50]:48883 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757463AbaEIVFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 17:05:46 -0400
Date: Fri, 9 May 2014 17:05:43 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Doug Anderson <dianders@chromium.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Will Deacon <will.deacon@arm.com>,
        John Stultz <john.stultz@linaro.org>,
        David Riley <davidriley@chromium.org>,
        "olof@lixom.net" <olof@lixom.net>, Sonny Rao <sonnyrao@chromium.org>,
        Richard Zhao <richard.zhao@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Shawn Guo <shawn.guo@linaro.org>, Stephen Boyd <sboyd@codeaurora.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Stephen Warren <swarren@nvidia.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: Don't ever downscale loops_per_jiffy in SMP
 systems#
In-Reply-To: <20140509182245.GM3693@n2100.arm.linux.org.uk>
Message-ID: <alpine.LFD.2.11.1405091640090.980@knanqh.ubzr>
References: <CAD=FV=UEGJGHrdcXgs3EZ_wFXT8GnNeCOMt7CgdiiUzBzZ5Y0A@mail.gmail.com> <alpine.LFD.2.11.1405081149190.980@knanqh.ubzr> <CAD=FV=VtcLOh51LCmafzRMdqtDrwKXCqK6gE6V7OOOUe4gjwbA@mail.gmail.com> <alpine.LFD.2.11.1405081329010.980@knanqh.ubzr>
 <20140508192209.GH3693@n2100.arm.linux.org.uk> <alpine.LFD.2.11.1405081600260.980@knanqh.ubzr> <20140508205223.GI3693@n2100.arm.linux.org.uk> <alpine.LFD.2.11.1405082058130.980@knanqh.ubzr> <20140509091824.GL3693@n2100.arm.linux.org.uk>
 <alpine.LFD.2.11.1405091245070.980@knanqh.ubzr> <20140509182245.GM3693@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 May 2014, Russell King - ARM Linux wrote:

> I'd much prefer just printing a warning at kernel boot time to report
> that the kernel is running with features which would make udelay() less
> than accurate.

What if there is simply no timer to rely upon, as in those cases where 
interrupts are needed for time keeping to make progress?  We should do 
better than simply saying "sorry your kernel should irradicate every 
udelay() usage to be reliable".

And I mean "reliable" which is not exactly the same as "accurate".  
Reliable means "never *significantly* shorter".

> Remember, it should be usable for _short_ delays on slow machines as
> well as other stuff, and if we're going to start throwing stuff like
> the above at it, it's going to become very inefficient.

You said that udelay can be much longer than expected due to various 
reasons.

You also said that the IRQ handler overhead during udelay calibration 
makes actual delays slightli shorter than expected.

I'm suggesting the addition of a slight overhead that is much smaller 
than the IRQ handler here.  That shouldn't impact things masurably.  
I'd certainly like Doug to run his udelay timing test with the following 
patch to see if it solves the problem.

diff --git a/arch/arm/include/asm/delay.h b/arch/arm/include/asm/delay.h
index dff714d886..74fb571a55 100644
--- a/arch/arm/include/asm/delay.h
+++ b/arch/arm/include/asm/delay.h
@@ -57,11 +57,6 @@ extern void __bad_udelay(void);
 			__const_udelay((n) * UDELAY_MULT)) :		\
 	  __udelay(n))
 
-/* Loop-based definitions for assembly code. */
-extern void __loop_delay(unsigned long loops);
-extern void __loop_udelay(unsigned long usecs);
-extern void __loop_const_udelay(unsigned long);
-
 /* Delay-loop timer registration. */
 #define ARCH_HAS_READ_CURRENT_TIMER
 extern void register_current_timer_delay(const struct delay_timer *timer);
diff --git a/arch/arm/lib/delay.c b/arch/arm/lib/delay.c
index 5306de3501..9150d31c2d 100644
--- a/arch/arm/lib/delay.c
+++ b/arch/arm/lib/delay.c
@@ -25,6 +25,11 @@
 #include <linux/module.h>
 #include <linux/timex.h>
 
+/* Loop-based definitions for assembly code. */
+extern void __loop_delay(unsigned long loops);
+extern void __loop_udelay(unsigned long usecs);
+extern void __loop_const_udelay(unsigned long);
+
 /*
  * Default to the loop-based delay implementation.
  */
@@ -34,6 +39,85 @@ struct arm_delay_ops arm_delay_ops = {
 	.udelay		= __loop_udelay,
 };
 
+#if defined(CONFIG_CPU_FREQ) && (defined(CONFIG_SMP) || defined(CONFIG_PREEMPT))
+
+#include <linux/cpufreq.h>
+
+/*
+ * Another CPU/thread might increase the CPU clock in the middle of
+ * the loop based delay routine and the newly scaled LPJ value won't be
+ * accounted for, resulting in a possibly significantly shorter delay than
+ * expected.  Let's make sure this occurrence is trapped and compensated.
+ */
+
+static int __loop_seq;
+static unsigned int __loop_security_factor;
+
+#define __safe_loop_(type) \
+static void __safe_loop_##type(unsigned long val) \
+{ \
+	int seq_count = __loop_seq; \
+	__loop_##type(val); \
+	if (seq_count != __loop_seq) \
+		__loop_##type(val * __loop_security_factor); \
+}
+
+__safe_loop_(delay)
+__safe_loop_(const_udelay)
+__safe_loop_(udelay)
+
+static int cpufreq_callback(struct notifier_block *nb,
+			    unsigned long val, void *data)
+{
+	struct cpufreq_freqs *freq = data;
+	unsigned int f;
+
+	if ((freq->flags & CPUFREQ_CONST_LOOPS) ||
+	    freq->old >= freq->new)
+		return NOTIFY_OK;
+
+	switch (val) {
+	case CPUFREQ_PRECHANGE:
+		/* Remember the largest security factor ever needed */
+		f = DIV_ROUND_UP(freq->new, freq->old) - 1;
+		if (__loop_security_factor < f)
+			__loop_security_factor = f;
+		/* fallthrough */
+	case CPUFREQ_POSTCHANGE:
+		__loop_seq++;
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block cpufreq_notifier = {
+	.notifier_call  = cpufreq_callback,
+};
+
+static int __init init_safe_loop_delays(void)
+{
+	int err;
+
+	/*
+	 * Bail out if the default loop based implementation has
+	 * already been replaced by something better.
+	 */
+	if (arm_delay_ops.udelay != __loop_udelay)
+		return 0;
+
+	__loop_security_factor = 1;
+	err = cpufreq_register_notifier(&cpufreq_notifier,
+					CPUFREQ_TRANSITION_NOTIFIER);
+	if (!err) {
+		arm_delay_ops.delay		= __safe_loop_delay;
+		arm_delay_ops.const_udelay	= __safe_loop_const_udelay;
+		arm_delay_ops.udelay		= __safe_loop_udelay;
+	}
+	return err;
+}
+core_initcall(init_safe_loop_delays);
+
+#endif
+
 static const struct delay_timer *delay_timer;
 static bool delay_calibrated;
 
