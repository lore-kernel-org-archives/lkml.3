Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533AbbAONNT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 08:13:19 -0500
Received: from nivc-ms1.auriga.com ([80.240.102.146]:17939 "EHLO
	nivc-ms1.auriga.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683AbbAONNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 08:13:17 -0500
From: Aleksey Makarov <aleksey.makarov@auriga.com>
To: <linux-mips@linux-mips.org>
CC: <linux-kernel@vger.kernel.org>, David Daney <david.daney@cavium.com>,
        Aleksey Makarov <aleksey.makarov@auriga.com>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH v3 10/15] MIPS: OCTEON: Update octeon-model.h code for new SoCs.
Date: Thu, 15 Jan 2015 16:11:14 +0300
Message-ID: <1421327487-28679-11-git-send-email-aleksey.makarov@auriga.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1421327487-28679-1-git-send-email-aleksey.makarov@auriga.com>
References: <1421327487-28679-1-git-send-email-aleksey.makarov@auriga.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [80.240.102.213]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

Add coverage for OCTEON III models.

Signed-off-by: David Daney <david.daney@cavium.com>
Signed-off-by: Aleksey Makarov <aleksey.makarov@auriga.com>
---
 arch/mips/cavium-octeon/dma-octeon.c               |   4 +-
 .../cavium-octeon/executive/cvmx-helper-board.c    |   2 +-
 arch/mips/cavium-octeon/octeon-irq.c               |   2 +-
 arch/mips/cavium-octeon/setup.c                    |   2 +-
 arch/mips/include/asm/octeon/octeon-model.h        | 107 ++++++++++++++++-----
 5 files changed, 90 insertions(+), 27 deletions(-)

diff --git a/arch/mips/cavium-octeon/dma-octeon.c b/arch/mips/cavium-octeon/dma-octeon.c
index 3778655..7d89878 100644
--- a/arch/mips/cavium-octeon/dma-octeon.c
+++ b/arch/mips/cavium-octeon/dma-octeon.c
@@ -276,7 +276,7 @@ void __init plat_swiotlb_setup(void)
 			continue;
 
 		/* These addresses map low for PCI. */
-		if (e->addr > 0x410000000ull && !OCTEON_IS_MODEL(OCTEON_CN6XXX))
+		if (e->addr > 0x410000000ull && !OCTEON_IS_OCTEON2())
 			continue;
 
 		addr_size += e->size;
@@ -308,7 +308,7 @@ void __init plat_swiotlb_setup(void)
 #endif
 #ifdef CONFIG_USB_OCTEON_OHCI
 	/* OCTEON II ohci is only 32-bit. */
-	if (OCTEON_IS_MODEL(OCTEON_CN6XXX) && max_addr >= 0x100000000ul)
+	if (OCTEON_IS_OCTEON2() && max_addr >= 0x100000000ul)
 		swiotlbsize = 64 * (1<<20);
 #endif
 	swiotlb_nslabs = swiotlbsize >> IO_TLB_SHIFT;
diff --git a/arch/mips/cavium-octeon/executive/cvmx-helper-board.c b/arch/mips/cavium-octeon/executive/cvmx-helper-board.c
index 5dfef84..9eb0fee 100644
--- a/arch/mips/cavium-octeon/executive/cvmx-helper-board.c
+++ b/arch/mips/cavium-octeon/executive/cvmx-helper-board.c
@@ -767,7 +767,7 @@ enum cvmx_helper_board_usb_clock_types __cvmx_helper_board_usb_get_clock_type(vo
 		break;
 	}
 	/* Most boards except NIC10e use a 12MHz crystal */
-	if (OCTEON_IS_MODEL(OCTEON_FAM_2))
+	if (OCTEON_IS_OCTEON2())
 		return USB_CLOCK_TYPE_CRYSTAL_12;
 	return USB_CLOCK_TYPE_REF_48;
 }
