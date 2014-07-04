Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758890AbaGDN5Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 09:57:16 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:51756 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121AbaGDN5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 09:57:15 -0400
MIME-Version: 1.0
Date: Fri, 4 Jul 2014 15:57:14 +0200
Message-ID: <CAPwkgkPrtCwyA6udppH47q-zY5X+gWL=AWDLuSM_Kgu_A5VQhw@mail.gmail.com>
Subject: [PATCH v2] Lattice ECP3 FPGA: Correct endianness
From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: sr@denx.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code corrects endianness and avoids a sparse error.
Tested with Lattice ECP3-35 with Freescale i.MX6.

Signed-off-by: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Acked-by: Stefan Roese <sr@denx.de>
---
 drivers/misc/lattice-ecp3-config.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/misc/lattice-ecp3-config.c
b/drivers/misc/lattice-ecp3-config.c
index bb26f08..957a66c 100644
--- a/drivers/misc/lattice-ecp3-config.c
+++ b/drivers/misc/lattice-ecp3-config.c
@@ -92,8 +92,8 @@ static void firmware_load(const struct firmware *fw,
void *context)
        /* Trying to speak with the FPGA via SPI... */
        txbuf[0] = FPGA_CMD_READ_ID;
        ret = spi_write_then_read(spi, txbuf, 8, rxbuf, rx_len);
-       dev_dbg(&spi->dev, "FPGA JTAG ID=%08x\n", *(u32 *)&rxbuf[4]);
-       jedec_id = *(u32 *)&rxbuf[4];
+       jedec_id = be32_to_cpu(*(__be32 *)&rxbuf[4]);
+       dev_dbg(&spi->dev, "FPGA JTAG ID=%08x\n", jedec_id);

        for (i = 0; i < ARRAY_SIZE(ecp3_dev); i++) {
                if (jedec_id == ecp3_dev[i].jedec_id)
@@ -110,7 +110,8 @@ static void firmware_load(const struct firmware
*fw, void *context)

        txbuf[0] = FPGA_CMD_READ_STATUS;
        ret = spi_write_then_read(spi, txbuf, 8, rxbuf, rx_len);
-       dev_dbg(&spi->dev, "FPGA Status=%08x\n", *(u32 *)&rxbuf[4]);
+       status = be32_to_cpu(*(__be32 *)&rxbuf[4]);
+       dev_dbg(&spi->dev, "FPGA Status=%08x\n", status);

        buffer = kzalloc(fw->size + 8, GFP_KERNEL);
        if (!buffer) {
@@ -142,7 +143,7 @@ static void firmware_load(const struct firmware
*fw, void *context)
        for (i = 0; i < FPGA_CLEAR_LOOP_COUNT; i++) {
                txbuf[0] = FPGA_CMD_READ_STATUS;
                ret = spi_write_then_read(spi, txbuf, 8, rxbuf, rx_len);
-               status = *(u32 *)&rxbuf[4];
+               status = be32_to_cpu(*(u32 *)&rxbuf[4]);
                if (status == FPGA_STATUS_CLEARED)
                        break;

@@ -165,8 +166,8 @@ static void firmware_load(const struct firmware
*fw, void *context)

        txbuf[0] = FPGA_CMD_READ_STATUS;
        ret = spi_write_then_read(spi, txbuf, 8, rxbuf, rx_len);
-       dev_dbg(&spi->dev, "FPGA Status=%08x\n", *(u32 *)&rxbuf[4]);
-       status = *(u32 *)&rxbuf[4];
+       status = be32_to_cpu(*(__be32 *)&rxbuf[4]);
+       dev_dbg(&spi->dev, "FPGA Status=%08x\n", status);

        /* Check result */
        if (status & FPGA_STATUS_DONE)
