Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759338Ab3EWOCW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 10:02:22 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:62949 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759255Ab3EWOCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 10:02:18 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, Michal Simek <michal.simek@xilinx.com>,
        "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [RFC PATCH 2/2] uio: Add two platform uio drivers to one
Date: Thu, 23 May 2013 16:01:59 +0200
Message-Id: <71c482e15ee32fa304db73b984f6d5a63441cd92.1369317710.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <086bdaf83fe546bd3c7fe163e565a0887770770f.1369317710.git.michal.simek@xilinx.com>
References: <086bdaf83fe546bd3c7fe163e565a0887770770f.1369317710.git.michal.simek@xilinx.com>
In-Reply-To: <086bdaf83fe546bd3c7fe163e565a0887770770f.1369317710.git.michal.simek@xilinx.com>
References: <086bdaf83fe546bd3c7fe163e565a0887770770f.1369317710.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-8059-1369317734-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-8059-1369317734-0001

- Remove Userspace I/O platform driver without IRQ support
  but add this functionality to genirq driver
- Remove code duplication from OF binding

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
The main reason for this change is to have one
compatibility string for UIO with and without IRQ.

---
 drivers/uio/Kconfig           |   7 ---
 drivers/uio/Makefile          |   1 -
 drivers/uio/uio_pdrv.c        | 113 ------------------------------------------
 drivers/uio/uio_pdrv_genirq.c |  30 ++++-------
 4 files changed, 9 insertions(+), 142 deletions(-)
 delete mode 100644 drivers/uio/uio_pdrv.c

diff --git a/drivers/uio/Kconfig b/drivers/uio/Kconfig
index e92eeaf..2ff4c90 100644
--- a/drivers/uio/Kconfig
+++ b/drivers/uio/Kconfig
@@ -23,13 +23,6 @@ config UIO_CIF
 	  To compile this driver as a module, choose M here: the module
 	  will be called uio_cif.

-config UIO_PDRV
-	tristate "Userspace I/O platform driver"
-	help
-	  Generic platform driver for Userspace I/O devices.
-
-	  If you don't know what to do here, say N.
-
 config UIO_PDRV_GENIRQ
 	tristate "Userspace I/O platform driver with generic IRQ handling"
 	help
diff --git a/drivers/uio/Makefile b/drivers/uio/Makefile
index b354c53..ea015a2 100644
--- a/drivers/uio/Makefile
+++ b/drivers/uio/Makefile
@@ -1,6 +1,5 @@
 obj-$(CONFIG_UIO)	+= uio.o
 obj-$(CONFIG_UIO_CIF)	+= uio_cif.o
-obj-$(CONFIG_UIO_PDRV)	+= uio_pdrv.o
 obj-$(CONFIG_UIO_PDRV_GENIRQ)	+= uio_pdrv_genirq.o
 obj-$(CONFIG_UIO_DMEM_GENIRQ)	+= uio_dmem_genirq.o
 obj-$(CONFIG_UIO_AEC)	+= uio_aec.o
