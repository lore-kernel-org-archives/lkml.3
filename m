Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846AbaLNUWo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 15:22:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52832 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbaLNUVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 15:21:39 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jack Morgenstein <jackm@dev.mellanox.co.il>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 15/24] net/mlx4_core: Limit count field to 24 bits in qp_alloc_res
Date: Sun, 14 Dec 2014 12:20:35 -0800
Message-Id: <20141214201801.131334584@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141214201800.613573495@linuxfoundation.org>
References: <20141214201800.613573495@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx4/resource_tracker.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
+++ b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
@@ -1207,7 +1207,7 @@ static int qp_alloc_res(struct mlx4_dev
 
 	switch (op) {
 	case RES_OP_RESERVE:
-		count = get_param_l(&in_param);
+		count = get_param_l(&in_param) & 0xffffff;
 		align = get_param_h(&in_param);
 		err = __mlx4_qp_reserve_range(dev, count, align, &base);
 		if (err)


