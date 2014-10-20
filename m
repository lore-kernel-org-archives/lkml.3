Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900AbaJTTEP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 15:04:15 -0400
Received: from mail-ie0-f201.google.com ([209.85.223.201]:47561 "EHLO
	mail-ie0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbaJTTEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 15:04:09 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Ralf Baechle <ralf@linux-mips.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Paul Burton <paul.burton@imgtec.com>,
        Qais Yousef <qais.yousef@imgtec.com>,
        John Crispin <blogic@openwrt.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 01/19] MIPS: Malta: Use gic_read_count() to read GIC timer
Date: Mon, 20 Oct 2014 12:03:48 -0700
Message-Id: <1413831846-32100-2-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1413831846-32100-1-git-send-email-abrestic@chromium.org>
References: <1413831846-32100-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of reading the GIC registers directly, use the interface the GIC
driver already exposes for reading the global timer.  Also get rid of
the unnecessary #ifdefs.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 arch/mips/mti-malta/malta-time.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/arch/mips/mti-malta/malta-time.c b/arch/mips/mti-malta/malta-time.c
index f6ca8ea..39f3902 100644
--- a/arch/mips/mti-malta/malta-time.c
+++ b/arch/mips/mti-malta/malta-time.c
@@ -70,9 +70,7 @@ static void __init estimate_frequencies(void)
 {
 	unsigned long flags;
 	unsigned int count, start;
-#ifdef CONFIG_MIPS_GIC
-	unsigned int giccount = 0, gicstart = 0;
-#endif
+	cycle_t giccount = 0, gicstart = 0;
 
 #if defined(CONFIG_KVM_GUEST) && CONFIG_KVM_GUEST_TIMER_FREQ
 	mips_hpt_frequency = CONFIG_KVM_GUEST_TIMER_FREQ * 1000000;
@@ -87,32 +85,26 @@ static void __init estimate_frequencies(void)
 
 	/* Initialize counters. */
 	start = read_c0_count();
-#ifdef CONFIG_MIPS_GIC
 	if (gic_present)
-		GICREAD(GIC_REG(SHARED, GIC_SH_COUNTER_31_00), gicstart);
-#endif
+		gicstart = gic_read_count();
 
 	/* Read counter exactly on falling edge of update flag. */
 	while (CMOS_READ(RTC_REG_A) & RTC_UIP);
 	while (!(CMOS_READ(RTC_REG_A) & RTC_UIP));
 
 	count = read_c0_count();
-#ifdef CONFIG_MIPS_GIC
 	if (gic_present)
-		GICREAD(GIC_REG(SHARED, GIC_SH_COUNTER_31_00), giccount);
-#endif
+		giccount = gic_read_count();
 
 	local_irq_restore(flags);
 
 	count -= start;
 	mips_hpt_frequency = count;
 
-#ifdef CONFIG_MIPS_GIC
 	if (gic_present) {
 		giccount -= gicstart;
 		gic_frequency = giccount;
 	}
-#endif
 }
 
 void read_persistent_clock(struct timespec *ts)
-- 
2.1.0.rc2.206.gedb03e5

