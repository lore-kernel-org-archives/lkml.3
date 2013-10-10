Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab3JJKkH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 06:40:07 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:50835 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747Ab3JJKjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 06:39:45 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu, wsa@the-dreams.de
Cc: Kedareswara rao Appana <appana.durga.rao@xilinx.com>,
        Jean Delvare <khali@linux-fr.org>, Peter Korsgaard <jacmet@sunsite.dk>,
        Kedareswara rao Appana <appanad@xilinx.com>, linux-i2c@vger.kernel.org
Subject: [PATCH v3 3/3] i2c: xilinx: Use devm_* functions
Date: Thu, 10 Oct 2013 12:39:38 +0200
Message-Id: <9691811c34ee339b1f5e3ed2acdea0796fc80788.1381401561.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <f3fd6f38d2553e59b077edff1969f4d07f8aa811.1381401561.git.michal.simek@xilinx.com>
References: <f3fd6f38d2553e59b077edff1969f4d07f8aa811.1381401561.git.michal.simek@xilinx.com>
In-Reply-To: <f3fd6f38d2553e59b077edff1969f4d07f8aa811.1381401561.git.michal.simek@xilinx.com>
References: <f3fd6f38d2553e59b077edff1969f4d07f8aa811.1381401561.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-11235-1381401582-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-11235-1381401582-0001

From: Kedareswara rao Appana <appana.durga.rao@xilinx.com>

Simplified the probe and remove functions using devm_* functions

Signed-off-by: Kedareswara rao Appana <appanad@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
Changes in v3:
- Remove error message which is already shown by devm_ioremap_resource
- Fix dev_get_platform recasting to simple (void *)
- Path 2/3 was removed because it was created on broken hw design
  and it was replaced by the patch which fixed irq handler registration
  and irq enabling. This patch reflect this new change in 2/3

Changes in v2: None

 drivers/i2c/busses/i2c-xiic.c | 67 +++++++++++--------------------------------
 1 file changed, 16 insertions(+), 51 deletions(-)

diff --git a/drivers/i2c/busses/i2c-xiic.c b/drivers/i2c/busses/i2c-xiic.c
index 183fea4..e1f8920 100644
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
@@ -693,32 +694,20 @@ static int xiic_i2c_probe(struct platform_device *pdev)
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
+	if (IS_ERR(i2c->base))
+		return PTR_ERR(i2c->base);

 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0)
-		goto resource_missing;
-
-	pdata = (struct xiic_i2c_platform_data *)dev_get_platdata(&pdev->dev);
-
-	i2c = kzalloc(sizeof(*i2c), GFP_KERNEL);
-	if (!i2c)
-		return -ENOMEM;
+		return irq;

-	if (!request_mem_region(res->start, resource_size(res), pdev->name)) {
-		dev_err(&pdev->dev, "Memory region busy\n");
-		ret = -EBUSY;
-		goto request_mem_failed;
-	}
-
-	i2c->base = ioremap(res->start, resource_size(res));
-	if (!i2c->base) {
-		dev_err(&pdev->dev, "Unable to map registers\n");
-		ret = -EIO;
-		goto map_failed;
-	}
+	pdata = (void *)dev_get_platdata(&pdev->dev);

 	/* hook up driver to tree */
 	platform_set_drvdata(pdev, i2c);
@@ -729,10 +718,11 @@ static int xiic_i2c_probe(struct platform_device *pdev)

 	spin_lock_init(&i2c->lock);
 	init_waitqueue_head(&i2c->wait);
-	ret = request_irq(irq, xiic_isr, 0, pdev->name, i2c);
-	if (ret) {
+
+	ret = devm_request_irq(&pdev->dev, irq, xiic_isr, 0, pdev->name, i2c);
+	if (ret < 0) {
 		dev_err(&pdev->dev, "Cannot claim IRQ\n");
-		goto request_irq_failed;
+		return ret;
 	}

 	xiic_reinit(i2c);
@@ -741,7 +731,8 @@ static int xiic_i2c_probe(struct platform_device *pdev)
 	ret = i2c_add_adapter(&i2c->adap);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to add adapter\n");
-		goto add_adapter_failed;
+		xiic_deinit(i2c);
+		return ret;
 	}

 	if (pdata) {
@@ -751,43 +742,17 @@ static int xiic_i2c_probe(struct platform_device *pdev)
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


--=_mimegpg-monstr-desktop-11235-1381401582-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlJWg+4ACgkQykllyylKDCGqaQCeIsxjntEisobe7sI99vNx3Slu
ougAoIuguQH8jG6zCy/T8Kdh+y22xoj5
=AAD4
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-11235-1381401582-0001--