diff --git a/arch/mips/cavium-octeon/octeon-irq.c b/arch/mips/cavium-octeon/octeon-irq.c
index 2bc4aa9..01bb01c 100644
--- a/arch/mips/cavium-octeon/octeon-irq.c
+++ b/arch/mips/cavium-octeon/octeon-irq.c
@@ -1210,7 +1210,7 @@ static void __init octeon_irq_init_ciu(void)
 	if (OCTEON_IS_MODEL(OCTEON_CN58XX_PASS2_X) ||
 	    OCTEON_IS_MODEL(OCTEON_CN56XX_PASS2_X) ||
 	    OCTEON_IS_MODEL(OCTEON_CN52XX_PASS2_X) ||
-	    OCTEON_IS_MODEL(OCTEON_CN6XXX)) {
+	    OCTEON_IS_OCTEON2() || OCTEON_IS_OCTEON3()) {
 		chip = &octeon_irq_chip_ciu_v2;
 		chip_mbox = &octeon_irq_chip_ciu_mbox_v2;
 		chip_wd = &octeon_irq_chip_ciu_wd_v2;
diff --git a/arch/mips/cavium-octeon/setup.c b/arch/mips/cavium-octeon/setup.c
index 7ff3def..45e17a1 100644
--- a/arch/mips/cavium-octeon/setup.c
+++ b/arch/mips/cavium-octeon/setup.c
@@ -659,7 +659,7 @@ void __init prom_init(void)
 	sysinfo->dfa_ref_clock_hz = octeon_bootinfo->dfa_ref_clock_hz;
 	sysinfo->bootloader_config_flags = octeon_bootinfo->config_flags;
 
-	if (OCTEON_IS_MODEL(OCTEON_CN6XXX)) {
+	if (OCTEON_IS_OCTEON2() || OCTEON_IS_OCTEON3()) {
 		/* I/O clock runs at a different rate than the CPU. */
 		union cvmx_mio_rst_boot rst_boot;
 		rst_boot.u64 = cvmx_read_csr(CVMX_MIO_RST_BOOT);
diff --git a/arch/mips/include/asm/octeon/octeon-model.h b/arch/mips/include/asm/octeon/octeon-model.h
index e8a1c2f..92b377e 100644
--- a/arch/mips/include/asm/octeon/octeon-model.h
+++ b/arch/mips/include/asm/octeon/octeon-model.h
@@ -45,6 +45,7 @@
  */
 
 #define OCTEON_FAMILY_MASK	0x00ffff00
+#define OCTEON_PRID_MASK	0x00ffffff
 
 /* Flag bits in top byte */
 /* Ignores revision in model checks */
@@ -63,11 +64,52 @@
 #define OM_MATCH_6XXX_FAMILY_MODELS	0x40000000
 /* Match all cnf7XXX Octeon models. */
 #define OM_MATCH_F7XXX_FAMILY_MODELS	0x80000000
+/* Match all cn7XXX Octeon models. */
+#define OM_MATCH_7XXX_FAMILY_MODELS     0x10000000
+#define OM_MATCH_FAMILY_MODELS		(OM_MATCH_5XXX_FAMILY_MODELS |	\
+					 OM_MATCH_6XXX_FAMILY_MODELS |	\
+					 OM_MATCH_F7XXX_FAMILY_MODELS | \
+					 OM_MATCH_7XXX_FAMILY_MODELS)
+/*
+ * CN7XXX models with new revision encoding
+ */
+
+#define OCTEON_CN73XX_PASS1_0	0x000d9700
+#define OCTEON_CN73XX		(OCTEON_CN73XX_PASS1_0 | OM_IGNORE_REVISION)
+#define OCTEON_CN73XX_PASS1_X	(OCTEON_CN73XX_PASS1_0 | \
+				 OM_IGNORE_MINOR_REVISION)
+
+#define OCTEON_CN70XX_PASS1_0	0x000d9600
+#define OCTEON_CN70XX_PASS1_1	0x000d9601
+#define OCTEON_CN70XX_PASS1_2	0x000d9602
+
+#define OCTEON_CN70XX_PASS2_0	0x000d9608
+
+#define OCTEON_CN70XX		(OCTEON_CN70XX_PASS1_0 | OM_IGNORE_REVISION)
+#define OCTEON_CN70XX_PASS1_X	(OCTEON_CN70XX_PASS1_0 | \
+				 OM_IGNORE_MINOR_REVISION)
+#define OCTEON_CN70XX_PASS2_X	(OCTEON_CN70XX_PASS2_0 | \
+				 OM_IGNORE_MINOR_REVISION)
+
+#define OCTEON_CN71XX		OCTEON_CN70XX
+
+#define OCTEON_CN78XX_PASS1_0	0x000d9500
+#define OCTEON_CN78XX_PASS1_1	0x000d9501
+#define OCTEON_CN78XX_PASS2_0	0x000d9508
+
+#define OCTEON_CN78XX		(OCTEON_CN78XX_PASS1_0 | OM_IGNORE_REVISION)
+#define OCTEON_CN78XX_PASS1_X	(OCTEON_CN78XX_PASS1_0 | \
+				 OM_IGNORE_MINOR_REVISION)
+#define OCTEON_CN78XX_PASS2_X	(OCTEON_CN78XX_PASS2_0 | \
+				 OM_IGNORE_MINOR_REVISION)
+
+#define OCTEON_CN76XX		(0x000d9540 | OM_CHECK_SUBMODEL)
 
 /*
  * CNF7XXX models with new revision encoding
  */
 #define OCTEON_CNF71XX_PASS1_0	0x000d9400
