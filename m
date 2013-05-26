Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab3EZP5u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 11:57:50 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:37250 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689Ab3EZP5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 11:57:46 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        linux-ia64@vger.kernel.org
Subject: [PATCH v3, part2 07/20] PCI, IA64: use hotplug-safe iterators to walk PCI buses
Date: Sun, 26 May 2013 23:53:04 +0800
Message-Id: <1369583597-3801-8-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369583597-3801-1-git-send-email-jiang.liu@huawei.com>
References: <1369583597-3801-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enhance IA64 architecture specific code to use hotplug-safe iterators
to walk PCI buses.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-ia64@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 arch/ia64/hp/common/sba_iommu.c   | 2 +-
 arch/ia64/sn/kernel/io_common.c   | 2 +-
 arch/ia64/sn/pci/tioca_provider.c | 3 ++-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/ia64/hp/common/sba_iommu.c b/arch/ia64/hp/common/sba_iommu.c
index bcda5b2..6faf241 100644
--- a/arch/ia64/hp/common/sba_iommu.c
+++ b/arch/ia64/hp/common/sba_iommu.c
@@ -2156,7 +2156,7 @@ sba_init(void)
 #ifdef CONFIG_PCI
 	{
 		struct pci_bus *b = NULL;
-		while ((b = pci_find_next_bus(b)) != NULL)
+		for_each_pci_root_bus(b)
 			sba_connect_bus(b);
 	}
 #endif
diff --git a/arch/ia64/sn/kernel/io_common.c b/arch/ia64/sn/kernel/io_common.c
index 11f2275..87d8d8f 100644
--- a/arch/ia64/sn/kernel/io_common.c
+++ b/arch/ia64/sn/kernel/io_common.c
@@ -530,7 +530,7 @@ sn_io_late_init(void)
 	 * info from the PROM).
 	 */
 	bus = NULL;
-	while ((bus = pci_find_next_bus(bus)) != NULL) {
+	for_each_pci_root_bus(bus) {
 		bussoft = SN_PCIBUS_BUSSOFT(bus);
 		nasid = NASID_GET(bussoft->bs_base);
 		cnode = nasid_to_cnodeid(nasid);
diff --git a/arch/ia64/sn/pci/tioca_provider.c b/arch/ia64/sn/pci/tioca_provider.c
index a70b11f..cd8c0fb 100644
--- a/arch/ia64/sn/pci/tioca_provider.c
+++ b/arch/ia64/sn/pci/tioca_provider.c
@@ -624,7 +624,7 @@ tioca_bus_fixup(struct pcibus_bussoft *prom_bussoft, struct pci_controller *cont
 	    nasid_to_cnodeid(tioca_common->ca_closest_nasid);
 	tioca_common->ca_kernel_private = (u64) tioca_kern;
 
-	bus = pci_find_bus(tioca_common->ca_common.bs_persist_segment,
+	bus = pci_get_bus(tioca_common->ca_common.bs_persist_segment,
 		tioca_common->ca_common.bs_persist_busnum);
 	BUG_ON(!bus);
 	tioca_kern->ca_devices = &bus->devices;
@@ -632,6 +632,7 @@ tioca_bus_fixup(struct pcibus_bussoft *prom_bussoft, struct pci_controller *cont
 	/* init GART */
 
 	if (tioca_gart_init(tioca_kern) < 0) {
+		pci_bus_put(bus);
 		kfree(tioca_kern);
 		kfree(tioca_common);
 		return NULL;
-- 
1.8.1.2

