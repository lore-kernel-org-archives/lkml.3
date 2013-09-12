Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638Ab3ILFkS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 01:40:18 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:46063 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab3ILFkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 01:40:16 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, Michal Simek <michal.simek@xilinx.com>,
        Pavel Machek <pavel@ucw.cz>, "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] uio: Simplify uio error path by using devres functions
Date: Thu, 12 Sep 2013 07:39:59 +0200
Message-Id: <c0afb787f4d36e0f4cfb055ce8c566acbe39beca.1378964390.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-16410-1378964399-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-16410-1378964399-0001

Using devres functions simplify driver error path.
- Use devm_kzalloc
- Use devm_request_irq

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
---
 drivers/uio/uio.c             | 16 ++++------------
 drivers/uio/uio_pdrv_genirq.c | 34 ++++++++++------------------------
 2 files changed, 14 insertions(+), 36 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index ba47563..11d4e0a 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -796,10 +796,9 @@ int __uio_register_device(struct module *owner,

 	info->uio_dev = NULL;

-	idev = kzalloc(sizeof(*idev), GFP_KERNEL);
+	idev = devm_kzalloc(parent, sizeof(*idev), GFP_KERNEL);
 	if (!idev) {
-		ret = -ENOMEM;
-		goto err_kzalloc;
+		return -ENOMEM;
 	}

 	idev->owner = owner;
@@ -809,7 +808,7 @@ int __uio_register_device(struct module *owner,

 	ret = uio_get_minor(idev);
 	if (ret)
-		goto err_get_minor;
+		return ret;

 	idev->dev = device_create(&uio_class, parent,
 				  MKDEV(uio_major, idev->minor), idev,
@@ -827,7 +826,7 @@ int __uio_register_device(struct module *owner,
 	info->uio_dev = idev;

 	if (info->irq && (info->irq != UIO_IRQ_CUSTOM)) {
-		ret = request_irq(info->irq, uio_interrupt,
+		ret = devm_request_irq(parent, info->irq, uio_interrupt,
 				  info->irq_flags, info->name, idev);
 		if (ret)
 			goto err_request_irq;
@@ -841,9 +840,6 @@ err_uio_dev_add_attributes:
 	device_destroy(&uio_class, MKDEV(uio_major, idev->minor));
 err_device_create:
 	uio_free_minor(idev);
-err_get_minor:
-	kfree(idev);
-err_kzalloc:
 	return ret;
 }
 EXPORT_SYMBOL_GPL(__uio_register_device);
@@ -864,13 +860,9 @@ void uio_unregister_device(struct uio_info *info)

 	uio_free_minor(idev);

-	if (info->irq && (info->irq != UIO_IRQ_CUSTOM))
-		free_irq(info->irq, idev);
-
 	uio_dev_del_attributes(idev);

 	device_destroy(&uio_class, MKDEV(uio_major, idev->minor));
-	kfree(idev);

 	return;
 }
diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
index 90ff17a..7666931 100644
--- a/drivers/uio/uio_pdrv_genirq.c
+++ b/drivers/uio/uio_pdrv_genirq.c
@@ -112,11 +112,11 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)

 	if (pdev->dev.of_node) {
 		/* alloc uioinfo for one device */
-		uioinfo = kzalloc(sizeof(*uioinfo), GFP_KERNEL);
+		uioinfo = devm_kzalloc(&pdev->dev, sizeof(*uioinfo),
+				       GFP_KERNEL);
 		if (!uioinfo) {
-			ret = -ENOMEM;
 			dev_err(&pdev->dev, "unable to kmalloc\n");
-			return ret;
+			return -ENOMEM;
 		}
 		uioinfo->name = pdev->dev.of_node->name;
 		uioinfo->version = "devicetree";
@@ -125,20 +125,19 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)

 	if (!uioinfo || !uioinfo->name || !uioinfo->version) {
 		dev_err(&pdev->dev, "missing platform_data\n");
-		goto bad0;
+		return ret;
 	}

 	if (uioinfo->handler || uioinfo->irqcontrol ||
 	    uioinfo->irq_flags & IRQF_SHARED) {
 		dev_err(&pdev->dev, "interrupt configuration error\n");
-		goto bad0;
+		return ret;
 	}

-	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv) {
-		ret = -ENOMEM;
 		dev_err(&pdev->dev, "unable to kmalloc\n");
-		goto bad0;
+		return -ENOMEM;
 	}

 	priv->uioinfo = uioinfo;
@@ -153,7 +152,7 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
 			uioinfo->irq = UIO_IRQ_NONE;
 		else if (ret < 0) {
 			dev_err(&pdev->dev, "failed to get IRQ\n");
-			goto bad1;
+			return ret;
 		}
 	}

@@ -209,20 +208,12 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
 	ret = uio_register_device(&pdev->dev, priv->uioinfo);
 	if (ret) {
 		dev_err(&pdev->dev, "unable to register uio device\n");
-		goto bad2;
+		pm_runtime_disable(&pdev->dev);
+		return ret;
 	}

 	platform_set_drvdata(pdev, priv);
 	return 0;
- bad2:
-	pm_runtime_disable(&pdev->dev);
- bad1:
-	kfree(priv);
- bad0:
-	/* kfree uioinfo for OF */
-	if (pdev->dev.of_node)
-		kfree(uioinfo);
-	return ret;
 }

 static int uio_pdrv_genirq_remove(struct platform_device *pdev)
@@ -235,11 +226,6 @@ static int uio_pdrv_genirq_remove(struct platform_device *pdev)
 	priv->uioinfo->handler = NULL;
 	priv->uioinfo->irqcontrol = NULL;

-	/* kfree uioinfo for OF */
-	if (pdev->dev.of_node)
-		kfree(priv->uioinfo);
-
-	kfree(priv);
 	return 0;
 }

--
1.8.2.3


--=_mimegpg-monstr-desktop-16410-1378964399-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlIxU7AACgkQykllyylKDCHW0wCfYFO2nszdINrW9UXNcgjxlh5o
Io0Anjp5j09J4pw8inMTDfs2GqLEUfHG
=sb7B
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-16410-1378964399-0001--
