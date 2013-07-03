Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932550Ab3GCIqD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 04:46:03 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:34003 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932424Ab3GCIp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 04:45:28 -0400
From: Hebbar Gururaja <gururaja.hebbar@ti.com>
To: <khilman@linaro.org>, <tony@atomide.com>, <benoit.cousson@gmail.com>
CC: <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <vaibhav.bedia@ti.com>, <sudhakar.raj@ti.com>,
        <gururaja.hebbar@ti.com>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Alessandro Zummo <a.zummo@towertech.it>, <rtc-linux@googlegroups.com>,
        <linux-doc@vger.kernel.org>
Subject: [Patch V2 3/4] rtc: omap: add rtc wakeup support to alarm events
Date: Wed, 3 Jul 2013 14:17:04 +0530
Message-ID: <1372841225-18813-4-git-send-email-gururaja.hebbar@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1372841225-18813-1-git-send-email-gururaja.hebbar@ti.com>
References: <1372841225-18813-1-git-send-email-gururaja.hebbar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some platforms (like AM33xx), a special register (RTC_IRQWAKEEN)
is available to enable Alarm Wakeup feature. This register needs to be
properly handled for the rtcwake to work properly.

Platforms using such IP should set "ti,am3352-rtc" in rtc device dt
compatibility node.

Signed-off-by: Hebbar Gururaja <gururaja.hebbar@ti.com>
Acked-by: Kevin Hilman <khilman@linaro.org>
Acked-by: Sekhar Nori <nsekhar@ti.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Rob Landley <rob@landley.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com
Cc: devicetree-discuss@lists.ozlabs.org
Cc: linux-doc@vger.kernel.org
---
Changes in V2:
	- Coding style corrections (use lower case for hex numbers)
	- use "[AM/am]3352" instead of "[AM/am]335x" to keep the all
	  usages in sync.
	- Use index defined for struct members so they remain in sync

:100644 100644 b47aa41... 5a0f02d... M	Documentation/devicetree/bindings/rtc/rtc-omap.txt
:100644 100644 761919d... c2e18fe... M	drivers/rtc/rtc-omap.c
 Documentation/devicetree/bindings/rtc/rtc-omap.txt |    6 +-
 drivers/rtc/rtc-omap.c                             |   60 +++++++++++++++++---
 2 files changed, 57 insertions(+), 9 deletions(-)

diff --git a/Documentation/devicetree/bindings/rtc/rtc-omap.txt b/Documentation/devicetree/bindings/rtc/rtc-omap.txt
index b47aa41..5a0f02d 100644
--- a/Documentation/devicetree/bindings/rtc/rtc-omap.txt
+++ b/Documentation/devicetree/bindings/rtc/rtc-omap.txt
@@ -1,7 +1,11 @@
 TI Real Time Clock
 
 Required properties:
-- compatible: "ti,da830-rtc"
+- compatible:
+	- "ti,da830-rtc"  - for RTC IP used similar to that on DA8xx SoC family.
+	- "ti,am3352-rtc" - for RTC IP used similar to that on AM335x SoC family.
+			    This RTC IP has special WAKE-EN Register to enable
+			    Wakeup generation for event Alarm.
 - reg: Address range of rtc register set
 - interrupts: rtc timer, alarm interrupts in order
 - interrupt-parent: phandle for the interrupt controller
diff --git a/drivers/rtc/rtc-omap.c b/drivers/rtc/rtc-omap.c
index 761919d..c2e18fe 100644
--- a/drivers/rtc/rtc-omap.c
+++ b/drivers/rtc/rtc-omap.c
@@ -72,6 +72,8 @@
 #define OMAP_RTC_KICK0_REG		0x6c
 #define OMAP_RTC_KICK1_REG		0x70
 
+#define OMAP_RTC_IRQWAKEEN		0x7c
+
 /* OMAP_RTC_CTRL_REG bit fields: */
 #define OMAP_RTC_CTRL_SPLIT		(1<<7)
 #define OMAP_RTC_CTRL_DISABLE		(1<<6)
@@ -96,12 +98,21 @@
 #define OMAP_RTC_INTERRUPTS_IT_ALARM    (1<<3)
 #define OMAP_RTC_INTERRUPTS_IT_TIMER    (1<<2)
 
+/* OMAP_RTC_IRQWAKEEN bit fields: */
+#define OMAP_RTC_IRQWAKEEN_ALARM_WAKEEN    (1<<1)
+
 /* OMAP_RTC_KICKER values */
 #define	KICK0_VALUE			0x83e70b13
 #define	KICK1_VALUE			0x95a4f1e0
 
 #define	OMAP_RTC_HAS_KICKER		0x1
 