+#define OCTEON_CNF71XX_PASS1_1  0x000d9401
 
 #define OCTEON_CNF71XX		(OCTEON_CNF71XX_PASS1_0 | OM_IGNORE_REVISION)
 #define OCTEON_CNF71XX_PASS1_X	(OCTEON_CNF71XX_PASS1_0 | OM_IGNORE_MINOR_REVISION)
@@ -79,6 +121,8 @@
 #define OCTEON_CN68XX_PASS1_1	0x000d9101
 #define OCTEON_CN68XX_PASS1_2	0x000d9102
 #define OCTEON_CN68XX_PASS2_0	0x000d9108
+#define OCTEON_CN68XX_PASS2_1   0x000d9109
+#define OCTEON_CN68XX_PASS2_2   0x000d910a
 
 #define OCTEON_CN68XX		(OCTEON_CN68XX_PASS2_0 | OM_IGNORE_REVISION)
 #define OCTEON_CN68XX_PASS1_X	(OCTEON_CN68XX_PASS1_0 | OM_IGNORE_MINOR_REVISION)
@@ -104,11 +148,18 @@
 #define OCTEON_CN63XX_PASS1_X	(OCTEON_CN63XX_PASS1_0 | OM_IGNORE_MINOR_REVISION)
 #define OCTEON_CN63XX_PASS2_X	(OCTEON_CN63XX_PASS2_0 | OM_IGNORE_MINOR_REVISION)
 
+/* CN62XX is same as CN63XX with 1 MB cache */
+#define OCTEON_CN62XX           OCTEON_CN63XX
+
 #define OCTEON_CN61XX_PASS1_0	0x000d9300
+#define OCTEON_CN61XX_PASS1_1   0x000d9301
 
 #define OCTEON_CN61XX		(OCTEON_CN61XX_PASS1_0 | OM_IGNORE_REVISION)
 #define OCTEON_CN61XX_PASS1_X	(OCTEON_CN61XX_PASS1_0 | OM_IGNORE_MINOR_REVISION)
 
+/* CN60XX is same as CN61XX with 512 KB cache */
+#define OCTEON_CN60XX           OCTEON_CN61XX
+
 /*
  * CN5XXX models with new revision encoding
  */
@@ -120,7 +171,7 @@
 #define OCTEON_CN58XX_PASS2_2	0x000d030a
 #define OCTEON_CN58XX_PASS2_3	0x000d030b
 
-#define OCTEON_CN58XX		(OCTEON_CN58XX_PASS1_0 | OM_IGNORE_REVISION)
+#define OCTEON_CN58XX		(OCTEON_CN58XX_PASS2_0 | OM_IGNORE_REVISION)
 #define OCTEON_CN58XX_PASS1_X	(OCTEON_CN58XX_PASS1_0 | OM_IGNORE_MINOR_REVISION)
 #define OCTEON_CN58XX_PASS2_X	(OCTEON_CN58XX_PASS2_0 | OM_IGNORE_MINOR_REVISION)
 #define OCTEON_CN58XX_PASS1	OCTEON_CN58XX_PASS1_X
