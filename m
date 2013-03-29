Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab3C2QEz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 12:04:55 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:34620 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418Ab3C2QEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 12:04:53 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [RFC 1/5] rtc-at91rm9200: add configuration support
Date: Fri, 29 Mar 2013 17:03:45 +0100
Message-Id: <1364573029-19346-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add configuration support which can be used to implement SoC-specific
workarounds for broken hardware.
---
 drivers/rtc/rtc-at91rm9200.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/rtc/rtc-at91rm9200.c b/drivers/rtc/rtc-at91rm9200.c
index 434ebc3..5bae0a1 100644
--- a/drivers/rtc/rtc-at91rm9200.c
+++ b/drivers/rtc/rtc-at91rm9200.c
@@ -40,6 +40,10 @@
 
 #define AT91_RTC_EPOCH		1900UL	/* just like arch/arm/common/rtctime.c */
 
+struct at91_rtc_config {
+};
+
+static const struct at91_rtc_config *at91_rtc_config;
 static DECLARE_COMPLETION(at91_rtc_updated);
 static unsigned int at91_alarm_year = AT91_RTC_EPOCH;
 static void __iomem *at91_rtc_regs;
@@ -248,6 +252,15 @@ static irqreturn_t at91_rtc_interrupt(int irq, void *dev_id)
 	return IRQ_NONE;		/* not handled */
 }
 
+static const struct at91_rtc_config at91rm9200_config = {
+};
+
+static const struct at91_rtc_config *
+at91_rtc_get_config(struct platform_device *pdev)
+{
+	return &at91rm9200_config;
+}
+
 static const struct rtc_class_ops at91_rtc_ops = {
 	.read_time	= at91_rtc_readtime,
 	.set_time	= at91_rtc_settime,
@@ -266,6 +279,10 @@ static int __init at91_rtc_probe(struct platform_device *pdev)
 	struct resource *regs;
 	int ret = 0;
 
+	at91_rtc_config = at91_rtc_get_config(pdev);
+	if (!at91_rtc_config)
+		return -ENODEV;
+
 	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!regs) {
 		dev_err(&pdev->dev, "no mmio resource defined\n");
-- 
1.8.1.5

