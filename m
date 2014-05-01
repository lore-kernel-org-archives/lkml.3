Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215AbaEAG7Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 02:59:25 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:62360 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbaEAG7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 02:59:24 -0400
From: Jerry Snitselaar <dev@snitselaar.org>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, arve@android.com,
        gregkh@linuxfoundation.org
Subject: [PATCH] staging: binder: cleanup dereference of noderef expressions
Date: Wed, 30 Apr 2014 23:58:55 -0700
Message-Id: <1398927535-31263-1-git-send-email-dev@snitselaar.org>
X-Mailer: git-send-email 2.0.0.rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up sparse warnings for cred struct dereference.

Signed-off-by: Jerry Snitselaar <dev@snitselaar.org>
---
 drivers/staging/android/binder.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index fc59281..6279d82 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -1313,6 +1313,7 @@ static void binder_transaction(struct binder_proc *proc,
 	struct binder_transaction *in_reply_to = NULL;
 	struct binder_transaction_log_entry *e;
 	uint32_t return_error;
+	const struct cred *cred = __task_cred(proc->tsk);
 
 	e = binder_transaction_log_add(&binder_transaction_log);
 	e->call_type = reply ? 2 : !!(tr->flags & TF_ONE_WAY);
@@ -1452,7 +1453,7 @@ static void binder_transaction(struct binder_proc *proc,
 		t->from = thread;
 	else
 		t->from = NULL;
-	t->sender_euid = proc->tsk->cred->euid;
+	t->sender_euid = cred->euid;
 	t->to_proc = target_proc;
 	t->to_thread = target_thread;
 	t->code = tr->code;
@@ -2574,6 +2575,7 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	struct binder_thread *thread;
 	unsigned int size = _IOC_SIZE(cmd);
 	void __user *ubuf = (void __user *)arg;
+	const struct cred *cred = current_cred();
 
 	/*pr_info("binder_ioctl: %d:%d %x %lx\n", proc->pid, current->pid, cmd, arg);*/
 
@@ -2658,15 +2660,15 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			goto err;
 		}
 		if (uid_valid(binder_context_mgr_uid)) {
-			if (!uid_eq(binder_context_mgr_uid, current->cred->euid)) {
+			if (!uid_eq(binder_context_mgr_uid, cred->euid)) {
 				pr_err("BINDER_SET_CONTEXT_MGR bad uid %d != %d\n",
-				       from_kuid(&init_user_ns, current->cred->euid),
+				       from_kuid(&init_user_ns, cred->euid),
 				       from_kuid(&init_user_ns, binder_context_mgr_uid));
 				ret = -EPERM;
 				goto err;
 			}
 		} else
-			binder_context_mgr_uid = current->cred->euid;
+			binder_context_mgr_uid = cred->euid;
 		binder_context_mgr_node = binder_new_node(proc, 0, 0);
 		if (binder_context_mgr_node == NULL) {
 			ret = -ENOMEM;
-- 
2.0.0.rc0

