Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237AbaASKiP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 05:38:15 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:51136 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbaASKhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 05:37:35 -0500
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Kent Overstreet <kmo@daterainc.com>, Jens Axboe <axboe@kernel.dk>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3/5] target: Update percpu_ida_alloc to use task state bitmask
Date: Sun, 19 Jan 2014 10:16:54 +0000
Message-Id: <1390126616-29560-4-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1390126616-29560-1-git-send-email-nab@linux-iscsi.org>
References: <1390126616-29560-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch updates percpu_ida_alloc() for target/vhost to TASK_RUNNING
(cannot sleep) instead of GFP_ATOMIC, and updates iscsi-target to use
TASK_INTERRUPTIBLE (may sleep) or TASK_RUNNING (cannot sleep).

Both are following the changes to percpu_ida to allow for task state
bitmask to be passed from the caller.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <stable@vger.kernel.org> #3.12+
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target_util.c |    8 ++++++--
 drivers/vhost/scsi.c                     |    2 +-
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 0819e68..5477eca 100644
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
+	tag = percpu_ida_alloc(&se_sess->sess_tag_pool, state);
+	if (tag < 0)
+		return NULL;
 
-	tag = percpu_ida_alloc(&se_sess->sess_tag_pool, gfp_mask);
 	size = sizeof(struct iscsi_cmd) + conn->conn_transport->priv_size;
 	cmd = (struct iscsi_cmd *)(se_sess->sess_cmd_map + (tag * size));
 	memset(cmd, 0, size);
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 84488a8..2d084fb 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -728,7 +728,7 @@ vhost_scsi_get_tag(struct vhost_virtqueue *vq,
 	}
 	se_sess = tv_nexus->tvn_se_sess;
 
-	tag = percpu_ida_alloc(&se_sess->sess_tag_pool, GFP_ATOMIC);
+	tag = percpu_ida_alloc(&se_sess->sess_tag_pool, TASK_RUNNING);
 	if (tag < 0) {
 		pr_err("Unable to obtain tag for tcm_vhost_cmd\n");
 		return ERR_PTR(-ENOMEM);
-- 
1.7.10.4

