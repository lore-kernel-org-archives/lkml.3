Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915AbaA2Oh4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 09:37:56 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:60959 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbaA2Oel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 09:34:41 -0500
From: Boris BREZILLON <b.brezillon.dev@gmail.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: Boris BREZILLON <b.brezillon.dev@gmail.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
        dev@linux-sunxi.org
Subject: [RFC PATCH v2 05/14] mtd: nand: add ONFI timing mode to nand_timings converter
Date: Wed, 29 Jan 2014 15:34:15 +0100
Message-Id: <1391006064-28890-6-git-send-email-b.brezillon.dev@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391006064-28890-1-git-send-email-b.brezillon.dev@gmail.com>
References: <1391006064-28890-1-git-send-email-b.brezillon.dev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a converter to retrieve NAND timings from an ONFI NAND timing mode.
This only support SDR NAND timings for now.

Signed-off-by: Boris BREZILLON <b.brezillon.dev@gmail.com>
---
 drivers/mtd/nand/Makefile       |    2 +-
 drivers/mtd/nand/nand_timings.c |  248 +++++++++++++++++++++++++++++++++++++++
 include/linux/mtd/nand.h        |    4 +
 3 files changed, 253 insertions(+), 1 deletion(-)
 create mode 100644 drivers/mtd/nand/nand_timings.c

diff --git a/drivers/mtd/nand/Makefile b/drivers/mtd/nand/Makefile
index 542b568..bbea7a6 100644
--- a/drivers/mtd/nand/Makefile
+++ b/drivers/mtd/nand/Makefile
@@ -2,7 +2,7 @@
 # linux/drivers/nand/Makefile
 #
 
-obj-$(CONFIG_MTD_NAND)			+= nand.o
+obj-$(CONFIG_MTD_NAND)			+= nand.o nand_timings.o
 obj-$(CONFIG_MTD_NAND_ECC)		+= nand_ecc.o
 obj-$(CONFIG_MTD_NAND_BCH)		+= nand_bch.o
 obj-$(CONFIG_MTD_NAND_IDS)		+= nand_ids.o
