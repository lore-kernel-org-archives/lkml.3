Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919AbaGIMim (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 08:38:42 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:36391 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755782AbaGIMij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 08:38:39 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <computersforpeace@gmail.com>
CC: <javier@dowhile0.org>, <pekon@ti.com>,
        <ezequiel.garcia@free-electrons.com>, <dwmw2@infradead.org>,
        <jg1.han@samsung.com>, <nsekhar@ti.com>,
        <linux-mtd@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [RFC PATCH 05/10] OMAP: GPMC: Introduce APIs for accessing Prefetch/Write-post engine
Date: Wed, 9 Jul 2014 15:37:25 +0300
Message-ID: <1404909450-11970-6-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1404909450-11970-1-git-send-email-rogerq@ti.com>
References: <1404909450-11970-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even though the Prefetch engine is meant for exclusive use by
the OMAP NAND controller, itst registers belong to the GPMC controller's
register space.

Introduce 4 APIs to access the Prefetch/Write-post engine.

int omap_gpmc_prefetch_start(int cs, int fifo_th, bool dma,
			     u32 count, int is_write);
int omap_gpmc_prefetch_stop(int cs);
u32 omap_gpmc_get_prefetch_count(void);
u32 omap_gpmc_get_prefetch_fifo_count(void);

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/gpmc.c     | 134 +++++++++++++++++++++++++++++++++++++++++
 include/linux/omap-gpmc-nand.h |  30 +++++++++
 2 files changed, 164 insertions(+)

diff --git a/arch/arm/mach-omap2/gpmc.c b/arch/arm/mach-omap2/gpmc.c
index 92bbada..43e2a9d 100644
--- a/arch/arm/mach-omap2/gpmc.c
+++ b/arch/arm/mach-omap2/gpmc.c
@@ -33,6 +33,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/omap-gpmc-nand.h>
 #include <linux/platform_data/mtd-nand-omap2.h>
+#include <linux/bitops.h>
 
 #include <asm/mach-types.h>
 
@@ -114,6 +115,20 @@
 
 #define GPMC_NR_WAITPINS		4
 
+/* GPMC Prefetch/Write-post Engine */
+#define GPMC_PREFETCH_CONFIG1_ENABLE_PREFETCH	BIT(7)
+#define GPMC_PREFETCH_CONFIG1_DMAMODE		BIT(2)
+#define GPMC_PREFETCH_CONFIG1_ACCESSMODE	BIT(0)
+#define GPMC_PREFETCH_CONFIG1_CS_MASK		GENMASK(26, 24)
+#define GPMC_PREFETCH_CONFIG1_CS_SHIFT		24
+#define GPMC_PREFETCH_CONFIG1_FIFOTH_MASK	GENMASK(14, 8)
+#define GPMC_PREFETCH_CONFIG1_FIFOTH_SHIFT	8
+
+#define GPMC_PREFETCH_CONTROL_START		BIT(0)
+
+#define GPMC_PREFETCH_STATUS_COUNT(val)		(val & 0x00003fff)
+#define GPMC_PREFETCH_STATUS_FIFO_CNT(val)	((val >> 24) & 0x7F)
+
 /* XXX: Only NAND irq has been considered,currently these are the only ones used
  */
 #define	GPMC_NR_IRQ		2
@@ -1971,3 +1986,122 @@ void omap_gpmc_write_reg(int cs, enum omap_gpmc_reg reg, u32 val)
 		break;
 	}
 }
