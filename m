Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933185Ab3BZX6l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 18:58:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42260 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933053Ab3BZX6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:58:31 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>,
        Amir Vadai <amirv@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 134/150] mlx4_en: fix allocation of CPU affinity reverse-map
Date: Tue, 26 Feb 2013 15:56:31 -0800
Message-Id: <20130226235538.152295835@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>

[ Upstream commit 3770699675dd1b8fc1e86ff369eb3cce44e10082 ]

The mlx4_en driver allocates the number of objects for the CPU affinity
reverse-map based on the number of rx rings of the device. However,
mlx4_assign_eq() calls irq_cpu_rmap_add() as many times as IRQ's are
assigned to EQ's, which can be as large as mlx4_dev->caps.comp_pool. If
caps.comp_pool is larger than rx_ring_num we will eventually hit the
BUG_ON() in cpu_rmap_add().

Fix this problem by allocating space for the maximum number of CPU
affinity reverse-map objects we might want to add.

Signed-off-by: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
Acked-by: Amir Vadai <amirv@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -1434,7 +1434,7 @@ int mlx4_en_alloc_resources(struct mlx4_
 	}
 
 #ifdef CONFIG_RFS_ACCEL
-	priv->dev->rx_cpu_rmap = alloc_irq_cpu_rmap(priv->rx_ring_num);
+	priv->dev->rx_cpu_rmap = alloc_irq_cpu_rmap(priv->mdev->dev->caps.comp_pool);
 	if (!priv->dev->rx_cpu_rmap)
 		goto err;
 


