Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760666AbaCUBJt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 21:09:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36718 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965167AbaCUAEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:04:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.13 094/149] iser-target: Fix post_send_buf_count for RDMA READ/WRITE
Date: Thu, 20 Mar 2014 17:04:17 -0700
Message-Id: <20140321000440.213026135@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/ulp/isert/ib_isert.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -1532,6 +1532,7 @@ isert_completion_rdma_read(struct iser_t
 	iscsit_stop_dataout_timer(cmd);
 	device->unreg_rdma_mem(isert_cmd, isert_conn);
 	cmd->write_data_done = wr->cur_rdma_length;
+	wr->send_wr_num = 0;
 
 	pr_debug("Cmd: %p RDMA_READ comp calling execute_cmd\n", isert_cmd);
 	spin_lock_bh(&cmd->istate_lock);
@@ -1596,6 +1597,7 @@ isert_response_completion(struct iser_tx
 			  struct ib_device *ib_dev)
 {
 	struct iscsi_cmd *cmd = isert_cmd->iscsi_cmd;
+	struct isert_rdma_wr *wr = &isert_cmd->rdma_wr;
 
 	if (cmd->i_state == ISTATE_SEND_TASKMGTRSP ||
 	    cmd->i_state == ISTATE_SEND_LOGOUTRSP ||
@@ -1607,7 +1609,7 @@ isert_response_completion(struct iser_tx
 		queue_work(isert_comp_wq, &isert_cmd->comp_work);
 		return;
 	}
-	atomic_dec(&isert_conn->post_send_buf_count);
+	atomic_sub(wr->send_wr_num + 1, &isert_conn->post_send_buf_count);
 
 	cmd->i_state = ISTATE_SENT_STATUS;
 	isert_completion_put(tx_desc, isert_cmd, ib_dev);
@@ -1645,7 +1647,7 @@ __isert_send_completion(struct iser_tx_d
 	case ISER_IB_RDMA_READ:
 		pr_debug("isert_send_completion: Got ISER_IB_RDMA_READ:\n");
 
-		atomic_dec(&isert_conn->post_send_buf_count);
+		atomic_sub(wr->send_wr_num, &isert_conn->post_send_buf_count);
 		isert_completion_rdma_read(tx_desc, isert_cmd);
 		break;
 	default:
@@ -2377,12 +2379,12 @@ isert_put_datain(struct iscsi_conn *conn
 	isert_init_send_wr(isert_conn, isert_cmd,
 			   &isert_cmd->tx_desc.send_wr, true);
 
-	atomic_inc(&isert_conn->post_send_buf_count);
+	atomic_add(wr->send_wr_num + 1, &isert_conn->post_send_buf_count);
 
 	rc = ib_post_send(isert_conn->conn_qp, wr->send_wr, &wr_failed);
 	if (rc) {
 		pr_warn("ib_post_send() failed for IB_WR_RDMA_WRITE\n");
-		atomic_dec(&isert_conn->post_send_buf_count);
+		atomic_sub(wr->send_wr_num + 1, &isert_conn->post_send_buf_count);
 	}
 	pr_debug("Cmd: %p posted RDMA_WRITE + Response for iSER Data READ\n",
 		 isert_cmd);
@@ -2410,12 +2412,12 @@ isert_get_dataout(struct iscsi_conn *con
 		return rc;
 	}
 
-	atomic_inc(&isert_conn->post_send_buf_count);
+	atomic_add(wr->send_wr_num, &isert_conn->post_send_buf_count);
 
 	rc = ib_post_send(isert_conn->conn_qp, wr->send_wr, &wr_failed);
 	if (rc) {
 		pr_warn("ib_post_send() failed for IB_WR_RDMA_READ\n");
-		atomic_dec(&isert_conn->post_send_buf_count);
+		atomic_sub(wr->send_wr_num, &isert_conn->post_send_buf_count);
 	}
 	pr_debug("Cmd: %p posted RDMA_READ memory for ISER Data WRITE\n",
 		 isert_cmd);


