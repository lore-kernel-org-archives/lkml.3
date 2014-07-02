Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942AbaGBN6f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 09:58:35 -0400
Received: from mga11.intel.com ([192.55.52.93]:51686 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753121AbaGBN6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 09:58:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,588,1400050800"; 
   d="scan'208,223";a="564175242"
Message-ID: <1404309504.8366.93.camel@rzhang1-toshiba>
Subject: [PATCH] soc_button_array: fix the issue that button device can't be
 enumerated since 3.16-rc1
From: Zhang Rui <rui.zhang@intel.com>
To: dmitry.torokhov@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>, yao.jin@intel.com
Date: Wed, 02 Jul 2014 21:58:24 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From c2ee1886ba230d9d93d2ea2f350b1dc1a2d5ead5 Mon Sep 17 00:00:00 2001
From: Jin Yao <yao.jin@linux.intel.com>
Date: Thu, 26 Jun 2014 10:26:44 +0800
Subject: [PATCH] soc_button_array: fix the issue that button device can't be
 enumerated since 3.16-rc1

ACPI device enumeration mechanism changed a lot since 3.16-rc1.
ACPI device objects with _HID will be enumerated to platform bus by default.
For the existing PNP drivers that probe the PNPACPI devices, the device ids
are listed explicitly in drivers/acpi/acpi_pnp.c. And ACPI folks will
continue their effort on shrinking this id list by converting the PNP drivers
to platform drivers.
But unfortunately, soc_button_array device id, aka, "PNP0C40", is missing
during this transition.

Thus soc_button_array driver fails to probe any device since 3.16-rc1 because
the device is enumerated to platform bus instead.

A simply fix is to add device id PNP0C40 back to drivers/acpi/acpi_pnp.c,
but given that the soc_button_array driver will be converted to platform
driver sooner or later, and the id will be removed from the list again,
it is better to fix the problem in one time.

This patch fixes the problem by converting the soc_button_driver
from PNP bus to platform bus.

Signed-off-by: Jin Yao <yao.jin@intel.com>
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/input/misc/soc_button_array.c | 60 ++++++++++++++++++-----------------
 1 file changed, 31 insertions(+), 29 deletions(-)

diff --git a/drivers/input/misc/soc_button_array.c b/drivers/input/misc/soc_button_array.c
index 5a6334b..16ca162 100644
--- a/drivers/input/misc/soc_button_array.c
+++ b/drivers/input/misc/soc_button_array.c
@@ -18,7 +18,7 @@
 #include <linux/gpio/consumer.h>
 #include <linux/gpio_keys.h>
 #include <linux/platform_device.h>
-#include <linux/pnp.h>
+#include <linux/acpi.h>
 
 /*
  * Definition of buttons on the tablet. The ACPI index of each button
@@ -67,7 +67,7 @@ static int soc_button_lookup_gpio(struct device *dev, int acpi_index)
 }
 
 static struct platform_device *
-soc_button_device_create(struct pnp_dev *pdev,
+soc_button_device_create(struct platform_device *pdev,
 			 const struct soc_button_info *button_info,
 			 bool autorepeat)
 {
@@ -135,30 +135,40 @@ soc_button_device_create(struct pnp_dev *pdev,
 	return ERR_PTR(error);
 }
 
-static void soc_button_remove(struct pnp_dev *pdev)
+static int soc_button_remove(struct platform_device *pdev)
 {
-	struct soc_button_data *priv = pnp_get_drvdata(pdev);
+	struct soc_button_data *priv = platform_get_drvdata(pdev);
+
 	int i;
 
 	for (i = 0; i < BUTTON_TYPES; i++)
 		if (priv->children[i])
 			platform_device_unregister(priv->children[i]);
+
+	return 0;
 }
 
-static int soc_button_pnp_probe(struct pnp_dev *pdev,
-				const struct pnp_device_id *id)
+static int soc_button_probe(struct platform_device *pdev)
 {
-	const struct soc_button_info *button_info = (void *)id->driver_data;
+	struct device *dev = &pdev->dev;
+	const struct acpi_device_id *id;
+	struct soc_button_info *button_info;
 	struct soc_button_data *priv;
 	struct platform_device *pd;
 	int i;
 	int error;
 
+	id = acpi_match_device(dev->driver->acpi_match_table, dev);
+	if (!id)
+		return -ENODEV;
+
+	button_info = (struct soc_button_info *)id->driver_data;
+
 	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
-	pnp_set_drvdata(pdev, priv);
+	platform_set_drvdata(pdev, priv);
 
 	for (i = 0; i < BUTTON_TYPES; i++) {
 		pd = soc_button_device_create(pdev, button_info, i == 0);
@@ -189,30 +199,22 @@ static struct soc_button_info soc_button_PNP0C40[] = {
 	{ }
 };
 
-static const struct pnp_device_id soc_button_pnp_match[] = {
-	{ .id = "PNP0C40", .driver_data = (long)soc_button_PNP0C40 },
-	{ .id = "" }
+static const struct acpi_device_id soc_button_acpi_match[] = {
+	{ "PNP0C40", (unsigned long)soc_button_PNP0C40 },
+	{ }
 };
-MODULE_DEVICE_TABLE(pnp, soc_button_pnp_match);
 
-static struct pnp_driver soc_button_pnp_driver = {
-	.name		= KBUILD_MODNAME,
-	.id_table	= soc_button_pnp_match,
-	.probe          = soc_button_pnp_probe,
+MODULE_DEVICE_TABLE(acpi, soc_button_acpi_match);
+
+static struct platform_driver soc_button_driver = {
+	.probe          = soc_button_probe,
 	.remove		= soc_button_remove,
+	.driver		= {
+		.name = KBUILD_MODNAME,
+		.owner = THIS_MODULE,
+		.acpi_match_table = ACPI_PTR(soc_button_acpi_match),
+	},
 };
-
-static int __init soc_button_init(void)
-{
-	return pnp_register_driver(&soc_button_pnp_driver);
-}
-
-static void __exit soc_button_exit(void)
-{
-	pnp_unregister_driver(&soc_button_pnp_driver);
-}
-
-module_init(soc_button_init);
-module_exit(soc_button_exit);
+module_platform_driver(soc_button_driver);
 
 MODULE_LICENSE("GPL");
-- 
1.8.3.2



