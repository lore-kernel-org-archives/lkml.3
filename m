Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220AbaBRKKq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 05:10:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29245 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755196AbaBRKKn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 05:10:43 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Eli Cohen <eli@mellanox.com>,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH net-next 19/35] mlx5: Use pci_enable_msix_range() instead of pci_enable_msix()
Date: Tue, 18 Feb 2014 11:11:48 +0100
Message-Id: <3a48ed13ea35014e0fcdf7bf18b928d9de525779.1392717503.git.agordeev@redhat.com>
In-Reply-To: <cover.1392717502.git.agordeev@redhat.com>
References: <cover.1392717502.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range() and pci_enable_msix_range()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Eli Cohen <eli@mellanox.com>
Cc: linux-rdma@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c |   16 +++++-----------
 1 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index a064f06..81df046 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -116,7 +116,6 @@ static int mlx5_enable_msix(struct mlx5_core_dev *dev)
 	struct mlx5_eq_table *table = &dev->priv.eq_table;
 	int num_eqs = 1 << dev->caps.log_max_eq;
 	int nvec;
-	int err;
 	int i;
 
 	nvec = dev->caps.num_ports * num_online_cpus() + MLX5_EQ_VEC_COMP_BASE;
@@ -131,17 +130,12 @@ static int mlx5_enable_msix(struct mlx5_core_dev *dev)
 	for (i = 0; i < nvec; i++)
 		table->msix_arr[i].entry = i;
 
-retry:
-	table->num_comp_vectors = nvec - MLX5_EQ_VEC_COMP_BASE;
-	err = pci_enable_msix(dev->pdev, table->msix_arr, nvec);
-	if (err <= 0) {
-		return err;
-	} else if (err > 2) {
-		nvec = err;
-		goto retry;
-	}
+	nvec = pci_enable_msix_range(dev->pdev, table->msix_arr,
+				     MLX5_EQ_VEC_COMP_BASE, nvec);
+	if (nvec < 0)
+		return nvec;
 
-	mlx5_core_dbg(dev, "received %d MSI vectors out of %d requested\n", err, nvec);
+	table->num_comp_vectors = nvec - MLX5_EQ_VEC_COMP_BASE;
 
 	return 0;
 }
-- 
1.7.7.6

