Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221AbaGHTl3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:41:29 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54117 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755686AbaGHTIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:39 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Roland Dreier" <roland@purestorage.com>,
        "Wei Yang" <weiyang@linux.vnet.ibm.com>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.686313675@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 114/125] mlx4_core: Stash PCI ID driver_data in
 mlx4_priv  structure
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

[ No upstream commit, this is a cherry picked backport enabler. ]

That way we can check flags later on, when we've finished with the
pci_device_id structure.

This is a backport.

Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/mellanox/mlx4/main.c | 12 +++++++++---
 drivers/net/ethernet/mellanox/mlx4/mlx4.h |  2 ++
 2 files changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -1220,7 +1220,7 @@ static void mlx4_clear_steering(struct m
 	kfree(priv->steer);
 }
 
-static int __mlx4_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
+static int __mlx4_init_one(struct pci_dev *pdev, int pci_dev_data)
 {
 	struct mlx4_priv *priv;
 	struct mlx4_dev *dev;
@@ -1362,6 +1362,7 @@ static int __mlx4_init_one(struct pci_de
 	mlx4_sense_init(dev);
 	mlx4_start_sense(dev);
 
+	priv->pci_dev_data = pci_dev_data;
 	pci_set_drvdata(pdev, dev);
 
 	return 0;
@@ -1414,7 +1415,7 @@ static int __devinit mlx4_init_one(struc
 {
 	printk_once(KERN_INFO "%s", mlx4_version);
 
-	return __mlx4_init_one(pdev, id);
+	return __mlx4_init_one(pdev, id->driver_data);
 }
 
 static void mlx4_remove_one(struct pci_dev *pdev)
@@ -1463,8 +1464,13 @@ static void mlx4_remove_one(struct pci_d
 
 int mlx4_restart_one(struct pci_dev *pdev)
 {
+	struct mlx4_dev  *dev  = pci_get_drvdata(pdev);
+	struct mlx4_priv *priv = mlx4_priv(dev);
+	int               pci_dev_data;
+
+	pci_dev_data = priv->pci_dev_data;
 	mlx4_remove_one(pdev);
-	return __mlx4_init_one(pdev, NULL);
+	return __mlx4_init_one(pdev, pci_dev_data);
 }
 
 static DEFINE_PCI_DEVICE_TABLE(mlx4_pci_table) = {
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
@@ -328,6 +328,8 @@ struct mlx4_priv {
 	struct list_head	ctx_list;
 	spinlock_t		ctx_lock;
 
+	int                     pci_dev_data;
+
 	struct list_head        pgdir_list;
 	struct mutex            pgdir_mutex;
 

