Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433Ab3HBRii (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 13:38:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:10958 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754196Ab3HBRgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 13:36:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,802,1367996400"; 
   d="scan'208";a="375273127"
From: Jon Mason <jon.mason@intel.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 08/15] NTB: Enable 32bit Support
Date: Fri,  2 Aug 2013 10:35:37 -0700
Message-Id: <1375464944-27914-9-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375464944-27914-1-git-send-email-jon.mason@intel.com>
References: <1375464944-27914-1-git-send-email-jon.mason@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct the issues on NTB that prevented it from working on x86_32 and
modify the Kconfig to allow it to be permitted to be used in that
environment as well.

Signed-off-by: Jon Mason <jon.mason@intel.com>
---
 drivers/ntb/Kconfig  |    2 +-
 drivers/ntb/ntb_hw.c |    4 ++--
 drivers/ntb/ntb_hw.h |   17 ++++++++++++++++-
 3 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/ntb/Kconfig b/drivers/ntb/Kconfig
index 37ee649..f69df793 100644
--- a/drivers/ntb/Kconfig
+++ b/drivers/ntb/Kconfig
@@ -1,7 +1,7 @@
 config NTB
        tristate "Intel Non-Transparent Bridge support"
        depends on PCI
-       depends on X86_64
+       depends on X86
        help
         The PCI-E Non-transparent bridge hardware is a point-to-point PCI-E bus
         connecting 2 systems.  When configured, writes to the device's PCI
diff --git a/drivers/ntb/ntb_hw.c b/drivers/ntb/ntb_hw.c
index fc6b19d..1d8e551 100644
--- a/drivers/ntb/ntb_hw.c
+++ b/drivers/ntb/ntb_hw.c
@@ -376,7 +376,7 @@ void __iomem *ntb_get_mw_vbase(struct ntb_device *ndev, unsigned int mw)
  *
  * RETURNS: the size of the memory window or zero on error
  */
-resource_size_t ntb_get_mw_size(struct ntb_device *ndev, unsigned int mw)
+u64 ntb_get_mw_size(struct ntb_device *ndev, unsigned int mw)
 {
 	if (mw >= ntb_max_mw(ndev))
 		return 0;
@@ -1247,7 +1247,7 @@ static int ntb_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		    ioremap_wc(pci_resource_start(pdev, MW_TO_BAR(i)),
 			       ndev->mw[i].bar_sz);
 		dev_info(&pdev->dev, "MW %d size %llu\n", i,
-			 pci_resource_len(pdev, MW_TO_BAR(i)));
+			 (unsigned long long) ndev->mw[i].bar_sz);
 		if (!ndev->mw[i].vbase) {
 			dev_warn(&pdev->dev, "Cannot remap BAR %d\n",
 				 MW_TO_BAR(i));
diff --git a/drivers/ntb/ntb_hw.h b/drivers/ntb/ntb_hw.h
index 591d4ff..b03de80 100644
--- a/drivers/ntb/ntb_hw.h
+++ b/drivers/ntb/ntb_hw.h
@@ -62,6 +62,21 @@
 
 #define msix_table_size(control)	((control & PCI_MSIX_FLAGS_QSIZE)+1)
 
+#ifndef readq
+static inline u64 readq(void __iomem *addr)
+{
+	return readl(addr) | (((u64) readl(addr + 4)) << 32LL);
+}
+#endif
+
+#ifndef writeq
+static inline void writeq(u64 val, void __iomem *addr)
+{
+	writel(((u32) (val)), (addr));
+	writel(((u32) (val >> 32)), (addr + 4));
+}
+#endif
+
 #define NTB_BAR_MMIO		0
 #define NTB_BAR_23		2
 #define NTB_BAR_45		4
@@ -226,7 +241,7 @@ int ntb_read_local_spad(struct ntb_device *ndev, unsigned int idx, u32 *val);
 int ntb_write_remote_spad(struct ntb_device *ndev, unsigned int idx, u32 val);
 int ntb_read_remote_spad(struct ntb_device *ndev, unsigned int idx, u32 *val);
 void __iomem *ntb_get_mw_vbase(struct ntb_device *ndev, unsigned int mw);
-resource_size_t ntb_get_mw_size(struct ntb_device *ndev, unsigned int mw);
+u64 ntb_get_mw_size(struct ntb_device *ndev, unsigned int mw);
 void ntb_ring_sdb(struct ntb_device *ndev, unsigned int idx);
 void *ntb_find_transport(struct pci_dev *pdev);
 
-- 
1.7.9.5

