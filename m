Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147AbaGIMiw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 08:38:52 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60429 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755708AbaGIMiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 08:38:50 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <computersforpeace@gmail.com>
CC: <javier@dowhile0.org>, <pekon@ti.com>,
        <ezequiel.garcia@free-electrons.com>, <dwmw2@infradead.org>,
        <jg1.han@samsung.com>, <nsekhar@ti.com>,
        <linux-mtd@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [RFC PATCH 07/10] OMAP: GPMC: Introduce APIs for Configuring ECC Engine
Date: Wed, 9 Jul 2014 15:37:27 +0300
Message-ID: <1404909450-11970-8-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1404909450-11970-1-git-send-email-rogerq@ti.com>
References: <1404909450-11970-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even though the ECC/BCH engine is meant for exclusive use by
the OMAP NAND controller, the ECC/BCH registers belong
to the GPMC controller's register space

Add omap_gpmc_ecc_configure_enable() and omap_gpmc_ecc_disable()
to manage the ECC engine. OMAP NAND driver must use these APIs
instead of directly accessing the ECC Engine registers.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/gpmc.c     | 109 ++++++++++++++++++++++++++++++++++++-----
 include/linux/omap-gpmc-nand.h |  25 ++++++++++
 2 files changed, 121 insertions(+), 13 deletions(-)

diff --git a/arch/arm/mach-omap2/gpmc.c b/arch/arm/mach-omap2/gpmc.c
index 43e2a9d..8befd16 100644
--- a/arch/arm/mach-omap2/gpmc.c
+++ b/arch/arm/mach-omap2/gpmc.c
@@ -73,19 +73,6 @@
 #define	GPMC_ECC_BCH_RESULT_5	0x304	/* not available on OMAP2 */
 #define	GPMC_ECC_BCH_RESULT_6	0x308	/* not available on OMAP2 */
 
-/* GPMC ECC control settings */
-#define GPMC_ECC_CTRL_ECCCLEAR		0x100
-#define GPMC_ECC_CTRL_ECCDISABLE	0x000
-#define GPMC_ECC_CTRL_ECCREG1		0x001
-#define GPMC_ECC_CTRL_ECCREG2		0x002
-#define GPMC_ECC_CTRL_ECCREG3		0x003
-#define GPMC_ECC_CTRL_ECCREG4		0x004
-#define GPMC_ECC_CTRL_ECCREG5		0x005
-#define GPMC_ECC_CTRL_ECCREG6		0x006
-#define GPMC_ECC_CTRL_ECCREG7		0x007
-#define GPMC_ECC_CTRL_ECCREG8		0x008
-#define GPMC_ECC_CTRL_ECCREG9		0x009
-
 #define	GPMC_CONFIG2_CSEXTRADELAY		BIT(7)
 #define	GPMC_CONFIG3_ADVEXTRADELAY		BIT(7)
 #define	GPMC_CONFIG4_OEEXTRADELAY		BIT(7)
@@ -129,6 +116,28 @@
 #define GPMC_PREFETCH_STATUS_COUNT(val)		(val & 0x00003fff)
 #define GPMC_PREFETCH_STATUS_FIFO_CNT(val)	((val >> 24) & 0x7F)
 
+/* GPMC ECC config */
+#define GPMC_ECC_CONFIG_ECCENABLE		BIT(0)
+#define GPMC_ECC_CONFIG_ECCCS_MASK		GENMASK(3, 1)
+#define GPMC_ECC_CONFIG_ECCCS_SHIFT		1
+#define GPMC_ECC_CONFIG_ECCNSECTOR_MASK		GENMASK(6, 4)
+#define GPMC_ECC_CONFIG_ECCNSECTOR_SHIFT	4
+#define GPMC_ECC_CONFIG_ECC16B			BIT(7)
+#define GPMC_ECC_CONFIG_ECCWRAPMODE_MASK	GENMASK(11, 8)
+#define GPMC_ECC_CONFIG_ECCWRAPMODE_SHIFT	8
+#define GPMC_ECC_CONFIG_ECCBCHTSEL_MASK		GENMASK(13, 12)
+#define GPMC_ECC_CONFIG_ECCBCHTSEL_SHIFT	12
+#define GPMC_ECC_CONFIG_ECCALGBCH		BIT(16)
+
+/* GPMC ECC control */
+#define	GPMC_ECC_CONTROL_ECCCLEAR		BIT(8)
+#define GPMC_ECC_CONTROL_ECCPOINTER_MASK	GENMASK(3, 0)
+#define GPMC_ECC_CONTROL_ECCPOINTER_SHIFT	0
+
+/* GPMC ECC size */
+#define GPMC_ECC_SIZE_ECCSIZE0_SHIFT	12
+#define GPMC_ECC_SIZE_ECCSIZE1_SHIFT	22
+
 /* XXX: Only NAND irq has been considered,currently these are the only ones used
  */
 #define	GPMC_NR_IRQ		2
@@ -2105,3 +2114,77 @@ u32 omap_gpmc_get_prefetch_fifo_count(void)
 	count = GPMC_PREFETCH_STATUS_FIFO_CNT(count);
 	return count;
 }
