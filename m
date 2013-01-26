Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049Ab3AZAz4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 19:55:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42309 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754894Ab3AZAzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 19:55:51 -0500
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH 2/2] PCI: Use PCI Express Capability accessors
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, jiang.liu@huawei.com, mcgrof@qca.qualcomm.com,
        mcgrof@do-not-panic.com, linux-kernel@vger.kernel.org
Date: Fri, 25 Jan 2013 17:55:45 -0700
Message-ID: <20130126005545.25808.91427.stgit@amt.stowe>
In-Reply-To: <20130126005533.25808.23022.stgit@amt.stowe>
References: <20130126005533.25808.23022.stgit@amt.stowe>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use PCI Express Capability access functions to simplify device
Capabilities Register usages.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 drivers/pci/access.c            |    4 ++--
 drivers/pci/pcie/portdrv_core.c |    2 +-
 include/linux/pci.h             |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/access.c b/drivers/pci/access.c
index 3af0478..5278ac6 100644
--- a/drivers/pci/access.c
+++ b/drivers/pci/access.c
@@ -472,7 +472,7 @@ EXPORT_SYMBOL_GPL(pci_cfg_access_unlock);
 
 static inline int pcie_cap_version(const struct pci_dev *dev)
 {
-	return dev->pcie_flags_reg & PCI_EXP_FLAGS_VERS;
+	return pcie_caps_reg(dev) & PCI_EXP_FLAGS_VERS;
 }
 
 static inline bool pcie_cap_has_devctl(const struct pci_dev *dev)
@@ -497,7 +497,7 @@ static inline bool pcie_cap_has_sltctl(const struct pci_dev *dev)
 	return pcie_cap_version(dev) > 1 ||
 	       type == PCI_EXP_TYPE_ROOT_PORT ||
 	       (type == PCI_EXP_TYPE_DOWNSTREAM &&
-		dev->pcie_flags_reg & PCI_EXP_FLAGS_SLOT);
+		pcie_caps_reg(dev) & PCI_EXP_FLAGS_SLOT);
 }
 
 static inline bool pcie_cap_has_rtctl(const struct pci_dev *dev)
diff --git a/drivers/pci/pcie/portdrv_core.c b/drivers/pci/pcie/portdrv_core.c
index b42133a..31063ac 100644
--- a/drivers/pci/pcie/portdrv_core.c
+++ b/drivers/pci/pcie/portdrv_core.c
@@ -272,7 +272,7 @@ static int get_port_device_capability(struct pci_dev *dev)
 
 	/* Hot-Plug Capable */
 	if ((cap_mask & PCIE_PORT_SERVICE_HP) &&
-	    dev->pcie_flags_reg & PCI_EXP_FLAGS_SLOT) {
+	    pcie_caps_reg(dev) & PCI_EXP_FLAGS_SLOT) {
 		pcie_capability_read_dword(dev, PCI_EXP_SLTCAP, &reg32);
 		if (reg32 & PCI_EXP_SLTCAP_HPC) {
 			services |= PCIE_PORT_SERVICE_HP;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 78581e1..63b3628 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1707,7 +1707,7 @@ static inline u16 pcie_caps_reg(const struct pci_dev *dev)
  */
 static inline int pci_pcie_type(const struct pci_dev *dev)
 {
-	return (dev->pcie_flags_reg & PCI_EXP_FLAGS_TYPE) >> 4;
+	return (pcie_caps_reg(dev) & PCI_EXP_FLAGS_TYPE) >> 4;
 }
 
 void pci_request_acs(void);

