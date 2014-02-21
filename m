Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021AbaBUWkm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 17:40:42 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:38294 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278AbaBUWkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 17:40:35 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Greg KH <gregkh@linuxfoundation.org>, Colin Cross <ccross@android.com>,
        Serban Constantinescu <serban.constantinescu@arm.com>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCHv2 2/3] staging: binder: Support concurrent 32 bit and 64 bit processes.
Date: Fri, 21 Feb 2014 14:40:26 -0800
Message-Id: <1393022427-14364-3-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393022427-14364-1-git-send-email-john.stultz@linaro.org>
References: <1393022427-14364-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arve Hjønnevåg <arve@android.com>

For 64bit systems we want to use the same binder interface for 32bit and
64bit processes. Thus the size and the layout of the structures passed
between the kernel and the userspace has to be the same for both 32 and
64bit processes.

This change replaces all the uses of void* and size_t with
binder_uintptr_t and binder_size_t. These are then typedefed to specific
sizes depending on the use of the interface, as follows:
       * __u32 - on legacy 32bit only userspace
       * __u64 - on mixed 32/64bit userspace where all processes use the same
interface.

This change also increments the BINDER_CURRENT_PROTOCOL_VERSION to 8 and
hooks the compat_ioctl entry for the mixed 32/64bit Android userspace.

This patch also provides a CONFIG_ANDROID_BINDER_IPC_32BIT option for
compatability, which if set which enables the old protocol, setting
BINDER_CURRENT_PROTOCOL_VERSION to 7, on 32 bit systems.

Please note that all 64bit kernels will use the 64bit Binder ABI.

Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Colin Cross <ccross@android.com>
Cc: Arve Hjønnevåg <arve@android.com>
Cc: Serban Constantinescu <serban.constantinescu@arm.com>
Cc: Android Kernel Team <kernel-team@android.com>
Signed-off-by: Arve Hjønnevåg <arve@android.com>
[jstultz: Merged with upstream type changes. Various whitespace fixes
and longer Kconfig description for checkpatch. Included improved commit
message from Serban (with a few tweaks).]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/Kconfig        |  12 ++
 drivers/staging/android/binder.c       | 268 ++++++++++++++++++---------------
 drivers/staging/android/binder.h       |   4 +
 drivers/staging/android/binder_trace.h |  14 +-
 drivers/staging/android/uapi/binder.h  |  64 +++++---
 5 files changed, 213 insertions(+), 149 deletions(-)

diff --git a/drivers/staging/android/Kconfig b/drivers/staging/android/Kconfig
index b91c758..3559690 100644
--- a/drivers/staging/android/Kconfig
+++ b/drivers/staging/android/Kconfig
@@ -20,6 +20,18 @@ config ANDROID_BINDER_IPC
 	  Android process, using Binder to identify, invoke and pass arguments
 	  between said processes.
 
+config ANDROID_BINDER_IPC_32BIT
+	bool "Use old 32-bit binder api"
+	depends on !64BIT
+	---help---
+	  The Binder API has been changed to support both 32 and 64bit
+	  applications in a mixed environment.
+
+	  Enable this to support an old 32-bit Android user-space (v4.4 and
+	  earlier).
+
+	  Note that enabling this will break newer Android user-space.
+
 config ASHMEM
 	bool "Enable the Anonymous Shared Memory Subsystem"
 	default n
diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index eaec1da..de8ecac 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -228,8 +228,8 @@ struct binder_node {
 	int internal_strong_refs;
 	int local_weak_refs;
 	int local_strong_refs;
-	void __user *ptr;
-	void __user *cookie;
+	binder_uintptr_t ptr;
+	binder_uintptr_t cookie;
 	unsigned has_strong_ref:1;
 	unsigned pending_strong_ref:1;
 	unsigned has_weak_ref:1;
@@ -242,7 +242,7 @@ struct binder_node {
 
 struct binder_ref_death {
 	struct binder_work work;
-	void __user *cookie;
+	binder_uintptr_t cookie;
 };
 
 struct binder_ref {
@@ -515,14 +515,14 @@ static void binder_insert_allocated_buffer(struct binder_proc *proc,
 }
 
 static struct binder_buffer *binder_buffer_lookup(struct binder_proc *proc,
-						  void __user *user_ptr)
+						  uintptr_t user_ptr)
 {
 	struct rb_node *n = proc->allocated_buffers.rb_node;
 	struct binder_buffer *buffer;
 	struct binder_buffer *kern_ptr;
 
-	kern_ptr = user_ptr - proc->user_buffer_offset
-		- offsetof(struct binder_buffer, data);
+	kern_ptr = (struct binder_buffer *)(user_ptr - proc->user_buffer_offset
+		- offsetof(struct binder_buffer, data));
 
 	while (n) {
 		buffer = rb_entry(n, struct binder_buffer, rb_node);
@@ -856,7 +856,7 @@ static void binder_free_buf(struct binder_proc *proc,
 }
 
 static struct binder_node *binder_get_node(struct binder_proc *proc,
-					   void __user *ptr)
+					   binder_uintptr_t ptr)
 {
 	struct rb_node *n = proc->nodes.rb_node;
 	struct binder_node *node;
@@ -875,8 +875,8 @@ static struct binder_node *binder_get_node(struct binder_proc *proc,
 }
 
 static struct binder_node *binder_new_node(struct binder_proc *proc,
-					   void __user *ptr,
-					   void __user *cookie)
+					   binder_uintptr_t ptr,
+					   binder_uintptr_t cookie)
 {
 	struct rb_node **p = &proc->nodes.rb_node;
 	struct rb_node *parent = NULL;
@@ -908,9 +908,9 @@ static struct binder_node *binder_new_node(struct binder_proc *proc,
 	INIT_LIST_HEAD(&node->work.entry);
 	INIT_LIST_HEAD(&node->async_todo);
 	binder_debug(BINDER_DEBUG_INTERNAL_REFS,
-		     "%d:%d node %d u%p c%p created\n",
+		     "%d:%d node %d u%016llx c%016llx created\n",
 		     proc->pid, current->pid, node->debug_id,
-		     node->ptr, node->cookie);
+		     (u64)node->ptr, (u64)node->cookie);
 	return node;
 }
 
@@ -1226,9 +1226,9 @@ static void binder_send_failed_reply(struct binder_transaction *t,
 
 static void binder_transaction_buffer_release(struct binder_proc *proc,
 					      struct binder_buffer *buffer,
-					      size_t *failed_at)
+					      binder_size_t *failed_at)
 {
-	size_t *offp, *off_end;
+	binder_size_t *offp, *off_end;
 	int debug_id = buffer->debug_id;
 
 	binder_debug(BINDER_DEBUG_TRANSACTION,
@@ -1239,7 +1239,8 @@ static void binder_transaction_buffer_release(struct binder_proc *proc,
 	if (buffer->target_node)
 		binder_dec_node(buffer->target_node, 1, 0);
 
-	offp = (size_t *)(buffer->data + ALIGN(buffer->data_size, sizeof(void *)));
+	offp = (binder_size_t *)(buffer->data +
+				 ALIGN(buffer->data_size, sizeof(void *)));
 	if (failed_at)
 		off_end = failed_at;
 	else
@@ -1249,8 +1250,8 @@ static void binder_transaction_buffer_release(struct binder_proc *proc,
 		if (*offp > buffer->data_size - sizeof(*fp) ||
 		    buffer->data_size < sizeof(*fp) ||
 		    !IS_ALIGNED(*offp, sizeof(u32))) {
-			pr_err("transaction release %d bad offset %zd, size %zd\n",
-			 debug_id, *offp, buffer->data_size);
+			pr_err("transaction release %d bad offset %lld, size %zd\n",
+			       debug_id, (u64)*offp, buffer->data_size);
 			continue;
 		}
 		fp = (struct flat_binder_object *)(buffer->data + *offp);
@@ -1259,13 +1260,13 @@ static void binder_transaction_buffer_release(struct binder_proc *proc,
 		case BINDER_TYPE_WEAK_BINDER: {
 			struct binder_node *node = binder_get_node(proc, fp->binder);
 			if (node == NULL) {
-				pr_err("transaction release %d bad node %p\n",
-					debug_id, fp->binder);
+				pr_err("transaction release %d bad node %016llx\n",
+				       debug_id, (u64)fp->binder);
 				break;
 			}
 			binder_debug(BINDER_DEBUG_TRANSACTION,
-				     "        node %d u%p\n",
-				     node->debug_id, node->ptr);
+				     "        node %d u%016llx\n",
+				     node->debug_id, (u64)node->ptr);
 			binder_dec_node(node, fp->type == BINDER_TYPE_BINDER, 0);
 		} break;
 		case BINDER_TYPE_HANDLE:
@@ -1303,7 +1304,7 @@ static void binder_transaction(struct binder_proc *proc,
 {
 	struct binder_transaction *t;
 	struct binder_work *tcomplete;
-	size_t *offp, *off_end;
+	binder_size_t *offp, *off_end;
 	struct binder_proc *target_proc;
 	struct binder_thread *target_thread = NULL;
 	struct binder_node *target_node = NULL;
@@ -1432,18 +1433,20 @@ static void binder_transaction(struct binder_proc *proc,
 
 	if (reply)
 		binder_debug(BINDER_DEBUG_TRANSACTION,
-			     "%d:%d BC_REPLY %d -> %d:%d, data %p-%p size %zd-%zd\n",
+			     "%d:%d BC_REPLY %d -> %d:%d, data %016llx-%016llx size %lld-%lld\n",
 			     proc->pid, thread->pid, t->debug_id,
 			     target_proc->pid, target_thread->pid,
-			     tr->data.ptr.buffer, tr->data.ptr.offsets,
-			     tr->data_size, tr->offsets_size);
+			     (u64)tr->data.ptr.buffer,
+			     (u64)tr->data.ptr.offsets,
+			     (u64)tr->data_size, (u64)tr->offsets_size);
 	else
 		binder_debug(BINDER_DEBUG_TRANSACTION,
-			     "%d:%d BC_TRANSACTION %d -> %d - node %d, data %p-%p size %zd-%zd\n",
+			     "%d:%d BC_TRANSACTION %d -> %d - node %d, data %016llx-%016llx size %lld-%lld\n",
 			     proc->pid, thread->pid, t->debug_id,
 			     target_proc->pid, target_node->debug_id,
-			     tr->data.ptr.buffer, tr->data.ptr.offsets,
-			     tr->data_size, tr->offsets_size);
+			     (u64)tr->data.ptr.buffer,
+			     (u64)tr->data.ptr.offsets,
+			     (u64)tr->data_size, (u64)tr->offsets_size);
 
 	if (!reply && !(tr->flags & TF_ONE_WAY))
 		t->from = thread;
@@ -1472,23 +1475,26 @@ static void binder_transaction(struct binder_proc *proc,
 	if (target_node)
 		binder_inc_node(target_node, 1, 0, NULL);
 
-	offp = (size_t *)(t->buffer->data + ALIGN(tr->data_size, sizeof(void *)));
+	offp = (binder_size_t *)(t->buffer->data +
+				 ALIGN(tr->data_size, sizeof(void *)));
 
-	if (copy_from_user(t->buffer->data, tr->data.ptr.buffer, tr->data_size)) {
+	if (copy_from_user(t->buffer->data, (const void __user *)(uintptr_t)
+			   tr->data.ptr.buffer, tr->data_size)) {
 		binder_user_error("%d:%d got transaction with invalid data ptr\n",
 				proc->pid, thread->pid);
 		return_error = BR_FAILED_REPLY;
 		goto err_copy_data_failed;
 	}
-	if (copy_from_user(offp, tr->data.ptr.offsets, tr->offsets_size)) {
+	if (copy_from_user(offp, (const void __user *)(uintptr_t)
+			   tr->data.ptr.offsets, tr->offsets_size)) {
 		binder_user_error("%d:%d got transaction with invalid offsets ptr\n",
 				proc->pid, thread->pid);
 		return_error = BR_FAILED_REPLY;
 		goto err_copy_data_failed;
 	}
-	if (!IS_ALIGNED(tr->offsets_size, sizeof(size_t))) {
-		binder_user_error("%d:%d got transaction with invalid offsets size, %zd\n",
-				proc->pid, thread->pid, tr->offsets_size);
+	if (!IS_ALIGNED(tr->offsets_size, sizeof(binder_size_t))) {
+		binder_user_error("%d:%d got transaction with invalid offsets size, %lld\n",
+				proc->pid, thread->pid, (u64)tr->offsets_size);
 		return_error = BR_FAILED_REPLY;
 		goto err_bad_offset;
 	}
@@ -1498,8 +1504,8 @@ static void binder_transaction(struct binder_proc *proc,
 		if (*offp > t->buffer->data_size - sizeof(*fp) ||
 		    t->buffer->data_size < sizeof(*fp) ||
 		    !IS_ALIGNED(*offp, sizeof(u32))) {
-			binder_user_error("%d:%d got transaction with invalid offset, %zd\n",
-					proc->pid, thread->pid, *offp);
+			binder_user_error("%d:%d got transaction with invalid offset, %lld\n",
+					  proc->pid, thread->pid, (u64)*offp);
 			return_error = BR_FAILED_REPLY;
 			goto err_bad_offset;
 		}
@@ -1519,10 +1525,10 @@ static void binder_transaction(struct binder_proc *proc,
 				node->accept_fds = !!(fp->flags & FLAT_BINDER_FLAG_ACCEPTS_FDS);
 			}
 			if (fp->cookie != node->cookie) {
-				binder_user_error("%d:%d sending u%p node %d, cookie mismatch %p != %p\n",
+				binder_user_error("%d:%d sending u%016llx node %d, cookie mismatch %016llx != %016llx\n",
 					proc->pid, thread->pid,
-					fp->binder, node->debug_id,
-					fp->cookie, node->cookie);
+					(u64)fp->binder, node->debug_id,
+					(u64)fp->cookie, (u64)node->cookie);
 				goto err_binder_get_ref_for_node_failed;
 			}
 			ref = binder_get_ref_for_node(target_proc, node);
@@ -1540,9 +1546,9 @@ static void binder_transaction(struct binder_proc *proc,
 
 			trace_binder_transaction_node_to_ref(t, node, ref);
 			binder_debug(BINDER_DEBUG_TRANSACTION,
-				     "        node %d u%p -> ref %d desc %d\n",
-				     node->debug_id, node->ptr, ref->debug_id,
-				     ref->desc);
+				     "        node %d u%016llx -> ref %d desc %d\n",
+				     node->debug_id, (u64)node->ptr,
+				     ref->debug_id, ref->desc);
 		} break;
 		case BINDER_TYPE_HANDLE:
 		case BINDER_TYPE_WEAK_HANDLE: {
@@ -1564,9 +1570,9 @@ static void binder_transaction(struct binder_proc *proc,
 				binder_inc_node(ref->node, fp->type == BINDER_TYPE_BINDER, 0, NULL);
 				trace_binder_transaction_ref_to_node(t, ref);
 				binder_debug(BINDER_DEBUG_TRANSACTION,
-					     "        ref %d desc %d -> node %d u%p\n",
+					     "        ref %d desc %d -> node %d u%016llx\n",
 					     ref->debug_id, ref->desc, ref->node->debug_id,
-					     ref->node->ptr);
+					     (u64)ref->node->ptr);
 			} else {
 				struct binder_ref *new_ref;
 				new_ref = binder_get_ref_for_node(target_proc, ref->node);
@@ -1682,9 +1688,9 @@ err_dead_binder:
 err_invalid_target_handle:
 err_no_context_mgr_node:
 	binder_debug(BINDER_DEBUG_FAILED_TRANSACTION,
-		     "%d:%d transaction failed %d, size %zd-%zd\n",
+		     "%d:%d transaction failed %d, size %lld-%lld\n",
 		     proc->pid, thread->pid, return_error,
-		     tr->data_size, tr->offsets_size);
+		     (u64)tr->data_size, (u64)tr->offsets_size);
 
 	{
 		struct binder_transaction_log_entry *fe;
@@ -1702,9 +1708,11 @@ err_no_context_mgr_node:
 
 static int binder_thread_write(struct binder_proc *proc,
 			struct binder_thread *thread,
-			void __user *buffer, size_t size, size_t *consumed)
+			binder_uintptr_t binder_buffer, size_t size,
+			binder_size_t *consumed)
 {
 	uint32_t cmd;
+	void __user *buffer = (void __user *)(uintptr_t)binder_buffer;
 	void __user *ptr = buffer + *consumed;
 	void __user *end = buffer + size;
 
@@ -1773,33 +1781,33 @@ static int binder_thread_write(struct binder_proc *proc,
 		}
 		case BC_INCREFS_DONE:
 		case BC_ACQUIRE_DONE: {
-			void __user *node_ptr;
-			void __user *cookie;
+			binder_uintptr_t node_ptr;
+			binder_uintptr_t cookie;
 			struct binder_node *node;
 
-			if (get_user(node_ptr, (void * __user *)ptr))
+			if (get_user(node_ptr, (binder_uintptr_t __user *)ptr))
 				return -EFAULT;
-			ptr += sizeof(void *);
-			if (get_user(cookie, (void * __user *)ptr))
+			ptr += sizeof(binder_uintptr_t);
+			if (get_user(cookie, (binder_uintptr_t __user *)ptr))
 				return -EFAULT;
-			ptr += sizeof(void *);
+			ptr += sizeof(binder_uintptr_t);
 			node = binder_get_node(proc, node_ptr);
 			if (node == NULL) {
-				binder_user_error("%d:%d %s u%p no match\n",
+				binder_user_error("%d:%d %s u%016llx no match\n",
 					proc->pid, thread->pid,
 					cmd == BC_INCREFS_DONE ?
 					"BC_INCREFS_DONE" :
 					"BC_ACQUIRE_DONE",
-					node_ptr);
+					(u64)node_ptr);
 				break;
 			}
 			if (cookie != node->cookie) {
-				binder_user_error("%d:%d %s u%p node %d cookie mismatch %p != %p\n",
+				binder_user_error("%d:%d %s u%016llx node %d cookie mismatch %016llx != %016llx\n",
 					proc->pid, thread->pid,
 					cmd == BC_INCREFS_DONE ?
 					"BC_INCREFS_DONE" : "BC_ACQUIRE_DONE",
-					node_ptr, node->debug_id,
-					cookie, node->cookie);
+					(u64)node_ptr, node->debug_id,
+					(u64)cookie, (u64)node->cookie);
 				break;
 			}
 			if (cmd == BC_ACQUIRE_DONE) {
@@ -1835,27 +1843,28 @@ static int binder_thread_write(struct binder_proc *proc,
 			return -EINVAL;
 
 		case BC_FREE_BUFFER: {
-			void __user *data_ptr;
+			binder_uintptr_t data_ptr;
 			struct binder_buffer *buffer;
 
-			if (get_user(data_ptr, (void * __user *)ptr))
+			if (get_user(data_ptr, (binder_uintptr_t __user *)ptr))
 				return -EFAULT;
-			ptr += sizeof(void *);
+			ptr += sizeof(binder_uintptr_t);
 
 			buffer = binder_buffer_lookup(proc, data_ptr);
 			if (buffer == NULL) {
-				binder_user_error("%d:%d BC_FREE_BUFFER u%p no match\n",
-					proc->pid, thread->pid, data_ptr);
+				binder_user_error("%d:%d BC_FREE_BUFFER u%016llx no match\n",
+					proc->pid, thread->pid, (u64)data_ptr);
 				break;
 			}
 			if (!buffer->allow_user_free) {
-				binder_user_error("%d:%d BC_FREE_BUFFER u%p matched unreturned buffer\n",
-					proc->pid, thread->pid, data_ptr);
+				binder_user_error("%d:%d BC_FREE_BUFFER u%016llx matched unreturned buffer\n",
+					proc->pid, thread->pid, (u64)data_ptr);
 				break;
 			}
 			binder_debug(BINDER_DEBUG_FREE_BUFFER,
-				     "%d:%d BC_FREE_BUFFER u%p found buffer %d for %s transaction\n",
-				     proc->pid, thread->pid, data_ptr, buffer->debug_id,
+				     "%d:%d BC_FREE_BUFFER u%016llx found buffer %d for %s transaction\n",
+				     proc->pid, thread->pid, (u64)data_ptr,
+				     buffer->debug_id,
 				     buffer->transaction ? "active" : "finished");
 
 			if (buffer->transaction) {
@@ -1925,16 +1934,16 @@ static int binder_thread_write(struct binder_proc *proc,
 		case BC_REQUEST_DEATH_NOTIFICATION:
 		case BC_CLEAR_DEATH_NOTIFICATION: {
 			uint32_t target;
-			void __user *cookie;
+			binder_uintptr_t cookie;
 			struct binder_ref *ref;
 			struct binder_ref_death *death;
 
 			if (get_user(target, (uint32_t __user *)ptr))
 				return -EFAULT;
 			ptr += sizeof(uint32_t);
-			if (get_user(cookie, (void __user * __user *)ptr))
+			if (get_user(cookie, (binder_uintptr_t __user *)ptr))
 				return -EFAULT;
-			ptr += sizeof(void *);
+			ptr += sizeof(binder_uintptr_t);
 			ref = binder_get_ref(proc, target);
 			if (ref == NULL) {
 				binder_user_error("%d:%d %s invalid ref %d\n",
@@ -1947,12 +1956,12 @@ static int binder_thread_write(struct binder_proc *proc,
 			}
 
 			binder_debug(BINDER_DEBUG_DEATH_NOTIFICATION,
-				     "%d:%d %s %p ref %d desc %d s %d w %d for node %d\n",
+				     "%d:%d %s %016llx ref %d desc %d s %d w %d for node %d\n",
 				     proc->pid, thread->pid,
 				     cmd == BC_REQUEST_DEATH_NOTIFICATION ?
 				     "BC_REQUEST_DEATH_NOTIFICATION" :
 				     "BC_CLEAR_DEATH_NOTIFICATION",
-				     cookie, ref->debug_id, ref->desc,
+				     (u64)cookie, ref->debug_id, ref->desc,
 				     ref->strong, ref->weak, ref->node->debug_id);
 
 			if (cmd == BC_REQUEST_DEATH_NOTIFICATION) {
@@ -1990,9 +1999,10 @@ static int binder_thread_write(struct binder_proc *proc,
 				}
 				death = ref->death;
 				if (death->cookie != cookie) {
-					binder_user_error("%d:%d BC_CLEAR_DEATH_NOTIFICATION death notification cookie mismatch %p != %p\n",
+					binder_user_error("%d:%d BC_CLEAR_DEATH_NOTIFICATION death notification cookie mismatch %016llx != %016llx\n",
 						proc->pid, thread->pid,
-						death->cookie, cookie);
+						(u64)death->cookie,
+						(u64)cookie);
 					break;
 				}
 				ref->death = NULL;
@@ -2012,9 +2022,9 @@ static int binder_thread_write(struct binder_proc *proc,
 		} break;
 		case BC_DEAD_BINDER_DONE: {
 			struct binder_work *w;
-			void __user *cookie;
+			binder_uintptr_t cookie;
 			struct binder_ref_death *death = NULL;
-			if (get_user(cookie, (void __user * __user *)ptr))
+			if (get_user(cookie, (binder_uintptr_t __user *)ptr))
 				return -EFAULT;
 
 			ptr += sizeof(void *);
@@ -2026,11 +2036,12 @@ static int binder_thread_write(struct binder_proc *proc,
 				}
 			}
 			binder_debug(BINDER_DEBUG_DEAD_BINDER,
-				     "%d:%d BC_DEAD_BINDER_DONE %p found %p\n",
-				     proc->pid, thread->pid, cookie, death);
+				     "%d:%d BC_DEAD_BINDER_DONE %016llx found %p\n",
+				     proc->pid, thread->pid, (u64)cookie,
+				     death);
 			if (death == NULL) {
-				binder_user_error("%d:%d BC_DEAD_BINDER_DONE %p not found\n",
-					proc->pid, thread->pid, cookie);
+				binder_user_error("%d:%d BC_DEAD_BINDER_DONE %016llx not found\n",
+					proc->pid, thread->pid, (u64)cookie);
 				break;
 			}
 
@@ -2082,9 +2093,10 @@ static int binder_has_thread_work(struct binder_thread *thread)
 
 static int binder_thread_read(struct binder_proc *proc,
 			      struct binder_thread *thread,
-			      void  __user *buffer, size_t size,
-			      size_t *consumed, int non_block)
+			      binder_uintptr_t binder_buffer, size_t size,
+			      binder_size_t *consumed, int non_block)
 {
+	void __user *buffer = (void __user *)(uintptr_t)binder_buffer;
 	void __user *ptr = buffer + *consumed;
 	void __user *end = buffer + size;
 
@@ -2229,32 +2241,40 @@ retry:
 				if (put_user(cmd, (uint32_t __user *)ptr))
 					return -EFAULT;
 				ptr += sizeof(uint32_t);
-				if (put_user(node->ptr, (void * __user *)ptr))
+				if (put_user(node->ptr,
+					     (binder_uintptr_t __user *)ptr))
 					return -EFAULT;
-				ptr += sizeof(void *);
-				if (put_user(node->cookie, (void * __user *)ptr))
+				ptr += sizeof(binder_uintptr_t);
+				if (put_user(node->cookie,
+					     (binder_uintptr_t __user *)ptr))
 					return -EFAULT;
-				ptr += sizeof(void *);
+				ptr += sizeof(binder_uintptr_t);
 
 				binder_stat_br(proc, thread, cmd);
 				binder_debug(BINDER_DEBUG_USER_REFS,
-					     "%d:%d %s %d u%p c%p\n",
-					     proc->pid, thread->pid, cmd_name, node->debug_id, node->ptr, node->cookie);
+					     "%d:%d %s %d u%016llx c%016llx\n",
+					     proc->pid, thread->pid, cmd_name,
+					     node->debug_id,
+					     (u64)node->ptr, (u64)node->cookie);
 			} else {
 				list_del_init(&w->entry);
 				if (!weak && !strong) {
 					binder_debug(BINDER_DEBUG_INTERNAL_REFS,
-						     "%d:%d node %d u%p c%p deleted\n",
-						     proc->pid, thread->pid, node->debug_id,
-						     node->ptr, node->cookie);
+						     "%d:%d node %d u%016llx c%016llx deleted\n",
+						     proc->pid, thread->pid,
+						     node->debug_id,
+						     (u64)node->ptr,
+						     (u64)node->cookie);
 					rb_erase(&node->rb_node, &proc->nodes);
 					kfree(node);
 					binder_stats_deleted(BINDER_STAT_NODE);
 				} else {
 					binder_debug(BINDER_DEBUG_INTERNAL_REFS,
-						     "%d:%d node %d u%p c%p state unchanged\n",
-						     proc->pid, thread->pid, node->debug_id, node->ptr,
-						     node->cookie);
+						     "%d:%d node %d u%016llx c%016llx state unchanged\n",
+						     proc->pid, thread->pid,
+						     node->debug_id,
+						     (u64)node->ptr,
+						     (u64)node->cookie);
 				}
 			}
 		} break;
@@ -2272,17 +2292,18 @@ retry:
 			if (put_user(cmd, (uint32_t __user *)ptr))
 				return -EFAULT;
 			ptr += sizeof(uint32_t);
-			if (put_user(death->cookie, (void * __user *)ptr))
+			if (put_user(death->cookie,
+				     (binder_uintptr_t __user *)ptr))
 				return -EFAULT;
-			ptr += sizeof(void *);
+			ptr += sizeof(binder_uintptr_t);
 			binder_stat_br(proc, thread, cmd);
 			binder_debug(BINDER_DEBUG_DEATH_NOTIFICATION,
-				     "%d:%d %s %p\n",
+				     "%d:%d %s %016llx\n",
 				      proc->pid, thread->pid,
 				      cmd == BR_DEAD_BINDER ?
 				      "BR_DEAD_BINDER" :
 				      "BR_CLEAR_DEATH_NOTIFICATION_DONE",
-				      death->cookie);
+				      (u64)death->cookie);
 
 			if (w->type == BINDER_WORK_CLEAR_DEATH_NOTIFICATION) {
 				list_del(&w->entry);
@@ -2312,8 +2333,8 @@ retry:
 				binder_set_nice(target_node->min_priority);
 			cmd = BR_TRANSACTION;
 		} else {
-			tr.target.ptr = NULL;
-			tr.cookie = NULL;
+			tr.target.ptr = 0;
+			tr.cookie = 0;
 			cmd = BR_REPLY;
 		}
 		tr.code = t->code;
@@ -2330,8 +2351,9 @@ retry:
 
 		tr.data_size = t->buffer->data_size;
 		tr.offsets_size = t->buffer->offsets_size;
-		tr.data.ptr.buffer = (void *)t->buffer->data +
-					proc->user_buffer_offset;
+		tr.data.ptr.buffer = (binder_uintptr_t)(
+					(uintptr_t)t->buffer->data +
+					proc->user_buffer_offset);
 		tr.data.ptr.offsets = tr.data.ptr.buffer +
 					ALIGN(t->buffer->data_size,
 					    sizeof(void *));
@@ -2346,14 +2368,14 @@ retry:
 		trace_binder_transaction_received(t);
 		binder_stat_br(proc, thread, cmd);
 		binder_debug(BINDER_DEBUG_TRANSACTION,
-			     "%d:%d %s %d %d:%d, cmd %d size %zd-%zd ptr %p-%p\n",
+			     "%d:%d %s %d %d:%d, cmd %d size %zd-%zd ptr %016llx-%016llx\n",
 			     proc->pid, thread->pid,
 			     (cmd == BR_TRANSACTION) ? "BR_TRANSACTION" :
 			     "BR_REPLY",
 			     t->debug_id, t->from ? t->from->proc->pid : 0,
 			     t->from ? t->from->pid : 0, cmd,
 			     t->buffer->data_size, t->buffer->offsets_size,
-			     tr.data.ptr.buffer, tr.data.ptr.offsets);
+			     (u64)tr.data.ptr.buffer, (u64)tr.data.ptr.offsets);
 
 		list_del(&t->work.entry);
 		t->buffer->allow_user_free = 1;
@@ -2423,8 +2445,8 @@ static void binder_release_work(struct list_head *list)
 
 			death = container_of(w, struct binder_ref_death, work);
 			binder_debug(BINDER_DEBUG_DEAD_TRANSACTION,
-				"undelivered death notification, %p\n",
-				death->cookie);
+				"undelivered death notification, %016llx\n",
+				(u64)death->cookie);
 			kfree(death);
 			binder_stats_deleted(BINDER_STAT_DEATH);
 		} break;
@@ -2580,12 +2602,16 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			goto err;
 		}
 		binder_debug(BINDER_DEBUG_READ_WRITE,
-			     "%d:%d write %zd at %016lx, read %zd at %016lx\n",
-			     proc->pid, thread->pid, bwr.write_size,
-			     bwr.write_buffer, bwr.read_size, bwr.read_buffer);
+			     "%d:%d write %lld at %016llx, read %lld at %016llx\n",
+			     proc->pid, thread->pid,
+			     (u64)bwr.write_size, (u64)bwr.write_buffer,
+			     (u64)bwr.read_size, (u64)bwr.read_buffer);
 
 		if (bwr.write_size > 0) {
-			ret = binder_thread_write(proc, thread, (void __user *)bwr.write_buffer, bwr.write_size, &bwr.write_consumed);
+			ret = binder_thread_write(proc, thread,
+						  bwr.write_buffer,
+						  bwr.write_size,
+						  &bwr.write_consumed);
 			trace_binder_write_done(ret);
 			if (ret < 0) {
 				bwr.read_consumed = 0;
@@ -2595,7 +2621,10 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			}
 		}
 		if (bwr.read_size > 0) {
-			ret = binder_thread_read(proc, thread, (void __user *)bwr.read_buffer, bwr.read_size, &bwr.read_consumed, filp->f_flags & O_NONBLOCK);
+			ret = binder_thread_read(proc, thread, bwr.read_buffer,
+						 bwr.read_size,
+						 &bwr.read_consumed,
+						 filp->f_flags & O_NONBLOCK);
 			trace_binder_read_done(ret);
 			if (!list_empty(&proc->todo))
 				wake_up_interruptible(&proc->wait);
@@ -2606,9 +2635,10 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			}
 		}
 		binder_debug(BINDER_DEBUG_READ_WRITE,
-			     "%d:%d wrote %zd of %zd, read return %zd of %zd\n",
-			     proc->pid, thread->pid, bwr.write_consumed, bwr.write_size,
-			     bwr.read_consumed, bwr.read_size);
+			     "%d:%d wrote %lld of %lld, read return %lld of %lld\n",
+			     proc->pid, thread->pid,
+			     (u64)bwr.write_consumed, (u64)bwr.write_size,
+			     (u64)bwr.read_consumed, (u64)bwr.read_size);
 		if (copy_to_user(ubuf, &bwr, sizeof(bwr))) {
 			ret = -EFAULT;
 			goto err;
@@ -2637,7 +2667,7 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			}
 		} else
 			binder_context_mgr_uid = current->cred->euid;
-		binder_context_mgr_node = binder_new_node(proc, NULL, NULL);
+		binder_context_mgr_node = binder_new_node(proc, 0, 0);
 		if (binder_context_mgr_node == NULL) {
 			ret = -ENOMEM;
 			goto err;
@@ -3133,8 +3163,9 @@ static void print_binder_work(struct seq_file *m, const char *prefix,
 		break;
 	case BINDER_WORK_NODE:
 		node = container_of(w, struct binder_node, work);
-		seq_printf(m, "%snode work %d: u%p c%p\n",
-			   prefix, node->debug_id, node->ptr, node->cookie);
+		seq_printf(m, "%snode work %d: u%016llx c%016llx\n",
+			   prefix, node->debug_id,
+			   (u64)node->ptr, (u64)node->cookie);
 		break;
 	case BINDER_WORK_DEAD_BINDER:
 		seq_printf(m, "%shas dead binder\n", prefix);
@@ -3194,8 +3225,8 @@ static void print_binder_node(struct seq_file *m, struct binder_node *node)
 	hlist_for_each_entry(ref, &node->refs, node_entry)
 		count++;
 
-	seq_printf(m, "  node %d: u%p c%p hs %d hw %d ls %d lw %d is %d iw %d",
-		   node->debug_id, node->ptr, node->cookie,
+	seq_printf(m, "  node %d: u%016llx c%016llx hs %d hw %d ls %d lw %d is %d iw %d",
+		   node->debug_id, (u64)node->ptr, (u64)node->cookie,
 		   node->has_strong_ref, node->has_weak_ref,
 		   node->local_strong_refs, node->local_weak_refs,
 		   node->internal_strong_refs, count);
@@ -3497,6 +3528,7 @@ static const struct file_operations binder_fops = {
 	.owner = THIS_MODULE,
 	.poll = binder_poll,
 	.unlocked_ioctl = binder_ioctl,
+	.compat_ioctl = binder_ioctl,
 	.mmap = binder_mmap,
 	.open = binder_open,
 	.flush = binder_flush,
diff --git a/drivers/staging/android/binder.h b/drivers/staging/android/binder.h
index d4101a6..eb08346 100644
--- a/drivers/staging/android/binder.h
+++ b/drivers/staging/android/binder.h
@@ -20,6 +20,10 @@
 #ifndef _LINUX_BINDER_H
 #define _LINUX_BINDER_H
 
+#ifdef CONFIG_ANDROID_BINDER_IPC_32BIT
+#define BINDER_IPC_32BIT 1
+#endif
+
 #include "uapi/binder.h"
 
 #endif /* _LINUX_BINDER_H */
diff --git a/drivers/staging/android/binder_trace.h b/drivers/staging/android/binder_trace.h
index 82a567c..7f20f3d 100644
--- a/drivers/staging/android/binder_trace.h
+++ b/drivers/staging/android/binder_trace.h
@@ -152,7 +152,7 @@ TRACE_EVENT(binder_transaction_node_to_ref,
 	TP_STRUCT__entry(
 		__field(int, debug_id)
 		__field(int, node_debug_id)
-		__field(void __user *, node_ptr)
+		__field(binder_uintptr_t, node_ptr)
 		__field(int, ref_debug_id)
 		__field(uint32_t, ref_desc)
 	),
@@ -163,8 +163,9 @@ TRACE_EVENT(binder_transaction_node_to_ref,
 		__entry->ref_debug_id = ref->debug_id;
 		__entry->ref_desc = ref->desc;
 	),
-	TP_printk("transaction=%d node=%d src_ptr=0x%p ==> dest_ref=%d dest_desc=%d",
-		  __entry->debug_id, __entry->node_debug_id, __entry->node_ptr,
+	TP_printk("transaction=%d node=%d src_ptr=0x%016llx ==> dest_ref=%d dest_desc=%d",
+		  __entry->debug_id, __entry->node_debug_id,
+		  (u64)__entry->node_ptr,
 		  __entry->ref_debug_id, __entry->ref_desc)
 );
 
@@ -177,7 +178,7 @@ TRACE_EVENT(binder_transaction_ref_to_node,
 		__field(int, ref_debug_id)
 		__field(uint32_t, ref_desc)
 		__field(int, node_debug_id)
-		__field(void __user *, node_ptr)
+		__field(binder_uintptr_t, node_ptr)
 	),
 	TP_fast_assign(
 		__entry->debug_id = t->debug_id;
@@ -186,9 +187,10 @@ TRACE_EVENT(binder_transaction_ref_to_node,
 		__entry->node_debug_id = ref->node->debug_id;
 		__entry->node_ptr = ref->node->ptr;
 	),
-	TP_printk("transaction=%d node=%d src_ref=%d src_desc=%d ==> dest_ptr=0x%p",
+	TP_printk("transaction=%d node=%d src_ref=%d src_desc=%d ==> dest_ptr=0x%016llx",
 		  __entry->debug_id, __entry->node_debug_id,
-		  __entry->ref_debug_id, __entry->ref_desc, __entry->node_ptr)
+		  __entry->ref_debug_id, __entry->ref_desc,
+		  (u64)__entry->node_ptr)
 );
 
 TRACE_EVENT(binder_transaction_ref_to_ref,
diff --git a/drivers/staging/android/uapi/binder.h b/drivers/staging/android/uapi/binder.h
index 4071fcf..904adb7 100644
--- a/drivers/staging/android/uapi/binder.h
+++ b/drivers/staging/android/uapi/binder.h
@@ -39,6 +39,14 @@ enum {
 	FLAT_BINDER_FLAG_ACCEPTS_FDS = 0x100,
 };
 
+#ifdef BINDER_IPC_32BIT
+typedef __u32 binder_size_t;
+typedef __u32 binder_uintptr_t;
+#else
+typedef __u64 binder_size_t;
+typedef __u64 binder_uintptr_t;
+#endif
+
 /*
  * This is the flattened representation of a Binder object for transfer
  * between processes.  The 'offsets' supplied as part of a binder transaction
@@ -53,12 +61,12 @@ struct flat_binder_object {
 
 	/* 8 bytes of data. */
 	union {
-		void __user	*binder;	/* local object */
-		__u32	    handle;		/* remote object */
+		binder_uintptr_t	binder;	/* local object */
+		__u32			handle;	/* remote object */
 	};
 
 	/* extra data associated with local object */
-	void __user		*cookie;
+	binder_uintptr_t	cookie;
 };
 
 /*
@@ -67,12 +75,12 @@ struct flat_binder_object {
  */
 
 struct binder_write_read {
-	size_t write_size;	/* bytes to write */
-	size_t write_consumed;	/* bytes consumed by driver */
-	unsigned long	write_buffer;
-	size_t read_size;	/* bytes to read */
-	size_t read_consumed;	/* bytes consumed by driver */
-	unsigned long	read_buffer;
+	binder_size_t		write_size;	/* bytes to write */
+	binder_size_t		write_consumed;	/* bytes consumed by driver */
+	binder_uintptr_t	write_buffer;
+	binder_size_t		read_size;	/* bytes to read */
+	binder_size_t		read_consumed;	/* bytes consumed by driver */
+	binder_uintptr_t	read_buffer;
 };
 
 /* Use with BINDER_VERSION, driver fills in fields. */
@@ -82,7 +90,11 @@ struct binder_version {
 };
 
 /* This is the current protocol version. */
+#ifdef BINDER_IPC_32BIT
 #define BINDER_CURRENT_PROTOCOL_VERSION 7
+#else
+#define BINDER_CURRENT_PROTOCOL_VERSION 8
+#endif
 
 #define BINDER_WRITE_READ		_IOWR('b', 1, struct binder_write_read)
 #define BINDER_SET_IDLE_TIMEOUT		_IOW('b', 3, __s64)
@@ -119,18 +131,20 @@ struct binder_transaction_data {
 	 * identifying the target and contents of the transaction.
 	 */
 	union {
-		__u32	handle;	/* target descriptor of command transaction */
-		void	*ptr;	/* target descriptor of return transaction */
+		/* target descriptor of command transaction */
+		__u32	handle;
+		/* target descriptor of return transaction */
+		binder_uintptr_t ptr;
 	} target;
-	void		*cookie;	/* target object cookie */
+	binder_uintptr_t	cookie;	/* target object cookie */
 	__u32		code;		/* transaction command */
 
 	/* General information about the transaction. */
 	__u32	        flags;
 	pid_t		sender_pid;
 	uid_t		sender_euid;
-	size_t		data_size;	/* number of bytes of data */
-	size_t		offsets_size;	/* number of bytes of offsets */
+	binder_size_t	data_size;	/* number of bytes of data */
+	binder_size_t	offsets_size;	/* number of bytes of offsets */
 
 	/* If this transaction is inline, the data immediately
 	 * follows here; otherwise, it ends with a pointer to
@@ -139,22 +153,22 @@ struct binder_transaction_data {
 	union {
 		struct {
 			/* transaction data */
-			const void __user	*buffer;
+			binder_uintptr_t	buffer;
 			/* offsets from buffer to flat_binder_object structs */
-			const void __user	*offsets;
+			binder_uintptr_t	offsets;
 		} ptr;
 		__u8	buf[8];
 	} data;
 };
 
 struct binder_ptr_cookie {
-	void *ptr;
-	void *cookie;
+	binder_uintptr_t ptr;
+	binder_uintptr_t cookie;
 };
 
 struct binder_handle_cookie {
 	__u32 handle;
-	void *cookie;
+	binder_uintptr_t cookie;
 } __attribute__((packed));
 
 struct binder_pri_desc {
@@ -164,8 +178,8 @@ struct binder_pri_desc {
 
 struct binder_pri_ptr_cookie {
 	__s32 priority;
-	void *ptr;
-	void *cookie;
+	binder_uintptr_t ptr;
+	binder_uintptr_t cookie;
 };
 
 enum binder_driver_return_protocol {
@@ -240,11 +254,11 @@ enum binder_driver_return_protocol {
 	 * stop threadpool thread
 	 */
 
-	BR_DEAD_BINDER = _IOR('r', 15, void *),
+	BR_DEAD_BINDER = _IOR('r', 15, binder_uintptr_t),
 	/*
 	 * void *: cookie
 	 */
-	BR_CLEAR_DEATH_NOTIFICATION_DONE = _IOR('r', 16, void *),
+	BR_CLEAR_DEATH_NOTIFICATION_DONE = _IOR('r', 16, binder_uintptr_t),
 	/*
 	 * void *: cookie
 	 */
@@ -270,7 +284,7 @@ enum binder_driver_command_protocol {
 	 * Else you have acquired a primary reference on the object.
 	 */
 
-	BC_FREE_BUFFER = _IOW('c', 3, void *),
+	BC_FREE_BUFFER = _IOW('c', 3, binder_uintptr_t),
 	/*
 	 * void *: ptr to transaction data received on a read
 	 */
@@ -327,7 +341,7 @@ enum binder_driver_command_protocol {
 	 * void *: cookie
 	 */
 
-	BC_DEAD_BINDER_DONE = _IOW('c', 16, void *),
+	BC_DEAD_BINDER_DONE = _IOW('c', 16, binder_uintptr_t),
 	/*
 	 * void *: cookie
 	 */
-- 
1.8.3.2