+
+/**
+ * omap_gpmc_prefetch_start - configures and starts the prefetch engine
+ *
+ * @cs: cs (chip select) number
+ * @fifo_th: fifo threshold to be used for read/ write
+ * @dma: dma mode enable (1) or disable (0)
+ * @count: number of bytes to be transferred
+ * @is_write: prefetch read(0) or write post(1) mode
+ *
+ * As there is a single prefetch engine that must be shared between
+ * chip selects containing NAND flashes, the function returns -EBUSY if
+ * the engine is already in use. Returns 0 on success.
+ */
+int omap_gpmc_prefetch_start(int cs, int fifo_th, bool dma,
+			     u32 count, int is_write)
+{
+	u32 val;
+
+	if (!gpmc_dev)
+		return -ENODEV;
+
+	if (cs >= gpmc_cs_num)
+		return -EINVAL;
+
+	if (fifo_th > GPMC_PREFETCH_FIFOTHRESHOLD_MAX)
+		return -EINVAL;
+
+	/* Check if engine is already in use */
+	if (gpmc_read_reg(GPMC_PREFETCH_CONTROL))
+		return -EBUSY;
+
+	/* Set the amount of bytes to be prefetched */
+	gpmc_write_reg(GPMC_PREFETCH_CONFIG2, count);
+
+	/* Set dma/mpu mode, the prefetch read / post write and
+	 * enable the engine. Set which cs is has requested for.
+	 */
+	val = ((cs << GPMC_PREFETCH_CONFIG1_CS_SHIFT) |
+		GPMC_PREFETCH_CONFIG1_ENABLE_PREFETCH |
+		(GPMC_PREFETCH_CONFIG1_ACCESSMODE & is_write));
+
+	val |= (fifo_th << GPMC_PREFETCH_CONFIG1_FIFOTH_SHIFT) &
+		GPMC_PREFETCH_CONFIG1_FIFOTH_MASK;
+
+	if (dma)
+		val |= GPMC_PREFETCH_CONFIG1_DMAMODE;
+
+	gpmc_write_reg(GPMC_PREFETCH_CONFIG1, val);
+
+	/*  Start the prefetch engine */
+	gpmc_write_reg(GPMC_PREFETCH_CONTROL, GPMC_PREFETCH_CONTROL_START);
+
+	return 0;
+}
+
+/**
+ * omap_gpmc_prefetch_stop - stops and disables the prefetch engine
+ *
+ * @cs: Chip select number
+ */
+int omap_gpmc_prefetch_stop(int cs)
+{
+	u32 config1;
+
+	if (!gpmc_dev)
+		return -ENODEV;
+
+	if (cs >= gpmc_cs_num)
+		return -EINVAL;
+
+	/* check if the same module/cs is trying to reset */
+	config1 = gpmc_read_reg(GPMC_PREFETCH_CONFIG1);
+	config1 &= GPMC_PREFETCH_CONFIG1_CS_MASK;
+
+	if ((config1 >> GPMC_PREFETCH_CONFIG1_CS_SHIFT) != cs)
+		return -EINVAL;
+
+	/* Stop the engine */
+	gpmc_write_reg(GPMC_PREFETCH_CONTROL, 0);
+
+	/* Reset/disable the engine */
+	gpmc_write_reg(GPMC_PREFETCH_CONFIG1, 0);
+
+	return 0;
+}
+
+/**
+ * omap_gpmc_get_prefetch_count - Returns the number of bytes remaining to be
+ * read or written by the prefetch/write-post engine
+ */
+u32 omap_gpmc_get_prefetch_count(void)
+{
+	u32 count;
+
+	if (!gpmc_dev)
+		return 0;
+
+	count = gpmc_read_reg(GPMC_PREFETCH_STATUS);
+	count = GPMC_PREFETCH_STATUS_COUNT(count);
+	return count;
+}
+
+/**
+ * omap_gpmc_get_prefetch_fifo_count - Returns the number of bytes available
+ * to be read from the FIFO or free bytes available to be written to the FIFO
+ * by the CPU
+ */
+u32 omap_gpmc_get_prefetch_fifo_count(void)
+{
+	u32 count;
+
+	if (!gpmc_dev)
+		return 0;
+
+	count = gpmc_read_reg(GPMC_PREFETCH_STATUS);
+	count = GPMC_PREFETCH_STATUS_FIFO_CNT(count);
+	return count;
+}
diff --git a/include/linux/omap-gpmc-nand.h b/include/linux/omap-gpmc-nand.h
index dcb2abe..c445d89 100644
--- a/include/linux/omap-gpmc-nand.h
+++ b/include/linux/omap-gpmc-nand.h
@@ -26,6 +26,12 @@ enum omap_gpmc_reg {
 #ifdef CONFIG_ARCH_OMAP2PLUS
 u32 omap_gpmc_read_reg(int cs, enum omap_gpmc_reg reg);
 void omap_gpmc_write_reg(int cs, enum omap_gpmc_reg reg, u32 val);
+
+int omap_gpmc_prefetch_start(int cs, int fifo_th, bool dma,
+			     u32 count, int is_write);
+int omap_gpmc_prefetch_stop(int cs);
+u32 omap_gpmc_get_prefetch_count(void);
+u32 omap_gpmc_get_prefetch_fifo_count(void);
 #else
 static inline u32 omap_gpmc_read_reg(int cs, enum omap_gpmc_reg reg)
 {
@@ -35,6 +41,30 @@ static inline u32 omap_gpmc_read_reg(int cs, enum omap_gpmc_reg reg)
 static inline void omap_gpmc_write_reg(int cs, enum omap_gpmc_reg reg, u32 val)
 {
 }
+
+static inline int omap_gpmc_prefetch_start(int cs, int fifo_th, bool dma,
+					   u32 count, int is_write)
+{
+	return -ENOSYS;
+}
+
+static inline int omap_gpmc_prefetch_stop(int cs)
+{
+	return -ENOSYS;
+}
+
+static inline u32 omap_gpmc_get_prefetch_count(void)
+{
+	return 0;
+}
+
+static inline u32 omap_gpmc_get_prefetch_fifo_count(void)
+{
+	return 0;
+}
 #endif
 
+/* Prefetch/Write-post Engine */
+#define GPMC_PREFETCH_FIFOTHRESHOLD_MAX		0x40
+
 #endif /* _GPMC_OMAP_H_ */
-- 
1.8.3.2