@@ -217,12 +268,10 @@
 #define OCTEON_CN3XXX		(OCTEON_CN58XX_PASS1_0 | OM_MATCH_PREVIOUS_MODELS | OM_IGNORE_REVISION)
 #define OCTEON_CN5XXX		(OCTEON_CN58XX_PASS1_0 | OM_MATCH_5XXX_FAMILY_MODELS)
 #define OCTEON_CN6XXX		(OCTEON_CN63XX_PASS1_0 | OM_MATCH_6XXX_FAMILY_MODELS)
-
-/* These are used to cover entire families of OCTEON processors */
-#define OCTEON_FAM_1		(OCTEON_CN3XXX)
-#define OCTEON_FAM_PLUS		(OCTEON_CN5XXX)
-#define OCTEON_FAM_1_PLUS	(OCTEON_FAM_PLUS | OM_MATCH_PREVIOUS_MODELS)
-#define OCTEON_FAM_2		(OCTEON_CN6XXX)
+#define OCTEON_CNF7XXX		(OCTEON_CNF71XX_PASS1_0 | \
+				 OM_MATCH_F7XXX_FAMILY_MODELS)
+#define OCTEON_CN7XXX		(OCTEON_CN78XX_PASS1_0 | \
+				 OM_MATCH_7XXX_FAMILY_MODELS)
 
 /* The revision byte (low byte) has two different encodings.
  * CN3XXX:
@@ -232,7 +281,7 @@
  *     <4>:   alternate package
  *     <3:0>: revision
  *
- * CN5XXX:
+ * CN5XXX and older models:
  *
  *     bits
  *     <7>:   reserved (0)
@@ -251,17 +300,21 @@
 /* CN5XXX and later use different layout of bits in the revision ID field */
 #define OCTEON_58XX_FAMILY_MASK	     OCTEON_38XX_FAMILY_MASK
 #define OCTEON_58XX_FAMILY_REV_MASK  0x00ffff3f
-#define OCTEON_58XX_MODEL_MASK	     0x00ffffc0
+#define OCTEON_58XX_MODEL_MASK	     0x00ffff40
 #define OCTEON_58XX_MODEL_REV_MASK   (OCTEON_58XX_FAMILY_REV_MASK | OCTEON_58XX_MODEL_MASK)
-#define OCTEON_58XX_MODEL_MINOR_REV_MASK (OCTEON_58XX_MODEL_REV_MASK & 0x00fffff8)
+#define OCTEON_58XX_MODEL_MINOR_REV_MASK (OCTEON_58XX_MODEL_REV_MASK & 0x00ffff38)
 #define OCTEON_5XXX_MODEL_MASK	     0x00ff0fc0
 
-/* forward declarations */
 static inline uint32_t cvmx_get_proc_id(void) __attribute__ ((pure));
 static inline uint64_t cvmx_read_csr(uint64_t csr_addr);
 
 #define __OCTEON_MATCH_MASK__(x, y, z) (((x) & (z)) == ((y) & (z)))
 
