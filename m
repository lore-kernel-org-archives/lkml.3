Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477AbaIRCPO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 22:15:14 -0400
Received: from mail-bn1bon0145.outbound.protection.outlook.com ([157.56.111.145]:53920
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756686AbaIRCPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 22:15:10 -0400
X-WSS-ID: 0NC2RL3-07-G1T-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <marc.zyngier@arm.com>, <mark.rutland@arm.com>, <jason@lakedaemon.net>
CC: <pawel.moll@arm.com>, <Catalin.Marinas@arm.com>, <Will.Deacon@arm.com>,
        <liviu.dudau@arm.com>, <tglx@linutronix.de>,
        <Harish.Kasiviswanathan@amd.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        "Suravee Suthikulpanit" <Suravee.Suthikulpanit@amd.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>
Subject: [PATCH 1/2 V7] irqchip: gic: Add support for multiple MSI for ARM64
Date: Wed, 17 Sep 2014 19:14:45 -0700
Message-ID: <1411006486-17513-2-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411006486-17513-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1411006486-17513-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(19580405001)(83322001)(21056001)(50986999)(83072002)(229853001)(19580395003)(107046002)(68736004)(89996001)(33646002)(76176999)(64706001)(95666004)(47776003)(20776003)(88136002)(104166001)(87936001)(92726001)(53416004)(2201001)(87286001)(92566001)(86152002)(44976005)(85306004)(99396002)(101416001)(77156001)(85852003)(62966002)(36756003)(84676001)(93916002)(106466001)(97736003)(4396001)(80022003)(74502003)(79102003)(77982003)(81542003)(81342003)(86362001)(46102003)(74662003)(77096002)(105586002)(50466002)(90102001)(31966008)(48376002)(50226001)(2004002);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB208;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB208;
X-Forefront-PRVS: 033857D0BD
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

This patch implelments the ARM64 version of arch_setup_msi_irqs(),
which does not return 1 for when PCI_CAP_ID_MSI and nvec > 1.

Cc: Mark Rutland <Mark.Rutland@arm.com>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>
Cc: Will Deacon <Will.Deacon@arm.com>
Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
---
 arch/arm64/kernel/Makefile |  1 +
 arch/arm64/kernel/msi.c    | 41 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+)
 create mode 100644 arch/arm64/kernel/msi.c

diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index df7ef87..a921c42 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -29,6 +29,7 @@ arm64-obj-$(CONFIG_ARM64_CPU_SUSPEND)	+= sleep.o suspend.o
 arm64-obj-$(CONFIG_JUMP_LABEL)		+= jump_label.o
 arm64-obj-$(CONFIG_KGDB)		+= kgdb.o
 arm64-obj-$(CONFIG_EFI)			+= efi.o efi-stub.o efi-entry.o
+arm64-obj-$(CONFIG_PCI_MSI)		+= msi.o
 
 obj-y					+= $(arm64-obj-y) vdso/
 obj-m					+= $(arm64-obj-m)
diff --git a/arch/arm64/kernel/msi.c b/arch/arm64/kernel/msi.c
new file mode 100644
index 0000000..a295862
--- /dev/null
+++ b/arch/arm64/kernel/msi.c
@@ -0,0 +1,41 @@
+/*
+ * ARM64 architectural MSI implemention
+ *
+ * Support for Message Signalelled Interrupts for systems that
+ * implement ARM Generic Interrupt Controller: GICv2m.
+ *
+ * Copyright (C) 2014 Advanced Micro Devices, Inc.
+ * Authors: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ */
+
+#include <linux/irq.h>
+#include <linux/msi.h>
+#include <linux/pci.h>
+
+/*
+ * ARM64 function for seting up MSI irqs.
+ * Based on driver/pci/msi.c: arch_setup_msi_irqs().
+ *
+ * Note:
+ * Current implementation assumes that all interrupt controller used in
+ * ARM64 architecture _MUST_ supports multi-MSI.
+ */
+int arm64_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
+{
+	struct msi_desc *entry;
+	int ret;
+
+	list_for_each_entry(entry, &dev->msi_list, list) {
+		ret = arch_setup_msi_irq(dev, entry);
+		if (ret < 0)
+			return ret;
+		if (ret > 0)
+			return -ENOSPC;
+	}
+
+	return 0;
+}
-- 
1.9.3

