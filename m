Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204Ab3LMC3e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 21:29:34 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:45294 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043Ab3LMC33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 21:29:29 -0500
From: Sergei Ianovich <ynvich@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Sergei Ianovich <ynvich@gmail.com>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Grant Likely <grant.likely@linaro.org>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...),
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        rtc-linux@googlegroups.com
Subject: [PATCH v2 07/16] rtc: support DS1302 RTC on ICP DAS LP-8x4x
Date: Fri, 13 Dec 2013 06:27:16 +0400
Message-Id: <1386901645-28895-8-git-send-email-ynvich@gmail.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1386901645-28895-1-git-send-email-ynvich@gmail.com>
References: <1386543229-1542-1-git-send-email-ynvich@gmail.com>
 <1386901645-28895-1-git-send-email-ynvich@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sergei Ianovich <ynvich@gmail.com>
---
   v0..v2
   * use device tree
   * use devm helpers where possible

 .../devicetree/bindings/rtc/rtc-ds1302.txt         |  14 +++
 arch/arm/boot/dts/pxa27x-lp8x4x.dts                |   6 ++
 arch/arm/configs/lp8x4x_defconfig                  |   1 +
 drivers/rtc/Kconfig                                |   2 +-
 drivers/rtc/rtc-ds1302.c                           | 111 ++++++++++++++++++++-
 5 files changed, 131 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/rtc/rtc-ds1302.txt

diff --git a/Documentation/devicetree/bindings/rtc/rtc-ds1302.txt b/Documentation/devicetree/bindings/rtc/rtc-ds1302.txt
new file mode 100644
index 0000000..876297c
--- /dev/null
+++ b/Documentation/devicetree/bindings/rtc/rtc-ds1302.txt
@@ -0,0 +1,14 @@
+* Dallas Semiconductor DS-1302 RTC
+
+Simple device which could be used to store date/time between reboots.
+
+Required properties:
+- compatible : Should be "ds,rtc-ds1302"
+- reg : Should be address and size of IO memory region
+
+Examples:
+
+rtc@40900000 {
+	compatible = "ds,rtc-ds1302";
+	reg = <0x1700901c 0x1>;
+};
diff --git a/arch/arm/boot/dts/pxa27x-lp8x4x.dts b/arch/arm/boot/dts/pxa27x-lp8x4x.dts
index a2a9183..574e853 100644
--- a/arch/arm/boot/dts/pxa27x-lp8x4x.dts
+++ b/arch/arm/boot/dts/pxa27x-lp8x4x.dts
@@ -107,5 +107,11 @@
 			interrupts = <82 IRQ_TYPE_EDGE_RISING>;
 			status = "okay";
 		};
+
+		rtc@1700901c {
+			compatible = "ds,rtc-ds1302";
+			reg = <0x1700901c 0x1>;
+			status = "okay";
+		};
 	};
 };
diff --git a/arch/arm/configs/lp8x4x_defconfig b/arch/arm/configs/lp8x4x_defconfig
index 4421c03..57f2830 100644
--- a/arch/arm/configs/lp8x4x_defconfig
+++ b/arch/arm/configs/lp8x4x_defconfig
@@ -133,6 +133,7 @@ CONFIG_USB_SERIAL=m
 CONFIG_MMC=y
 CONFIG_MMC_PXA=y
 CONFIG_RTC_CLASS=y
+CONFIG_RTC_DRV_DS1302=y
 CONFIG_RTC_DRV_PXA=m
 # CONFIG_IOMMU_SUPPORT is not set
 CONFIG_EXT2_FS=m
diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 0077302..501055f 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -676,7 +676,7 @@ config RTC_DRV_DS1286
 
 config RTC_DRV_DS1302
 	tristate "Dallas DS1302"
-	depends on SH_SECUREEDGE5410
+	depends on SH_SECUREEDGE5410 || (ARCH_PXA && HIGH_RES_TIMERS)
 	help
 	  If you say yes here you get support for the Dallas DS1302 RTC chips.
 
