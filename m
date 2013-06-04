Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342Ab3FDOCx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:02:53 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:45310 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333Ab3FDOCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:02:51 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, Michal Simek <michal.simek@xilinx.com>,
        Peter Crosthwaite <pcrost@xilinx.com>,
        Peter Crosthwaite <peter.crosthwaite@petalogix.com>,
        Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        spi-devel-general@lists.sourceforge.net
Subject: [PATCH 1/3] spi: spi-xilinx: Remove ISR race condition
Date: Tue,  4 Jun 2013 16:02:34 +0200
Message-Id: <041d7ca272ef9499fab630294e3395110b3e31ac.1370354549.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-11158-1370354557-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-11158-1370354557-0001

From: Peter Crosthwaite <peter.crosthwaite@petalogix.com>

The ISR currently consumes the rx buffer data and re-enables transmission
from within interrupt context. This is bad because if the interrupt
occurs again before the ISR exits, the new interrupt will be erroneously
cleared by the still completing ISR.

Simplified the ISR by just setting the completion variable and exiting with
no action. Then just looped the transmit functionality in
xilinx_spi_txrx_bufs().

Signed-off-by: Peter Crosthwaite <peter.crosthwaite@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
 drivers/spi/spi-xilinx.c | 74 +++++++++++++++++++++++-------------------------
 1 file changed, 35 insertions(+), 39 deletions(-)

diff --git a/drivers/spi/spi-xilinx.c b/drivers/spi/spi-xilinx.c
index e1d7696..34d18dc 100644
--- a/drivers/spi/spi-xilinx.c
+++ b/drivers/spi/spi-xilinx.c
@@ -267,7 +267,6 @@ static int xilinx_spi_txrx_bufs(struct spi_device *spi, struct spi_transfer *t)
 {
 	struct xilinx_spi *xspi = spi_master_get_devdata(spi->master);
 	u32 ipif_ier;
-	u16 cr;

 	/* We get here with transmitter inhibited */

@@ -276,7 +275,6 @@ static int xilinx_spi_txrx_bufs(struct spi_device *spi, struct spi_transfer *t)
 	xspi->remaining_bytes = t->len;
 	INIT_COMPLETION(xspi->done);

-	xilinx_spi_fill_tx_fifo(xspi);

 	/* Enable the transmit empty interrupt, which we use to determine
 	 * progress on the transmission.
@@ -285,12 +283,41 @@ static int xilinx_spi_txrx_bufs(struct spi_device *spi, struct spi_transfer *t)
 	xspi->write_fn(ipif_ier | XSPI_INTR_TX_EMPTY,
 		xspi->regs + XIPIF_V123B_IIER_OFFSET);

-	/* Start the transfer by not inhibiting the transmitter any longer */
-	cr = xspi->read_fn(xspi->regs + XSPI_CR_OFFSET) &
-		~XSPI_CR_TRANS_INHIBIT;
-	xspi->write_fn(cr, xspi->regs + XSPI_CR_OFFSET);
+	for (;;) {
+		u16 cr;
+		u8 sr;
+
+		xilinx_spi_fill_tx_fifo(xspi);
+
+		/* Start the transfer by not inhibiting the transmitter any
+		 * longer
+		 */
+		cr = xspi->read_fn(xspi->regs + XSPI_CR_OFFSET) &
+							~XSPI_CR_TRANS_INHIBIT;
+		xspi->write_fn(cr, xspi->regs + XSPI_CR_OFFSET);
+
+		wait_for_completion(&xspi->done);
+
+		/* A transmit has just completed. Process received data and
+		 * check for more data to transmit. Always inhibit the
+		 * transmitter while the Isr refills the transmit register/FIFO,
+		 * or make sure it is stopped if we're done.
+		 */
+		cr = xspi->read_fn(xspi->regs + XSPI_CR_OFFSET);
+		xspi->write_fn(cr | XSPI_CR_TRANS_INHIBIT,
+			       xspi->regs + XSPI_CR_OFFSET);
+
+		/* Read out all the data from the Rx FIFO */
+		sr = xspi->read_fn(xspi->regs + XSPI_SR_OFFSET);
+		while ((sr & XSPI_SR_RX_EMPTY_MASK) == 0) {
+			xspi->rx_fn(xspi);
+			sr = xspi->read_fn(xspi->regs + XSPI_SR_OFFSET);
+		}

-	wait_for_completion(&xspi->done);
+		/* See if there is more data to send */
+		if (!xspi->remaining_bytes > 0)
+			break;
+	}

 	/* Disable the transmit empty interrupt */
 	xspi->write_fn(ipif_ier, xspi->regs + XIPIF_V123B_IIER_OFFSET);
@@ -314,38 +341,7 @@ static irqreturn_t xilinx_spi_irq(int irq, void *dev_id)
 	xspi->write_fn(ipif_isr, xspi->regs + XIPIF_V123B_IISR_OFFSET);

 	if (ipif_isr & XSPI_INTR_TX_EMPTY) {	/* Transmission completed */
-		u16 cr;
-		u8 sr;
-
-		/* A transmit has just completed. Process received data and
-		 * check for more data to transmit. Always inhibit the
-		 * transmitter while the Isr refills the transmit register/FIFO,
-		 * or make sure it is stopped if we're done.
-		 */
-		cr = xspi->read_fn(xspi->regs + XSPI_CR_OFFSET);
-		xspi->write_fn(cr | XSPI_CR_TRANS_INHIBIT,
-			xspi->regs + XSPI_CR_OFFSET);
-
-		/* Read out all the data from the Rx FIFO */
-		sr = xspi->read_fn(xspi->regs + XSPI_SR_OFFSET);
-		while ((sr & XSPI_SR_RX_EMPTY_MASK) == 0) {
-			xspi->rx_fn(xspi);
-			sr = xspi->read_fn(xspi->regs + XSPI_SR_OFFSET);
-		}
-
-		/* See if there is more data to send */
-		if (xspi->remaining_bytes > 0) {
-			xilinx_spi_fill_tx_fifo(xspi);
-			/* Start the transfer by not inhibiting the
-			 * transmitter any longer
-			 */
-			xspi->write_fn(cr, xspi->regs + XSPI_CR_OFFSET);
-		} else {
-			/* No more data to send.
-			 * Indicate the transfer is completed.
-			 */
-			complete(&xspi->done);
-		}
+		complete(&xspi->done);
 	}

 	return IRQ_HANDLED;
--
1.8.2.3


--=_mimegpg-monstr-desktop-11158-1370354557-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlGt830ACgkQykllyylKDCGLEgCdEAFOnKlLkeEYrW/xgFBCuZ6x
HIAAn17Ru16T7x/2rBoSuECyK6rSUleb
=2kW5
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-11158-1370354557-0001--
