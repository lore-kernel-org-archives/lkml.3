Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762629AbbA2ClS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:41:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47065 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762434AbbA2Cix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:38:53 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sonny Rao <sonnyrao@chromium.org>, Olof Johansson <olof@lixom.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 085/139] clocksource: arch_timer: Fix code to use physical timers when requested
Date: Wed, 28 Jan 2015 14:20:28 -0800
Message-Id: <1422483682-15393-86-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

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
[ kamal: backport to 3.13-stable: context ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/include/asm/arch_timer.h    |  9 +++++++++
 arch/arm64/include/asm/arch_timer.h  |  9 +++++++++
 drivers/clocksource/arm_arch_timer.c | 10 +++++++---
 3 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/arch/arm/include/asm/arch_timer.h b/arch/arm/include/asm/arch_timer.h
index 0704e0c..e72aa4d 100644
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
index 9400596..6abb872 100644
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
index 95fb944..46884f8 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -426,10 +426,14 @@ static void __init arch_counter_register(unsigned type)
 	u64 start_count;
 
 	/* Register the CP15 based counter if we have one */
-	if (type & ARCH_CP15_TIMER)
-		arch_timer_read_counter = arch_counter_get_cntvct;
-	else
+	if (type & ARCH_CP15_TIMER) {
+		if (arch_timer_use_virtual)
+			arch_timer_read_counter = arch_counter_get_cntvct;
+		else
+			arch_timer_read_counter = arch_counter_get_cntpct;
+	} else {
 		arch_timer_read_counter = arch_counter_get_cntvct_mem;
+	}
 
 	start_count = arch_timer_read_counter();
 	clocksource_register_hz(&clocksource_counter, arch_timer_rate);
-- 
1.9.1

