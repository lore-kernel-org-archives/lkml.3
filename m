Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796AbaDALS3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:18:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42625 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbaDALSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:18:25 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Or Gerlitz <ogerlitz@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 108/144] iser-target: Fix post_send_buf_count for RDMA READ/WRITE
Date: Tue,  1 Apr 2014 12:15:12 +0100
Message-Id: <1396350948-29910-109-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit b6b87a1df604678ed1be40158080db012a99ccca upstream.

This patch fixes the incorrect setting of ->post_send_buf_count
related to RDMA WRITEs + READs where isert_rdma_rw->send_wr_num
was not being taken into account.

This includes incrementing ->post_send_buf_count within
isert_put_datain() + isert_get_dataout(), decrementing within
__isert_send_completion() + isert_response_completion(), and
clearing wr->send_wr_num within isert_completion_rdma_read()

This is necessary because even though IB_SEND_SIGNALED is
not set for RDMA WRITEs + READs, during a QP failure event
the work requests will be returned with exception status
from the TX completion queue.

Acked-by: Sagi Grimberg <sagig@mellanox.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 57a01df..5430b4a 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -1374,6 +1374,7 @@ isert_completion_rdma_read(struct iser_tx_desc *tx_desc,
 	}
 
 	cmd->write_data_done = se_cmd->data_length;
+	wr->send_wr_num = 0;
 
 	pr_debug("isert_do_rdma_read_comp, calling target_execute_cmd\n");
 	spin_lock_bh(&cmd->istate_lock);
@@ -1438,6 +1439,7 @@ isert_response_completion(struct iser_tx_desc *tx_desc,
 			  struct ib_device *ib_dev)
 {
 	struct iscsi_cmd *cmd = &isert_cmd->iscsi_cmd;
+	struct isert_rdma_wr *wr = &isert_cmd->rdma_wr;
 
 	if (cmd->i_state == ISTATE_SEND_TASKMGTRSP ||
 	    cmd->i_state == ISTATE_SEND_LOGOUTRSP ||
@@ -1449,7 +1451,7 @@ isert_response_completion(struct iser_tx_desc *tx_desc,
 		queue_work(isert_comp_wq, &isert_cmd->comp_work);
 		return;
 	}
-	atomic_dec(&isert_conn->post_send_buf_count);
+	atomic_sub(wr->send_wr_num + 1, &isert_conn->post_send_buf_count);
 
 	cmd->i_state = ISTATE_SENT_STATUS;
 	isert_completion_put(tx_desc, isert_cmd, ib_dev);
@@ -1487,7 +1489,7 @@ isert_send_completion(struct iser_tx_desc *tx_desc,
 	case ISER_IB_RDMA_READ:
 		pr_debug("isert_send_completion: Got ISER_IB_RDMA_READ:\n");
 
-		atomic_dec(&isert_conn->post_send_buf_count);
+		atomic_sub(wr->send_wr_num, &isert_conn->post_send_buf_count);
 		isert_completion_rdma_read(tx_desc, isert_cmd);
 		break;
 	default:
@@ -1951,12 +1953,12 @@ isert_put_datain(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
 	isert_init_tx_hdrs(isert_conn, &isert_cmd->tx_desc);
 	isert_init_send_wr(isert_cmd, &isert_cmd->tx_desc.send_wr);
 
-	atomic_inc(&isert_conn->post_send_buf_count);
+	atomic_add(wr->send_wr_num + 1, &isert_conn->post_send_buf_count);
 
 	rc = ib_post_send(isert_conn->conn_qp, wr->send_wr, &wr_failed);
 	if (rc) {
 		pr_warn("ib_post_send() failed for IB_WR_RDMA_WRITE\n");
-		atomic_dec(&isert_conn->post_send_buf_count);
+		atomic_sub(wr->send_wr_num + 1, &isert_conn->post_send_buf_count);
 	}
 	pr_debug("Posted RDMA_WRITE + Response for iSER Data READ\n");
 	return 1;
@@ -2059,12 +2061,12 @@ isert_get_dataout(struct iscsi_conn *conn, struct iscsi_cmd *cmd, bool recovery)
 		data_left -= data_len;
 	}
 
-	atomic_inc(&isert_conn->post_send_buf_count);
+	atomic_add(wr->send_wr_num, &isert_conn->post_send_buf_count);
 
 	rc = ib_post_send(isert_conn->conn_qp, wr->send_wr, &wr_failed);
 	if (rc) {
 		pr_warn("ib_post_send() failed for IB_WR_RDMA_READ\n");
-		atomic_dec(&isert_conn->post_send_buf_count);
+		atomic_sub(wr->send_wr_num, &isert_conn->post_send_buf_count);
 	}
 	pr_debug("Posted RDMA_READ memory for ISER Data WRITE\n");
 	return 0;
-- 
1.9.1

