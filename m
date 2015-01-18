Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895AbbARLlg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 06:41:36 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:45014 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbbARLj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 06:39:56 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        John Crispin <blogic@openwrt.org>
Subject: [PATCH 5/8] gpio/gpio-mm-lantiq: Use of_mm_gpiochip_remove
Date: Sun, 18 Jan 2015 12:39:30 +0100
Message-Id: <1421581173-28416-6-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421581173-28416-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1421581173-28416-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since d621e8bae5ac9c67 (Create of_mm_gpiochip_remove), there is a
counterpart for of_mm_gpiochip_add.

This patch implements the remove function of the driver making use of
it.

Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>
Cc: John Crispin <blogic@openwrt.org>
Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/gpio/gpio-mm-lantiq.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/gpio/gpio-mm-lantiq.c b/drivers/gpio/gpio-mm-lantiq.c
index b511a6b..082c1d5 100644
--- a/drivers/gpio/gpio-mm-lantiq.c
+++ b/drivers/gpio/gpio-mm-lantiq.c
@@ -110,6 +110,8 @@ static int ltq_mm_probe(struct platform_device *pdev)
 	if (!chip)
 		return -ENOMEM;
 
+	platform_set_drvdata(pdev, chip);
+
 	chip->mmchip.gc.ngpio = 16;
 	chip->mmchip.gc.direction_output = ltq_mm_dir_out;
 	chip->mmchip.gc.set = ltq_mm_set;
@@ -122,6 +124,15 @@ static int ltq_mm_probe(struct platform_device *pdev)
 	return of_mm_gpiochip_add(pdev->dev.of_node, &chip->mmchip);
 }
 
+static int ltq_mm_remove(struct platform_device *pdev)
+{
+	struct ltq_mm *chip = platform_get_drvdata(pdev);
+
+	of_mm_gpiochip_remove(&chip->mmchip);
+
+	return 0;
+}
+
 static const struct of_device_id ltq_mm_match[] = {
 	{ .compatible = "lantiq,gpio-mm" },
 	{},
@@ -130,6 +141,7 @@ MODULE_DEVICE_TABLE(of, ltq_mm_match);
 
 static struct platform_driver ltq_mm_driver = {
 	.probe = ltq_mm_probe,
+	.remove = ltq_mm_remove,
 	.driver = {
 		.name = "gpio-mm-ltq",
 		.of_match_table = ltq_mm_match,
@@ -142,3 +154,9 @@ static int __init ltq_mm_init(void)
 }
 
 subsys_initcall(ltq_mm_init);
+
+static void __exit ltq_mm_exit(void)
+{
+	platform_driver_unregister(&ltq_mm_driver);
+}
+module_exit(ltq_mm_exit);
-- 
2.1.4

