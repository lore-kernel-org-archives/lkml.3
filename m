Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882AbaE1WaA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 18:30:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:62051 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755781AbaE1W36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 18:29:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,931,1392192000"; 
   d="scan'208";a="546409366"
Subject: [PATCH 2/2] iov: Use pci_walk_vbus for tasks where we must search
 for VFs
From: Alexander Duyck <alexander.h.duyck@intel.com>
To: bhelgaas@google.com, ddutile@redhat.com
Cc: linux-pci@vger.kernel.org, alex.williamson@redhat.com,
        linux-kernel@vger.kernel.org
Date: Wed, 28 May 2014 15:29:28 -0700
Message-ID: <20140528222914.18898.42967.stgit@ahduyck-cp2.jf.intel.com>
In-Reply-To: <20140528222901.18898.48031.stgit@ahduyck-cp2.jf.intel.com>
References: <20140528222901.18898.48031.stgit@ahduyck-cp2.jf.intel.com>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change makes it so that we use pci_walk_vbus to go though and search
for all devices that are contained within the local bus of our device.

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
---
 drivers/pci/iov.c |   50 +++++++++++++++++++++++++++-----------------------
 1 files changed, 27 insertions(+), 23 deletions(-)

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index de7a747..717f202 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -602,6 +602,30 @@ int pci_num_vf(struct pci_dev *dev)
 }
 EXPORT_SYMBOL_GPL(pci_num_vf);
 
+struct vfs_assigned {
+	struct pci_dev *physfn;
+	unsigned int count;
+};
+
+/**
+ * pci_vfs_assigned_cb - callback used by pci_vfs_assigned
+ * @dev: the PCI device
+ * @data: Pointer to structure used by pci_vfs_assigned
+ *
+ * If the device is a virtual function and belongs to the provided PF
+ * and is assigned this will increment the count by 1.
+ */
+static int pci_vfs_assigned_cb(struct pci_dev *dev, void *data)
+{
+	struct vfs_assigned *vfa = data;
+
+	if (dev->is_virtfn && (dev->physfn == vfa->physfn) &&
+	    (dev->dev_flags & PCI_DEV_FLAGS_ASSIGNED))
+		vfa->count++;
+
+	return 0;
+}
+
 /**
  * pci_vfs_assigned - returns number of VFs are assigned to a guest
  * @dev: the PCI device
@@ -611,35 +635,15 @@ EXPORT_SYMBOL_GPL(pci_num_vf);
  */
 int pci_vfs_assigned(struct pci_dev *dev)
 {
-	struct pci_dev *vfdev;
-	unsigned int vfs_assigned = 0;
-	unsigned short dev_id;
+	struct vfs_assigned vfa = { .physfn = dev, .count = 0 };
 
 	/* only search if we are a PF */
 	if (!dev->is_physfn)
 		return 0;
 
-	/*
-	 * determine the device ID for the VFs, the vendor ID will be the
-	 * same as the PF so there is no need to check for that one
-	 */
-	pci_read_config_word(dev, dev->sriov->pos + PCI_SRIOV_VF_DID, &dev_id);
-
-	/* loop through all the VFs to see if we own any that are assigned */
-	vfdev = pci_get_device(dev->vendor, dev_id, NULL);
-	while (vfdev) {
-		/*
-		 * It is considered assigned if it is a virtual function with
-		 * our dev as the physical function and the assigned bit is set
-		 */
-		if (vfdev->is_virtfn && (vfdev->physfn == dev) &&
-		    (vfdev->dev_flags & PCI_DEV_FLAGS_ASSIGNED))
-			vfs_assigned++;
-
-		vfdev = pci_get_device(dev->vendor, dev_id, vfdev);
-	}
+	pci_walk_vbus(dev->bus, pci_vfs_assigned_cb, &vfa);
 
-	return vfs_assigned;
+	return vfa.count;
 }
 EXPORT_SYMBOL_GPL(pci_vfs_assigned);
 

