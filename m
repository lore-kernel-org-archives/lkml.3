Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082AbaGIMir (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 08:38:47 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:36414 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755708AbaGIMip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 08:38:45 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <computersforpeace@gmail.com>
CC: <javier@dowhile0.org>, <pekon@ti.com>,
        <ezequiel.garcia@free-electrons.com>, <dwmw2@infradead.org>,
        <jg1.han@samsung.com>, <nsekhar@ti.com>,
        <linux-mtd@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [RFC PATCH 06/10] mtd: nand: omap: Use GPMC APIs for accessing Prefetch engine
Date: Wed, 9 Jul 2014 15:37:26 +0300
Message-ID: <1404909450-11970-7-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1404909450-11970-1-git-send-email-rogerq@ti.com>
References: <1404909450-11970-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't access the Prefetch engine registers directly as they belong
to the GPMC controller's register space. Use the relevant GPMC
APIs instead.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/mtd/nand/omap2.c | 155 ++++++++++++++---------------------------------
 1 file changed, 45 insertions(+), 110 deletions(-)

diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
index f50e71d..420ef0b 100644
--- a/drivers/mtd/nand/omap2.c
+++ b/drivers/mtd/nand/omap2.c
@@ -100,20 +100,13 @@
 #define P4e_s(a)	(TF(a & NAND_Ecc_P4e)		<< 0)
 #define P4o_s(a)	(TF(a & NAND_Ecc_P4o)		<< 1)
 
-#define	PREFETCH_CONFIG1_CS_SHIFT	24
 #define	ECC_CONFIG_CS_SHIFT		1
 #define	CS_MASK				0x7
-#define	ENABLE_PREFETCH			(0x1 << 7)
-#define	DMA_MPU_MODE_SHIFT		2
 #define	ECCSIZE0_SHIFT			12
 #define	ECCSIZE1_SHIFT			22
 #define	ECC1RESULTSIZE			0x1
 #define	ECCCLEAR			0x100
 #define	ECC1				0x1
-#define	PREFETCH_FIFOTHRESHOLD_MAX	0x40
-#define	PREFETCH_FIFOTHRESHOLD(val)	((val) << 8)
-#define	PREFETCH_STATUS_COUNT(val)	(val & 0x00003fff)
-#define	PREFETCH_STATUS_FIFO_CNT(val)	((val >> 24) & 0x7F)
 #define	STATUS_BUFF_EMPTY		0x00000001
 
 #define OMAP24XX_DMA_GPMC		4
@@ -177,63 +170,6 @@ struct omap_nand_info {
 };
 
 /**
- * omap_prefetch_enable - configures and starts prefetch transfer
- * @cs: cs (chip select) number
- * @fifo_th: fifo threshold to be used for read/ write
- * @dma_mode: dma mode enable (1) or disable (0)
- * @u32_count: number of bytes to be transferred
- * @is_write: prefetch read(0) or write post(1) mode
- */
-static int omap_prefetch_enable(int cs, int fifo_th, int dma_mode,
-	unsigned int u32_count, int is_write, struct omap_nand_info *info)
-{
-	u32 val;
-
-	if (fifo_th > PREFETCH_FIFOTHRESHOLD_MAX)
-		return -1;
-
-	if (readl(info->reg.gpmc_prefetch_control))
-		return -EBUSY;
-
-	/* Set the amount of bytes to be prefetched */
-	writel(u32_count, info->reg.gpmc_prefetch_config2);
-
-	/* Set dma/mpu mode, the prefetch read / post write and
-	 * enable the engine. Set which cs is has requested for.
-	 */
-	val = ((cs << PREFETCH_CONFIG1_CS_SHIFT) |
-		PREFETCH_FIFOTHRESHOLD(fifo_th) | ENABLE_PREFETCH |
-		(dma_mode << DMA_MPU_MODE_SHIFT) | (0x1 & is_write));
-	writel(val, info->reg.gpmc_prefetch_config1);
-
-	/*  Start the prefetch engine */
-	writel(0x1, info->reg.gpmc_prefetch_control);
-
-	return 0;
-}
-
-/**
- * omap_prefetch_reset - disables and stops the prefetch engine
- */
-static int omap_prefetch_reset(int cs, struct omap_nand_info *info)
-{
-	u32 config1;
-
-	/* check if the same module/cs is trying to reset */
-	config1 = readl(info->reg.gpmc_prefetch_config1);
-	if (((config1 >> PREFETCH_CONFIG1_CS_SHIFT) & CS_MASK) != cs)
-		return -EINVAL;
-
-	/* Stop the PFPW engine */
-	writel(0x0, info->reg.gpmc_prefetch_control);
-
-	/* Reset/disable the PFPW engine */
-	writel(0x0, info->reg.gpmc_prefetch_config1);
-
-	return 0;
-}
-
-/**
  * omap_hwcontrol - hardware specific access to control-lines
  * @mtd: MTD device structure
  * @cmd: command to device
@@ -362,26 +298,26 @@ static void omap_read_buf_pref(struct mtd_info *mtd, u_char *buf, int len)
 		len -= len % 4;
 	}
 
-	/* configure and start prefetch transfer */
-	ret = omap_prefetch_enable(info->gpmc_cs,
-			PREFETCH_FIFOTHRESHOLD_MAX, 0x0, len, 0x0, info);
+	/* configure and start prefetch engine */
+	ret = omap_gpmc_prefetch_start(info->gpmc_cs,
+				       GPMC_PREFETCH_FIFOTHRESHOLD_MAX,
+				       false, len, false);
 	if (ret) {
-		/* PFPW engine is busy, use cpu copy method */
+		/* prefetch engine is busy, use cpu copy method */
 		if (info->nand.options & NAND_BUSWIDTH_16)
 			omap_read_buf16(mtd, (u_char *)p, len);
 		else
 			omap_read_buf8(mtd, (u_char *)p, len);
 	} else {
 		do {
-			r_count = readl(info->reg.gpmc_prefetch_status);
-			r_count = PREFETCH_STATUS_FIFO_CNT(r_count);
+			r_count = omap_gpmc_get_prefetch_fifo_count();
 			r_count = r_count >> 2;
 			ioread32_rep(info->nand.IO_ADDR_R, p, r_count);
 			p += r_count;
 			len -= r_count << 2;
 		} while (len);
-		/* disable and stop the PFPW engine */
-		omap_prefetch_reset(info->gpmc_cs, info);
+		/* disable and stop the prefetch engine */
+		omap_gpmc_prefetch_stop(info->gpmc_cs);
 	}
 }
 
