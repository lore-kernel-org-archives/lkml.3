Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab3LBTSd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:18:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39469 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620Ab3LBTSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:18:21 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Moussa Ba <moussaba@micron.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.12 141/212] ib_isert: Avoid duplicate iscsit_increment_maxcmdsn call
Date: Mon,  2 Dec 2013 11:15:32 -0800
Message-Id: <20131202191302.840082638@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit 04d9cd1224e5bc9d6146bab2866cdc81deb9b509 upstream.

This patch avoids a duplicate iscsit_increment_maxcmdsn() call for
ISER_IB_RDMA_WRITE within isert_map_rdma() + isert_reg_rdma_frwr(),
which will already be occuring once during isert_put_datain() ->
iscsit_build_rsp_pdu() operation.

It also removes the local conn->stat_sn assignment + increment,
and changes the third parameter to iscsit_build_rsp_pdu() to
signal this should be done by iscsi_target_mode code.

Tested-by: Moussa Ba <moussaba@micron.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/ulp/isert/ib_isert.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -1991,8 +1991,6 @@ isert_map_rdma(struct iscsi_conn *conn,
 
 	if (wr->iser_ib_op == ISER_IB_RDMA_WRITE) {
 		data_left = se_cmd->data_length;
-		iscsit_increment_maxcmdsn(cmd, conn->sess);
-		cmd->stat_sn = conn->stat_sn++;
 	} else {
 		sg_off = cmd->write_data_done / PAGE_SIZE;
 		data_left = se_cmd->data_length - cmd->write_data_done;
@@ -2204,8 +2202,6 @@ isert_reg_rdma_frwr(struct iscsi_conn *c
 
 	if (wr->iser_ib_op == ISER_IB_RDMA_WRITE) {
 		data_left = se_cmd->data_length;
-		iscsit_increment_maxcmdsn(cmd, conn->sess);
-		cmd->stat_sn = conn->stat_sn++;
 	} else {
 		sg_off = cmd->write_data_done / PAGE_SIZE;
 		data_left = se_cmd->data_length - cmd->write_data_done;
@@ -2314,7 +2310,7 @@ isert_put_datain(struct iscsi_conn *conn
 	 * Build isert_conn->tx_desc for iSCSI response PDU and attach
 	 */
 	isert_create_send_desc(isert_conn, isert_cmd, &isert_cmd->tx_desc);
-	iscsit_build_rsp_pdu(cmd, conn, false, (struct iscsi_scsi_rsp *)
+	iscsit_build_rsp_pdu(cmd, conn, true, (struct iscsi_scsi_rsp *)
 			     &isert_cmd->tx_desc.iscsi_header);
 	isert_init_tx_hdrs(isert_conn, &isert_cmd->tx_desc);
 	isert_init_send_wr(isert_cmd, &isert_cmd->tx_desc.send_wr);


