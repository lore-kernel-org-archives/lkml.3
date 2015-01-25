Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483AbbAYTBL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 14:01:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57780 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755496AbbAYSJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:09:38 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Maor Gottlieb <maorg@mellanox.com>, Matan Barak <matanb@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.18 020/183] net/mlx4_core: Correcly update the mtts offset in the MR re-reg flow
Date: Sun, 25 Jan 2015 10:05:42 -0800
Message-Id: <20150125180811.053924219@linuxfoundation.org>
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

From: Maor Gottlieb <maorg@mellanox.com>

[ Upstream commit a51e0df4c1e06afd7aba84496c14238e6b363caa ]

Previously, mlx4_mt_rereg_write filled the MPT's entity_size with the
old MTT's page shift, which could result in using an incorrect offset.
Fix the initialization to be after we calculate the new MTT offset.

In addition, assign mtt order to -1 after calling mlx4_mtt_cleanup. This
is necessary in order to mark the MTT as invalid and avoid freeing it later.

Fixes: e630664 ('mlx4_core: Add helper functions to support MR re-registration')
Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Matan Barak <matanb@mellanox.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx4/mr.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx4/mr.c
+++ b/drivers/net/ethernet/mellanox/mlx4/mr.c
@@ -590,6 +590,7 @@ EXPORT_SYMBOL_GPL(mlx4_mr_free);
 void mlx4_mr_rereg_mem_cleanup(struct mlx4_dev *dev, struct mlx4_mr *mr)
 {
 	mlx4_mtt_cleanup(dev, &mr->mtt);
+	mr->mtt.order = -1;
 }
 EXPORT_SYMBOL_GPL(mlx4_mr_rereg_mem_cleanup);
 
@@ -599,14 +600,14 @@ int mlx4_mr_rereg_mem_write(struct mlx4_
 {
 	int err;
 
-	mpt_entry->start       = cpu_to_be64(iova);
-	mpt_entry->length      = cpu_to_be64(size);
-	mpt_entry->entity_size = cpu_to_be32(page_shift);
-
 	err = mlx4_mtt_init(dev, npages, page_shift, &mr->mtt);
 	if (err)
 		return err;
 
+	mpt_entry->start       = cpu_to_be64(mr->iova);
+	mpt_entry->length      = cpu_to_be64(mr->size);
+	mpt_entry->entity_size = cpu_to_be32(mr->mtt.page_shift);
+
 	mpt_entry->pd_flags &= cpu_to_be32(MLX4_MPT_PD_MASK |
 					   MLX4_MPT_PD_FLAG_EN_INV);
 	mpt_entry->flags    &= cpu_to_be32(MLX4_MPT_FLAG_FREE |


