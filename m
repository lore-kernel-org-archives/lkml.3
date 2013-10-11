Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933408Ab3JKUX1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:23:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45935 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932161Ab3JKTkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:40:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 090/110] iscsi-target: Only perform wait_for_tasks when performing shutdown
Date: Fri, 11 Oct 2013 12:39:10 -0700
Message-Id: <20131011193817.611623650@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193807.584188672@linuxfoundation.org>
References: <20131011193807.584188672@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit e255a28598e8e63070322fc89bd34189dd660a89 upstream.

This patch changes transport_generic_free_cmd() to only wait_for_tasks
when shutdown=true is passed to iscsit_free_cmd().

With the advent of >= v3.10 iscsi-target code using se_cmd->cmd_kref,
the extra wait_for_tasks with shutdown=false is unnecessary, and may
end up causing an extra context switch when releasing WRITEs.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/iscsi/iscsi_target_util.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -734,7 +734,7 @@ void iscsit_free_cmd(struct iscsi_cmd *c
 		 * Fallthrough
 		 */
 	case ISCSI_OP_SCSI_TMFUNC:
-		rc = transport_generic_free_cmd(&cmd->se_cmd, 1);
+		rc = transport_generic_free_cmd(&cmd->se_cmd, shutdown);
 		if (!rc && shutdown && se_cmd && se_cmd->se_sess) {
 			__iscsit_free_cmd(cmd, true, shutdown);
 			target_put_sess_cmd(se_cmd->se_sess, se_cmd);
@@ -750,7 +750,7 @@ void iscsit_free_cmd(struct iscsi_cmd *c
 			se_cmd = &cmd->se_cmd;
 			__iscsit_free_cmd(cmd, true, shutdown);
 
-			rc = transport_generic_free_cmd(&cmd->se_cmd, 1);
+			rc = transport_generic_free_cmd(&cmd->se_cmd, shutdown);
 			if (!rc && shutdown && se_cmd->se_sess) {
 				__iscsit_free_cmd(cmd, true, shutdown);
 				target_put_sess_cmd(se_cmd->se_sess, se_cmd);


