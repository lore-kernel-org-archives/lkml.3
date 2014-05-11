Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097AbaEKKFH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 06:05:07 -0400
Received: from ns.horizon.com ([71.41.210.147]:64302 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758069AbaEKKFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 06:05:04 -0400
Date: 11 May 2014 06:05:02 -0400
Message-ID: <20140511100502.1491.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, pavel@ucw.cz
Subject: [PATCH 2/3] drivers/mmc/host/mmc_spi.c: Use get/put_unaligned_be32
Cc: arik@wizery.com, david.gnedt@davizone.at, eliad@wizery.com,
        jan.nikitenko@gmail.com, laurent.pinchart+renesas@ideasonboard.com,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-wireless@vger.kernel.org,
        linville@tuxdriver.com, luca@coelho.fi, tony@atomide.com
In-Reply-To: <20140511100211.1334.qmail@ns.horizon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Very minor source and binary size reduction.

Signed-off-by: George Spelvin <linux@horizon.com>
---
I spotted this while making the previous crc7 change.

This looks simple enough, but I don't actually have one of these devices to test.
At least one other careful desk-check is solicited.

 drivers/mmc/host/mmc_spi.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/mmc/host/mmc_spi.c b/drivers/mmc/host/mmc_spi.c
index 338e2202ea..cc8d4a6099 100644
--- a/drivers/mmc/host/mmc_spi.c
+++ b/drivers/mmc/host/mmc_spi.c
@@ -448,7 +448,6 @@ mmc_spi_command_send(struct mmc_spi_host *host,
 {
 	struct scratch		*data = host->data;
 	u8			*cp = data->status;
-	u32			arg = cmd->arg;
 	int			status;
 	struct spi_transfer	*t;
 
@@ -465,14 +464,12 @@ mmc_spi_command_send(struct mmc_spi_host *host,
 	 * We init the whole buffer to all-ones, which is what we need
 	 * to write while we're reading (later) response data.
 	 */
-	memset(cp++, 0xff, sizeof(data->status));
+	memset(cp, 0xff, sizeof(data->status));
 
-	*cp++ = 0x40 | cmd->opcode;
-	*cp++ = (u8)(arg >> 24);
-	*cp++ = (u8)(arg >> 16);
-	*cp++ = (u8)(arg >> 8);
-	*cp++ = (u8)arg;
-	*cp++ = crc7_be(0, &data->status[1], 5) | 0x01;
+	cp[1] = 0x40 | cmd->opcode;
+	put_unaligned_be32(cmd->arg, cp+2);
+	cp[6] = crc7_be(0, cp+1, 5) | 0x01;
+	cp += 7;
 
 	/* Then, read up to 13 bytes (while writing all-ones):
 	 *  - N(CR) (== 1..8) bytes of all-ones
@@ -711,10 +708,7 @@ mmc_spi_writeblock(struct mmc_spi_host *host, struct spi_transfer *t,
 	 * so we have to cope with this situation and check the response
 	 * bit-by-bit. Arggh!!!
 	 */
-	pattern  = scratch->status[0] << 24;
-	pattern |= scratch->status[1] << 16;
-	pattern |= scratch->status[2] << 8;
-	pattern |= scratch->status[3];
+	pattern = get_unaligned_be32(scratch->status);
 
 	/* First 3 bit of pattern are undefined */
 	pattern |= 0xE0000000;
-- 
1.9.2

