Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140AbaASKiD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 05:38:03 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:51145 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbaASKhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 05:37:36 -0500
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Kent Overstreet <kmo@daterainc.com>, Jens Axboe <axboe@kernel.dk>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 5/5] target/iscsi: Convert gfp_t parameter to task state bitmask
Date: Sun, 19 Jan 2014 10:16:56 +0000
Message-Id: <1390126616-29560-6-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1390126616-29560-1-git-send-email-nab@linux-iscsi.org>
References: <1390126616-29560-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch propigates the use of task state bitmask now used by
percpu_ida_alloc() up the iscsi-target callchain, replacing the
use of GFP_ATOMIC + GFP_KERNEL.

Also, drop the unnecessary gfp_t parameter to isert_allocate_cmd(),
and just pass TASK_INTERRUPTIBLE into iscsit_allocate_cmd().

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c  |   14 +++++++-------
 drivers/target/iscsi/iscsi_target.c      |   14 +++++++-------
 drivers/target/iscsi/iscsi_target_util.c |    7 +++----
 drivers/target/iscsi/iscsi_target_util.h |    2 +-
 include/target/iscsi/iscsi_transport.h   |    2 +-
 5 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 421182b..63bcf69 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -1028,13 +1028,13 @@ isert_rx_login_req(struct iser_rx_desc *rx_desc, int rx_buflen,
 }
 
 static struct iscsi_cmd
