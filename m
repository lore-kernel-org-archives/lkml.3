Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618Ab3GJHZz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 03:25:55 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:34195 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320Ab3GJHZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 03:25:36 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: Mark Brown <broonie@kernel.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>, Michal Simek <monstr@monstr.eu>,
        Grant Likely <grant.likely@linaro.org>, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v1] spi/xilinx: Revert master->setup function removal
Date: Wed, 10 Jul 2013 09:25:28 +0200
Message-Id: <adbc806cd75b1c1ffd6382dc1dae425c71a93168.1373441121.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-28369-1373441129-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-28369-1373441129-0001

master->setup() must be initialized to be able
to successfully run spi_bitbang_start()
and satisfy if/else logic there.

"spi: convert drivers to use bits_per_word_mask"
(sha1: 24778be20f87d5aadb19624fc768b3159fa43efc)

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
Based on the latest Linus tree.

---
 drivers/spi/spi-xilinx.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/spi/spi-xilinx.c b/drivers/spi/spi-xilinx.c
index fb56fcf..09a9428 100644
--- a/drivers/spi/spi-xilinx.c
+++ b/drivers/spi/spi-xilinx.c
@@ -233,6 +233,21 @@ static int xilinx_spi_setup_transfer(struct spi_device *spi,
 	return 0;
 }

+static int xilinx_spi_setup(struct spi_device *spi)
+{
+	/* always return 0, we can not check the number of bits.
+	 * There are cases when SPI setup is called before any driver is
+	 * there, in that case the SPI core defaults to 8 bits, which we
+	 * do not support in some cases. But if we return an error, the
+	 * SPI device would not be registered and no driver can get hold of it
+	 * When the driver is there, it will call SPI setup again with the
+	 * correct number of bits per transfer.
+	 * If a driver setups with the wrong bit number, it will fail when
+	 * it tries to do a transfer
+	 */
+	return 0;
+}
+
 static void xilinx_spi_fill_tx_fifo(struct xilinx_spi *xspi)
 {
 	u8 sr;
@@ -360,6 +375,7 @@ struct spi_master *xilinx_spi_init(struct device *dev, struct resource *mem,
 	xspi->bitbang.chipselect = xilinx_spi_chipselect;
 	xspi->bitbang.setup_transfer = xilinx_spi_setup_transfer;
 	xspi->bitbang.txrx_bufs = xilinx_spi_txrx_bufs;
+	xspi->bitbang.master->setup = xilinx_spi_setup;
 	init_completion(&xspi->done);

 	if (!request_mem_region(mem->start, resource_size(mem),
--
1.8.2.3


--=_mimegpg-monstr-desktop-28369-1373441129-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlHdDGkACgkQykllyylKDCHcpQCgmjSH4h4C8R2jfQmhHvTg5EWq
oWMAn3J7kh49efUS7H7y8BzzqkeoUmWW
=cJ2D
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-28369-1373441129-0001--
