Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135Ab3LFOYe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 09:24:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43546 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757827Ab3LFM7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 07:59:38 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nicholas Bellinger <nab@linux-iscsi.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 007/272] iscsi-target: Fix mutex_trylock usage in iscsit_increment_maxcmdsn
Date: Fri,  6 Dec 2013 12:54:56 +0000
Message-Id: <1386334761-25517-8-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/target/iscsi/iscsi_target_configfs.c | 5 +++++
 drivers/target/iscsi/iscsi_target_device.c   | 6 +-----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index bbfd288..752ee53 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -1786,6 +1786,11 @@ static int lio_queue_status(struct se_cmd *se_cmd)
 	struct iscsi_cmd *cmd = container_of(se_cmd, struct iscsi_cmd, se_cmd);
 
 	cmd->i_state = ISTATE_SEND_STATUS;
+
+	if (cmd->se_cmd.scsi_status || cmd->sense_reason) {
+		iscsit_add_cmd_to_response_queue(cmd, cmd->conn, cmd->i_state);
+		return 0;
+	}
 	cmd->conn->conn_transport->iscsit_queue_status(cmd->conn, cmd);
 
 	return 0;
diff --git a/drivers/target/iscsi/iscsi_target_device.c b/drivers/target/iscsi/iscsi_target_device.c
index 1b74033..4edcc47 100644
--- a/drivers/target/iscsi/iscsi_target_device.c
+++ b/drivers/target/iscsi/iscsi_target_device.c
@@ -60,11 +60,7 @@ void iscsit_increment_maxcmdsn(struct iscsi_cmd *cmd, struct iscsi_session *sess
 
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
-- 
1.8.3.2

