Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934038Ab3CRVwj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:52:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45662 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755684Ab3CRVHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:07:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Amir Vadai <amirv@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Or Gerlitz <ogerlitz@mellanox.com>
Subject: [ 51/75] net/mlx4_en: Initialize RFS filters lock and list in init_netdev
Date: Mon, 18 Mar 2013 14:07:14 -0700
Message-Id: <20130318210513.939189383@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130318210510.203500214@linuxfoundation.org>
References: <20130318210510.203500214@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Vadai <amirv@mellanox.com>

commit 78fb2de711ec28997bf38bcf3e48e108e907be77 upstream.

filters_lock might have been used while it was re-initialized.
Moved filters_lock and filters_list initialization to init_netdev instead of
alloc_resources which is called every time the device is configured.

Signed-off-by: Amir Vadai <amirv@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -1437,9 +1437,6 @@ int mlx4_en_alloc_resources(struct mlx4_
 	priv->dev->rx_cpu_rmap = alloc_irq_cpu_rmap(priv->mdev->dev->caps.comp_pool);
 	if (!priv->dev->rx_cpu_rmap)
 		goto err;
-
-	INIT_LIST_HEAD(&priv->filters);
-	spin_lock_init(&priv->filters_lock);
 #endif
 
 	return 0;
@@ -1634,6 +1631,11 @@ int mlx4_en_init_netdev(struct mlx4_en_d
 	if (err)
 		goto out;
 
+#ifdef CONFIG_RFS_ACCEL
+	INIT_LIST_HEAD(&priv->filters);
+	spin_lock_init(&priv->filters_lock);
+#endif
+
 	/* Allocate page for receive rings */
 	err = mlx4_alloc_hwq_res(mdev->dev, &priv->res,
 				MLX4_EN_PAGE_SIZE, MLX4_EN_PAGE_SIZE);


