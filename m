Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915AbaGHTmQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:42:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54085 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755678AbaGHTIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:39 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Wei Yang" <weiyang@linux.vnet.ibm.com>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.250474809@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 115/125] net/mlx4_core: Preserve pci_dev_data after 
 __mlx4_remove_one()
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Yang <weiyang@linux.vnet.ibm.com>

[ Upstream commit befdf8978accecac2e0739e6b5075afc62db37fe ]

This patch wrap up a helper function __mlx4_remove_one() which does the tear
down function but preserve the drv_data. Functions like
mlx4_pci_err_detected() and mlx4_restart_one() will call this one with out
releasing drvdata.

Signed-off-by: Wei Yang <weiyang@linux.vnet.ibm.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/mellanox/mlx4/main.c | 110 +++++++++++++++++-------------
 drivers/net/ethernet/mellanox/mlx4/mlx4.h |   1 +
 2 files changed, 65 insertions(+), 46 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -1283,15 +1283,8 @@ static int __mlx4_init_one(struct pci_de
 	/* Allow large DMA segments, up to the firmware limit of 1 GB */
 	dma_set_max_seg_size(&pdev->dev, 1024 * 1024 * 1024);
 
-	priv = kzalloc(sizeof *priv, GFP_KERNEL);
-	if (!priv) {
-		dev_err(&pdev->dev, "Device struct alloc failed, "
-			"aborting.\n");
-		err = -ENOMEM;
-		goto err_release_regions;
-	}
-
-	dev       = &priv->dev;
+	dev       = pci_get_drvdata(pdev);
+	priv      = mlx4_priv(dev);
 	dev->pdev = pdev;
 	INIT_LIST_HEAD(&priv->ctx_list);
 	spin_lock_init(&priv->ctx_lock);
@@ -1362,8 +1355,7 @@ static int __mlx4_init_one(struct pci_de
 	mlx4_sense_init(dev);
 	mlx4_start_sense(dev);
 
-	priv->pci_dev_data = pci_dev_data;
-	pci_set_drvdata(pdev, dev);
+	priv->removed = 0;
 
 	return 0;
 
@@ -1413,53 +1405,79 @@ err_disable_pdev:
 static int __devinit mlx4_init_one(struct pci_dev *pdev,
 				   const struct pci_device_id *id)
 {
+	struct mlx4_priv *priv;
+	struct mlx4_dev *dev;
+
 	printk_once(KERN_INFO "%s", mlx4_version);
 
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	dev       = &priv->dev;
+	pci_set_drvdata(pdev, dev);
+	priv->pci_dev_data = id->driver_data;
+
 	return __mlx4_init_one(pdev, id->driver_data);
 }
 
-static void mlx4_remove_one(struct pci_dev *pdev)
+static void __mlx4_remove_one(struct pci_dev *pdev)
 {
 	struct mlx4_dev  *dev  = pci_get_drvdata(pdev);
 	struct mlx4_priv *priv = mlx4_priv(dev);
+	int               pci_dev_data;
 	int p;
 
-	if (dev) {
-		mlx4_stop_sense(dev);
-		mlx4_unregister_device(dev);
-
-		for (p = 1; p <= dev->caps.num_ports; p++) {
-			mlx4_cleanup_port_info(&priv->port[p]);
-			mlx4_CLOSE_PORT(dev, p);
-		}
-
-		mlx4_cleanup_counters_table(dev);
-		mlx4_cleanup_mcg_table(dev);
-		mlx4_cleanup_qp_table(dev);
-		mlx4_cleanup_srq_table(dev);
-		mlx4_cleanup_cq_table(dev);
-		mlx4_cmd_use_polling(dev);
-		mlx4_cleanup_eq_table(dev);
-		mlx4_cleanup_mr_table(dev);
-		mlx4_cleanup_xrcd_table(dev);
-		mlx4_cleanup_pd_table(dev);
-
-		iounmap(priv->kar);
-		mlx4_uar_free(dev, &priv->driver_uar);
-		mlx4_cleanup_uar_table(dev);
-		mlx4_clear_steering(dev);
-		mlx4_free_eq_table(dev);
-		mlx4_close_hca(dev);
-		mlx4_cmd_cleanup(dev);
-
-		if (dev->flags & MLX4_FLAG_MSI_X)
-			pci_disable_msix(pdev);
-
-		kfree(priv);
-		pci_release_regions(pdev);
-		pci_disable_device(pdev);
-		pci_set_drvdata(pdev, NULL);
+	if (priv->removed)
+		return;
+
+	pci_dev_data = priv->pci_dev_data;
+
+	mlx4_stop_sense(dev);
+	mlx4_unregister_device(dev);
+
+	for (p = 1; p <= dev->caps.num_ports; p++) {
+		mlx4_cleanup_port_info(&priv->port[p]);
+		mlx4_CLOSE_PORT(dev, p);
 	}
+
+	mlx4_cleanup_counters_table(dev);
+	mlx4_cleanup_mcg_table(dev);
+	mlx4_cleanup_qp_table(dev);
+	mlx4_cleanup_srq_table(dev);
+	mlx4_cleanup_cq_table(dev);
+	mlx4_cmd_use_polling(dev);
+	mlx4_cleanup_eq_table(dev);
+	mlx4_cleanup_mr_table(dev);
+	mlx4_cleanup_xrcd_table(dev);
+	mlx4_cleanup_pd_table(dev);
+
+	iounmap(priv->kar);
+	mlx4_uar_free(dev, &priv->driver_uar);
+	mlx4_cleanup_uar_table(dev);
+	mlx4_clear_steering(dev);
+	mlx4_free_eq_table(dev);
+	mlx4_close_hca(dev);
+	mlx4_cmd_cleanup(dev);
+
+	if (dev->flags & MLX4_FLAG_MSI_X)
+		pci_disable_msix(pdev);
+
+	pci_release_regions(pdev);
+	pci_disable_device(pdev);
+	memset(priv, 0, sizeof(*priv));
+	priv->pci_dev_data = pci_dev_data;
+	priv->removed = 1;
+}
+
+static void mlx4_remove_one(struct pci_dev *pdev)
+{
+	struct mlx4_dev  *dev  = pci_get_drvdata(pdev);
+	struct mlx4_priv *priv = mlx4_priv(dev);
+
+	__mlx4_remove_one(pdev);
+	kfree(priv);
+	pci_set_drvdata(pdev, NULL);
 }
 
 int mlx4_restart_one(struct pci_dev *pdev)
@@ -1469,7 +1487,7 @@ int mlx4_restart_one(struct pci_dev *pde
 	int               pci_dev_data;
 
 	pci_dev_data = priv->pci_dev_data;
-	mlx4_remove_one(pdev);
+	__mlx4_remove_one(pdev);
 	return __mlx4_init_one(pdev, pci_dev_data);
 }
 
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
@@ -329,6 +329,7 @@ struct mlx4_priv {
 	spinlock_t		ctx_lock;
 
 	int                     pci_dev_data;
+	int                     removed;
 
 	struct list_head        pgdir_list;
 	struct mutex            pgdir_mutex;