-*isert_allocate_cmd(struct iscsi_conn *conn, gfp_t gfp)
+*isert_allocate_cmd(struct iscsi_conn *conn)
 {
 	struct isert_conn *isert_conn = (struct isert_conn *)conn->context;
 	struct isert_cmd *isert_cmd;
 	struct iscsi_cmd *cmd;
 
-	cmd = iscsit_allocate_cmd(conn, gfp);
+	cmd = iscsit_allocate_cmd(conn, TASK_INTERRUPTIBLE);
 	if (!cmd) {
 		pr_err("Unable to allocate iscsi_cmd + isert_cmd\n");
 		return NULL;
@@ -1223,7 +1223,7 @@ isert_rx_opcode(struct isert_conn *isert_conn, struct iser_rx_desc *rx_desc,
 
 	switch (opcode) {
 	case ISCSI_OP_SCSI_CMD:
-		cmd = isert_allocate_cmd(conn, GFP_KERNEL);
+		cmd = isert_allocate_cmd(conn);
 		if (!cmd)
 			break;
 
@@ -1237,7 +1237,7 @@ isert_rx_opcode(struct isert_conn *isert_conn, struct iser_rx_desc *rx_desc,
 					rx_desc, (unsigned char *)hdr);
 		break;
 	case ISCSI_OP_NOOP_OUT:
-		cmd = isert_allocate_cmd(conn, GFP_KERNEL);
+		cmd = isert_allocate_cmd(conn);
 		if (!cmd)
 			break;
 
@@ -1250,7 +1250,7 @@ isert_rx_opcode(struct isert_conn *isert_conn, struct iser_rx_desc *rx_desc,
 						(unsigned char *)hdr);
 		break;
 	case ISCSI_OP_SCSI_TMFUNC:
-		cmd = isert_allocate_cmd(conn, GFP_KERNEL);
+		cmd = isert_allocate_cmd(conn);
 		if (!cmd)
 			break;
 
@@ -1258,7 +1258,7 @@ isert_rx_opcode(struct isert_conn *isert_conn, struct iser_rx_desc *rx_desc,
 						(unsigned char *)hdr);
 		break;
 	case ISCSI_OP_LOGOUT:
-		cmd = isert_allocate_cmd(conn, GFP_KERNEL);
+		cmd = isert_allocate_cmd(conn);
 		if (!cmd)
 			break;
 
@@ -1269,7 +1269,7 @@ isert_rx_opcode(struct isert_conn *isert_conn, struct iser_rx_desc *rx_desc,
 						    HZ);
 		break;
 	case ISCSI_OP_TEXT:
-		cmd = isert_allocate_cmd(conn, GFP_KERNEL);
+		cmd = isert_allocate_cmd(conn);
 		if (!cmd)
 			break;
 
diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index d70e911..2a52752 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -621,7 +621,7 @@ static int iscsit_add_reject(
 {
 	struct iscsi_cmd *cmd;
 
-	cmd = iscsit_allocate_cmd(conn, GFP_KERNEL);
+	cmd = iscsit_allocate_cmd(conn, TASK_INTERRUPTIBLE);
 	if (!cmd)
 		return -1;
 
@@ -2476,7 +2476,7 @@ static void iscsit_build_conn_drop_async_message(struct iscsi_conn *conn)
 	if (!conn_p)
 		return;
 
-	cmd = iscsit_allocate_cmd(conn_p, GFP_ATOMIC);
+	cmd = iscsit_allocate_cmd(conn_p, TASK_RUNNING);
 	if (!cmd) {
 		iscsit_dec_conn_usage_count(conn_p);
 		return;
@@ -3952,7 +3952,7 @@ static int iscsi_target_rx_opcode(struct iscsi_conn *conn, unsigned char *buf)
 
 	switch (hdr->opcode & ISCSI_OPCODE_MASK) {
 	case ISCSI_OP_SCSI_CMD:
-		cmd = iscsit_allocate_cmd(conn, GFP_KERNEL);
+		cmd = iscsit_allocate_cmd(conn, TASK_INTERRUPTIBLE);
 		if (!cmd)
 			goto reject;
 
@@ -3964,28 +3964,28 @@ static int iscsi_target_rx_opcode(struct iscsi_conn *conn, unsigned char *buf)
 	case ISCSI_OP_NOOP_OUT:
 		cmd = NULL;
 		if (hdr->ttt == cpu_to_be32(0xFFFFFFFF)) {
-			cmd = iscsit_allocate_cmd(conn, GFP_KERNEL);
+			cmd = iscsit_allocate_cmd(conn, TASK_INTERRUPTIBLE);
 			if (!cmd)
 				goto reject;
 		}
 		ret = iscsit_handle_nop_out(conn, cmd, buf);
 		break;
 	case ISCSI_OP_SCSI_TMFUNC:
-		cmd = iscsit_allocate_cmd(conn, GFP_KERNEL);
+		cmd = iscsit_allocate_cmd(conn, TASK_INTERRUPTIBLE);
 		if (!cmd)
 			goto reject;
 
 		ret = iscsit_handle_task_mgt_cmd(conn, cmd, buf);
 		break;
 	case ISCSI_OP_TEXT:
-		cmd = iscsit_allocate_cmd(conn, GFP_KERNEL);
+		cmd = iscsit_allocate_cmd(conn, TASK_INTERRUPTIBLE);
 		if (!cmd)
 			goto reject;
 
 		ret = iscsit_handle_text_cmd(conn, cmd, buf);
 		break;
 	case ISCSI_OP_LOGOUT:
-		cmd = iscsit_allocate_cmd(conn, GFP_KERNEL);
+		cmd = iscsit_allocate_cmd(conn, TASK_INTERRUPTIBLE);
 		if (!cmd)
 			goto reject;
 
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 5477eca..e655b04 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -152,12 +152,11 @@ void iscsit_free_r2ts_from_list(struct iscsi_cmd *cmd)
  * May be called from software interrupt (timer) context for allocating
  * iSCSI NopINs.
  */
-struct iscsi_cmd *iscsit_allocate_cmd(struct iscsi_conn *conn, gfp_t gfp_mask)
+struct iscsi_cmd *iscsit_allocate_cmd(struct iscsi_conn *conn, int state)
 {
 	struct iscsi_cmd *cmd;
 	struct se_session *se_sess = conn->sess->se_sess;
-	int size, tag, state = (gfp_mask & __GFP_WAIT) ? TASK_INTERRUPTIBLE :
-				TASK_RUNNING;
+	int size, tag;
 
 	tag = percpu_ida_alloc(&se_sess->sess_tag_pool, state);
 	if (tag < 0)
@@ -930,7 +929,7 @@ static int iscsit_add_nopin(struct iscsi_conn *conn, int want_response)
 	u8 state;
 	struct iscsi_cmd *cmd;
 
-	cmd = iscsit_allocate_cmd(conn, GFP_ATOMIC);
+	cmd = iscsit_allocate_cmd(conn, TASK_RUNNING);
 	if (!cmd)
 		return -1;
 
diff --git a/drivers/target/iscsi/iscsi_target_util.h b/drivers/target/iscsi/iscsi_target_util.h
index e4fc34a..561a424 100644
--- a/drivers/target/iscsi/iscsi_target_util.h
+++ b/drivers/target/iscsi/iscsi_target_util.h
@@ -9,7 +9,7 @@ extern struct iscsi_r2t *iscsit_get_r2t_from_list(struct iscsi_cmd *);
 extern void iscsit_free_r2t(struct iscsi_r2t *, struct iscsi_cmd *);
 extern void iscsit_free_r2ts_from_list(struct iscsi_cmd *);
 extern struct iscsi_cmd *iscsit_alloc_cmd(struct iscsi_conn *, gfp_t);
-extern struct iscsi_cmd *iscsit_allocate_cmd(struct iscsi_conn *, gfp_t);
+extern struct iscsi_cmd *iscsit_allocate_cmd(struct iscsi_conn *, int);
 extern struct iscsi_seq *iscsit_get_seq_holder_for_datain(struct iscsi_cmd *, u32);
 extern struct iscsi_seq *iscsit_get_seq_holder_for_r2t(struct iscsi_cmd *);
 extern struct iscsi_r2t *iscsit_get_holder_for_r2tsn(struct iscsi_cmd *, u32);
diff --git a/include/target/iscsi/iscsi_transport.h b/include/target/iscsi/iscsi_transport.h
index a12589c..ae5a171 100644
--- a/include/target/iscsi/iscsi_transport.h
+++ b/include/target/iscsi/iscsi_transport.h
@@ -94,7 +94,7 @@ extern int iscsit_tmr_post_handler(struct iscsi_cmd *, struct iscsi_conn *);
 /*
  * From iscsi_target_util.c
  */
-extern struct iscsi_cmd *iscsit_allocate_cmd(struct iscsi_conn *, gfp_t);
+extern struct iscsi_cmd *iscsit_allocate_cmd(struct iscsi_conn *, int);
 extern int iscsit_sequence_cmd(struct iscsi_conn *, struct iscsi_cmd *,
 			       unsigned char *, __be32);
 extern void iscsit_release_cmd(struct iscsi_cmd *);
-- 
1.7.10.4

