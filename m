Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758840Ab3HBKHs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:07:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37038 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758719Ab3HBKHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:07:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Mike Christie <michaelc@cs.wisc.edu>
Subject: [ 02/99] iser-target: Fix isert_put_reject payload buffer post
Date: Fri,  2 Aug 2013 18:07:15 +0800
Message-Id: <20130802100225.829303813@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.4.841.g1a3f60e
In-Reply-To: <20130802100225.478715166@linuxfoundation.org>
References: <20130802100225.478715166@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit 3df8f68aaf7ebe3d136a22262b41b350b0a1858b upstream.

This patch adds the missing isert_put_reject() logic to post
a outgoing payload buffer to hold the 48 bytes of original PDU
header request payload for the rejected cmd.

It also fixes ISTATE_SEND_REJECT handling in isert_response_completion()
-> isert_do_control_comp() code, and drops incorrect iscsi_cmd_t->reject_comp
usage.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/ulp/isert/ib_isert.c |   26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -1222,6 +1222,9 @@ isert_put_cmd(struct isert_cmd *isert_cm
 		 * associated cmd->se_cmd needs to be released.
 		 */
 		if (cmd->se_cmd.se_tfo != NULL) {
+			pr_debug("Calling transport_generic_free_cmd from"
+				 " isert_put_cmd for 0x%02x\n",
+				 cmd->iscsi_opcode);
 			transport_generic_free_cmd(&cmd->se_cmd, 0);
 			break;
 		}
@@ -1318,8 +1321,8 @@ isert_do_control_comp(struct work_struct
 		atomic_dec(&isert_conn->post_send_buf_count);
 
 		cmd->i_state = ISTATE_SENT_STATUS;
-		complete(&cmd->reject_comp);
 		isert_completion_put(&isert_cmd->tx_desc, isert_cmd, ib_dev);
+		break;
 	case ISTATE_SEND_LOGOUTRSP:
 		pr_debug("Calling iscsit_logout_post_handler >>>>>>>>>>>>>>\n");
 		/*
@@ -1345,7 +1348,8 @@ isert_response_completion(struct iser_tx
 	struct iscsi_cmd *cmd = &isert_cmd->iscsi_cmd;
 
 	if (cmd->i_state == ISTATE_SEND_TASKMGTRSP ||
-	    cmd->i_state == ISTATE_SEND_LOGOUTRSP) {
+	    cmd->i_state == ISTATE_SEND_LOGOUTRSP ||
+	    cmd->i_state == ISTATE_SEND_REJECT) {
 		isert_unmap_tx_desc(tx_desc, ib_dev);
 
 		INIT_WORK(&isert_cmd->comp_work, isert_do_control_comp);
@@ -1637,11 +1641,25 @@ isert_put_reject(struct iscsi_cmd *cmd,
 				struct isert_cmd, iscsi_cmd);
 	struct isert_conn *isert_conn = (struct isert_conn *)conn->context;
 	struct ib_send_wr *send_wr = &isert_cmd->tx_desc.send_wr;
+	struct ib_device *ib_dev = isert_conn->conn_cm_id->device;
+	struct ib_sge *tx_dsg = &isert_cmd->tx_desc.tx_sg[1];
+	struct iscsi_reject *hdr =
+		(struct iscsi_reject *)&isert_cmd->tx_desc.iscsi_header;
 
 	isert_create_send_desc(isert_conn, isert_cmd, &isert_cmd->tx_desc);
-	iscsit_build_reject(cmd, conn, (struct iscsi_reject *)
-				&isert_cmd->tx_desc.iscsi_header);
+	iscsit_build_reject(cmd, conn, hdr);
 	isert_init_tx_hdrs(isert_conn, &isert_cmd->tx_desc);
+
+	hton24(hdr->dlength, ISCSI_HDR_LEN);
+	isert_cmd->sense_buf_dma = ib_dma_map_single(ib_dev,
+			(void *)cmd->buf_ptr, ISCSI_HDR_LEN,
+			DMA_TO_DEVICE);
+	isert_cmd->sense_buf_len = ISCSI_HDR_LEN;
+	tx_dsg->addr	= isert_cmd->sense_buf_dma;
+	tx_dsg->length	= ISCSI_HDR_LEN;
+	tx_dsg->lkey	= isert_conn->conn_mr->lkey;
+	isert_cmd->tx_desc.num_sge = 2;
+
 	isert_init_send_wr(isert_cmd, send_wr);
 
 	pr_debug("Posting Reject IB_WR_SEND >>>>>>>>>>>>>>>>>>>>>>\n");


