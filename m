Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370AbaITQcD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 12:32:03 -0400
Received: from mail-bl2on0114.outbound.protection.outlook.com ([65.55.169.114]:40194
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756137AbaITQb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 12:31:59 -0400
X-WSS-ID: 0NC7KL2-08-00N-02
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
        Mark Rutland <Mark.Rutland@arm.com>
Subject: [V8 1/2] irqchip: gic: Add support for multiple MSI for ARM64
Date: Sat, 20 Sep 2014 09:31:37 -0700
Message-ID: <1411230698-8081-2-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411230698-8081-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1411230698-8081-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(33646002)(36756003)(105586002)(77982003)(4396001)(229853001)(106466001)(90102001)(74502003)(80022003)(77156001)(81342003)(46102003)(47776003)(74662003)(77096002)(81542003)(76482002)(85306004)(95666004)(50466002)(48376002)(107046002)(50986999)(97736003)(92566001)(76176999)(21056001)(44976005)(2201001)(92726001)(53416004)(86362001)(85852003)(31966008)(86152002)(68736004)(83322001)(19580405001)(19580395003)(84676001)(62966002)(89996001)(50226001)(64706001)(104166001)(79102003)(20776003)(101416001)(87286001)(102836001)(99396002)(83072002)(87936001)(2004002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0201MB1078;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0201MB1078;
X-Forefront-PRVS: 0340850FCD
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

This patch implelments the ARM64 version of arch_setup_msi_irqs(),
which does not return 1 for when PCI_CAP_ID_MSI and nvec > 1.

Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Acked-by: Marc Zyngier <Marc.Zyngier@arm.com>
Cc: Mark Rutland <Mark.Rutland@arm.com>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>
Cc: Will Deacon <Will.Deacon@arm.com>
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

