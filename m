Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbaJ0HJK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 03:09:10 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:10253 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbaJ0HIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 03:08:23 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Xinwei Hu <huxinwei@huawei.com>, Wuyun <wuyun.wu@huawei.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Thierry Reding" <thierry.reding@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH 09/10] arm/PCI: Clean unused pcibios_add_bus() and pcibios_remove_bus()
Date: Mon, 27 Oct 2014 15:48:46 +0800
Message-ID: <1414396127-30023-10-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1414396127-30023-1-git-send-email-wangyijing@huawei.com>
References: <1414396127-30023-1-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.166]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MSI controller has been saved in pci_sys_data, now we can
clean up pcibios_add_bus() and pcibios_remove_bus()
in arm, and use pcibios_msi_controller() to get MSI controller
pointer.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 arch/arm/include/asm/mach/pci.h |    4 ----
 arch/arm/kernel/bios32.c        |   16 ----------------
 2 files changed, 0 insertions(+), 20 deletions(-)

diff --git a/arch/arm/include/asm/mach/pci.h b/arch/arm/include/asm/mach/pci.h
index 8144d61..8292b5f 100644
--- a/arch/arm/include/asm/mach/pci.h
+++ b/arch/arm/include/asm/mach/pci.h
@@ -39,8 +39,6 @@ struct hw_pci {
 					  resource_size_t start,
 					  resource_size_t size,
 					  resource_size_t align);
-	void		(*add_bus)(struct pci_bus *bus);
-	void		(*remove_bus)(struct pci_bus *bus);
 };
 
 /*
@@ -71,8 +69,6 @@ struct pci_sys_data {
 					  resource_size_t start,
 					  resource_size_t size,
 					  resource_size_t align);
-	void		(*add_bus)(struct pci_bus *bus);
-	void		(*remove_bus)(struct pci_bus *bus);
 	void		*private_data;	/* platform controller private data	*/
 };
 
diff --git a/arch/arm/kernel/bios32.c b/arch/arm/kernel/bios32.c
index 073229f..32301fc 100644
--- a/arch/arm/kernel/bios32.c
+++ b/arch/arm/kernel/bios32.c
@@ -369,20 +369,6 @@ void pcibios_fixup_bus(struct pci_bus *bus)
 }
 EXPORT_SYMBOL(pcibios_fixup_bus);
 
-void pcibios_add_bus(struct pci_bus *bus)
-{
-	struct pci_sys_data *sys = bus->sysdata;
-	if (sys->add_bus)
-		sys->add_bus(bus);
-}
-
-void pcibios_remove_bus(struct pci_bus *bus)
-{
-	struct pci_sys_data *sys = bus->sysdata;
-	if (sys->remove_bus)
-		sys->remove_bus(bus);
-}
-
 /*
  * Swizzle the device pin each time we cross a bridge.  If a platform does
  * not provide a swizzle function, we perform the standard PCI swizzling.
@@ -487,8 +473,6 @@ static void pcibios_init_hw(struct device *parent, struct hw_pci *hw,
 		sys->swizzle = hw->swizzle;
 		sys->map_irq = hw->map_irq;
 		sys->align_resource = hw->align_resource;
-		sys->add_bus = hw->add_bus;
-		sys->remove_bus = hw->remove_bus;
 		INIT_LIST_HEAD(&sys->resources);
 
 		if (hw->private_data)
-- 
1.7.1

