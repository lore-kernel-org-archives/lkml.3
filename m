Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758991Ab3EGEO2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:14:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22849 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932852Ab3EGD6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 23:58:44 -0400
X-Authority-Analysis: v=2.0 cv=GtrACzJC c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=KOPVi35HSHMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=unVOkQuXBE8A:10 a=W5idTISOAAAA:8 a=wggVRkVUAAAA:8 a=VwQbUJbxAAAA:8 a=fC4T7qsy4_4xvlMS5R0A:9 a=-Pj1cSz79GQA:10 a=oPY2pAEv0vQA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035841.913623675@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:57:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Gerhard Sittig <gerhard.sittig@ifm.com>,
        Anatolij Gustschin <agust@denx.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [006/126] spi/mpc512x-psc: optionally keep PSC SS asserted across xfer
 segmensts
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0006-spi-mpc512x-psc-optionally-keep-PSC-SS-asserted-acro.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Anatolij Gustschin <agust@denx.de>

[ Upstream commit 1ad849aee5f53353ed88d9cd3d68a51b03a7d44f ]

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
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/spi/spi-mpc512x-psc.c |    2 +-
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
1.7.10.4


