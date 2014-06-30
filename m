Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbaF3MqF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:46:05 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:53045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754560AbaF3Ma4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:30:56 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sagi Grimberg <sagig@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 155/181] Target/iscsi: Fix sendtargets response pdu for iser transport
Date: Mon, 30 Jun 2014 13:52:56 +0200
Message-Id: <3b21f90b541c912075ab5d8fc939b013f404e42f.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sagi Grimberg <sagig@mellanox.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/infiniband/ulp/isert/ib_isert.c |  2 +-
 drivers/target/iscsi/iscsi_target.c     | 14 ++++++++++----
 include/target/iscsi/iscsi_transport.h  |  3 ++-
 3 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 27925b7161ff..548d86847d18 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -1949,7 +1949,7 @@ isert_put_text_rsp(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 	int rc;
 
 	isert_create_send_desc(isert_conn, isert_cmd, &isert_cmd->tx_desc);
-	rc = iscsit_build_text_rsp(cmd, conn, hdr);
+	rc = iscsit_build_text_rsp(cmd, conn, hdr, ISCSI_INFINIBAND);
 	if (rc < 0)
 		return rc;
 
diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index d5b07e179a38..f99162542df2 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -3378,7 +3378,9 @@ static bool iscsit_check_inaddr_any(struct iscsi_np *np)
 
 #define SENDTARGETS_BUF_LIMIT 32768U
 
-static int iscsit_build_sendtargets_response(struct iscsi_cmd *cmd)
+static int
+iscsit_build_sendtargets_response(struct iscsi_cmd *cmd,
+				  enum iscsit_transport_type network_transport)
 {
 	char *payload = NULL;
 	struct iscsi_conn *conn = cmd->conn;
@@ -3450,6 +3452,9 @@ static int iscsit_build_sendtargets_response(struct iscsi_cmd *cmd)
 				struct iscsi_np *np = tpg_np->tpg_np;
 				bool inaddr_any = iscsit_check_inaddr_any(np);
 
+				if (np->np_network_transport != network_transport)
+					continue;
+
 				len = sprintf(buf, "TargetAddress="
 					"%s:%hu,%hu",
 					(inaddr_any == false) ?
@@ -3487,11 +3492,12 @@ eob:
 
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
 
@@ -3529,7 +3535,7 @@ static int iscsit_send_text_rsp(
 	u32 tx_size = 0;
 	int text_length, iov_count = 0, rc;
 
-	rc = iscsit_build_text_rsp(cmd, conn, hdr);
+	rc = iscsit_build_text_rsp(cmd, conn, hdr, ISCSI_TCP);
 	if (rc < 0)
 		return rc;
 
diff --git a/include/target/iscsi/iscsi_transport.h b/include/target/iscsi/iscsi_transport.h
index 361bd0f04018..78edd7895c7f 100644
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
2.0.0

