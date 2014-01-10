Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbaAJDVN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 22:21:13 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:39428 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbaAJDVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 22:21:05 -0500
From: "Nicholas A. Bellinger" <nab@daterainc.com>
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 2/3] iscsi-target: Fix connection reset hang with percpu_ida_alloc
Date: Fri, 10 Jan 2014 03:00:46 +0000
Message-Id: <1389322847-6570-3-git-send-email-nab@daterainc.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1389322847-6570-1-git-send-email-nab@daterainc.com>
References: <1389322847-6570-1-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch addresses a bug where connection reset would hang
indefinately when percpu_ida_alloc() was starved for tags,
and always assumed uninterruptible sleep mode.

So now with percpu_ida_alloc_state() available to make
interruptible sleep optional, convert iscsit_allocate_cmd()
to set TASK_INTERRUPTIBLE when GFP_KERNEL is passed, or
set TASK_RUNNING when GFP_ATOMIC is passed.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target_util.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 0819e68..6cf1d95 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -156,9 +156,13 @@ struct iscsi_cmd *iscsit_allocate_cmd(struct iscsi_conn *conn, gfp_t gfp_mask)
 {
 	struct iscsi_cmd *cmd;
 	struct se_session *se_sess = conn->sess->se_sess;
-	int size, tag;
+	int size, tag, state = (gfp_mask & __GFP_WAIT) ? TASK_INTERRUPTIBLE :
+				TASK_RUNNING;
+
+	tag = percpu_ida_alloc_state(&se_sess->sess_tag_pool, state);
+	if (tag < 0)
+		return NULL;
 
-	tag = percpu_ida_alloc(&se_sess->sess_tag_pool, gfp_mask);
 	size = sizeof(struct iscsi_cmd) + conn->conn_transport->priv_size;
 	cmd = (struct iscsi_cmd *)(se_sess->sess_cmd_map + (tag * size));
 	memset(cmd, 0, size);
-- 
1.7.10.4

