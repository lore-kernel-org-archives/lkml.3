Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485AbaJ0HIV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 03:08:21 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:10231 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbaJ0HIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 03:08:18 -0400
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
Subject: [PATCH 05/10] PCI: designware: Save MSI controller in pci_sys_data
Date: Mon, 27 Oct 2014 15:48:42 +0800
Message-ID: <1414396127-30023-6-git-send-email-wangyijing@huawei.com>
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

Save MSI controller in pci_sys_data instead of
assigning MSI controller pointer to every pci bus
in .add_bus().

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/pci/host/pcie-designware.c |   15 ++++-----------
 1 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-designware.c
index 0839b92..dd85b41 100644
--- a/drivers/pci/host/pcie-designware.c
+++ b/drivers/pci/host/pcie-designware.c
@@ -498,6 +498,10 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
 	val |= PORT_LOGIC_SPEED_CHANGE;
 	dw_pcie_wr_own_conf(pp, PCIE_LINK_WIDTH_SPEED_CONTROL, 4, val);
 
+#ifdef CONFIG_PCI_MSI
+	dw_pcie_msi_controller.dev = pp->dev;
+	dw_pci.msi_ctrl = &dw_pcie_msi_controller;
+#endif
 	dw_pci.nr_controllers = 1;
 	dw_pci.private_data = (void **)&pp;
 
@@ -747,21 +751,10 @@ static int dw_pcie_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 	return irq;
 }
 
-static void dw_pcie_add_bus(struct pci_bus *bus)
-{
-	if (IS_ENABLED(CONFIG_PCI_MSI)) {
-		struct pcie_port *pp = sys_to_pcie(bus->sysdata);
-
-		dw_pcie_msi_controller.dev = pp->dev;
-		bus->msi = &dw_pcie_msi_controller;
-	}
-}
-
 static struct hw_pci dw_pci = {
 	.setup		= dw_pcie_setup,
 	.scan		= dw_pcie_scan_bus,
 	.map_irq	= dw_pcie_map_irq,
-	.add_bus	= dw_pcie_add_bus,
 };
 
 void dw_pcie_setup_rc(struct pcie_port *pp)
-- 
1.7.1

