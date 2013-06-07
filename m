Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719Ab3FGQN3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 12:13:29 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:46531 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756105Ab3FGQMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 12:12:02 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, broonie@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 08/10] regulator: ab8500-ext: Register as a device in its own right
Date: Fri,  7 Jun 2013 17:11:26 +0100
Message-Id: <1370621488-18130-9-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370621488-18130-1-git-send-email-lee.jones@linaro.org>
References: <1370621488-18130-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some platforms don't support the AB8500 external regulators, so instead
of having a list of is_<platform>() calls prior to calling
ab8500_ext_regulator_init() from ab8500_regulator_probe(), we can only
register as a platform device on platforms which require them. It means
we also have more control over them when booting with Device Tree.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/regulator/ab8500-ext.c   |   33 +++++++++++++++++++++++++++++++--
 drivers/regulator/ab8500.c       |   17 +----------------
 include/linux/regulator/ab8500.h |    4 ----
 3 files changed, 32 insertions(+), 22 deletions(-)

diff --git a/drivers/regulator/ab8500-ext.c b/drivers/regulator/ab8500-ext.c
index e4975bc..95f495f 100644
--- a/drivers/regulator/ab8500-ext.c
+++ b/drivers/regulator/ab8500-ext.c
@@ -333,7 +333,7 @@ static struct ab8500_ext_regulator_info
 	},
 };
 
-int ab8500_ext_regulator_init(struct platform_device *pdev)
+int ab8500_ext_regulator_probe(struct platform_device *pdev)
 {
 	struct ab8500 *ab8500 = dev_get_drvdata(pdev->dev.parent);
 	struct ab8500_platform_data *ppdata;
@@ -409,7 +409,7 @@ int ab8500_ext_regulator_init(struct platform_device *pdev)
 	return 0;
 }
 
-void ab8500_ext_regulator_exit(struct platform_device *pdev)
+int ab8500_ext_regulator_remove(struct platform_device *pdev)
 {
 	int i;
 
@@ -422,7 +422,36 @@ void ab8500_ext_regulator_exit(struct platform_device *pdev)
 
 		regulator_unregister(info->rdev);
 	}
+
+	return 0;
+}
+
+static struct platform_driver ab8500_ext_regulator_driver = {
+	.probe = ab8500_ext_regulator_probe,
+	.remove = ab8500_ext_regulator_remove,
+	.driver         = {
+		.name   = "ab8500-ext-regulator",
+		.owner  = THIS_MODULE,
+	},
+};
+
+static int __init ab8500_ext_regulator_init(void)
+{
+	int ret;
+
+	ret = platform_driver_register(&ab8500_ext_regulator_driver);
+	if (ret)
+		pr_err("Failed to register ab8500 ext regulator: %d\n", ret);
+
+	return ret;
+}
+subsys_initcall(ab8500_ext_regulator_init);
+
+static void __exit ab8500_ext_regulator_exit(void)
+{
+	platform_driver_unregister(&ab8500_ext_regulator_driver);
 }
+module_exit(ab8500_ext_regulator_exit);
 
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Bengt Jonsson <bengt.g.jonsson@stericsson.com>");
diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index a19045e..aea9fdae 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -3156,22 +3156,12 @@ static int ab8500_regulator_probe(struct platform_device *pdev)
 			return err;
 	}
 
-	if (!is_ab8505(ab8500)) {
-		/* register external regulators (before Vaux1, 2 and 3) */
-		err = ab8500_ext_regulator_init(pdev);
-		if (err)
-			return err;
-	}
-
 	/* register all regulators */
 	for (i = 0; i < abx500_regulator.info_size; i++) {
 		err = ab8500_regulator_register(pdev, &pdata->regulator[i],
 						i, NULL);
-		if (err < 0) {
-			if (!is_ab8505(ab8500))
-				ab8500_ext_regulator_exit(pdev);
+		if (err < 0)
 			return err;
-		}
 	}
 
 	return 0;
@@ -3180,7 +3170,6 @@ static int ab8500_regulator_probe(struct platform_device *pdev)
 static int ab8500_regulator_remove(struct platform_device *pdev)
 {
 	int i, err;
-	struct ab8500 *ab8500 = dev_get_drvdata(pdev->dev.parent);
 
 	for (i = 0; i < abx500_regulator.info_size; i++) {
 		struct ab8500_regulator_info *info = NULL;
@@ -3192,10 +3181,6 @@ static int ab8500_regulator_remove(struct platform_device *pdev)
 		regulator_unregister(info->regulator);
 	}
 
-	/* remove external regulators (after Vaux1, 2 and 3) */
-	if (!is_ab8505(ab8500))
-		ab8500_ext_regulator_exit(pdev);
-
 	/* remove regulator debug */
 	err = ab8500_regulator_debug_exit(pdev);
 	if (err)
diff --git a/include/linux/regulator/ab8500.h b/include/linux/regulator/ab8500.h
index 7c5ff0c..7530744 100644
--- a/include/linux/regulator/ab8500.h
+++ b/include/linux/regulator/ab8500.h
@@ -336,8 +336,4 @@ static inline int ab8500_regulator_debug_exit(struct platform_device *pdev)
 }
 #endif
 
-/* AB8500 external regulator functions. */
-int ab8500_ext_regulator_init(struct platform_device *pdev);
-void ab8500_ext_regulator_exit(struct platform_device *pdev);
-
 #endif
-- 
1.7.10.4

