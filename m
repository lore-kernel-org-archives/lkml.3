Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871AbaGKHzz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 03:55:55 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33549 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751457AbaGKHzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 03:55:54 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org
Cc: Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH 2/2] mtd: nand: add ONFI timing mode to nand_timings converter
Date: Fri, 11 Jul 2014 09:49:42 +0200
Message-Id: <1405064982-11456-3-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1405064982-11456-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1405064982-11456-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a converter to retrieve NAND timings from an ONFI NAND timing mode.
At the moment, only SDR NAND timings are supported.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 drivers/mtd/nand/Makefile       |   2 +-
 drivers/mtd/nand/nand_timings.c | 250 ++++++++++++++++++++++++++++++++++++++++
 include/linux/mtd/nand.h        |   3 +
 3 files changed, 254 insertions(+), 1 deletion(-)
 create mode 100644 drivers/mtd/nand/nand_timings.c

diff --git a/drivers/mtd/nand/Makefile b/drivers/mtd/nand/Makefile
index 542b568..a035e7c 100644
--- a/drivers/mtd/nand/Makefile
+++ b/drivers/mtd/nand/Makefile
@@ -50,4 +50,4 @@ obj-$(CONFIG_MTD_NAND_GPMI_NAND)	+= gpmi-nand/
 obj-$(CONFIG_MTD_NAND_XWAY)		+= xway_nand.o
 obj-$(CONFIG_MTD_NAND_BCM47XXNFLASH)	+= bcm47xxnflash/
 
-nand-objs := nand_base.o nand_bbt.o
+nand-objs := nand_base.o nand_bbt.o nand_timings.o
diff --git a/drivers/mtd/nand/nand_timings.c b/drivers/mtd/nand/nand_timings.c
new file mode 100644
index 0000000..f154780
--- /dev/null
+++ b/drivers/mtd/nand/nand_timings.c
@@ -0,0 +1,250 @@
+/*
+ *  Copyright (C) 2014 Free Electrons
+ *
+ *  Author: Boris BREZILLON <boris.brezillon@free-electrons.com>
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
+	if (mode < 0 || mode >= ARRAY_SIZE(onfi_sdr_timings))
+		return ERR_PTR(-EINVAL);
+
+	return &onfi_sdr_timings[mode];
+}
+EXPORT_SYMBOL(onfi_async_timing_mode_to_sdr_timings);
diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
index a3a45f2..2bd3254 100644
--- a/include/linux/mtd/nand.h
+++ b/include/linux/mtd/nand.h
@@ -996,4 +996,7 @@ struct nand_sdr_timings {
 	u32 tWP_min;
 	u32 tWW_min;
 };
+
+/* get timing characteristics from ONFI timing mode. */
+const struct nand_sdr_timings *onfi_async_timing_mode_to_sdr_timings(int mode);
 #endif /* __LINUX_MTD_NAND_H */
-- 
1.8.3.2

