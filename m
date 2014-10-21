Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111AbaJURsM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 13:48:12 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:38856 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755618AbaJURsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 13:48:07 -0400
X-Google-Original-Sender: <johan@hovold.com>
From: Johan Hovold <johan@kernel.org>
To: Alessandro Zummo <a.zummo@towertech.it>, Tony Lindgren <tony@atomide.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Felipe Balbi <balbi@ti.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Lokesh Vutla <lokeshvutla@ti.com>, Guenter Roeck <linux@roeck-us.net>,
        nsekhar@ti.com, t-kristo@ti.com, j-keerthy@ti.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH v2 15/20] rtc: omap: add support for pmic_power_en
Date: Tue, 21 Oct 2014 19:38:01 +0200
Message-Id: <1413913086-12730-16-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1413913086-12730-1-git-send-email-johan@kernel.org>
References: <1412881594-25678-1-git-send-email-johan@kernel.org>
 <1413913086-12730-1-git-send-email-johan@kernel.org>
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
 Documentation/devicetree/bindings/rtc/rtc-omap.txt |  9 ++-
 drivers/rtc/rtc-omap.c                             | 93 ++++++++++++++++++++++
 2 files changed, 101 insertions(+), 1 deletion(-)

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
index c508e45ca3ce..f6c93f877857 100644
--- a/drivers/rtc/rtc-omap.c
+++ b/drivers/rtc/rtc-omap.c
@@ -68,6 +68,15 @@
 
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
@@ -80,6 +89,7 @@
 
 /* OMAP_RTC_STATUS_REG bit fields: */
 #define OMAP_RTC_STATUS_POWER_UP	BIT(7)
+#define OMAP_RTC_STATUS_ALARM2		BIT(7)
 #define OMAP_RTC_STATUS_ALARM		BIT(6)
 #define OMAP_RTC_STATUS_1D_EVENT	BIT(5)
 #define OMAP_RTC_STATUS_1H_EVENT	BIT(4)
@@ -89,6 +99,7 @@
 #define OMAP_RTC_STATUS_BUSY		BIT(0)
 
 /* OMAP_RTC_INTERRUPTS_REG bit fields: */
+#define OMAP_RTC_INTERRUPTS_IT_ALARM2	BIT(4)
 #define OMAP_RTC_INTERRUPTS_IT_ALARM	BIT(3)
 #define OMAP_RTC_INTERRUPTS_IT_TIMER	BIT(2)
 
@@ -98,6 +109,9 @@
 /* OMAP_RTC_IRQWAKEEN bit fields: */
 #define OMAP_RTC_IRQWAKEEN_ALARM_WAKEEN	BIT(1)
 
+/* OMAP_RTC_PMIC bit fields: */
+#define OMAP_RTC_PMIC_POWER_EN_EN	BIT(16)
+
 /* OMAP_RTC_KICKER values */
 #define	KICK0_VALUE			0x83e70b13
 #define	KICK1_VALUE			0x95a4f1e0
@@ -106,6 +120,7 @@ struct omap_rtc_device_type {
 	bool has_32kclk_en;
 	bool has_kicker;
 	bool has_irqwakeen;
+	bool has_pmic_mode;
 	bool has_power_up_reset;
 };
 
@@ -115,6 +130,7 @@ struct omap_rtc {
 	int irq_alarm;
 	int irq_timer;
 	u8 interrupts_reg;
+	bool is_pmic_controller;
 	const struct omap_rtc_device_type *type;
 };
 
@@ -345,6 +361,63 @@ static int omap_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alm)
 	return 0;
 }
 
