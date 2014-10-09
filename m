Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805AbaJITPk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 15:15:40 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:34865 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbaJITMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 15:12:31 -0400
X-Google-Original-Sender: <johan@hovold.com>
From: Johan Hovold <johan@kernel.org>
To: Alessandro Zummo <a.zummo@towertech.it>, Tony Lindgren <tony@atomide.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Felipe Balbi <balbi@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, Guenter Roeck <linux@roeck-us.net>,
        Colin Foe-Parker <colin.foeparker@logicpd.com>,
        AnilKumar Ch <anilkumar@ti.com>, nsekhar@ti.com, t-kristo@ti.com,
        j-keerthy@ti.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 09/12] rtc: omap: add support for pmic_power_en
Date: Thu,  9 Oct 2014 21:06:31 +0200
Message-Id: <1412881594-25678-10-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1412881594-25678-1-git-send-email-johan@kernel.org>
References: <1412881594-25678-1-git-send-email-johan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add new property "ti,system-power-controller" to register the RTC as a
power-off handler.

Some RTC IP revisions can control an external PMIC via the pmic_power_en
pin, which can be configured to transition to OFF on ALARM2 events and
back to ON on subsequent ALARM (wakealarm) events.

This is based on earlier work by Colin Foe-Parker and AnilKumar Ch. [1]

[1] https://www.mail-archive.com/linux-omap@vger.kernel.org/msg82127.html

Signed-off-by: Johan Hovold <johan@kernel.org>
---
 Documentation/devicetree/bindings/rtc/rtc-omap.txt |   9 +-
 drivers/rtc/rtc-omap.c                             | 107 ++++++++++++++++++++-
 2 files changed, 110 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/rtc/rtc-omap.txt b/Documentation/devicetree/bindings/rtc/rtc-omap.txt
index 5a0f02d34d95..750efd40c72e 100644
--- a/Documentation/devicetree/bindings/rtc/rtc-omap.txt
+++ b/Documentation/devicetree/bindings/rtc/rtc-omap.txt
@@ -5,11 +5,17 @@ Required properties:
 	- "ti,da830-rtc"  - for RTC IP used similar to that on DA8xx SoC family.
 	- "ti,am3352-rtc" - for RTC IP used similar to that on AM335x SoC family.
 			    This RTC IP has special WAKE-EN Register to enable
-			    Wakeup generation for event Alarm.
+			    Wakeup generation for event Alarm. It can also be
+			    used to control an external PMIC via the
+			    pmic_power_en pin.
 - reg: Address range of rtc register set
 - interrupts: rtc timer, alarm interrupts in order
 - interrupt-parent: phandle for the interrupt controller
 
