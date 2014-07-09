Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352AbaGIMjH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 08:39:07 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:36482 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755708AbaGIMjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 08:39:00 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <computersforpeace@gmail.com>
CC: <javier@dowhile0.org>, <pekon@ti.com>,
        <ezequiel.garcia@free-electrons.com>, <dwmw2@infradead.org>,
        <jg1.han@samsung.com>, <nsekhar@ti.com>,
        <linux-mtd@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [RFC PATCH 08/10] OMAP: GPMC: Introduce APIs to get ECC/BCH results
Date: Wed, 9 Jul 2014 15:37:28 +0300
Message-ID: <1404909450-11970-9-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1404909450-11970-1-git-send-email-rogerq@ti.com>
References: <1404909450-11970-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even though the ECC/BCH engine is meant for exclusive use by
the OMAP NAND controller, the ECC/BCH result registers belong
to the GPMC controller's register space.

Introduce 2 APIs to access the ECC/BCH results.
void omap_gpmc_ecc_get_result(int length, u32 *result);
void omap_gpmc_ecc_get_bch_result(int length, u8 sector, u32 *result);

The first one is to get the Hamming code ECC result registers
and the second one is to get the BCH ECC result registers.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/gpmc.c     | 97 +++++++++++++++++++++++++++++++++++++++---
 include/linux/omap-gpmc-nand.h | 11 +++++
 2 files changed, 101 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-omap2/gpmc.c b/arch/arm/mach-omap2/gpmc.c
index 8befd16..9222244 100644
--- a/arch/arm/mach-omap2/gpmc.c
+++ b/arch/arm/mach-omap2/gpmc.c
@@ -65,6 +65,7 @@
 #define GPMC_ECC_CONTROL	0x1f8
 #define GPMC_ECC_SIZE_CONFIG	0x1fc
 #define GPMC_ECC1_RESULT        0x200
+#define GPMC_ECC9_RESULT        0x220
 #define GPMC_ECC_BCH_RESULT_0   0x240   /* not available on OMAP2 */
 #define	GPMC_ECC_BCH_RESULT_1	0x244	/* not available on OMAP2 */
 #define	GPMC_ECC_BCH_RESULT_2	0x248	/* not available on OMAP2 */
@@ -83,6 +84,7 @@
 #define GPMC_CS0_OFFSET		0x60
 #define GPMC_CS_SIZE		0x30
 #define	GPMC_BCH_SIZE		0x10
+#define GPMC_BCH_NUM		7	/* Max no. of BCH registers 0-6 */
 
 #define GPMC_MEM_END		0x3FFFFFFF
 
@@ -96,9 +98,10 @@
 #define	GPMC_REVISION_MAJOR(l)		((l >> 4) & 0xf)
 #define	GPMC_REVISION_MINOR(l)		(l & 0xf)
 
-#define	GPMC_HAS_WR_ACCESS		0x1
-#define	GPMC_HAS_WR_DATA_MUX_BUS	0x2
-#define	GPMC_HAS_MUX_AAD		0x4
+#define	GPMC_HAS_WR_ACCESS		BIT(0)
+#define	GPMC_HAS_WR_DATA_MUX_BUS	BIT(1)
+#define	GPMC_HAS_MUX_AAD		BIT(2)
+#define	GPMC_HAS_BCH			BIT(3)
 
 #define GPMC_NR_WAITPINS		4
 
@@ -185,6 +188,7 @@ static DEFINE_SPINLOCK(gpmc_mem_lock);
 static unsigned int gpmc_cs_map = ((1 << GPMC_CS_NUM) - 1);
 static unsigned int gpmc_cs_num = GPMC_CS_NUM;
 static unsigned int gpmc_nr_waitpins;
+static unsigned int gpmc_bch_num = GPMC_BCH_NUM;
 static struct device *gpmc_dev;
 static int gpmc_irq;
 static resource_size_t phys_base, mem_size;
@@ -198,6 +202,7 @@ struct gpmc_nand_reg {
 };
 
 static struct gpmc_nand_reg gpmc_nand_reg_map[GPMC_CS_NUM];
+void __iomem *gpmc_bch_reg_map[GPMC_BCH_NUM][GPMC_BCH_NUM_REMAINDER];
 
 static struct clk *gpmc_l3_clk;
 
@@ -205,7 +210,7 @@ static irqreturn_t gpmc_handle_irq(int irq, void *dev);
 
 static void gpmc_fill_nand_reg_map(void)
 {
-	int i;
+	int i, j;
 
 	for (i = 0; i < gpmc_cs_num; i++) {
 		gpmc_nand_reg_map[i].command = gpmc_base + GPMC_CS0_OFFSET +
@@ -215,6 +220,28 @@ static void gpmc_fill_nand_reg_map(void)
 		gpmc_nand_reg_map[i].data  = gpmc_base + GPMC_CS0_OFFSET +
 				GPMC_CS_NAND_DATA + GPMC_CS_SIZE * i;
 	}
+
+	if (!(gpmc_capability & GPMC_HAS_BCH))
+		return;
+
+
+	for (i = 0; i < 4; i++) {
+		for (j = 0; j < 8; j++) {
+			gpmc_bch_reg_map[i][j] = gpmc_base +
+						 GPMC_ECC_BCH_RESULT_0 +
+						 i * 4 + GPMC_BCH_SIZE * j;
+		}
+	}
+
+	/* 2nd for loop for BCH4 onwards due to non-consecutive address */
+	for (i = 4; i < gpmc_bch_num; i++) {
+		for (j = 0; j < 8; j++) {
+			gpmc_bch_reg_map[i][j] = gpmc_base +
+						 GPMC_ECC_BCH_RESULT_4 +
+						 (i - 4) * 4 +
+						 GPMC_BCH_SIZE * j;
+		}
+	}
 }
 
 static void gpmc_write_reg(int idx, u32 val)