@@ -409,35 +345,35 @@ static void omap_write_buf_pref(struct mtd_info *mtd,
 		len--;
 	}
 
-	/*  configure and start prefetch transfer */
-	ret = omap_prefetch_enable(info->gpmc_cs,
-			PREFETCH_FIFOTHRESHOLD_MAX, 0x0, len, 0x1, info);
+	/*  configure and start posted write engine */
+	ret = omap_gpmc_prefetch_start(info->gpmc_cs,
+				       GPMC_PREFETCH_FIFOTHRESHOLD_MAX,
+				       false, len, true);
 	if (ret) {
-		/* PFPW engine is busy, use cpu copy method */
+		/* posted write engine is busy, use cpu copy method */
 		if (info->nand.options & NAND_BUSWIDTH_16)
 			omap_write_buf16(mtd, (u_char *)p, len);
 		else
 			omap_write_buf8(mtd, (u_char *)p, len);
 	} else {
 		while (len) {
-			w_count = readl(info->reg.gpmc_prefetch_status);
-			w_count = PREFETCH_STATUS_FIFO_CNT(w_count);
+			w_count = omap_gpmc_get_prefetch_fifo_count();
 			w_count = w_count >> 1;
 			for (i = 0; (i < w_count) && len; i++, len -= 2)
 				iowrite16(*p++, info->nand.IO_ADDR_W);
 		}
-		/* wait for data to flushed-out before reset the prefetch */
+
+		/* wait for data to flushed-out before resetting the engine */
 		tim = 0;
 		limit = (loops_per_jiffy *
 					msecs_to_jiffies(OMAP_NAND_TIMEOUT_MS));
 		do {
 			cpu_relax();
-			val = readl(info->reg.gpmc_prefetch_status);
-			val = PREFETCH_STATUS_COUNT(val);
+			val = omap_gpmc_get_prefetch_count();
 		} while (val && (tim++ < limit));
 
-		/* disable and stop the PFPW engine */
-		omap_prefetch_reset(info->gpmc_cs, info);
+		/* disable and stop the posted write engine */
+		omap_gpmc_prefetch_stop(info->gpmc_cs);
 	}
 }
 
