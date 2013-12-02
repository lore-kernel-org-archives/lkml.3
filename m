Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285Ab3LBUOG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:14:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39166 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141Ab3LBTRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:17:31 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Moussa Ba <moussaba@micron.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.12 057/212] iscsi-target: Fix mutex_trylock usage in iscsit_increment_maxcmdsn
Date: Mon,  2 Dec 2013 11:14:08 -0800
Message-Id: <20131202191254.488061181@linuxfoundation.org>
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

commit 5e8e6b4b3adebf01a9d97056cbbfd8c44330df99 upstream.

This patch fixes a >= v3.10 regression bug with mutex_trylock() usage
within iscsit_increment_maxcmdsn(), that was originally added to allow
for a special case where ->cmdsn_mutex was already held from the
iscsit_execute_cmd() exception path for ib_isert.

When !mutex_trylock() was occuring under contention during normal RX/TX
process context codepaths, the bug was manifesting itself as the following
protocol error:

  Received CmdSN: 0x000fcbb7 is greater than MaxCmdSN: 0x000fcbb6, protocol error.
  Received CmdSN: 0x000fcbb8 is greater than MaxCmdSN: 0x000fcbb6, protocol error.

This patch simply avoids the direct ib_isert callback in lio_queue_status()
for the special iscsi_execute_cmd() exception cases, that allows the problematic
mutex_trylock() usage in iscsit_increment_maxcmdsn() to go away.

Reported-by: Moussa Ba <moussaba@micron.com>
Tested-by: Moussa Ba <moussaba@micron.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/iscsi/iscsi_target_configfs.c |    5 +++++
 drivers/target/iscsi/iscsi_target_device.c   |    6 +-----
 2 files changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -1784,6 +1784,11 @@ static int lio_queue_status(struct se_cm
 	struct iscsi_cmd *cmd = container_of(se_cmd, struct iscsi_cmd, se_cmd);
 
 	cmd->i_state = ISTATE_SEND_STATUS;
+
+	if (cmd->se_cmd.scsi_status || cmd->sense_reason) {
+		iscsit_add_cmd_to_response_queue(cmd, cmd->conn, cmd->i_state);
+		return 0;
+	}
 	cmd->conn->conn_transport->iscsit_queue_status(cmd->conn, cmd);
 
 	return 0;
--- a/drivers/target/iscsi/iscsi_target_device.c
+++ b/drivers/target/iscsi/iscsi_target_device.c
@@ -58,11 +58,7 @@ void iscsit_increment_maxcmdsn(struct is
 
 	cmd->maxcmdsn_inc = 1;
 
-	if (!mutex_trylock(&sess->cmdsn_mutex)) {
-		sess->max_cmd_sn += 1;
-		pr_debug("Updated MaxCmdSN to 0x%08x\n", sess->max_cmd_sn);
-		return;
-	}
+	mutex_lock(&sess->cmdsn_mutex);
 	sess->max_cmd_sn += 1;
 	pr_debug("Updated MaxCmdSN to 0x%08x\n", sess->max_cmd_sn);
 	mutex_unlock(&sess->cmdsn_mutex);


