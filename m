Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806Ab3APP6c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 10:58:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35672 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756545Ab3APP6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 10:58:18 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Roland Dreier <roland@purestorage.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 014/222] iscsi-target: Always send a response before terminating iSCSI connection
Date: Wed, 16 Jan 2013 13:53:34 -0200
Message-Id: <1358351822-7675-15-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roland Dreier <roland@purestorage.com>

commit 1c5c12c666fda27c7c494b34934a0a0631a48130 upstream.

There are some cases, for example when the initiator sends an
out-of-bounds ErrorRecoveryLevel value, where the iSCSI target
terminates the connection without sending back any error.  Audit the
login path and add appropriate iscsit_tx_login_rsp() calls to make
sure this doesn't happen.

Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
[ herton: adjust context ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/target/iscsi/iscsi_target_login.c |    8 ++++----
 drivers/target/iscsi/iscsi_target_nego.c  |   10 ++++++++--
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 3cb7a4f..bc7d08f 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -131,13 +131,13 @@ int iscsi_check_for_session_reinstatement(struct iscsi_conn *conn)
 
 	initiatorname_param = iscsi_find_param_from_key(
 			INITIATORNAME, conn->param_list);
-	if (!initiatorname_param)
-		return -1;
-
 	sessiontype_param = iscsi_find_param_from_key(
 			SESSIONTYPE, conn->param_list);
-	if (!sessiontype_param)
+	if (!initiatorname_param || !sessiontype_param) {
+		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
+			ISCSI_LOGIN_STATUS_MISSING_FIELDS);
 		return -1;
+	}
 
 	sessiontype = (strncmp(sessiontype_param->value, NORMAL, 6)) ? 1 : 0;
 
diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index 2dba448..0184bea 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -628,8 +628,11 @@ static int iscsi_target_handle_csg_one(struct iscsi_conn *conn, struct iscsi_log
 			login->req_buf,
 			payload_length,
 			conn->param_list);
-	if (ret < 0)
+	if (ret < 0) {
+		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
+				ISCSI_LOGIN_STATUS_INIT_ERR);
 		return -1;
+	}
 
 	if (login->first_request)
 		if (iscsi_target_check_first_request(conn, login) < 0)
@@ -644,8 +647,11 @@ static int iscsi_target_handle_csg_one(struct iscsi_conn *conn, struct iscsi_log
 			login->rsp_buf,
 			&login->rsp_length,
 			conn->param_list);
-	if (ret < 0)
+	if (ret < 0) {
+		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
+				ISCSI_LOGIN_STATUS_INIT_ERR);
 		return -1;
+	}
 
 	if (!login->auth_complete &&
 	     ISCSI_TPG_ATTRIB(ISCSI_TPG_C(conn))->authentication) {
-- 
1.7.9.5

