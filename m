Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933139Ab3LDSNs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 13:13:48 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:52518 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933093Ab3LDSNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 13:13:37 -0500
From: Serban Constantinescu <serban.constantinescu@arm.com>
To: gregkh@linuxfoundation.org, arve@android.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, john.stultz@linaro.org,
        ccross@android.com, Dave.Butcher@arm.com, irogers@google.com,
        romlem@android.com
Cc: Serban Constantinescu <serban.constantinescu@arm.com>
Subject: [PATCH v1 9/9] staging: android: binder: Add binder compat layer
Date: Wed,  4 Dec 2013 18:09:41 +0000
Message-Id: <1386180581-6710-10-git-send-email-serban.constantinescu@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386180581-6710-1-git-send-email-serban.constantinescu@arm.com>
References: <1386180581-6710-1-git-send-email-serban.constantinescu@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for 32bit userspace running on 64bit kernels.
All the changes done in this patch have been tested on 32bit and 64bit
systems.

Signed-off-by: Serban Constantinescu <serban.constantinescu@arm.com>
---
 drivers/staging/android/binder.c |  355 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 353 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index 855d348..941973a 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -37,6 +37,7 @@
 #include <linux/vmalloc.h>
 #include <linux/slab.h>
 #include <linux/pid_namespace.h>
+#include <linux/compat.h>
 
 #include "binder.h"
 #include "binder_trace.h"
@@ -140,6 +141,77 @@ module_param_call(stop_on_user_error, binder_set_stop_on_user_error,
 			binder_stop_on_user_error = 2; \
 	} while (0)
 
+#ifdef CONFIG_COMPAT
+static inline void writeback_flat_binder_object(struct flat_binder_object *fp,
+					 void __user *ptr)
+{
+	struct compat_flat_binder_object *tmp_fp;
+
+	tmp_fp = (struct compat_flat_binder_object *) ptr;
+	tmp_fp->type = fp->type;
+	tmp_fp->flags = fp->flags;
+	tmp_fp->binder = ptr_to_compat(fp->binder);
+	tmp_fp->cookie = ptr_to_compat(fp->cookie);
+}
+
+static inline struct flat_binder_object *copy_flat_binder_object(void __user *ptr)
+{
+	struct flat_binder_object *fp;
+	struct compat_flat_binder_object *tmp_fp;
+
+	if (!is_compat_task())
+		return (struct flat_binder_object *) ptr;
+
+	fp = kzalloc(sizeof(*fp), GFP_KERNEL);
+	if (fp == NULL)
+		return NULL;
+
+	tmp_fp = (struct compat_flat_binder_object *) ptr;
+	/* copy compat struct */
+	fp->type = tmp_fp->type;
+	fp->flags = tmp_fp->flags;
+	fp->binder = compat_ptr(tmp_fp->binder);
+	fp->cookie = compat_ptr(tmp_fp->cookie);
+
+	return fp;
+}
+
+static inline uint32_t compat_change_size(uint32_t cmd, size_t size)
+{
+	uint32_t compat_cmd;
+
+	compat_cmd = cmd & ~IOCSIZE_MASK;
+	compat_cmd = compat_cmd | ((size << _IOC_SIZESHIFT) & IOCSIZE_MASK);
+	return compat_cmd;
+}
+
+#define align_helper(x) (						    \
+	is_compat_task() ?						    \
+	ALIGN(x, sizeof(compat_uptr_t)) :				    \
+	ALIGN(x, sizeof(void *))					    \
+	)
+
+#define deref_helper(x) (						    \
+	is_compat_task() ?						    \
+	(size_t) *(compat_size_t *)x :					    \
+	*(size_t *)x							    \
+	)
+
+#define size_helper(x) ({						    \
+	size_t __size;							    \
+	if (!is_compat_task())						    \
+		__size = sizeof(x);					    \
+	else if (sizeof(x) == sizeof(struct flat_binder_object))	    \
+		__size = sizeof(struct compat_flat_binder_object);	    \
+	else if (sizeof(x) == sizeof(struct binder_transaction_data))	    \
+		__size = sizeof(struct compat_binder_transaction_data);	    \
+	else if (sizeof(x) == sizeof(size_t))				    \
+		__size = sizeof(compat_size_t);				    \
+	else								    \
+		 BUG();							    \
+	__size;								    \
+	})
+#else
 #define align_helper(ptr)	    ALIGN(ptr, sizeof(void *))
 #define deref_helper(ptr)	    (*(typeof(size_t *))ptr)
 #define size_helper(x)		    sizeof(x)
