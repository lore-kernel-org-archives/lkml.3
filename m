Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277Ab3GHN33 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 09:29:29 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:38737 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119Ab3GHN30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 09:29:26 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, Michal Simek <michal.simek@xilinx.com>,
        Mark Brown <broonie@kernel.org>, linux-spi <linux-spi@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        spi-devel-general@lists.sourceforge.net
Subject: [PATCH v1 2/4] spi/xilinx: Clean ioremap calling
Date: Mon,  8 Jul 2013 15:29:15 +0200
Message-Id: <cc1bf277180140e94abaac7d3a8c2d6a723f7ad2.1373290150.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <ff70173bee5f9223ffea2b92b903b4e46ef8b323.1373290150.git.michal.simek@xilinx.com>
References: <ff70173bee5f9223ffea2b92b903b4e46ef8b323.1373290150.git.michal.simek@xilinx.com>
In-Reply-To: <ff70173bee5f9223ffea2b92b903b4e46ef8b323.1373290150.git.michal.simek@xilinx.com>
References: <ff70173bee5f9223ffea2b92b903b4e46ef8b323.1373290150.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-25823-1373290163-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-25823-1373290163-0001

devm_ioremap_resource() automatically checks that
struct resource is initialized.
Also group platform_get_resource() and devm_ioremap_resource()
together.
And remove mem resource from struct xilinx_spi.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
 drivers/spi/spi-xilinx.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/spi/spi-xilinx.c b/drivers/spi/spi-xilinx.c
index f3de5e5..c99c37b 100644
--- a/drivers/spi/spi-xilinx.c
+++ b/drivers/spi/spi-xilinx.c
@@ -80,7 +80,6 @@ struct xilinx_spi {
 	/* bitbang has to be first */
 	struct spi_bitbang bitbang;
 	struct completion done;
-	struct resource mem; /* phys mem */
 	void __iomem	*regs;	/* virt. address of the control registers */

 	u32		irq;
@@ -363,7 +362,7 @@ static int xilinx_spi_probe(struct platform_device *pdev)
 {
 	struct xilinx_spi *xspi;
 	struct xspi_platform_data *pdata;
-	struct resource *r;
+	struct resource *res;
 	int ret, irq, num_cs = 0, bits_per_word = 8;
 	struct spi_master *master;
 	u32 tmp;
@@ -392,10 +391,6 @@ static int xilinx_spi_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}

-	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!r)
-		return -ENODEV;
-
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0)
 		return -ENXIO;
@@ -415,7 +410,8 @@ static int xilinx_spi_probe(struct platform_device *pdev)
 	xspi->bitbang.master->setup = xilinx_spi_setup;
 	init_completion(&xspi->done);

-	xspi->regs = devm_ioremap_resource(&pdev->dev, r);
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	xspi->regs = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(xspi->regs)) {
 		ret = PTR_ERR(xspi->regs);
 		goto put_master;
@@ -425,7 +421,6 @@ static int xilinx_spi_probe(struct platform_device *pdev)
 	master->num_chipselect = num_cs;
 	master->dev.of_node = pdev->dev.of_node;

-	xspi->mem = *r;
 	xspi->irq = irq;

 	/*
@@ -477,7 +472,7 @@ static int xilinx_spi_probe(struct platform_device *pdev)
 	}

 	dev_info(&pdev->dev, "at 0x%08llX mapped to 0x%p, irq=%d\n",
-		(unsigned long long)r->start, xspi->regs, xspi->irq);
+		(unsigned long long)res->start, xspi->regs, xspi->irq);

 	if (pdata) {
 		for (i = 0; i < pdata->num_devices; i++)
--
1.8.2.3


--=_mimegpg-monstr-desktop-25823-1373290163-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlHavrMACgkQykllyylKDCG5owCeLfkrWfWog9O+BVlTF5rAu0sV
sBwAoJRVgE6ZxdBozKWxZg+oDwfhEoWi
=hG8h
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-25823-1373290163-0001--
