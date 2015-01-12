Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796AbbALSGg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:06:36 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57703 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703AbbALSGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:06:33 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sonny Rao <sonnyrao@chromium.org>, Olof Johansson <olof@lixom.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 088/216] clocksource: arch_timer: Fix code to use physical timers when requested
Date: Mon, 12 Jan 2015 18:03:25 +0000
Message-Id: <1421085933-32536-89-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sonny Rao <sonnyrao@chromium.org>

commit 0b46b8a718c6e90910a1b1b0fe797be3c167e186 upstream.

This is a bug fix for using physical arch timers when
the arch_timer_use_virtual boolean is false.  It restores the
arch_counter_get_cntpct() function after removal in

0d651e4e "clocksource: arch_timer: use virtual counters"

We need this on certain ARMv7 systems which are architected like this:

* The firmware doesn't know and doesn't care about hypervisor mode and
  we don't want to add the complexity of hypervisor there.

* The firmware isn't involved in SMP bringup or resume.

* The ARCH timer come up with an uninitialized offset between the
  virtual and physical counters.  Each core gets a different random
  offset.

* The device boots in "Secure SVC" mode.

* Nothing has touched the reset value of CNTHCTL.PL1PCEN or
  CNTHCTL.PL1PCTEN (both default to 1 at reset)

One example of such as system is RK3288 where it is much simpler to
use the physical counter since there's nobody managing the offset and
each time a core goes down and comes back up it will get reinitialized
to some other random value.

Fixes: 0d651e4e65e9 ("clocksource: arch_timer: use virtual counters")
Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Olof Johansson <olof@lixom.net>
[ luis: backported to 3.16: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/include/asm/arch_timer.h    | 9 +++++++++
 arch/arm64/include/asm/arch_timer.h  | 9 +++++++++
 drivers/clocksource/arm_arch_timer.c | 5 ++++-
 3 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/arch_timer.h b/arch/arm/include/asm/arch_timer.h
index 0704e0cf5571..e72aa4d802de 100644
--- a/arch/arm/include/asm/arch_timer.h
+++ b/arch/arm/include/asm/arch_timer.h
@@ -78,6 +78,15 @@ static inline u32 arch_timer_get_cntfrq(void)
 	return val;
 }
 
+static inline u64 arch_counter_get_cntpct(void)
+{
+	u64 cval;
+
+	isb();
+	asm volatile("mrrc p15, 0, %Q0, %R0, c14" : "=r" (cval));
+	return cval;
+}
+
 static inline u64 arch_counter_get_cntvct(void)
 {
 	u64 cval;
diff --git a/arch/arm64/include/asm/arch_timer.h b/arch/arm64/include/asm/arch_timer.h
index 9400596a0f39..6abb872b34d6 100644
--- a/arch/arm64/include/asm/arch_timer.h
+++ b/arch/arm64/include/asm/arch_timer.h
@@ -135,6 +135,15 @@ static inline void arch_timer_evtstrm_enable(int divider)
 #endif
 }
 
+static inline u64 arch_counter_get_cntpct(void)
+{
+	/*
+	 * AArch64 kernel and user space mandate the use of CNTVCT.
+	 */
+	BUG();
+	return 0;
+}
+
 static inline u64 arch_counter_get_cntvct(void)
 {
 	u64 cval;
diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index c99afdf12e98..506949d2e922 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -430,7 +430,10 @@ static void __init arch_counter_register(unsigned type)
 
 	/* Register the CP15 based counter if we have one */
 	if (type & ARCH_CP15_TIMER) {
-		arch_timer_read_counter = arch_counter_get_cntvct;
+		if (arch_timer_use_virtual)
+			arch_timer_read_counter = arch_counter_get_cntvct;
+		else
+			arch_timer_read_counter = arch_counter_get_cntpct;
 	} else {
 		arch_timer_read_counter = arch_counter_get_cntvct_mem;
 
-- 
2.1.4

