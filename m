Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352AbaJ0HId (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 03:08:33 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:6584 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbaJ0HIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 03:08:30 -0400
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
Subject: [PATCH 10/10] PCI/MSI: Remove useless bus->msi assignment
Date: Mon, 27 Oct 2014 15:48:47 +0800
Message-ID: <1414396127-30023-11-git-send-email-wangyijing@huawei.com>
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

Thierry introduced MSI chip(now renamed to MSI controller)
framework to associate MSI chip and PCI bus in arm.
Other platforms still use its own arch MSI functions to
support MSI capability. Thierry introduced the bus->msi
assignment to make child bus can inherit bus->msi from the parent.
But in fact, drivers which used MSI chip always associate
MSI chip and PCI bus by add .add_bus() in arm PCI host bridge
drivers. Now we have saved MSI chip in pci_sys_data.
We can remove this bus->msi assignment safely.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
CC: Thierry Reding <thierry.reding@gmail.com>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
---
 drivers/pci/msi.c   |    5 -----
 drivers/pci/probe.c |    1 -
 2 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index f085f7f..27b6a54 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -37,11 +37,6 @@ struct msi_controller * __weak pcibios_msi_controller(struct pci_bus *bus)
 
 struct msi_controller *pci_msi_controller(struct pci_bus *bus)
 {
-	struct msi_controller *ctrl = bus->msi;
-
-	if (ctrl)
-		return ctrl;
-
 	return pcibios_msi_controller(bus);
 }
 
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 5ed9930..4b18bf2 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -682,7 +682,6 @@ static struct pci_bus *pci_alloc_child_bus(struct pci_bus *parent,
 
 	child->parent = parent;
 	child->ops = parent->ops;
-	child->msi = parent->msi;
 	child->sysdata = parent->sysdata;
 	child->bus_flags = parent->bus_flags;
 
-- 
1.7.1

