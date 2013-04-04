Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759927Ab3DDMct (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 08:32:49 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:64416 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759744Ab3DDMcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 08:32:45 -0400
From: Serban Constantinescu <serban.constantinescu@arm.com>
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        kernel-team@android.com, arve@android.com, john.stultz@linaro.org,
        Dave.Butcher@arm.com
Cc: Serban Constantinescu <serban.constantinescu@arm.com>
Subject: [PATCH 1/8] staging: android: binder: replace explicit size types
Date: Thu,  4 Apr 2013 13:32:31 +0100
Message-Id: <1365078758-28674-2-git-send-email-serban.constantinescu@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365078758-28674-1-git-send-email-serban.constantinescu@arm.com>
References: <1365078758-28674-1-git-send-email-serban.constantinescu@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the binder driver uses both uint32_t and unsigned int any further
kernel changes will be difficult to read. This patch fixes the inconsistent
types usage.

The patch does not change in any way the functionality of the binder driver.

Signed-off-by: Serban Constantinescu <serban.constantinescu@arm.com>
---
 drivers/staging/android/binder.c |   74 +++++++++++++++++++-------------------
 1 file changed, 37 insertions(+), 37 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index 24456a0..5794cf6 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -103,7 +103,7 @@ enum {
 	BINDER_DEBUG_PRIORITY_CAP           = 1U << 14,
 	BINDER_DEBUG_BUFFER_ALLOC_ASYNC     = 1U << 15,
 };
-static uint32_t binder_debug_mask = BINDER_DEBUG_USER_ERROR |
+static unsigned int binder_debug_mask = BINDER_DEBUG_USER_ERROR |
 	BINDER_DEBUG_FAILED_TRANSACTION | BINDER_DEBUG_DEAD_TRANSACTION;
 module_param_named(debug_mask, binder_debug_mask, uint, S_IWUSR | S_IRUGO);
 
@@ -255,7 +255,7 @@ struct binder_ref {
 	struct hlist_node node_entry;
 	struct binder_proc *proc;
 	struct binder_node *node;
-	uint32_t desc;
+	unsigned int desc;
 	int strong;
 	int weak;
 	struct binder_ref_death *death;
@@ -307,7 +307,7 @@ struct binder_proc {
 
 	struct page **pages;
 	size_t buffer_size;
-	uint32_t buffer_free;
+	unsigned int buffer_free;
 	struct list_head todo;
 	wait_queue_head_t wait;
 	struct binder_stats stats;
@@ -336,8 +336,8 @@ struct binder_thread {
 	int looper;
 	struct binder_transaction *transaction_stack;
 	struct list_head todo;
-	uint32_t return_error; /* Write failed, return error code in read buf */
-	uint32_t return_error2; /* Write failed, return error code in read */
+	unsigned int return_error; /* Write failed, return error code in read buf */
+	unsigned int return_error2; /* Write failed, return error code in read */
 		/* buffer. Used when sending a reply to a dead process that */
 		/* we are also waiting on */
 	wait_queue_head_t wait;
@@ -993,7 +993,7 @@ static int binder_dec_node(struct binder_node *node, int strong, int internal)
 
 
 static struct binder_ref *binder_get_ref(struct binder_proc *proc,
-					 uint32_t desc)
+					 unsigned int desc)
 {
 	struct rb_node *n = proc->refs_by_desc.rb_node;
 	struct binder_ref *ref;
@@ -1173,7 +1173,7 @@ static void binder_pop_transaction(struct binder_thread *target_thread,
 }
 
 static void binder_send_failed_reply(struct binder_transaction *t,
-				     uint32_t error_code)
+				     unsigned int error_code)
 {
 	struct binder_thread *target_thread;
 	BUG_ON(t->flags & TF_ONE_WAY);
@@ -1310,7 +1310,7 @@ static void binder_transaction(struct binder_proc *proc,
 	wait_queue_head_t *target_wait;
 	struct binder_transaction *in_reply_to = NULL;
 	struct binder_transaction_log_entry *e;
-	uint32_t return_error;
+	unsigned int return_error;
 
 	e = binder_transaction_log_add(&binder_transaction_log);
 	e->call_type = reply ? 2 : !!(tr->flags & TF_ONE_WAY);
@@ -1702,14 +1702,14 @@ err_no_context_mgr_node:
 int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 			void __user *buffer, int size, signed long *consumed)
 {
-	uint32_t cmd;
+	unsigned int cmd;
 	void __user *ptr = buffer + *consumed;
 	void __user *end = buffer + size;
 
 	while (ptr < end && thread->return_error == BR_OK) {
-		if (get_user(cmd, (uint32_t __user *)ptr))
+		if (get_user(cmd, (unsigned int __user *)ptr))
 			return -EFAULT;
-		ptr += sizeof(uint32_t);
+		ptr += sizeof(unsigned int);
 		trace_binder_command(cmd);
 		if (_IOC_NR(cmd) < ARRAY_SIZE(binder_stats.bc)) {
 			binder_stats.bc[_IOC_NR(cmd)]++;
@@ -1721,13 +1721,13 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 		case BC_ACQUIRE:
 		case BC_RELEASE:
 		case BC_DECREFS: {
-			uint32_t target;
+			unsigned int target;
 			struct binder_ref *ref;
 			const char *debug_string;
 
-			if (get_user(target, (uint32_t __user *)ptr))
+			if (get_user(target, (unsigned int __user *)ptr))
 				return -EFAULT;
-			ptr += sizeof(uint32_t);
+			ptr += sizeof(unsigned int);
 			if (target == 0 && binder_context_mgr_node &&
 			    (cmd == BC_INCREFS || cmd == BC_ACQUIRE)) {
 				ref = binder_get_ref_for_node(proc,
@@ -1922,14 +1922,14 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 
 		case BC_REQUEST_DEATH_NOTIFICATION:
 		case BC_CLEAR_DEATH_NOTIFICATION: {
-			uint32_t target;
+			unsigned int target;
 			void __user *cookie;
 			struct binder_ref *ref;
 			struct binder_ref_death *death;
 
-			if (get_user(target, (uint32_t __user *)ptr))
+			if (get_user(target, (unsigned int __user *)ptr))
 				return -EFAULT;
-			ptr += sizeof(uint32_t);
+			ptr += sizeof(unsigned int);
 			if (get_user(cookie, (void __user * __user *)ptr))
 				return -EFAULT;
 			ptr += sizeof(void *);
@@ -2055,7 +2055,7 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 }
 
 void binder_stat_br(struct binder_proc *proc, struct binder_thread *thread,
-		    uint32_t cmd)
+		    unsigned int cmd)
 {
 	trace_binder_return(cmd);
 	if (_IOC_NR(cmd) < ARRAY_SIZE(binder_stats.br)) {
@@ -2090,9 +2090,9 @@ static int binder_thread_read(struct binder_proc *proc,
 	int wait_for_proc_work;
 
 	if (*consumed == 0) {
-		if (put_user(BR_NOOP, (uint32_t __user *)ptr))
+		if (put_user(BR_NOOP, (unsigned int __user *)ptr))
 			return -EFAULT;
-		ptr += sizeof(uint32_t);
+		ptr += sizeof(unsigned int);
 	}
 
 retry:
@@ -2101,17 +2101,17 @@ retry:
 
 	if (thread->return_error != BR_OK && ptr < end) {
 		if (thread->return_error2 != BR_OK) {
-			if (put_user(thread->return_error2, (uint32_t __user *)ptr))
+			if (put_user(thread->return_error2, (unsigned int __user *)ptr))
 				return -EFAULT;
-			ptr += sizeof(uint32_t);
+			ptr += sizeof(unsigned int);
 			binder_stat_br(proc, thread, thread->return_error2);
 			if (ptr == end)
 				goto done;
 			thread->return_error2 = BR_OK;
 		}
-		if (put_user(thread->return_error, (uint32_t __user *)ptr))
+		if (put_user(thread->return_error, (unsigned int __user *)ptr))
 			return -EFAULT;
-		ptr += sizeof(uint32_t);
+		ptr += sizeof(unsigned int);
 		binder_stat_br(proc, thread, thread->return_error);
 		thread->return_error = BR_OK;
 		goto done;
@@ -2159,7 +2159,7 @@ retry:
 		return ret;
 
 	while (1) {
-		uint32_t cmd;
+		unsigned int cmd;
 		struct binder_transaction_data tr;
 		struct binder_work *w;
 		struct binder_transaction *t = NULL;
@@ -2183,9 +2183,9 @@ retry:
 		} break;
 		case BINDER_WORK_TRANSACTION_COMPLETE: {
 			cmd = BR_TRANSACTION_COMPLETE;
-			if (put_user(cmd, (uint32_t __user *)ptr))
+			if (put_user(cmd, (unsigned int __user *)ptr))
 				return -EFAULT;
-			ptr += sizeof(uint32_t);
+			ptr += sizeof(unsigned int);
 
 			binder_stat_br(proc, thread, cmd);
 			binder_debug(BINDER_DEBUG_TRANSACTION_COMPLETE,
@@ -2198,7 +2198,7 @@ retry:
 		} break;
 		case BINDER_WORK_NODE: {
 			struct binder_node *node = container_of(w, struct binder_node, work);
-			uint32_t cmd = BR_NOOP;
+			unsigned int cmd = BR_NOOP;
 			const char *cmd_name;
 			int strong = node->internal_strong_refs || node->local_strong_refs;
 			int weak = !hlist_empty(&node->refs) || node->local_weak_refs || strong;
@@ -2224,9 +2224,9 @@ retry:
 				node->has_weak_ref = 0;
 			}
 			if (cmd != BR_NOOP) {
-				if (put_user(cmd, (uint32_t __user *)ptr))
+				if (put_user(cmd, (unsigned int __user *)ptr))
 					return -EFAULT;
-				ptr += sizeof(uint32_t);
+				ptr += sizeof(unsigned int);
 				if (put_user(node->ptr, (void * __user *)ptr))
 					return -EFAULT;
 				ptr += sizeof(void *);
@@ -2260,16 +2260,16 @@ retry:
 		case BINDER_WORK_DEAD_BINDER_AND_CLEAR:
 		case BINDER_WORK_CLEAR_DEATH_NOTIFICATION: {
 			struct binder_ref_death *death;
-			uint32_t cmd;
+			unsigned int cmd;
 
 			death = container_of(w, struct binder_ref_death, work);
 			if (w->type == BINDER_WORK_CLEAR_DEATH_NOTIFICATION)
 				cmd = BR_CLEAR_DEATH_NOTIFICATION_DONE;
 			else
 				cmd = BR_DEAD_BINDER;
-			if (put_user(cmd, (uint32_t __user *)ptr))
+			if (put_user(cmd, (unsigned int __user *)ptr))
 				return -EFAULT;
-			ptr += sizeof(uint32_t);
+			ptr += sizeof(unsigned int);
 			if (put_user(death->cookie, (void * __user *)ptr))
 				return -EFAULT;
 			ptr += sizeof(void *);
@@ -2334,9 +2334,9 @@ retry:
 					ALIGN(t->buffer->data_size,
 					    sizeof(void *));
 
-		if (put_user(cmd, (uint32_t __user *)ptr))
+		if (put_user(cmd, (unsigned int __user *)ptr))
 			return -EFAULT;
-		ptr += sizeof(uint32_t);
+		ptr += sizeof(unsigned int);
 		if (copy_to_user(ptr, &tr, sizeof(tr)))
 			return -EFAULT;
 		ptr += sizeof(tr);
@@ -2379,7 +2379,7 @@ done:
 		binder_debug(BINDER_DEBUG_THREADS,
 			     "%d:%d BR_SPAWN_LOOPER\n",
 			     proc->pid, thread->pid);
-		if (put_user(BR_SPAWN_LOOPER, (uint32_t __user *)buffer))
+		if (put_user(BR_SPAWN_LOOPER, (unsigned int __user *)buffer))
 			return -EFAULT;
 		binder_stat_br(proc, thread, BR_SPAWN_LOOPER);
 	}
@@ -2752,7 +2752,7 @@ static int binder_mmap(struct file *filp, struct vm_area_struct *vma)
 
 #ifdef CONFIG_CPU_CACHE_VIPT
 	if (cache_is_vipt_aliasing()) {
-		while (CACHE_COLOUR((vma->vm_start ^ (uint32_t)proc->buffer))) {
+		while (CACHE_COLOUR((vma->vm_start ^ (unsigned int)proc->buffer))) {
 			pr_info("binder_mmap: %d %lx-%lx maps %p bad alignment\n", proc->pid, vma->vm_start, vma->vm_end, proc->buffer);
 			vma->vm_start += PAGE_SIZE;
 		}
-- 
1.7.9.5

