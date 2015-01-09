Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757651AbbAIKeh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:34:37 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44620 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757518AbbAIKca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:32:30 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jack Morgenstein <jackm@dev.mellanox.co.il>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 04/78] net/mlx4_core: Limit count field to 24 bits in qp_alloc_res
Date: Fri,  9 Jan 2015 11:31:13 +0100
Message-Id: <0b79861fc455782afb8f490d9e2e9102fa196bc2.1420799385.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
References: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
In-Reply-To: <cover.1420799385.git.jslaby@suse.cz>
References: <cover.1420799385.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Morgenstein <jackm@dev.mellanox.co.il>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/ethernet/mellanox/mlx4/resource_tracker.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
index dd6876321116..cdbe63712d2d 100644
--- a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
+++ b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
@@ -1227,7 +1227,7 @@ static int qp_alloc_res(struct mlx4_dev *dev, int slave, int op, int cmd,
 
 	switch (op) {
 	case RES_OP_RESERVE:
-		count = get_param_l(&in_param);
+		count = get_param_l(&in_param) & 0xffffff;
 		align = get_param_h(&in_param);
 		err = __mlx4_qp_reserve_range(dev, count, align, &base);
 		if (err)
-- 
2.2.1