+static struct omap_rtc *omap_rtc_power_off_rtc;
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
+ * calculation is too heavy for everything to be done within a single access
+ * period (~15us).
+ *
+ * Called with local interrupts disabled.
+ */
+static void omap_rtc_power_off(void)
+{
+	struct omap_rtc *rtc = omap_rtc_power_off_rtc;
+	struct rtc_time tm;
+	unsigned long now;
+	u32 val;
+
+	/* enable pmic_power_en control */
+	val = rtc_readl(rtc, OMAP_RTC_PMIC_REG);
+	rtc_writel(rtc, OMAP_RTC_PMIC_REG, val | OMAP_RTC_PMIC_POWER_EN_EN);
+
+	/* set alarm two seconds from now */
+	omap_rtc_read_time_raw(rtc, &tm);
+	bcd2tm(&tm);
+	rtc_tm_to_time(&tm, &now);
+	rtc_time_to_tm(now + 2, &tm);
+
+	if (tm2bcd(&tm) < 0) {
+		dev_err(&rtc->rtc->dev, "power off failed\n");
+		return;
+	}
+
+	rtc_wait_not_busy(rtc);
+
+	rtc_write(rtc, OMAP_RTC_ALARM2_SECONDS_REG, tm.tm_sec);
+	rtc_write(rtc, OMAP_RTC_ALARM2_MINUTES_REG, tm.tm_min);
+	rtc_write(rtc, OMAP_RTC_ALARM2_HOURS_REG, tm.tm_hour);
+	rtc_write(rtc, OMAP_RTC_ALARM2_DAYS_REG, tm.tm_mday);
+	rtc_write(rtc, OMAP_RTC_ALARM2_MONTHS_REG, tm.tm_mon);
+	rtc_write(rtc, OMAP_RTC_ALARM2_YEARS_REG, tm.tm_year);
+
+	/*
+	 * enable ALARM2 interrupt
+	 *
+	 * NOTE: this fails on AM3352 if rtc_write (writeb) is used
+	 */
+	val = rtc_read(rtc, OMAP_RTC_INTERRUPTS_REG);
+	rtc_writel(rtc, OMAP_RTC_INTERRUPTS_REG,
+			val | OMAP_RTC_INTERRUPTS_IT_ALARM2);
+}
+
 static struct rtc_class_ops omap_rtc_ops = {
 	.read_time	= omap_rtc_read_time,
 	.set_time	= omap_rtc_set_time,
@@ -361,6 +434,7 @@ static const struct omap_rtc_device_type omap_rtc_am3352_type = {
 	.has_32kclk_en	= true,
 	.has_kicker	= true,
 	.has_irqwakeen	= true,
+	.has_pmic_mode	= true,
 };
 
 static const struct omap_rtc_device_type omap_rtc_da830_type = {
@@ -412,6 +486,9 @@ static int __init omap_rtc_probe(struct platform_device *pdev)
 	of_id = of_match_device(omap_rtc_of_match, &pdev->dev);
 	if (of_id) {
 		rtc->type = of_id->data;
+		rtc->is_pmic_controller = rtc->type->has_pmic_mode &&
+				of_property_read_bool(pdev->dev.of_node,
+						"ti,system-power-controller");
 	} else {
 		id_entry = platform_get_device_id(pdev);
 		rtc->type = (void *)id_entry->driver_data;
@@ -460,6 +537,9 @@ static int __init omap_rtc_probe(struct platform_device *pdev)
 
 	mask = OMAP_RTC_STATUS_ALARM;
 
+	if (rtc->type->has_pmic_mode)
+		mask |= OMAP_RTC_STATUS_ALARM2;
+
 	if (rtc->type->has_power_up_reset) {
 		mask |= OMAP_RTC_STATUS_POWER_UP;
 		if (reg & OMAP_RTC_STATUS_POWER_UP)
@@ -520,6 +600,13 @@ static int __init omap_rtc_probe(struct platform_device *pdev)
 			goto err;
 	}
 
+	if (rtc->is_pmic_controller) {
+		if (!pm_power_off) {
+			omap_rtc_power_off_rtc = rtc;
+			pm_power_off = omap_rtc_power_off;
+		}
+	}
+
 	return 0;
 
 err:
@@ -536,6 +623,12 @@ static int __exit omap_rtc_remove(struct platform_device *pdev)
 {
 	struct omap_rtc *rtc = platform_get_drvdata(pdev);
 
+	if (pm_power_off == omap_rtc_power_off &&
+			omap_rtc_power_off_rtc == rtc) {
+		pm_power_off = NULL;
+		omap_rtc_power_off_rtc = NULL;
+	}
+
 	device_init_wakeup(&pdev->dev, 0);
 
 	/* leave rtc running, but disable irqs */
-- 
2.0.4

