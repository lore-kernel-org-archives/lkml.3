Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966247Ab3DRJkx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 05:40:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39993 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756151Ab3DRJRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 05:17:19 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Anatolij Gustschin <agust@denx.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 04/72] spi/mpc512x-psc: optionally keep PSC SS asserted across xfer segmensts
Date: Thu, 18 Apr 2013 10:15:49 +0100
Message-Id: <1366276617-3553-5-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
References: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.11 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/spi/spi-mpc512x-psc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-mpc512x-psc.c b/drivers/spi/spi-mpc512x-psc.c
index 4c63f77..2e2b04f 100644
--- a/drivers/spi/spi-mpc512x-psc.c
+++ b/drivers/spi/spi-mpc512x-psc.c
@@ -164,7 +164,7 @@ static int mpc512x_psc_spi_transfer_rxtx(struct spi_device *spi,
 
 		for (i = count; i > 0; i--) {
 			data = tx_buf ? *tx_buf++ : 0;
-			if (len == EOFBYTE)
+			if (len == EOFBYTE && t->cs_change)
 				setbits32(&fifo->txcmd, MPC512x_PSC_FIFO_EOF);
 			out_8(&fifo->txdata_8, data);
 			len--;
-- 
1.8.1.2

