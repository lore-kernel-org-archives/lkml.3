Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271AbaIGK3c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 06:29:32 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:35485 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbaIGK3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 06:29:31 -0400
From: Vidya Sagar <sagar.tv@gmail.com>
X-Google-Original-From: Vidya Sagar <vidyas@nvidia.com>
To: linux@arm.linux.org.uk, bhelgaas@google.com, wangyijing@huawei.com,
        thierry.reding@gmail.com, jason@lakedaemon.net, will.deacon@arm.com,
        swarren@nvidia.com
Cc: kthota@nvidia.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Vidya Sagar <sagar.tv@gmail.com>
Subject: [PATCH v4] ARM: fix debug prints relevant to PCI devices
Date: Sun,  7 Sep 2014 15:58:07 +0530
Message-Id: <1410085687-11273-1-git-send-email-vidyas@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vidya Sagar <sagar.tv@gmail.com>

As per PCIe spec, fast back-to-back transactions feature
is not applicable to PCIe devices. Hence, do not print
that fast back-to-back trasactions are disabled when
there is a PCIe device found on the bus

Signed-off-by: Vidya Sagar <sagar.tv@gmail.com>
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

