Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757965Ab3AOS5Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 13:57:25 -0500
Received: from mail.kernel.org ([198.145.19.201]:34793 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757947Ab3AOS5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 13:57:19 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Steve Hodgson <steve@purestorage.com>,
        Roland Dreier <roland@purestorage.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 037/221] iscsi-target: Fix bug in handling of ExpStatSN ACK during u32 wrap-around
Date: Tue, 15 Jan 2013 10:49:24 -0800
Message-Id: <20130115185000.709964724@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/iscsi/iscsi_target.c      |    2 +-
 drivers/target/iscsi/iscsi_target_erl2.c |    2 +-
 drivers/target/iscsi/iscsi_target_tmr.c  |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -735,7 +735,7 @@ static void iscsit_ack_from_expstatsn(st
 	list_for_each_entry(cmd, &conn->conn_cmd_list, i_conn_node) {
 		spin_lock(&cmd->istate_lock);
 		if ((cmd->i_state == ISTATE_SENT_STATUS) &&
-		    (cmd->stat_sn < exp_statsn)) {
+		    iscsi_sna_lt(cmd->stat_sn, exp_statsn)) {
 			cmd->i_state = ISTATE_REMOVE;
 			spin_unlock(&cmd->istate_lock);
 			iscsit_add_cmd_to_immediate_queue(cmd, conn,
--- a/drivers/target/iscsi/iscsi_target_erl2.c
+++ b/drivers/target/iscsi/iscsi_target_erl2.c
@@ -372,7 +372,7 @@ int iscsit_prepare_cmds_for_realligance(
 		 * made generic here.
 		 */
 		if (!(cmd->cmd_flags & ICF_OOO_CMDSN) && !cmd->immediate_cmd &&
-		     (cmd->cmd_sn >= conn->sess->exp_cmd_sn)) {
+		     iscsi_sna_gte(cmd->stat_sn, conn->sess->exp_cmd_sn)) {
 			list_del(&cmd->i_conn_node);
 			spin_unlock_bh(&conn->cmd_lock);
 			iscsit_free_cmd(cmd);
--- a/drivers/target/iscsi/iscsi_target_tmr.c
+++ b/drivers/target/iscsi/iscsi_target_tmr.c
@@ -50,8 +50,8 @@ u8 iscsit_tmr_abort_task(
 	if (!ref_cmd) {
 		pr_err("Unable to locate RefTaskTag: 0x%08x on CID:"
 			" %hu.\n", hdr->rtt, conn->cid);
-		return (be32_to_cpu(hdr->refcmdsn) >= conn->sess->exp_cmd_sn &&
-			be32_to_cpu(hdr->refcmdsn) <= conn->sess->max_cmd_sn) ?
+		return (iscsi_sna_gte(be32_to_cpu(hdr->refcmdsn), conn->sess->exp_cmd_sn) &&
+			iscsi_sna_lte(be32_to_cpu(hdr->refcmdsn), conn->sess->max_cmd_sn)) ?
 			ISCSI_TMF_RSP_COMPLETE : ISCSI_TMF_RSP_NO_TASK;
 	}
 	if (ref_cmd->cmd_sn != be32_to_cpu(hdr->refcmdsn)) {