@@ -458,7 +394,7 @@ static void omap_nand_dma_callback(void *data)
  * @is_write: flag for read/write operation
  */
 static inline int omap_nand_dma_transfer(struct mtd_info *mtd, void *addr,
-					unsigned int len, int is_write)
+					unsigned int len, bool is_write)
 {
 	struct omap_nand_info *info = container_of(mtd,
 					struct omap_nand_info, mtd);
@@ -501,9 +437,10 @@ static inline int omap_nand_dma_transfer(struct mtd_info *mtd, void *addr,
 	tx->callback_param = &info->comp;
 	dmaengine_submit(tx);
 
-	/*  configure and start prefetch transfer */
-	ret = omap_prefetch_enable(info->gpmc_cs,
-		PREFETCH_FIFOTHRESHOLD_MAX, 0x1, len, is_write, info);
+	/* configure and start prefetch engine */
+	ret = omap_gpmc_prefetch_start(info->gpmc_cs,
+				       GPMC_PREFETCH_FIFOTHRESHOLD_MAX,
+				       true, len, is_write);
 	if (ret)
 		/* PFPW engine is busy, use cpu copy method */
 		goto out_copy_unmap;
@@ -518,12 +455,11 @@ static inline int omap_nand_dma_transfer(struct mtd_info *mtd, void *addr,
 
 	do {
 		cpu_relax();
-		val = readl(info->reg.gpmc_prefetch_status);
-		val = PREFETCH_STATUS_COUNT(val);
+		val = omap_gpmc_get_prefetch_count();
 	} while (val && (tim++ < limit));
 
-	/* disable and stop the PFPW engine */
-	omap_prefetch_reset(info->gpmc_cs, info);
+	/* disable and stop the prefetch engine */
+	omap_gpmc_prefetch_stop(info->gpmc_cs);
 
 	dma_unmap_sg(info->dma->device->dev, &sg, 1, dir);
 	return 0;
@@ -552,7 +488,7 @@ static void omap_read_buf_dma_pref(struct mtd_info *mtd, u_char *buf, int len)
 		omap_read_buf_pref(mtd, buf, len);
 	else
 		/* start transfer in DMA mode */
-		omap_nand_dma_transfer(mtd, buf, len, 0x0);
+		omap_nand_dma_transfer(mtd, buf, len, false);
 }
 
 /**
@@ -568,7 +504,7 @@ static void omap_write_buf_dma_pref(struct mtd_info *mtd,
 		omap_write_buf_pref(mtd, buf, len);
 	else
 		/* start transfer in DMA mode */
-		omap_nand_dma_transfer(mtd, (u_char *) buf, len, 0x1);
+		omap_nand_dma_transfer(mtd, (u_char *)buf, len, true);
 }
 
 /*
@@ -581,8 +517,7 @@ static irqreturn_t omap_nand_irq(int this_irq, void *dev)
 	struct omap_nand_info *info = (struct omap_nand_info *) dev;
 	u32 bytes;
 
-	bytes = readl(info->reg.gpmc_prefetch_status);
-	bytes = PREFETCH_STATUS_FIFO_CNT(bytes);
+	bytes = omap_gpmc_get_prefetch_fifo_count();
 	bytes = bytes  & 0xFFFC; /* io in multiple of 4 bytes */
 	if (info->iomode == OMAP_NAND_IO_WRITE) { /* checks for write io */
 		if (this_irq == info->gpmc_irq_count)
@@ -638,11 +573,12 @@ static void omap_read_buf_irq_pref(struct mtd_info *mtd, u_char *buf, int len)
 	info->buf = buf;
 	init_completion(&info->comp);
 
-	/*  configure and start prefetch transfer */
-	ret = omap_prefetch_enable(info->gpmc_cs,
-			PREFETCH_FIFOTHRESHOLD_MAX/2, 0x0, len, 0x0, info);
+	/*  configure and start prefetch engine */
+	ret = omap_gpmc_prefetch_start(info->gpmc_cs,
+				       GPMC_PREFETCH_FIFOTHRESHOLD_MAX/2,
+				       false, len, false);
 	if (ret)
-		/* PFPW engine is busy, use cpu copy method */
+		/* prefetch engine is busy, use cpu copy method */
 		goto out_copy;
 
 	info->buf_len = len;
@@ -653,8 +589,8 @@ static void omap_read_buf_irq_pref(struct mtd_info *mtd, u_char *buf, int len)
 	/* waiting for read to complete */
 	wait_for_completion(&info->comp);
 
-	/* disable and stop the PFPW engine */
-	omap_prefetch_reset(info->gpmc_cs, info);
+	/* disable and stop the prefetch engine */
+	omap_gpmc_prefetch_stop(info->gpmc_cs);
 	return;
 
 out_copy:
@@ -688,11 +624,11 @@ static void omap_write_buf_irq_pref(struct mtd_info *mtd,
 	info->buf = (u_char *) buf;
 	init_completion(&info->comp);
 
-	/* configure and start prefetch transfer : size=24 */
-	ret = omap_prefetch_enable(info->gpmc_cs,
-		(PREFETCH_FIFOTHRESHOLD_MAX * 3) / 8, 0x0, len, 0x1, info);
+	/* configure and start posted write engine : fifo size = 24 */
+	ret = omap_gpmc_prefetch_start(info->gpmc_cs, 24,
+				       false, len, true);
 	if (ret)
-		/* PFPW engine is busy, use cpu copy method */
+		/* posted write engine is busy, use cpu copy method */
 		goto out_copy;
 
 	info->buf_len = len;
@@ -703,17 +639,16 @@ static void omap_write_buf_irq_pref(struct mtd_info *mtd,
 	/* waiting for write to complete */
 	wait_for_completion(&info->comp);
 
-	/* wait for data to flushed-out before reset the prefetch */
+	/* wait for data to flushed-out before reset the engine */
 	tim = 0;
 	limit = (loops_per_jiffy *  msecs_to_jiffies(OMAP_NAND_TIMEOUT_MS));
 	do {
-		val = readl(info->reg.gpmc_prefetch_status);
-		val = PREFETCH_STATUS_COUNT(val);
+		val = omap_gpmc_get_prefetch_count();
 		cpu_relax();
 	} while (val && (tim++ < limit));
 
-	/* disable and stop the PFPW engine */
-	omap_prefetch_reset(info->gpmc_cs, info);
+	/* disable and stop the posted write engine */
+	omap_gpmc_prefetch_stop(info->gpmc_cs);
 	return;
 
 out_copy:
-- 
1.8.3.2

