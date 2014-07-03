Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030268AbaGCJX5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:23:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52196 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030182AbaGCJXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:23:44 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sagi Grimberg <sagig@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 123/198] Target/iscsi: Fix sendtargets response pdu for iser transport
Date: Thu,  3 Jul 2014 10:19:26 +0100
Message-Id: <1404379241-8590-124-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c |  2 +-
 drivers/target/iscsi/iscsi_target.c     | 14 ++++++++++----
 include/target/iscsi/iscsi_transport.h  |  3 ++-
 3 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index f1208f9ba702..6ed7c829b863 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -1811,7 +1811,7 @@ isert_put_text_rsp(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 	int rc;
 
 	isert_create_send_desc(isert_conn, isert_cmd, &isert_cmd->tx_desc);
-	rc = iscsit_build_text_rsp(cmd, conn, hdr);
+	rc = iscsit_build_text_rsp(cmd, conn, hdr, ISCSI_INFINIBAND);
 	if (rc < 0)
 		return rc;
 
diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index a2a650733df2..a5825ea2488e 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -3390,7 +3390,9 @@ static bool iscsit_check_inaddr_any(struct iscsi_np *np)
 
 #define SENDTARGETS_BUF_LIMIT 32768U
 
-static int iscsit_build_sendtargets_response(struct iscsi_cmd *cmd)
+static int
+iscsit_build_sendtargets_response(struct iscsi_cmd *cmd,
+				  enum iscsit_transport_type network_transport)
 {
 	char *payload = NULL;
 	struct iscsi_conn *conn = cmd->conn;
@@ -3462,6 +3464,9 @@ static int iscsit_build_sendtargets_response(struct iscsi_cmd *cmd)
 				struct iscsi_np *np = tpg_np->tpg_np;
 				bool inaddr_any = iscsit_check_inaddr_any(np);
 
+				if (np->np_network_transport != network_transport)
+					continue;
+
 				len = sprintf(buf, "TargetAddress="
 					"%s%s%s:%hu,%hu",
 					(np->np_sockaddr.ss_family == AF_INET6) ?
@@ -3501,11 +3506,12 @@ eob:
 
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
 
@@ -3543,7 +3549,7 @@ static int iscsit_send_text_rsp(
 	u32 tx_size = 0;
 	int text_length, iov_count = 0, rc;
 
-	rc = iscsit_build_text_rsp(cmd, conn, hdr);
+	rc = iscsit_build_text_rsp(cmd, conn, hdr, ISCSI_TCP);
 	if (rc < 0)
 		return rc;
 
diff --git a/include/target/iscsi/iscsi_transport.h b/include/target/iscsi/iscsi_transport.h
index 4bde6131bc16..0dba01d89b58 100644
--- a/include/target/iscsi/iscsi_transport.h
+++ b/include/target/iscsi/iscsi_transport.h
@@ -63,7 +63,8 @@ extern void iscsit_build_nopin_rsp(struct iscsi_cmd *, struct iscsi_conn *,
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

