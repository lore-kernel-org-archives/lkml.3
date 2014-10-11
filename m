Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673AbaJKQU6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 12:20:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:29315 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045AbaJKQU4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 12:20:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,699,1406617200"; 
   d="scan'208";a="603887846"
From: Vinod Koul <vinod.koul@intel.com>
To: dmaengine@vger.kernel.org
Cc: Li Yang <leoli@freescale.com>, Zhang Wei <zw@zh-kernel.org>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Vinod Koul <vinod.koul@intel.com>
Subject: [PATCH 3/6] carma-fpga: use dmaengine_xxx() API
Date: Sat, 11 Oct 2014 21:16:45 +0530
Message-Id: <1413042408-28491-4-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1413042408-28491-1-git-send-email-vinod.koul@intel.com>
References: <1413042408-28491-1-git-send-email-vinod.koul@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The drivers should use dmaengine_slave_config() and dmaengine_prep_dma_sg()
API instead of accessing the device_control which will be deprecated soon

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
---
 drivers/misc/carma/carma-fpga-program.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/misc/carma/carma-fpga-program.c b/drivers/misc/carma/carma-fpga-program.c
index 7be8983..fd0cb8b 100644
--- a/drivers/misc/carma/carma-fpga-program.c
+++ b/drivers/misc/carma/carma-fpga-program.c
@@ -518,8 +518,7 @@ static noinline int fpga_program_dma(struct fpga_dev *priv)
 	config.direction = DMA_MEM_TO_DEV;
 	config.dst_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
 	config.dst_maxburst = fpga_fifo_size(priv->regs) / 2 / 4;
-	ret = chan->device->device_control(chan, DMA_SLAVE_CONFIG,
-					   (unsigned long)&config);
+	ret = dmaengine_slave_config(chan, &config);
 	if (ret) {
 		dev_err(priv->dev, "DMA slave configuration failed\n");
 		goto out_dma_unmap;
@@ -532,9 +531,9 @@ static noinline int fpga_program_dma(struct fpga_dev *priv)
 	}
 
 	/* setup and submit the DMA transaction */
-	tx = chan->device->device_prep_dma_sg(chan,
-					      table.sgl, num_pages,
-					      vb->sglist, vb->sglen, 0);
+
+	tx = dmaengine_prep_dma_sg(chan, table.sgl, num_pages,
+			vb->sglist, vb->sglen, 0);
 	if (!tx) {
 		dev_err(priv->dev, "Unable to prep DMA transaction\n");
 		ret = -ENOMEM;
-- 
1.7.0.4

