Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145AbbAEEvg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 23:51:36 -0500
Received: from mail-qg0-f41.google.com ([209.85.192.41]:62341 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838AbbAEEvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 23:51:35 -0500
Date: Sun, 4 Jan 2015 23:51:31 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Pavel Machek <pavel@ucw.cz>, Marc Zyngier <marc.zyngier@arm.com>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Revert 9fc2105aeaaf56b0cf75296a84702d0f9e64437b to fix
 pyaudio (and probably more)
In-Reply-To: <20150104212659.GC12302@n2100.arm.linux.org.uk>
Message-ID: <alpine.LFD.2.11.1501042343240.18844@knanqh.ubzr>
References: <20150104190123.GA20153@amd> <alpine.LFD.2.11.1501041438130.18844@knanqh.ubzr> <20150104201026.GA23427@amd> <alpine.LFD.2.11.1501041512440.18844@knanqh.ubzr> <20150104203724.GA16372@amd> <alpine.LFD.2.11.1501041547050.18844@knanqh.ubzr>
 <CA+55aFy5yB2d-1iXEUtU+puua4TAmV0kZF_7TBhXO1Y4Khqb9Q@mail.gmail.com> <alpine.LFD.2.11.1501041609290.18844@knanqh.ubzr> <20150104212659.GC12302@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Jan 2015, Russell King - ARM Linux wrote:

> On Sun, Jan 04, 2015 at 04:20:57PM -0500, Nicolas Pitre wrote:
> > On Sun, 4 Jan 2015, Linus Torvalds wrote:
> > 
> > > On Sun, Jan 4, 2015 at 12:56 PM, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> > > >
> > > > It wasted a lot of people's time before by simply being there and wrong
> > > > before it was removed.  It's only a matter of whose time you want to
> > > > waste.  Really.
> > > 
> > > Really. Shut up.
> > > 
> > > The whole "no regressions" thing is very much about the fact that we
> > > don't waste users time.
> > 
> > I was talking about users time all along.
> > 
> > Never mind.  I'm sorry for the NAK and sorry for attempting to start a 
> > discussion to find a better replacement.
> 
> Nico,
> 
> I encourage you *not* to back down like this.  Linus is right in so far
> as the regressions issue, but he is *totally* wrong to do the revert,
> which IMHO has been done out of nothing more than spite.
> 
> Either *with or without* the revert, the issue still remains, and needs
> to be addressed properly.
> 
> With the revert in place, we now have insanely small bogomips values
> reported via /proc/cpuinfo when hardware timers are used.  That needs
> fixing.

Here's my take on it.  Taking a step back, it was stupid to mix bogomips 
with timer based delays.

----- >8
From: Nicolas Pitre <nicolas.pitre@linaro.org>
Date: Sun, 4 Jan 2015 22:28:58 -0500
Subject: [PATCH] ARM: disentangle timer based delays and bogomips calibration

The bogomips value is a pseudo CPU speed value originally used to calibrate
loop-based small delays.  It is also exported to user space through the
/proc filesystem and some user space apps started relying on it.

Modern hardware can vary their CPU clock at run time making the bogomips
value less reliable for delay purposes. With the advent of high resolution
timers, small delays migrated to timer polling loops instead.  Strangely
enough, the bogomips value calibration became timer based too, making it
way more bogus than it already was as a CPU speed representation and people
using it via /proc/cpuinfo started complaining.

Since it was wrong for user space to rely on a "bogus" mips value to start
with, the initial responce from kernel people was to remove it.  This broke
user space even more as some applications then refused to run altogether.
The bogomips export was therefore reinstated in commit 4bf9636c39 ("Revert
'ARM: 7830/1: delay: don't bother reporting bogomips in /proc/cpuinfo'").

Because the reported bogomips is orders of magnitude away from the
traditionally expected value for a given CPU when timer based delays are
in use, and because lumping bogomips and timer based delay loops is rather
senseless anyway, let's calibrate bogomips using a CPU loop all the time
even when timer based delays are available.  Timer based delays don't
need any calibration and /proc/cpuinfo will provide somewhat sensible
values again.

In practice, calls to __delay() will now always use the CPU based loop.
Things remain unchanged for udelay() and its derivatives.

Signed-off-by: Nicolas Pitre <nico@linaro.org>

diff --git a/arch/arm/include/asm/delay.h b/arch/arm/include/asm/delay.h
index dff714d886..7feeb163f5 100644
--- a/arch/arm/include/asm/delay.h
+++ b/arch/arm/include/asm/delay.h
@@ -21,13 +21,12 @@ struct delay_timer {
 };
 
 extern struct arm_delay_ops {
-	void (*delay)(unsigned long);
 	void (*const_udelay)(unsigned long);
 	void (*udelay)(unsigned long);
 	unsigned long ticks_per_jiffy;
 } arm_delay_ops;
 
-#define __delay(n)		arm_delay_ops.delay(n)
+#define __delay(n)		__loop_delay(n)
 
 /*
  * This function intentionally does not exist; if you see references to
@@ -63,7 +62,6 @@ extern void __loop_udelay(unsigned long usecs);
 extern void __loop_const_udelay(unsigned long);
 
 /* Delay-loop timer registration. */
-#define ARCH_HAS_READ_CURRENT_TIMER
 extern void register_current_timer_delay(const struct delay_timer *timer);
 
 #endif /* __ASSEMBLY__ */
diff --git a/arch/arm/lib/delay.c b/arch/arm/lib/delay.c
index 312d43eb68..d958886874 100644
--- a/arch/arm/lib/delay.c
+++ b/arch/arm/lib/delay.c
@@ -30,7 +30,6 @@
  * Default to the loop-based delay implementation.
  */
 struct arm_delay_ops arm_delay_ops = {
-	.delay		= __loop_delay,
 	.const_udelay	= __loop_const_udelay,
 	.udelay		= __loop_udelay,
 };
@@ -86,12 +85,8 @@ void __init register_current_timer_delay(const struct delay_timer *timer)
 	if (!delay_calibrated && (!delay_res || (res < delay_res))) {
 		pr_info("Switching to timer-based delay loop, resolution %lluns\n", res);
 		delay_timer			= timer;
-		lpj_fine			= timer->freq / HZ;
 		delay_res			= res;
-
-		/* cpufreq may scale loops_per_jiffy, so keep a private copy */
-		arm_delay_ops.ticks_per_jiffy	= lpj_fine;
-		arm_delay_ops.delay		= __timer_delay;
+		arm_delay_ops.ticks_per_jiffy	= timer->freq / HZ;
 		arm_delay_ops.const_udelay	= __timer_const_udelay;
 		arm_delay_ops.udelay		= __timer_udelay;
 	} else {
@@ -102,7 +97,9 @@ void __init register_current_timer_delay(const struct delay_timer *timer)
 unsigned long calibrate_delay_is_known(void)
 {
 	delay_calibrated = true;
-	return lpj_fine;
+
+	/* calibrate bogomips even when timer based delays are used */
+	return 0;
 }
 
 void calibration_delay_done(void)