+/*
+ * Few RTC IP revisions has special WAKE-EN Register to enable Wakeup
+ * generation for event Alarm.
+ */
+#define	OMAP_RTC_HAS_IRQWAKEEN		0x2
+
 static void __iomem	*rtc_base;
 
 #define rtc_read(addr)		readb(rtc_base + (addr))
@@ -301,12 +312,18 @@ static struct rtc_class_ops omap_rtc_ops = {
 static int omap_rtc_alarm;
 static int omap_rtc_timer;
 
-#define	OMAP_RTC_DATA_DA830_IDX	1
+#define	OMAP_RTC_DATA_AM3352_IDX	1
+#define	OMAP_RTC_DATA_DA830_IDX		2
 
 static struct platform_device_id omap_rtc_devtype[] = {
 	{
 		.name	= DRIVER_NAME,
-	}, {
+	},
+	[OMAP_RTC_DATA_AM3352_IDX] = {
+		.name	= "am3352-rtc",
+		.driver_data = OMAP_RTC_HAS_KICKER | OMAP_RTC_HAS_IRQWAKEEN,
+	},
+	[OMAP_RTC_DATA_DA830_IDX] = {
 		.name	= "da830-rtc",
 		.driver_data = OMAP_RTC_HAS_KICKER,
 	},
@@ -318,6 +335,9 @@ static const struct of_device_id omap_rtc_of_match[] = {
 	{	.compatible	= "ti,da830-rtc",
 		.data		= &omap_rtc_devtype[OMAP_RTC_DATA_DA830_IDX],
 	},
+	{	.compatible	= "ti,am3352-rtc",
+		.data		= &omap_rtc_devtype[OMAP_RTC_DATA_AM3352_IDX],
+	},
 	{},
 };
 MODULE_DEVICE_TABLE(of, omap_rtc_of_match);
@@ -466,16 +486,28 @@ static u8 irqstat;
 
 static int omap_rtc_suspend(struct device *dev)
 {
+	u8 irqwake_stat;
+	struct platform_device *pdev = to_platform_device(dev);
+	const struct platform_device_id *id_entry =
+					platform_get_device_id(pdev);
+
 	irqstat = rtc_read(OMAP_RTC_INTERRUPTS_REG);
 
 	/* FIXME the RTC alarm is not currently acting as a wakeup event
-	 * source, and in fact this enable() call is just saving a flag
-	 * that's never used...
+	 * source on some platforms, and in fact this enable() call is just
+	 * saving a flag that's never used...
 	 */
-	if (device_may_wakeup(dev))
+	if (device_may_wakeup(dev)) {
 		enable_irq_wake(omap_rtc_alarm);
-	else
+
+		if (id_entry->driver_data & OMAP_RTC_HAS_IRQWAKEEN) {
+			irqwake_stat = rtc_read(OMAP_RTC_IRQWAKEEN);
+			irqwake_stat |= OMAP_RTC_IRQWAKEEN_ALARM_WAKEEN;
+			rtc_write(irqwake_stat, OMAP_RTC_IRQWAKEEN);
+		}
+	} else {
 		rtc_write(0, OMAP_RTC_INTERRUPTS_REG);
+	}
 
 	/* Disable the clock/module */
 	pm_runtime_put_sync(dev);
@@ -485,13 +517,25 @@ static int omap_rtc_suspend(struct device *dev)
 
 static int omap_rtc_resume(struct device *dev)
 {
+	u8 irqwake_stat;
+	struct platform_device *pdev = to_platform_device(dev);
+	const struct platform_device_id *id_entry =
+				platform_get_device_id(pdev);
+
 	/* Enable the clock/module so that we can access the registers */
 	pm_runtime_get_sync(dev);
 
-	if (device_may_wakeup(dev))
+	if (device_may_wakeup(dev)) {
 		disable_irq_wake(omap_rtc_alarm);
-	else
+
+		if (id_entry->driver_data & OMAP_RTC_HAS_IRQWAKEEN) {
+			irqwake_stat = rtc_read(OMAP_RTC_IRQWAKEEN);
+			irqwake_stat &= ~OMAP_RTC_IRQWAKEEN_ALARM_WAKEEN;
+			rtc_write(irqwake_stat, OMAP_RTC_IRQWAKEEN);
+		}
+	} else {
 		rtc_write(irqstat, OMAP_RTC_INTERRUPTS_REG);
+	}
 	return 0;
 }
 #endif
-- 
1.7.9.5

