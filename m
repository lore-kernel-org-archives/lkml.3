Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757699Ab3EWIkQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 04:40:16 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:53051 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897Ab3EWIja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 04:39:30 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Robert Nelson <Robert.Nelson@digikey.com>,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH v3 2/5] rtc-at91rm9200: add configuration support
Date: Thu, 23 May 2013 10:38:52 +0200
Message-Id: <1369298335-24597-3-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1369298335-24597-1-git-send-email-jhovold@gmail.com>
References: <1364983415-20298-1-git-send-email-jhovold@gmail.com>
 <1369298335-24597-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add configuration support which can be used to implement SoC-specific
workarounds for broken hardware.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/rtc/rtc-at91rm9200.c | 46 ++++++++++++++++++++++++++++++++++++--------
 1 file changed, 38 insertions(+), 8 deletions(-)

diff --git a/drivers/rtc/rtc-at91rm9200.c b/drivers/rtc/rtc-at91rm9200.c
index eeeb73f..ab2024b 100644
--- a/drivers/rtc/rtc-at91rm9200.c
+++ b/drivers/rtc/rtc-at91rm9200.c
@@ -42,6 +42,10 @@
 
 #define AT91_RTC_EPOCH		1900UL	/* just like arch/arm/common/rtctime.c */
 
+struct at91_rtc_config {
+};
+
+static const struct at91_rtc_config *at91_rtc_config;
 static DECLARE_COMPLETION(at91_rtc_updated);
 static unsigned int at91_alarm_year = AT91_RTC_EPOCH;
 static void __iomem *at91_rtc_regs;
@@ -250,6 +254,36 @@ static irqreturn_t at91_rtc_interrupt(int irq, void *dev_id)
 	return IRQ_NONE;		/* not handled */
 }
 
+static const struct at91_rtc_config at91rm9200_config = {
+};
+
+#ifdef CONFIG_OF
+static const struct of_device_id at91_rtc_dt_ids[] = {
+	{
+		.compatible = "atmel,at91rm9200-rtc",
+		.data = &at91rm9200_config,
+	}, {
+		/* sentinel */
+	}
+};
+MODULE_DEVICE_TABLE(of, at91_rtc_dt_ids);
+#endif
+
+static const struct at91_rtc_config *
+at91_rtc_get_config(struct platform_device *pdev)
+{
+	const struct of_device_id *match;
+
+	if (pdev->dev.of_node) {
+		match = of_match_node(at91_rtc_dt_ids, pdev->dev.of_node);
+		if (!match)
+			return NULL;
+		return (const struct at91_rtc_config *)match->data;
+	}
+
+	return &at91rm9200_config;
+}
+
 static const struct rtc_class_ops at91_rtc_ops = {
 	.read_time	= at91_rtc_readtime,
 	.set_time	= at91_rtc_settime,
@@ -268,6 +302,10 @@ static int __init at91_rtc_probe(struct platform_device *pdev)
 	struct resource *regs;
 	int ret = 0;
 
+	at91_rtc_config = at91_rtc_get_config(pdev);
+	if (!at91_rtc_config)
+		return -ENODEV;
+
 	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!regs) {
 		dev_err(&pdev->dev, "no mmio resource defined\n");
@@ -383,14 +421,6 @@ static int at91_rtc_resume(struct device *dev)
 
 static SIMPLE_DEV_PM_OPS(at91_rtc_pm_ops, at91_rtc_suspend, at91_rtc_resume);
 
-#ifdef CONFIG_OF
-static const struct of_device_id at91_rtc_dt_ids[] = {
-	{ .compatible = "atmel,at91rm9200-rtc" },
-	{ /* sentinel */ }
-};
-MODULE_DEVICE_TABLE(of, at91_rtc_dt_ids);
-#endif
-
 static struct platform_driver at91_rtc_driver = {
 	.remove		= __exit_p(at91_rtc_remove),
 	.driver		= {
-- 
1.8.2.1

