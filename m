Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771Ab3FDODC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:03:02 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:32961 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507Ab3FDOC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:02:56 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, Michal Simek <michal.simek@xilinx.com>,
        Peter Crosthwaite <pcrost@xilinx.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        spi-devel-general@lists.sourceforge.net
Subject: [PATCH 3/3] spi: spi-xilinx: Add run run-time endian detection
Date: Tue,  4 Jun 2013 16:02:36 +0200
Message-Id: <85e2cc9ef188d475c531780d9ee338705a1df673.1370354549.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <041d7ca272ef9499fab630294e3395110b3e31ac.1370354549.git.michal.simek@xilinx.com>
References: <041d7ca272ef9499fab630294e3395110b3e31ac.1370354549.git.michal.simek@xilinx.com>
In-Reply-To: <041d7ca272ef9499fab630294e3395110b3e31ac.1370354549.git.michal.simek@xilinx.com>
References: <041d7ca272ef9499fab630294e3395110b3e31ac.1370354549.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-11188-1370354572-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-11188-1370354572-0001

Do not load endian value from platform data
and rather autodetect it.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
 drivers/mfd/timberdale.c       |  1 -
 drivers/spi/spi-xilinx.c       | 29 +++++++++++++++++++++--------
 include/linux/spi/xilinx_spi.h |  1 -
 3 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/mfd/timberdale.c b/drivers/mfd/timberdale.c
index 59e0ee2..0c1fcbc 100644
--- a/drivers/mfd/timberdale.c
+++ b/drivers/mfd/timberdale.c
@@ -145,7 +145,6 @@ static struct spi_board_info timberdale_spi_8bit_board_info[] = {

 static struct xspi_platform_data timberdale_xspi_platform_data = {
 	.num_chipselect = 3,
-	.little_endian = true,
 	/* bits per word and devices will be filled in runtime depending
 	 * on the HW config
 	 */
diff --git a/drivers/spi/spi-xilinx.c b/drivers/spi/spi-xilinx.c
index d690756..0b7b8d7 100644
--- a/drivers/spi/spi-xilinx.c
+++ b/drivers/spi/spi-xilinx.c
@@ -30,6 +30,7 @@
  */
 #define XSPI_CR_OFFSET		0x60	/* Control Register */

+#define XSPI_CR_LOOP		0x01
 #define XSPI_CR_ENABLE		0x02
 #define XSPI_CR_MASTER_MODE	0x04
 #define XSPI_CR_CPOL		0x08
@@ -355,11 +356,12 @@ static const struct of_device_id xilinx_spi_of_match[] = {
 MODULE_DEVICE_TABLE(of, xilinx_spi_of_match);

 struct spi_master *xilinx_spi_init(struct device *dev, struct resource *mem,
-	u32 irq, s16 bus_num, int num_cs, int little_endian, int bits_per_word)
+	u32 irq, s16 bus_num, int num_cs, int bits_per_word)
 {
 	struct spi_master *master;
 	struct xilinx_spi *xspi;
 	int ret;
+	u32 tmp;

 	master = spi_alloc_master(dev, sizeof(struct xilinx_spi));
 	if (!master)
@@ -395,13 +397,25 @@ struct spi_master *xilinx_spi_init(struct device *dev, struct resource *mem,

 	xspi->mem = *mem;
 	xspi->irq = irq;
-	if (little_endian) {
-		xspi->read_fn = xspi_read32;
-		xspi->write_fn = xspi_write32;
-	} else {
+
+	/*
+	 * Detect endianess on the IP via loop bit in CR. Detection
+	 * must be done before reset is sent because incorrect reset
+	 * value generates error interrupt.
+	 * Setup little endian helper functions first and try to use them
+	 * and check if bit was correctly setup or not.
+	 */
+	xspi->read_fn = xspi_read32;
+	xspi->write_fn = xspi_write32;
+
+	xspi->write_fn(XSPI_CR_LOOP, xspi->regs + XSPI_CR_OFFSET);
+	tmp = xspi->read_fn(xspi->regs + XSPI_CR_OFFSET);
+	tmp &= XSPI_CR_LOOP;
+	if (tmp != XSPI_CR_LOOP) {
 		xspi->read_fn = xspi_read32_be;
 		xspi->write_fn = xspi_write32_be;
 	}
+
 	xspi->bits_per_word = bits_per_word;
 	if (xspi->bits_per_word == 8) {
 		xspi->tx_fn = xspi_tx8;
@@ -465,14 +479,13 @@ static int xilinx_spi_probe(struct platform_device *dev)
 {
 	struct xspi_platform_data *pdata;
 	struct resource *r;
-	int irq, num_cs = 0, little_endian = 0, bits_per_word = 8;
+	int irq, num_cs = 0, bits_per_word = 8;
 	struct spi_master *master;
 	u8 i;

 	pdata = dev->dev.platform_data;
 	if (pdata) {
 		num_cs = pdata->num_chipselect;
-		little_endian = pdata->little_endian;
 		bits_per_word = pdata->bits_per_word;
 	}

@@ -504,7 +517,7 @@ static int xilinx_spi_probe(struct platform_device *dev)
 		return -ENXIO;

 	master = xilinx_spi_init(&dev->dev, r, irq, dev->id, num_cs,
-				 little_endian, bits_per_word);
+				 bits_per_word);
 	if (!master)
 		return -ENODEV;

diff --git a/include/linux/spi/xilinx_spi.h b/include/linux/spi/xilinx_spi.h
index 6f17278..333ecdf 100644
--- a/include/linux/spi/xilinx_spi.h
+++ b/include/linux/spi/xilinx_spi.h
@@ -11,7 +11,6 @@
  */
 struct xspi_platform_data {
 	u16 num_chipselect;
-	bool little_endian;
 	u8 bits_per_word;
 	struct spi_board_info *devices;
 	u8 num_devices;
--
1.8.2.3


--=_mimegpg-monstr-desktop-11188-1370354572-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlGt84wACgkQykllyylKDCE70wCffu2N+maeuc6B3jdlbcKoxLZz
+5UAoJraYusPHM0mA5OZdB3ofUaAYzGX
=aARs
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-11188-1370354572-0001--
