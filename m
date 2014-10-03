Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbaJCM4Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 08:56:16 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:36623 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490AbaJCM4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 08:56:13 -0400
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Mark Brown <broonie@kernel.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Marcelo Tosatti <marcelo@kvack.org>,
        Vitaly Bordug <vitb@kernel.crashing.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-spi@vger.kernel.org,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>,
        scottwood@freescale.com
Subject: [PATCH 1/2] spi: fsl-spi: Fix parameter ram offset setup for CPM1
Message-Id: <20141003125609.0CD2B1AB275@localhost.localdomain>
Date: Fri,  3 Oct 2014 14:56:08 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On CPM1, the SPI parameter RAM has a default location. In fsl_spi_cpm_get_pram()
there was a confusion between the SPI_BASE register and the base of the SPI
parameter RAM. Fortunatly, it was working properly with MPC866 and MPC885
because they do set SPI_BASE, but on MPC860 and other old MPC8xx that doesn't
set SPI_BASE, pram_ofs was not properly set. This patch fixes this confusion.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

---
 drivers/spi/spi-fsl-cpm.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/spi/spi-fsl-cpm.c b/drivers/spi/spi-fsl-cpm.c
index 54b0637..0f3a912 100644
--- a/drivers/spi/spi-fsl-cpm.c
+++ b/drivers/spi/spi-fsl-cpm.c
@@ -262,15 +262,14 @@ static unsigned long fsl_spi_cpm_get_pram(struct mpc8xxx_spi *mspi)
 		pram_ofs = cpm_muram_alloc(SPI_PRAM_SIZE, 64);
 		out_be16(spi_base, pram_ofs);
 	} else {
-		struct spi_pram __iomem *pram = spi_base;
-		u16 rpbase = in_be16(&pram->rpbase);
+		u16 rpbase = in_be16(spi_base);
 
-		/* Microcode relocation patch applied? */
+		/* Microcode relocation patch applied | rpbase set by default */
 		if (rpbase) {
 			pram_ofs = rpbase;
 		} else {
-			pram_ofs = cpm_muram_alloc(SPI_PRAM_SIZE, 64);
-			out_be16(spi_base, pram_ofs);
+			pram_ofs = offsetof(cpm8xx_t, cp_dparam[PROFF_SPI]) -
+				   offsetof(cpm8xx_t, cp_dpmem[0]);
 		}
 	}
 
-- 
2.1.0