@@ -1738,10 +1765,17 @@ static int gpmc_probe(struct platform_device *pdev)
 	 * - OMAP3xxx			= 5.0
 	 * - OMAP44xx/54xx/AM335x	= 6.0
 	 */
-	if (GPMC_REVISION_MAJOR(l) > 0x4)
-		gpmc_capability = GPMC_HAS_WR_ACCESS | GPMC_HAS_WR_DATA_MUX_BUS;
-	if (GPMC_REVISION_MAJOR(l) > 0x5)
+	if (GPMC_REVISION_MAJOR(l) >= 5) {
+		gpmc_capability = GPMC_HAS_WR_ACCESS |
+				  GPMC_HAS_WR_DATA_MUX_BUS | GPMC_HAS_BCH;
+		gpmc_bch_num = 4;
+	}
+
+	if (GPMC_REVISION_MAJOR(l) >= 6) {
 		gpmc_capability |= GPMC_HAS_MUX_AAD;
+		gpmc_bch_num = GPMC_BCH_NUM;
+	}
+
 	dev_info(gpmc_dev, "GPMC revision %d.%d\n", GPMC_REVISION_MAJOR(l),
 		 GPMC_REVISION_MINOR(l));
 
@@ -2188,3 +2222,52 @@ void omap_gpmc_ecc_configure_enable(int cs, bool ecc16, u8 ecc_size0,
 	val |= GPMC_ECC_CONFIG_ECCENABLE;
 	gpmc_write_reg(GPMC_ECC_CONFIG, val);
 }
+
+/**
+ * omap_gpmc_ecc_get_result - reads out the Hamming code ECC result registers
+ *
+ * @length: Number of 32-bit registers to read
+ * @result: pointer to 32-bit buffer where results should be copied into
+ */
+void omap_gpmc_ecc_get_result(int length, u32 *result)
+{
+	u32 reg_addr;
+	int i;
+
+	if (!gpmc_dev)
+		return;
+
+	reg_addr = GPMC_ECC1_RESULT;
+	for (i = 0; i < length; i++) {
+		*result++ = gpmc_read_reg(reg_addr);
+		reg_addr += 4;
+		/* Don't read past ECC_RESULT region */
+		if (reg_addr > GPMC_ECC9_RESULT)
+			break;
+	}
+}
+
+/**
+ * omap_gpmc_ecc_get_bch_result - reads out the BCH result registers
+ *
+ * @length: Number of 32-bit registers to read
+ * @sector: Which sector's results to read (0 to 7)
+ * @result: pointer to 32-bit buffer where results should be copied into
+ */
+void omap_gpmc_ecc_get_bch_result(int length, u8 sector, u32 *result)
+{
+	int i;
+
+	if (!gpmc_dev)
+		return;
+
+	if (sector > GPMC_BCH_NUM_REMAINDER)
+		return;
+
+	/* Don't read past BCH_RESULT region */
+	if (length > gpmc_bch_num)
+		length = gpmc_bch_num;
+
+	for (i = 0; i < length; i++)
+		*result++ = readl_relaxed(gpmc_bch_reg_map[i][sector]);
+}
diff --git a/include/linux/omap-gpmc-nand.h b/include/linux/omap-gpmc-nand.h
index f08cd05..d0ef165 100644
--- a/include/linux/omap-gpmc-nand.h
+++ b/include/linux/omap-gpmc-nand.h
@@ -43,6 +43,8 @@ void omap_gpmc_ecc_configure_enable(int cs, bool ecc16, u8 ecc_size0,
 				    u8 ecc_size1, bool use_bch,
 				    enum omap_gpmc_bch_type bch_type,
 				    u8 bch_sectors, u8 bch_wrap_mode);
+void omap_gpmc_ecc_get_result(int length, u32 *result);
+void omap_gpmc_ecc_get_bch_result(int length, u8 sector, u32 *result);
 #else
 static inline u32 omap_gpmc_read_reg(int cs, enum omap_gpmc_reg reg)
 {
@@ -87,6 +89,15 @@ static inline void omap_gpmc_ecc_configure_enable(int cs, bool ecc16,
 {
 }
 
+static inline void omap_gpmc_ecc_get_result(int length, u32 *result)
+{
+}
+
+static inline void omap_gpmc_ecc_get_bch_result(int length, u8 sector,
+						u32 *result)
+{
+}
+
 #endif
 
 /* Prefetch/Write-post Engine */
-- 
1.8.3.2

