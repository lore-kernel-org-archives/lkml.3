Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127AbaBKUIa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:08:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40052 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589AbaBKTGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:06:50 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kent Overstreet <kmo@daterainc.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.12 060/107] iscsi-target: Fix connection reset hang with percpu_ida_alloc
Date: Tue, 11 Feb 2014 11:05:26 -0800
Message-Id: <20140211184749.910095285@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184748.191276235@linuxfoundation.org>
References: <20140211184748.191276235@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit 555b270e25b0279b98083518a85f4b1da144a181 upstream.

This patch addresses a bug where connection reset would hang
indefinately once percpu_ida_alloc() was starved for tags, due
to the fact that it always assumed uninterruptible sleep mode.

So now make percpu_ida_alloc() check for signal_pending_state() for
making interruptible sleep optional, and convert iscsit_allocate_cmd()
to set TASK_INTERRUPTIBLE for GFP_KERNEL, or TASK_RUNNING for
GFP_ATOMIC.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kent Overstreet <kmo@daterainc.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/iscsi/iscsi_target_util.c |    2 +-
 lib/percpu_ida.c                         |    9 +++++++--
 2 files changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -156,7 +156,7 @@ struct iscsi_cmd *iscsit_allocate_cmd(st
 {
 	struct iscsi_cmd *cmd;
 	struct se_session *se_sess = conn->sess->se_sess;
-	int size, tag, state = (gfp_mask & __GFP_WAIT) ? TASK_UNINTERRUPTIBLE :
+	int size, tag, state = (gfp_mask & __GFP_WAIT) ? TASK_INTERRUPTIBLE :
 				TASK_RUNNING;
 
 	tag = percpu_ida_alloc(&se_sess->sess_tag_pool, state);
--- a/lib/percpu_ida.c
+++ b/lib/percpu_ida.c
@@ -148,14 +148,14 @@ static inline unsigned alloc_local_tag(s
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
@@ -205,6 +205,11 @@ int percpu_ida_alloc(struct percpu_ida *
 		if (tag >= 0 || state == TASK_RUNNING)
 			break;
 
+		if (signal_pending_state(state, current)) {
+			tag = -ERESTARTSYS;
+			break;
+		}
+
 		schedule();
 
 		local_irq_save(flags);


