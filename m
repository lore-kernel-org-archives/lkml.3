Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656Ab3C2QGT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 12:06:19 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:62229 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592Ab3C2QEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 12:04:54 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [RFC 2/5] rtc-at91rm9200: add device-tree support
Date: Fri, 29 Mar 2013 17:03:46 +0100
Message-Id: <1364573029-19346-2-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1364573029-19346-1-git-send-email-jhovold@gmail.com>
References: <1364573029-19346-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree support.
---
 drivers/rtc/rtc-at91rm9200.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/rtc/rtc-at91rm9200.c b/drivers/rtc/rtc-at91rm9200.c
index 5bae0a1..67260f9 100644
--- a/drivers/rtc/rtc-at91rm9200.c
+++ b/drivers/rtc/rtc-at91rm9200.c
@@ -28,6 +28,7 @@
 #include <linux/ioctl.h>
 #include <linux/completion.h>
 #include <linux/io.h>
+#include <linux/of.h>
 
 #include <asm/uaccess.h>
 
@@ -255,9 +256,30 @@ static irqreturn_t at91_rtc_interrupt(int irq, void *dev_id)
 static const struct at91_rtc_config at91rm9200_config = {
 };
 
+#if defined(CONFIG_OF)
+static const struct of_device_id at91_rtc_dt_ids[] = {
+	{
+		.compatible = "atmel,at91rm9200-rtc",
+		.data = &at91rm9200_config,
+	},
+		/* terminator */
+	}
+};
+MODULE_DEVICE_TABLE(of, at91_rtc_dt_ids);
+#endif
+
 static const struct at91_rtc_config *
 at91_rtc_get_config(struct platform_device *pdev)
 {
+	const struct of_device_id *match;
+
+	if (pdev->dev.of_node) {
+		match = of_match_node(at91_rtc_dt_ids, pdev->dev.of_node);
+		if (!match)
+			return NULL;
+		return (const struct at91_rtc_config *)match->data;
+	}
+
 	return &at91rm9200_config;
 }
 
@@ -403,6 +425,7 @@ static struct platform_driver at91_rtc_driver = {
 	.driver		= {
 		.name	= "at91_rtc",
 		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(at91_rtc_dt_ids),
 		.pm	= at91_rtc_pm_ptr,
 	},
 };
-- 
1.8.1.5

