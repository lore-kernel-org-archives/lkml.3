Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757179Ab3CRVw0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:52:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45644 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755528Ab3CRVHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:07:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Yan Burman <yanb@mellanox.com>,
        Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>,
        Amir Vadai <amirv@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 52/75] net/mlx4_en: Disable RFS when running in SRIOV mode
Date: Mon, 18 Mar 2013 14:07:15 -0700
Message-Id: <20130318210514.000944275@linuxfoundation.org>
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

commit a229e488ac3f904d06c20d8d3f47831db3c7a15a upstream.

Commit 37706996 "mlx4_en: fix allocation of CPU affinity reverse-map" fixed
a bug when mlx4_dev->caps.comp_pool is larger from the device rx rings, but
introduced a regression.

When the mlx4_core is activating its "legacy mode" (e.g when running in SRIOV
mode) w.r.t to EQs/IRQs usage, comp_pool becomes zero and we're crashing on
divide by zero alloc_cpu_rmap.

Fix that by enabling RFS only when running in non-legacy mode.

Reported-by: Yan Burman <yanb@mellanox.com>
Cc: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
Signed-off-by: Amir Vadai <amirv@mellanox.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -1434,9 +1434,11 @@ int mlx4_en_alloc_resources(struct mlx4_
 	}
 
 #ifdef CONFIG_RFS_ACCEL
-	priv->dev->rx_cpu_rmap = alloc_irq_cpu_rmap(priv->mdev->dev->caps.comp_pool);
-	if (!priv->dev->rx_cpu_rmap)
-		goto err;
+	if (priv->mdev->dev->caps.comp_pool) {
+		priv->dev->rx_cpu_rmap = alloc_irq_cpu_rmap(priv->mdev->dev->caps.comp_pool);
+		if (!priv->dev->rx_cpu_rmap)
+			goto err;
+	}
 #endif
 
 	return 0;


