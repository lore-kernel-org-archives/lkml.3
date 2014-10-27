Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbaJ0XMn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 19:12:43 -0400
Received: from down.free-electrons.com ([37.187.137.238]:55583 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752806AbaJ0XJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 19:09:57 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Sebastian Reichel <sre@kernel.org>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH v2 2/8] memory: atmel-sdramc: allow probing from pdata
Date: Tue, 28 Oct 2014 00:09:31 +0100
Message-Id: <1414451377-11053-3-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414451377-11053-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1414451377-11053-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow probing the atmel-sdramc from platform_data.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 drivers/memory/atmel-sdramc.c | 45 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 44 insertions(+), 1 deletion(-)

diff --git a/drivers/memory/atmel-sdramc.c b/drivers/memory/atmel-sdramc.c
index d89ed0af44d9..c4a7ba0f291f 100644
--- a/drivers/memory/atmel-sdramc.c
+++ b/drivers/memory/atmel-sdramc.c
@@ -19,6 +19,7 @@
 
 #include <linux/clk.h>
 #include <linux/err.h>
+#include <linux/io.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/of_address.h>
@@ -140,7 +141,7 @@ static const struct of_device_id atmel_ramc_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, atmel_ramc_of_match);
 
-static int atmel_ramc_probe(struct platform_device *pdev)
+static int atmel_ramc_of_probe(struct platform_device *pdev)
 {
 	const struct of_device_id *match;
 	const struct at91_ramc_caps *caps;
@@ -181,6 +182,47 @@ static int atmel_ramc_probe(struct platform_device *pdev)
 	return 0;
 }
 
+static int atmel_ramc_platform_probe(struct platform_device *pdev)
+{
+	struct resource *res;
+	const struct platform_device_id *match;
+	int idx = 0;
+
+	for (idx = 0; idx < 2; idx++) {
+		res = platform_get_resource(pdev, IORESOURCE_MEM, idx + 1);
+		at91_ramc_base[idx] = devm_ioremap(&pdev->dev, res->start,
+						   resource_size(res));
+		if (IS_ERR(at91_ramc_base[idx])) {
+			dev_err(&pdev->dev, "Could not map ram controller address\n");
+			return PTR_ERR(at91_ramc_base[idx]);
+		}
+	}
+
+	match = platform_get_device_id(pdev);
+	at91_ramc_shutdown =
+		(void (*)(void __iomem *rstc_cr, u32 value))match->driver_data;
+
+	return 0;
+};
+
+static int atmel_ramc_probe(struct platform_device *pdev)
+{
+	int ret;
+
+	if (pdev->dev.of_node)
+		ret = atmel_ramc_of_probe(pdev);
+	else
+		ret = atmel_ramc_platform_probe(pdev);
+
+	return ret;
+}
+
+static struct platform_device_id atmel_ramc_plat_match[] = {
+	{ "at91sam9260-sdramc", (unsigned long)at91sam9260_shutdown, },
+	{ "at91sam9g45-ddramc", (unsigned long)at91sam9g45_shutdown, },
+	{ /* sentinel */ }
+};
+
 static struct platform_driver atmel_ramc_driver = {
 	.probe		= atmel_ramc_probe,
 	.driver		= {
@@ -188,6 +230,7 @@ static struct platform_driver atmel_ramc_driver = {
 		.owner	= THIS_MODULE,
 		.of_match_table = atmel_ramc_of_match,
 	},
+	.id_table = atmel_ramc_plat_match,
 };
 
 static int __init atmel_ramc_init(void)
-- 
1.9.1

