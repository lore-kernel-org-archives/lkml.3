Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490AbaGVBwI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 21:52:08 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:28726 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbaGVBwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 21:52:06 -0400
From: Ethan Zhao <ethan.zhao@oracle.com>
To: alexander.h.duyck@intel.com, jeffrey.t.kirsher@intel.com,
        jesse.brandeburg@intel.com, bruce.w.allan@intel.com,
        carolyn.wyborny@intel.com, donald.c.skidmore@intel.com,
        gregory.v.rose@intel.com, john.ronciak@intel.com,
        mitch.a.williams@intel.com
Cc: linux.nics@intel.com, e1000-devel@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ethan.kernel@gmail.com, Ethan Zhao <ethan.zhao@oracle.com>
Subject: [PATCH] i40e: use global pci_vfs_assigned() to replace local i40e_vfs_are_assigned()
Date: Tue, 22 Jul 2014 09:50:51 +0800
Message-Id: <1405993851-24375-1-git-send-email-ethan.zhao@oracle.com>
X-Mailer: git-send-email 1.7.1
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is global funcion pci_vfs_assigned(), so use it instead of composing
local one.

Signed-off-by: Ethan Zhao <ethan.kernel@gmail.com>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |   31 +-------------------
 1 files changed, 1 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 02c11a7..ec59190 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -683,35 +683,6 @@ complete_reset:
 	wr32(hw, I40E_VFGEN_RSTAT1(vf->vf_id), I40E_VFR_VFACTIVE);
 	i40e_flush(hw);
 }
-
-/**
- * i40e_vfs_are_assigned
- * @pf: pointer to the pf structure
- *
- * Determine if any VFs are assigned to VMs
- **/
-static bool i40e_vfs_are_assigned(struct i40e_pf *pf)
-{
-	struct pci_dev *pdev = pf->pdev;
-	struct pci_dev *vfdev;
-
-	/* loop through all the VFs to see if we own any that are assigned */
-	vfdev = pci_get_device(PCI_VENDOR_ID_INTEL, I40E_DEV_ID_VF , NULL);
-	while (vfdev) {
-		/* if we don't own it we don't care */
-		if (vfdev->is_virtfn && pci_physfn(vfdev) == pdev) {
-			/* if it is assigned we cannot release it */
-			if (vfdev->dev_flags & PCI_DEV_FLAGS_ASSIGNED)
-				return true;
-		}
-
-		vfdev = pci_get_device(PCI_VENDOR_ID_INTEL,
-				       I40E_DEV_ID_VF,
-				       vfdev);
-	}
-
-	return false;
-}
 #ifdef CONFIG_PCI_IOV
 
 /**
@@ -815,7 +786,7 @@ void i40e_free_vfs(struct i40e_pf *pf)
 	kfree(pf->vf);
 	pf->vf = NULL;
 
-	if (!i40e_vfs_are_assigned(pf)) {
+	if (!pci_vfs_assigned(pf->pdev)) {
 		pci_disable_sriov(pf->pdev);
 		/* Acknowledge VFLR for all VFS. Without this, VFs will fail to
 		 * work correctly when SR-IOV gets re-enabled.
-- 
1.7.1

