Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446AbaELQ5o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 12:57:44 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:60122 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196AbaELQ5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 12:57:42 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, Jon Loeliger <jdl@jdl.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [RFC PATCH 9/9] dt: deps: omap2: make it possible to use CONFIG_OF_DEPENDENCIES
Date: Mon, 12 May 2014 18:48:00 +0200
Message-Id: <1399913280-6915-10-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1399913280-6915-1-git-send-email-holler@ahsoftware.de>
References: <1399913280-6915-1-git-send-email-holler@ahsoftware.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the feature of dependency based initialization order for drivers
if CONFIG_OF_DEPENDENCIES is enabled.

This patch also includes a change for a driver which does call
of_platform_populate() itself. This shouldn't be done or necessary
when CONFIG_OF_DEPENDENCIES is enabled.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 arch/arm/mach-omap2/pdata-quirks.c | 8 ++++++++
 drivers/pwm/pwm-tipwmss.c          | 5 +++++
 2 files changed, 13 insertions(+)

diff --git a/arch/arm/mach-omap2/pdata-quirks.c b/arch/arm/mach-omap2/pdata-quirks.c
index c33e07e..80becdb 100644
--- a/arch/arm/mach-omap2/pdata-quirks.c
+++ b/arch/arm/mach-omap2/pdata-quirks.c
@@ -13,6 +13,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/of_platform.h>
+#include <linux/of_dependencies.h>
 #include <linux/wl12xx.h>
 
 #include <linux/platform_data/pinctrl-single.h>
@@ -312,7 +313,14 @@ void __init pdata_quirks_init(struct of_device_id *omap_dt_match_table)
 {
 	omap_sdrc_init(NULL, NULL);
 	pdata_quirks_check(auxdata_quirks);
+#ifdef CONFIG_OF_DEPENDENCIES
+	if (!of_init_build_order(NULL, NULL))
+		of_init_create_devices(NULL, omap_auxdata_lookup);
+	else
+		of_init_free_order();
+#else
 	of_platform_populate(NULL, omap_dt_match_table,
 			     omap_auxdata_lookup, NULL);
+#endif
 	pdata_quirks_check(pdata_quirks);
 }
diff --git a/drivers/pwm/pwm-tipwmss.c b/drivers/pwm/pwm-tipwmss.c
index 3b119bc..786fa39 100644
--- a/drivers/pwm/pwm-tipwmss.c
+++ b/drivers/pwm/pwm-tipwmss.c
@@ -78,10 +78,15 @@ static int pwmss_probe(struct platform_device *pdev)
 	pm_runtime_get_sync(&pdev->dev);
 	platform_set_drvdata(pdev, info);
 
+#ifndef CONFIG_OF_DEPENDENCIES
 	/* Populate all the child nodes here... */
 	ret = of_platform_populate(node, NULL, NULL, &pdev->dev);
 	if (ret)
 		dev_err(&pdev->dev, "no child node found\n");
+#else
+	/* dependency based initialization already has setup devices */
+	ret = 0;
+#endif
 
 	return ret;
 }
-- 
1.8.3.1

