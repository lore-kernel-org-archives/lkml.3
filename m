Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751423AbaGXIxK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 04:53:10 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:33222 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbaGXIxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 04:53:07 -0400
From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
To: gregkh@linuxfoundation.org, arnd@arndb.de, sr@denx.de,
        linux-kernel@vger.kernel.org
Cc: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Subject: [PATCH v5] Lattice ECP3 FPGA: Correct endianness
Date: Thu, 24 Jul 2014 10:53:00 +0200
Message-Id: <1406191980-24283-1-git-send-email-jean-michel.hautbois@vodalys.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code corrects endianness and avoids a sparse error.
Tested with Lattice ECP3-35 with Freescale i.MX6.
It also sends uevent in order to load it.

Signed-off-by: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
---
 drivers/misc/lattice-ecp3-config.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/misc/lattice-ecp3-config.c b/drivers/misc/lattice-ecp3-config.c
index 61fbe6a..66b37bc 100644
--- a/drivers/misc/lattice-ecp3-config.c
+++ b/drivers/misc/lattice-ecp3-config.c
@@ -16,6 +16,7 @@
 #include <linux/spi/spi.h>
 #include <linux/platform_device.h>
 #include <linux/delay.h>
+#include <asm/unaligned.h>
 
 #define FIRMWARE_NAME	"lattice-ecp3.bit"
 
@@ -92,8 +93,8 @@ static void firmware_load(const struct firmware *fw, void *context)
 	/* Trying to speak with the FPGA via SPI... */
 	txbuf[0] = FPGA_CMD_READ_ID;
 	ret = spi_write_then_read(spi, txbuf, 8, rxbuf, rx_len);
-	dev_dbg(&spi->dev, "FPGA JTAG ID=%08x\n", *(u32 *)&rxbuf[4]);
-	jedec_id = *(u32 *)&rxbuf[4];
+	jedec_id = get_unaligned_be32(&rxbuf[4]);
+	dev_dbg(&spi->dev, "FPGA JTAG ID=%08x\n", jedec_id);
 
 	for (i = 0; i < ARRAY_SIZE(ecp3_dev); i++) {
 		if (jedec_id == ecp3_dev[i].jedec_id)
@@ -110,7 +111,8 @@ static void firmware_load(const struct firmware *fw, void *context)
 
 	txbuf[0] = FPGA_CMD_READ_STATUS;
 	ret = spi_write_then_read(spi, txbuf, 8, rxbuf, rx_len);
-	dev_dbg(&spi->dev, "FPGA Status=%08x\n", *(u32 *)&rxbuf[4]);
+	status = get_unaligned_be32(&rxbuf[4]);
+	dev_dbg(&spi->dev, "FPGA Status=%08x\n", status);
 
 	buffer = kzalloc(fw->size + 8, GFP_KERNEL);
 	if (!buffer) {
@@ -142,7 +144,7 @@ static void firmware_load(const struct firmware *fw, void *context)
 	for (i = 0; i < FPGA_CLEAR_LOOP_COUNT; i++) {
 		txbuf[0] = FPGA_CMD_READ_STATUS;
 		ret = spi_write_then_read(spi, txbuf, 8, rxbuf, rx_len);
-		status = *(u32 *)&rxbuf[4];
+		status = get_unaligned_be32(&rxbuf[4]);
 		if (status == FPGA_STATUS_CLEARED)
 			break;
 
@@ -165,8 +167,8 @@ static void firmware_load(const struct firmware *fw, void *context)
 
 	txbuf[0] = FPGA_CMD_READ_STATUS;
 	ret = spi_write_then_read(spi, txbuf, 8, rxbuf, rx_len);
-	dev_dbg(&spi->dev, "FPGA Status=%08x\n", *(u32 *)&rxbuf[4]);
-	status = *(u32 *)&rxbuf[4];
+	status = get_unaligned_be32(&rxbuf[4]);
+	dev_dbg(&spi->dev, "FPGA Status=%08x\n", status);
 
 	/* Check result */
 	if (status & FPGA_STATUS_DONE)
@@ -197,7 +199,7 @@ static int lattice_ecp3_probe(struct spi_device *spi)
 	spi_set_drvdata(spi, data);
 
 	init_completion(&data->fw_loaded);
-	err = request_firmware_nowait(THIS_MODULE, FW_ACTION_NOHOTPLUG,
+	err = request_firmware_nowait(THIS_MODULE, FW_ACTION_HOTPLUG,
 				      FIRMWARE_NAME, &spi->dev,
 				      GFP_KERNEL, spi, firmware_load);
 	if (err) {
-- 
2.0.0

