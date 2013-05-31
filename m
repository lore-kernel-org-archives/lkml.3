Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375Ab3EaGca (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 02:32:30 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:45700 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab3EaGcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 02:32:23 -0400
From: Hebbar Gururaja <gururaja.hebbar@ti.com>
To: <akpm@linux-foundation.org>
CC: <linux@arm.linux.org.uk>, <zonque@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>, <grant.likely@linaro.org>,
        <rob.herring@calxeda.com>, <rob@landley.net>, <a.zummo@towertech.it>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rtc-linux@googlegroups.com>,
        <davinci-linux-open-source@linux.davincidsp.com>, <khilman@linaro.org>,
        <vaibhav.bedia@ti.com>, <sudhakar.raj@ti.com>,
        <gururaja.hebbar@ti.com>
Subject: [PATCH 2/2] rtc: omap: add rtc wakeup support to alarm events
Date: Fri, 31 May 2013 12:03:25 +0530
Message-ID: <1369982005-8572-3-git-send-email-gururaja.hebbar@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1369982005-8572-1-git-send-email-gururaja.hebbar@ti.com>
References: <1369982005-8572-1-git-send-email-gururaja.hebbar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some platforms (like AM33xx), a special register (RTC_IRQWAKEEN)
is available to enable Wakeup feature for Alarm Events.

Since new platforms/Boards are now added through DT only, this feature
is supported via DT property only.

Platforms using such IP should add the property "ti,has_irq_wake_enb"
in rtc DT node.

Signed-off-by: Hebbar Gururaja <gururaja.hebbar@ti.com>
---
:100644 100644 108a629... b870d87... M	Documentation/devicetree/bindings/rtc/rtc-omap.txt
:100644 100644 000a02f... 5e9c0dd... M	drivers/rtc/rtc-omap.c
 Documentation/devicetree/bindings/rtc/rtc-omap.txt |    2 +
 drivers/rtc/rtc-omap.c                             |   47 ++++++++++++++++----
 2 files changed, 41 insertions(+), 8 deletions(-)

diff --git a/Documentation/devicetree/bindings/rtc/rtc-omap.txt b/Documentation/devicetree/bindings/rtc/rtc-omap.txt
index 108a629..b870d87 100644
--- a/Documentation/devicetree/bindings/rtc/rtc-omap.txt
+++ b/Documentation/devicetree/bindings/rtc/rtc-omap.txt
@@ -9,6 +9,8 @@ Required properties:
 Optional properties:
 - ti,wakeup_capable: Inform the rtc driver that this module is wake-up
   capable so that rtcwake and suspend tests can work.
+- ti,has_irq_wake_enb: Inform rtc driver that this module has a a
+  special register to enable Wakeup feature for Alarm events.
 
 Example:
 
diff --git a/drivers/rtc/rtc-omap.c b/drivers/rtc/rtc-omap.c
index 000a02f..5e9c0dd 100644
--- a/drivers/rtc/rtc-omap.c
+++ b/drivers/rtc/rtc-omap.c
@@ -72,6 +72,8 @@
 #define OMAP_RTC_KICK0_REG		0x6c
 #define OMAP_RTC_KICK1_REG		0x70
 
+#define OMAP_RTC_IRQWAKEEN		0x7C
+
 /* OMAP_RTC_CTRL_REG bit fields: */
 #define OMAP_RTC_CTRL_SPLIT		(1<<7)
 #define OMAP_RTC_CTRL_DISABLE		(1<<6)
@@ -96,6 +98,9 @@
 #define OMAP_RTC_INTERRUPTS_IT_ALARM    (1<<3)
 #define OMAP_RTC_INTERRUPTS_IT_TIMER    (1<<2)
 
+/* OMAP_RTC_IRQWAKEEN bit fields: */
+#define OMAP_RTC_IRQWAKEEN_ALARM_WAKEEN    (1<<1)
+
 /* OMAP_RTC_KICKER values */
 #define	KICK0_VALUE			0x83e70b13
 #define	KICK1_VALUE			0x95a4f1e0
@@ -103,6 +108,7 @@
 #define	OMAP_RTC_HAS_KICKER		0x1
 
 static void __iomem	*rtc_base;
+static unsigned int	has_irq_wake_enb_bit;
 
 #define rtc_read(addr)		readb(rtc_base + (addr))
 #define rtc_write(val, addr)	writeb(val, rtc_base + (addr))
@@ -425,9 +431,14 @@ static int __init omap_rtc_probe(struct platform_device *pdev)
 
 	/* Fixup wakeup-enable feature based on the device tree */
 	if (of_id && of_find_property(pdev->dev.of_node,
-				      "ti,wakeup_capable", NULL))
+				      "ti,wakeup_capable", NULL)) {
 		device_init_wakeup(&pdev->dev, 1);
 
+		if (of_find_property(pdev->dev.of_node,
+				     "ti,has_irq_wake_enb", NULL))
+			has_irq_wake_enb_bit = true;
+	}
+
 	if (new_ctrl & (u8) OMAP_RTC_CTRL_SPLIT)
 		pr_info("%s: split power mode\n", pdev->name);
 
@@ -469,16 +480,26 @@ static u8 irqstat;
 
 static int omap_rtc_suspend(struct device *dev)
 {
+	u8 irqwake_stat;
+
 	irqstat = rtc_read(OMAP_RTC_INTERRUPTS_REG);
 
-	/* FIXME the RTC alarm is not currently acting as a wakeup event
-	 * source, and in fact this enable() call is just saving a flag
-	 * that's never used...
+	/*
+	 * FIXME. On some platforms the RTC alarm is not currently acting as a
+	 * wakeup event source, and in fact this enable() call is just saving a
+	 * flag that's never used...
 	 */
-	if (device_may_wakeup(dev))
+	if (device_may_wakeup(dev)) {
 		enable_irq_wake(omap_rtc_alarm);
-	else
+
+		if (has_irq_wake_enb_bit == true) {
+			irqwake_stat = rtc_read(OMAP_RTC_IRQWAKEEN);
+			irqwake_stat |= OMAP_RTC_IRQWAKEEN_ALARM_WAKEEN;
+			rtc_write(irqwake_stat, OMAP_RTC_IRQWAKEEN);
+		}
+	} else {
 		rtc_write(0, OMAP_RTC_INTERRUPTS_REG);
+	}
 
 	/* Disable the clock/module */
 	pm_runtime_put_sync(dev);
@@ -488,13 +509,23 @@ static int omap_rtc_suspend(struct device *dev)
 
 static int omap_rtc_resume(struct device *dev)
 {
+	u8 irqwake_stat;
+
 	/* Enable the clock/module so that we can access the registers */
 	pm_runtime_get_sync(dev);
 
-	if (device_may_wakeup(dev))
+	if (device_may_wakeup(dev)) {
 		disable_irq_wake(omap_rtc_alarm);
-	else
+
+		if (has_irq_wake_enb_bit == true) {
+			irqwake_stat = rtc_read(OMAP_RTC_IRQWAKEEN);
+			irqwake_stat &= ~OMAP_RTC_IRQWAKEEN_ALARM_WAKEEN;
+			rtc_write(irqwake_stat, OMAP_RTC_IRQWAKEEN);
+		}
+	} else {
 		rtc_write(irqstat, OMAP_RTC_INTERRUPTS_REG);
+	}
+
 	return 0;
 }
 #endif
-- 
1.7.9.5