+
+/**
+ * omap_gpmc_ecc_disable - Disables the ECC engine
+ * but doesn't clear the ECC result registers.
+ */
+void omap_gpmc_ecc_disable(void)
+{
+	u32 val;
+
+	/* Disable ECC engine if running */
+	val = gpmc_read_reg(GPMC_ECC_CONFIG);
+	if (val & GPMC_ECC_CONFIG_ECCENABLE) {
+		val &= ~GPMC_ECC_CONFIG_ECCENABLE;
+		gpmc_write_reg(GPMC_ECC_CONFIG, val);
+	}
+}
+
+/**
+ * omap_gpmc_ecc_configure_enable - Configures and enables the ECC-BCH engine
+ *
+ * @cs: chip select number
+ * @ecc16: true for 16-bit ECC column, false for 8-bit ECC columna
+ * @ecc_size0: This value is written to ECCSIZE0 of GPMC_ECC_SIZE_CONFIG reg.
+ * @ecc_size1: This value is written to ECCSIZE1 of GPMC_ECC_SIZE_CONFIG reg.
+ * @use_bch: true for BCH algorithm, false for 1-bit Hamming code algorithm
+ * @bch_type: enum omap_gpmc_bch_type, 4-bit, 8-bit or 16-bit BCH error
+ *	      correction cabability. Ignored if use_bch is false.
+ * @bch_sectors: No. of sectors to process with BCH. Ignored if use_bch false.
+ * @bch_wrap_mode: pre defined spare area defination for BCH calculation.
+ *		   Ignored if use_bch is false
+ */
+void omap_gpmc_ecc_configure_enable(int cs, bool ecc16, u8 ecc_size0,
+				    u8 ecc_size1, bool use_bch,
+				    enum omap_gpmc_bch_type bch_type,
+				    u8 bch_sectors, u8 bch_wrap_mode)
+{
+	u32 val, valx;
+
+	/* Disable ECC engine if running */
+	omap_gpmc_ecc_disable();
+
+	/* Clear all ECC/BCH result registers */
+	gpmc_write_reg(GPMC_ECC_CONTROL, GPMC_ECC_CONTROL_ECCCLEAR);
+
+	/* ECC size */
+	val = (ecc_size1 << GPMC_ECC_SIZE_ECCSIZE1_SHIFT) |
+	      (ecc_size0 << GPMC_ECC_SIZE_ECCSIZE0_SHIFT);
+	gpmc_write_reg(GPMC_ECC_SIZE_CONFIG, val);
+
+	/* ECC config */
+	val = (cs << GPMC_ECC_CONFIG_ECCCS_SHIFT) & GPMC_ECC_CONFIG_ECCCS_MASK;
+
+	if (ecc16)
+		val |= GPMC_ECC_CONFIG_ECC16B;
+
+	if (use_bch) {
+		val |= GPMC_ECC_CONFIG_ECCALGBCH;
+		val |= (bch_type << GPMC_ECC_CONFIG_ECCBCHTSEL_SHIFT) &
+		       GPMC_ECC_CONFIG_ECCBCHTSEL_MASK;
+		val |= (bch_sectors << GPMC_ECC_CONFIG_ECCNSECTOR_SHIFT) &
+		       GPMC_ECC_CONFIG_ECCNSECTOR_MASK;
+		val |= (bch_wrap_mode << GPMC_ECC_CONFIG_ECCWRAPMODE_SHIFT) &
+		       GPMC_ECC_CONFIG_ECCWRAPMODE_MASK;
+	} else {
+		/* Reset ECC result pointer to 1 */
+		valx = (1 << GPMC_ECC_CONTROL_ECCPOINTER_SHIFT) &
+		       GPMC_ECC_CONTROL_ECCPOINTER_MASK;
+		gpmc_write_reg(GPMC_ECC_CONTROL, valx);
+	}
+
+	/* Enable ECC engine */
+	val |= GPMC_ECC_CONFIG_ECCENABLE;
+	gpmc_write_reg(GPMC_ECC_CONFIG, val);
+}
diff --git a/include/linux/omap-gpmc-nand.h b/include/linux/omap-gpmc-nand.h
index c445d89..f08cd05 100644
--- a/include/linux/omap-gpmc-nand.h
+++ b/include/linux/omap-gpmc-nand.h
@@ -23,6 +23,12 @@ enum omap_gpmc_reg {
 	OMAP_GPMC_NAND_DATA,
 };
 
+enum omap_gpmc_bch_type {
+	OMAP_GPMC_BCH4,
+	OMAP_GPMC_BCH8,
+	OMAP_GPMC_BCH16,
+};
+
 #ifdef CONFIG_ARCH_OMAP2PLUS
 u32 omap_gpmc_read_reg(int cs, enum omap_gpmc_reg reg);
 void omap_gpmc_write_reg(int cs, enum omap_gpmc_reg reg, u32 val);
@@ -32,6 +38,11 @@ int omap_gpmc_prefetch_start(int cs, int fifo_th, bool dma,
 int omap_gpmc_prefetch_stop(int cs);
 u32 omap_gpmc_get_prefetch_count(void);
 u32 omap_gpmc_get_prefetch_fifo_count(void);
+void omap_gpmc_ecc_disable(void);
+void omap_gpmc_ecc_configure_enable(int cs, bool ecc16, u8 ecc_size0,
+				    u8 ecc_size1, bool use_bch,
+				    enum omap_gpmc_bch_type bch_type,
+				    u8 bch_sectors, u8 bch_wrap_mode);
 #else
 static inline u32 omap_gpmc_read_reg(int cs, enum omap_gpmc_reg reg)
 {
@@ -62,6 +73,20 @@ static inline u32 omap_gpmc_get_prefetch_fifo_count(void)
 {
 	return 0;
 }
+
+static inline void omap_gpmc_ecc_disable(void)
+{
+}
+
+static inline void omap_gpmc_ecc_configure_enable(int cs, bool ecc16,
+						  u8 ecc_size0, u8 ecc_size1,
+						  bool use_bch,
+						  enum omap_gpmc_bch_type bch_type,
+						  u8 bch_sectors,
+						  u8 bch_wrap_mode)
+{
+}
+
 #endif
 
 /* Prefetch/Write-post Engine */
-- 
1.8.3.2

