Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465Ab3APQAr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:00:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35878 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757440Ab3APQAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:00:44 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Steve Hodgson <steve@purestorage.com>,
        Roland Dreier <roland@purestorage.com>,
        Nicholas Bellinger <nab@risingtidesystems.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 051/222] qla2xxx: Look up LUN for abort requests
Date: Wed, 16 Jan 2013 13:54:11 -0200
Message-Id: <1358351822-7675-52-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve Hodgson <steve@purestorage.com>

commit 06e97b489006f28e23bb028febfa1c01c266d676 upstream.

Search through the list of pending commands on the session list to find
the command the initiator is actually aborting, so that we can pass the
correct LUN to the core TMR handling code.

(nab: Allow abort requests to work to LUN=0 with mainline target code)

Signed-off-by: Steve Hodgson <steve@purestorage.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@risingtidesystems.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/scsi/qla2xxx/qla_target.c |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index f6021cd..714a97d 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1264,8 +1264,27 @@ static int __qlt_24xx_handle_abts(struct scsi_qla_host *vha,
 	struct abts_recv_from_24xx *abts, struct qla_tgt_sess *sess)
 {
 	struct qla_hw_data *ha = vha->hw;
+	struct se_session *se_sess = sess->se_sess;
 	struct qla_tgt_mgmt_cmd *mcmd;
+	struct se_cmd *se_cmd;
+	u32 lun = 0;
 	int rc;
+	bool found_lun = false;
+
+	spin_lock(&se_sess->sess_cmd_lock);
+	list_for_each_entry(se_cmd, &se_sess->sess_cmd_list, se_cmd_list) {
+		struct qla_tgt_cmd *cmd =
+			container_of(se_cmd, struct qla_tgt_cmd, se_cmd);
+		if (cmd->tag == abts->exchange_addr_to_abort) {
+			lun = cmd->unpacked_lun;
+			found_lun = true;
+			break;
+		}
+	}
+	spin_unlock(&se_sess->sess_cmd_lock);
+
+	if (!found_lun)
+		return -ENOENT;
 
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf00f,
 	    "qla_target(%d): task abort (tag=%d)\n",
@@ -1283,7 +1302,7 @@ static int __qlt_24xx_handle_abts(struct scsi_qla_host *vha,
 	mcmd->sess = sess;
 	memcpy(&mcmd->orig_iocb.abts, abts, sizeof(mcmd->orig_iocb.abts));
 
-	rc = ha->tgt.tgt_ops->handle_tmr(mcmd, 0, TMR_ABORT_TASK,
+	rc = ha->tgt.tgt_ops->handle_tmr(mcmd, lun, TMR_ABORT_TASK,
 	    abts->exchange_addr_to_abort);
 	if (rc != 0) {
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf052,
-- 
1.7.9.5

