Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950AbaJITN3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 15:13:29 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:50168 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbaJITMb (ORCPT
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
Subject: [PATCH 07/12] rtc: omap: silence bogus power-up reset message at probe
Date: Thu,  9 Oct 2014 21:06:29 +0200
Message-Id: <1412881594-25678-8-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1412881594-25678-1-git-send-email-johan@kernel.org>
References: <1412881594-25678-1-git-send-email-johan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some legacy RTC IP revisions has a power-up reset flag in the status
register that later revisions lack.

As this flag is always read back as set on later revisions (or is
overloaded with a different flag), make sure to only clear the flag and
print the info message on legacy platforms.

Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/rtc/rtc-omap.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/rtc/rtc-omap.c b/drivers/rtc/rtc-omap.c
index 1c58920b0c88..0ef016553a97 100644
--- a/drivers/rtc/rtc-omap.c
+++ b/drivers/rtc/rtc-omap.c
@@ -118,6 +118,12 @@
  */
 #define OMAP_RTC_HAS_32KCLK_EN		BIT(2)
 
+/*
+ * Some legacy RTC IP revisions has a power-up reset flag which later
+ * revisions lack.
+ */
+#define OMAP_RTC_HAS_POWER_UP_RESET	BIT(3)
+
 static void __iomem	*rtc_base;
 
 #define rtc_read(addr)		readb(rtc_base + (addr))
@@ -347,6 +353,7 @@ static int omap_rtc_timer;
 static struct platform_device_id omap_rtc_devtype[] = {
 	{
 		.name	= DRIVER_NAME,
+		.driver_data = OMAP_RTC_HAS_POWER_UP_RESET,
 	},
 	[OMAP_RTC_DATA_AM3352_IDX] = {
 		.name	= "am3352-rtc",
@@ -376,7 +383,7 @@ static int __init omap_rtc_probe(struct platform_device *pdev)
 {
 	struct resource		*res;
 	struct rtc_device	*rtc;
-	u8			reg, new_ctrl;
+	u8			reg, mask, new_ctrl;
 	const struct platform_device_id *id_entry;
 	const struct of_device_id *of_id;
 
@@ -429,12 +436,16 @@ static int __init omap_rtc_probe(struct platform_device *pdev)
 
 	/* clear old status */
 	reg = rtc_read(OMAP_RTC_STATUS_REG);
-	if (reg & (u8) OMAP_RTC_STATUS_POWER_UP) {
-		dev_info(&pdev->dev, "RTC power up reset detected\n");
-		rtc_write(OMAP_RTC_STATUS_POWER_UP, OMAP_RTC_STATUS_REG);
+
+	mask = OMAP_RTC_STATUS_ALARM;
+	if (id_entry->driver_data & OMAP_RTC_HAS_POWER_UP_RESET) {
+		mask |= OMAP_RTC_STATUS_POWER_UP;
+		if (reg & OMAP_RTC_STATUS_POWER_UP)
+			dev_info(&pdev->dev, "RTC power up reset detected\n");
 	}
-	if (reg & (u8) OMAP_RTC_STATUS_ALARM)
-		rtc_write(OMAP_RTC_STATUS_ALARM, OMAP_RTC_STATUS_REG);
+
+	if (reg & mask)
+		rtc_write(reg & mask, OMAP_RTC_STATUS_REG);
 
 	/* handle periodic and alarm irqs */
 	if (devm_request_irq(&pdev->dev, omap_rtc_timer, rtc_irq, 0,
-- 
2.0.4

