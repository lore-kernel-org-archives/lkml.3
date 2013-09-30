Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159Ab3I3JJQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 05:09:16 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:51661 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100Ab3I3JJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 05:09:10 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Kedareswara rao Appana <appana.durga.rao@xilinx.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Kedareswara rao Appana <appanad@xilinx.com>,
        Jean Delvare <khali@linux-fr.org>, Peter Korsgaard <jacmet@sunsite.dk>,
        linux-i2c@vger.kernel.org
Subject: [PATCH 3/3] i2c: xilinx: Use devm_* functions
Date: Mon, 30 Sep 2013 11:08:52 +0200
Message-Id: <5962fbc321c28489325678809453eb585ea9ef31.1380532113.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <c122ad49b27406ee495ef0d6cac191968d64f09f.1380532113.git.michal.simek@xilinx.com>
References: <c122ad49b27406ee495ef0d6cac191968d64f09f.1380532113.git.michal.simek@xilinx.com>
In-Reply-To: <c122ad49b27406ee495ef0d6cac191968d64f09f.1380532113.git.michal.simek@xilinx.com>
References: <c122ad49b27406ee495ef0d6cac191968d64f09f.1380532113.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-3926-1380532147-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-3926-1380532147-0001

From: Kedareswara rao Appana <appana.durga.rao@xilinx.com>

Simplified the probe and remove functions using devm_* functions

Signed-off-by: Kedareswara rao Appana <appanad@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
 drivers/i2c/busses/i2c-xiic.c | 69 +++++++++++--------------------------------
 1 file changed, 18 insertions(+), 51 deletions(-)

diff --git a/drivers/i2c/busses/i2c-xiic.c b/drivers/i2c/busses/i2c-xiic.c
index 44e6ae7..6dd3212 100644
--- a/drivers/i2c/busses/i2c-xiic.c
+++ b/drivers/i2c/busses/i2c-xiic.c
@@ -32,6 +32,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/errno.h>
+#include <linux/err.h>
 #include <linux/delay.h>
 #include <linux/platform_device.h>
 #include <linux/i2c.h>
@@ -698,32 +699,28 @@ static int xiic_i2c_probe(struct platform_device *pdev)
 	int ret, irq;
 	u8 i;

+	i2c = devm_kzalloc(&pdev->dev, sizeof(*i2c), GFP_KERNEL);
+	if (!i2c)
+		return -ENOMEM;
+
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		goto resource_missing;
+	i2c->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(i2c->base)) {
+		dev_err(&pdev->dev, "Could not allocate iomem\n");
+		return PTR_ERR(i2c->base);
+	}

 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0)
-		goto resource_missing;
-
-	pdata = (struct xiic_i2c_platform_data *)dev_get_platdata(&pdev->dev);
+		return irq;

-	i2c = kzalloc(sizeof(*i2c), GFP_KERNEL);
-	if (!i2c)
-		return -ENOMEM;
-
-	if (!request_mem_region(res->start, resource_size(res), pdev->name)) {
-		dev_err(&pdev->dev, "Memory region busy\n");
-		ret = -EBUSY;
-		goto request_mem_failed;
+	ret = devm_request_irq(&pdev->dev, irq, xiic_isr, 0, pdev->name, i2c);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Cannot claim IRQ\n");
+		return ret;
 	}

-	i2c->base = ioremap(res->start, resource_size(res));
-	if (!i2c->base) {
-		dev_err(&pdev->dev, "Unable to map registers\n");
-		ret = -EIO;
-		goto map_failed;
-	}
+	pdata = (struct xiic_i2c_platform_data *)dev_get_platdata(&pdev->dev);

 	/* hook up driver to tree */
 	platform_set_drvdata(pdev, i2c);
@@ -736,17 +733,13 @@ static int xiic_i2c_probe(struct platform_device *pdev)

 	spin_lock_init(&i2c->lock);
 	init_waitqueue_head(&i2c->wait);
-	ret = request_irq(irq, xiic_isr, 0, pdev->name, i2c);
-	if (ret) {
-		dev_err(&pdev->dev, "Cannot claim IRQ\n");
-		goto request_irq_failed;
-	}

 	/* add i2c adapter to i2c tree */
 	ret = i2c_add_adapter(&i2c->adap);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to add adapter\n");
-		goto add_adapter_failed;
+		xiic_deinit(i2c);
+		return ret;
 	}

 	if (pdata) {
@@ -756,43 +749,17 @@ static int xiic_i2c_probe(struct platform_device *pdev)
 	}

 	return 0;
-
-add_adapter_failed:
-	free_irq(irq, i2c);
-request_irq_failed:
-	xiic_deinit(i2c);
-	iounmap(i2c->base);
-map_failed:
-	release_mem_region(res->start, resource_size(res));
-request_mem_failed:
-	kfree(i2c);
-
-	return ret;
-resource_missing:
-	dev_err(&pdev->dev, "IRQ or Memory resource is missing\n");
-	return -ENOENT;
 }

 static int xiic_i2c_remove(struct platform_device *pdev)
 {
 	struct xiic_i2c *i2c = platform_get_drvdata(pdev);
-	struct resource *res;

 	/* remove adapter & data */
 	i2c_del_adapter(&i2c->adap);

 	xiic_deinit(i2c);

-	free_irq(platform_get_irq(pdev, 0), i2c);
-
-	iounmap(i2c->base);
-
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (res)
-		release_mem_region(res->start, resource_size(res));
-
-	kfree(i2c);
-
 	return 0;
 }

--
1.8.2.3


--=_mimegpg-monstr-desktop-3926-1380532147-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlJJP7MACgkQykllyylKDCGB9ACglcWndc3WJXgtdKuH3XTlnRZ8
rasAn1Jmq4GsN0g16cTDwXJPpGaNZpqp
=dm1M
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-3926-1380532147-0001--
