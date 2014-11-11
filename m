Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751282AbaKKPHM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 10:07:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48175 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730AbaKKPHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 10:07:10 -0500
Subject: [PATCH v2] PCI: Remove fixed parameter in pci_iov_resource_bar()
From: Myron Stowe <myron.stowe@redhat.com>
To: bhelgaas@google.com, linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Date: Tue, 11 Nov 2014 08:04:50 -0700
Message-ID: <20141111150450.15401.41753.stgit@amt.stowe>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pci_iov_resource_bar() always sets its 'pci_bar_type' parameter to
'pci_bar_unknown'.  Drop the parameter and just use 'pci_bar_unknown'
directly in the callers.

No functional change intended.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Yu Zhao <yuzhao@google.com>
---
 drivers/pci/iov.c |   11 +++--------
 drivers/pci/pci.c |    3 ++-
 drivers/pci/pci.h |    6 ++----
 3 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index 4d109c0..4b3a4ea 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -479,20 +479,16 @@ void pci_iov_release(struct pci_dev *dev)
  * pci_iov_resource_bar - get position of the SR-IOV BAR
  * @dev: the PCI device
  * @resno: the resource number
- * @type: the BAR type to be filled in
  *
  * Returns position of the BAR encapsulated in the SR-IOV capability.
  */
-int pci_iov_resource_bar(struct pci_dev *dev, int resno,
-			 enum pci_bar_type *type)
+int pci_iov_resource_bar(struct pci_dev *dev, int resno)
 {
 	if (resno < PCI_IOV_RESOURCES || resno > PCI_IOV_RESOURCE_END)
 		return 0;
 
 	BUG_ON(!dev->is_physfn);
 
-	*type = pci_bar_unknown;
-
 	return dev->sriov->pos + PCI_SRIOV_BAR +
 		4 * (resno - PCI_IOV_RESOURCES);
 }
@@ -510,13 +506,12 @@ int pci_iov_resource_bar(struct pci_dev *dev, int resno,
 resource_size_t pci_sriov_resource_alignment(struct pci_dev *dev, int resno)
 {
 	struct resource tmp;
-	enum pci_bar_type type;
-	int reg = pci_iov_resource_bar(dev, resno, &type);
+	int reg = pci_iov_resource_bar(dev, resno);
 
 	if (!reg)
 		return 0;
 
-	 __pci_read_base(dev, type, &tmp, reg);
+	 __pci_read_base(dev, pci_bar_unknown, &tmp, reg);
 	return resource_alignment(&tmp);
 }
 
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 625a4ac..7bf2465 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -4180,7 +4180,8 @@ int pci_resource_bar(struct pci_dev *dev, int resno, enum pci_bar_type *type)
 		return dev->rom_base_reg;
 	} else if (resno < PCI_BRIDGE_RESOURCES) {
 		/* device specific resource */
-		reg = pci_iov_resource_bar(dev, resno, type);
+		*type = pci_bar_unknown;
+		reg = pci_iov_resource_bar(dev, resno);
 		if (reg)
 			return reg;
 	}
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 0601890..a0905a0 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -251,8 +251,7 @@ static inline void pci_restore_ats_state(struct pci_dev *dev)
 #ifdef CONFIG_PCI_IOV
 int pci_iov_init(struct pci_dev *dev);
 void pci_iov_release(struct pci_dev *dev);
-int pci_iov_resource_bar(struct pci_dev *dev, int resno,
-			 enum pci_bar_type *type);
+int pci_iov_resource_bar(struct pci_dev *dev, int resno);
 resource_size_t pci_sriov_resource_alignment(struct pci_dev *dev, int resno);
 void pci_restore_iov_state(struct pci_dev *dev);
 int pci_iov_bus_range(struct pci_bus *bus);
@@ -266,8 +265,7 @@ static inline void pci_iov_release(struct pci_dev *dev)
 
 {
 }
-static inline int pci_iov_resource_bar(struct pci_dev *dev, int resno,
-				       enum pci_bar_type *type)
+static inline int pci_iov_resource_bar(struct pci_dev *dev, int resno)
 {
 	return 0;
 }

