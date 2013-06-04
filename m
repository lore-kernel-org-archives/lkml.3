Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab3FDRS1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 13:18:27 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:60675 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab3FDRSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 13:18:24 -0400
Date: Tue, 4 Jun 2013 19:18:14 +0200 (CEST)
From: Sebastian Ott <sebott@linux.vnet.ibm.com>
X-X-Sender: sebott@c4eb
To: Bjorn Helgaas <bhelgaas@google.com>
cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] pci: add pcibios_release_device
Message-ID: <alpine.LFD.2.03.1306041911170.1686@linux.vnet.ibm.com>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
Organization: =?ISO-8859-15?Q?=22IBM_Deutschland_Research_&_Development_GmbH_=2F_Vorsitzende_des_Aufsichtsrats=3A_Martina_Koederitz_Gesch=E4ftsf=FChrung=3A_Dirk_Wittkopp_Sitz_der_Gesellschaft=3A_B=F6blingen_=2F_Registergericht?=
 =?ISO-8859-15?Q?=3A_Amtsgericht_Stuttgart=2C_HRB_243294=22?=
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060417-5024-0000-0000-0000063C7A2D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Bjorn,

part of your feedback to the PCI support on s390 was to put some smarts in
the config space accessors and let the pci core do the scanning of pci
functions.
To get there I had to implement pcibios_add_device on s390 to do some arch
specific device initialization. During removal of the pci function I would
like to undo these steps. Would it be possible to have a couterpart of
pcibios_add_device - like the patch below:


pci: add pcibios_release_device

Platforms may want to provide architecture-specific functionality when
a pci device is released. Add a pcibios_release_device() call that
architectures can override to do so.

Signed-off-by: Sebastian Ott <sebott@linux.vnet.ibm.com>
---
 drivers/pci/pci.c   |   10 ++++++++++
 drivers/pci/probe.c |    1 +
 include/linux/pci.h |    1 +
 3 files changed, 12 insertions(+)

--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1335,6 +1335,16 @@ int __weak pcibios_add_device (struct pc
 }
 
 /**
+ * pcibios_release_device - provide arch specific hooks when releasing device dev
+ * @dev: the PCI device being released
+ *
+ * Permits the platform to provide architecture specific functionality when
+ * devices are released. This is the default implementation. Architecture
+ * implementations can override this.
+ */
+void __weak pcibios_release_device(struct pci_dev *dev) {}
+
+/**
  * pcibios_disable_device - disable arch specific PCI resources for device dev
  * @dev: the PCI device to disable
  *
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1132,6 +1132,7 @@ static void pci_release_dev(struct devic
 	pci_dev = to_pci_dev(dev);
 	pci_release_capabilities(pci_dev);
 	pci_release_of_node(pci_dev);
+	pcibios_release_device(pci_dev);
 	kfree(pci_dev);
 }
 
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1643,6 +1643,7 @@ void pcibios_set_master(struct pci_dev *
 int pcibios_set_pcie_reset_state(struct pci_dev *dev,
 				 enum pcie_reset_state state);
 int pcibios_add_device(struct pci_dev *dev);
+void pcibios_release_device(struct pci_dev *dev);
 
 #ifdef CONFIG_PCI_MMCONFIG
 void __init pci_mmcfg_early_init(void);

