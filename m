Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758008Ab3AOS53 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 13:57:29 -0500
Received: from mail.kernel.org ([198.145.19.201]:34838 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757988Ab3AOS51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 13:57:27 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Steve Hodgson <steve@purestorage.com>,
        Roland Dreier <roland@purestorage.com>,
        Nicholas Bellinger <nab@risingtidesystems.com>
Subject: [ 040/221] qla2xxx: Look up LUN for abort requests
Date: Tue, 15 Jan 2013 10:49:27 -0800
Message-Id: <20130115185000.919638083@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/qla2xxx/qla_target.c |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1264,8 +1264,27 @@ static int __qlt_24xx_handle_abts(struct
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
@@ -1283,7 +1302,7 @@ static int __qlt_24xx_handle_abts(struct
 	mcmd->sess = sess;
 	memcpy(&mcmd->orig_iocb.abts, abts, sizeof(mcmd->orig_iocb.abts));
 
-	rc = ha->tgt.tgt_ops->handle_tmr(mcmd, 0, TMR_ABORT_TASK,
+	rc = ha->tgt.tgt_ops->handle_tmr(mcmd, lun, TMR_ABORT_TASK,
 	    abts->exchange_addr_to_abort);
 	if (rc != 0) {
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf052,


