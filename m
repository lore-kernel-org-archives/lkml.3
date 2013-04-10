Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937131Ab3DJXSf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 19:18:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56052 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937046Ab3DJWrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:47:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Gerhard Sittig <gerhard.sittig@ifm.com>,
        Anatolij Gustschin <agust@denx.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 09/64] spi/mpc512x-psc: optionally keep PSC SS asserted across xfer segmensts
Date: Wed, 10 Apr 2013 15:46:06 -0700
Message-Id: <20130410224335.297143653@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130410224333.114387235@linuxfoundation.org>
References: <20130410224333.114387235@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anatolij Gustschin <agust@denx.de>

commit 1ad849aee5f53353ed88d9cd3d68a51b03a7d44f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-mpc512x-psc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/spi/spi-mpc512x-psc.c
+++ b/drivers/spi/spi-mpc512x-psc.c
@@ -164,7 +164,7 @@ static int mpc512x_psc_spi_transfer_rxtx
 
 		for (i = count; i > 0; i--) {
 			data = tx_buf ? *tx_buf++ : 0;
-			if (len == EOFBYTE)
+			if (len == EOFBYTE && t->cs_change)
 				setbits32(&fifo->txcmd, MPC512x_PSC_FIFO_EOF);
 			out_8(&fifo->txdata_8, data);
 			len--;