diff --git a/drivers/uio/uio_pdrv.c b/drivers/uio/uio_pdrv.c
deleted file mode 100644
index 39be9e0..0000000
--- a/drivers/uio/uio_pdrv.c
+++ /dev/null
@@ -1,113 +0,0 @@
-/*
- * drivers/uio/uio_pdrv.c
- *
- * Copyright (C) 2008 by Digi International Inc.
- * All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License version 2 as published by
- * the Free Software Foundation.
- */
-#include <linux/platform_device.h>
-#include <linux/uio_driver.h>
-#include <linux/stringify.h>
-#include <linux/module.h>
-#include <linux/slab.h>
-
-#define DRIVER_NAME "uio_pdrv"
-
-struct uio_platdata {
-	struct uio_info *uioinfo;
-};
-
-static int uio_pdrv_probe(struct platform_device *pdev)
-{
-	struct uio_info *uioinfo = pdev->dev.platform_data;
-	struct uio_platdata *pdata;
-	struct uio_mem *uiomem;
-	int ret = -ENODEV;
-	int i;
-
-	if (!uioinfo || !uioinfo->name || !uioinfo->version) {
-		dev_dbg(&pdev->dev, "%s: err_uioinfo\n", __func__);
-		goto err_uioinfo;
-	}
-
-	pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
-	if (!pdata) {
-		ret = -ENOMEM;
-		dev_dbg(&pdev->dev, "%s: err_alloc_pdata\n", __func__);
-		goto err_alloc_pdata;
-	}
-
-	pdata->uioinfo = uioinfo;
-
-	uiomem = &uioinfo->mem[0];
-
-	for (i = 0; i < pdev->num_resources; ++i) {
-		struct resource *r = &pdev->resource[i];
-
-		if (r->flags != IORESOURCE_MEM)
-			continue;
-
-		if (uiomem >= &uioinfo->mem[MAX_UIO_MAPS]) {
-			dev_warn(&pdev->dev, "device has more than "
-					__stringify(MAX_UIO_MAPS)
-					" I/O memory resources.\n");
-			break;
-		}
-
-		uiomem->memtype = UIO_MEM_PHYS;
-		uiomem->addr = r->start;
-		uiomem->size = resource_size(r);
-		uiomem->name = r->name;
-		++uiomem;
-	}
-
-	while (uiomem < &uioinfo->mem[MAX_UIO_MAPS]) {
-		uiomem->size = 0;
-		++uiomem;
-	}
-
-	pdata->uioinfo->priv = pdata;
-
-	ret = uio_register_device(&pdev->dev, pdata->uioinfo);
-
-	if (ret) {
-		kfree(pdata);
-err_alloc_pdata:
-err_uioinfo:
-		return ret;
-	}
-
-	platform_set_drvdata(pdev, pdata);
-
-	return 0;
-}
-
-static int uio_pdrv_remove(struct platform_device *pdev)
-{
-	struct uio_platdata *pdata = platform_get_drvdata(pdev);
-
-	uio_unregister_device(pdata->uioinfo);
-
-	kfree(pdata);
-
-	return 0;
-}
-
-static struct platform_driver uio_pdrv = {
-	.probe = uio_pdrv_probe,
-	.remove = uio_pdrv_remove,
-	.driver = {
-		.name = DRIVER_NAME,
-		.owner = THIS_MODULE,
-	},
-};
-
-module_platform_driver(uio_pdrv);
-
-MODULE_AUTHOR("Uwe Kleine-Koenig");
-MODULE_DESCRIPTION("Userspace I/O platform driver");
-MODULE_LICENSE("GPL v2");
-MODULE_ALIAS("platform:" DRIVER_NAME);
diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
index d7ba355..ccd2750 100644
--- a/drivers/uio/uio_pdrv_genirq.c
+++ b/drivers/uio/uio_pdrv_genirq.c
@@ -103,8 +103,6 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
 	int i;

 	if (pdev->dev.of_node) {
-		int irq;
-
 		/* alloc uioinfo for one device */
 		uioinfo = kzalloc(sizeof(*uioinfo), GFP_KERNEL);
 		if (!uioinfo) {
@@ -114,13 +112,6 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
 		}
 		uioinfo->name = pdev->dev.of_node->name;
 		uioinfo->version = "devicetree";
-
-		/* Multiple IRQs are not supported */
-		irq = platform_get_irq(pdev, 0);
-		if (irq == -ENXIO)
-			uioinfo->irq = UIO_IRQ_NONE;
-		else
-			uioinfo->irq = irq;
 	}

 	if (!uioinfo || !uioinfo->name || !uioinfo->version) {
@@ -146,14 +137,6 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
 	priv->flags = 0; /* interrupt is enabled to begin with */
 	priv->pdev = pdev;

-	if (!uioinfo->irq) {
-		ret = platform_get_irq(pdev, 0);
-		if (ret < 0) {
-			dev_err(&pdev->dev, "failed to get IRQ\n");
-			goto bad0;
-		}
-		uioinfo->irq = ret;
-	}
 	uiomem = &uioinfo->mem[0];

 	for (i = 0; i < pdev->num_resources; ++i) {
@@ -190,10 +173,15 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
 	 * Interrupt sharing is not supported.
 	 */

-	uioinfo->handler = uio_pdrv_genirq_handler;
-	uioinfo->irqcontrol = uio_pdrv_genirq_irqcontrol;
-	uioinfo->open = uio_pdrv_genirq_open;
-	uioinfo->release = uio_pdrv_genirq_release;
+	ret = platform_get_irq(pdev, 0);
+	if (ret >= 0) {
+		uioinfo->irq = ret;
+		uioinfo->handler = uio_pdrv_genirq_handler;
+		uioinfo->irqcontrol = uio_pdrv_genirq_irqcontrol;
+		uioinfo->open = uio_pdrv_genirq_open;
+		uioinfo->release = uio_pdrv_genirq_release;
+	}
+
 	uioinfo->priv = priv;

 	/* Enable Runtime PM for this device:
--
1.8.2.3


--=_mimegpg-monstr-desktop-8059-1369317734-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlGeIWYACgkQykllyylKDCFbmACfX9ZW4lcRRMkVynr9E7kqu7hw
60AAnAp9jAn0jy7XktF+oJP2v6FxYafe
=KrEb
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-8059-1369317734-0001--
