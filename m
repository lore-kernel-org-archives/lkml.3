Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759023AbbAYTDV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 14:03:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57551 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755450AbbAYSJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:09:35 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Wei Yang <weiyang@linux.vnet.ibm.com>, Ido Shamay <idos@mellanox.com>,
        Amir Vadai <amirv@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.18 002/183] net/mlx4: Cache line CQE/EQE stride fixes
Date: Sun, 25 Jan 2015 10:05:24 -0800
Message-Id: <20150125180810.285417125@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Shamay <idos@mellanox.com>

[ Upstream commit c3f2511feac088030055012cc8f64ebd84c87dbc ]

This commit contains 2 fixes for the 128B CQE/EQE stride feaure.
Wei found that mlx4_QUERY_HCA function marked the wrong capability
in flags (64B CQE/EQE), when CQE/EQE stride feature was enabled.
Also added small fix in initial CQE ownership bit assignment, when CQE
is size is not default 32B.

Fixes: 77507aa24 (net/mlx4: Enable CQE/EQE stride support)
Signed-off-by: Wei Yang <weiyang@linux.vnet.ibm.com>
Signed-off-by: Ido Shamay <idos@mellanox.com>
Signed-off-by: Amir Vadai <amirv@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c |   11 +++++++++--
 drivers/net/ethernet/mellanox/mlx4/fw.c        |    4 ++--
 2 files changed, 11 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -1569,8 +1569,15 @@ int mlx4_en_start_port(struct net_device
 			mlx4_en_free_affinity_hint(priv, i);
 			goto cq_err;
 		}
-		for (j = 0; j < cq->size; j++)
-			cq->buf[j].owner_sr_opcode = MLX4_CQE_OWNER_MASK;
+
+		for (j = 0; j < cq->size; j++) {
+			struct mlx4_cqe *cqe = NULL;
+
+			cqe = mlx4_en_get_cqe(cq->buf, j, priv->cqe_size) +
+			      priv->cqe_factor;
+			cqe->owner_sr_opcode = MLX4_CQE_OWNER_MASK;
+		}
+
 		err = mlx4_en_set_cq_moder(priv, cq);
 		if (err) {
 			en_err(priv, "Failed setting cq moderation parameters\n");
--- a/drivers/net/ethernet/mellanox/mlx4/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx4/fw.c
@@ -1647,8 +1647,8 @@ int mlx4_QUERY_HCA(struct mlx4_dev *dev,
 	/* CX3 is capable of extending CQEs\EQEs to strides larger than 64B */
 	MLX4_GET(byte_field, outbox, INIT_HCA_EQE_CQE_STRIDE_OFFSET);
 	if (byte_field) {
-		param->dev_cap_enabled |= MLX4_DEV_CAP_64B_EQE_ENABLED;
-		param->dev_cap_enabled |= MLX4_DEV_CAP_64B_CQE_ENABLED;
+		param->dev_cap_enabled |= MLX4_DEV_CAP_EQE_STRIDE_ENABLED;
+		param->dev_cap_enabled |= MLX4_DEV_CAP_CQE_STRIDE_ENABLED;
 		param->cqe_size = 1 << ((byte_field &
 					 MLX4_CQE_SIZE_MASK_STRIDE) + 5);
 		param->eqe_size = 1 << (((byte_field &


