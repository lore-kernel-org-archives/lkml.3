Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255AbaEAJ5V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 05:57:21 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:65452 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755127AbaEAJ5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 05:57:18 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: computersforpeace@gmail.com, linux-mtd@lists.infradead.org,
        kernel@stlinux.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 05/47] mtd: nand: add ONFI NAND Timing Mode Specifications
Date: Thu,  1 May 2014 10:56:12 +0100
Message-Id: <1398938214-17847-6-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
References: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new structure, 'nand_timing_spec', to capture the A/C
timing characteristics of NAND devices.

Unfortunately, there is no universally accepted standard for defining
NAND timing parameters. Different datasheets list different sets of
parameters. The ONFI standard gets close, but support is missing from
some of the major NAND manufacturers (e.g. Samsung, Toshiba). Here we
have followed broadly the ONFI timing definitions.

We also provide specifications for the six standard ONFI timing modes,
in terms of the new nand_timing_spec structure. This will allow fully
automated configuration of the timing registers when using
ONFI-compliant NAND.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/nand/stm_nand_bch.c  | 167 +++++++++++++++++++++++++++++++++++++++
 drivers/mtd/nand/stm_nand_regs.h |  30 +++++++
 2 files changed, 197 insertions(+)

diff --git a/drivers/mtd/nand/stm_nand_bch.c b/drivers/mtd/nand/stm_nand_bch.c
index 09a7fdb..2d6a81f 100644
--- a/drivers/mtd/nand/stm_nand_bch.c
+++ b/drivers/mtd/nand/stm_nand_bch.c
@@ -54,6 +54,173 @@ struct nandi_controller {
 						/* 'page_buf'             */
 };
 
+/* ONFI define 6 timing modes */
+#define ST_NAND_ONFI_TIMING_MODES		6
+
+/*
+ * ONFI NAND Timing Mode Specifications
+ *
+ * Note, 'tR' field (maximum page read time) is extracted from the ONFI
+ * parameter page during device probe.
+ */
+const struct nand_timing_spec st_nand_onfi_timing_specs[] = {
+	/*
+	 * ONFI Timing Mode '0' (supported on all ONFI compliant devices)
+	 */
+	[0] = {
+		.tCLS	= 50,
+		.tCS	= 70,
+		.tALS	= 50,
+		.tDS	= 40,
+		.tWP	= 50,
+		.tCLH	= 20,
+		.tCH	= 20,
+		.tALH	= 20,
+		.tDH	= 20,
+		.tWB	= 200,
+		.tWH	= 30,
+		.tWC	= 100,
+		.tRP	= 50,
+		.tREH	= 30,
+		.tRC	= 100,
+		.tREA	= 40,
+		.tRHOH	= 0,
+		.tCEA	= 100,
+		.tCOH	= 0,
+		.tCHZ	= 100,
+	},
+
+	/*
+	 * ONFI Timing Mode '1'
+	 */
+	[1] = {
+		.tCLS	= 25,
+		.tCS	= 35,
+		.tALS	= 25,
+		.tDS	= 20,
+		.tWP	= 25,
+		.tCLH	= 10,
+		.tCH	= 10,
+		.tALH	= 10,
+		.tDH	= 10,
+		.tWB	= 100,
+		.tWH	= 15,
+		.tWC	= 45,
+		.tRP	= 25,
+		.tREH	= 15,
+		.tRC	= 50,
+		.tREA	= 30,
+		.tRHOH	= 15,
+		.tCEA	= 45,
+		.tCOH	= 15,
+		.tCHZ	= 50,
+	},
+
+	/*
+	 * ONFI Timing Mode '2'
+	 */
+	[2] = {
+		.tCLS	= 15,
+		.tCS	= 25,
+		.tALS	= 15,
+		.tDS	= 15,
+		.tWP	= 17,
+		.tCLH	= 10,
+		.tCH	= 10,
+		.tALH	= 10,
+		.tDH	= 5,
+		.tWB	= 100,
+		.tWH	= 15,
+		.tWC	= 35,
+		.tRP	= 17,
+		.tREH	= 16,
+		.tRC	= 35,
+		.tREA	= 25,
+		.tRHOH	= 15,
+		.tCEA	= 30,
+		.tCOH	= 15,
+		.tCHZ	= 50,
+	},
+
+	/*
+	 * ONFI Timing Mode '3'
+	 */
+	[3] = {
+		.tCLS	= 10,
+		.tCS	= 25,
+		.tALS	= 10,
+		.tDS	= 10,
+		.tWP	= 15,
+		.tCLH	= 5,
+		.tCH	= 5,
+		.tALH	= 5,
+		.tDH	= 5,
+		.tWB	= 100,
+		.tWH	= 10,
+		.tWC	= 30,
+		.tRP	= 15,
+		.tREH	= 10,
+		.tRC	= 30,
+		.tREA	= 20,
+		.tRHOH	= 15,
+		.tCEA	= 25,
+		.tCOH	= 15,
+		.tCHZ	= 50,
+	},
+
+	/*
+	 * ONFI Timing Mode '4' (EDO only)
+	 */
+	[4] = {
+		.tCLS	= 10,
+		.tCS	= 20,
+		.tALS	= 10,
+		.tDS	= 10,
+		.tWP	= 12,
+		.tCLH	= 5,
+		.tCH	= 5,
+		.tALH	= 5,
+		.tDH	= 5,
+		.tWB	= 100,
+		.tWH	= 10,
+		.tWC	= 25,
+		.tRP	= 12,
+		.tREH	= 10,
+		.tRC	= 25,
+		.tREA	= 20,
+		.tRHOH	= 15,
+		.tCEA	= 25,
+		.tCOH	= 15,
+		.tCHZ	= 30,
+	},
+
+	/*
+	 * ONFI Timing Mode '5' (EDO only)
+	 */
+	[5] = {
+		.tCLS	= 10,
+		.tCS	= 15,
+		.tALS	= 10,
+		.tDS	= 7,
+		.tWP	= 10,
+		.tCLH	= 5,
+		.tCH	= 5,
+		.tALH	= 5,
+		.tDH	= 5,
+		.tWB	= 100,
+		.tWH	= 7,
+		.tWC	= 20,
+		.tRP	= 10,
+		.tREH	= 7,
+		.tRC	= 20,
+		.tREA	= 16,
+		.tRHOH	= 15,
+		.tCEA	= 25,
+		.tCOH	= 15,
+		.tCHZ	= 30,
+	}
+};
+
 static int remap_named_resource(struct platform_device *pdev,
 				char *name,
 				void __iomem **io_ptr)
