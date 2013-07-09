Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab3GIQF2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 12:05:28 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54345 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224Ab3GIQFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 12:05:25 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: Mark Brown <broonie@kernel.org>
Cc: Michal Simek <monstr@monstr.eu>, Grant Likely <grant.likely@linaro.org>,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] spi/xilinx: Simplify irq allocation
Date: Tue,  9 Jul 2013 18:05:16 +0200
Message-Id: <348754a6cc4e7e05c7062d1b8b681638870a6894.1373385910.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-28905-1373385916-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-28905-1373385916-0001

Use devm_request_irq() for irq allocation which
simplify driver code.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
Changes in v2:
- Disable interrupts in xilinx_spi_remove() to be sure
  that interrupt won't come between struct freeing
  and devres irq unregistration.

---
 drivers/spi/spi-xilinx.c | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/spi/spi-xilinx.c b/drivers/spi/spi-xilinx.c
index 1c33720..fea815c 100644
--- a/drivers/spi/spi-xilinx.c
+++ b/drivers/spi/spi-xilinx.c
@@ -359,7 +359,7 @@ static int xilinx_spi_probe(struct platform_device *pdev)
 	struct xilinx_spi *xspi;
 	struct xspi_platform_data *pdata;
 	struct resource *res;
-	int ret, irq, num_cs = 0, bits_per_word = 8;
+	int ret, num_cs = 0, bits_per_word = 8;
 	struct spi_master *master;
 	u32 tmp;
 	u8 i;
@@ -379,10 +379,6 @@ static int xilinx_spi_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}

-	irq = platform_get_irq(pdev, 0);
-	if (irq < 0)
-		return -ENXIO;
-
 	master = spi_alloc_master(&pdev->dev, sizeof(struct xilinx_spi));
 	if (!master)
 		return -ENODEV;
@@ -409,8 +405,6 @@ static int xilinx_spi_probe(struct platform_device *pdev)
 	master->num_chipselect = num_cs;
 	master->dev.of_node = pdev->dev.of_node;

-	xspi->irq = irq;
-
 	/*
 	 * Detect endianess on the IP via loop bit in CR. Detection
 	 * must be done before reset is sent because incorrect reset
@@ -444,19 +438,25 @@ static int xilinx_spi_probe(struct platform_device *pdev)
 		goto put_master;
 	}

-
 	/* SPI controller initializations */
 	xspi_init_hw(xspi);

+	xspi->irq = platform_get_irq(pdev, 0);
+	if (xspi->irq < 0) {
+		ret = xspi->irq;
+		goto put_master;
+	}
+
 	/* Register for SPI Interrupt */
-	ret = request_irq(xspi->irq, xilinx_spi_irq, 0, XILINX_SPI_NAME, xspi);
+	ret = devm_request_irq(&pdev->dev, xspi->irq, xilinx_spi_irq, 0,
+			       dev_name(&pdev->dev), xspi);
 	if (ret)
 		goto put_master;

 	ret = spi_bitbang_start(&xspi->bitbang);
 	if (ret) {
 		dev_err(&pdev->dev, "spi_bitbang_start FAILED\n");
-		goto free_irq;
+		goto put_master;
 	}

 	dev_info(&pdev->dev, "at 0x%08llX mapped to 0x%p, irq=%d\n",
@@ -470,8 +470,6 @@ static int xilinx_spi_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, master);
 	return 0;

-free_irq:
-	free_irq(xspi->irq, xspi);
 put_master:
 	spi_master_put(master);

@@ -482,9 +480,14 @@ static int xilinx_spi_remove(struct platform_device *pdev)
 {
 	struct spi_master *master = platform_get_drvdata(pdev);
 	struct xilinx_spi *xspi = spi_master_get_devdata(master);
+	void __iomem *regs_base = xspi->regs;

 	spi_bitbang_stop(&xspi->bitbang);
-	free_irq(xspi->irq, xspi);
+
+	/* Disable all the interrupts just in case */
+	xspi->write_fn(0, regs_base + XIPIF_V123B_IIER_OFFSET);
+	/* Disable the global IPIF interrupt */
+	xspi->write_fn(0, regs_base + XIPIF_V123B_DGIER_OFFSET);

 	spi_master_put(xspi->bitbang.master);

--
1.8.2.3


--=_mimegpg-monstr-desktop-28905-1373385916-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlHcNLwACgkQykllyylKDCFDCACfUfWa3sjSKZY5idJO4zsEPfgC
1R0An1cQ7FPMAua7Q6hqb4N2YlVAJFrz
=bK+8
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-28905-1373385916-0001--
