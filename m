Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479Ab3DVFkg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 01:40:36 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:48269
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752630Ab3DVFke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 01:40:34 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzc8kzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
From: Varun Sethi <Varun.Sethi@freescale.com>
To: <joro@8bytes.org>, <iommu@lists.linux-foundation.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <galak@kernel.crashing.org>, <benh@kernel.crashing.org>,
        <stuart.yoder@freescale.com>, <scottwood@freescale.com>
CC: Varun Sethi <Varun.Sethi@freescale.com>
Subject: [PATCH 1/3 v2] iommu: Move swap_pci_ref function to pci.h.
Date: Mon, 22 Apr 2013 11:01:54 +0530
Message-ID: <1366608716-1704-1-git-send-email-Varun.Sethi@freescale.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

swap_pci_ref function is used by the IOMMU API code for swapping pci device
pointers, while determining the iommu group for the device.
Currently this function was being implemented for different IOMMU drivers.
This patch moves the function to a new file, drivers/iommu/pci.h so that the
implementation can be shared across various IOMMU drivers.

Signed-off-by: Varun Sethi <Varun.Sethi@freescale.com>
---
v2 changes:
- created a new file drivers/iommu/pci.h.

 drivers/iommu/amd_iommu.c   |    7 +------
 drivers/iommu/intel-iommu.c |    7 +------
 drivers/iommu/pci.h         |   29 +++++++++++++++++++++++++++++
 3 files changed, 31 insertions(+), 12 deletions(-)
 create mode 100644 drivers/iommu/pci.h

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index a7f6b04..2463464 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -46,6 +46,7 @@
 #include "amd_iommu_proto.h"
 #include "amd_iommu_types.h"
 #include "irq_remapping.h"
+#include "pci.h"
 
 #define CMD_SET_TYPE(cmd, t) ((cmd)->data[1] |= ((t) << 28))
 
@@ -263,12 +264,6 @@ static bool check_device(struct device *dev)
 	return true;
 }
 
-static void swap_pci_ref(struct pci_dev **from, struct pci_dev *to)
-{
-	pci_dev_put(*from);
-	*from = to;
-}
-
 static struct pci_bus *find_hosted_bus(struct pci_bus *bus)
 {
 	while (!bus->self) {
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 6e0b9ff..81ad7b8 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -47,6 +47,7 @@
 #include <asm/iommu.h>
 
 #include "irq_remapping.h"
+#include "pci.h"
 
 #define ROOT_SIZE		VTD_PAGE_SIZE
 #define CONTEXT_SIZE		VTD_PAGE_SIZE
@@ -4137,12 +4138,6 @@ static int intel_iommu_domain_has_cap(struct iommu_domain *domain,
 	return 0;
 }
 
-static void swap_pci_ref(struct pci_dev **from, struct pci_dev *to)
-{
-	pci_dev_put(*from);
-	*from = to;
-}
-
 #define REQ_ACS_FLAGS	(PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF)
 
 static int intel_iommu_add_device(struct device *dev)
diff --git a/drivers/iommu/pci.h b/drivers/iommu/pci.h
new file mode 100644
index 0000000..d460646
--- /dev/null
+++ b/drivers/iommu/pci.h
@@ -0,0 +1,29 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ *
+ * Copyright (C) 2013 Red Hat, Inc.
+ * Copyright (C) 2013 Freescale Semiconductor, Inc.
+ *
+ */
+#ifndef __PCI_H
+#define __PCI_H
+
+/* Helper function for swapping pci device reference */
+static inline void swap_pci_ref(struct pci_dev **from, struct pci_dev *to)
+{
+	pci_dev_put(*from);
+	*from = to;
+}
+
+#endif  /* __PCI_H */
-- 
1.7.4.1


