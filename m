Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933171Ab3LDSOM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 13:14:12 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:52517 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933079Ab3LDSNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 13:13:36 -0500
From: Serban Constantinescu <serban.constantinescu@arm.com>
To: gregkh@linuxfoundation.org, arve@android.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, john.stultz@linaro.org,
        ccross@android.com, Dave.Butcher@arm.com, irogers@google.com,
        romlem@android.com
Cc: Serban Constantinescu <serban.constantinescu@arm.com>
Subject: [PATCH v1 3/9] staging: android: binder: Add cmd == CMD_NAME handling
Date: Wed,  4 Dec 2013 18:09:35 +0000
Message-Id: <1386180581-6710-4-git-send-email-serban.constantinescu@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386180581-6710-1-git-send-email-serban.constantinescu@arm.com>
References: <1386180581-6710-1-git-send-email-serban.constantinescu@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies the functions that need to be passed the explicit
command to use a boolean flag. This way we can reuse the code for 64bit
compat commands.

Signed-off-by: Serban Constantinescu <serban.constantinescu@arm.com>
---
 drivers/staging/android/binder.c |   35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index 6fbb340..16109cd 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -1701,7 +1701,7 @@ err_no_context_mgr_node:
 }
 
 static void bc_increfs_done(struct binder_proc *proc,
-		struct binder_thread *thread, uint32_t cmd,
+		struct binder_thread *thread, bool acquire,
 		void __user *node_ptr, void __user *cookie)
 {
 	struct binder_node *node;
@@ -1710,22 +1710,22 @@ static void bc_increfs_done(struct binder_proc *proc,
 	if (node == NULL) {
 		binder_user_error("%d:%d %s u%p no match\n",
 			proc->pid, thread->pid,
-			cmd == BC_INCREFS_DONE ?
-			"BC_INCREFS_DONE" :
-			"BC_ACQUIRE_DONE",
+			acquire ?
+			"BC_ACQUIRE_DONE" :
+			"BC_INCREFS_DONE",
 			node_ptr);
 		return;
 	}
 	if (cookie != node->cookie) {
 		binder_user_error("%d:%d %s u%p node %d cookie mismatch %p != %p\n",
 			proc->pid, thread->pid,
-			cmd == BC_INCREFS_DONE ?
-			"BC_INCREFS_DONE" : "BC_ACQUIRE_DONE",
+			acquire ?
+			"BC_ACQUIRE_DONE" : "BC_INCREFS_DONE",
 			node_ptr, node->debug_id,
 			cookie, node->cookie);
 		return;
 	}
-	if (cmd == BC_ACQUIRE_DONE) {
+	if (acquire) {
 		if (node->pending_strong_ref == 0) {
 			binder_user_error("%d:%d BC_ACQUIRE_DONE node %d has no pending acquire request\n",
 				proc->pid, thread->pid,
@@ -1742,13 +1742,13 @@ static void bc_increfs_done(struct binder_proc *proc,
 		}
 		node->pending_weak_ref = 0;
 	}
-	binder_dec_node(node, cmd == BC_ACQUIRE_DONE, 0);
+	binder_dec_node(node, acquire, 0);
 	binder_debug(BINDER_DEBUG_USER_REFS,
 		     "%d:%d %s node %d ls %d lw %d\n",
 		     proc->pid, thread->pid,
-		     cmd == BC_INCREFS_DONE ?
-		     "BC_INCREFS_DONE" :
-		     "BC_ACQUIRE_DONE",
+		     acquire ?
+		     "BC_ACQUIRE_DONE" :
+		     "BC_INCREFS_DONE",
 		     node->debug_id, node->local_strong_refs,
 		     node->local_weak_refs);
 	return;
@@ -1793,7 +1793,7 @@ static void bc_free_buffer(struct binder_proc *proc,
 }
 
 static void bc_clear_death_notif(struct binder_proc *proc,
-		    struct binder_thread *thread, uint32_t cmd,
+		    struct binder_thread *thread, bool request,
 		    uint32_t target, void __user *cookie)
 {
 	struct binder_ref *ref;
@@ -1803,7 +1803,7 @@ static void bc_clear_death_notif(struct binder_proc *proc,
 	if (ref == NULL) {
 		binder_user_error("%d:%d %s invalid ref %d\n",
 			proc->pid, thread->pid,
-			cmd == BC_REQUEST_DEATH_NOTIFICATION ?
+			request ?
 			"BC_REQUEST_DEATH_NOTIFICATION" :
 			"BC_CLEAR_DEATH_NOTIFICATION",
 			target);
@@ -1813,13 +1813,13 @@ static void bc_clear_death_notif(struct binder_proc *proc,
 	binder_debug(BINDER_DEBUG_DEATH_NOTIFICATION,
 		     "%d:%d %s %p ref %d desc %d s %d w %d for node %d\n",
 		     proc->pid, thread->pid,
-		     cmd == BC_REQUEST_DEATH_NOTIFICATION ?
+		     request ?
 		     "BC_REQUEST_DEATH_NOTIFICATION" :
 		     "BC_CLEAR_DEATH_NOTIFICATION",
 		     cookie, ref->debug_id, ref->desc,
 		     ref->strong, ref->weak, ref->node->debug_id);
 
-	if (cmd == BC_REQUEST_DEATH_NOTIFICATION) {
+	if (request) {
 		if (ref->death) {
 			binder_user_error("%d:%d BC_REQUEST_DEATH_NOTIFICATION death notification already set\n",
 				proc->pid, thread->pid);
@@ -1993,7 +1993,7 @@ static int binder_thread_write(struct binder_proc *proc,
 			if (get_user(cookie, (void * __user *)ptr))
 				return -EFAULT;
 			ptr += sizeof(void *);
-			bc_increfs_done(proc, thread, cmd, node_ptr, cookie);
+			bc_increfs_done(proc, thread, cmd == BC_ACQUIRE_DONE, node_ptr, cookie);
 			break;
 		}
 		case BC_ATTEMPT_ACQUIRE:
@@ -2071,7 +2071,8 @@ static int binder_thread_write(struct binder_proc *proc,
 			if (get_user(cookie, (void __user * __user *)ptr))
 				return -EFAULT;
 			ptr += sizeof(void *);
-			bc_clear_death_notif(proc, thread, cmd, target, cookie);
+			bc_clear_death_notif(proc, thread, cmd == BC_REQUEST_DEATH_NOTIFICATION,
+					     target, cookie);
 			break;
 		}
 		case BC_DEAD_BINDER_DONE: {
-- 
1.7.9.5

