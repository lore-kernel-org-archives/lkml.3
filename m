Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410AbaJWEbx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 00:31:53 -0400
Received: from mail-bn1bon0137.outbound.protection.outlook.com ([157.56.111.137]:19616
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750833AbaJWEbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 00:31:51 -0400
From: Chenhui Zhao <chenhui.zhao@freescale.com>
To: <linux-kernel@vger.kernel.org>, <kernel@pengutronix.de>,
        <linux-arm-kernel@lists.infradead.org>
CC: <leoli@freescale.com>, <Jason.Jin@freescale.com>
Subject: [PATCH v2 1/2] pm: add FSM configuration for deep sleep
Date: Thu, 23 Oct 2014 12:16:12 +0800
Message-ID: <1414037773-7735-1-git-send-email-chenhui.zhao@freescale.com>
X-Mailer: git-send-email 1.7.3
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(84676001)(21056001)(50986999)(87286001)(85852003)(87936001)(89996001)(88136002)(85306004)(68736004)(99396003)(36756003)(120916001)(77156001)(97736003)(575784001)(2201001)(80022003)(76482002)(93916002)(102836001)(26826002)(86362001)(92726001)(92566001)(46102003)(31966008)(106466001)(105606002)(64706001)(4396001)(50226001)(20776003)(47776003)(19580405001)(104016003)(50466002)(48376002)(6806004)(44976005)(19580395003)(33646002)(62966002)(95666004)(104166001)(107046002)(229853001)(2004002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR03MB393;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB393;
X-Forefront-PRVS: 0373D94D15
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=chenhui.zhao@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For some Freescale's SoCs which support deep sleep, such as T1040,
LS1021, software will start a Finite State Machine (FSM) to control
the hardware precedure to enter deep sleep and return from it.

This patch configures parameters of the FSM preparing for deep sleep.

Signed-off-by: Chenhui Zhao <chenhui.zhao@freescale.com>
---
Changes for v2:
 * use iowrite32be()

 drivers/platform/Kconfig         |    1 +
 drivers/platform/Makefile        |    1 +
 drivers/platform/fsl/Kconfig     |   10 ++
 drivers/platform/fsl/Makefile    |    5 +
 drivers/platform/fsl/sleep_fsm.c |  269 ++++++++++++++++++++++++++++++++++++++
 drivers/platform/fsl/sleep_fsm.h |  106 +++++++++++++++
 6 files changed, 392 insertions(+), 0 deletions(-)
 create mode 100644 drivers/platform/fsl/Kconfig
 create mode 100644 drivers/platform/fsl/Makefile
 create mode 100644 drivers/platform/fsl/sleep_fsm.c
 create mode 100644 drivers/platform/fsl/sleep_fsm.h

diff --git a/drivers/platform/Kconfig b/drivers/platform/Kconfig
index 69616ae..54ada25 100644
--- a/drivers/platform/Kconfig
+++ b/drivers/platform/Kconfig
@@ -5,3 +5,4 @@ if GOLDFISH
 source "drivers/platform/goldfish/Kconfig"
 endif
 
+source "drivers/platform/fsl/Kconfig"
diff --git a/drivers/platform/Makefile b/drivers/platform/Makefile
index 8a44a4c..d0cce95 100644
--- a/drivers/platform/Makefile
+++ b/drivers/platform/Makefile
@@ -5,3 +5,4 @@
 obj-$(CONFIG_X86)		+= x86/
 obj-$(CONFIG_OLPC)		+= olpc/
 obj-$(CONFIG_GOLDFISH)		+= goldfish/
+obj-$(CONFIG_FSL_SOC)		+= fsl/
diff --git a/drivers/platform/fsl/Kconfig b/drivers/platform/fsl/Kconfig
new file mode 100644
index 0000000..72ed053
--- /dev/null
+++ b/drivers/platform/fsl/Kconfig
@@ -0,0 +1,10 @@
+#
+# Freescale Specific Power Management Drivers
+#
+
+config FSL_SLEEP_FSM
+	bool
+	help
+	  This driver configures a hardware FSM (Finite State Machine) for deep sleep.
+	  The FSM is used to finish clean-ups at the last stage of system entering deep
+	  sleep, and also wakes up system when a wake up event happens.
diff --git a/drivers/platform/fsl/Makefile b/drivers/platform/fsl/Makefile
new file mode 100644
index 0000000..d99ca0e
--- /dev/null
+++ b/drivers/platform/fsl/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile for linux/drivers/platform/fsl
+# Freescale Specific Power Management Drivers
+#
+obj-$(CONFIG_FSL_SLEEP_FSM)	+= sleep_fsm.o
diff --git a/drivers/platform/fsl/sleep_fsm.c b/drivers/platform/fsl/sleep_fsm.c
new file mode 100644
index 0000000..32616ad
--- /dev/null
+++ b/drivers/platform/fsl/sleep_fsm.c
@@ -0,0 +1,269 @@
+/*
+ * Freescale deep sleep FSM (finite-state machine) configuration
+ *
+ * Copyright 2014 Freescale Semiconductor Inc.
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/kernel.h>
+#include <linux/io.h>
+#include <linux/types.h>
+
+#include "sleep_fsm.h"
+/*
+ * These values are from chip's reference manual. For example,
+ * the values for T1040 can be found in "8.4.3.8 Programming
+ * supporting deep sleep mode" of Chapter 8 "Run Control and
+ * Power Management (RCPM)".
+ * The default value can be applied to T104x, LS1021.
+ */
+struct fsm_reg_vals epu_default_val[] = {
+	/* EPGCR (Event Processor Global Control Register) */
+	{EPGCR, 0},
+	/* EPECR (Event Processor Event Control Registers) */
+	{EPECR0 + EPECR_STRIDE * 0, 0},
+	{EPECR0 + EPECR_STRIDE * 1, 0},
+	{EPECR0 + EPECR_STRIDE * 2, 0xF0004004},
+	{EPECR0 + EPECR_STRIDE * 3, 0x80000084},
+	{EPECR0 + EPECR_STRIDE * 4, 0x20000084},
+	{EPECR0 + EPECR_STRIDE * 5, 0x08000004},
+	{EPECR0 + EPECR_STRIDE * 6, 0x80000084},
+	{EPECR0 + EPECR_STRIDE * 7, 0x80000084},
+	{EPECR0 + EPECR_STRIDE * 8, 0x60000084},
+	{EPECR0 + EPECR_STRIDE * 9, 0x08000084},
+	{EPECR0 + EPECR_STRIDE * 10, 0x42000084},
+	{EPECR0 + EPECR_STRIDE * 11, 0x90000084},
+	{EPECR0 + EPECR_STRIDE * 12, 0x80000084},
+	{EPECR0 + EPECR_STRIDE * 13, 0x08000084},
+	{EPECR0 + EPECR_STRIDE * 14, 0x02000084},
+	{EPECR0 + EPECR_STRIDE * 15, 0x00000004},
+	/*
+	 * EPEVTCR (Event Processor EVT Pin Control Registers)
+	 * SCU8 triger EVT2, and SCU11 triger EVT9
+	 */
+	{EPEVTCR0 + EPEVTCR_STRIDE * 0, 0},
+	{EPEVTCR0 + EPEVTCR_STRIDE * 1, 0},
+	{EPEVTCR0 + EPEVTCR_STRIDE * 2, 0x80000001},
+	{EPEVTCR0 + EPEVTCR_STRIDE * 3, 0},
+	{EPEVTCR0 + EPEVTCR_STRIDE * 4, 0},
+	{EPEVTCR0 + EPEVTCR_STRIDE * 5, 0},
+	{EPEVTCR0 + EPEVTCR_STRIDE * 6, 0},
+	{EPEVTCR0 + EPEVTCR_STRIDE * 7, 0},
+	{EPEVTCR0 + EPEVTCR_STRIDE * 8, 0},
+	{EPEVTCR0 + EPEVTCR_STRIDE * 9, 0xB0000001},
+	/* EPCMPR (Event Processor Counter Compare Registers) */
+	{EPCMPR0 + EPCMPR_STRIDE * 0, 0},
+	{EPCMPR0 + EPCMPR_STRIDE * 1, 0},
+	{EPCMPR0 + EPCMPR_STRIDE * 2, 0x000000FF},
+	{EPCMPR0 + EPCMPR_STRIDE * 3, 0},
+	{EPCMPR0 + EPCMPR_STRIDE * 4, 0x000000FF},
+	{EPCMPR0 + EPCMPR_STRIDE * 5, 0x00000020},
+	{EPCMPR0 + EPCMPR_STRIDE * 6, 0},
+	{EPCMPR0 + EPCMPR_STRIDE * 7, 0},
+	{EPCMPR0 + EPCMPR_STRIDE * 8, 0x000000FF},
+	{EPCMPR0 + EPCMPR_STRIDE * 9, 0x000000FF},
+	{EPCMPR0 + EPCMPR_STRIDE * 10, 0x000000FF},
+	{EPCMPR0 + EPCMPR_STRIDE * 11, 0x000000FF},
+	{EPCMPR0 + EPCMPR_STRIDE * 12, 0x000000FF},
+	{EPCMPR0 + EPCMPR_STRIDE * 13, 0},
+	{EPCMPR0 + EPCMPR_STRIDE * 14, 0x000000FF},
+	{EPCMPR0 + EPCMPR_STRIDE * 15, 0x000000FF},
+	/* EPCCR (Event Processor Counter Control Registers) */
+	{EPCCR0 + EPCCR_STRIDE * 0, 0},
+	{EPCCR0 + EPCCR_STRIDE * 1, 0},
+	{EPCCR0 + EPCCR_STRIDE * 2, 0x92840000},
+	{EPCCR0 + EPCCR_STRIDE * 3, 0},
+	{EPCCR0 + EPCCR_STRIDE * 4, 0x92840000},
+	{EPCCR0 + EPCCR_STRIDE * 5, 0x92840000},
+	{EPCCR0 + EPCCR_STRIDE * 6, 0},
+	{EPCCR0 + EPCCR_STRIDE * 7, 0},
+	{EPCCR0 + EPCCR_STRIDE * 8, 0x92840000},
+	{EPCCR0 + EPCCR_STRIDE * 9, 0x92840000},
+	{EPCCR0 + EPCCR_STRIDE * 10, 0x92840000},
+	{EPCCR0 + EPCCR_STRIDE * 11, 0x92840000},
+	{EPCCR0 + EPCCR_STRIDE * 12, 0x92840000},
+	{EPCCR0 + EPCCR_STRIDE * 13, 0},
+	{EPCCR0 + EPCCR_STRIDE * 14, 0x92840000},
+	{EPCCR0 + EPCCR_STRIDE * 15, 0x92840000},
+	/* EPSMCR (Event Processor SCU Mux Control Registers) */
+	{EPSMCR0 + EPSMCR_STRIDE * 0, 0},
+	{EPSMCR0 + EPSMCR_STRIDE * 1, 0},
+	{EPSMCR0 + EPSMCR_STRIDE * 2, 0x6C700000},
+	{EPSMCR0 + EPSMCR_STRIDE * 3, 0x2F000000},
+	{EPSMCR0 + EPSMCR_STRIDE * 4, 0x002F0000},
+	{EPSMCR0 + EPSMCR_STRIDE * 5, 0x00002E00},
+	{EPSMCR0 + EPSMCR_STRIDE * 6, 0x7C000000},
+	{EPSMCR0 + EPSMCR_STRIDE * 7, 0x30000000},
+	{EPSMCR0 + EPSMCR_STRIDE * 8, 0x64300000},
+	{EPSMCR0 + EPSMCR_STRIDE * 9, 0x00003000},
+	{EPSMCR0 + EPSMCR_STRIDE * 10, 0x65000030},
+	{EPSMCR0 + EPSMCR_STRIDE * 11, 0x31740000},
+	{EPSMCR0 + EPSMCR_STRIDE * 12, 0x7F000000},
+	{EPSMCR0 + EPSMCR_STRIDE * 13, 0x00003100},
+	{EPSMCR0 + EPSMCR_STRIDE * 14, 0x00000031},
+	{EPSMCR0 + EPSMCR_STRIDE * 15, 0x76000000},
+	/* EPACR (Event Processor Action Control Registers) */
+	{EPACR0 + EPACR_STRIDE * 0, 0},
+	{EPACR0 + EPACR_STRIDE * 1, 0},
+	{EPACR0 + EPACR_STRIDE * 2, 0},
+	{EPACR0 + EPACR_STRIDE * 3, 0x00000080},
+	{EPACR0 + EPACR_STRIDE * 4, 0},
+	{EPACR0 + EPACR_STRIDE * 5, 0x00000040},
+	{EPACR0 + EPACR_STRIDE * 6, 0},
+	{EPACR0 + EPACR_STRIDE * 7, 0},
+	{EPACR0 + EPACR_STRIDE * 8, 0},
+	{EPACR0 + EPACR_STRIDE * 9, 0x0000001C},
+	{EPACR0 + EPACR_STRIDE * 10, 0x00000020},
+	{EPACR0 + EPACR_STRIDE * 11, 0},
+	{EPACR0 + EPACR_STRIDE * 12, 0x00000003},
+	{EPACR0 + EPACR_STRIDE * 13, 0x06000000},
+	{EPACR0 + EPACR_STRIDE * 14, 0x04000000},
+	{EPACR0 + EPACR_STRIDE * 15, 0x02000000},
+	/* EPIMCR (Event Processor Input Mux Control Registers) */
+	{EPIMCR0 + EPIMCR_STRIDE * 0, 0},
+	{EPIMCR0 + EPIMCR_STRIDE * 1, 0},
+	{EPIMCR0 + EPIMCR_STRIDE * 2, 0},
+	{EPIMCR0 + EPIMCR_STRIDE * 3, 0},
+	{EPIMCR0 + EPIMCR_STRIDE * 4, 0x44000000},
+	{EPIMCR0 + EPIMCR_STRIDE * 5, 0x40000000},
+	{EPIMCR0 + EPIMCR_STRIDE * 6, 0},
+	{EPIMCR0 + EPIMCR_STRIDE * 7, 0},
+	{EPIMCR0 + EPIMCR_STRIDE * 8, 0},
+	{EPIMCR0 + EPIMCR_STRIDE * 9, 0},
+	{EPIMCR0 + EPIMCR_STRIDE * 10, 0},
+	{EPIMCR0 + EPIMCR_STRIDE * 11, 0},
+	{EPIMCR0 + EPIMCR_STRIDE * 12, 0x44000000},
+	{EPIMCR0 + EPIMCR_STRIDE * 13, 0},
+	{EPIMCR0 + EPIMCR_STRIDE * 14, 0},
+	{EPIMCR0 + EPIMCR_STRIDE * 15, 0},
+	{EPIMCR0 + EPIMCR_STRIDE * 16, 0x6A000000},
+	{EPIMCR0 + EPIMCR_STRIDE * 17, 0},
+	{EPIMCR0 + EPIMCR_STRIDE * 18, 0},
+	{EPIMCR0 + EPIMCR_STRIDE * 19, 0},
+	{EPIMCR0 + EPIMCR_STRIDE * 20, 0x48000000},
+	{EPIMCR0 + EPIMCR_STRIDE * 21, 0},
+	{EPIMCR0 + EPIMCR_STRIDE * 22, 0x6C000000},
+	{EPIMCR0 + EPIMCR_STRIDE * 23, 0},
+	{EPIMCR0 + EPIMCR_STRIDE * 24, 0},
+	{EPIMCR0 + EPIMCR_STRIDE * 25, 0},
+	{EPIMCR0 + EPIMCR_STRIDE * 26, 0},
+	{EPIMCR0 + EPIMCR_STRIDE * 27, 0},
+	{EPIMCR0 + EPIMCR_STRIDE * 28, 0x76000000},
+	{EPIMCR0 + EPIMCR_STRIDE * 29, 0},
+	{EPIMCR0 + EPIMCR_STRIDE * 30, 0},
+	{EPIMCR0 + EPIMCR_STRIDE * 31, 0x76000000},
+	/* EPXTRIGCR (Event Processor Crosstrigger Control Register) */
+	{EPXTRIGCR, 0x0000FFDF},
+	/* end */
+	{FSM_END_FLAG, 0},
+};
+
+struct fsm_reg_vals npc_default_val[] = {
+	/* NPC triggered Memory-Mapped Access Registers */
+	{NCR, 0x80000000},
+	{MCCR1, 0},
+	{MCSR1, 0},
+	{MMAR1LO, 0},
+	{MMAR1HI, 0},
+	{MMDR1, 0},
+	{MCSR2, 0},
+	{MMAR2LO, 0},
+	{MMAR2HI, 0},
+	{MMDR2, 0},
+	{MCSR3, 0x80000000},
+	{MMAR3LO, 0x000E2130},
+	{MMAR3HI, 0x00030000},
+	{MMDR3, 0x00020000},
+	/* end */
+	{FSM_END_FLAG, 0},
+};
+
+/**
+ * fsl_fsm_setup - Configure EPU's FSM registers
+ * @base: the base address of registers
+ * @val: Pointer to address-value pairs for FSM registers
+ */
+void fsl_fsm_setup(void __iomem *base, struct fsm_reg_vals *val)
+{
+	struct fsm_reg_vals *data = val;
+
+	BUG_ON(!base || !data);
+	while (data->offset != FSM_END_FLAG) {
+		iowrite32be(data->value, base + data->offset);
+		data++;
+	}
+}
+
+void fsl_epu_setup_default(void __iomem *epu_base)
+{
+	fsl_fsm_setup(epu_base, epu_default_val);
+}
+
+void fsl_npc_setup_default(void __iomem *npc_base)
+{
+	fsl_fsm_setup(npc_base, npc_default_val);
+}
+
+/**
+ * fsl_fsm_clean - Clear EPU's FSM registers
+ * @base: the base address of registers
+ * @val: Pointer to address-value pairs for FSM registers
+ */
+void fsl_fsm_clean(void __iomem *base, struct fsm_reg_vals *val)
+{
+	struct fsm_reg_vals *data = val;
+
+	BUG_ON(!base || !data);
+	while (data->offset != FSM_END_FLAG) {
+		iowrite32be(0, base + data->offset);
+		data++;
+	}
+}
+
+void fsl_epu_clean_default(void __iomem *epu_base)
+{
+	u32 offset;
+
+	/* follow the exact sequence to clear the registers */
+	/* Clear EPACRn */
+	for (offset = EPACR0; offset <= EPACR15; offset += EPACR_STRIDE)
+		iowrite32be(0, epu_base + offset);
+
+	/* Clear EPEVTCRn */
+	for (offset = EPEVTCR0; offset <= EPEVTCR9; offset += EPEVTCR_STRIDE)
+		iowrite32be(0, epu_base + offset);
+
+	/* Clear EPGCR */
+	iowrite32be(0, epu_base + EPGCR);
+
+	/* Clear EPSMCRn */
+	for (offset = EPSMCR0; offset <= EPSMCR15; offset += EPSMCR_STRIDE)
+		iowrite32be(0, epu_base + offset);
+
+	/* Clear EPCCRn */
+	for (offset = EPCCR0; offset <= EPCCR31; offset += EPCCR_STRIDE)
+		iowrite32be(0, epu_base + offset);
+
+	/* Clear EPCMPRn */
+	for (offset = EPCMPR0; offset <= EPCMPR31; offset += EPCMPR_STRIDE)
+		iowrite32be(0, epu_base + offset);
+
+	/* Clear EPCTRn */
+	for (offset = EPCTR0; offset <= EPCTR31; offset += EPCTR_STRIDE)
+		iowrite32be(0, epu_base + offset);
+
+	/* Clear EPIMCRn */
+	for (offset = EPIMCR0; offset <= EPIMCR31; offset += EPIMCR_STRIDE)
+		iowrite32be(0, epu_base + offset);
+
+	/* Clear EPXTRIGCRn */
+	iowrite32be(0, epu_base + EPXTRIGCR);
+
+	/* Clear EPECRn */
+	for (offset = EPECR0; offset <= EPECR15; offset += EPECR_STRIDE)
+		iowrite32be(0, epu_base + offset);
+}
diff --git a/drivers/platform/fsl/sleep_fsm.h b/drivers/platform/fsl/sleep_fsm.h
new file mode 100644
index 0000000..8fea8ec
--- /dev/null
+++ b/drivers/platform/fsl/sleep_fsm.h
@@ -0,0 +1,106 @@
+/*
+ * Freescale deep sleep FSM (finite-state machine) configuration
+ *
+ * Copyright 2014 Freescale Semiconductor Inc.
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+#ifndef _FSL_SLEEP_FSM_H
+#define _FSL_SLEEP_FSM_H
+
+#define FSL_STRIDE_4B	4
+#define FSL_STRIDE_8B	8
+
+/* End flag */
+#define FSM_END_FLAG		0xFFFFFFFFUL
+
+/* Block offsets */
+#define RCPM_BLOCK_OFFSET	0x00022000
+#define EPU_BLOCK_OFFSET	0x00000000
+#define NPC_BLOCK_OFFSET	0x00001000
+
+/* EPGCR (Event Processor Global Control Register) */
+#define EPGCR		0x000
+
+/* EPEVTCR0-9 (Event Processor EVT Pin Control Registers) */
+#define EPEVTCR0	0x050
+#define EPEVTCR9	0x074
+#define EPEVTCR_STRIDE	FSL_STRIDE_4B
+
+/* EPXTRIGCR (Event Processor Crosstrigger Control Register) */
+#define EPXTRIGCR	0x090
+
+/* EPIMCR0-31 (Event Processor Input Mux Control Registers) */
+#define EPIMCR0		0x100
+#define EPIMCR31	0x17C
+#define EPIMCR_STRIDE	FSL_STRIDE_4B
+
+/* EPSMCR0-15 (Event Processor SCU Mux Control Registers) */
+#define EPSMCR0		0x200
+#define EPSMCR15	0x278
+#define EPSMCR_STRIDE	FSL_STRIDE_8B
+
+/* EPECR0-15 (Event Processor Event Control Registers) */
+#define EPECR0		0x300
+#define EPECR15		0x33C
+#define EPECR_STRIDE	FSL_STRIDE_4B
+
+/* EPACR0-15 (Event Processor Action Control Registers) */
+#define EPACR0		0x400
+#define EPACR15		0x43C
+#define EPACR_STRIDE	FSL_STRIDE_4B
+
+/* EPCCRi0-15 (Event Processor Counter Control Registers) */
+#define EPCCR0		0x800
+#define EPCCR15		0x83C
+#define EPCCR31		0x87C
+#define EPCCR_STRIDE	FSL_STRIDE_4B
+
+/* EPCMPR0-15 (Event Processor Counter Compare Registers) */
+#define EPCMPR0		0x900
+#define EPCMPR15	0x93C
+#define EPCMPR31	0x97C
+#define EPCMPR_STRIDE	FSL_STRIDE_4B
+
+/* EPCTR0-31 (Event Processor Counter Register) */
+#define EPCTR0		0xA00
+#define EPCTR31		0xA7C
+#define EPCTR_STRIDE	FSL_STRIDE_4B
+
+/* NPC triggered Memory-Mapped Access Registers */
+#define NCR		0x000
+#define MCCR1		0x0CC
+#define MCSR1		0x0D0
+#define MMAR1LO		0x0D4
+#define MMAR1HI		0x0D8
+#define MMDR1		0x0DC
+#define MCSR2		0x0E0
+#define MMAR2LO		0x0E4
+#define MMAR2HI		0x0E8
+#define MMDR2		0x0EC
+#define MCSR3		0x0F0
+#define MMAR3LO		0x0F4
+#define MMAR3HI		0x0F8
+#define MMDR3		0x0FC
+
+/* RCPM Core State Action Control Register 0 */
+#define CSTTACR0	0xB00
+
+/* RCPM Core Group 1 Configuration Register 0 */
+#define CG1CR0		0x31C
+
+struct fsm_reg_vals {
+	u32 offset;
+	u32 value;
+};
+
+void fsl_fsm_setup(void __iomem *base, struct fsm_reg_vals *val);
+void fsl_epu_setup_default(void __iomem *epu_base);
+void fsl_npc_setup_default(void __iomem *npc_base);
+void fsl_fsm_clean(void __iomem *base, struct fsm_reg_vals *val);
+void fsl_epu_clean_default(void __iomem *epu_base);
+
+#endif /* _FSL_SLEEP_FSM_H */
-- 
1.7.3

