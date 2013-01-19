Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066Ab3ASBfs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 20:35:48 -0500
Received: from mail.kernel.org ([198.145.19.201]:56298 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745Ab3ASBRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 20:17:51 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Roland Dreier <roland@purestorage.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 09/33] target: Fix use-after-free in LUN RESET handling
Date: Fri, 18 Jan 2013 17:16:34 -0800
Message-Id: <20130119010349.038823359@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130119010345.885772698@linuxfoundation.org>
References: <20130119010345.885772698@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roland Dreier <roland@purestorage.com>

commit 72b59d6ee8adaa51f70377db0a1917ed489bead8 upstream.

If a backend IO takes a really long then an initiator might abort a
command, and then when it gives up on the abort, send a LUN reset too,
all before we process any of the original command or the abort.  (The
abort will wait for the backend IO to complete too)

When the backend IO final completes (or fails), the abort handling
will proceed and queue up a "return aborted status" operation.  Then,
while that's still pending, the LUN reset might find the original
command still on the LUN's list of commands and try to return aborted
status again, which leads to a use-after free when the first
se_tfo->queue_status call frees the command and then the second
se_tfo->queue_status call runs.

Fix this by removing a command from the LUN state_list when we first
are about to queue aborted status; we shouldn't do anything
LUN-related after we've started returning status, so this seems like
the correct thing to do.

Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_transport.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -545,9 +545,6 @@ static void transport_lun_remove_cmd(str
 
 void transport_cmd_finish_abort(struct se_cmd *cmd, int remove)
 {
-	if (!(cmd->se_cmd_flags & SCF_SCSI_TMR_CDB))
-		transport_lun_remove_cmd(cmd);
-
 	if (transport_cmd_check_stop_to_fabric(cmd))
 		return;
 	if (remove)
@@ -3090,6 +3087,8 @@ void transport_send_task_abort(struct se
 	}
 	cmd->scsi_status = SAM_STAT_TASK_ABORTED;
 
+	transport_lun_remove_cmd(cmd);
+
 	pr_debug("Setting SAM_STAT_TASK_ABORTED status for CDB: 0x%02x,"
 		" ITT: 0x%08x\n", cmd->t_task_cdb[0],
 		cmd->se_tfo->get_task_tag(cmd));


