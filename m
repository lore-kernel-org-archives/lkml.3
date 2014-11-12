Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976AbaKLBU1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:20:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58391 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954AbaKLBUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:20:24 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Or Gerlitz <ogerlitz@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.17 021/319] mlx4: Avoid leaking steering rules on flow creation error flow
Date: Wed, 12 Nov 2014 10:12:39 +0900
Message-Id: <20141112010956.206851732@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Or Gerlitz <ogerlitz@mellanox.com>

[ Upstream commit 571e1b2c7a4c2fd5faa1648462a6b65fa26530d7 ]

If mlx4_ib_create_flow() attempts to create > 1 rules with the
firmware, and one of these registrations fail, we leaked the
already created flow rules.

One example of the leak is when the registration of the VXLAN ghost
steering rule fails, we didn't unregister the original rule requested
by the user, introduced in commit d2fce8a9060d "mlx4: Set
user-space raw Ethernet QPs to properly handle VXLAN traffic".

While here, add dump of the VXLAN portion of steering rules
so it can actually be seen when flow creation fails.

Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/mlx4/main.c        |   10 ++++++++--
 drivers/net/ethernet/mellanox/mlx4/mcg.c |    4 ++++
 2 files changed, 12 insertions(+), 2 deletions(-)

--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1173,18 +1173,24 @@ static struct ib_flow *mlx4_ib_create_fl
 		err = __mlx4_ib_create_flow(qp, flow_attr, domain, type[i],
 					    &mflow->reg_id[i]);
 		if (err)
-			goto err_free;
+			goto err_create_flow;
 		i++;
 	}
 
 	if (i < ARRAY_SIZE(type) && flow_attr->type == IB_FLOW_ATTR_NORMAL) {
 		err = mlx4_ib_tunnel_steer_add(qp, flow_attr, &mflow->reg_id[i]);
 		if (err)
-			goto err_free;
+			goto err_create_flow;
+		i++;
 	}
 
 	return &mflow->ibflow;
 
+err_create_flow:
+	while (i) {
+		(void)__mlx4_ib_destroy_flow(to_mdev(qp->device)->dev, mflow->reg_id[i]);
+		i--;
+	}
 err_free:
 	kfree(mflow);
 	return ERR_PTR(err);
--- a/drivers/net/ethernet/mellanox/mlx4/mcg.c
+++ b/drivers/net/ethernet/mellanox/mlx4/mcg.c
@@ -955,6 +955,10 @@ static void mlx4_err_rule(struct mlx4_de
 					cur->ib.dst_gid_msk);
 			break;
 
+		case MLX4_NET_TRANS_RULE_ID_VXLAN:
+			len += snprintf(buf + len, BUF_SIZE - len,
+					"VNID = %d ", be32_to_cpu(cur->vxlan.vni));
+			break;
 		case MLX4_NET_TRANS_RULE_ID_IPV6:
 			break;
 


