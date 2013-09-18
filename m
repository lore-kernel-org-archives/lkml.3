Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870Ab3IRGJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 02:09:21 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49732 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab3IRGJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 02:09:20 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
From: Takao Indoh <indou.takao@jp.fujitsu.com>
To: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        dwmw2@infradead.org, joro@8bytes.org
Cc: kexec@lists.infradead.org, alex.williamson@redhat.com, bhe@redhat.com
Subject: [PATCH v2] intel-iommu: Quiesce devices before disabling IOMMU
Date: Wed, 18 Sep 2013 15:09:01 +0900
Message-Id: <1379484541-4496-1-git-send-email-indou.takao@jp.fujitsu.com>
X-Mailer: git-send-email 1.7.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch quiesces devices before disabling IOMMU on boot to stop
ongoing DMA. In intel_iommu_init(), check context entries and if there
is entry whose present bit is set then reset corresponding device.

When IOMMU is already enabled on boot, it is disabled and new DMAR table
is created and then re-enabled in intel_iommu_init(). This causes DMAR
faults if there are in-flight DMAs.

This causes problem on kdump. Devices are working in first kernel, and
after switching to second kernel and initializing IOMMU, many DMAR
faults occur and it causes problems like driver error or PCI SERR, at
last kdump fails. This patch fixes this problem.

Changelog:
v2:
- Add CONTEXT_ENTRY_NR

v1:
https://lkml.org/lkml/2013/8/21/71

Signed-off-by: Takao Indoh <indou.takao@jp.fujitsu.com>
---
 drivers/iommu/intel-iommu.c |   56 ++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 55 insertions(+), 1 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index eec0d3e..d0e8aff 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -224,6 +224,7 @@ struct context_entry {
 	u64 lo;
 	u64 hi;
 };
+#define CONTEXT_ENTRY_NR (VTD_PAGE_SIZE/sizeof(struct context_entry))
 
 static inline bool context_present(struct context_entry *context)
 {
@@ -3663,6 +3664,56 @@ static struct notifier_block device_nb = {
 	.notifier_call = device_notifier,
 };
 
+/* Reset PCI devices if its entry exists in DMAR table */
+static void __init iommu_reset_devices(struct intel_iommu *iommu, u16 segment)
+{
+	u64 addr;
+	struct root_entry *root;
+	struct context_entry *context;
+	int bus, devfn;
+	struct pci_dev *dev;
+
+	addr = dmar_readq(iommu->reg + DMAR_RTADDR_REG);
+	if (!addr)
+		return;
+
+	/*
+	 *  In the case of kdump, ioremap is needed because root-entry table
+	 *  exists in first kernel's memory area which is not mapped in second
+	 *  kernel
+	 */
+	root = (struct root_entry *)ioremap(addr, PAGE_SIZE);
+	if (!root)
+		return;
+
+	for (bus = 0; bus < ROOT_ENTRY_NR; bus++) {
+		if (!root_present(&root[bus]))
+			continue;
+
+		context = (struct context_entry *)ioremap(
+			root[bus].val & VTD_PAGE_MASK, PAGE_SIZE);
+		if (!context)
+			continue;
+
+		for (devfn = 0; devfn < CONTEXT_ENTRY_NR; devfn++) {
+			if (!context_present(&context[devfn]))
+				continue;
+
+			dev = pci_get_domain_bus_and_slot(segment, bus, devfn);
+			if (!dev)
+				continue;
+
+			if (!pci_reset_bus(dev->bus)) /* go to next bus */
+				break;
+			else /* Try per-function reset */
+				pci_reset_function(dev);
+
+		}
+		iounmap(context);
+	}
+	iounmap(root);
+}
+
 int __init intel_iommu_init(void)
 {
 	int ret = 0;
@@ -3687,8 +3738,11 @@ int __init intel_iommu_init(void)
 			continue;
 
 		iommu = drhd->iommu;
-		if (iommu->gcmd & DMA_GCMD_TE)
+		if (iommu->gcmd & DMA_GCMD_TE) {
+			if (reset_devices)
+				iommu_reset_devices(iommu, drhd->segment);
 			iommu_disable_translation(iommu);
+		}
 	}
 
 	if (dmar_dev_scope_init() < 0) {
-- 
1.7.1


