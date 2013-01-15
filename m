Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757985Ab3AOS51 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 13:57:27 -0500
Received: from mail.kernel.org ([198.145.19.201]:34810 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757537Ab3AOS5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 13:57:21 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Roland Dreier <roland@purestorage.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 038/221] iscsi-target: Always send a response before terminating iSCSI connection
Date: Tue, 15 Jan 2013 10:49:25 -0800
Message-Id: <20130115185000.779390168@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/iscsi/iscsi_target_login.c |    8 ++++----
 drivers/target/iscsi/iscsi_target_nego.c  |   10 ++++++++--
 2 files changed, 12 insertions(+), 6 deletions(-)

--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -127,13 +127,13 @@ int iscsi_check_for_session_reinstatemen
 
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
 
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -620,8 +620,11 @@ static int iscsi_target_handle_csg_one(s
 			login->req_buf,
 			payload_length,
 			conn);
-	if (ret < 0)
+	if (ret < 0) {
+		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
+				ISCSI_LOGIN_STATUS_INIT_ERR);
 		return -1;
+	}
 
 	if (login->first_request)
 		if (iscsi_target_check_first_request(conn, login) < 0)
@@ -636,8 +639,11 @@ static int iscsi_target_handle_csg_one(s
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


