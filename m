Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688AbaJ0HKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 03:10:40 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:10248 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbaJ0HIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 03:08:20 -0400
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
Subject: [PATCH 03/10] arm/MSI: Save MSI controller in pci_sys_data
Date: Mon, 27 Oct 2014 15:48:40 +0800
Message-ID: <1414396127-30023-4-git-send-email-wangyijing@huawei.com>
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

Saving msi controller in pci_sys_data make PCI bus and
devices don't need to know msi controller details. It also
make PCI enumeration code be decoupled from msi controller.
Currently, we associate msi controller and PCI bus by adding
.add_bus() in PCI host drivers, and assign parent PCI bus's
msi controller to child bus in pci_alloc_child_bus().
In fact, all PCI devices under the same PCI host bridge
share same msi controller. So msi controller should be seen
as one of resources or attributes to be initialized in pci host
bridge driver. Currently, pci hostbridge drivers create
pci_host_bridge in pci_create_root_bus(), and pass arch
specific pci sysdata to core pci scan functions. So pci
arch sysdata is good place to save msi controller. But this
is not the best solution, because we have to add arch spec
pcibios_msi_controller() to extract out msi_controller from
PCI sysdata.
A better approach is to make a generic pci_host_bridge,
save common info like msi controller, PCI domain, PCI hostbridge
resources into it, and pass the generic pci_host_bridge to PCI
scan functions. Then we can remove lots of arch spec functions.
But these changes are huge, so we plan to do it in another series.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 arch/arm/include/asm/mach/pci.h |    6 ++++++
 arch/arm/kernel/bios32.c        |   12 ++++++++++++
 2 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/arch/arm/include/asm/mach/pci.h b/arch/arm/include/asm/mach/pci.h
index 7fc4278..8144d61 100644
--- a/arch/arm/include/asm/mach/pci.h
+++ b/arch/arm/include/asm/mach/pci.h
@@ -22,6 +22,9 @@ struct hw_pci {
 #ifdef CONFIG_PCI_DOMAINS
 	int		domain;
 #endif
+#ifdef CONFIG_PCI_MSI
+	struct msi_controller *msi_ctrl;
+#endif
 	struct pci_ops	*ops;
 	int		nr_controllers;
 	void		**private_data;
@@ -47,6 +50,9 @@ struct pci_sys_data {
 #ifdef CONFIG_PCI_DOMAINS
 	int		domain;
 #endif
+#ifdef CONFIG_PCI_MSI
+	struct msi_controller *msi_ctrl;
+#endif
 	struct list_head node;
 	int		busnr;		/* primary bus number			*/
 	u64		mem_offset;	/* bus->cpu memory mapping offset	*/
diff --git a/arch/arm/kernel/bios32.c b/arch/arm/kernel/bios32.c
index 17a26c1..073229f 100644
--- a/arch/arm/kernel/bios32.c
+++ b/arch/arm/kernel/bios32.c
@@ -18,6 +18,15 @@
 
 static int debug_pci;
 
+#ifdef CONFIG_PCI_MSI
+struct msi_controller *pcibios_msi_controller(struct pci_bus *bus)
+{
+	struct pci_sys_data *sysdata = bus->sysdata;
+
+	return sysdata->msi_ctrl;
+}
+#endif
+
 /*
  * We can't use pci_get_device() here since we are
  * called from interrupt context.
@@ -471,6 +480,9 @@ static void pcibios_init_hw(struct device *parent, struct hw_pci *hw,
 #ifdef CONFIG_PCI_DOMAINS
 		sys->domain  = hw->domain;
 #endif
+#ifdef CONFIG_PCI_MSI
+		sys->msi_ctrl = hw->msi_ctrl;
+#endif
 		sys->busnr   = busnr;
 		sys->swizzle = hw->swizzle;
 		sys->map_irq = hw->map_irq;
-- 
1.7.1

