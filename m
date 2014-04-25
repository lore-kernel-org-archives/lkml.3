Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbaDYJb1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 05:31:27 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:24903 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751075AbaDYJbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 05:31:21 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Cc: Russell King <linux@arm.linux.org.uk>, Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: [PATCH 3/7] rtc-cmos: allow MMIO to be used when initialized from FDT
Date: Fri, 25 Apr 2014 10:31:11 +0100
Message-Id: <1398418275-9671-4-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1398418275-9671-1-git-send-email-marc.zyngier@arm.com>
References: <1398418275-9671-1-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, rtc-cmos mandates the use of an I/O port. If the
resource obtained from the device tree is instead a memory mapped
range, the probing will fail.

Let the cmos_of_init function try to ioremap the range obtained
from FDT. Should this fail, fallback to the normal I/O port.

Tested on KVM/ARM with kvmtools as the backend for RTC emulation.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/rtc/Kconfig       |  3 +++
 drivers/rtc/rtc-cmos.c    | 67 ++++++++++++++++++++++++++++++++++++++++++-----
 include/asm-generic/rtc.h |  5 ++++
 3 files changed, 68 insertions(+), 7 deletions(-)

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 2e565f8..7e88866 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -677,6 +677,9 @@ config RTC_DRV_CMOS
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-cmos.
 
+config RTC_DRV_CMOS_MMIO
+	bool
+
 config RTC_DRV_ALPHA
 	bool "Alpha PC-style CMOS"
 	depends on ALPHA
diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index be2dd17..d535e72 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -37,6 +37,7 @@
 #include <linux/log2.h>
 #include <linux/pm.h>
 #include <linux/of.h>
+#include <linux/of_address.h>
 #include <linux/of_platform.h>
 #include <linux/dmi.h>
 
@@ -66,6 +67,41 @@ struct cmos_rtc {
 
 static const char driver_name[] = "rtc_cmos";
 
+#ifdef CONFIG_RTC_DRV_CMOS_MMIO
+static void __iomem *rtc_cmos_base;
+
+static u8 do_cmos_read(u8 reg)
+{
+	u8 val;
+
+	if (rtc_cmos_base) {
+		writeb(reg, rtc_cmos_base);
+		val = readb(rtc_cmos_base + 1);
+	} else {
+		val = CMOS_READ(reg);
+	}
+
+	return val;
+}
+
+static void do_cmos_write(u8 val, u8 reg)
+{
+	if (rtc_cmos_base) {
+		writeb(reg, rtc_cmos_base);
+		writeb(val, rtc_cmos_base + 1);
+	} else {
+		CMOS_WRITE(val, reg);
+	}
+}
+
+static inline void rtc_cmos_set_base(void __iomem *base)
+{
+	rtc_cmos_base = base;
+}
+#else
+static void rtc_cmos_set_base(void __iomem *base) {}
+#endif
+
 /* The RTC_INTR register may have e.g. RTC_PF set even if RTC_PIE is clear;
  * always mask it against the irq enable bits in RTC_CONTROL.  Bit values
  * are the same: PF==PIE, AF=AIE, UF=UIE; so RTC_IRQMASK works with both.
@@ -663,13 +699,23 @@ cmos_do_probe(struct device *dev, struct resource *ports, int rtc_irq)
 		return -ENODEV;
 
 	/* Claim I/O ports ASAP, minimizing conflict with legacy driver.
-	 *
-	 * REVISIT non-x86 systems may instead use memory space resources
-	 * (needing ioremap etc), not i/o space resources like this ...
+	 * MMIO gets requested the same way, not that it matters much.
 	 */
-	ports = request_region(ports->start,
-			resource_size(ports),
-			driver_name);
+	switch(resource_type(ports)) {
+	case IORESOURCE_IO:
+		ports = request_region(ports->start,
+				       resource_size(ports),
+				       driver_name);
+		break;
+	case IORESOURCE_MEM:
+		ports = request_mem_region(ports->start,
+					   resource_size(ports),
+					   driver_name);
+		break;
+	default:		/* Martian I/O??? */
+		ports = NULL;
+	}
+
 	if (!ports) {
 		dev_dbg(dev, "i/o registers already in use\n");
 		return -EBUSY;
@@ -1160,10 +1206,17 @@ static inline void cmos_of_init(struct platform_device *pdev) {}
 
 static int __init cmos_platform_probe(struct platform_device *pdev)
 {
+	struct resource *ports;
+
 	cmos_of_init(pdev);
+
+	ports = platform_get_resource(pdev, IORESOURCE_IO, 0);
+	if (!ports)
+		ports = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+
 	cmos_wake_setup(&pdev->dev);
 	return cmos_do_probe(&pdev->dev,
-			platform_get_resource(pdev, IORESOURCE_IO, 0),
+			ports,
 			platform_get_irq(pdev, 0));
 }
 
diff --git a/include/asm-generic/rtc.h b/include/asm-generic/rtc.h
index 1ad3e78..236693b 100644
--- a/include/asm-generic/rtc.h
+++ b/include/asm-generic/rtc.h
@@ -28,6 +28,10 @@
 #define RTC_24H 0x02		/* 24 hour mode - else hours bit 7 means pm */
 #define RTC_DST_EN 0x01	        /* auto switch DST - works f. USA only */
 
+#ifdef CONFIG_RTC_DRV_CMOS_MMIO
+static u8 do_cmos_read(u8 reg);
+static void do_cmos_write(u8 val, u8 reg);
+#else
 static inline u8 do_cmos_read(u8 reg)
 {
 	return CMOS_READ(reg);
@@ -37,6 +41,7 @@ static inline void do_cmos_write(u8 val, u8 reg)
 {
 	CMOS_WRITE(val, reg);
 }
+#endif
 
 static inline unsigned long rtc_cmos_lock(void)
 {
-- 
1.8.3.4

