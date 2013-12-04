Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933043Ab3LDSLy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 13:11:54 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:52438 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753952Ab3LDSLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 13:11:52 -0500
From: Serban Constantinescu <serban.constantinescu@arm.com>
To: gregkh@linuxfoundation.org, arve@android.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, john.stultz@linaro.org,
        ccross@android.com, Dave.Butcher@arm.com, irogers@google.com,
        romlem@android.com
Cc: Serban Constantinescu <serban.constantinescu@arm.com>
Subject: [PATCH v1 1/9] staging: android: binder: Move some of the logic into subfunction
Date: Wed,  4 Dec 2013 18:09:33 +0000
Message-Id: <1386180581-6710-2-git-send-email-serban.constantinescu@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386180581-6710-1-git-send-email-serban.constantinescu@arm.com>
References: <1386180581-6710-1-git-send-email-serban.constantinescu@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves some of the logic for binder_thread_write() into
subfunctions. This way we can share more code with the binder compat
layer.

Signed-off-by: Serban Constantinescu <serban.constantinescu@arm.com>
---
 drivers/staging/android/binder.c |  403 +++++++++++++++++++++-----------------
 1 file changed, 220 insertions(+), 183 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index eaec1da..233889c 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -1700,6 +1700,217 @@ err_no_context_mgr_node:
 		thread->return_error = return_error;
 }
 