diff --git a/drivers/mtd/nand/nand_timings.c b/drivers/mtd/nand/nand_timings.c
new file mode 100644
index 0000000..f66fe95
--- /dev/null
+++ b/drivers/mtd/nand/nand_timings.c
@@ -0,0 +1,248 @@
+/*
+ *  Copyright (C) 2014 Boris BREZILLON <b.brezillon.dev@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+#include <linux/mtd/nand.h>
+
+static const struct nand_sdr_timings onfi_sdr_timings[] = {
+	/* Mode 0 */
+	{
+		.tADL_min = 200000,
+		.tALH_min = 20000,
+		.tALS_min = 50000,
+		.tAR_min = 25000,
+		.tCEA_max = 100000,
+		.tCEH_min = 20000,
+		.tCH_min = 20000,
+		.tCHZ_max = 100000,
+		.tCLH_min = 20000,
+		.tCLR_min = 20000,
+		.tCLS_min = 50000,
+		.tCOH_min = 0,
+		.tCS_min = 70000,
+		.tDH_min = 20000,
+		.tDS_min = 40000,
+		.tFEAT_max = 1000000,
+		.tIR_min = 10000,
+		.tITC_max = 1000000,
+		.tRC_min = 100000,
+		.tREA_max = 40000,
+		.tREH_min = 30000,
+		.tRHOH_min = 0,
+		.tRHW_min = 200000,
+		.tRHZ_max = 200000,
+		.tRLOH_min = 0,
+		.tRP_min = 50000,
+		.tRST_max = 250000000000,
+		.tWB_max = 200000,
+		.tRR_min = 40000,
+		.tWC_min = 100000,
+		.tWH_min = 30000,
+		.tWHR_min = 120000,
+		.tWP_min = 50000,
+		.tWW_min = 100000,
+	},
+	/* Mode 1 */
+	{
+		.tADL_min = 100000,
+		.tALH_min = 10000,
+		.tALS_min = 25000,
+		.tAR_min = 10000,
+		.tCEA_max = 45000,
+		.tCEH_min = 20000,
+		.tCH_min = 10000,
+		.tCHZ_max = 50000,
+		.tCLH_min = 10000,
+		.tCLR_min = 10000,
+		.tCLS_min = 25000,
+		.tCOH_min = 15000,
+		.tCS_min = 35000,
+		.tDH_min = 10000,
+		.tDS_min = 20000,
+		.tFEAT_max = 1000000,
+		.tIR_min = 0,
+		.tITC_max = 1000000,
+		.tRC_min = 50000,
+		.tREA_max = 30000,
+		.tREH_min = 15000,
+		.tRHOH_min = 15000,
+		.tRHW_min = 100000,
+		.tRHZ_max = 100000,
+		.tRLOH_min = 0,
+		.tRP_min = 25000,
+		.tRR_min = 20000,
+		.tRST_max = 500000000,
+		.tWB_max = 100000,
+		.tWC_min = 45000,
+		.tWH_min = 15000,
+		.tWHR_min = 80000,
+		.tWP_min = 25000,
+		.tWW_min = 100000,
+	},
+	/* Mode 2 */
+	{
+		.tADL_min = 100000,
+		.tALH_min = 10000,
+		.tALS_min = 15000,
+		.tAR_min = 10000,
+		.tCEA_max = 30000,
+		.tCEH_min = 20000,
+		.tCH_min = 10000,
+		.tCHZ_max = 50000,
+		.tCLH_min = 10000,
+		.tCLR_min = 10000,
+		.tCLS_min = 15000,
+		.tCOH_min = 15000,
+		.tCS_min = 25000,
+		.tDH_min = 5000,
+		.tDS_min = 15000,
+		.tFEAT_max = 1000000,
+		.tIR_min = 0,
+		.tITC_max = 1000000,
+		.tRC_min = 35000,
+		.tREA_max = 25000,
+		.tREH_min = 15000,
+		.tRHOH_min = 15000,
+		.tRHW_min = 100000,
+		.tRHZ_max = 100000,
+		.tRLOH_min = 0,
+		.tRR_min = 20000,
+		.tRST_max = 500000000,
+		.tWB_max = 100000,
+		.tRP_min = 17000,
+		.tWC_min = 35000,
+		.tWH_min = 15000,
+		.tWHR_min = 80000,
+		.tWP_min = 17000,
+		.tWW_min = 100000,
+	},
+	/* Mode 3 */
+	{
+		.tADL_min = 100000,
+		.tALH_min = 5000,
+		.tALS_min = 10000,
+		.tAR_min = 10000,
+		.tCEA_max = 25000,
+		.tCEH_min = 20000,
+		.tCH_min = 5000,
+		.tCHZ_max = 50000,
+		.tCLH_min = 5000,
+		.tCLR_min = 10000,
+		.tCLS_min = 10000,
+		.tCOH_min = 15000,
+		.tCS_min = 25000,
+		.tDH_min = 5000,
+		.tDS_min = 10000,
+		.tFEAT_max = 1000000,
+		.tIR_min = 0,
+		.tITC_max = 1000000,
+		.tRC_min = 30000,
+		.tREA_max = 20000,
+		.tREH_min = 10000,
+		.tRHOH_min = 15000,
+		.tRHW_min = 100000,
+		.tRHZ_max = 100000,
+		.tRLOH_min = 0,
+		.tRP_min = 15000,
+		.tRR_min = 20000,
+		.tRST_max = 500000000,
+		.tWB_max = 100000,
+		.tWC_min = 30000,
+		.tWH_min = 10000,
+		.tWHR_min = 80000,
+		.tWP_min = 15000,
+		.tWW_min = 100000,
+	},
+	/* Mode 4 */
+	{
+		.tADL_min = 70000,
+		.tALH_min = 5000,
+		.tALS_min = 10000,
+		.tAR_min = 10000,
+		.tCEA_max = 25000,
+		.tCEH_min = 20000,
+		.tCH_min = 5000,
+		.tCHZ_max = 30000,
+		.tCLH_min = 5000,
+		.tCLR_min = 10000,
+		.tCLS_min = 10000,
+		.tCOH_min = 15000,
+		.tCS_min = 20000,
+		.tDH_min = 5000,
+		.tDS_min = 10000,
+		.tFEAT_max = 1000000,
+		.tIR_min = 0,
+		.tITC_max = 1000000,
+		.tRC_min = 25000,
+		.tREA_max = 20000,
+		.tREH_min = 10000,
+		.tRHOH_min = 15000,
+		.tRHW_min = 100000,
+		.tRHZ_max = 100000,
+		.tRLOH_min = 5000,
+		.tRP_min = 12000,
+		.tRR_min = 20000,
+		.tRST_max = 500000000,
+		.tWB_max = 100000,
+		.tWC_min = 25000,
+		.tWH_min = 10000,
+		.tWHR_min = 80000,
+		.tWP_min = 12000,
+		.tWW_min = 100000,
+	},
+	/* Mode 5 */
+	{
+		.tADL_min = 70000,
+		.tALH_min = 5000,
+		.tALS_min = 10000,
+		.tAR_min = 10000,
+		.tCEA_max = 25000,
+		.tCEH_min = 20000,
+		.tCH_min = 5000,
+		.tCHZ_max = 30000,
+		.tCLH_min = 5000,
+		.tCLR_min = 10000,
+		.tCLS_min = 10000,
+		.tCOH_min = 15000,
+		.tCS_min = 15000,
+		.tDH_min = 5000,
+		.tDS_min = 7000,
+		.tFEAT_max = 1000000,
+		.tIR_min = 0,
+		.tITC_max = 1000000,
+		.tRC_min = 20000,
+		.tREA_max = 16000,
+		.tREH_min = 7000,
+		.tRHOH_min = 15000,
+		.tRHW_min = 100000,
+		.tRHZ_max = 100000,
+		.tRLOH_min = 5000,
+		.tRP_min = 10000,
+		.tRR_min = 20000,
+		.tRST_max = 500000000,
+		.tWB_max = 100000,
+		.tWC_min = 20000,
+		.tWH_min = 7000,
+		.tWHR_min = 80000,
+		.tWP_min = 10000,
+		.tWW_min = 100000,
+	},
+};
+
+/**
+ * onfi_async_timing_mode_to_sdr_timings - [NAND Interface] Retrieve NAND
+ * timings according to the given ONFI timing mode
+ * @mode: ONFI timing mode
+ */
+const struct nand_sdr_timings *onfi_async_timing_mode_to_sdr_timings(int mode)
+{
+	if (mode < 0 || mode > ARRAY_SIZE(onfi_sdr_timings))
+		return ERR_PTR(-EINVAL);
+
+	return &onfi_sdr_timings[mode];
+}
+EXPORT_SYMBOL(onfi_async_timing_mode_to_sdr_timings);
diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
index 67f0829..c70e0a3 100644
--- a/include/linux/mtd/nand.h
+++ b/include/linux/mtd/nand.h
@@ -806,6 +806,7 @@ static inline bool nand_is_slc(struct nand_chip *chip)
 	return chip->bits_per_cell == 1;
 }
 
+
 /**
  * struct nand_sdr_timings - SDR NAND chip timings
  *
@@ -854,4 +855,7 @@ struct nand_sdr_timings {
 	u32 tWW_min;
 };
 
+/* convert an ONFI timing mode to its timing characteristics. */
+const struct nand_sdr_timings *onfi_async_timing_mode_to_sdr_timings(int mode);
+
 #endif /* __LINUX_MTD_NAND_H */
-- 
1.7.9.5

