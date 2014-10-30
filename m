Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980AbaJ3HcI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 03:32:08 -0400
Received: from mail-bl2on0129.outbound.protection.outlook.com ([65.55.169.129]:7915
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757385AbaJ3HcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 03:32:05 -0400
From: Zhao Qiang <B45475@freescale.com>
To: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <B07421@freescale.com>
CC: <R63061@freescale.com>, Zhao Qiang <B45475@freescale.com>
Subject: [PATCH v3 2/3] qe_common: add qe common functions into qe_common.c
Date: Thu, 30 Oct 2014 15:31:03 +0800
Message-ID: <1414654264-2596-2-git-send-email-B45475@freescale.com>
X-Mailer: git-send-email 2.1.0.27.g96db324
In-Reply-To: <1414654264-2596-1-git-send-email-B45475@freescale.com>
References: <1414654264-2596-1-git-send-email-B45475@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(40224003)(189002)(26826002)(120916001)(97736003)(102836001)(99396003)(31966008)(85306004)(229853001)(104166001)(95666004)(107046002)(64706001)(36756003)(50226001)(4396001)(47776003)(20776003)(106466001)(77156001)(105606002)(44976005)(19580405001)(6806004)(84676001)(80022003)(92566001)(2201001)(92726001)(50466002)(93916002)(46102003)(62966002)(48376002)(87286001)(76176999)(76482002)(68736004)(50986999)(104016003)(85852003)(89996001)(87936001)(21056001)(19580395003)(88136002)(2004002)(2101003)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0732;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0732;
X-Forefront-PRVS: 038002787A
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=qiang.zhao@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

qe need to call some common functions,
add a new file drivers/soc/fsl-qe/qe_common.c
for them.

Signed-off-by: Zhao Qiang <B45475@freescale.com>
---
 drivers/soc/fsl-qe/Makefile    |   2 +-
 drivers/soc/fsl-qe/qe_common.c | 185 +++++++++++++++++++++++++++++++++++++++++
 include/linux/fsl/qe.h         |  52 ++++++++++--
 3 files changed, 230 insertions(+), 9 deletions(-)
 create mode 100644 drivers/soc/fsl-qe/qe_common.c

diff --git a/drivers/soc/fsl-qe/Makefile b/drivers/soc/fsl-qe/Makefile
index f1855c1..77f6fd9 100644
--- a/drivers/soc/fsl-qe/Makefile
+++ b/drivers/soc/fsl-qe/Makefile
@@ -1,7 +1,7 @@
 #
 # Makefile for the linux ppc-specific parts of QE
 #
-obj-$(CONFIG_QUICC_ENGINE)+= qe.o qe_ic.o qe_io.o
+obj-$(CONFIG_QUICC_ENGINE)+= qe.o qe_ic.o qe_io.o qe_common.o
 
 obj-$(CONFIG_UCC)	+= ucc.o
 obj-$(CONFIG_UCC_SLOW)	+= ucc_slow.o
diff --git a/drivers/soc/fsl-qe/qe_common.c b/drivers/soc/fsl-qe/qe_common.c
new file mode 100644
index 0000000..c82ddcc
--- /dev/null
+++ b/drivers/soc/fsl-qe/qe_common.c
@@ -0,0 +1,185 @@
+/*
+ * Common QE code
+ *
+ * Author: Scott Wood <scottwood@freescale.com>
+ *
+ * Copyright 2007-2008,2010 Freescale Semiconductor, Inc.
+ *
+ * Some parts derived from commproc.c/cpm2_common.c, which is:
+ * Copyright (c) 1997 Dan error_act (dmalek@jlc.net)
+ * Copyright (c) 1999-2001 Dan Malek <dan@embeddedalley.com>
+ * Copyright (c) 2000 MontaVista Software, Inc (source@mvista.com)
+ * 2006 (c) MontaVista Software, Inc.
+ * Vitaly Bordug <vbordug@ru.mvista.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/init.h>
+#include <linux/of_device.h>
+#include <linux/spinlock.h>
+#include <linux/export.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/slab.h>
+
+#include <linux/io.h>
+#include <asm/rheap.h>
+#include <linux/fsl/qe.h>
+
+static spinlock_t qe_muram_lock;
+static rh_block_t qe_boot_muram_rh_block[16];
+static rh_info_t qe_muram_info;
+static u8 __iomem *muram_vbase;
+static phys_addr_t muram_pbase;
+
+/* Max address size we deal with */
+#define OF_MAX_ADDR_CELLS	4
+
+int qe_muram_init(void)
+{
+	struct device_node *np;
+	struct resource r;
+	u32 zero[OF_MAX_ADDR_CELLS] = {};
+	resource_size_t max = 0;
+	int i = 0;
+	int ret = 0;
+
+	if (muram_pbase)
+		return 0;
+
+	spin_lock_init(&qe_muram_lock);
+	/* initialize the info header */
+	rh_init(&qe_muram_info, 1,
+		sizeof(qe_boot_muram_rh_block) /
+		sizeof(qe_boot_muram_rh_block[0]),
+		qe_boot_muram_rh_block);
+
+	np = of_find_compatible_node(NULL, NULL, "fsl,qe-muram-data");
+	if (!np) {
+		/* try legacy bindings */
+		np = of_find_node_by_name(NULL, "data-only");
+		if (!np) {
+			pr_err("Cannot find CPM muram data node");
+			ret = -ENODEV;
+			goto out;
+		}
+	}
+
+	muram_pbase = of_translate_address(np, zero);
+	if (muram_pbase == (phys_addr_t)OF_BAD_ADDR) {
+		pr_err("Cannot translate zero through CPM muram node");
+		ret = -ENODEV;
+		goto out;
+	}
+
+	while (of_address_to_resource(np, i++, &r) == 0) {
+		if (r.end > max)
+			max = r.end;
+
+		rh_attach_region(&qe_muram_info, r.start - muram_pbase,
+				 resource_size(&r));
+	}
+
+	muram_vbase = ioremap(muram_pbase, max - muram_pbase + 1);
+	if (!muram_vbase) {
+		pr_err("Cannot map CPM muram");
+		ret = -ENOMEM;
+	}
+
+out:
+	of_node_put(np);
+	return ret;
+}
+
+/**
+ * qe_muram_alloc - allocate the requested size worth of multi-user ram
+ * @size: number of bytes to allocate
+ * @align: requested alignment, in bytes
+ *
+ * This function returns an offset into the muram area.
+ * Use qe_dpram_addr() to get the virtual address of the area.
+ * Use qe_muram_free() to free the allocation.
+ */
+unsigned long qe_muram_alloc(unsigned long size, unsigned long align)
+{
+	unsigned long start;
+	unsigned long flags;
+
+	spin_lock_irqsave(&qe_muram_lock, flags);
+	qe_muram_info.alignment = align;
+	start = rh_alloc(&qe_muram_info, size, "commproc");
+	memset(qe_muram_addr(start), 0, size);
+	spin_unlock_irqrestore(&qe_muram_lock, flags);
+
+	return start;
+}
+EXPORT_SYMBOL(qe_muram_alloc);
+
+/**
+ * qe_muram_free - free a chunk of multi-user ram
+ * @offset: The beginning of the chunk as returned by qe_muram_alloc().
+ */
+int qe_muram_free(unsigned long offset)
+{
+	int ret;
+	unsigned long flags;
+
+	spin_lock_irqsave(&qe_muram_lock, flags);
+	ret = rh_free(&qe_muram_info, offset);
+	spin_unlock_irqrestore(&qe_muram_lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL(qe_muram_free);
+
+/**
+ * qe_muram_alloc_fixed - reserve a specific region of multi-user ram
+ * @offset: the offset into the muram area to reserve
+ * @size: the number of bytes to reserve
+ *
+ * This function returns "start" on success, -ENOMEM on failure.
+ * Use qe_dpram_addr() to get the virtual address of the area.
+ * Use qe_muram_free() to free the allocation.
+ */
+unsigned long qe_muram_alloc_fixed(unsigned long offset, unsigned long size)
+{
+	unsigned long start;
+	unsigned long flags;
+
+	spin_lock_irqsave(&qe_muram_lock, flags);
+	qe_muram_info.alignment = 1;
+	start = rh_alloc_fixed(&qe_muram_info, offset, size, "commproc");
+	spin_unlock_irqrestore(&qe_muram_lock, flags);
+
+	return start;
+}
+EXPORT_SYMBOL(qe_muram_alloc_fixed);
+
+/**
+ * qe_muram_addr - turn a muram offset into a virtual address
+ * @offset: muram offset to convert
+ */
+void __iomem *qe_muram_addr(unsigned long offset)
+{
+	return muram_vbase + offset;
+}
+EXPORT_SYMBOL(qe_muram_addr);
+
+unsigned long qe_muram_offset(void __iomem *addr)
+{
+	return addr - (void __iomem *)muram_vbase;
+}
+EXPORT_SYMBOL(qe_muram_offset);
+
+/**
+ * qe_muram_dma - turn a muram virtual address into a DMA address
+ * @offset: virtual address from qe_muram_addr() to convert
+ */
+dma_addr_t qe_muram_dma(void __iomem *addr)
+{
+	return muram_pbase + ((u8 __iomem *)addr - muram_vbase);
+}
+EXPORT_SYMBOL(qe_muram_dma);
diff --git a/include/linux/fsl/qe.h b/include/linux/fsl/qe.h
index 1c9d626..8ac5a8c 100644
--- a/include/linux/fsl/qe.h
+++ b/include/linux/fsl/qe.h
@@ -19,7 +19,8 @@
 #include <linux/spinlock.h>
 #include <linux/errno.h>
 #include <linux/err.h>
-#include <asm/cpm.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
 #include <linux/fsl/immap_qe.h>
 
 #define QE_NUM_OF_SNUM	256	/* There are 256 serial number in QE */
@@ -186,13 +187,48 @@ static inline int qe_alive_during_sleep(void)
 #endif
 }
 
-/* we actually use cpm_muram implementation, define this for convenience */
-#define qe_muram_init cpm_muram_init
-#define qe_muram_alloc cpm_muram_alloc
-#define qe_muram_alloc_fixed cpm_muram_alloc_fixed
-#define qe_muram_free cpm_muram_free
-#define qe_muram_addr cpm_muram_addr
-#define qe_muram_offset cpm_muram_offset
+int qe_muram_init(void);
+
+#if defined(CONFIG_QUICC_ENGINE)
+unsigned long qe_muram_alloc(unsigned long size, unsigned long align);
+int qe_muram_free(unsigned long offset);
+unsigned long qe_muram_alloc_fixed(unsigned long offset, unsigned long size);
+void __iomem *qe_muram_addr(unsigned long offset);
+unsigned long qe_muram_offset(void __iomem *addr);
+dma_addr_t qe_muram_dma(void __iomem *addr);
+#else
+static inline unsigned long qe_muram_alloc(unsigned long size,
+					    unsigned long align)
+{
+	return -ENOSYS;
+}
+
+static inline int qe_muram_free(unsigned long offset)
+{
+	return -ENOSYS;
+}
+
+static inline unsigned long qe_muram_alloc_fixed(unsigned long offset,
+						  unsigned long size)
+{
+	return -ENOSYS;
+}
+
+static inline void __iomem *qe_muram_addr(unsigned long offset)
+{
+	return NULL;
+}
+
+static inline unsigned long qe_muram_offset(void __iomem *addr)
+{
+	return -ENOSYS;
+}
+
+static inline dma_addr_t qe_muram_dma(void __iomem *addr)
+{
+	return 0;
+}
+#endif /* defined(CONFIG_QUICC_ENGINE) */
 
 /* Structure that defines QE firmware binary files.
  *
-- 
2.1.0.27.g96db324