+static void bc_increfs_done(struct binder_proc *proc,
+		struct binder_thread *thread, uint32_t cmd,
+		void __user *node_ptr, void __user *cookie)
+{
+	struct binder_node *node;
+
+	node = binder_get_node(proc, node_ptr);
+	if (node == NULL) {
+		binder_user_error("%d:%d %s u%p no match\n",
+			proc->pid, thread->pid,
+			cmd == BC_INCREFS_DONE ?
+			"BC_INCREFS_DONE" :
+			"BC_ACQUIRE_DONE",
+			node_ptr);
+		return;
+	}
+	if (cookie != node->cookie) {
+		binder_user_error("%d:%d %s u%p node %d cookie mismatch %p != %p\n",
+			proc->pid, thread->pid,
+			cmd == BC_INCREFS_DONE ?
+			"BC_INCREFS_DONE" : "BC_ACQUIRE_DONE",
+			node_ptr, node->debug_id,
+			cookie, node->cookie);
+		return;
+	}
+	if (cmd == BC_ACQUIRE_DONE) {
+		if (node->pending_strong_ref == 0) {
+			binder_user_error("%d:%d BC_ACQUIRE_DONE node %d has no pending acquire request\n",
+				proc->pid, thread->pid,
+				node->debug_id);
+			return;
+		}
+		node->pending_strong_ref = 0;
+	} else {
+		if (node->pending_weak_ref == 0) {
+			binder_user_error("%d:%d BC_INCREFS_DONE node %d has no pending increfs request\n",
+				proc->pid, thread->pid,
+				node->debug_id);
+			return;
+		}
+		node->pending_weak_ref = 0;
+	}
+	binder_dec_node(node, cmd == BC_ACQUIRE_DONE, 0);
+	binder_debug(BINDER_DEBUG_USER_REFS,
+		     "%d:%d %s node %d ls %d lw %d\n",
+		     proc->pid, thread->pid,
+		     cmd == BC_INCREFS_DONE ?
+		     "BC_INCREFS_DONE" :
+		     "BC_ACQUIRE_DONE",
+		     node->debug_id, node->local_strong_refs,
+		     node->local_weak_refs);
+	return;
+}
+
+static void bc_free_buffer(struct binder_proc *proc,
+		    struct binder_thread *thread, void __user *data_ptr)
+{
+	struct binder_buffer *buffer;
+
+	buffer = binder_buffer_lookup(proc, data_ptr);
+	if (buffer == NULL) {
+		binder_user_error("%d:%d BC_FREE_BUFFER u%p no match\n",
+			proc->pid, thread->pid, data_ptr);
+		return;
+	}
+	if (!buffer->allow_user_free) {
+		binder_user_error("%d:%d BC_FREE_BUFFER u%p matched unreturned buffer\n",
+			proc->pid, thread->pid, data_ptr);
+		return;
+	}
+	binder_debug(BINDER_DEBUG_FREE_BUFFER,
+		     "%d:%d BC_FREE_BUFFER u%p found buffer %d for %s transaction\n",
+		     proc->pid, thread->pid, data_ptr, buffer->debug_id,
+		     buffer->transaction ? "active" : "finished");
+
+	if (buffer->transaction) {
+		buffer->transaction->buffer = NULL;
+		buffer->transaction = NULL;
+	}
+	if (buffer->async_transaction && buffer->target_node) {
+		BUG_ON(!buffer->target_node->has_async_transaction);
+		if (list_empty(&buffer->target_node->async_todo))
+			buffer->target_node->has_async_transaction = 0;
+		else
+			list_move_tail(buffer->target_node->async_todo.next, &thread->todo);
+	}
+	trace_binder_transaction_buffer_release(buffer);
+	binder_transaction_buffer_release(proc, buffer, NULL);
+	binder_free_buf(proc, buffer);
+	return;
+}
+
+static void bc_clear_death_notif(struct binder_proc *proc,
+		    struct binder_thread *thread, uint32_t cmd,
+		    uint32_t target, void __user *cookie)
+{
+	struct binder_ref *ref;
+	struct binder_ref_death *death;
+
+	ref = binder_get_ref(proc, target);
+	if (ref == NULL) {
+		binder_user_error("%d:%d %s invalid ref %d\n",
+			proc->pid, thread->pid,
+			cmd == BC_REQUEST_DEATH_NOTIFICATION ?
+			"BC_REQUEST_DEATH_NOTIFICATION" :
+			"BC_CLEAR_DEATH_NOTIFICATION",
+			target);
+		return;
+	}
+
+	binder_debug(BINDER_DEBUG_DEATH_NOTIFICATION,
+		     "%d:%d %s %p ref %d desc %d s %d w %d for node %d\n",
+		     proc->pid, thread->pid,
+		     cmd == BC_REQUEST_DEATH_NOTIFICATION ?
+		     "BC_REQUEST_DEATH_NOTIFICATION" :
+		     "BC_CLEAR_DEATH_NOTIFICATION",
+		     cookie, ref->debug_id, ref->desc,
+		     ref->strong, ref->weak, ref->node->debug_id);
+
+	if (cmd == BC_REQUEST_DEATH_NOTIFICATION) {
+		if (ref->death) {
+			binder_user_error("%d:%d BC_REQUEST_DEATH_NOTIFICATION death notification already set\n",
+				proc->pid, thread->pid);
+			return;
+		}
+		death = kzalloc(sizeof(*death), GFP_KERNEL);
+		if (death == NULL) {
+			thread->return_error = BR_ERROR;
+			binder_debug(BINDER_DEBUG_FAILED_TRANSACTION,
+				     "%d:%d BC_REQUEST_DEATH_NOTIFICATION failed\n",
+				     proc->pid, thread->pid);
+			return;
+		}
+		binder_stats_created(BINDER_STAT_DEATH);
+		INIT_LIST_HEAD(&death->work.entry);
+		death->cookie = cookie;
+		ref->death = death;
+		if (ref->node->proc == NULL) {
+			ref->death->work.type = BINDER_WORK_DEAD_BINDER;
+			if (thread->looper & (BINDER_LOOPER_STATE_REGISTERED | BINDER_LOOPER_STATE_ENTERED)) {
+				list_add_tail(&ref->death->work.entry, &thread->todo);
+			} else {
+				list_add_tail(&ref->death->work.entry, &proc->todo);
+				wake_up_interruptible(&proc->wait);
+			}
+		}
+	} else {
+		if (ref->death == NULL) {
+			binder_user_error("%d:%d BC_CLEAR_DEATH_NOTIFICATION death notification not active\n",
+				proc->pid, thread->pid);
+			return;
+		}
+		death = ref->death;
+		if (death->cookie != cookie) {
+			binder_user_error("%d:%d BC_CLEAR_DEATH_NOTIFICATION death notification cookie mismatch %p != %p\n",
+				proc->pid, thread->pid,
+				death->cookie, cookie);
+			return;
+		}
+		ref->death = NULL;
+		if (list_empty(&death->work.entry)) {
+			death->work.type = BINDER_WORK_CLEAR_DEATH_NOTIFICATION;
+			if (thread->looper & (BINDER_LOOPER_STATE_REGISTERED | BINDER_LOOPER_STATE_ENTERED)) {
+				list_add_tail(&death->work.entry, &thread->todo);
+			} else {
+				list_add_tail(&death->work.entry, &proc->todo);
+				wake_up_interruptible(&proc->wait);
+			}
+		} else {
+			BUG_ON(death->work.type != BINDER_WORK_DEAD_BINDER);
+			death->work.type = BINDER_WORK_DEAD_BINDER_AND_CLEAR;
+		}
+	}
+	return;
+}
+
+static void bc_dead_binder_done(struct binder_proc *proc,
+		    struct binder_thread *thread, void __user *cookie)
+{
+	struct binder_work *w;
+	struct binder_ref_death *death = NULL;
+
+	list_for_each_entry(w, &proc->delivered_death, entry) {
+		struct binder_ref_death *tmp_death = container_of(w, struct binder_ref_death, work);
+		if (tmp_death->cookie == cookie) {
+			death = tmp_death;
+			return;
+		}
+	}
+	binder_debug(BINDER_DEBUG_DEAD_BINDER,
+		     "%d:%d BC_DEAD_BINDER_DONE %p found %p\n",
+		     proc->pid, thread->pid, cookie, death);
+	if (death == NULL) {
+		binder_user_error("%d:%d BC_DEAD_BINDER_DONE %p not found\n",
+			proc->pid, thread->pid, cookie);
+		return;
+	}
+
+	list_del_init(&death->work.entry);
+	if (death->work.type == BINDER_WORK_DEAD_BINDER_AND_CLEAR) {
+		death->work.type = BINDER_WORK_CLEAR_DEATH_NOTIFICATION;
+		if (thread->looper & (BINDER_LOOPER_STATE_REGISTERED | BINDER_LOOPER_STATE_ENTERED)) {
+			list_add_tail(&death->work.entry, &thread->todo);
+		} else {
+			list_add_tail(&death->work.entry, &proc->todo);
+			wake_up_interruptible(&proc->wait);
+		}
+	}
+	return;
+}
+
 static int binder_thread_write(struct binder_proc *proc,
 			struct binder_thread *thread,
 			void __user *buffer, size_t size, size_t *consumed)
