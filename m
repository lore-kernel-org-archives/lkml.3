Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661Ab3GXPmO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 11:42:14 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:37572 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab3GXPmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 11:42:12 -0400
From: Olof Johansson <olof@lixom.net>
To: Richard Purdie <rpurdie@rpsys.net>, Jingoo Han <jg1.han@samsung.com>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com,
        Qing Xu <qingx@marvell.com>, Haojian Zhuang <haojian.zhuang@gmail.com>,
        linux-arm-kernel@lists.infradead.org, holt@sgi.com,
        Olof Johansson <olof@lixom.net>
Subject: [PATCH] mfd: max8925: fix dt code for backlight
Date: Wed, 24 Jul 2013 08:42:27 -0700
Message-Id: <1374680547-5336-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device-tree enablement for max8925 has several problems, but besides
the bindings being wrong (and not having seen review) there's also some
bad coding practices on how to fill in the platform_data from device tree.

I came across this since it causes a warning when compiling
mmp2_defconfig, and instead of doing the minimal fix to silence the
warning, I restructured the code a bit.

This silences the warning:
drivers/video/backlight/max8925_bl.c: In function 'max8925_backlight_probe':
drivers/video/backlight/max8925_bl.c:177:3: warning: statement with no effect [-Wunused-value]

Note that the bindings themselves need to be revisited too, but that will
affect more than just the backlight driver and is best done separately;
this just fixes the bad code for the backlight driver.

Signed-off-by: Olof Johansson <olof@lixom.net>
---

Richard, Jingoo, this would be good to see go into 3.11 if you're
comfortable with it.


-Olof

 drivers/video/backlight/max8925_bl.c |   41 +++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/drivers/video/backlight/max8925_bl.c b/drivers/video/backlight/max8925_bl.c
index 5ca11b0..886e797 100644
--- a/drivers/video/backlight/max8925_bl.c
+++ b/drivers/video/backlight/max8925_bl.c
@@ -101,33 +101,37 @@ static const struct backlight_ops max8925_backlight_ops = {
 	.get_brightness	= max8925_backlight_get_brightness,
 };
 
-#ifdef CONFIG_OF
-static int max8925_backlight_dt_init(struct platform_device *pdev,
-			      struct max8925_backlight_pdata *pdata)
+static void max8925_backlight_dt_init(struct platform_device *pdev)
 {
 	struct device_node *nproot = pdev->dev.parent->of_node, *np;
-	int dual_string;
+	struct max8925_backlight_pdata *pdata;
+	u32 val;
+
+	if (!nproot || !IS_ENABLED(CONFIG_OF))
+		return;
+
+	pdata = devm_kzalloc(&pdev->dev,
+			     sizeof(struct max8925_backlight_pdata),
+			     GFP_KERNEL);
+	if (!pdata)
+		return;
 
-	if (!nproot)
-		return -ENODEV;
 	np = of_find_node_by_name(nproot, "backlight");
 	if (!np) {
 		dev_err(&pdev->dev, "failed to find backlight node\n");
-		return -ENODEV;
+		return;
 	}
 
-	of_property_read_u32(np, "maxim,max8925-dual-string", &dual_string);
-	pdata->dual_string = dual_string;
-	return 0;
+	if (!of_property_read_u32(np, "maxim,max8925-dual-string", &val))
+		pdata->dual_string = val;
+
+	pdev->dev.platform_data = pdata;
 }
-#else
-#define max8925_backlight_dt_init(x, y)	(-1)
-#endif
 
 static int max8925_backlight_probe(struct platform_device *pdev)
 {
 	struct max8925_chip *chip = dev_get_drvdata(pdev->dev.parent);
-	struct max8925_backlight_pdata *pdata = pdev->dev.platform_data;
+	struct max8925_backlight_pdata *pdata;
 	struct max8925_backlight_data *data;
 	struct backlight_device *bl;
 	struct backlight_properties props;
@@ -170,13 +174,10 @@ static int max8925_backlight_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, bl);
 
 	value = 0;
-	if (pdev->dev.parent->of_node && !pdata) {
-		pdata = devm_kzalloc(&pdev->dev,
-				     sizeof(struct max8925_backlight_pdata),
-				     GFP_KERNEL);
-		max8925_backlight_dt_init(pdev, pdata);
-	}
+	if (!pdev->dev.platform_data)
+		max8925_backlight_dt_init(pdev);
 
+	pdata = pdev->dev.platform_data;
 	if (pdata) {
 		if (pdata->lxw_scl)
 			value |= (1 << 7);
-- 
1.7.10.4

