Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210Ab3CZRpq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:45:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21945 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170Ab3CZRgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:21 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=ASFqcrq1eywA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=4Ohr-eZgTLYA:10 a=VnNF1IyMAAAA:8 a=CbDCq_QkAAAA:8 a=J1Y8HTJGAAAA:8 a=QH10y-6sWg32Ox54Xh4A:9 a=E3yz0KKPV6YA:10 a=4N9Db7Z2_RYA:10 a=88X0TAY6dXWGbp3x:21 a=cMljXEUzV-ykQfGl:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173613.383713136@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:22:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>,
        Amir Vadai <amirv@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 85/86] mlx4_en: fix allocation of CPU affinity reverse-map
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0085-mlx4_en-fix-allocation-of-CPU-affinity-reverse-map.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>

[ Upstream commit 77c5d9e186705280ca6eff08f3280a5f70c79f8e ]

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
---
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index edd9cb8..aa9122f 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -1435,7 +1435,7 @@ int mlx4_en_alloc_resources(struct mlx4_en_priv *priv)
 	}
 
 #ifdef CONFIG_RFS_ACCEL
-	priv->dev->rx_cpu_rmap = alloc_irq_cpu_rmap(priv->rx_ring_num);
+	priv->dev->rx_cpu_rmap = alloc_irq_cpu_rmap(priv->mdev->dev->caps.comp_pool);
 	if (!priv->dev->rx_cpu_rmap)
 		goto err;
 
-- 
1.7.10.4