diff --git a/drivers/mtd/nand/stm_nand_regs.h b/drivers/mtd/nand/stm_nand_regs.h
index 2b0e069..e4951dc 100644
--- a/drivers/mtd/nand/stm_nand_regs.h
+++ b/drivers/mtd/nand/stm_nand_regs.h
@@ -299,4 +299,34 @@
 #define FLEX_ADDR_ADD8_VALID			(0x1 << 30)
 #define FLEX_ADDR_CSN				(0x1 << 31)
 
+/*
+ * NAND Device Timing Specification
+ *
+ * All values in nano seconds, except where specified.
+ */
+struct nand_timing_spec {
+	int	tR;		/* Max Page Read delay [us]*/
+	int	tCLS;		/* Min CLE setup time */
+	int	tCS;		/* Min CE setup time */
+	int	tALS;		/* Min ALE setup time */
+	int	tDS;		/* Min Data setup time */
+	int	tWP;		/* Min WE pulse width */
+	int	tCLH;		/* Min CLE hold time */
+	int	tCH;		/* Min CE hold time */
+	int	tALH;		/* Min ALE hold time */
+	int	tDH;		/* Min Data hold time */
+	int	tWB;		/* Max WE high to busy */
+	int	tWH;		/* Min WE hold time */
+	int	tWC;		/* Min Write cycle time */
+	int	tRP;		/* Min RE pulse width */
+	int	tREH;		/* Min RE high hold time */
+	int	tRC;		/* Min Read cycle time */
+	int	tREA;		/* Max Read access time */
+	int	tRHOH;		/* Min RE high to output hold */
+	int	tCEA;		/* Max CE access time */
+	int	tCOH;		/* Min CE high to output hold */
+	int	tCHZ;		/* Max CE high to output high Z */
+	int	tCSD;		/* Min CE high to ALE/CLE don't care */
+};
+
 #endif /* STM_NANDC_REGS_H */
-- 
1.8.3.2

