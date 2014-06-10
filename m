Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936222AbaFJAcT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 20:32:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58624 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934537AbaFJAWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 20:22:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Roland Dreier <roland@purestorage.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Ben Hutchings <ben@decadent.org.uk>, Rui Xiang <rui.xiang@huawei.com>
Subject: [PATCH 3.4 67/88] iscsi-target: Always send a response before terminating iSCSI connection
Date: Mon,  9 Jun 2014 17:25:17 -0700
Message-Id: <20140610002426.707664196@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140610002424.500996570@linuxfoundation.org>
References: <20140610002424.500996570@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Rui Xiang <rui.xiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/iscsi/iscsi_target_login.c |    8 ++++----
 drivers/target/iscsi/iscsi_target_nego.c  |   10 ++++++++--
 2 files changed, 12 insertions(+), 6 deletions(-)

--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -131,13 +131,13 @@ int iscsi_check_for_session_reinstatemen
 
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
@@ -628,8 +628,11 @@ static int iscsi_target_handle_csg_one(s
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
@@ -644,8 +647,11 @@ static int iscsi_target_handle_csg_one(s
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


