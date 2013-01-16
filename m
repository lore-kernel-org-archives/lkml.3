Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768Ab3APP6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 10:58:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35667 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756306Ab3APP6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 10:58:15 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Steve Hodgson <steve@purestorage.com>,
        Roland Dreier <roland@purestorage.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 013/222] iscsi-target: Fix bug in handling of ExpStatSN ACK during u32 wrap-around
Date: Wed, 16 Jan 2013 13:53:33 -0200
Message-Id: <1358351822-7675-14-git-send-email-herton.krzesinski@canonical.com>
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

commit 64c13330a38935120501b19c97a3e6095747c7a1 upstream.

This patch fixes a bug in the hanlding of initiator provided ExpStatSN and
individual iscsi_cmd->stat_sn comparision during iscsi_conn->stat_sn
wrap-around within iscsit_ack_from_expstatsn() code.

This bug would manifest itself as iscsi_cmd descriptors not being Acked
by a lower ExpStatSn, causing them to be leaked until an iSCSI connection
or session reinstatement event occurs to release all commands.

Also fix up two other uses of incorrect CmdSN SNA comparison to use wrapper
usage from include/scsi/iscsi_proto.h.

Signed-off-by: Steve Hodgson <steve@purestorage.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
[ herton: hdr->refcmdsn has the converted be32_to_cpu value on 3.5 ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/target/iscsi/iscsi_target.c      |    2 +-
 drivers/target/iscsi/iscsi_target_erl2.c |    2 +-
 drivers/target/iscsi/iscsi_target_tmr.c  |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 4891cc8..65fc914 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -735,7 +735,7 @@ static void iscsit_ack_from_expstatsn(struct iscsi_conn *conn, u32 exp_statsn)
 	list_for_each_entry(cmd, &conn->conn_cmd_list, i_conn_node) {
 		spin_lock(&cmd->istate_lock);
 		if ((cmd->i_state == ISTATE_SENT_STATUS) &&
-		    (cmd->stat_sn < exp_statsn)) {
+		    iscsi_sna_lt(cmd->stat_sn, exp_statsn)) {
 			cmd->i_state = ISTATE_REMOVE;
 			spin_unlock(&cmd->istate_lock);
 			iscsit_add_cmd_to_immediate_queue(cmd, conn,
diff --git a/drivers/target/iscsi/iscsi_target_erl2.c b/drivers/target/iscsi/iscsi_target_erl2.c
index 65aac14..ecfd2ad 100644
--- a/drivers/target/iscsi/iscsi_target_erl2.c
+++ b/drivers/target/iscsi/iscsi_target_erl2.c
@@ -374,7 +374,7 @@ int iscsit_prepare_cmds_for_realligance(struct iscsi_conn *conn)
 		 * made generic here.
 		 */
 		if (!(cmd->cmd_flags & ICF_OOO_CMDSN) && !cmd->immediate_cmd &&
-		     (cmd->cmd_sn >= conn->sess->exp_cmd_sn)) {
+		     iscsi_sna_gte(cmd->stat_sn, conn->sess->exp_cmd_sn)) {
 			list_del(&cmd->i_conn_node);
 			spin_unlock_bh(&conn->cmd_lock);
 			iscsit_free_cmd(cmd);
diff --git a/drivers/target/iscsi/iscsi_target_tmr.c b/drivers/target/iscsi/iscsi_target_tmr.c
index f4e640b..147e809 100644
--- a/drivers/target/iscsi/iscsi_target_tmr.c
+++ b/drivers/target/iscsi/iscsi_target_tmr.c
@@ -49,8 +49,8 @@ u8 iscsit_tmr_abort_task(
 	if (!ref_cmd) {
 		pr_err("Unable to locate RefTaskTag: 0x%08x on CID:"
 			" %hu.\n", hdr->rtt, conn->cid);
-		return ((hdr->refcmdsn >= conn->sess->exp_cmd_sn) &&
-			(hdr->refcmdsn <= conn->sess->max_cmd_sn)) ?
+		return (iscsi_sna_gte(hdr->refcmdsn, conn->sess->exp_cmd_sn) &&
+			iscsi_sna_lte(hdr->refcmdsn, conn->sess->max_cmd_sn)) ?
 			ISCSI_TMF_RSP_COMPLETE : ISCSI_TMF_RSP_NO_TASK;
 	}
 	if (ref_cmd->cmd_sn != hdr->refcmdsn) {
-- 
1.7.9.5

