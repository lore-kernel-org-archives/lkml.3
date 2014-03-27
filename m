Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337AbaC0AIz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 20:08:55 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55017 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756632AbaC0AGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 20:06:55 -0400
From: Felipe Balbi <balbi@ti.com>
To: Balaji T K <balajitk@ti.com>
CC: <chris@printf.net>, <ulf.hansson@linaro.org>, <linux-mmc@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 2/5] mmc: host: omap_hsmmc: add reg_offset field
Date: Wed, 26 Mar 2014 19:04:47 -0500
Message-ID: <1395878690-9650-3-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.9.1.286.g5172cb3
In-Reply-To: <1395878690-9650-1-git-send-email-balbi@ti.com>
References: <1395878690-9650-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

by saving reg_offset inside our host structure
we can ioremap the correct area, make use of
resource_size() and make sure newer versions
of the IP have access to the new set of registers
which were added back in OMAP4.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/mmc/host/omap_hsmmc.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index a8f1e08..d46f768 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -152,10 +152,10 @@
  * MMC Host controller read/write API's
  */
 #define OMAP_HSMMC_READ(host, reg)	\
-	__raw_readl((host)->base + OMAP_HSMMC_##reg)
+	__raw_readl((host)->base + OMAP_HSMMC_##reg + host->reg_offset)
 
 #define OMAP_HSMMC_WRITE(host, reg, val) \
-	__raw_writel((val), (host)->base + OMAP_HSMMC_##reg)
+	__raw_writel((val), (host)->base + OMAP_HSMMC_##reg + host->reg_offset)
 
 struct omap_hsmmc_next {
 	unsigned int	dma_len;
@@ -184,6 +184,7 @@ struct omap_hsmmc_host {
 	void	__iomem		*base;
 	resource_size_t		mapbase;
 	spinlock_t		irq_lock; /* Prevent races with irq handler */
+	unsigned int		reg_offset;
 	unsigned int		dma_len;
 	unsigned int		dma_sg_idx;
 	unsigned char		bus_mode;
@@ -1354,8 +1355,8 @@ static int omap_hsmmc_setup_dma_transfer(struct omap_hsmmc_host *host,
 
 	chan = omap_hsmmc_get_dma_chan(host, data);
 
-	cfg.src_addr = host->mapbase + OMAP_HSMMC_DATA;
-	cfg.dst_addr = host->mapbase + OMAP_HSMMC_DATA;
+	cfg.src_addr = host->mapbase + OMAP_HSMMC_DATA + host->reg_offset;
+	cfg.dst_addr = host->mapbase + OMAP_HSMMC_DATA + host->reg_offset;
 	cfg.src_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
 	cfg.dst_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
 	cfg.src_maxburst = data->blksz / 4;
@@ -1903,8 +1904,9 @@ static int omap_hsmmc_probe(struct platform_device *pdev)
 	host->dma_ch	= -1;
 	host->irq	= irq;
 	host->slot_id	= 0;
-	host->mapbase	= res->start + pdata->reg_offset;
-	host->base	= ioremap(host->mapbase, SZ_4K);
+	host->reg_offset = pdata->reg_offset;
+	host->mapbase	= res->start;
+	host->base	= ioremap(res->start, resource_size(res));
 	host->power_mode = MMC_POWER_OFF;
 	host->next_data.cookie = 1;
 	host->pbias_enabled = 0;
-- 
1.9.1.286.g5172cb3

