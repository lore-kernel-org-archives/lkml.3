Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbaDYJb3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 05:31:29 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:24920 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751502AbaDYJbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 05:31:22 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Cc: Russell King <linux@arm.linux.org.uk>, Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: [PATCH 5/7] rtc-cmos: implement driver private locking
Date: Fri, 25 Apr 2014 10:31:13 +0100
Message-Id: <1398418275-9671-6-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1398418275-9671-1-git-send-email-marc.zyngier@arm.com>
References: <1398418275-9671-1-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A number of architecture happen to share a lock between the rtc-cmos
driver and the core architectural code for good reasons (or at least,
reasons that matter to the architecture).

Other architectures don't do that, but still have to define a lock
that is only used by the RTC driver. How annoying!

Implement a set of driver private locking primitives, and expose
a config option allowing the architecture to select it if it doesn't
require to share the lock with the RTC driver.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/rtc/Kconfig       |  3 +++
 drivers/rtc/rtc-cmos.c    | 16 ++++++++++++++++
 include/asm-generic/rtc.h |  5 +++++
 3 files changed, 24 insertions(+)

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 10974f7..12bc27d 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -684,6 +684,9 @@ config RTC_DRV_CMOS_MMIO_STRICT
 	select RTC_DRV_CMOS_MMIO
 	bool
 
+config RTC_DRV_CMOS_PRIV_LOCK
+	bool
+
 config RTC_DRV_ALPHA
 	bool "Alpha PC-style CMOS"
 	depends on ALPHA
diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index e2d1338..eb5d05c 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -107,6 +107,22 @@ static inline void rtc_cmos_set_base(void __iomem *base)
 static void rtc_cmos_set_base(void __iomem *base) {}
 #endif
 
+#ifdef CONFIG_RTC_DRV_CMOS_PRIV_LOCK
+static DEFINE_SPINLOCK(rtc_private_lock);
+
+static unsigned long rtc_cmos_lock(void)
+{
+	unsigned long flags;
+	spin_lock_irqsave(&rtc_private_lock, flags);
+	return flags;
+}
+
+static void rtc_cmos_unlock(unsigned long flags)
+{
+	spin_unlock_irqrestore(&rtc_private_lock, flags);
+}
+#endif
+
 /* The RTC_INTR register may have e.g. RTC_PF set even if RTC_PIE is clear;
  * always mask it against the irq enable bits in RTC_CONTROL.  Bit values
  * are the same: PF==PIE, AF=AIE, UF=UIE; so RTC_IRQMASK works with both.
diff --git a/include/asm-generic/rtc.h b/include/asm-generic/rtc.h
index 236693b..1d21408 100644
--- a/include/asm-generic/rtc.h
+++ b/include/asm-generic/rtc.h
@@ -43,6 +43,10 @@ static inline void do_cmos_write(u8 val, u8 reg)
 }
 #endif
 
+#ifdef CONFIG_RTC_DRV_CMOS_PRIV_LOCK
+static unsigned long rtc_cmos_lock(void);
+static void rtc_cmos_unlock(unsigned long flags);
+#else
 static inline unsigned long rtc_cmos_lock(void)
 {
 	unsigned long flags;
@@ -54,6 +58,7 @@ static inline void rtc_cmos_unlock(unsigned long flags)
 {
 	spin_unlock_irqrestore(&rtc_lock, flags);
 }
+#endif
 
 /*
  * Returns true if a clock update is in progress
-- 
1.8.3.4

