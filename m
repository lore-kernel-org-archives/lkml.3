Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987AbaLFPTq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 10:19:46 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:47740 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752188AbaLFPIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 10:08:09 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Thor Thayer <tthayer@opensource.altera.com>,
        Vlastimil Setka <setka@vsis.cz>, Mark Brown <broonie@kernel.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 53/66] spi: dw: Fix dynamic speed change.
Date: Sat,  6 Dec 2014 16:07:45 +0100
Message-Id: <982b1001490f09f2a8810775a6c237d6b8e626f2.1417878427.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
References: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
In-Reply-To: <cover.1417878427.git.jslaby@suse.cz>
References: <cover.1417878427.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thor Thayer <tthayer@opensource.altera.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/spi/spi-dw.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/spi/spi-dw.c b/drivers/spi/spi-dw.c
index 79c958e49f61..bb91bd8a21dc 100644
--- a/drivers/spi/spi-dw.c
+++ b/drivers/spi/spi-dw.c
@@ -394,9 +394,6 @@ static void pump_transfers(unsigned long data)
 	chip = dws->cur_chip;
 	spi = message->spi;
 
-	if (unlikely(!chip->clk_div))
-		chip->clk_div = dws->max_freq / chip->speed_hz;
-
 	if (message->state == ERROR_STATE) {
 		message->status = -EIO;
 		goto early_exit;
@@ -438,7 +435,7 @@ static void pump_transfers(unsigned long data)
 	if (transfer->speed_hz) {
 		speed = chip->speed_hz;
 
-		if (transfer->speed_hz != speed) {
+		if ((transfer->speed_hz != speed) || (!chip->clk_div)) {
 			speed = transfer->speed_hz;
 			if (speed > dws->max_freq) {
 				printk(KERN_ERR "MRST SPI0: unsupported"
@@ -658,7 +655,6 @@ static int dw_spi_setup(struct spi_device *spi)
 		dev_err(&spi->dev, "No max speed HZ parameter\n");
 		return -EINVAL;
 	}
-	chip->speed_hz = spi->max_speed_hz;
 
 	chip->tmode = 0; /* Tx & Rx */
 	/* Default SPI mode is SCPOL = 0, SCPH = 0 */
-- 
2.1.3

