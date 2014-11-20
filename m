Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757875AbaKTQYX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 11:24:23 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:13103 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756195AbaKTQYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 11:24:21 -0500
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Mark Brown <broonie@kernel.org>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-spi@vger.kernel.org
Subject: [PATCH] spi: fsl-spi: Don't use cpm_command on CPM1
Message-Id: <20141120162418.04FAC1A9BFC@localhost.localdomain>
Date: Thu, 20 Nov 2014 17:24:17 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On CPM1, when the SPI parameter RAM is relocated to somewhere else than the
default location, in accordance with freescale documentation
(refer micropatch SPI application note EB662), init RX/TX params command shall
not be used because it doesn't take into account the new location, and
overwrites data that is in original location of SPI param ram at addresses 
SCC2 param base +  (u32*)0x88 (u16*)0x90 (u32*)0x98 (u16*)0xA0, hence breaking
activity on SCC2 if SCC2 is used in a mode like QMC for instance.

Therefore, the action shall be done manually as described by freescale and as
was already partly done by the driver.

Reported-by: Patrick Vasseur <patrick.vasseur@c-s.fr>
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Tested-by: Patrick Vasseur <patrick.vasseur@c-s.fr>

---
 drivers/spi/spi-fsl-cpm.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-fsl-cpm.c b/drivers/spi/spi-fsl-cpm.c
index 54b0637..da97988 100644
--- a/drivers/spi/spi-fsl-cpm.c
+++ b/drivers/spi/spi-fsl-cpm.c
@@ -56,12 +56,15 @@ void fsl_spi_cpm_reinit_txrx(struct mpc8xxx_spi *mspi)
 		qe_issue_cmd(QE_INIT_TX_RX, mspi->subblock,
 			     QE_CR_PROTOCOL_UNSPECIFIED, 0);
 	} else {
-		cpm_command(CPM_SPI_CMD, CPM_CR_INIT_TRX);
 		if (mspi->flags & SPI_CPM1) {
+			out_be32(&mspi->pram->rstate, 0);
 			out_be16(&mspi->pram->rbptr,
 				 in_be16(&mspi->pram->rbase));
+			out_be32(&mspi->pram->tstate, 0);
 			out_be16(&mspi->pram->tbptr,
 				 in_be16(&mspi->pram->tbase));
+		} else {
+			cpm_command(CPM_SPI_CMD, CPM_CR_INIT_TRX);
 		}
 	}
 }
-- 
2.1.0

