Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932106AbaDYJT7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 05:19:59 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:48788 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932067AbaDYJTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 05:19:54 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>, <linux-ia64@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, <sparclinux@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, <x86@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH 03/13] PCI: Use new pci_is_bridge() to simplify code
Date: Fri, 25 Apr 2014 17:18:25 +0800
Message-ID: <1398417515-8740-4-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
In-Reply-To: <1398417515-8740-1-git-send-email-wangyijing@huawei.com>
References: <1398417515-8740-1-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we can use new pci_is_bridge() helper function
to simplify code.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/pci/pci-acpi.c  |    8 +-------
 drivers/pci/probe.c     |    3 +--
 drivers/pci/setup-bus.c |    4 +---
 3 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/pci/pci-acpi.c b/drivers/pci/pci-acpi.c
index f49abef..ca4927b 100644
--- a/drivers/pci/pci-acpi.c
+++ b/drivers/pci/pci-acpi.c
@@ -309,13 +309,7 @@ static struct acpi_device *acpi_pci_find_companion(struct device *dev)
 	bool check_children;
 	u64 addr;
 
-	/*
-	 * pci_is_bridge() is not suitable here, because pci_dev->subordinate
-	 * is set only after acpi_pci_find_device() has been called for the
-	 * given device.
-	 */
-	check_children = pci_dev->hdr_type == PCI_HEADER_TYPE_BRIDGE
-			|| pci_dev->hdr_type == PCI_HEADER_TYPE_CARDBUS;
+	check_children = pci_is_bridge(pci_dev);
 	/* Please ref to ACPI spec for the syntax of _ADR */
 	addr = (PCI_SLOT(pci_dev->devfn) << 16) | PCI_FUNC(pci_dev->devfn);
 	return acpi_find_child_device(ACPI_COMPANION(dev->parent), addr,
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index ef09f5f..f831dd8 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1670,8 +1670,7 @@ unsigned int pci_scan_child_bus(struct pci_bus *bus)
 
 	for (pass=0; pass < 2; pass++)
 		list_for_each_entry(dev, &bus->devices, bus_list) {
-			if (dev->hdr_type == PCI_HEADER_TYPE_BRIDGE ||
-			    dev->hdr_type == PCI_HEADER_TYPE_CARDBUS)
+			if (pci_is_bridge(dev))
 				max = pci_scan_bridge(bus, dev, max, pass);
 		}
 
diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 138bdd6..e399d00 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -1629,9 +1629,7 @@ void pci_assign_unassigned_bus_resources(struct pci_bus *bus)
 
 	down_read(&pci_bus_sem);
 	list_for_each_entry(dev, &bus->devices, bus_list)
-		if (dev->hdr_type == PCI_HEADER_TYPE_BRIDGE ||
-		    dev->hdr_type == PCI_HEADER_TYPE_CARDBUS)
-			if (dev->subordinate)
+		if (pci_is_bridge(dev) && pci_has_subordinate(dev))
 				__pci_bus_size_bridges(dev->subordinate,
 							 &add_list);
 	up_read(&pci_bus_sem);
-- 
1.7.1