+Optional properties:
+- ti,system-power-controller: whether the rtc is controlling the system power
+  through pmic_power_en
+
 Example:
 
 rtc@1c23000 {
@@ -18,4 +24,5 @@ rtc@1c23000 {
 	interrupts = <19
 		      19>;
 	interrupt-parent = <&intc>;
+	ti,system-power-controller;
 };
diff --git a/drivers/rtc/rtc-omap.c b/drivers/rtc/rtc-omap.c
index 62e2e9a9887a..b0319864dd42 100644
--- a/drivers/rtc/rtc-omap.c
+++ b/drivers/rtc/rtc-omap.c
@@ -70,6 +70,15 @@
 
 #define OMAP_RTC_IRQWAKEEN		0x7c
 
+#define OMAP_RTC_ALARM2_SECONDS_REG	0x80
+#define OMAP_RTC_ALARM2_MINUTES_REG	0x84
+#define OMAP_RTC_ALARM2_HOURS_REG	0x88
+#define OMAP_RTC_ALARM2_DAYS_REG	0x8c
+#define OMAP_RTC_ALARM2_MONTHS_REG	0x90
+#define OMAP_RTC_ALARM2_YEARS_REG	0x94
+
+#define OMAP_RTC_PMIC_REG		0x98
+
 /* OMAP_RTC_CTRL_REG bit fields: */
 #define OMAP_RTC_CTRL_SPLIT		BIT(7)
 #define OMAP_RTC_CTRL_DISABLE		BIT(6)
@@ -82,6 +91,7 @@
 
 /* OMAP_RTC_STATUS_REG bit fields: */
 #define OMAP_RTC_STATUS_POWER_UP	BIT(7)
+#define OMAP_RTC_STATUS_ALARM2		BIT(7)
 #define OMAP_RTC_STATUS_ALARM		BIT(6)
 #define OMAP_RTC_STATUS_1D_EVENT	BIT(5)
 #define OMAP_RTC_STATUS_1H_EVENT	BIT(4)
@@ -91,6 +101,7 @@
 #define OMAP_RTC_STATUS_BUSY		BIT(0)
 
 /* OMAP_RTC_INTERRUPTS_REG bit fields: */
+#define OMAP_RTC_INTERRUPTS_IT_ALARM2	BIT(4)
 #define OMAP_RTC_INTERRUPTS_IT_ALARM	BIT(3)
 #define OMAP_RTC_INTERRUPTS_IT_TIMER	BIT(2)
 
@@ -100,6 +111,9 @@
 /* OMAP_RTC_IRQWAKEEN bit fields: */
 #define OMAP_RTC_IRQWAKEEN_ALARM_WAKEEN	BIT(1)
 
+/* OMAP_RTC_PMIC bit fields: */
+#define OMAP_RTC_PMIC_POWER_EN_EN	BIT(16)
+
 /* OMAP_RTC_KICKER values */
 #define	KICK0_VALUE			0x83e70b13
 #define	KICK1_VALUE			0x95a4f1e0
@@ -124,11 +138,18 @@
  */
 #define OMAP_RTC_HAS_POWER_UP_RESET	BIT(3)
 
+/*
+ * Some RTC IP revisions can control an external PMIC via the pmic_power_en
+ * pin.
+ */
+#define OMAP_RTC_HAS_PMIC_MODE		BIT(4)
+
 static void __iomem	*rtc_base;
 
 #define rtc_read(addr)		readb(rtc_base + (addr))
 #define rtc_write(val, addr)	writeb(val, rtc_base + (addr))
 
+#define rtc_readl(addr)		readl(rtc_base + (addr))
 #define rtc_writel(val, addr)	writel(val, rtc_base + (addr))
 
 
@@ -338,6 +359,61 @@ static int omap_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alm)
 	return 0;
 }
 
