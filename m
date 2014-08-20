Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328AbaHTLw3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 07:52:29 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59003 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752609AbaHTLoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:11 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Stefan Assmann <sassmann@kpanic.de>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 085/104] igb: fix driver reload with VF assigned to guest
Date: Wed, 20 Aug 2014 13:43:48 +0200
Message-Id: <5fae3f3dfd40e78d94dfee0c116b0b8a0189cec6.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Assmann <sassmann@kpanic.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 781798a11e2820ee35fa9142869bb8cec117dedc upstream.

commit fa44f2f185f7f9da19d331929bb1b56c1ccd1d93 broke reloading of igb, when
VFs are assigned to a guest, in several ways.
1. on module load adapter->vf_data does not get properly allocated,
resulting in a null pointer exception when accessing adapter->vf_data in
igb_reset() on module reload.
 modprobe -r igb ; modprobe igb max_vfs=7
[  215.215837] igb 0000:01:00.1: removed PHC on eth1
[  216.932072] igb 0000:01:00.1: IOV Disabled
[  216.937038] igb 0000:01:00.0: removed PHC on eth0
[  217.127032] igb 0000:01:00.0: Cannot deallocate SR-IOV virtual functions while they are assigned - VFs will not be deallocated
[  217.146178] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.0.5-k
[  217.154050] igb: Copyright (c) 2007-2013 Intel Corporation.
[  217.160688] igb 0000:01:00.0: Enabling SR-IOV VFs using the module parameter is deprecated - please use the pci sysfs interface.
[  217.173703] igb 0000:01:00.0: irq 103 for MSI/MSI-X
[  217.179227] igb 0000:01:00.0: irq 104 for MSI/MSI-X
[  217.184735] igb 0000:01:00.0: irq 105 for MSI/MSI-X
[  217.220082] BUG: unable to handle kernel NULL pointer dereference at 0000000000000048
[  217.228846] IP: [<ffffffffa007c5e5>] igb_reset+0xc5/0x4b0 [igb]
[  217.235472] PGD 3607ec067 PUD 36170b067 PMD 0
[  217.240461] Oops: 0002 [#1] SMP
[  217.244085] Modules linked in: igb(+) igbvf mptsas mptscsih mptbase scsi_transport_sas [last unloaded: igb]
[  217.255040] CPU: 4 PID: 4833 Comm: modprobe Not tainted 3.11.0+ #46
[...]
[  217.390007]  [<ffffffffa007fab2>] igb_probe+0x892/0xfd0 [igb]
[  217.396422]  [<ffffffff81470b3e>] local_pci_probe+0x1e/0x40
[  217.402641]  [<ffffffff81472029>] pci_device_probe+0xf9/0x110
[...]
2. A follow up issue, pci_enable_sriov() should only be called if no VFs were
still allocated on module unload. Otherwise pci_enable_sriov() gets called
multiple times in a row rendering the NIC unusable until reset.
3. simply calling igb_enable_sriov() in igb_probe_vfs() is not enough as the
interrupts need to be re-setup. Switching that to igb_pci_enable_sriov().

Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Tested-by: Sibai Li <Sibai.li@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 37 +++++++++++++------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 318017d7dada..2b76ae55f2af 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -182,6 +182,7 @@ static void igb_check_vf_rate_limit(struct igb_adapter *);
 
 #ifdef CONFIG_PCI_IOV
 static int igb_vf_configure(struct igb_adapter *adapter, int vf);
+static int igb_pci_enable_sriov(struct pci_dev *dev, int num_vfs);
 #endif
 
 #ifdef CONFIG_PM
@@ -2423,7 +2424,7 @@ err_dma:
 }
 
 #ifdef CONFIG_PCI_IOV
-static int  igb_disable_sriov(struct pci_dev *pdev)
+static int igb_disable_sriov(struct pci_dev *pdev)
 {
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct igb_adapter *adapter = netdev_priv(netdev);
@@ -2464,27 +2465,19 @@ static int igb_enable_sriov(struct pci_dev *pdev, int num_vfs)
 	int err = 0;
 	int i;
 
-	if (!adapter->msix_entries) {
+	if (!adapter->msix_entries || num_vfs > 7) {
 		err = -EPERM;
 		goto out;
 	}
-
 	if (!num_vfs)
 		goto out;
-	else if (old_vfs && old_vfs == num_vfs)
-		goto out;
-	else if (old_vfs && old_vfs != num_vfs)
-		err = igb_disable_sriov(pdev);
-
-	if (err)
-		goto out;
 
-	if (num_vfs > 7) {
-		err = -EPERM;
-		goto out;
-	}
-
-	adapter->vfs_allocated_count = num_vfs;
+	if (old_vfs) {
+		dev_info(&pdev->dev, "%d pre-allocated VFs found - override max_vfs setting of %d\n",
+			 old_vfs, max_vfs);
+		adapter->vfs_allocated_count = old_vfs;
+	} else
+		adapter->vfs_allocated_count = num_vfs;
 
 	adapter->vf_data = kcalloc(adapter->vfs_allocated_count,
 				sizeof(struct vf_data_storage), GFP_KERNEL);
@@ -2498,10 +2491,12 @@ static int igb_enable_sriov(struct pci_dev *pdev, int num_vfs)
 		goto out;
 	}
 
-	err = pci_enable_sriov(pdev, adapter->vfs_allocated_count);
-	if (err)
-		goto err_out;
-
+	/* only call pci_enable_sriov() if no VFs are allocated already */
+	if (!old_vfs) {
+		err = pci_enable_sriov(pdev, adapter->vfs_allocated_count);
+		if (err)
+			goto err_out;
+	}
 	dev_info(&pdev->dev, "%d VFs allocated\n",
 		 adapter->vfs_allocated_count);
 	for (i = 0; i < adapter->vfs_allocated_count; i++)
@@ -2617,7 +2612,7 @@ static void igb_probe_vfs(struct igb_adapter *adapter)
 		return;
 
 	pci_sriov_set_totalvfs(pdev, 7);
-	igb_enable_sriov(pdev, max_vfs);
+	igb_pci_enable_sriov(pdev, max_vfs);
 
 #endif /* CONFIG_PCI_IOV */
 }
-- 
2.0.4

