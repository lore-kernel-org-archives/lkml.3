Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758136Ab3DZJPv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 05:15:51 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:63364 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856Ab3DZJPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 05:15:49 -0400
From: Matus Ujhelyi <ujhelyi.m@gmail.com>
To: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        rpurdie@rpsys.net, FlorianSchandinat@gmx.de
Cc: devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        marek.belisko@streamunlimited.com, zonque@gmail.com,
        ujhelyi.m@gmail.com, Matus Ujhelyi <matus.ujhelyi@streamunlimited.com>
Subject: [PATCH 1/1] backlight: add default brightness value option for tps65217-bl driver
Date: Fri, 26 Apr 2013 11:15:33 +0200
Message-Id: <1366967733-29958-1-git-send-email-matus.ujhelyi@streamunlimited.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Matus Ujhelyi <matus.ujhelyi@streamunlimited.com>
---
 .../video/backlight/tps65217-backlight.txt         |    2 ++
 drivers/video/backlight/tps65217_bl.c              |   15 ++++++++++++++-
 include/linux/mfd/tps65217.h                       |    1 +
 3 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/video/backlight/tps65217-backlight.txt b/Documentation/devicetree/bindings/video/backlight/tps65217-backlight.txt
index cc4ee25..5fb9279 100644
--- a/Documentation/devicetree/bindings/video/backlight/tps65217-backlight.txt
+++ b/Documentation/devicetree/bindings/video/backlight/tps65217-backlight.txt
@@ -9,6 +9,7 @@ Required properties:
 - backlight: node for specifying WLED1 and WLED2 lines in TPS65217
 - isel: selection bit, valid values: 1 for ISEL1 (low-level) and 2 for ISEL2 (high-level)
 - fdim: PWM dimming frequency, valid values: 100, 200, 500, 1000
+- default-brightness: valid values: 0-100
 
 Each regulator is defined using the standard binding for regulators.
 
@@ -20,6 +21,7 @@ Example:
 		backlight {
 			isel = <1>;  /* 1 - ISET1, 2 ISET2 */
 			fdim = <100>; /* TPS65217_BL_FDIM_100HZ */
+			default-brightness = <50>;
 		};
 	};
 
diff --git a/drivers/video/backlight/tps65217_bl.c b/drivers/video/backlight/tps65217_bl.c
index 7088163..0578231 100644
--- a/drivers/video/backlight/tps65217_bl.c
+++ b/drivers/video/backlight/tps65217_bl.c
@@ -245,6 +245,18 @@ tps65217_bl_parse_dt(struct platform_device *pdev)
 		}
 	}
 
+	if (!of_property_read_u32(node, "default-brightness", &val)) {
+		if (val < 0 ||
+			val > 100) {
+			dev_err(&pdev->dev,
+				"invalid 'default-brightness' value in the device tree\n");
+			err = ERR_PTR(-EINVAL);
+			goto err;
+		}
+
+		pdata->dft_brightness = val;
+	}
+
 	of_node_put(node);
 
 	return pdata;
@@ -311,7 +323,8 @@ static int tps65217_bl_probe(struct platform_device *pdev)
 		return PTR_ERR(tps65217_bl->bl);
 	}
 
-	tps65217_bl->bl->props.brightness = 0;
+	tps65217_bl->bl->props.brightness = pdata->dft_brightness;
+	backlight_update_status(tps65217_bl->bl);
 	platform_set_drvdata(pdev, tps65217_bl);
 
 	return 0;
diff --git a/include/linux/mfd/tps65217.h b/include/linux/mfd/tps65217.h
index 290762f..29eab2b 100644
--- a/include/linux/mfd/tps65217.h
+++ b/include/linux/mfd/tps65217.h
@@ -228,6 +228,7 @@ enum tps65217_bl_fdim {
 struct tps65217_bl_pdata {
 	enum tps65217_bl_isel isel;
 	enum tps65217_bl_fdim fdim;
+	int dft_brightness;
 };
 
 /**
-- 
1.7.9.5

