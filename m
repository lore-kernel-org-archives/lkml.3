Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046AbaFXPvq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 11:51:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60805 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754969AbaFXPvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:51:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Roland Dreier <roland@purestorage.com>
Subject: [PATCH 3.4 07/26] mlx4_core: Stash PCI ID driver_data in mlx4_priv structure
Date: Tue, 24 Jun 2014 11:50:30 -0400
Message-Id: <20140624154619.844365922@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140624154619.499002156@linuxfoundation.org>
References: <20140624154619.499002156@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Yang <weiyang@linux.vnet.ibm.com>

[ No upstream commit, this is a cherry picked backport enabler. ]

From: Roland Dreier <roland@purestorage.com>

That way we can check flags later on, when we've finished with the
pci_device_id structure.  Also convert the "is VF" flag to an enum:
"Never do in the preprocessor what can be done in C."

Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx4/main.c |   27 +++++++++++++++------------
 drivers/net/ethernet/mellanox/mlx4/mlx4.h |    6 ++++++
 2 files changed, 21 insertions(+), 12 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -92,8 +92,6 @@ MODULE_PARM_DESC(log_num_mgm_entry_size,
 					 " 10 gives 248.range: 9<="
 					 " log_num_mgm_entry_size <= 12");
 
-#define MLX4_VF                                        (1 << 0)
-
 #define HCA_GLOBAL_CAP_MASK            0
 #define PF_CONTEXT_BEHAVIOUR_MASK      0
 
@@ -1731,7 +1729,7 @@ static void mlx4_free_ownership(struct m
 	iounmap(owner);
 }
 
-static int __mlx4_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
+static int __mlx4_init_one(struct pci_dev *pdev, int pci_dev_data)
 {
 	struct mlx4_priv *priv;
 	struct mlx4_dev *dev;
@@ -1754,12 +1752,11 @@ static int __mlx4_init_one(struct pci_de
 	/*
 	 * Check for BARs.
 	 */
-	if (((id == NULL) || !(id->driver_data & MLX4_VF)) &&
+	if (!(pci_dev_data & MLX4_PCI_DEV_IS_VF) &&
 	    !(pci_resource_flags(pdev, 0) & IORESOURCE_MEM)) {
 		dev_err(&pdev->dev, "Missing DCS, aborting."
-			"(id == 0X%p, id->driver_data: 0x%lx,"
-			" pci_resource_flags(pdev, 0):0x%lx)\n", id,
-			id ? id->driver_data : 0, pci_resource_flags(pdev, 0));
+			"(driver_data: 0x%x, pci_resource_flags(pdev, 0):0x%lx)\n",
+			pci_dev_data, pci_resource_flags(pdev, 0));
 		err = -ENODEV;
 		goto err_disable_pdev;
 	}
@@ -1824,7 +1821,7 @@ static int __mlx4_init_one(struct pci_de
 
 	dev->rev_id = pdev->revision;
 	/* Detect if this device is a virtual function */
-	if (id && id->driver_data & MLX4_VF) {
+	if (pci_dev_data & MLX4_PCI_DEV_IS_VF) {
 		/* When acting as pf, we normally skip vfs unless explicitly
 		 * requested to probe them. */
 		if (num_vfs && extended_func_num(pdev) > probe_vf) {
@@ -1970,6 +1967,7 @@ slave_start:
 	mlx4_sense_init(dev);
 	mlx4_start_sense(dev);
 
+	priv->pci_dev_data = pci_dev_data;
 	pci_set_drvdata(pdev, dev);
 
 	return 0;
@@ -2039,7 +2037,7 @@ static int __devinit mlx4_init_one(struc
 {
 	printk_once(KERN_INFO "%s", mlx4_version);
 
-	return __mlx4_init_one(pdev, id);
+	return __mlx4_init_one(pdev, id->driver_data);
 }
 
 static void mlx4_remove_one(struct pci_dev *pdev)
@@ -2108,8 +2106,13 @@ static void mlx4_remove_one(struct pci_d
 
 int mlx4_restart_one(struct pci_dev *pdev)
 {
+	struct mlx4_dev	 *dev  = pci_get_drvdata(pdev);
+	struct mlx4_priv *priv = mlx4_priv(dev);
+	int		  pci_dev_data;
+
+	pci_dev_data = priv->pci_dev_data;
 	mlx4_remove_one(pdev);
-	return __mlx4_init_one(pdev, NULL);
+	return __mlx4_init_one(pdev, pci_dev_data);
 }
 
 static DEFINE_PCI_DEVICE_TABLE(mlx4_pci_table) = {
@@ -2138,11 +2141,11 @@ static DEFINE_PCI_DEVICE_TABLE(mlx4_pci_
 	/* MT26478 ConnectX2 40GigE PCIe gen2 */
 	{ PCI_VDEVICE(MELLANOX, 0x676e), 0 },
 	/* MT25400 Family [ConnectX-2 Virtual Function] */
-	{ PCI_VDEVICE(MELLANOX, 0x1002), MLX4_VF },
+	{ PCI_VDEVICE(MELLANOX, 0x1002), MLX4_PCI_DEV_IS_VF },
 	/* MT27500 Family [ConnectX-3] */
 	{ PCI_VDEVICE(MELLANOX, 0x1003), 0 },
 	/* MT27500 Family [ConnectX-3 Virtual Function] */
-	{ PCI_VDEVICE(MELLANOX, 0x1004), MLX4_VF },
+	{ PCI_VDEVICE(MELLANOX, 0x1004), MLX4_PCI_DEV_IS_VF },
 	{ PCI_VDEVICE(MELLANOX, 0x1005), 0 }, /* MT27510 Family */
 	{ PCI_VDEVICE(MELLANOX, 0x1006), 0 }, /* MT27511 Family */
 	{ PCI_VDEVICE(MELLANOX, 0x1007), 0 }, /* MT27520 Family */
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
@@ -711,6 +711,10 @@ struct mlx4_steer {
 	struct list_head steer_entries[MLX4_NUM_STEERS];
 };
 
+enum {
+	MLX4_PCI_DEV_IS_VF              = 1 << 0,
+};
+
 struct mlx4_priv {
 	struct mlx4_dev		dev;
 
@@ -718,6 +722,8 @@ struct mlx4_priv {
 	struct list_head	ctx_list;
 	spinlock_t		ctx_lock;
 
+	int			pci_dev_data;
+
 	struct list_head        pgdir_list;
 	struct mutex            pgdir_mutex;
 


