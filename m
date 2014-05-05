Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419AbaEEVZU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 17:25:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:3630 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755370AbaEEVZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 17:25:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,991,1389772800"; 
   d="scan'208";a="533952403"
Subject: [PATCH] pci: Save and restore VFs as a part of a reset
From: Alexander Duyck <alexander.h.duyck@intel.com>
To: bhelgaas@google.com, linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, jeffrey.t.kirsher@intel.com
Date: Mon, 05 May 2014 14:25:17 -0700
Message-ID: <20140505212346.18767.34117.stgit@ahduyck-cp2.jf.intel.com>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes an issue I found in which triggering a reset via the PCI sysfs
reset while SR-IOV was enabled would leave the VFs in a state in which the
BME and MSI-X enable bits were all cleared.

To correct that I have added code so that the VF state is saved and restored
as a part of the PF save and restore state functions.  By doing this the VF
state is restored as well as the IOV state allowing the VFs to resume function
following a reset.

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
---
 drivers/pci/iov.c |   48 ++++++++++++++++++++++++++++++++++++++++++++++--
 drivers/pci/pci.c |    2 ++
 drivers/pci/pci.h |    5 +++++
 3 files changed, 53 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index de7a747..645ed71 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -521,13 +521,57 @@ resource_size_t pci_sriov_resource_alignment(struct pci_dev *dev, int resno)
 }
 
 /**
+ * pci_save_iov_state - Save the state of the VF configurations
+ * @dev: the PCI device
+ */
+int pci_save_iov_state(struct pci_dev *dev)
+{
+	struct pci_dev *vfdev = NULL;
+	unsigned short dev_id;
+
+	/* only search if we are a PF */
+	if (!dev->is_physfn)
+		return 0;
+
+	/* retrieve VF device ID */
+	pci_read_config_word(dev, dev->sriov->pos + PCI_SRIOV_VF_DID, &dev_id);
+
+	/* loop through all the VFs and save their state information */
+	while ((vfdev = pci_get_device(dev->vendor, dev_id, vfdev))) {
+		if (vfdev->is_virtfn && (vfdev->physfn == dev)) {
+			int err = pci_save_state(vfdev);
+			if (err)
+				return err;
+		}
+	}
+
+	return 0;
+}
+
+/**
  * pci_restore_iov_state - restore the state of the IOV capability
  * @dev: the PCI device
  */
 void pci_restore_iov_state(struct pci_dev *dev)
 {
-	if (dev->is_physfn)
-		sriov_restore_state(dev);
+	struct pci_dev *vfdev = NULL;
+	unsigned short dev_id;
+
+	if (!dev->is_physfn)
+		return;
+
+	sriov_restore_state(dev);
+
+	/* retrieve VF device ID */
+	pci_read_config_word(dev, dev->sriov->pos + PCI_SRIOV_VF_DID, &dev_id);
+
+	/* loop through all VFs and restore state for any of our VFs */
+	while ((vfdev = pci_get_device(dev->vendor, dev_id, vfdev))) {
+		if (vfdev->is_virtfn && (vfdev->physfn == dev))
+			pci_restore_state(vfdev);
+	}
+
+	return 0;
 }
 
 /**
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 7325d43..120a432 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1015,6 +1015,8 @@ pci_save_state(struct pci_dev *dev)
 		return i;
 	if ((i = pci_save_vc_state(dev)) != 0)
 		return i;
+	if ((i = pci_save_iov_state(dev)) != 0)
+		return i;
 	return 0;
 }
 
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 6bd0822..9185edd 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -254,6 +254,7 @@ void pci_iov_release(struct pci_dev *dev);
 int pci_iov_resource_bar(struct pci_dev *dev, int resno,
 			 enum pci_bar_type *type);
 resource_size_t pci_sriov_resource_alignment(struct pci_dev *dev, int resno);
+int pci_save_iov_state(struct pci_dev *dev);
 void pci_restore_iov_state(struct pci_dev *dev);
 int pci_iov_bus_range(struct pci_bus *bus);
 
@@ -271,6 +272,10 @@ static inline int pci_iov_resource_bar(struct pci_dev *dev, int resno,
 {
 	return 0;
 }
+static inline void pci_save_iov_state(struct pci_dev *dev)
+{
+	return 0;
+}
 static inline void pci_restore_iov_state(struct pci_dev *dev)
 {
 }

