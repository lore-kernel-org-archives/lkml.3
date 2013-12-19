Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601Ab3LSPFt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:05:49 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:57559 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754532Ab3LSPFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:05:25 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu, wsa@the-dreams.de,
        joe@perches.com
Cc: Kedareswara rao Appana <appana.durga.rao@xilinx.com>,
        Jingoo Han <jg1.han@samsung.com>, Jean Delvare <khali@linux-fr.org>,
        Peter Korsgaard <jacmet@sunsite.dk>, linux-i2c@vger.kernel.org
Subject: [PATCH v5 3/3] i2c: xilinx: Use devm_* functions
Date: Thu, 19 Dec 2013 16:05:06 +0100
Message-Id: <e73deb41a2955f016a16f0773c470cc0c716f95f.1387465488.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <c220f51fd2ee7a5d65afa805a62582bd23e4d599.1387465488.git.michal.simek@xilinx.com>
References: <c220f51fd2ee7a5d65afa805a62582bd23e4d599.1387465488.git.michal.simek@xilinx.com>
In-Reply-To: <c220f51fd2ee7a5d65afa805a62582bd23e4d599.1387465488.git.michal.simek@xilinx.com>
References: <c220f51fd2ee7a5d65afa805a62582bd23e4d599.1387465488.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-14328-1387465521-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-14328-1387465521-0001

From: Kedareswara rao Appana <appana.durga.rao@xilinx.com>

Simplified the probe and remove functions using devm_* functions

Signed-off-by: Kedareswara rao Appana <appanad@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

Changes in v5:
- dev_get_platdata casting was removed in
"i2c: xiic: Remove casting the return value which is a void pointer"
(sha1: ab0dc7a81df2595a18b328d2c7031b00bd7efb1e) that's why
I have created next series.
- Rebased on v3.13-rc4

Changes in v4:
- Remove dev_get_platdata casting

Changes in v3:
- Remove error message which is already shown by devm_ioremap_resource
- Fix dev_get_platform recasting to simple (void *)
- Path 2/3 was removed because it was created on broken hw design
  and it was replaced by the patch which fixed irq handler registration
  and irq enabling. This patch reflect this new change in 2/3

Changes in v2: None

 drivers/i2c/busses/i2c-xiic.c | 65 ++++++++++---------------------------------
 1 file changed, 15 insertions(+), 50 deletions(-)

diff --git a/drivers/i2c/busses/i2c-xiic.c b/drivers/i2c/busses/i2c-xiic.c
index 2d55989..6f9918f 100644
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
@@ -697,33 +698,21 @@ static int xiic_i2c_probe(struct platform_device *pdev)
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
+		return irq;

 	pdata = dev_get_platdata(&pdev->dev);

-	i2c = kzalloc(sizeof(*i2c), GFP_KERNEL);
-	if (!i2c)
-		return -ENOMEM;
-
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
-
 	/* hook up driver to tree */
 	platform_set_drvdata(pdev, i2c);
 	i2c->adap = xiic_adapter;
@@ -733,10 +722,11 @@ static int xiic_i2c_probe(struct platform_device *pdev)

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
@@ -745,7 +735,8 @@ static int xiic_i2c_probe(struct platform_device *pdev)
 	ret = i2c_add_adapter(&i2c->adap);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to add adapter\n");
-		goto add_adapter_failed;
+		xiic_deinit(i2c);
+		return ret;
 	}

 	if (pdata) {
@@ -755,43 +746,17 @@ static int xiic_i2c_probe(struct platform_device *pdev)
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


--=_mimegpg-monstr-desktop-14328-1387465521-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlKzCzEACgkQykllyylKDCGcKACghHA63vMXN/GGfOc9KhcesInw
/HIAn2Gvt4ATUYfr6ezXVEYkbA8GErZ9
=GK8l
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-14328-1387465521-0001--
