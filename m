Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757Ab3LBUDO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:03:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39149 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505Ab3LBTRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:17:54 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vu Pham <vu@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.12 093/212] iser-target: Avoid using FRMR for single dma entry requests
Date: Mon,  2 Dec 2013 11:14:44 -0800
Message-Id: <20131202191257.897405691@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vu Pham <vu@mellanox.com>

commit f01b9f73392b48c6cda7c2c66594c73137c776da upstream.

This patch changes isert_reg_rdma_frwr() to not use FRMR for single
dma entry requests from small I/Os, in order to avoid the associated
memory registration overhead.

Using DMA MR is sufficient here for the single dma entry requests,
and addresses a >= v3.12 performance regression.

Signed-off-by: Vu Pham <vu@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/ulp/isert/ib_isert.c |   30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -2259,18 +2259,26 @@ isert_reg_rdma_frwr(struct iscsi_conn *c
 	data_len = min(data_left, rdma_write_max);
 	wr->cur_rdma_length = data_len;
 
-	spin_lock_irqsave(&isert_conn->conn_lock, flags);
-	fr_desc = list_first_entry(&isert_conn->conn_frwr_pool,
-				   struct fast_reg_descriptor, list);
-	list_del(&fr_desc->list);
-	spin_unlock_irqrestore(&isert_conn->conn_lock, flags);
-	wr->fr_desc = fr_desc;
+	/* if there is a single dma entry, dma mr is sufficient */
+	if (count == 1) {
+		ib_sge->addr = ib_sg_dma_address(ib_dev, &sg_start[0]);
+		ib_sge->length = ib_sg_dma_len(ib_dev, &sg_start[0]);
+		ib_sge->lkey = isert_conn->conn_mr->lkey;
+		wr->fr_desc = NULL;
+	} else {
+		spin_lock_irqsave(&isert_conn->conn_lock, flags);
+		fr_desc = list_first_entry(&isert_conn->conn_frwr_pool,
+					   struct fast_reg_descriptor, list);
+		list_del(&fr_desc->list);
+		spin_unlock_irqrestore(&isert_conn->conn_lock, flags);
+		wr->fr_desc = fr_desc;
 
-	ret = isert_fast_reg_mr(fr_desc, isert_cmd, isert_conn,
-			  ib_sge, offset, data_len);
-	if (ret) {
-		list_add_tail(&fr_desc->list, &isert_conn->conn_frwr_pool);
-		goto unmap_sg;
+		ret = isert_fast_reg_mr(fr_desc, isert_cmd, isert_conn,
+				  ib_sge, offset, data_len);
+		if (ret) {
+			list_add_tail(&fr_desc->list, &isert_conn->conn_frwr_pool);
+			goto unmap_sg;
+		}
 	}
 
 	return 0;


