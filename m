Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934626AbaLLGke (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:40:34 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51873 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759282AbaLLGQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:56 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Vlastimil Setka" <setka@vsis.cz>,
        "Thor Thayer" <tthayer@opensource.altera.com>,
        "Mark Brown" <broonie@kernel.org>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.612730998@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 119/164] spi: dw: Fix dynamic speed change.
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/spi/spi-dw.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/spi/spi-dw.c
+++ b/drivers/spi/spi-dw.c
@@ -400,9 +400,6 @@ static void pump_transfers(unsigned long
 	chip = dws->cur_chip;
 	spi = message->spi;
 
-	if (unlikely(!chip->clk_div))
-		chip->clk_div = dws->max_freq / chip->speed_hz;
-
 	if (message->state == ERROR_STATE) {
 		message->status = -EIO;
 		goto early_exit;
@@ -444,7 +441,7 @@ static void pump_transfers(unsigned long
 	if (transfer->speed_hz) {
 		speed = chip->speed_hz;
 
-		if (transfer->speed_hz != speed) {
+		if ((transfer->speed_hz != speed) || (!chip->clk_div)) {
 			speed = transfer->speed_hz;
 			if (speed > dws->max_freq) {
 				printk(KERN_ERR "MRST SPI0: unsupported"
@@ -683,7 +680,6 @@ static int dw_spi_setup(struct spi_devic
 		dev_err(&spi->dev, "No max speed HZ parameter\n");
 		return -EINVAL;
 	}
-	chip->speed_hz = spi->max_speed_hz;
 
 	chip->tmode = 0; /* Tx & Rx */
 	/* Default SPI mode is SCPOL = 0, SCPH = 0 */

