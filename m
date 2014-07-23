Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757816AbaGWJjw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 05:39:52 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:64059 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757801AbaGWJju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 05:39:50 -0400
MIME-Version: 1.0
From: Jean-Michel Hautbois <jhautbois@gmail.com>
Date: Wed, 23 Jul 2014 11:39:35 +0200
Message-ID: <CAL8zT=g5aO1aNbADQ9Usv6J952D5t8_NvmDozTjvtczq-BGbrw@mail.gmail.com>
Subject: [PATCH v4] Lattice ECP3 FPGA: Correct endianness
To: linux-kernel <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        gregkh@linuxfoundation.org, Stefan Roese <sr@denx.de>
Content-Type: text/plain; charset=UTF-8
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

diff --git a/drivers/misc/lattice-ecp3-config.c
b/drivers/misc/lattice-ecp3-config.c
index bb26f08..2c86319 100644
--- a/drivers/misc/lattice-ecp3-config.c
+++ b/drivers/misc/lattice-ecp3-config.c
@@ -16,6 +16,7 @@
 #include <linux/spi/spi.h>
 #include <linux/platform_device.h>
 #include <linux/delay.h>
+#include <asm/unaligned.h>

 #define FIRMWARE_NAME    "lattice-ecp3.bit"

@@ -92,8 +93,8 @@ static void firmware_load(const struct firmware *fw,
void *context)
     /* Trying to speak with the FPGA via SPI... */
     txbuf[0] = FPGA_CMD_READ_ID;
     ret = spi_write_then_read(spi, txbuf, 8, rxbuf, rx_len);
-    dev_dbg(&spi->dev, "FPGA JTAG ID=%08x\n", *(u32 *)&rxbuf[4]);
-    jedec_id = *(u32 *)&rxbuf[4];
+    jedec_id = get_unaligned_be32(&rxbuf[4]);
+    dev_dbg(&spi->dev, "FPGA JTAG ID=%08x\n", jedec_id);

     for (i = 0; i < ARRAY_SIZE(ecp3_dev); i++) {
         if (jedec_id == ecp3_dev[i].jedec_id)
@@ -110,7 +111,8 @@ static void firmware_load(const struct firmware
*fw, void *context)

     txbuf[0] = FPGA_CMD_READ_STATUS;
     ret = spi_write_then_read(spi, txbuf, 8, rxbuf, rx_len);
-    dev_dbg(&spi->dev, "FPGA Status=%08x\n", *(u32 *)&rxbuf[4]);
+    status = get_unaligned_be32(&rxbuf[4]);
+    dev_dbg(&spi->dev, "FPGA Status=%08x\n", status);

     buffer = kzalloc(fw->size + 8, GFP_KERNEL);
     if (!buffer) {
@@ -142,7 +144,7 @@ static void firmware_load(const struct firmware
*fw, void *context)
     for (i = 0; i < FPGA_CLEAR_LOOP_COUNT; i++) {
         txbuf[0] = FPGA_CMD_READ_STATUS;
         ret = spi_write_then_read(spi, txbuf, 8, rxbuf, rx_len);
-        status = *(u32 *)&rxbuf[4];
+        status = get_unaligned_be32(&rxbuf[4]);
         if (status == FPGA_STATUS_CLEARED)
             break;

@@ -165,8 +167,8 @@ static void firmware_load(const struct firmware
*fw, void *context)

     txbuf[0] = FPGA_CMD_READ_STATUS;
     ret = spi_write_then_read(spi, txbuf, 8, rxbuf, rx_len);
-    dev_dbg(&spi->dev, "FPGA Status=%08x\n", *(u32 *)&rxbuf[4]);
-    status = *(u32 *)&rxbuf[4];
+    status = get_unaligned_be32(&rxbuf[4]);
+    dev_dbg(&spi->dev, "FPGA Status=%08x\n", status);

     /* Check result */
     if (status & FPGA_STATUS_DONE)
@@ -197,7 +199,7 @@ static int lattice_ecp3_probe(struct spi_device *spi)
     spi_set_drvdata(spi, data);

     init_completion(&data->fw_loaded);
-    err = request_firmware_nowait(THIS_MODULE, FW_ACTION_NOHOTPLUG,
+    err = request_firmware_nowait(THIS_MODULE, FW_ACTION_HOTPLUG,
                       FIRMWARE_NAME, &spi->dev,
                       GFP_KERNEL, spi, firmware_load);
     if (err) {
-- 
2.0.0
