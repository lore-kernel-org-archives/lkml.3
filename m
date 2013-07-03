Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964863Ab3GCQxl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 12:53:41 -0400
Received: from longford.logfs.org ([213.229.74.203]:59734 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932895Ab3GCQxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 12:53:39 -0400
From: Joern Engel <joern@logfs.org>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-kernel@vger.kernel.org, target-devel <target-devel@vger.kernel.org>,
        Joern Engel <joern@logfs.org>
Subject: [PATCH 3/3] target: make queue_tm_rsp() return void
Date: Wed,  3 Jul 2013 11:22:17 -0400
Message-Id: <1372864937-32437-4-git-send-email-joern@logfs.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1372864937-32437-1-git-send-email-joern@logfs.org>
References: <1372864937-32437-1-git-send-email-joern@logfs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The return value wasn't checked by any of the callers.  Assuming this is
correct behaviour, we can simplify some code by not bothering to
generate it.

Signed-off-by: Joern Engel <joern@logfs.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c        |   14 +++++---------
 drivers/scsi/qla2xxx/tcm_qla2xxx.c           |    4 +---
 drivers/target/iscsi/iscsi_target_configfs.c |    3 +--
 drivers/target/loopback/tcm_loop.c           |    3 +--
 drivers/target/sbp/sbp_target.c              |    3 +--
 drivers/target/tcm_fc/tcm_fc.h               |    2 +-
 drivers/target/tcm_fc/tfc_cmd.c              |    5 ++---
 drivers/usb/gadget/tcm_usb_gadget.c          |    3 +--
 drivers/vhost/tcm_vhost.c                    |    3 +--
 include/target/target_core_fabric.h          |    2 +-
 10 files changed, 15 insertions(+), 27 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index c09d41b..2c61a28 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2987,7 +2987,7 @@ static u8 tcm_to_srp_tsk_mgmt_status(const int tcm_mgmt_status)
  * Callback function called by the TCM core. Must not block since it can be
  * invoked on the context of the IB completion handler.
  */
-static int srpt_queue_response(struct se_cmd *cmd)
+static void srpt_queue_response(struct se_cmd *cmd)
 {
 	struct srpt_rdma_ch *ch;
 	struct srpt_send_ioctx *ioctx;
@@ -2998,8 +2998,6 @@ static int srpt_queue_response(struct se_cmd *cmd)
 	int resp_len;
 	u8 srp_tm_status;
 
-	ret = 0;
-
 	ioctx = container_of(cmd, struct srpt_send_ioctx, cmd);
 	ch = ioctx->ch;
 	BUG_ON(!ch);
@@ -3025,7 +3023,7 @@ static int srpt_queue_response(struct se_cmd *cmd)
 		     || WARN_ON_ONCE(state == SRPT_STATE_CMD_RSP_SENT))) {
 		atomic_inc(&ch->req_lim_delta);
 		srpt_abort_cmd(ioctx);
-		goto out;
+		return;
 	}
 
 	dir = ioctx->cmd.data_direction;
@@ -3037,7 +3035,7 @@ static int srpt_queue_response(struct se_cmd *cmd)
 		if (ret) {
 			printk(KERN_ERR "xfer_data failed for tag %llu\n",
 			       ioctx->tag);
-			goto out;
+			return;
 		}
 	}
 
@@ -3058,9 +3056,6 @@ static int srpt_queue_response(struct se_cmd *cmd)
 		srpt_set_cmd_state(ioctx, SRPT_STATE_DONE);
 		target_put_sess_cmd(ioctx->ch->sess, &ioctx->cmd);
 	}
-
-out:
-	return ret;
 }
 
 static int srpt_queue_status(struct se_cmd *cmd)
@@ -3073,7 +3068,8 @@ static int srpt_queue_status(struct se_cmd *cmd)
 	    (SCF_TRANSPORT_TASK_SENSE | SCF_EMULATED_TASK_SENSE))
 		WARN_ON(cmd->scsi_status != SAM_STAT_CHECK_CONDITION);
 	ioctx->queue_status_only = true;
-	return srpt_queue_response(cmd);
+	srpt_queue_response(cmd);
+	return 0;
 }
 
 static void srpt_refresh_port_work(struct work_struct *work)
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 2313f06..9b75ec9 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -699,7 +699,7 @@ static int tcm_qla2xxx_queue_status(struct se_cmd *se_cmd)
 	return qlt_xmit_response(cmd, xmit_type, se_cmd->scsi_status);
 }
 
-static int tcm_qla2xxx_queue_tm_rsp(struct se_cmd *se_cmd)
+static void tcm_qla2xxx_queue_tm_rsp(struct se_cmd *se_cmd)
 {
 	struct se_tmr_req *se_tmr = se_cmd->se_tmr_req;
 	struct qla_tgt_mgmt_cmd *mcmd = container_of(se_cmd,
@@ -731,8 +731,6 @@ static int tcm_qla2xxx_queue_tm_rsp(struct se_cmd *se_cmd)
 	 * CTIO response packet.
 	 */
 	qlt_xmit_tm_rsp(mcmd);
-
-	return 0;
 }
 
 /* Local pointer to allocated TCM configfs fabric module */
diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index 6bd5d01..0cfa96e 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -1582,13 +1582,12 @@ static int lio_queue_status(struct se_cmd *se_cmd)
 	return 0;
 }
 