+/*
+ * __OCTEON_IS_MODEL_COMPILE__(arg_model, chip_model)
+ * returns true if chip_model is identical or belong to the OCTEON
+ * model group specified in arg_model.
+ */
 /* NOTE: This for internal use only! */
 #define __OCTEON_IS_MODEL_COMPILE__(arg_model, chip_model)		\
 ((((arg_model & OCTEON_38XX_FAMILY_MASK) < OCTEON_CN58XX_PASS1_0)  && ( \
@@ -286,11 +339,18 @@ static inline uint64_t cvmx_read_csr(uint64_t csr_addr);
 		((((arg_model) & (OM_FLAG_MASK)) == OM_IGNORE_REVISION) \
 			&& __OCTEON_MATCH_MASK__((chip_model), (arg_model), OCTEON_58XX_FAMILY_MASK)) || \
 		((((arg_model) & (OM_FLAG_MASK)) == OM_CHECK_SUBMODEL)	\
-			&& __OCTEON_MATCH_MASK__((chip_model), (arg_model), OCTEON_58XX_MODEL_REV_MASK)) || \
+			&& __OCTEON_MATCH_MASK__((chip_model), (arg_model), OCTEON_58XX_MODEL_MASK)) || \
 		((((arg_model) & (OM_MATCH_5XXX_FAMILY_MODELS)) == OM_MATCH_5XXX_FAMILY_MODELS) \
-			&& ((chip_model) >= OCTEON_CN58XX_PASS1_0) && ((chip_model) < OCTEON_CN63XX_PASS1_0)) || \
+			&& ((chip_model & OCTEON_PRID_MASK) >= OCTEON_CN58XX_PASS1_0) \
+			&& ((chip_model & OCTEON_PRID_MASK) < OCTEON_CN63XX_PASS1_0)) || \
 		((((arg_model) & (OM_MATCH_6XXX_FAMILY_MODELS)) == OM_MATCH_6XXX_FAMILY_MODELS) \
-			&& ((chip_model) >= OCTEON_CN63XX_PASS1_0)) ||	\
+			&& ((chip_model & OCTEON_PRID_MASK) >= OCTEON_CN63XX_PASS1_0) \
+			&& ((chip_model & OCTEON_PRID_MASK) < OCTEON_CNF71XX_PASS1_0)) || \
+		((((arg_model) & (OM_MATCH_F7XXX_FAMILY_MODELS)) == OM_MATCH_F7XXX_FAMILY_MODELS) \
+			&& ((chip_model & OCTEON_PRID_MASK) >= OCTEON_CNF71XX_PASS1_0) \
+			&& ((chip_model & OCTEON_PRID_MASK) < OCTEON_CN78XX_PASS1_0)) || \
+		((((arg_model) & (OM_MATCH_7XXX_FAMILY_MODELS)) == OM_MATCH_7XXX_FAMILY_MODELS) \
+			&& ((chip_model & OCTEON_PRID_MASK) >= OCTEON_CN78XX_PASS1_0)) || \
 		((((arg_model) & (OM_MATCH_PREVIOUS_MODELS)) == OM_MATCH_PREVIOUS_MODELS) \
 			&& (((chip_model) & OCTEON_58XX_MODEL_MASK) < ((arg_model) & OCTEON_58XX_MODEL_MASK))) \
 		)))
@@ -300,14 +360,6 @@ static inline int __octeon_is_model_runtime__(uint32_t model)
 {
 	uint32_t cpuid = cvmx_get_proc_id();
 
-	/*
-	 * Check for special case of mismarked 3005 samples. We only
-	 * need to check if the sub model isn't being ignored
-	 */
-	if ((model & OM_CHECK_SUBMODEL) == OM_CHECK_SUBMODEL) {
-		if (cpuid == OCTEON_CN3010_PASS1 && (cvmx_read_csr(0x80011800800007B8ull) & (1ull << 34)))
-			cpuid |= 0x10;
-	}
 	return __OCTEON_IS_MODEL_COMPILE__(model, cpuid);
 }
 
@@ -326,10 +378,21 @@ static inline int __octeon_is_model_runtime__(uint32_t model)
 #define OCTEON_IS_COMMON_BINARY() 1
 #undef OCTEON_MODEL
 
+#define OCTEON_IS_OCTEON1()	OCTEON_IS_MODEL(OCTEON_CN3XXX)
+#define OCTEON_IS_OCTEONPLUS()	OCTEON_IS_MODEL(OCTEON_CN5XXX)
+#define OCTEON_IS_OCTEON2()						\
+	(OCTEON_IS_MODEL(OCTEON_CN6XXX) || OCTEON_IS_MODEL(OCTEON_CNF71XX))
+
+#define OCTEON_IS_OCTEON3()	OCTEON_IS_MODEL(OCTEON_CN7XXX)
+
+#define OCTEON_IS_OCTEON1PLUS()	(OCTEON_IS_OCTEON1() || OCTEON_IS_OCTEONPLUS())
+
 const char *__init octeon_model_get_string(uint32_t chip_id);
 
 /*
  * Return the octeon family, i.e., ProcessorID of the PrID register.
+ *
+ * @return the octeon family on success, ((unint32_t)-1) on error.
  */
 static inline uint32_t cvmx_get_octeon_family(void)
 {
-- 
2.2.2