+static struct platform_device *omap_rtc_power_off_dev;
+
+/*
+ * omap_rtc_poweroff: RTC-controlled power off
+ *
+ * The RTC can be used to control an external PMIC via the pmic_power_en pin,
+ * which can be configured to transition to OFF on ALARM2 events.
+ *
+ * Notes:
+ * The two-second alarm offset is the shortest offset possible as the alarm
+ * registers must be set before the next timer update and the offset
+ * calculation is to heavy for everything to be done within a single access
+ * period (~15us).
+ *
+ * Called with local interrupts disabled.
+ */
+static void omap_rtc_power_off(void)
+{
+	struct rtc_time tm;
+	unsigned long now;
+	u32 val;
+
+	/* enable pmic_power_en control */
+	val = rtc_readl(OMAP_RTC_PMIC_REG);
+	rtc_writel(val | OMAP_RTC_PMIC_POWER_EN_EN, OMAP_RTC_PMIC_REG);
+
+	/* set alarm two seconds from now */
+	omap_rtc_read_time(&omap_rtc_power_off_dev->dev, &tm);
+	rtc_tm_to_time(&tm, &now);
+	rtc_time_to_tm(now + 2, &tm);
+
+	if (tm2bcd(&tm) < 0) {
+		pr_err("%s - power off failed\n", __func__);
+		return;
+	}
+
+	rtc_wait_not_busy();
+
+	rtc_write(tm.tm_sec, OMAP_RTC_ALARM2_SECONDS_REG);
+	rtc_write(tm.tm_min, OMAP_RTC_ALARM2_MINUTES_REG);
+	rtc_write(tm.tm_hour, OMAP_RTC_ALARM2_HOURS_REG);
+	rtc_write(tm.tm_mday, OMAP_RTC_ALARM2_DAYS_REG);
+	rtc_write(tm.tm_mon, OMAP_RTC_ALARM2_MONTHS_REG);
+	rtc_write(tm.tm_year, OMAP_RTC_ALARM2_YEARS_REG);
+
+	/*
+	 * enable ALARM2 interrupt
+	 *
+	 * NOTE: this fails on AM3352 if rtc_write (writeb) is used
+	 */
+	val = rtc_read(OMAP_RTC_INTERRUPTS_REG);
+	rtc_writel(val | OMAP_RTC_INTERRUPTS_IT_ALARM2,
+			OMAP_RTC_INTERRUPTS_REG);
+}
+
 static struct rtc_class_ops omap_rtc_ops = {
 	.read_time	= omap_rtc_read_time,
 	.set_time	= omap_rtc_set_time,
@@ -360,7 +436,7 @@ static struct platform_device_id omap_rtc_devtype[] = {
 	[OMAP_RTC_DATA_AM3352_IDX] = {
 		.name	= "am3352-rtc",
 		.driver_data = OMAP_RTC_HAS_KICKER | OMAP_RTC_HAS_IRQWAKEEN |
-			       OMAP_RTC_HAS_32KCLK_EN,
+			       OMAP_RTC_HAS_32KCLK_EN | OMAP_RTC_HAS_PMIC_MODE,
 	},
 	[OMAP_RTC_DATA_DA830_IDX] = {
 		.name	= "da830-rtc",
@@ -386,12 +462,16 @@ static int __init omap_rtc_probe(struct platform_device *pdev)
 	struct resource		*res;
 	struct rtc_device	*rtc;
 	u8			reg, mask, new_ctrl;
+	bool			pm_off = false;
 	const struct platform_device_id *id_entry;
 	const struct of_device_id *of_id;
 
 	of_id = of_match_device(omap_rtc_of_match, &pdev->dev);
-	if (of_id)
+	if (of_id) {
 		pdev->id_entry = of_id->data;
+		pm_off = of_property_read_bool(pdev->dev.of_node,
+				"ti,system-power-controller");
+	}
 
 	id_entry = platform_get_device_id(pdev);
 	if (!id_entry) {
@@ -425,10 +505,12 @@ static int __init omap_rtc_probe(struct platform_device *pdev)
 		rtc_writel(KICK1_VALUE, OMAP_RTC_KICK1_REG);
 	}
 
-	/* clear pending irqs, and set 1/second periodic,
-	 * which we'll use instead of update irqs
+	/*
+	 * disable interrupts
+	 *
+	 * NOTE: ALARM2 is not cleared on AM3352 if rtc_write (writeb) is used
 	 */
-	rtc_write(0, OMAP_RTC_INTERRUPTS_REG);
+	rtc_writel(0, OMAP_RTC_INTERRUPTS_REG);
 
 	/* enable RTC functional clock */
 	if (id_entry->driver_data & OMAP_RTC_HAS_32KCLK_EN) {
@@ -440,6 +522,8 @@ static int __init omap_rtc_probe(struct platform_device *pdev)
 	reg = rtc_read(OMAP_RTC_STATUS_REG);
 
 	mask = OMAP_RTC_STATUS_ALARM;
+	if (id_entry->driver_data & OMAP_RTC_HAS_PMIC_MODE)
+		mask |= OMAP_RTC_STATUS_ALARM2;
 	if (id_entry->driver_data & OMAP_RTC_HAS_POWER_UP_RESET) {
 		mask |= OMAP_RTC_STATUS_POWER_UP;
 		if (reg & OMAP_RTC_STATUS_POWER_UP)
@@ -502,6 +586,13 @@ static int __init omap_rtc_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, rtc);
 
+	if (id_entry->driver_data & OMAP_RTC_HAS_PMIC_MODE) {
+		if (pm_off && !pm_power_off) {
+			omap_rtc_power_off_dev = pdev;
+			pm_power_off = omap_rtc_power_off;
+		}
+	}
+
 	return 0;
 
 fail0:
@@ -518,6 +609,12 @@ static int __exit omap_rtc_remove(struct platform_device *pdev)
 	const struct platform_device_id *id_entry =
 				platform_get_device_id(pdev);
 
+	if (pm_power_off == omap_rtc_power_off &&
+			omap_rtc_power_off_dev == pdev) {
+		pm_power_off = NULL;
+		omap_rtc_power_off_dev = NULL;
+	}
+
 	device_init_wakeup(&pdev->dev, 0);
 
 	/* leave rtc running, but disable irqs */
-- 
2.0.4

