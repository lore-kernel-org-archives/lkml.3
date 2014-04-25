Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074AbaDYJf5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 05:35:57 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:24934 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752417AbaDYJbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 05:31:24 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Cc: Russell King <linux@arm.linux.org.uk>, Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: [PATCH 7/7] arm64: rtc: plug the PC CMOS RTC using MMIO accessors
Date: Fri, 25 Apr 2014 10:31:15 +0100
Message-Id: <1398418275-9671-8-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1398418275-9671-1-git-send-email-marc.zyngier@arm.com>
References: <1398418275-9671-1-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the now minimal gunk to enable the PC-style CMOS RTC.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/mc146818rtc.h | 10 ++++++++++
 drivers/rtc/Kconfig                  |  5 +++--
 drivers/rtc/rtc-cmos.c               |  2 +-
 3 files changed, 14 insertions(+), 3 deletions(-)
 create mode 100644 arch/arm64/include/asm/mc146818rtc.h

diff --git a/arch/arm64/include/asm/mc146818rtc.h b/arch/arm64/include/asm/mc146818rtc.h
new file mode 100644
index 0000000..79cc1f3
--- /dev/null
+++ b/arch/arm64/include/asm/mc146818rtc.h
@@ -0,0 +1,10 @@
+/*
+ * Machine dependent access functions for RTC registers.
+ * In the arm64 case, pretty much nothing.
+ */
+#ifndef __ARM64_MC146818RTC_H__
+#define __ARM64_MC146818RTC_H__
+
+#define RTC_ALWAYS_BCD	0
+
+#endif /* __ARM64_MC146818RTC_H__ */
diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index b2a512e..5944c92 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -660,10 +660,11 @@ comment "Platform RTC drivers"
 
 config RTC_DRV_CMOS
 	tristate "PC-style 'CMOS'"
-	depends on X86 || ARM || M32R || PPC || MIPS || SPARC64
+	depends on X86 || ARM || M32R || PPC || MIPS || SPARC64 || ARM64
 	default y if X86
 	select RTC_DRV_CMOS_MMIO if ARM
-	select RTC_DRV_CMOS_PRIV_LOCK if ARM
+	select RTC_DRV_CMOS_MMIO_STRICT if ARM64
+	select RTC_DRV_CMOS_PRIV_LOCK if (ARM || ARM64)
 	help
 	  Say "yes" here to get direct support for the real time clock
 	  found in every PC or ACPI-based system, and some other boards.
diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index eb5d05c..d84e3a5 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -754,7 +754,7 @@ cmos_do_probe(struct device *dev, struct resource *ports, int rtc_irq)
 	address_space = 64;
 #elif defined(__i386__) || defined(__x86_64__) || defined(__arm__) \
 			|| defined(__sparc__) || defined(__mips__) \
-			|| defined(__powerpc__)
+			|| defined(__powerpc__) || defined(CONFIG_ARM64)
 	address_space = 128;
 #else
 #warning Assuming 128 bytes of RTC+NVRAM address space, not 64 bytes.
-- 
1.8.3.4

