Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934638Ab3DGX16 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 19:27:58 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46632 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757645Ab3DGX1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 19:27:55 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Gerhard Sittig" <gerhard.sittig@ifm.com>,
        "Mark Brown" <broonie@opensource.wolfsonmicro.com>,
        "Anatolij Gustschin" <agust@denx.de>
Date: Sun, 07 Apr 2013 23:45:42 +0100
Message-ID: <lsq.1365374742.961917932@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [43/74] spi/mpc512x-psc: optionally keep PSC SS asserted across
 xfer segmensts
In-Reply-To: <lsq.1365374742.214522651@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:b4b3:7e2a:e2d0:3478
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.43-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Anatolij Gustschin <agust@denx.de>

commit 1ad849aee5f53353ed88d9cd3d68a51b03a7d44f upstream.

Some SPI slave devices require asserted chip select signal across
multiple transfer segments of an SPI message. Currently the driver
always de-asserts the internal SS signal for every single transfer
segment of the message and ignores the 'cs_change' flag of the
transfer description. Disable the internal chip select (SS) only
if this is needed and indicated by the 'cs_change' flag.

Without this change, each partial transfer of a surrounding
multi-part SPI transaction might erroneously change the SS
signal, which might prevent slaves from answering the request
that was sent in a previous transfer segment because the
transaction could be considered aborted (SS was de-asserted
before reading the response).

Reported-by: Gerhard Sittig <gerhard.sittig@ifm.com>
Signed-off-by: Anatolij Gustschin <agust@denx.de>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/spi/spi-mpc512x-psc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/spi/spi-mpc512x-psc.c
+++ b/drivers/spi/spi-mpc512x-psc.c
@@ -164,7 +164,7 @@ static int mpc512x_psc_spi_transfer_rxtx
 
 		for (i = count; i > 0; i--) {
 			data = tx_buf ? *tx_buf++ : 0;
-			if (len == EOFBYTE)
+			if (len == EOFBYTE && t->cs_change)
 				setbits32(&fifo->txcmd, MPC512x_PSC_FIFO_EOF);
 			out_8(&fifo->txdata_8, data);
 			len--;

