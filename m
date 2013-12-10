Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515Ab3LJXn3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 18:43:29 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:38964 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab3LJXnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 18:43:18 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org
Subject: [PATCH 2/7] Input: pmic8xxx-pwrkey - Migrate to regmap APIs
Date: Tue, 10 Dec 2013 15:43:11 -0800
Message-Id: <1386718996-3733-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.1.109.g3d252a9
In-Reply-To: <1386718996-3733-1-git-send-email-sboyd@codeaurora.org>
References: <1386718996-3733-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the regmap APIs for this driver instead of custom pm8xxx
APIs. This breaks this driver's dependency on the pm8xxx APIs and
allows us to easily port it to other bus protocols in the future.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/input/misc/pmic8xxx-pwrkey.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/input/misc/pmic8xxx-pwrkey.c b/drivers/input/misc/pmic8xxx-pwrkey.c
index 233b216..a4de105 100644
--- a/drivers/input/misc/pmic8xxx-pwrkey.c
+++ b/drivers/input/misc/pmic8xxx-pwrkey.c
@@ -18,9 +18,9 @@
 #include <linux/input.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
+#include <linux/regmap.h>
 #include <linux/log2.h>
 
-#include <linux/mfd/pm8xxx/core.h>
 #include <linux/input/pmic8xxx-pwrkey.h>
 
 #define PON_CNTL_1 0x1C
@@ -83,7 +83,8 @@ static int pmic8xxx_pwrkey_probe(struct platform_device *pdev)
 	int key_press_irq = platform_get_irq(pdev, 1);
 	int err;
 	unsigned int delay;
-	u8 pon_cntl;
+	unsigned int pon_cntl;
+	struct regmap *regmap;
 	struct pmic8xxx_pwrkey *pwrkey;
 	const struct pm8xxx_pwrkey_platform_data *pdata =
 					dev_get_platdata(&pdev->dev);
@@ -108,6 +109,10 @@ static int pmic8xxx_pwrkey_probe(struct platform_device *pdev)
 		err = -ENOMEM;
 	}
 
+	regmap = dev_get_regmap(pdev->dev.parent, NULL);
+	if (!regmap)
+		return -ENODEV;
+
 	input_set_capability(pwr, EV_KEY, KEY_POWER);
 
 	pwr->name = "pmic8xxx_pwrkey";
@@ -116,7 +121,7 @@ static int pmic8xxx_pwrkey_probe(struct platform_device *pdev)
 	delay = (pdata->kpd_trigger_delay_us << 10) / USEC_PER_SEC;
 	delay = 1 + ilog2(delay);
 
-	err = pm8xxx_readb(pdev->dev.parent, PON_CNTL_1, &pon_cntl);
+	err = regmap_read(regmap, PON_CNTL_1, &pon_cntl);
 	if (err < 0) {
 		dev_err(&pdev->dev, "failed reading PON_CNTL_1 err=%d\n", err);
 		return err;
@@ -129,7 +134,7 @@ static int pmic8xxx_pwrkey_probe(struct platform_device *pdev)
 	else
 		pon_cntl &= ~PON_CNTL_PULL_UP;
 
-	err = pm8xxx_writeb(pdev->dev.parent, PON_CNTL_1, pon_cntl);
+	err = regmap_write(regmap, PON_CNTL_1, pon_cntl);
 	if (err < 0) {
 		dev_err(&pdev->dev, "failed writing PON_CNTL_1 err=%d\n", err);
 		return err;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