diff --git a/drivers/rtc/rtc-ds1302.c b/drivers/rtc/rtc-ds1302.c
index 07e8d79..d88749c 100644
--- a/drivers/rtc/rtc-ds1302.c
+++ b/drivers/rtc/rtc-ds1302.c
@@ -50,7 +50,7 @@
 #define ds1302_set_tx()
 #define ds1302_set_rx()
 
-static inline int ds1302_hw_init(void)
+static inline int ds1302_hw_init(struct platform_device *pdev)
 {
 	return 0;
 }
@@ -86,6 +86,112 @@ static inline int ds1302_rxbit(void)
 	return !!(get_dp() & RTC_IODATA);
 }
 
+#elif defined(CONFIG_ARCH_PXA) && defined(CONFIG_HIGH_RES_TIMERS)
+
+#include <linux/hrtimer.h>
+#include <linux/of.h>
+#include <linux/sched.h>
+
+#define	RTC_CE		0x01
+#define	RTC_CLK		0x02
+#define	RTC_nWE		0x04
+#define	RTC_IODATA	0x08
+
+static unsigned long ds1302_state;
+
+static void *mem;
+
+void nsleep(unsigned long nanosec)
+{
+	ktime_t t = ns_to_ktime(nanosec);
+	long state = current->state;
+
+	__set_current_state(TASK_UNINTERRUPTIBLE);
+	schedule_hrtimeout(&t, HRTIMER_MODE_REL);
+	__set_current_state(state);
+}
+
+static inline int ds1302_hw_init(struct platform_device *pdev)
+{
+	struct resource *r;
+
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!r)
+		return -ENODEV;
+
+	mem = devm_ioremap_resource(&pdev->dev, r);
+	if (!mem)
+		return -EFAULT;
+
+	return 0;
+}
+
+static inline void ds1302_reset(void)
+{
+	ds1302_state = 0;
+	iowrite8(ds1302_state, mem);
+	nsleep(4000);
+}
+
+static inline void ds1302_clock(void)
+{
+	nsleep(1000);
+	ds1302_state |= RTC_CLK;
+	iowrite8(ds1302_state, mem);
+	nsleep(1000);
+	ds1302_state &= ~RTC_CLK;
+	iowrite8(ds1302_state, mem);
+}
+
+static inline void ds1302_start(void)
+{
+	ds1302_state &= ~RTC_CLK;
+	ds1302_state |= RTC_CE;
+	iowrite8(ds1302_state, mem);
+	nsleep(3000);
+}
+
+static inline void ds1302_stop(void)
+{
+	ds1302_state &= ~RTC_CE;
+	iowrite8(ds1302_state, mem);
+}
+
+static inline void ds1302_set_tx(void)
+{
+	ds1302_state &= ~RTC_nWE;
+	iowrite8(ds1302_state, mem);
+}
+
+static inline void ds1302_set_rx(void)
+{
+	ds1302_state |= RTC_nWE;
+	iowrite8(ds1302_state, mem);
+}
+
+static inline void ds1302_txbit(int bit)
+{
+	if (bit)
+		ds1302_state |= RTC_IODATA;
+	else
+		ds1302_state &= ~RTC_IODATA;
+	iowrite8(ds1302_state, mem);
+}
+
+static inline int ds1302_rxbit(void)
+{
+	return ioread8(mem) & 0x1;
+}
+
+#ifdef CONFIG_OF
+static const struct of_device_id ds1302_dt_ids[] = {
+	{ .compatible = "ds,rtc-ds1302" },
+	{ }
+};
+
+MODULE_DEVICE_TABLE(of, ds1302_dt_ids);
+#endif
+
 #else
 #error "Add support for your platform"
 #endif
@@ -216,7 +322,7 @@ static int __init ds1302_rtc_probe(struct platform_device *pdev)
 {
 	struct rtc_device *rtc;
 
-	if (ds1302_hw_init()) {
+	if (ds1302_hw_init(pdev)) {
 		dev_err(&pdev->dev, "Failed to init communication channel");
 		return -EINVAL;
 	}
@@ -245,6 +351,7 @@ static struct platform_driver ds1302_platform_driver = {
 	.driver		= {
 		.name	= DRV_NAME,
 		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(ds1302_dt_ids),
 	},
 };
 
-- 
1.8.4.3