@@ -1775,7 +1986,6 @@ static int binder_thread_write(struct binder_proc *proc,
 		case BC_ACQUIRE_DONE: {
 			void __user *node_ptr;
 			void __user *cookie;
-			struct binder_node *node;
 
 			if (get_user(node_ptr, (void * __user *)ptr))
 				return -EFAULT;
@@ -1783,48 +1993,7 @@ static int binder_thread_write(struct binder_proc *proc,
 			if (get_user(cookie, (void * __user *)ptr))
 				return -EFAULT;
 			ptr += sizeof(void *);
-			node = binder_get_node(proc, node_ptr);
-			if (node == NULL) {
-				binder_user_error("%d:%d %s u%p no match\n",
-					proc->pid, thread->pid,
-					cmd == BC_INCREFS_DONE ?
-					"BC_INCREFS_DONE" :
-					"BC_ACQUIRE_DONE",
-					node_ptr);
-				break;
-			}
-			if (cookie != node->cookie) {
-				binder_user_error("%d:%d %s u%p node %d cookie mismatch %p != %p\n",
-					proc->pid, thread->pid,
-					cmd == BC_INCREFS_DONE ?
-					"BC_INCREFS_DONE" : "BC_ACQUIRE_DONE",
-					node_ptr, node->debug_id,
-					cookie, node->cookie);
-				break;
-			}
-			if (cmd == BC_ACQUIRE_DONE) {
-				if (node->pending_strong_ref == 0) {
-					binder_user_error("%d:%d BC_ACQUIRE_DONE node %d has no pending acquire request\n",
-						proc->pid, thread->pid,
-						node->debug_id);
-					break;
-				}
-				node->pending_strong_ref = 0;
-			} else {
-				if (node->pending_weak_ref == 0) {
-					binder_user_error("%d:%d BC_INCREFS_DONE node %d has no pending increfs request\n",
-						proc->pid, thread->pid,
-						node->debug_id);
-					break;
-				}
-				node->pending_weak_ref = 0;
-			}
-			binder_dec_node(node, cmd == BC_ACQUIRE_DONE, 0);
-			binder_debug(BINDER_DEBUG_USER_REFS,
-				     "%d:%d %s node %d ls %d lw %d\n",
-				     proc->pid, thread->pid,
-				     cmd == BC_INCREFS_DONE ? "BC_INCREFS_DONE" : "BC_ACQUIRE_DONE",
-				     node->debug_id, node->local_strong_refs, node->local_weak_refs);
+			bc_increfs_done(proc, thread, cmd, node_ptr, cookie);
 			break;
 		}
 		case BC_ATTEMPT_ACQUIRE:
@@ -1836,42 +2005,11 @@ static int binder_thread_write(struct binder_proc *proc,
 
 		case BC_FREE_BUFFER: {
 			void __user *data_ptr;
-			struct binder_buffer *buffer;
 
 			if (get_user(data_ptr, (void * __user *)ptr))
 				return -EFAULT;
 			ptr += sizeof(void *);
-
-			buffer = binder_buffer_lookup(proc, data_ptr);
-			if (buffer == NULL) {
-				binder_user_error("%d:%d BC_FREE_BUFFER u%p no match\n",
-					proc->pid, thread->pid, data_ptr);
-				break;
-			}
-			if (!buffer->allow_user_free) {
-				binder_user_error("%d:%d BC_FREE_BUFFER u%p matched unreturned buffer\n",
-					proc->pid, thread->pid, data_ptr);
-				break;
-			}
-			binder_debug(BINDER_DEBUG_FREE_BUFFER,
-				     "%d:%d BC_FREE_BUFFER u%p found buffer %d for %s transaction\n",
-				     proc->pid, thread->pid, data_ptr, buffer->debug_id,
-				     buffer->transaction ? "active" : "finished");
-
-			if (buffer->transaction) {
-				buffer->transaction->buffer = NULL;
-				buffer->transaction = NULL;
-			}
-			if (buffer->async_transaction && buffer->target_node) {
-				BUG_ON(!buffer->target_node->has_async_transaction);
-				if (list_empty(&buffer->target_node->async_todo))
-					buffer->target_node->has_async_transaction = 0;
-				else
-					list_move_tail(buffer->target_node->async_todo.next, &thread->todo);
-			}
-			trace_binder_transaction_buffer_release(buffer);
-			binder_transaction_buffer_release(proc, buffer, NULL);
-			binder_free_buf(proc, buffer);
+			bc_free_buffer(proc, thread, data_ptr);
 			break;
 		}
 
@@ -1926,8 +2064,6 @@ static int binder_thread_write(struct binder_proc *proc,
 		case BC_CLEAR_DEATH_NOTIFICATION: {
 			uint32_t target;
 			void __user *cookie;
-			struct binder_ref *ref;
-			struct binder_ref_death *death;
 
 			if (get_user(target, (uint32_t __user *)ptr))
 				return -EFAULT;
@@ -1935,117 +2071,18 @@ static int binder_thread_write(struct binder_proc *proc,
 			if (get_user(cookie, (void __user * __user *)ptr))
 				return -EFAULT;
 			ptr += sizeof(void *);
-			ref = binder_get_ref(proc, target);
-			if (ref == NULL) {
-				binder_user_error("%d:%d %s invalid ref %d\n",
-					proc->pid, thread->pid,
-					cmd == BC_REQUEST_DEATH_NOTIFICATION ?
-					"BC_REQUEST_DEATH_NOTIFICATION" :
-					"BC_CLEAR_DEATH_NOTIFICATION",
-					target);
-				break;
-			}
-
-			binder_debug(BINDER_DEBUG_DEATH_NOTIFICATION,
-				     "%d:%d %s %p ref %d desc %d s %d w %d for node %d\n",
-				     proc->pid, thread->pid,
-				     cmd == BC_REQUEST_DEATH_NOTIFICATION ?
-				     "BC_REQUEST_DEATH_NOTIFICATION" :
-				     "BC_CLEAR_DEATH_NOTIFICATION",
-				     cookie, ref->debug_id, ref->desc,
-				     ref->strong, ref->weak, ref->node->debug_id);
-
-			if (cmd == BC_REQUEST_DEATH_NOTIFICATION) {
-				if (ref->death) {
-					binder_user_error("%d:%d BC_REQUEST_DEATH_NOTIFICATION death notification already set\n",
-						proc->pid, thread->pid);
-					break;
-				}
-				death = kzalloc(sizeof(*death), GFP_KERNEL);
-				if (death == NULL) {
-					thread->return_error = BR_ERROR;
-					binder_debug(BINDER_DEBUG_FAILED_TRANSACTION,
-						     "%d:%d BC_REQUEST_DEATH_NOTIFICATION failed\n",
-						     proc->pid, thread->pid);
-					break;
-				}
-				binder_stats_created(BINDER_STAT_DEATH);
-				INIT_LIST_HEAD(&death->work.entry);
-				death->cookie = cookie;
-				ref->death = death;
-				if (ref->node->proc == NULL) {
-					ref->death->work.type = BINDER_WORK_DEAD_BINDER;
-					if (thread->looper & (BINDER_LOOPER_STATE_REGISTERED | BINDER_LOOPER_STATE_ENTERED)) {
-						list_add_tail(&ref->death->work.entry, &thread->todo);
-					} else {
-						list_add_tail(&ref->death->work.entry, &proc->todo);
-						wake_up_interruptible(&proc->wait);
-					}
-				}
-			} else {
-				if (ref->death == NULL) {
-					binder_user_error("%d:%d BC_CLEAR_DEATH_NOTIFICATION death notification not active\n",
-						proc->pid, thread->pid);
-					break;
-				}
-				death = ref->death;
-				if (death->cookie != cookie) {
-					binder_user_error("%d:%d BC_CLEAR_DEATH_NOTIFICATION death notification cookie mismatch %p != %p\n",
-						proc->pid, thread->pid,
-						death->cookie, cookie);
-					break;
-				}
-				ref->death = NULL;
-				if (list_empty(&death->work.entry)) {
-					death->work.type = BINDER_WORK_CLEAR_DEATH_NOTIFICATION;
-					if (thread->looper & (BINDER_LOOPER_STATE_REGISTERED | BINDER_LOOPER_STATE_ENTERED)) {
-						list_add_tail(&death->work.entry, &thread->todo);
-					} else {
-						list_add_tail(&death->work.entry, &proc->todo);
-						wake_up_interruptible(&proc->wait);
-					}
-				} else {
-					BUG_ON(death->work.type != BINDER_WORK_DEAD_BINDER);
-					death->work.type = BINDER_WORK_DEAD_BINDER_AND_CLEAR;
-				}
-			}
-		} break;
+			bc_clear_death_notif(proc, thread, cmd, target, cookie);
+			break;
+		}
 		case BC_DEAD_BINDER_DONE: {
-			struct binder_work *w;
 			void __user *cookie;
-			struct binder_ref_death *death = NULL;
+
 			if (get_user(cookie, (void __user * __user *)ptr))
 				return -EFAULT;
-
 			ptr += sizeof(void *);
-			list_for_each_entry(w, &proc->delivered_death, entry) {
-				struct binder_ref_death *tmp_death = container_of(w, struct binder_ref_death, work);
-				if (tmp_death->cookie == cookie) {
-					death = tmp_death;
-					break;
-				}
-			}
-			binder_debug(BINDER_DEBUG_DEAD_BINDER,
-				     "%d:%d BC_DEAD_BINDER_DONE %p found %p\n",
-				     proc->pid, thread->pid, cookie, death);
-			if (death == NULL) {
-				binder_user_error("%d:%d BC_DEAD_BINDER_DONE %p not found\n",
-					proc->pid, thread->pid, cookie);
-				break;
-			}
-
-			list_del_init(&death->work.entry);
-			if (death->work.type == BINDER_WORK_DEAD_BINDER_AND_CLEAR) {
-				death->work.type = BINDER_WORK_CLEAR_DEATH_NOTIFICATION;
-				if (thread->looper & (BINDER_LOOPER_STATE_REGISTERED | BINDER_LOOPER_STATE_ENTERED)) {
-					list_add_tail(&death->work.entry, &thread->todo);
-				} else {
-					list_add_tail(&death->work.entry, &proc->todo);
-					wake_up_interruptible(&proc->wait);
-				}
-			}
-		} break;
-
+			bc_dead_binder_done(proc, thread, cookie);
+			break;
+		}
 		default:
 			pr_err("%d:%d unknown command %d\n",
 			       proc->pid, thread->pid, cmd);
-- 
1.7.9.5

