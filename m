Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933502AbaFIOgj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 10:36:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38274 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932628AbaFIOgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 10:36:36 -0400
Date: Mon, 9 Jun 2014 16:36:33 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Roland Dreier <roland@kernel.org>, Roland Dreier <roland@purestorage.com>,
        Or Gerlitz <ogerlitz@mellanox.com>
cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] IB/mlx4: fix gfp passing in create_qp_common()
Message-ID: <alpine.LNX.2.00.1406091634480.20782@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two kzalloc() calls which were not converted to use value of gfp 
passed to create_qp_common() instead of using hardcoded GFP_KERNEL in 
40f2287bd583 ("IB/mlx4: Implement IB_QP_CREATE_USE_GFP_NOIO"). Fix this by 
passing gfp value down properly.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 drivers/infiniband/hw/mlx4/qp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 78fc4c3..5b0cb8e 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -674,14 +674,14 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 		if (qp_type == MLX4_IB_QPT_SMI || qp_type == MLX4_IB_QPT_GSI ||
 		    (qp_type & (MLX4_IB_QPT_PROXY_SMI | MLX4_IB_QPT_PROXY_SMI_OWNER |
 				MLX4_IB_QPT_PROXY_GSI | MLX4_IB_QPT_TUN_SMI_OWNER))) {
-			sqp = kzalloc(sizeof (struct mlx4_ib_sqp), GFP_KERNEL);
+			sqp = kzalloc(sizeof (struct mlx4_ib_sqp), gfp);
 			if (!sqp)
 				return -ENOMEM;
 			qp = &sqp->qp;
 			qp->pri.vid = 0xFFFF;
 			qp->alt.vid = 0xFFFF;
 		} else {
-			qp = kzalloc(sizeof (struct mlx4_ib_qp), GFP_KERNEL);
+			qp = kzalloc(sizeof (struct mlx4_ib_qp), gfp);
 			if (!qp)
 				return -ENOMEM;
 			qp->pri.vid = 0xFFFF;
-- 
Jiri Kosina
SUSE Labs
