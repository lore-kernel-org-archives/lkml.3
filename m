Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406AbaJGLuX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 07:50:23 -0400
Received: from us01smtprelay-2.synopsys.com ([198.182.44.111]:48961 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaJGLuU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 07:50:20 -0400
From: Prabu Thangamuthu <Prabu.T@synopsys.com>
To: Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Manjunath M Bettegowda <Manjunath.MB@synopsys.com>,
        "prabu.t@synopsys.com" <prabu.t@synopsys.com>
Subject: [PATCH v5] mmc: dw_mmc: Add IDMAC 64-bit address mode support
Thread-Topic: [PATCH v5] mmc: dw_mmc: Add IDMAC 64-bit address mode support
Thread-Index: Ac/iI9OmsHimH3VBQ3mVRB3ChsbEAA==
Date: Tue, 7 Oct 2014 11:47:44 +0000
Message-ID: <705D14B1C7978B40A723277C067CEDE21B32D001@IN01WEMBXB.internal.synopsys.com>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.144.112.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Synopsys DW_MMC IP core supports Internal DMA Controller with 64-bit address mode from IP version 2.70a onwards.
Updated the dw_mmc driver to support IDMAC 64-bit addressing mode.

Tested the features in DW_MMC core v2.70a and v2.40a with HAPS-51 setup and driver is working fine.

Signed-off-by: Prabu Thangamuthu <prabu.t@synopsys.com>
---
Change log v5:
	- Recreated the patch against linux-next as this patch is required for another patch http://www.spinics.net/lists/arm-kernel/msg357985.html

Change log v4:
	- Add the dynamic support for 32-bit and 64-bit address mode based on hw configuration.
	- Removed the CONFIG_MMC_DW_IDMAC_64BIT_ADDRESS macro.
	
Change log v3:
	-Add the condition check to find the IDMAC configuration mismatches between sw & hw.
	-Driver should not use the IDMAC if any conflict between sw & hw configurations
	 since the register offsets are different for both 32-bit and 64-bit configurations.
	-Reused the existing code.

 drivers/mmc/host/dw_mmc.c  |  197 +++++++++++++++++++++++++++++++++++---------
 drivers/mmc/host/dw_mmc.h  |   11 +++
 include/linux/mmc/dw_mmc.h |    2 +
 3 files changed, 171 insertions(+), 39 deletions(-)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index 69f0cc6..f784ab8 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -62,6 +62,24 @@
 				 SDMMC_IDMAC_INT_FBE | SDMMC_IDMAC_INT_RI | \
 				 SDMMC_IDMAC_INT_TI)
 
