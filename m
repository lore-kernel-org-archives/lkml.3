Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757055AbaCEOZh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:25:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40941 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757009AbaCEOZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:25:34 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kevin Cernekee <cernekee@gmail.com>, Jonas Gorski <jogo@openwrt.org>,
        Florian Fainelli <florian@openwrt.org>, Felipe Balbi <balbi@ti.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 049/131] usb: gadget: bcm63xx_udc: fix build failure on DMA channel code
Date: Wed,  5 Mar 2014 14:22:53 +0000
Message-Id: <1394029455-23128-50-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Fainelli <florian@openwrt.org>

commit 2d1f7af3d60dd09794e0738a915d272c6c27abc5 upstream.

Commit 3dc6475 ("bcm63xx_enet: add support Broadcom BCM6345 Ethernet")
changed the ENETDMA[CS] macros such that they are no longer macros, but
actual register offset definitions. The bcm63xx_udc driver was not
updated, and as a result, causes the following build error to pop up:

 CC      drivers/usb/gadget/u_ether.o
drivers/usb/gadget/bcm63xx_udc.c: In function 'iudma_write':
drivers/usb/gadget/bcm63xx_udc.c:642:24: error: called object '0' is not
a function
drivers/usb/gadget/bcm63xx_udc.c: In function 'iudma_reset_channel':
drivers/usb/gadget/bcm63xx_udc.c:698:46: error: called object '0' is not
a function
drivers/usb/gadget/bcm63xx_udc.c:700:49: error: called object '0' is not
a function

Fix this by updating usb_dmac_{read,write}l and usb_dmas_{read,write}l to
take an extra channel argument, and use the channel width
(ENETDMA_CHAN_WIDTH) to offset the register we want to access, hence
doing again what the macro implicitely did for us.

Cc: Kevin Cernekee <cernekee@gmail.com>
Cc: Jonas Gorski <jogo@openwrt.org>
Signed-off-by: Florian Fainelli <florian@openwrt.org>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/gadget/bcm63xx_udc.c | 58 ++++++++++++++++++++++------------------
 1 file changed, 32 insertions(+), 26 deletions(-)

diff --git a/drivers/usb/gadget/bcm63xx_udc.c b/drivers/usb/gadget/bcm63xx_udc.c
index fd24cb4..5396709 100644
--- a/drivers/usb/gadget/bcm63xx_udc.c
+++ b/drivers/usb/gadget/bcm63xx_udc.c
@@ -361,24 +361,30 @@ static inline void usb_dma_writel(struct bcm63xx_udc *udc, u32 val, u32 off)
 	bcm_writel(val, udc->iudma_regs + off);
 }
 
-static inline u32 usb_dmac_readl(struct bcm63xx_udc *udc, u32 off)
+static inline u32 usb_dmac_readl(struct bcm63xx_udc *udc, u32 off, int chan)
 {
-	return bcm_readl(udc->iudma_regs + IUDMA_DMAC_OFFSET + off);
+	return bcm_readl(udc->iudma_regs + IUDMA_DMAC_OFFSET + off +
+			(ENETDMA_CHAN_WIDTH * chan));
 }
 
-static inline void usb_dmac_writel(struct bcm63xx_udc *udc, u32 val, u32 off)
+static inline void usb_dmac_writel(struct bcm63xx_udc *udc, u32 val, u32 off,
+					int chan)
 {
-	bcm_writel(val, udc->iudma_regs + IUDMA_DMAC_OFFSET + off);
+	bcm_writel(val, udc->iudma_regs + IUDMA_DMAC_OFFSET + off +
+			(ENETDMA_CHAN_WIDTH * chan));
 }
 
-static inline u32 usb_dmas_readl(struct bcm63xx_udc *udc, u32 off)
+static inline u32 usb_dmas_readl(struct bcm63xx_udc *udc, u32 off, int chan)
 {
-	return bcm_readl(udc->iudma_regs + IUDMA_DMAS_OFFSET + off);
+	return bcm_readl(udc->iudma_regs + IUDMA_DMAS_OFFSET + off +
+			(ENETDMA_CHAN_WIDTH * chan));
 }
 
-static inline void usb_dmas_writel(struct bcm63xx_udc *udc, u32 val, u32 off)
+static inline void usb_dmas_writel(struct bcm63xx_udc *udc, u32 val, u32 off,
+					int chan)
 {
-	bcm_writel(val, udc->iudma_regs + IUDMA_DMAS_OFFSET + off);
+	bcm_writel(val, udc->iudma_regs + IUDMA_DMAS_OFFSET + off +
+			(ENETDMA_CHAN_WIDTH * chan));
 }
 
 static inline void set_clocks(struct bcm63xx_udc *udc, bool is_enabled)
@@ -639,7 +645,7 @@ static void iudma_write(struct bcm63xx_udc *udc, struct iudma_ch *iudma,
 	} while (!last_bd);
 
 	usb_dmac_writel(udc, ENETDMAC_CHANCFG_EN_MASK,
-			ENETDMAC_CHANCFG_REG(iudma->ch_idx));
+			ENETDMAC_CHANCFG_REG, iudma->ch_idx);
 }
 
 /**
@@ -695,9 +701,9 @@ static void iudma_reset_channel(struct bcm63xx_udc *udc, struct iudma_ch *iudma)
 		bcm63xx_fifo_reset_ep(udc, max(0, iudma->ep_num));
 
 	/* stop DMA, then wait for the hardware to wrap up */
