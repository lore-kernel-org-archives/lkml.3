Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308AbaLOTcU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 14:32:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40908 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbaLOTcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 14:32:16 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jack Morgenstein <jackm@dev.mellanox.co.il>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 91/96] net/mlx4_core: Limit count field to 24 bits in qp_alloc_res
Date: Mon, 15 Dec 2014 11:26:51 -0800
Message-Id: <1418671616-25482-92-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418671616-25482-1-git-send-email-kamal@canonical.com>
References: <1418671616-25482-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jack Morgenstein <jackm@dev.mellanox.co.il>

[ Upstream commit 2d5c57d7fbfaa642fb7f0673df24f32b83d9066c ]

Some VF drivers use the upper byte of "param1" (the qp count field)
in mlx4_qp_reserve_range() to pass flags which are used to optimize
the range allocation.

Under the current code, if any of these flags are set, the 32-bit
count field yields a count greater than 2^24, which is out of range,
and this VF fails.

As these flags represent a "best-effort" allocation hint anyway, they may
safely be ignored. Therefore, the PF driver may simply mask out the bits.

Fixes: c82e9aa0a8 "mlx4_core: resource tracking for HCA resources used by guests"
Signed-off-by: Jack Morgenstein <jackm@dev.mellanox.co.il>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/ethernet/mellanox/mlx4/resource_tracker.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
index 2f3f2bc..2a2e17c 100644
--- a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
+++ b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
@@ -1484,7 +1484,7 @@ static int qp_alloc_res(struct mlx4_dev *dev, int slave, int op, int cmd,
 
 	switch (op) {
 	case RES_OP_RESERVE:
-		count = get_param_l(&in_param);
+		count = get_param_l(&in_param) & 0xffffff;
 		align = get_param_h(&in_param);
 		err = mlx4_grant_resource(dev, slave, RES_QP, count, 0);
 		if (err)
-- 
1.9.1

