Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977Ab3K3Wle (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 17:41:34 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:51852 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab3K3Wks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 17:40:48 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Guo Chao <yan@linux.vnet.ibm.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v3 06/12] PCI: Only enable realloc auto when root bus has 64bit mmio
Date: Sat, 30 Nov 2013 14:40:32 -0800
Message-Id: <1385851238-21085-7-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1385851238-21085-1-git-send-email-yinghai@kernel.org>
References: <1385851238-21085-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joseph found
| commit b07f2ebc109b607789f648dedcff4b125f9afec6
| Date:   Thu Feb 23 19:23:32 2012 -0800
|
|    PCI: add a PCI resource reallocation config option

cause one system can not load driver for Intel x520 NIC's.

The root resource:
[    1.212470] PCI host bridge to bus 0000:20
[    1.212475] pci_bus 0000:20: root bus resource [bus 20-3e]
[    1.212479] pci_bus 0000:20: root bus resource [io  0xc000-0xdfff]
[    1.212483] pci_bus 0000:20: root bus resource [mem 0xfecc0000-0xfecfffff]
[    1.212487] pci_bus 0000:20: root bus resource [mem 0xe9400000-0xe97fffff]

and bios does not assign sriov, also have two function ROM bar point to same
position.
[    1.213197] pci 0000:22:00.0: [8086:10fb] type 00 class 0x020000
...
[    1.213240] pci 0000:22:00.0: reg 0x30: [mem 0xe9500000-0xe957ffff pref]
[    1.213303] pci 0000:22:00.0: reg 0x184: [mem 0x00000000-0x00003fff 64bit]
[    1.213317] pci 0000:22:00.0: reg 0x190: [mem 0x00000000-0x00003fff 64bit]
[    1.213366] pci 0000:22:00.1: [8086:10fb] type 00 class 0x020000
...
[    1.213408] pci 0000:22:00.1: reg 0x30: [mem 0xe9500000-0xe957ffff pref]
[    1.213468] pci 0000:22:00.1: reg 0x184: [mem 0x00000000-0x00003fff 64bit]
[    1.213481] pci 0000:22:00.1: reg 0x190: [mem 0x00000000-0x00003fff 64bit]
[    1.218527] pci 0000:20:03.0: PCI bridge to [bus 22]
[    1.218534] pci 0000:20:03.0:   bridge window [io  0xd000-0xdfff]
[    1.218537] pci 0000:20:03.0:   bridge window [mem 0xe9400000-0xe95fffff]
...
[    1.254103] pci 0000:22:00.1: address space collision: [mem 0xe9500000-0xe957ffff pref] conflicts with 0000:22:00.0 [mem 0xe9500000-0xe957ffff pref]
[    1.254111] pci 0000:23:00.1: address space collision: [mem 0xe9700000-0xe977ffff pref] conflicts with 0000:23:00.0 [mem 0xe9700000-0xe977ffff pref]

We don't need to enable realloc for this case, as we can not alter root bus mmio
range to get big one to hold two rom bar, and sriov under 4G.

Add checking if pci root bus have 4G above mmio res, and don't enable
realloc auto accordingly.

bug report at: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1245938

Reported-by: Joseph Salisbury <joseph.salisbury@canonical.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/setup-bus.c | 32 +++++++++++++++++++++++++++-----
 1 file changed, 27 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 219a410..f9e6efb 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -1432,17 +1432,39 @@ static int iov_resources_unassigned(struct pci_dev *dev, void *data)
 	return 0;
 }
 
+static bool pci_bus_mem_above_4g(struct pci_bus *bus)
+{
+	int i;
+	struct resource *res;
+
+	pci_bus_for_each_resource(bus, res, i) {
+		struct pci_bus_region region;
+
+		if (!res || !(res->flags & IORESOURCE_MEM))
+			continue;
+
+		__pcibios_resource_to_bus(bus, &region, res);
+		if (region.end > 0xffffffff)
+			return true;
+	}
+
+	return false;
+}
+
 static enum enable_type pci_realloc_detect(struct pci_bus *bus,
 			 enum enable_type enable_local)
 {
-	bool unassigned = false;
-
 	if (enable_local != undefined)
 		return enable_local;
 
-	pci_walk_bus(bus, iov_resources_unassigned, &unassigned);
-	if (unassigned)
-		return auto_enabled;
+	/* only enable auto when root bus does support 64bit mmio */
+	if (pci_bus_mem_above_4g(bus)) {
+		bool unassigned = false;
+
+		pci_walk_bus(bus, iov_resources_unassigned, &unassigned);
+		if (unassigned)
+			return auto_enabled;
+	}
 
 	return enable_local;
 }
-- 
1.8.1.4