-static int lio_queue_tm_rsp(struct se_cmd *se_cmd)
+static void lio_queue_tm_rsp(struct se_cmd *se_cmd)
 {
 	struct iscsi_cmd *cmd = container_of(se_cmd, struct iscsi_cmd, se_cmd);
 
 	cmd->i_state = ISTATE_SEND_TASKMGTRSP;
 	iscsit_add_cmd_to_response_queue(cmd, cmd->conn, cmd->i_state);
-	return 0;
 }
 
 static char *lio_tpg_get_endpoint_wwn(struct se_portal_group *se_tpg)
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 2d444b1..673e4fa 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -787,7 +787,7 @@ static int tcm_loop_queue_status(struct se_cmd *se_cmd)
 	return 0;
 }
 
-static int tcm_loop_queue_tm_rsp(struct se_cmd *se_cmd)
+static void tcm_loop_queue_tm_rsp(struct se_cmd *se_cmd)
 {
 	struct se_tmr_req *se_tmr = se_cmd->se_tmr_req;
 	struct tcm_loop_tmr *tl_tmr = se_tmr->fabric_tmr_ptr;
@@ -797,7 +797,6 @@ static int tcm_loop_queue_tm_rsp(struct se_cmd *se_cmd)
 	 */
 	atomic_set(&tl_tmr->tmr_complete, 1);
 	wake_up(&tl_tmr->tl_tmr_wait);
-	return 0;
 }
 
 static char *tcm_loop_dump_proto_id(struct tcm_loop_hba *tl_hba)
diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index d3536f5..e51b09a 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -1842,9 +1842,8 @@ static int sbp_queue_status(struct se_cmd *se_cmd)
 	return sbp_send_sense(req);
 }
 
-static int sbp_queue_tm_rsp(struct se_cmd *se_cmd)
+static void sbp_queue_tm_rsp(struct se_cmd *se_cmd)
 {
-	return 0;
 }
 
 static int sbp_check_stop_free(struct se_cmd *se_cmd)
diff --git a/drivers/target/tcm_fc/tcm_fc.h b/drivers/target/tcm_fc/tcm_fc.h
index eea6935..0dd54a4 100644
--- a/drivers/target/tcm_fc/tcm_fc.h
+++ b/drivers/target/tcm_fc/tcm_fc.h
@@ -161,7 +161,7 @@ int ft_write_pending(struct se_cmd *);
 int ft_write_pending_status(struct se_cmd *);
 u32 ft_get_task_tag(struct se_cmd *);
 int ft_get_cmd_state(struct se_cmd *);
-int ft_queue_tm_resp(struct se_cmd *);
+void ft_queue_tm_resp(struct se_cmd *);
 
 /*
  * other internal functions.
diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index 7b6bb72..0e5a1cae 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -394,14 +394,14 @@ static void ft_send_tm(struct ft_cmd *cmd)
 /*
  * Send status from completed task management request.
  */
-int ft_queue_tm_resp(struct se_cmd *se_cmd)
+void ft_queue_tm_resp(struct se_cmd *se_cmd)
 {
 	struct ft_cmd *cmd = container_of(se_cmd, struct ft_cmd, se_cmd);
 	struct se_tmr_req *tmr = se_cmd->se_tmr_req;
 	enum fcp_resp_rsp_codes code;
 
 	if (cmd->aborted)
-		return 0;
+		return;
 	switch (tmr->response) {
 	case TMR_FUNCTION_COMPLETE:
 		code = FCP_TMF_CMPL;
@@ -421,7 +421,6 @@ int ft_queue_tm_resp(struct se_cmd *se_cmd)
 	pr_debug("tmr fn %d resp %d fcp code %d\n",
 		  tmr->function, tmr->response, code);
 	ft_send_resp_code(cmd, code);
-	return 0;
 }
 
 static void ft_send_work(struct work_struct *work);
diff --git a/drivers/usb/gadget/tcm_usb_gadget.c b/drivers/usb/gadget/tcm_usb_gadget.c
index 7cacd6a..0ff3339 100644
--- a/drivers/usb/gadget/tcm_usb_gadget.c
+++ b/drivers/usb/gadget/tcm_usb_gadget.c
@@ -1467,9 +1467,8 @@ static int usbg_get_cmd_state(struct se_cmd *se_cmd)
 	return 0;
 }
 
-static int usbg_queue_tm_rsp(struct se_cmd *se_cmd)
+static void usbg_queue_tm_rsp(struct se_cmd *se_cmd)
 {
-	return 0;
 }
 
 static const char *usbg_check_wwn(const char *name)
diff --git a/drivers/vhost/tcm_vhost.c b/drivers/vhost/tcm_vhost.c
index 957a0b9..60f386d 100644
--- a/drivers/vhost/tcm_vhost.c
+++ b/drivers/vhost/tcm_vhost.c
@@ -344,9 +344,8 @@ static int tcm_vhost_queue_status(struct se_cmd *se_cmd)
 	return 0;
 }
 
-static int tcm_vhost_queue_tm_rsp(struct se_cmd *se_cmd)
+static void tcm_vhost_queue_tm_rsp(struct se_cmd *se_cmd)
 {
-	return 0;
 }
 
 static void vhost_scsi_free_cmd(struct tcm_vhost_cmd *tv_cmd)
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index aaa1ee6..9708a04 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -61,7 +61,7 @@ struct target_core_fabric_ops {
 	int (*get_cmd_state)(struct se_cmd *);
 	int (*queue_data_in)(struct se_cmd *);
 	int (*queue_status)(struct se_cmd *);
-	int (*queue_tm_rsp)(struct se_cmd *);
+	void (*queue_tm_rsp)(struct se_cmd *);
 	/*
 	 * fabric module calls for target_core_fabric_configfs.c
 	 */
-- 
1.7.10.4

