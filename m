Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbaATEFw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 23:05:52 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:44987 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031AbaATEF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 23:05:26 -0500
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Kent Overstreet <kmo@daterainc.com>, Jens Axboe <axboe@kernel.dk>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH-v2 3/3] iscsi-target: Fix connection reset hang with percpu_ida_alloc
Date: Mon, 20 Jan 2014 03:44:46 +0000
Message-Id: <1390189486-13579-4-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1390189486-13579-1-git-send-email-nab@linux-iscsi.org>
References: <1390189486-13579-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch addresses a bug where connection reset would hang
indefinately once percpu_ida_alloc() was starved for tags, due
to the fact that it always assumed uninterruptible sleep mode.

So now make percpu_ida_alloc() check for signal_pending_state() for
making interruptible sleep optional, and convert iscsit_allocate_cmd()
to set TASK_INTERRUPTIBLE for GFP_KERNEL, or TASK_RUNNING for
GFP_ATOMIC.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kent Overstreet <kmo@daterainc.com>
Cc: <stable@vger.kernel.org> #3.12+
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target_util.c |    2 +-
 lib/percpu_ida.c                         |    9 +++++++--
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 9b8e1db..5477eca 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -156,7 +156,7 @@ struct iscsi_cmd *iscsit_allocate_cmd(struct iscsi_conn *conn, gfp_t gfp_mask)
 {
 	struct iscsi_cmd *cmd;
 	struct se_session *se_sess = conn->sess->se_sess;
-	int size, tag, state = (gfp_mask & __GFP_WAIT) ? TASK_UNINTERRUPTIBLE :
+	int size, tag, state = (gfp_mask & __GFP_WAIT) ? TASK_INTERRUPTIBLE :
 				TASK_RUNNING;
 
 	tag = percpu_ida_alloc(&se_sess->sess_tag_pool, state);
diff --git a/lib/percpu_ida.c b/lib/percpu_ida.c
index a48ce2e..a667110 100644
--- a/lib/percpu_ida.c
+++ b/lib/percpu_ida.c
@@ -138,14 +138,14 @@ static inline unsigned alloc_local_tag(struct percpu_ida_cpu *tags)
  * tag_pool_init()), or otherwise -ENOSPC on allocation failure.
  *
  * Safe to be called from interrupt context (assuming it isn't passed
- * TASK_UNINTERRUPTIBLE, of course).
+ * TASK_UNINTERRUPTIBLE | TASK_INTERRUPTIBLE, of course).
  *
  * @gfp indicates whether or not to wait until a free id is available (it's not
  * used for internal memory allocations); thus if passed __GFP_WAIT we may sleep
  * however long it takes until another thread frees an id (same semantics as a
  * mempool).
  *
- * Will not fail if passed TASK_UNINTERRUPTIBLE.
+ * Will not fail if passed TASK_UNINTERRUPTIBLE | TASK_INTERRUPTIBLE.
  */
 int percpu_ida_alloc(struct percpu_ida *pool, int state)
 {
@@ -194,6 +194,11 @@ int percpu_ida_alloc(struct percpu_ida *pool, int state)
 		if (tag >= 0 || state == TASK_RUNNING)
 			break;
 
+		if (signal_pending_state(state, current)) {
+			tag = -ERESTARTSYS;
+			break;
+		}
+
 		schedule();
 
 		local_irq_save(flags);
-- 
1.7.10.4

