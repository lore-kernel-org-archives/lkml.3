Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710AbaJ0HKm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 03:10:42 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:10243 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbaJ0HIU (ORCPT
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
Subject: [PATCH 08/10] PCI: xilinx: Save MSI controller in pci_sys_data
Date: Mon, 27 Oct 2014 15:48:45 +0800
Message-ID: <1414396127-30023-9-git-send-email-wangyijing@huawei.com>
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
 drivers/pci/host/pcie-xilinx.c |   19 ++++---------------
 1 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/pci/host/pcie-xilinx.c b/drivers/pci/host/pcie-xilinx.c
index ce19133..5a3e5a0 100644
--- a/drivers/pci/host/pcie-xilinx.c
+++ b/drivers/pci/host/pcie-xilinx.c
@@ -431,20 +431,6 @@ static void xilinx_pcie_enable_msi(struct xilinx_pcie_port *port)
 	pcie_write(port, msg_addr, XILINX_PCIE_REG_MSIBASE2);
 }
 
-/**
- * xilinx_pcie_add_bus - Add MSI chip info to PCIe bus
- * @bus: PCIe bus
- */
-static void xilinx_pcie_add_bus(struct pci_bus *bus)
-{
-	if (IS_ENABLED(CONFIG_PCI_MSI)) {
-		struct xilinx_pcie_port *port = sys_to_pcie(bus->sysdata);
-
-		xilinx_pcie_msi_controller.dev = port->dev;
-		bus->msi = &xilinx_pcie_msi_controller;
-	}
-}
-
 /* INTx Functions */
 
 /**
@@ -924,10 +910,13 @@ static int xilinx_pcie_probe(struct platform_device *pdev)
 		.private_data	= (void **)&port,
 		.setup		= xilinx_pcie_setup,
 		.map_irq	= of_irq_parse_and_map_pci,
-		.add_bus	= xilinx_pcie_add_bus,
 		.scan		= xilinx_pcie_scan_bus,
 		.ops		= &xilinx_pcie_ops,
 	};
+#ifdef CONFIG_PCI_MSI
+	xilinx_pcie_msi_controller.dev = port->dev;
+	hw.msi_ctrl = &xilinx_pcie_msi_controller;
+#endif
 	pci_common_init_dev(dev, &hw);
 
 	return 0;
-- 
1.7.1

