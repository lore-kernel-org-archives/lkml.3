Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539AbaF1Rui (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 13:50:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53619 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755515AbaF1Rud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:50:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sagi Grimberg <sagig@mellanox.com>,
        Slava Shwartsman <valyushash@gmail.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.14 079/110] Target/iscsi: Fix sendtargets response pdu for iser transport
Date: Sat, 28 Jun 2014 10:47:16 -0700
Message-Id: <20140628174550.224151570@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174545.354748696@linuxfoundation.org>
References: <20140628174545.354748696@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/ulp/isert/ib_isert.c |    2 +-
 drivers/target/iscsi/iscsi_target.c     |   14 ++++++++++----
 include/target/iscsi/iscsi_transport.h  |    3 ++-
 3 files changed, 13 insertions(+), 6 deletions(-)

--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -2044,7 +2044,7 @@ isert_put_text_rsp(struct iscsi_cmd *cmd
 	int rc;
 
 	isert_create_send_desc(isert_conn, isert_cmd, &isert_cmd->tx_desc);
-	rc = iscsit_build_text_rsp(cmd, conn, hdr);
+	rc = iscsit_build_text_rsp(cmd, conn, hdr, ISCSI_INFINIBAND);
 	if (rc < 0)
 		return rc;
 
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -3361,7 +3361,9 @@ static bool iscsit_check_inaddr_any(stru
 
 #define SENDTARGETS_BUF_LIMIT 32768U
 
-static int iscsit_build_sendtargets_response(struct iscsi_cmd *cmd)
+static int
+iscsit_build_sendtargets_response(struct iscsi_cmd *cmd,
+				  enum iscsit_transport_type network_transport)
 {
 	char *payload = NULL;
 	struct iscsi_conn *conn = cmd->conn;
@@ -3438,6 +3440,9 @@ static int iscsit_build_sendtargets_resp
 				struct iscsi_np *np = tpg_np->tpg_np;
 				bool inaddr_any = iscsit_check_inaddr_any(np);
 
+				if (np->np_network_transport != network_transport)
+					continue;
+
 				if (!target_name_printed) {
 					len = sprintf(buf, "TargetName=%s",
 						      tiqn->tiqn);
@@ -3491,11 +3496,12 @@ eob:
 
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
 
@@ -3533,7 +3539,7 @@ static int iscsit_send_text_rsp(
 	u32 tx_size = 0;
 	int text_length, iov_count = 0, rc;
 
-	rc = iscsit_build_text_rsp(cmd, conn, hdr);
+	rc = iscsit_build_text_rsp(cmd, conn, hdr, ISCSI_TCP);
 	if (rc < 0)
 		return rc;
 
--- a/include/target/iscsi/iscsi_transport.h
+++ b/include/target/iscsi/iscsi_transport.h
@@ -68,7 +68,8 @@ extern void iscsit_build_nopin_rsp(struc
 extern void iscsit_build_task_mgt_rsp(struct iscsi_cmd *, struct iscsi_conn *,
 				struct iscsi_tm_rsp *);
 extern int iscsit_build_text_rsp(struct iscsi_cmd *, struct iscsi_conn *,
-				struct iscsi_text_rsp *);
+				struct iscsi_text_rsp *,
+				enum iscsit_transport_type);
 extern void iscsit_build_reject(struct iscsi_cmd *, struct iscsi_conn *,
 				struct iscsi_reject *);
 extern int iscsit_build_logout_rsp(struct iscsi_cmd *, struct iscsi_conn *,


