Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155AbbAPDsQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 22:48:16 -0500
Received: from [119.145.14.66] ([119.145.14.66]:23266 "EHLO
	szxga03-in.huawei.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S932617AbbAPDsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 22:48:08 -0500
From: Yijing Wang <wangyijing@huawei.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Jiang Liu <jiang.liu@linux.intel.com>, <linux-pci@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, <linux-kernel@vger.kernel.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>, <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        <linux-ia64@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Guan Xuetao" <gxt@mprc.pku.edu.cn>, <linux-alpha@vger.kernel.org>,
        <linux-m68k@vger.kernel.org>, Liviu Dudau <liviu@dudau.co.uk>,
        "Arnd Bergmann" <arnd@arndb.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "Yijing Wang" <wangyijing@huawei.com>
Subject: [PATCH 21/28] PCI/mvebu: Use pci_common_init_dev() to simplify code
Date: Fri, 16 Jan 2015 09:44:19 +0800
Message-ID: <1421372666-12288-22-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1421372666-12288-1-git-send-email-wangyijing@huawei.com>
References: <1421372666-12288-1-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.166]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020206.54B889D2.007C,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 62ddac9ad5c33c48151d9255819f6f81
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mvebu_pcie_scan_bus() is not necessary, we could use
pci_common_init_dev() instead of pci_common_init(),
and pass the device pointer as the parent. Then
pci_scan_root_bus() will be called to scan the pci busses.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/pci/host/pci-mvebu.c |   18 +-----------------
 1 files changed, 1 insertions(+), 17 deletions(-)

diff --git a/drivers/pci/host/pci-mvebu.c b/drivers/pci/host/pci-mvebu.c
index 1309cfb..d5a2b70 100644
--- a/drivers/pci/host/pci-mvebu.c
+++ b/drivers/pci/host/pci-mvebu.c
@@ -750,21 +750,6 @@ static int mvebu_pcie_setup(int nr, struct pci_sys_data *sys)
 	return 1;
 }
 
-static struct pci_bus *mvebu_pcie_scan_bus(int nr, struct pci_sys_data *sys)
-{
-	struct mvebu_pcie *pcie = sys_to_pcie(sys);
-	struct pci_bus *bus;
-
-	bus = pci_create_root_bus(&pcie->pdev->dev, sys->busnr,
-				  &mvebu_pcie_ops, sys, &sys->resources);
-	if (!bus)
-		return NULL;
-
-	pci_scan_child_bus(bus);
-
-	return bus;
-}
-
 static resource_size_t mvebu_pcie_align_resource(struct pci_dev *dev,
 						 const struct resource *res,
 						 resource_size_t start,
@@ -808,12 +793,11 @@ static void mvebu_pcie_enable(struct mvebu_pcie *pcie)
 	hw.nr_controllers = 1;
 	hw.private_data   = (void **)&pcie;
 	hw.setup          = mvebu_pcie_setup;
-	hw.scan           = mvebu_pcie_scan_bus;
 	hw.map_irq        = of_irq_parse_and_map_pci;
 	hw.ops            = &mvebu_pcie_ops;
 	hw.align_resource = mvebu_pcie_align_resource;
 
-	pci_common_init(&hw);
+	pci_common_init_dev(&pcie->pdev->dev, &hw);
 }
 
 /*
-- 
1.7.1

