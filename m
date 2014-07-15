Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759351AbaGOVg1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:36:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54494 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759394AbaGOVgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:36:17 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sagi Grimberg <sagig@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 128/198] Target/iscsi: Fix sendtargets response pdu for iser transport
Date: Tue, 15 Jul 2014 14:29:58 -0700
Message-Id: <1405459868-15089-129-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sagi Grimberg <sagig@mellanox.com>

commit 22c7aaa57e80853b4904a46c18f97db0036a3b97 upstream.

In case the transport is iser we should not include the
iscsi target info in the sendtargets text response pdu.
This causes sendtargets response to include the target
info twice.

Modify iscsit_build_sendtargets_response to filter
transport types that don't match.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
Reported-by: Slava Shwartsman <valyushash@gmail.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c |  2 +-
 drivers/target/iscsi/iscsi_target.c     | 14 ++++++++++----
 include/target/iscsi/iscsi_transport.h  |  3 ++-
 3 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index bde56da..5199f4e 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -2016,7 +2016,7 @@ isert_put_text_rsp(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 	int rc;
 
 	isert_create_send_desc(isert_conn, isert_cmd, &isert_cmd->tx_desc);
-	rc = iscsit_build_text_rsp(cmd, conn, hdr);
+	rc = iscsit_build_text_rsp(cmd, conn, hdr, ISCSI_INFINIBAND);
 	if (rc < 0)
 		return rc;
 
diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index fe63a02..711dff4 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -3360,7 +3360,9 @@ static bool iscsit_check_inaddr_any(struct iscsi_np *np)
 
 #define SENDTARGETS_BUF_LIMIT 32768U
 
-static int iscsit_build_sendtargets_response(struct iscsi_cmd *cmd)
+static int
+iscsit_build_sendtargets_response(struct iscsi_cmd *cmd,
+				  enum iscsit_transport_type network_transport)
 {
 	char *payload = NULL;
 	struct iscsi_conn *conn = cmd->conn;
@@ -3437,6 +3439,9 @@ static int iscsit_build_sendtargets_response(struct iscsi_cmd *cmd)
 				struct iscsi_np *np = tpg_np->tpg_np;
 				bool inaddr_any = iscsit_check_inaddr_any(np);
 
+				if (np->np_network_transport != network_transport)
+					continue;
+
 				if (!target_name_printed) {
 					len = sprintf(buf, "TargetName=%s",
 						      tiqn->tiqn);
@@ -3490,11 +3495,12 @@ eob:
 
 int
 iscsit_build_text_rsp(struct iscsi_cmd *cmd, struct iscsi_conn *conn,
-		      struct iscsi_text_rsp *hdr)
+		      struct iscsi_text_rsp *hdr,
+		      enum iscsit_transport_type network_transport)
 {
 	int text_length, padding;
 
-	text_length = iscsit_build_sendtargets_response(cmd);
+	text_length = iscsit_build_sendtargets_response(cmd, network_transport);
 	if (text_length < 0)
 		return text_length;
 
@@ -3532,7 +3538,7 @@ static int iscsit_send_text_rsp(
 	u32 tx_size = 0;
 	int text_length, iov_count = 0, rc;
 
-	rc = iscsit_build_text_rsp(cmd, conn, hdr);
+	rc = iscsit_build_text_rsp(cmd, conn, hdr, ISCSI_TCP);
 	if (rc < 0)
 		return rc;
 
diff --git a/include/target/iscsi/iscsi_transport.h b/include/target/iscsi/iscsi_transport.h
index 361bd0f..78edd78 100644
--- a/include/target/iscsi/iscsi_transport.h
+++ b/include/target/iscsi/iscsi_transport.h
@@ -68,7 +68,8 @@ extern void iscsit_build_nopin_rsp(struct iscsi_cmd *, struct iscsi_conn *,
 extern void iscsit_build_task_mgt_rsp(struct iscsi_cmd *, struct iscsi_conn *,
 				struct iscsi_tm_rsp *);
 extern int iscsit_build_text_rsp(struct iscsi_cmd *, struct iscsi_conn *,
-				struct iscsi_text_rsp *);
+				struct iscsi_text_rsp *,
+				enum iscsit_transport_type);
 extern void iscsit_build_reject(struct iscsi_cmd *, struct iscsi_conn *,
 				struct iscsi_reject *);
 extern int iscsit_build_logout_rsp(struct iscsi_cmd *, struct iscsi_conn *,
-- 
1.9.1

