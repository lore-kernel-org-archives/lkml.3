Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389AbaFSGgO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 02:36:14 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:15307 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbaFSGgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 02:36:13 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 18 Jun 2014 23:26:47 -0700
From: Vidya Sagar <vidyas@nvidia.com>
To: <linux@arm.linux.org.uk>, <bhelgaas@google.com>, <wangyijing@huawei.com>,
        <thierry.reding@gmail.com>, <jason@lakedaemon.net>,
        <will.deacon@arm.com>, <swarren@nvidia.com>, <kthota@nvidia.com>,
        <vidyas@nvidia.com>
CC: <sagar.tv@gmail.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v4] ARM: fix debug prints relevant to PCI devices
Date: Thu, 19 Jun 2014 12:06:00 +0530
Message-ID: <1403159760-32627-1-git-send-email-vidyas@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As per PCIe spec, fast back-to-back transactions feature
is not applicable to PCIe devices. Hence, do not print
that fast back-to-back trasactions are disabled when
there is a PCIe device found on the bus

Signed-off-by: Vidya Sagar <vidyas@nvidia.com>
---
v4:
* initialized 'has_pcie_dev' to 'false'

v3:
* removed KERN_INFO from pr_info() which was not removed by mistake in previous patch

v2:
* Modified has_pcie_dev type to bool and used pci_is_pcie() instead of pci_pcie_cap()
* replaced printk with pr_info

 arch/arm/kernel/bios32.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/bios32.c b/arch/arm/kernel/bios32.c
index 17a26c1..03c56ba 100644
--- a/arch/arm/kernel/bios32.c
+++ b/arch/arm/kernel/bios32.c
@@ -290,6 +290,7 @@ void pcibios_fixup_bus(struct pci_bus *bus)
 {
 	struct pci_dev *dev;
 	u16 features = PCI_COMMAND_SERR | PCI_COMMAND_PARITY | PCI_COMMAND_FAST_BACK;
+	bool has_pcie_dev = false;
 
 	/*
 	 * Walk the devices on this bus, working out what we can
@@ -298,6 +299,8 @@ void pcibios_fixup_bus(struct pci_bus *bus)
 	list_for_each_entry(dev, &bus->devices, bus_list) {
 		u16 status;
 
+		if (!has_pcie_dev)
+			has_pcie_dev = pci_is_pcie(dev);
 		pci_read_config_word(dev, PCI_STATUS, &status);
 
 		/*
@@ -354,9 +357,11 @@ void pcibios_fixup_bus(struct pci_bus *bus)
 
 	/*
 	 * Report what we did for this bus
+	 * (only if the bus doesn't have any PCIe devices)
 	 */
-	printk(KERN_INFO "PCI: bus%d: Fast back to back transfers %sabled\n",
-		bus->number, (features & PCI_COMMAND_FAST_BACK) ? "en" : "dis");
+	if (!has_pcie_dev)
+		pr_info("PCI: bus%d: Fast back to back transfers %sabled\n",
+			bus->number, (features & PCI_COMMAND_FAST_BACK) ? "en" : "dis");
 }
 EXPORT_SYMBOL(pcibios_fixup_bus);
 
-- 
1.8.1.5

