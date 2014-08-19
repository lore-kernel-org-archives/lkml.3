Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbaHSReY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 13:34:24 -0400
Received: from mga01.intel.com ([192.55.52.88]:36503 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753852AbaHSReT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 13:34:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,896,1400050800"; 
   d="scan'208";a="578872943"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Vinod Koul <vinod.koul@intel.com>, Mark Brown <broonie@kernel.org>,
        Hein Tibosch <hein_tibosch@yahoo.es>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Takashi Iwai <tiwai@suse.de>,
        Kweh Hock Leong <hock.leong.kweh@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alan Cox <alan@linux.intel.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 03/12] dmaengine: dw: convert dw_dma_slave to use explicit HS interfaces
Date: Tue, 19 Aug 2014 20:29:14 +0300
Message-Id: <1408469363-15901-4-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1408469363-15901-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1408469363-15901-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of exposing the possibility to set DMA registers CFG_HI and CFG_LO
strict user to provide handshake interfaces explicitly.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 arch/avr32/mach-at32ap/at32ap700x.c  | 15 +++++----------
 drivers/dma/dw/core.c                |  4 ++--
 include/linux/platform_data/dma-dw.h | 10 ++++------
 3 files changed, 11 insertions(+), 18 deletions(-)

diff --git a/arch/avr32/mach-at32ap/at32ap700x.c b/arch/avr32/mach-at32ap/at32ap700x.c
index ec7be28..37b7560 100644
--- a/arch/avr32/mach-at32ap/at32ap700x.c
+++ b/arch/avr32/mach-at32ap/at32ap700x.c
@@ -1356,10 +1356,8 @@ at32_add_device_mci(unsigned int id, struct mci_platform_data *data)
 		goto fail;
 
 	slave->sdata.dma_dev = &dw_dmac0_device.dev;
-	slave->sdata.cfg_hi = (DWC_CFGH_SRC_PER(0)
-				| DWC_CFGH_DST_PER(1));
-	slave->sdata.cfg_lo &= ~(DWC_CFGL_HS_DST_POL
-				| DWC_CFGL_HS_SRC_POL);
+	slave->sdata.src_id = 0;
+	slave->sdata.dst_id = 1;
 	slave->sdata.src_master = 1;
 	slave->sdata.dst_master = 0;
 
@@ -2054,8 +2052,7 @@ at32_add_device_ac97c(unsigned int id, struct ac97c_platform_data *data,
 	/* Check if DMA slave interface for capture should be configured. */
 	if (flags & AC97C_CAPTURE) {
 		rx_dws->dma_dev = &dw_dmac0_device.dev;
-		rx_dws->cfg_hi = DWC_CFGH_SRC_PER(3);
-		rx_dws->cfg_lo &= ~(DWC_CFGL_HS_DST_POL | DWC_CFGL_HS_SRC_POL);
+		rx_dws->src_id = 3;
 		rx_dws->src_master = 0;
 		rx_dws->dst_master = 1;
 	}
@@ -2063,8 +2060,7 @@ at32_add_device_ac97c(unsigned int id, struct ac97c_platform_data *data,
 	/* Check if DMA slave interface for playback should be configured. */
 	if (flags & AC97C_PLAYBACK) {
 		tx_dws->dma_dev = &dw_dmac0_device.dev;
-		tx_dws->cfg_hi = DWC_CFGH_DST_PER(4);
-		tx_dws->cfg_lo &= ~(DWC_CFGL_HS_DST_POL | DWC_CFGL_HS_SRC_POL);
+		tx_dws->dst_id = 4;
 		tx_dws->src_master = 0;
 		tx_dws->dst_master = 1;
 	}
@@ -2136,8 +2132,7 @@ at32_add_device_abdac(unsigned int id, struct atmel_abdac_pdata *data)
 	dws = &data->dws;
 
 	dws->dma_dev = &dw_dmac0_device.dev;
-	dws->cfg_hi = DWC_CFGH_DST_PER(2);
-	dws->cfg_lo &= ~(DWC_CFGL_HS_DST_POL | DWC_CFGL_HS_SRC_POL);
+	dws->dst_id = 2;
 	dws->src_master = 0;
 	dws->dst_master = 1;
 
diff --git a/drivers/dma/dw/core.c b/drivers/dma/dw/core.c
index 1af731b..0a9c052 100644
--- a/drivers/dma/dw/core.c
+++ b/drivers/dma/dw/core.c
@@ -155,8 +155,8 @@ static void dwc_initialize(struct dw_dma_chan *dwc)
 		 */
 		BUG_ON(!dws->dma_dev || dws->dma_dev != dw->dma.dev);
 
-		cfghi = dws->cfg_hi;
-		cfglo |= dws->cfg_lo & ~DWC_CFGL_CH_PRIOR_MASK;
+		cfghi |= DWC_CFGH_DST_PER(dws->dst_id);
+		cfghi |= DWC_CFGH_SRC_PER(dws->src_id);
 	} else {
 		if (dwc->direction == DMA_MEM_TO_DEV)
 			cfghi = DWC_CFGH_DST_PER(dwc->request_line);
diff --git a/include/linux/platform_data/dma-dw.h b/include/linux/platform_data/dma-dw.h
index 68b4024..bc411a1 100644
--- a/include/linux/platform_data/dma-dw.h
+++ b/include/linux/platform_data/dma-dw.h
@@ -17,17 +17,15 @@
  * struct dw_dma_slave - Controller-specific information about a slave
  *
  * @dma_dev: required DMA master device. Depricated.
- * @bus_id: name of this device channel, not just a device name since
- *          devices may have more than one channel e.g. "foo_tx"
- * @cfg_hi: Platform-specific initializer for the CFG_HI register
- * @cfg_lo: Platform-specific initializer for the CFG_LO register
+ * @src_id:	src request line
+ * @dst_id:	dst request line
  * @src_master: src master for transfers on allocated channel.
  * @dst_master: dest master for transfers on allocated channel.
  */
 struct dw_dma_slave {
 	struct device		*dma_dev;
-	u32			cfg_hi;
-	u32			cfg_lo;
+	u8			src_id;
+	u8			dst_id;
 	u8			src_master;
 	u8			dst_master;
 };
-- 
2.1.0