@@ -148,6 +220,7 @@ static inline struct flat_binder_object *copy_flat_binder_object(void __user *pt
 {
 	return (struct flat_binder_object *)ptr;
 }
+#endif
 
 enum binder_stat_types {
 	BINDER_STAT_PROC,
@@ -1254,7 +1327,7 @@ static void binder_transaction_buffer_release(struct binder_proc *proc,
 	else
 		off_end = (void *)offp + buffer->offsets_size;
 	for (; offp < off_end; offp += size_helper(size_t)) {
-		struct flat_binder_object *fp;
+		struct flat_binder_object *fp = NULL;
 		if (deref_helper(offp) > buffer->data_size - size_helper(*fp) ||
 		    buffer->data_size < size_helper(*fp) ||
 		    !IS_ALIGNED(deref_helper(offp), sizeof(u32))) {
@@ -1303,6 +1376,8 @@ static void binder_transaction_buffer_release(struct binder_proc *proc,
 				debug_id, fp->type);
 			break;
 		}
+		if (is_compat_task())
+			kfree(fp);
 	}
 }
 
@@ -1321,6 +1396,7 @@ static void binder_transaction(struct binder_proc *proc,
 	struct binder_transaction *in_reply_to = NULL;
 	struct binder_transaction_log_entry *e;
 	uint32_t return_error;
+	struct flat_binder_object *fp = NULL;
 
 	e = binder_transaction_log_add(&binder_transaction_log);
 	e->call_type = reply ? 2 : !!(tr->flags & TF_ONE_WAY);
@@ -1503,7 +1579,6 @@ static void binder_transaction(struct binder_proc *proc,
 	}
 	off_end = (void *)offp + tr->offsets_size;
 	for (; offp < off_end; offp += size_helper(size_t)) {
-		struct flat_binder_object *fp;
 		if (deref_helper(offp) > t->buffer->data_size - size_helper(*fp) ||
 		    t->buffer->data_size < size_helper(*fp) ||
 		    !IS_ALIGNED(deref_helper(offp), sizeof(u32))) {
@@ -1639,6 +1714,12 @@ static void binder_transaction(struct binder_proc *proc,
 			return_error = BR_FAILED_REPLY;
 			goto err_bad_object_type;
 		}
+#ifdef CONFIG_COMPAT
+		if (is_compat_task()) {
+			writeback_flat_binder_object(fp, t->buffer->data + deref_helper(offp));
+			kfree(fp);
+		}
+#endif
 	}
 	if (reply) {
 		BUG_ON(t->buffer->async_transaction != 0);
@@ -1674,6 +1755,8 @@ err_binder_new_node_failed:
 err_bad_object_type:
 err_bad_offset:
 err_copy_data_failed:
+	if (is_compat_task())
+		kfree(fp);
 	trace_binder_transaction_failed_buffer_release(t->buffer);
 	binder_transaction_buffer_release(target_proc, t->buffer, offp);
 	t->buffer->transaction = NULL;
@@ -1920,6 +2003,95 @@ static void bc_dead_binder_done(struct binder_proc *proc,
 	return;
 }
 
+#ifdef CONFIG_COMPAT
+static int compat_binder_thread_write(struct binder_proc *proc,
+		struct binder_thread *thread, uint32_t cmd,
+		void __user **ptr)
+{
+	BUG_ON(!is_compat_task());
+	switch (cmd) {
+	case COMPAT_BC_INCREFS_DONE:
+	case COMPAT_BC_ACQUIRE_DONE: {
+		compat_uptr_t node_ptr;
+		compat_uptr_t cookie;
+
+		if (get_user(node_ptr, (compat_uptr_t __user *)*ptr))
+			return -EFAULT;
+		*ptr += sizeof(compat_uptr_t);
+		if (get_user(cookie, (compat_uptr_t __user *)*ptr))
+			return -EFAULT;
+		*ptr += sizeof(compat_uptr_t);
+		bc_increfs_done(proc, thread, cmd == COMPAT_BC_ACQUIRE_DONE,
+			compat_ptr(node_ptr), compat_ptr(cookie));
+		break;
+	}
+
+	case COMPAT_BC_FREE_BUFFER: {
+		compat_uptr_t data_ptr;
+
+		if (get_user(data_ptr, (compat_uptr_t __user *)*ptr))
+			return -EFAULT;
+		*ptr += sizeof(compat_uptr_t);
+		bc_free_buffer(proc, thread, compat_ptr(data_ptr));
+		break;
+	}
+
+	case COMPAT_BC_TRANSACTION:
+	case COMPAT_BC_REPLY: {
+		struct binder_transaction_data tr;
+		struct compat_binder_transaction_data tmp_tr;
+
+		if (copy_from_user(&tmp_tr, *ptr, sizeof(tmp_tr)))
+			return -EFAULT;
+		*ptr += sizeof(tmp_tr);
+
+		memset(&tr, 0, sizeof(tr));
+		/* copy from compat struct */
+		tr.target.ptr = compat_ptr(tmp_tr.target.ptr);
+		tr.cookie = compat_ptr(tmp_tr.cookie);
+		tr.code = tmp_tr.code;
+		tr.flags = tmp_tr.flags;
+		tr.sender_pid = tmp_tr.sender_pid;
+		tr.sender_euid = tmp_tr.sender_euid;
+		tr.data_size = (size_t) tmp_tr.data_size;
+		tr.offsets_size = (size_t) tmp_tr.offsets_size;
+		tr.data.ptr.buffer = compat_ptr(tmp_tr.data.ptr.buffer);
+		tr.data.ptr.offsets = compat_ptr(tmp_tr.data.ptr.offsets);
+
+		binder_transaction(proc, thread, &tr, cmd == COMPAT_BC_REPLY);
+		break;
+	}
+	case COMPAT_BC_REQUEST_DEATH_NOTIFICATION:
+	case COMPAT_BC_CLEAR_DEATH_NOTIFICATION: {
+		uint32_t target;
+		compat_uptr_t cookie;
+
+		if (get_user(target, (uint32_t __user *)*ptr))
+			return -EFAULT;
+		*ptr += sizeof(uint32_t);
+		if (get_user(cookie, (compat_uptr_t __user *)*ptr))
+			return -EFAULT;
+		*ptr += sizeof(compat_uptr_t);
+		bc_clear_death_notif(proc, thread, cmd == COMPAT_BC_REQUEST_DEATH_NOTIFICATION,
+			target, compat_ptr(cookie));
+		break;
+	}
+	case COMPAT_BC_DEAD_BINDER_DONE: {
+		compat_uptr_t cookie;
+
+		if (get_user(cookie, (compat_uptr_t __user *)*ptr))
+			return -EFAULT;
+		*ptr += sizeof(compat_uptr_t);
+		bc_dead_binder_done(proc, thread, compat_ptr(cookie));
+		break;
+	}
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+#endif
+
 static int binder_thread_write(struct binder_proc *proc,
 			struct binder_thread *thread,
 			void __user *buffer, size_t size, size_t *consumed)
@@ -2094,6 +2266,10 @@ static int binder_thread_write(struct binder_proc *proc,
 			break;
 		}
 		default:
+#ifdef CONFIG_COMPAT
+			if (is_compat_task() && (!compat_binder_thread_write(proc, thread, cmd, &ptr)))
+				break;
+#endif
 			pr_err("%d:%d unknown command %d\n",
 			       proc->pid, thread->pid, cmd);
 			return -EINVAL;
@@ -2127,6 +2303,103 @@ static int binder_has_thread_work(struct binder_thread *thread)
 		(thread->looper & BINDER_LOOPER_STATE_NEED_RETURN);
 }
 
+#ifdef CONFIG_COMPAT
+static int binder_copy_to_user(uint32_t cmd, void *parcel,
+			       void __user **ptr, size_t size)
+{
+	if (!is_compat_task()) {
+		if (put_user(cmd, (uint32_t __user *)*ptr))
+			return -EFAULT;
+		*ptr += sizeof(uint32_t);
+		if (copy_to_user(*ptr, parcel, size))
+			return -EFAULT;
+		*ptr += size;
+		return 0;
+	}
+	switch (cmd) {
+	case BR_INCREFS:
+	case BR_ACQUIRE:
+	case BR_RELEASE:
+	case BR_DECREFS: {
+		struct binder_ptr_cookie *fp;
+		struct compat_binder_ptr_cookie tmp;
+
+		cmd = compat_change_size(cmd, sizeof(tmp));
+		BUG_ON((cmd != COMPAT_BR_INCREFS) &&
+		       (cmd != COMPAT_BR_ACQUIRE) &&
+		       (cmd != COMPAT_BR_RELEASE) &&
+		       (cmd != COMPAT_BR_DECREFS));
+
+		fp = (struct binder_ptr_cookie *) parcel;
+		tmp.ptr = ptr_to_compat(fp->ptr);
+		tmp.cookie = ptr_to_compat(fp->cookie);
+		if (put_user(cmd, (uint32_t __user *)*ptr))
+			return -EFAULT;
+		*ptr += sizeof(uint32_t);
+		if (copy_to_user(*ptr, &tmp, sizeof(tmp)))
+			return -EFAULT;
+		*ptr += sizeof(tmp);
+
+		break;
+	}
+	case BR_DEAD_BINDER:
+	case BR_CLEAR_DEATH_NOTIFICATION_DONE: {
+		compat_uptr_t tmp;
+
+		cmd = compat_change_size(cmd, sizeof(tmp));
+		BUG_ON((cmd != COMPAT_BR_DEAD_BINDER) &&
+		       (cmd != COMPAT_BR_CLEAR_DEATH_NOTIFICATION_DONE));
+
+		tmp = ptr_to_compat((void *)*(uintptr_t *) parcel);
+		if (put_user(cmd, (uint32_t __user *)*ptr))
+			return -EFAULT;
+		*ptr += sizeof(uint32_t);
+		if (copy_to_user(*ptr, &tmp, sizeof(tmp)))
+			return -EFAULT;
+		*ptr += sizeof(tmp);
+
+		break;
+	}
+	case BR_REPLY:
+	case BR_TRANSACTION: {
+		struct binder_transaction_data *fp;
+		struct compat_binder_transaction_data tmp;
+
+		memset(&tmp, 0, sizeof(tmp));
+		cmd = compat_change_size(cmd, sizeof(tmp));
+		BUG_ON((cmd != COMPAT_BR_REPLY) &&
+		       (cmd != COMPAT_BR_TRANSACTION));
+
+		fp = (struct binder_transaction_data *) parcel;
+		/* copy to compat struct */
+		tmp.target.ptr = ptr_to_compat(fp->target.ptr);
+		tmp.cookie = ptr_to_compat(fp->cookie);
+		tmp.code = fp->code;
+		tmp.flags = fp->flags;
+		tmp.sender_pid = fp->sender_pid;
+		tmp.sender_euid = fp->sender_euid;
+		tmp.data_size = (compat_size_t) fp->data_size;
+		tmp.offsets_size = (compat_size_t) fp->offsets_size;
+		tmp.data.ptr.buffer = ptr_to_compat((void *)fp->data.ptr.buffer);
+		tmp.data.ptr.offsets = ptr_to_compat((void *)fp->data.ptr.offsets);
+
+		if (put_user(cmd, (uint32_t __user *)*ptr))
+			return -EFAULT;
+		*ptr += sizeof(uint32_t);
+		if (copy_to_user(*ptr, &tmp, sizeof(tmp)))
+			return -EFAULT;
+		*ptr += sizeof(tmp);
+
+		break;
+	}
+	default:
+		pr_err("unexpected user copy, cmd %d, ptr %p\n",
+			cmd, (void *)*(uintptr_t *)ptr);
+		return -EFAULT;
+	}
+	return 0;
+}
+#else
 static int binder_copy_to_user(uint32_t cmd, void *parcel,
 			       void __user **ptr, size_t size)
 {
@@ -2138,6 +2411,7 @@ static int binder_copy_to_user(uint32_t cmd, void *parcel,
 	*ptr += size;
 	return 0;
 }
+#endif
 
 static int binder_thread_read(struct binder_proc *proc,
 			      struct binder_thread *thread,
@@ -2729,6 +3003,80 @@ err_unlocked:
 	return ret;
 }
 
+/* TODO: add tracepoint */
+#ifdef CONFIG_COMPAT
+static long compat_binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+{
+	int ret = 0;
+	struct binder_thread *thread;
+	struct compat_binder_write_read bwr;
+	struct binder_proc *proc = filp->private_data;
+	void __user *ubuf = compat_ptr(arg);
+
+	/* pr_info("compat_binder_ioctl: %d:%d %x %lx\n", proc->pid, current->pid, cmd, arg); */
+
+	if (cmd != COMPAT_BINDER_WRITE_READ)
+		return binder_ioctl(filp, cmd, arg);
+
+	BUG_ON(!is_compat_task());
+	binder_lock(__func__);
+	thread = binder_get_thread(proc);
+	if (thread == NULL) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	/* COMPAT_BINDER_WRITE_READ */
+	if (copy_from_user(&bwr, ubuf, sizeof(bwr))) {
+		ret = -EFAULT;
+		goto err;
+	}
+	binder_debug(BINDER_DEBUG_READ_WRITE,
+	    "compat: %d:%d write %d at %016x, read %d at %016x\n",
+		    proc->pid, thread->pid, bwr.write_size,
+		    bwr.write_buffer, bwr.read_size, bwr.read_buffer);
+
+	if (bwr.write_size > 0) {
+		size_t tmp_write_consumed = (size_t)bwr.write_consumed;
+		ret = binder_thread_write(proc, thread, compat_ptr(bwr.write_buffer), (size_t)bwr.write_size, &tmp_write_consumed);
+		bwr.write_consumed = (compat_size_t)tmp_write_consumed;
+		if (ret < 0) {
+			bwr.read_consumed = 0;
+			if (copy_to_user(ubuf, &bwr, sizeof(bwr)))
+				ret = -EFAULT;
+			goto err;
+		}
+	}
+
+	if (bwr.read_size > 0) {
+		size_t tmp_read_consumed = (size_t)bwr.read_consumed;
+		ret = binder_thread_read(proc, thread, compat_ptr(bwr.read_buffer), (size_t)bwr.read_size, &tmp_read_consumed, filp->f_flags & O_NONBLOCK);
+		bwr.read_consumed = (compat_size_t)tmp_read_consumed;
+		if (!list_empty(&proc->todo))
+			wake_up_interruptible(&proc->wait);
+		if (ret < 0) {
+			if (copy_to_user(ubuf, &bwr, sizeof(bwr)))
+				ret = -EFAULT;
+			goto err;
+		}
+	}
+	binder_debug(BINDER_DEBUG_READ_WRITE,
+		    "compat: %d:%d wrote %d of %d, read return %d of %d\n",
+		    proc->pid, thread->pid, bwr.write_consumed, bwr.write_size,
+		    bwr.read_consumed, bwr.read_size);
+	if (copy_to_user(ubuf, &bwr, sizeof(bwr)))
+		ret = -EFAULT;
+
+err:
+	if (thread)
+		thread->looper &= ~BINDER_LOOPER_STATE_NEED_RETURN;
+	binder_unlock(__func__);
+	if (ret && ret != -ERESTARTSYS)
+		pr_info("%d:%d compat ioctl %x %lx returned %d\n", proc->pid, current->pid, cmd, arg, ret);
+	return ret;
+}
+#endif
+
 static void binder_vma_open(struct vm_area_struct *vma)
 {
 	struct binder_proc *proc = vma->vm_private_data;
@@ -3546,6 +3894,9 @@ static const struct file_operations binder_fops = {
 	.owner = THIS_MODULE,
 	.poll = binder_poll,
 	.unlocked_ioctl = binder_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = compat_binder_ioctl,
+#endif
 	.mmap = binder_mmap,
 	.open = binder_open,
 	.flush = binder_flush,
-- 
1.7.9.5