+struct idmac_desc_64addr {
+	u32		des0;	/* Control Descriptor */
+
+	u32		des1;	/* Reserved */
+
+	u32		des2;	/*Buffer sizes */
+#define IDMAC_64ADDR_SET_BUFFER1_SIZE(d, s) \
+	((d)->des2 = ((d)->des2 & 0x03ffe000) | ((s) & 0x1fff))
+
+	u32		des3;	/* Reserved */
+
+	u32		des4;	/* Lower 32-bits of Buffer Address Pointer 1*/
+	u32		des5;	/* Upper 32-bits of Buffer Address Pointer 1*/
+
+	u32		des6;	/* Lower 32-bits of Next Descriptor Address */
+	u32		des7;	/* Upper 32-bits of Next Descriptor Address */
+};
+
 struct idmac_desc {
 	u32		des0;	/* Control Descriptor */
 #define IDMAC_DES0_DIC	BIT(1)
@@ -414,30 +432,66 @@ static void dw_mci_translate_sglist(struct dw_mci *host, struct mmc_data *data,
 				    unsigned int sg_len)
 {
 	int i;
-	struct idmac_desc *desc = host->sg_cpu;
+	if (host->dma_64bit_address == 1) {
+		struct idmac_desc_64addr *desc = host->sg_cpu;
+
+		for (i = 0; i < sg_len; i++, desc++) {
+			unsigned int length = sg_dma_len(&data->sg[i]);
+			u64 mem_addr = sg_dma_address(&data->sg[i]);
+
+			/*
+			 * Set the OWN bit and disable interrupts for this
+			 * descriptor
+			 */
+			desc->des0 = IDMAC_DES0_OWN | IDMAC_DES0_DIC |
+						IDMAC_DES0_CH;
+			/* Buffer length */
+			IDMAC_64ADDR_SET_BUFFER1_SIZE(desc, length);
+
+			/* Physical address to DMA to/from */
+			desc->des4 = mem_addr & 0xffffffff;
+			desc->des5 = mem_addr >> 32;
+		}
 
-	for (i = 0; i < sg_len; i++, desc++) {
-		unsigned int length = sg_dma_len(&data->sg[i]);
-		u32 mem_addr = sg_dma_address(&data->sg[i]);
+		/* Set first descriptor */
+		desc = host->sg_cpu;
+		desc->des0 |= IDMAC_DES0_FD;
 
-		/* Set the OWN bit and disable interrupts for this descriptor */
-		desc->des0 = IDMAC_DES0_OWN | IDMAC_DES0_DIC | IDMAC_DES0_CH;
+		/* Set last descriptor */
+		desc = host->sg_cpu + (i - 1) *
+				sizeof(struct idmac_desc_64addr);
+		desc->des0 &= ~(IDMAC_DES0_CH | IDMAC_DES0_DIC);
+		desc->des0 |= IDMAC_DES0_LD;
 
-		/* Buffer length */
-		IDMAC_SET_BUFFER1_SIZE(desc, length);
+	} else {
+		struct idmac_desc *desc = host->sg_cpu;
 
-		/* Physical address to DMA to/from */
-		desc->des2 = mem_addr;
-	}
+		for (i = 0; i < sg_len; i++, desc++) {
+			unsigned int length = sg_dma_len(&data->sg[i]);
+			u32 mem_addr = sg_dma_address(&data->sg[i]);
 
-	/* Set first descriptor */
-	desc = host->sg_cpu;
-	desc->des0 |= IDMAC_DES0_FD;
+			/*
+			 * Set the OWN bit and disable interrupts for this
+			 * descriptor
+			 */
+			desc->des0 = IDMAC_DES0_OWN | IDMAC_DES0_DIC |
+						IDMAC_DES0_CH;
+			/* Buffer length */
+			IDMAC_SET_BUFFER1_SIZE(desc, length);
 
-	/* Set last descriptor */
-	desc = host->sg_cpu + (i - 1) * sizeof(struct idmac_desc);
-	desc->des0 &= ~(IDMAC_DES0_CH | IDMAC_DES0_DIC);
-	desc->des0 |= IDMAC_DES0_LD;
+			/* Physical address to DMA to/from */
+			desc->des2 = mem_addr;
+		}
+
+		/* Set first descriptor */
+		desc = host->sg_cpu;
+		desc->des0 |= IDMAC_DES0_FD;
+
+		/* Set last descriptor */
+		desc = host->sg_cpu + (i - 1) * sizeof(struct idmac_desc);
+		desc->des0 &= ~(IDMAC_DES0_CH | IDMAC_DES0_DIC);
+		desc->des0 |= IDMAC_DES0_LD;
+	}
 
 	wmb();
 }
@@ -466,29 +520,67 @@ static void dw_mci_idmac_start_dma(struct dw_mci *host, unsigned int sg_len)
 
 static int dw_mci_idmac_init(struct dw_mci *host)
 {
-	struct idmac_desc *p;
 	int i;
 
-	/* Number of descriptors in the ring buffer */
-	host->ring_size = PAGE_SIZE / sizeof(struct idmac_desc);
+	if (host->dma_64bit_address == 1) {
+		struct idmac_desc_64addr *p;
+		/* Number of descriptors in the ring buffer */
+		host->ring_size = PAGE_SIZE / sizeof(struct idmac_desc_64addr);
+
+		/* Forward link the descriptor list */
+		for (i = 0, p = host->sg_cpu; i < host->ring_size - 1;
+								i++, p++) {
+			p->des6 = (host->sg_dma +
+					(sizeof(struct idmac_desc_64addr) *
+							(i + 1))) & 0xffffffff;
+
+			p->des7 = (host->sg_dma +
+					(sizeof(struct idmac_desc_64addr) *
+							(i + 1))) >> 32;
+		}
 
-	/* Forward link the descriptor list */
-	for (i = 0, p = host->sg_cpu; i < host->ring_size - 1; i++, p++)
-		p->des3 = host->sg_dma + (sizeof(struct idmac_desc) * (i + 1));
+		/* Set the last descriptor as the end-of-ring descriptor */
+		p->des6 = host->sg_dma & 0xffffffff;
+		p->des7 = host->sg_dma >> 32;
+		p->des0 = IDMAC_DES0_ER;
 
-	/* Set the last descriptor as the end-of-ring descriptor */
-	p->des3 = host->sg_dma;
-	p->des0 = IDMAC_DES0_ER;
+	} else {
+		struct idmac_desc *p;
+		/* Number of descriptors in the ring buffer */
+		host->ring_size = PAGE_SIZE / sizeof(struct idmac_desc);
 
-	dw_mci_idmac_reset(host);
+		/* Forward link the descriptor list */
+		for (i = 0, p = host->sg_cpu; i < host->ring_size - 1; i++, p++)
+			p->des3 = host->sg_dma + (sizeof(struct idmac_desc) *
+								(i + 1));
+
+		/* Set the last descriptor as the end-of-ring descriptor */
+		p->des3 = host->sg_dma;
+		p->des0 = IDMAC_DES0_ER;
+	}
+
+	mci_writel(host, BMOD, SDMMC_IDMAC_SWRESET);
+
+	if (host->dma_64bit_address == 1) {
+		/* Mask out interrupts - get Tx & Rx complete only */
+		mci_writel(host, IDSTS64, IDMAC_INT_CLR);
+		mci_writel(host, IDINTEN64, SDMMC_IDMAC_INT_NI |
+				SDMMC_IDMAC_INT_RI | SDMMC_IDMAC_INT_TI);
 
-	/* Mask out interrupts - get Tx & Rx complete only */
-	mci_writel(host, IDSTS, IDMAC_INT_CLR);
-	mci_writel(host, IDINTEN, SDMMC_IDMAC_INT_NI | SDMMC_IDMAC_INT_RI |
-		   SDMMC_IDMAC_INT_TI);
+		/* Set the descriptor base address */
+		mci_writel(host, DBADDRL, host->sg_dma & 0xffffffff);
+		mci_writel(host, DBADDRU, host->sg_dma >> 32);
+
+	} else {
+		/* Mask out interrupts - get Tx & Rx complete only */
+		mci_writel(host, IDSTS, IDMAC_INT_CLR);
+		mci_writel(host, IDINTEN, SDMMC_IDMAC_INT_NI |
+				SDMMC_IDMAC_INT_RI | SDMMC_IDMAC_INT_TI);
+
+		/* Set the descriptor base address */
+		mci_writel(host, DBADDR, host->sg_dma);
+	}
 
-	/* Set the descriptor base address */
-	mci_writel(host, DBADDR, host->sg_dma);
 	return 0;
 }
 
@@ -2045,11 +2137,22 @@ static irqreturn_t dw_mci_interrupt(int irq, void *dev_id)
 
 #ifdef CONFIG_MMC_DW_IDMAC
 	/* Handle DMA interrupts */
-	pending = mci_readl(host, IDSTS);
-	if (pending & (SDMMC_IDMAC_INT_TI | SDMMC_IDMAC_INT_RI)) {
-		mci_writel(host, IDSTS, SDMMC_IDMAC_INT_TI | SDMMC_IDMAC_INT_RI);
-		mci_writel(host, IDSTS, SDMMC_IDMAC_INT_NI);
-		host->dma_ops->complete(host);
+	if (host->dma_64bit_address == 1) {
+		pending = mci_readl(host, IDSTS64);
+		if (pending & (SDMMC_IDMAC_INT_TI | SDMMC_IDMAC_INT_RI)) {
+			mci_writel(host, IDSTS64, SDMMC_IDMAC_INT_TI |
+							SDMMC_IDMAC_INT_RI);
+			mci_writel(host, IDSTS64, SDMMC_IDMAC_INT_NI);
+			host->dma_ops->complete(host);
+		}
+	} else {
+		pending = mci_readl(host, IDSTS);
+		if (pending & (SDMMC_IDMAC_INT_TI | SDMMC_IDMAC_INT_RI)) {
+			mci_writel(host, IDSTS, SDMMC_IDMAC_INT_TI |
+							SDMMC_IDMAC_INT_RI);
+			mci_writel(host, IDSTS, SDMMC_IDMAC_INT_NI);
+			host->dma_ops->complete(host);
+		}
 	}
 #endif
 
@@ -2309,6 +2412,22 @@ static void dw_mci_cleanup_slot(struct dw_mci_slot *slot, unsigned int id)
 
 static void dw_mci_init_dma(struct dw_mci *host)
 {
+	int addr_config;
+	/* Check ADDR_CONFIG bit in HCON to find IDMAC address bus width */
+	addr_config = (mci_readl(host, HCON) >> 27) & 0x01;
+
+	if (addr_config == 1) {
+		/* host supports IDMAC in 64-bit address mode */
+		host->dma_64bit_address = 1;
+		dev_info(host->dev, "IDMAC supports 64-bit address mode.\n");
+		if (!dma_set_mask(host->dev, DMA_BIT_MASK(64)))
+			dma_set_coherent_mask(host->dev, DMA_BIT_MASK(64));
+	} else {
+		/* host supports IDMAC in 32-bit address mode */
+		host->dma_64bit_address = 0;
+		dev_info(host->dev, "IDMAC supports 32-bit address mode.\n");
+	}
+
 	/* Alloc memory for sg translation */
 	host->sg_cpu = dmam_alloc_coherent(host->dev, PAGE_SIZE,
 					  &host->sg_dma, GFP_KERNEL);
diff --git a/drivers/mmc/host/dw_mmc.h b/drivers/mmc/host/dw_mmc.h
index 01b99e8..64b04aa 100644
--- a/drivers/mmc/host/dw_mmc.h
+++ b/drivers/mmc/host/dw_mmc.h
@@ -55,6 +55,17 @@
 #define SDMMC_BUFADDR		0x098
 #define SDMMC_CDTHRCTL		0x100
 #define SDMMC_DATA(x)		(x)
+/*
+* Registers to support idmac 64-bit address mode
+*/
+#define SDMMC_DBADDRL		0x088
+#define SDMMC_DBADDRU		0x08c
+#define SDMMC_IDSTS64		0x090
+#define SDMMC_IDINTEN64		0x094
+#define SDMMC_DSCADDRL		0x098
+#define SDMMC_DSCADDRU		0x09c
+#define SDMMC_BUFADDRL		0x0A0
+#define SDMMC_BUFADDRU		0x0A4
 
 /*
  * Data offset is difference according to Version
diff --git a/include/linux/mmc/dw_mmc.h b/include/linux/mmc/dw_mmc.h
index 0013669..9e6eabb 100644
--- a/include/linux/mmc/dw_mmc.h
+++ b/include/linux/mmc/dw_mmc.h
@@ -54,6 +54,7 @@ struct mmc_data;
  *	transfer is in progress.
  * @use_dma: Whether DMA channel is initialized or not.
  * @using_dma: Whether DMA is in use for the current transfer.
+ * @dma_64bit_address: Whether DMA supports 64-bit address mode or not.
  * @sg_dma: Bus address of DMA buffer.
  * @sg_cpu: Virtual address of DMA buffer.
  * @dma_ops: Pointer to platform-specific DMA callbacks.
@@ -140,6 +141,7 @@ struct dw_mci {
 	/* DMA interface members*/
 	int			use_dma;
 	int			using_dma;
+	int			dma_64bit_address;
 
 	dma_addr_t		sg_dma;
 	void			*sg_cpu;
-- 
1.7.6.5
