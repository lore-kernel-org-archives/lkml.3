Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176AbaFLP7B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 11:59:01 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:3267 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088AbaFLP66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 11:58:58 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 12 Jun 2014 08:53:39 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: [PATCH v2 2/3] ARM: choose highest resolution delay timer
Date: Thu, 12 Jun 2014 18:58:28 +0300
Message-ID: <1402588713-18766-3-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1402588713-18766-1-git-send-email-pdeschrijver@nvidia.com>
References: <1402588713-18766-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case there are several possible delay timers, choose the one with the
highest resolution. This code relies on the fact secondary CPUs have not yet
been brought online when register_current_timer_delay() is called. This is
ensured by implementing calibration_delay_done(),

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 arch/arm/lib/delay.c |   26 ++++++++++++++++++++++----
 1 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/arch/arm/lib/delay.c b/arch/arm/lib/delay.c
index 5306de3..312d43e 100644
--- a/arch/arm/lib/delay.c
+++ b/arch/arm/lib/delay.c
@@ -19,6 +19,7 @@
  * Author: Will Deacon <will.deacon@arm.com>
  */
 
+#include <linux/clocksource.h>
 #include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -36,6 +37,7 @@ struct arm_delay_ops arm_delay_ops = {
 
 static const struct delay_timer *delay_timer;
 static bool delay_calibrated;
+static u64 delay_res;
 
 int read_current_timer(unsigned long *timer_val)
 {
@@ -47,6 +49,11 @@ int read_current_timer(unsigned long *timer_val)
 }
 EXPORT_SYMBOL_GPL(read_current_timer);
 
+static inline u64 cyc_to_ns(u64 cyc, u32 mult, u32 shift)
+{
+	return (cyc * mult) >> shift;
+}
+
 static void __timer_delay(unsigned long cycles)
 {
 	cycles_t start = get_cycles();
@@ -69,18 +76,24 @@ static void __timer_udelay(unsigned long usecs)
 
 void __init register_current_timer_delay(const struct delay_timer *timer)
 {
-	if (!delay_calibrated) {
-		pr_info("Switching to timer-based delay loop\n");
+	u32 new_mult, new_shift;
+	u64 res;
+
+	clocks_calc_mult_shift(&new_mult, &new_shift, timer->freq,
+			       NSEC_PER_SEC, 3600);
+	res = cyc_to_ns(1ULL, new_mult, new_shift);
+
+	if (!delay_calibrated && (!delay_res || (res < delay_res))) {
+		pr_info("Switching to timer-based delay loop, resolution %lluns\n", res);
 		delay_timer			= timer;
 		lpj_fine			= timer->freq / HZ;
+		delay_res			= res;
 
 		/* cpufreq may scale loops_per_jiffy, so keep a private copy */
 		arm_delay_ops.ticks_per_jiffy	= lpj_fine;
 		arm_delay_ops.delay		= __timer_delay;
 		arm_delay_ops.const_udelay	= __timer_const_udelay;
 		arm_delay_ops.udelay		= __timer_udelay;
-
-		delay_calibrated		= true;
 	} else {
 		pr_info("Ignoring duplicate/late registration of read_current_timer delay\n");
 	}
@@ -91,3 +104,8 @@ unsigned long calibrate_delay_is_known(void)
 	delay_calibrated = true;
 	return lpj_fine;
 }
+
+void calibration_delay_done(void)
+{
+	delay_calibrated = true;
+}
-- 
1.7.7.rc0.72.g4b5ea.dirty

