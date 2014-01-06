Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197AbaAFXB2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:01:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48552 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933227AbaAFWmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:42:03 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Rob Herring <rob.herring@calxeda.com>, Mark Brown <broonie@kernel.org>
Subject: [PATCH 3.10 126/129] clocksource: arch_timer: use virtual counters
Date: Mon,  6 Jan 2014 14:39:15 -0800
Message-Id: <20140106223903.201063932@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223859.589799655@linuxfoundation.org>
References: <20140106223859.589799655@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rutland <mark.rutland@arm.com>

commit 0d651e4e65e96989f72236bf83bd4c6e55eb6ce4 upstream.

Switching between reading the virtual or physical counters is
problematic, as some core code wants a view of time before we're fully
set up. Using a function pointer and switching the source after the
first read can make time appear to go backwards, and having a check in
the read function is an unfortunate block on what we want to be a fast
path.

Instead, this patch makes us always use the virtual counters. If we're a
guest, or don't have hyp mode, we'll use the virtual timers, and as such
don't care about CNTVOFF as long as it doesn't change in such a way as
to make time appear to travel backwards. As the guest will use the
virtual timers, a (potential) KVM host must use the physical timers
(which can wake up the host even if they fire while a guest is
executing), and hence a host must have CNTVOFF set to zero so as to have
a consistent view of time between the physical timers and virtual
counters.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/include/asm/arch_timer.h    |    9 ---------
 arch/arm64/include/asm/arch_timer.h  |   10 ----------
 drivers/clocksource/arm_arch_timer.c |   23 +++++------------------
 include/clocksource/arm_arch_timer.h |    2 +-
 4 files changed, 6 insertions(+), 38 deletions(-)

--- a/arch/arm/include/asm/arch_timer.h
+++ b/arch/arm/include/asm/arch_timer.h
@@ -80,15 +80,6 @@ static inline u32 arch_timer_get_cntfrq(
 	return val;
 }
 
-static inline u64 arch_counter_get_cntpct(void)
-{
-	u64 cval;
-
-	isb();
-	asm volatile("mrrc p15, 0, %Q0, %R0, c14" : "=r" (cval));
-	return cval;
-}
-
 static inline u64 arch_counter_get_cntvct(void)
 {
 	u64 cval;
--- a/arch/arm64/include/asm/arch_timer.h
+++ b/arch/arm64/include/asm/arch_timer.h
@@ -110,16 +110,6 @@ static inline void __cpuinit arch_counte
 	asm volatile("msr	cntkctl_el1, %0" : : "r" (cntkctl));
 }
 
-static inline u64 arch_counter_get_cntpct(void)
-{
-	u64 cval;
-
-	isb();
-	asm volatile("mrs %0, cntpct_el0" : "=r" (cval));
-
-	return cval;
-}
-
 static inline u64 arch_counter_get_cntvct(void)
 {
 	u64 cval;
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -186,27 +186,19 @@ u32 arch_timer_get_rate(void)
 	return arch_timer_rate;
 }
 
-/*
- * Some external users of arch_timer_read_counter (e.g. sched_clock) may try to
- * call it before it has been initialised. Rather than incur a performance
- * penalty checking for initialisation, provide a default implementation that
- * won't lead to time appearing to jump backwards.
- */
-static u64 arch_timer_read_zero(void)
+u64 arch_timer_read_counter(void)
 {
-	return 0;
+	return arch_counter_get_cntvct();
 }
 
-u64 (*arch_timer_read_counter)(void) = arch_timer_read_zero;
-
 static cycle_t arch_counter_read(struct clocksource *cs)
 {
-	return arch_timer_read_counter();
+	return arch_counter_get_cntvct();
 }
 
 static cycle_t arch_counter_read_cc(const struct cyclecounter *cc)
 {
-	return arch_timer_read_counter();
+	return arch_counter_get_cntvct();
 }
 
 static struct clocksource clocksource_counter = {
@@ -287,7 +279,7 @@ static int __init arch_timer_register(vo
 	cyclecounter.mult = clocksource_counter.mult;
 	cyclecounter.shift = clocksource_counter.shift;
 	timecounter_init(&timecounter, &cyclecounter,
-			 arch_counter_get_cntpct());
+			 arch_counter_get_cntvct());
 
 	if (arch_timer_use_virtual) {
 		ppi = arch_timer_ppi[VIRT_PPI];
@@ -376,11 +368,6 @@ static void __init arch_timer_init(struc
 		}
 	}
 
-	if (arch_timer_use_virtual)
-		arch_timer_read_counter = arch_counter_get_cntvct;
-	else
-		arch_timer_read_counter = arch_counter_get_cntpct;
-
 	arch_timer_register();
 	arch_timer_arch_init();
 }
--- a/include/clocksource/arm_arch_timer.h
+++ b/include/clocksource/arm_arch_timer.h
@@ -32,7 +32,7 @@
 #ifdef CONFIG_ARM_ARCH_TIMER
 
 extern u32 arch_timer_get_rate(void);
-extern u64 (*arch_timer_read_counter)(void);
+extern u64 arch_timer_read_counter(void);
 extern struct timecounter *arch_timer_get_timecounter(void);
 
 #else


