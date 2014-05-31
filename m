Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095AbaEaTnh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 15:43:37 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:54215 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbaEaTng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 15:43:36 -0400
Message-ID: <538A30E6.6010403@gmail.com>
Date: Sat, 31 May 2014 22:43:34 +0300
From: Tair Rzayev <tair.rzayev@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: swetland@google.com, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: android: binder.c: Use more appropriate functions
 for euid retrieval
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of getting the reference to whole credential structure, use
task_euid() and current_euid() to get it.

Signed-off-by: Tair Rzayev <tair.rzayev@gmail.com>
---
 drivers/staging/android/binder.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index e8dd7dd..989f809 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -1326,7 +1326,6 @@ static void binder_transaction(struct binder_proc *proc,
 	struct binder_transaction *in_reply_to = NULL;
 	struct binder_transaction_log_entry *e;
 	uint32_t return_error;
-	const struct cred *cred = __task_cred(proc->tsk);
 
 	e = binder_transaction_log_add(&binder_transaction_log);
 	e->call_type = reply ? 2 : !!(tr->flags & TF_ONE_WAY);
@@ -1468,7 +1467,7 @@ static void binder_transaction(struct binder_proc *proc,
 		t->from = thread;
 	else
 		t->from = NULL;
-	t->sender_euid = cred->euid;
+	t->sender_euid = task_euid(proc->tsk);
 	t->to_proc = target_proc;
 	t->to_thread = target_thread;
 	t->code = tr->code;
@@ -2602,7 +2601,7 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	struct binder_thread *thread;
 	unsigned int size = _IOC_SIZE(cmd);
 	void __user *ubuf = (void __user *)arg;
-	const struct cred *cred = current_cred();
+	kuid_t curr_euid = current_euid();
 
 	/*pr_info("binder_ioctl: %d:%d %x %lx\n", proc->pid, current->pid, cmd, arg);*/
 
@@ -2688,15 +2687,16 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			goto err;
 		}
 		if (uid_valid(binder_context_mgr_uid)) {
-			if (!uid_eq(binder_context_mgr_uid, cred->euid)) {
+			if (!uid_eq(binder_context_mgr_uid, curr_euid)) {
 				pr_err("BINDER_SET_CONTEXT_MGR bad uid %d != %d\n",
-				       from_kuid(&init_user_ns, cred->euid),
+				       from_kuid(&init_user_ns, curr_euid),
 				       from_kuid(&init_user_ns, binder_context_mgr_uid));
 				ret = -EPERM;
 				goto err;
 			}
-		} else
-			binder_context_mgr_uid = cred->euid;
+		} else {
+			binder_context_mgr_uid = curr_euid;
+		}
 		binder_context_mgr_node = binder_new_node(proc, 0, 0);
 		if (binder_context_mgr_node == NULL) {
 			ret = -ENOMEM;
-- 
1.9.1


