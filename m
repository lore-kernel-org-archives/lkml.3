Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224Ab3F0DnQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 23:43:16 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:47568 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193Ab3F0DnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 23:43:14 -0400
From: Joel Fernandes <joelf@ti.com>
To: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Matt Porter <matt@ohporter.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>, Mark Brown <broonie@linaro.org>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
CC: Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Joel Fernandes <joelf@ti.com>
Subject: [PATCH v2 2/2] DMA: EDMA: Add comments for A-sync case calculations
Date: Wed, 26 Jun 2013 22:42:28 -0500
Message-ID: <1372304548-30777-1-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A-sync case in EDMA driver is tricky and not so obvious.
Document the reasons for the calculations and the scenarious
they are used.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 drivers/dma/edma.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index e008ed2..a1d9f3785 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -284,8 +284,24 @@ static struct dma_async_tx_descriptor *edma_prep_slave_sg(
 		 */
 		if (burst == 1) {
 			edesc->absync = false;
+			/*
+			 * For the A-sync case, bcnt and ccnt are the remainder
+			 * and quotient respectively of the division of:
+			 * (sg_dma_len(sg) / acnt) by (SZ_64K -1). This is so
+			 * that in case bcnt over flows, we have ccnt to use.
+			 * Note: In A-sync tranfer only, bcntrld is used, but it
+			 * only applies for sg_dma_len(sg) >= SZ_64K.
+			 * In this case, the best way adopted is- bccnt for the
+			 * first frame will be the remainder below. Then for
+			 * every successive frame, bcnt will be SZ_64K-1. This
+			 * is assured as bcntrld = 0xffff in end of function.
+			 */
 			ccnt = sg_dma_len(sg) / acnt / (SZ_64K - 1);
 			bcnt = sg_dma_len(sg) / acnt - ccnt * (SZ_64K - 1);
+			/*
+			 * If bcnt is non-zero, we have a remainder and hence an
+			 * extra frame to transfer, so increment ccnt.
+			 */
 			if (bcnt)
 				ccnt++;
 			else
@@ -343,6 +359,12 @@ static struct dma_async_tx_descriptor *edma_prep_slave_sg(
 
 		edesc->pset[i].a_b_cnt = bcnt << 16 | acnt;
 		edesc->pset[i].ccnt = ccnt;
+		/*
+		 * Only time when (bcntrld) auto reload is required is for
+		 * A-sync case, and in this case, a requirement of reload value
+		 * of SZ_64K-1 only is assured. 'link' is initially set to NULL
+		 * and then later will be populated by edma_execute.
+		 */
 		edesc->pset[i].link_bcntrld = 0xffffffff;
 
 	}
-- 
1.7.9.5

