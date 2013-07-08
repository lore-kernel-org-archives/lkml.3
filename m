Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443Ab3GHN3v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 09:29:51 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:63396 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab3GHN32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 09:29:28 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, Michal Simek <michal.simek@xilinx.com>,
        Mark Brown <broonie@kernel.org>, linux-spi <linux-spi@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        spi-devel-general@lists.sourceforge.net
Subject: [PATCH v1 3/4] spi/xilinx: Simplify irq allocation
Date: Mon,  8 Jul 2013 15:29:16 +0200
Message-Id: <b4458c93742bd9dfe69e3553cf377a703c945f81.1373290150.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <ff70173bee5f9223ffea2b92b903b4e46ef8b323.1373290150.git.michal.simek@xilinx.com>
References: <ff70173bee5f9223ffea2b92b903b4e46ef8b323.1373290150.git.michal.simek@xilinx.com>
In-Reply-To: <ff70173bee5f9223ffea2b92b903b4e46ef8b323.1373290150.git.michal.simek@xilinx.com>
References: <ff70173bee5f9223ffea2b92b903b4e46ef8b323.1373290150.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-25837-1373290165-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-25837-1373290165-0001

Use devm_request_irq() for irq allocation which
simplify driver code.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
 drivers/spi/spi-xilinx.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/spi/spi-xilinx.c b/drivers/spi/spi-xilinx.c
index c99c37b..a6bb5b0 100644
--- a/drivers/spi/spi-xilinx.c
+++ b/drivers/spi/spi-xilinx.c
@@ -363,7 +363,7 @@ static int xilinx_spi_probe(struct platform_device *pdev)
 	struct xilinx_spi *xspi;
 	struct xspi_platform_data *pdata;
 	struct resource *res;
-	int ret, irq, num_cs = 0, bits_per_word = 8;
+	int ret, num_cs = 0, bits_per_word = 8;
 	struct spi_master *master;
 	u32 tmp;
 	u8 i;
@@ -391,10 +391,6 @@ static int xilinx_spi_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}

-	irq = platform_get_irq(pdev, 0);
-	if (irq < 0)
-		return -ENXIO;
-
 	master = spi_alloc_master(&pdev->dev, sizeof(struct xilinx_spi));
 	if (!master)
 		return -ENODEV;
@@ -421,8 +417,6 @@ static int xilinx_spi_probe(struct platform_device *pdev)
 	master->num_chipselect = num_cs;
 	master->dev.of_node = pdev->dev.of_node;

-	xspi->irq = irq;
-
 	/*
 	 * Detect endianess on the IP via loop bit in CR. Detection
 	 * must be done before reset is sent because incorrect reset
@@ -456,19 +450,25 @@ static int xilinx_spi_probe(struct platform_device *pdev)
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
@@ -482,8 +482,6 @@ static int xilinx_spi_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, master);
 	return 0;

-free_irq:
-	free_irq(xspi->irq, xspi);
 put_master:
 	spi_master_put(master);

@@ -495,7 +493,6 @@ static int xilinx_spi_remove(struct platform_device *pdev)
 	struct xilinx_spi *xspi = platform_get_drvdata(pdev);

 	spi_bitbang_stop(&xspi->bitbang);
-	free_irq(xspi->irq, xspi);

 	spi_master_put(xspi->bitbang.master);

--
1.8.2.3


--=_mimegpg-monstr-desktop-25837-1373290165-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlHavrUACgkQykllyylKDCFgjwCgh9kqRzvnmOcg1PuQc+JwJnhj
zUYAmgOvssjCrBVPJqU2BqcMW98fu2D9
=/bEO
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-25837-1373290165-0001--