-	usb_dmac_writel(udc, 0, ENETDMAC_CHANCFG_REG(ch_idx));
+	usb_dmac_writel(udc, 0, ENETDMAC_CHANCFG_REG, ch_idx);
 
-	while (usb_dmac_readl(udc, ENETDMAC_CHANCFG_REG(ch_idx)) &
+	while (usb_dmac_readl(udc, ENETDMAC_CHANCFG_REG, ch_idx) &
 				   ENETDMAC_CHANCFG_EN_MASK) {
 		udelay(1);
 
@@ -714,10 +720,10 @@ static void iudma_reset_channel(struct bcm63xx_udc *udc, struct iudma_ch *iudma)
 			dev_warn(udc->dev, "forcibly halting IUDMA channel %d\n",
 				 ch_idx);
 			usb_dmac_writel(udc, ENETDMAC_CHANCFG_BUFHALT_MASK,
-					ENETDMAC_CHANCFG_REG(ch_idx));
+					ENETDMAC_CHANCFG_REG, ch_idx);
 		}
 	}
-	usb_dmac_writel(udc, ~0, ENETDMAC_IR_REG(ch_idx));
+	usb_dmac_writel(udc, ~0, ENETDMAC_IR_REG, ch_idx);
 
 	/* don't leave "live" HW-owned entries for the next guy to step on */
 	for (d = iudma->bd_ring; d <= iudma->end_bd; d++)
@@ -729,11 +735,11 @@ static void iudma_reset_channel(struct bcm63xx_udc *udc, struct iudma_ch *iudma)
 
 	/* set up IRQs, UBUS burst size, and BD base for this channel */
 	usb_dmac_writel(udc, ENETDMAC_IR_BUFDONE_MASK,
-			ENETDMAC_IRMASK_REG(ch_idx));
-	usb_dmac_writel(udc, 8, ENETDMAC_MAXBURST_REG(ch_idx));
+			ENETDMAC_IRMASK_REG, ch_idx);
+	usb_dmac_writel(udc, 8, ENETDMAC_MAXBURST_REG, ch_idx);
 
-	usb_dmas_writel(udc, iudma->bd_ring_dma, ENETDMAS_RSTART_REG(ch_idx));
-	usb_dmas_writel(udc, 0, ENETDMAS_SRAM2_REG(ch_idx));
+	usb_dmas_writel(udc, iudma->bd_ring_dma, ENETDMAS_RSTART_REG, ch_idx);
+	usb_dmas_writel(udc, 0, ENETDMAS_SRAM2_REG, ch_idx);
 }
 
 /**
@@ -2036,7 +2042,7 @@ static irqreturn_t bcm63xx_udc_data_isr(int irq, void *dev_id)
 	spin_lock(&udc->lock);
 
 	usb_dmac_writel(udc, ENETDMAC_IR_BUFDONE_MASK,
-			ENETDMAC_IR_REG(iudma->ch_idx));
+			ENETDMAC_IR_REG, iudma->ch_idx);
 	bep = iudma->bep;
 	rc = iudma_read(udc, iudma);
 
@@ -2176,18 +2182,18 @@ static int bcm63xx_iudma_dbg_show(struct seq_file *s, void *p)
 		seq_printf(s, " [ep%d]:\n",
 			   max_t(int, iudma_defaults[ch_idx].ep_num, 0));
 		seq_printf(s, "  cfg: %08x; irqstat: %08x; irqmask: %08x; maxburst: %08x\n",
-			   usb_dmac_readl(udc, ENETDMAC_CHANCFG_REG(ch_idx)),
-			   usb_dmac_readl(udc, ENETDMAC_IR_REG(ch_idx)),
-			   usb_dmac_readl(udc, ENETDMAC_IRMASK_REG(ch_idx)),
-			   usb_dmac_readl(udc, ENETDMAC_MAXBURST_REG(ch_idx)));
+			   usb_dmac_readl(udc, ENETDMAC_CHANCFG_REG, ch_idx),
+			   usb_dmac_readl(udc, ENETDMAC_IR_REG, ch_idx),
+			   usb_dmac_readl(udc, ENETDMAC_IRMASK_REG, ch_idx),
+			   usb_dmac_readl(udc, ENETDMAC_MAXBURST_REG, ch_idx));
 
-		sram2 = usb_dmas_readl(udc, ENETDMAS_SRAM2_REG(ch_idx));
-		sram3 = usb_dmas_readl(udc, ENETDMAS_SRAM3_REG(ch_idx));
+		sram2 = usb_dmas_readl(udc, ENETDMAS_SRAM2_REG, ch_idx);
+		sram3 = usb_dmas_readl(udc, ENETDMAS_SRAM3_REG, ch_idx);
 		seq_printf(s, "  base: %08x; index: %04x_%04x; desc: %04x_%04x %08x\n",
-			   usb_dmas_readl(udc, ENETDMAS_RSTART_REG(ch_idx)),
+			   usb_dmas_readl(udc, ENETDMAS_RSTART_REG, ch_idx),
 			   sram2 >> 16, sram2 & 0xffff,
 			   sram3 >> 16, sram3 & 0xffff,
-			   usb_dmas_readl(udc, ENETDMAS_SRAM4_REG(ch_idx)));
+			   usb_dmas_readl(udc, ENETDMAS_SRAM4_REG, ch_idx));
 		seq_printf(s, "  desc: %d/%d used", iudma->n_bds_used,
 			   iudma->n_bds);
 
-- 
1.9.0

