Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008AbaLEWw7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 17:52:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53755 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456AbaLEWqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:46:14 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vlastimil Setka <setka@vsis.cz>,
        Thor Thayer <tthayer@opensource.altera.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 3.17 086/122] spi: dw: Fix dynamic speed change.
Date: Fri,  5 Dec 2014 14:44:20 -0800
Message-Id: <20141205223318.725396892@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205223305.514276242@linuxfoundation.org>
References: <20141205223305.514276242@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-dw.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/spi/spi-dw.c
+++ b/drivers/spi/spi-dw.c
@@ -382,9 +382,6 @@ static void pump_transfers(unsigned long
 	chip = dws->cur_chip;
 	spi = message->spi;
 
-	if (unlikely(!chip->clk_div))
-		chip->clk_div = dws->max_freq / chip->speed_hz;
-
 	if (message->state == ERROR_STATE) {
 		message->status = -EIO;
 		goto early_exit;
@@ -425,7 +422,7 @@ static void pump_transfers(unsigned long
 	if (transfer->speed_hz) {
 		speed = chip->speed_hz;
 
-		if (transfer->speed_hz != speed) {
+		if ((transfer->speed_hz != speed) || (!chip->clk_div)) {
 			speed = transfer->speed_hz;
 
 			/* clk_div doesn't support odd number */
@@ -586,7 +583,6 @@ static int dw_spi_setup(struct spi_devic
 		dev_err(&spi->dev, "No max speed HZ parameter\n");
 		return -EINVAL;
 	}
-	chip->speed_hz = spi->max_speed_hz;
 
 	chip->tmode = 0; /* Tx & Rx */
 	/* Default SPI mode is SCPOL = 0, SCPH = 0 */


