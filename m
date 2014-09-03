Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932557AbaICMkO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 08:40:14 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:44075 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932220AbaICMkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 08:40:12 -0400
From: Xia Kaixu <kaixu.xia@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: kaixu.xia@linaro.org, arnd@arndb.de, Imre Kaloz <kaloz@openwrt.org>,
        linaro-kernel@lists.linaro.org
Subject: [PATCH] ARM: cns3xxx: fix allmodconfig panic in pci driver
Date: Wed,  3 Sep 2014 20:39:22 +0800
Message-Id: <1409747962-23739-1-git-send-email-kaixu.xia@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <kaixu.xia@linaro.org>
References: <kaixu.xia@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xia Kaixu <kaixu.xia@linaro.org>

The kernel panic occurs when running an allmodconfig kernel on 
OMAP4460. The inicall "cns3xxx_pcie_init" does not check which
hardware it's running on and just tries to access to its specific 
registers. Now call it from .init_late callback from the two
machine descriptors.

Signed-off-by: Xia Kaixu <kaixu.xia@linaro.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Anton Vorontsov <anton@enomsg.org>
Cc: Felix Fietkau <nbd@openwrt.org>
Cc: Imre Kaloz <kaloz@openwrt.org>
Cc: linaro-kernel@lists.linaro.org
Cc: linux-arm-kernel@lists.infradead.org
---
 arch/arm/mach-cns3xxx/cns3420vb.c | 1 +
 arch/arm/mach-cns3xxx/core.c      | 1 +
 arch/arm/mach-cns3xxx/core.h      | 9 +++++++++
 arch/arm/mach-cns3xxx/pcie.c      | 3 +--
 4 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-cns3xxx/cns3420vb.c b/arch/arm/mach-cns3xxx/cns3420vb.c
index d863d87..99c74cc 100644
--- a/arch/arm/mach-cns3xxx/cns3420vb.c
+++ b/arch/arm/mach-cns3xxx/cns3420vb.c
@@ -250,5 +250,6 @@ MACHINE_START(CNS3420VB, "Cavium Networks CNS3420 Validation Board")
 	.init_irq	= cns3xxx_init_irq,
 	.init_time	= cns3xxx_timer_init,
 	.init_machine	= cns3420_init,
+	.init_late      = cns3xxx_pcie_init_late,
 	.restart	= cns3xxx_restart,
 MACHINE_END
diff --git a/arch/arm/mach-cns3xxx/core.c b/arch/arm/mach-cns3xxx/core.c
index f85449a..c2363bb 100644
--- a/arch/arm/mach-cns3xxx/core.c
+++ b/arch/arm/mach-cns3xxx/core.c
@@ -404,5 +404,6 @@ DT_MACHINE_START(CNS3XXX_DT, "Cavium Networks CNS3xxx")
 	.init_irq	= cns3xxx_init_irq,
 	.init_time	= cns3xxx_timer_init,
 	.init_machine	= cns3xxx_init,
+	.init_late	= cns3xxx_pcie_init_late,
 	.restart	= cns3xxx_restart,
 MACHINE_END
diff --git a/arch/arm/mach-cns3xxx/core.h b/arch/arm/mach-cns3xxx/core.h
index 5218b61..780689b 100644
--- a/arch/arm/mach-cns3xxx/core.h
+++ b/arch/arm/mach-cns3xxx/core.h
@@ -21,6 +21,15 @@ void __init cns3xxx_l2x0_init(void);
 static inline void cns3xxx_l2x0_init(void) {}
 #endif /* CONFIG_CACHE_L2X0 */
 
+#ifdef CONFIG_PCI
+extern int __init cns3xxx_pcie_init_late(void);
+#else
+static inline int __init cns3xxx_pcie_init_late(void)
+{
+	return -ENXIO;
+}
+#endif
+
 void __init cns3xxx_map_io(void);
 void __init cns3xxx_init_irq(void);
 void cns3xxx_power_off(void);
diff --git a/arch/arm/mach-cns3xxx/pcie.c b/arch/arm/mach-cns3xxx/pcie.c
index 413134c..bf2a4e8 100644
--- a/arch/arm/mach-cns3xxx/pcie.c
+++ b/arch/arm/mach-cns3xxx/pcie.c
@@ -318,7 +318,7 @@ static int cns3xxx_pcie_abort_handler(unsigned long addr, unsigned int fsr,
 	return 0;
 }
 
-static int __init cns3xxx_pcie_init(void)
+int __init cns3xxx_pcie_init_late(void)
 {
 	int i;
 
@@ -340,4 +340,3 @@ static int __init cns3xxx_pcie_init(void)
 
 	return 0;
 }
-device_initcall(cns3xxx_pcie_init);
-- 
1.8.5.5

