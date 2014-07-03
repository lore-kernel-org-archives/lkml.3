Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964928AbaGCPyZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 11:54:25 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:37606 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932340AbaGCPyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 11:54:23 -0400
MIME-Version: 1.0
From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Date: Thu, 3 Jul 2014 17:54:08 +0200
X-Google-Sender-Auth: udGRCNymanhC6gpxCbLh-0LyQqg
Message-ID: <CAL8zT=isq_2RT07a6z8imJ4N0w0v-yw6ysv3wf+S7sLsqZBCeg@mail.gmail.com>
Subject: [PATCH] Lattice ECP3 FPGA: Correct endianness
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: sr@denx.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch corrects three big/little endian issues. Tested on i.MX6.

From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Date: Thu, 3 Jul 2014 17:49:47 +0200
Subject: [PATCH] Endianness corrections

---
 drivers/misc/lattice-ecp3-config.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/lattice-ecp3-config.c
b/drivers/misc/lattice-ecp3-config.c
index bb26f08..23d5c01 100644
--- a/drivers/misc/lattice-ecp3-config.c
+++ b/drivers/misc/lattice-ecp3-config.c
@@ -93,7 +93,7 @@ static void firmware_load(const struct firmware *fw,
void *context)
     txbuf[0] = FPGA_CMD_READ_ID;
     ret = spi_write_then_read(spi, txbuf, 8, rxbuf, rx_len);
     dev_dbg(&spi->dev, "FPGA JTAG ID=%08x\n", *(u32 *)&rxbuf[4]);
-    jedec_id = *(u32 *)&rxbuf[4];
+    jedec_id = be32_to_cpu(*(u32 *)&rxbuf[4]);

     for (i = 0; i < ARRAY_SIZE(ecp3_dev); i++) {
         if (jedec_id == ecp3_dev[i].jedec_id)
@@ -142,7 +142,7 @@ static void firmware_load(const struct firmware
*fw, void *context)
     for (i = 0; i < FPGA_CLEAR_LOOP_COUNT; i++) {
         txbuf[0] = FPGA_CMD_READ_STATUS;
         ret = spi_write_then_read(spi, txbuf, 8, rxbuf, rx_len);
-        status = *(u32 *)&rxbuf[4];
+        status = be32_to_cpu(*(u32 *)&rxbuf[4]);
         if (status == FPGA_STATUS_CLEARED)
             break;

@@ -165,8 +165,8 @@ static void firmware_load(const struct firmware
*fw, void *context)

     txbuf[0] = FPGA_CMD_READ_STATUS;
     ret = spi_write_then_read(spi, txbuf, 8, rxbuf, rx_len);
-    dev_dbg(&spi->dev, "FPGA Status=%08x\n", *(u32 *)&rxbuf[4]);
-    status = *(u32 *)&rxbuf[4];
+    dev_dbg(&spi->dev, "FPGA Status=%08x\n", be32_to_cpu(*(u32 *)&rxbuf[4]));
+    status = be32_to_cpu(*(u32 *)&rxbuf[4]);

     /* Check result */
     if (status & FPGA_STATUS_DONE)
-- 
2.0.0
