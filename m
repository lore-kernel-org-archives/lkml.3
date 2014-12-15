Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784AbaLOO2Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:28:16 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38576 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbaLOO2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:28:09 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Vlastimil Setka <setka@vsis.cz>,
        Thor Thayer <tthayer@opensource.altera.com>,
        Mark Brown <broonie@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 075/168] spi: dw: Fix dynamic speed change.
Date: Mon, 15 Dec 2014 14:25:29 +0000
Message-Id: <1418653622-21105-76-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thor Thayer <tthayer@opensource.altera.com>

commit 0a8727e69778683495058852f783eeda141a754e upstream.

An IOCTL call that calls spi_setup() and then dw_spi_setup() will
overwrite the persisted last transfer speed. On each transfer, the
SPI speed is compared to the last transfer speed to determine if the
clock divider registers need to be updated (did the speed change?).
This bug was observed with the spidev driver using spi-config to
update the max transfer speed.

This fix: Don't overwrite the persisted last transaction clock speed
when updating the SPI parameters in dw_spi_setup(). On the next
transaction, the new speed won't match the persisted last speed
and the hardware registers will be updated.
On initialization, the persisted last transaction clock
speed will be 0 but will be updated after the first SPI
transaction.

Move zeroed clock divider check into clock change test because
chip->clk_div is zero on startup and would cause a divide-by-zero
error. The calculation was wrong as well (can't support odd #).

Reported-by: Vlastimil Setka <setka@vsis.cz>
Signed-off-by: Vlastimil Setka <setka@vsis.cz>
Signed-off-by: Thor Thayer <tthayer@opensource.altera.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/spi/spi-dw.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/spi/spi-dw.c b/drivers/spi/spi-dw.c
index 0dd0623319b0..080e0a343675 100644
--- a/drivers/spi/spi-dw.c
+++ b/drivers/spi/spi-dw.c
@@ -382,9 +382,6 @@ static void pump_transfers(unsigned long data)
 	chip = dws->cur_chip;
 	spi = message->spi;
 
-	if (unlikely(!chip->clk_div))
-		chip->clk_div = dws->max_freq / chip->speed_hz;
-
 	if (message->state == ERROR_STATE) {
 		message->status = -EIO;
 		goto early_exit;
@@ -425,7 +422,7 @@ static void pump_transfers(unsigned long data)
 	if (transfer->speed_hz) {
 		speed = chip->speed_hz;
 
-		if (transfer->speed_hz != speed) {
+		if ((transfer->speed_hz != speed) || (!chip->clk_div)) {
 			speed = transfer->speed_hz;
 
 			/* clk_div doesn't support odd number */
@@ -586,7 +583,6 @@ static int dw_spi_setup(struct spi_device *spi)
 		dev_err(&spi->dev, "No max speed HZ parameter\n");
 		return -EINVAL;
 	}
-	chip->speed_hz = spi->max_speed_hz;
 
 	chip->tmode = 0; /* Tx & Rx */
 	/* Default SPI mode is SCPOL = 0, SCPH = 0 */
-- 
2.1.3

