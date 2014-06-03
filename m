Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507AbaFCT10 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 15:27:26 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:54871 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbaFCT1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 15:27:25 -0400
Message-ID: <538E2199.5060309@gmail.com>
Date: Tue, 03 Jun 2014 22:27:21 +0300
From: Tair Rzayev <tair.rzayev@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: swetland@google.com, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: android: binder.c: binder_ioctl() cleanup
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

binder_ioctl() is quite huge and checkpatch dirty - mostly because of 
the amount of code for the BINDER_WRITE_READ and BINDER_SET_CONTEXT_MGR.
Moved that code into the new binder_ioctl_write_read() and
binder_ioctl_set_ctx_mgr()

Signed-off-by: Tair Rzayev <tair.rzayev@gmail.com>
---
 drivers/staging/android/binder.c | 186 ++++++++++++++++++++++-----------------
 1 file changed, 107 insertions(+), 79 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index 989f809..ed432e3 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -2594,6 +2594,106 @@ static unsigned int binder_poll(struct file *filp,
 	return 0;
 }
 
+static int binder_ioctl_write_read(struct file *filp,
+				unsigned int cmd, unsigned long arg,
+				struct binder_thread *thread)
+{
+	int ret = 0;
+	struct binder_proc *proc = filp->private_data;
+	unsigned int size = _IOC_SIZE(cmd);
+	void __user *ubuf = (void __user *)arg;
+	struct binder_write_read bwr;
+
+	if (size != sizeof(struct binder_write_read)) {
+		ret = -EINVAL;
+		goto out;
+	}
+	if (copy_from_user(&bwr, ubuf, sizeof(bwr))) {
+		ret = -EFAULT;
+		goto out;
+	}
+	binder_debug(BINDER_DEBUG_READ_WRITE,
+		     "%d:%d write %lld at %016llx, read %lld at %016llx\n",
+		     proc->pid, thread->pid,
+		     (u64)bwr.write_size, (u64)bwr.write_buffer,
+		     (u64)bwr.read_size, (u64)bwr.read_buffer);
+
+	if (bwr.write_size > 0) {
+		ret = binder_thread_write(proc, thread,
+					  bwr.write_buffer,
+					  bwr.write_size,
+					  &bwr.write_consumed);
+		trace_binder_write_done(ret);
+		if (ret < 0) {
+			bwr.read_consumed = 0;
+			if (copy_to_user(ubuf, &bwr, sizeof(bwr)))
+				ret = -EFAULT;
+			goto out;
+		}
+	}
+	if (bwr.read_size > 0) {
+		ret = binder_thread_read(proc, thread, bwr.read_buffer,
+					 bwr.read_size,
+					 &bwr.read_consumed,
+					 filp->f_flags & O_NONBLOCK);
+		trace_binder_read_done(ret);
+		if (!list_empty(&proc->todo))
+			wake_up_interruptible(&proc->wait);
+		if (ret < 0) {
+			if (copy_to_user(ubuf, &bwr, sizeof(bwr)))
+				ret = -EFAULT;
+			goto out;
+		}
+	}
+	binder_debug(BINDER_DEBUG_READ_WRITE,
+		     "%d:%d wrote %lld of %lld, read return %lld of %lld\n",
+		     proc->pid, thread->pid,
+		     (u64)bwr.write_consumed, (u64)bwr.write_size,
+		     (u64)bwr.read_consumed, (u64)bwr.read_size);
+	if (copy_to_user(ubuf, &bwr, sizeof(bwr))) {
+		ret = -EFAULT;
+		goto out;
+	}
+out:
+	return ret;
+}
+
+static int binder_ioctl_set_ctx_mgr(struct file *filp)
+{
+	int ret = 0;
+	struct binder_proc *proc = filp->private_data;
+	kuid_t curr_euid = current_euid();
+
+	if (binder_context_mgr_node != NULL) {
+		pr_err("BINDER_SET_CONTEXT_MGR already set\n");
+		ret = -EBUSY;
+		goto out;
+	}
+	if (uid_valid(binder_context_mgr_uid)) {
+		if (!uid_eq(binder_context_mgr_uid, curr_euid)) {
+			pr_err("BINDER_SET_CONTEXT_MGR bad uid %d != %d\n",
+			       from_kuid(&init_user_ns, curr_euid),
+			       from_kuid(&init_user_ns,
+					binder_context_mgr_uid));
+			ret = -EPERM;
+			goto out;
+		}
+	} else {
+		binder_context_mgr_uid = curr_euid;
+	}
+	binder_context_mgr_node = binder_new_node(proc, 0, 0);
+	if (binder_context_mgr_node == NULL) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	binder_context_mgr_node->local_weak_refs++;
+	binder_context_mgr_node->local_strong_refs++;
+	binder_context_mgr_node->has_strong_ref = 1;
+	binder_context_mgr_node->has_weak_ref = 1;
+out:
+	return ret;
+}
+
 static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	int ret;
@@ -2601,9 +2701,9 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	struct binder_thread *thread;
 	unsigned int size = _IOC_SIZE(cmd);
 	void __user *ubuf = (void __user *)arg;
-	kuid_t curr_euid = current_euid();
 
-	/*pr_info("binder_ioctl: %d:%d %x %lx\n", proc->pid, current->pid, cmd, arg);*/
+	/*pr_info("binder_ioctl: %d:%d %x %lx\n",
+			proc->pid, current->pid, cmd, arg);*/
 
 	trace_binder_ioctl(cmd, arg);
 
@@ -2619,61 +2719,11 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	}
 
 	switch (cmd) {
-	case BINDER_WRITE_READ: {
-		struct binder_write_read bwr;
-
-		if (size != sizeof(struct binder_write_read)) {
-			ret = -EINVAL;
+	case BINDER_WRITE_READ:
+		ret = binder_ioctl_write_read(filp, cmd, arg, thread);
+		if (ret)
 			goto err;
-		}
-		if (copy_from_user(&bwr, ubuf, sizeof(bwr))) {
-			ret = -EFAULT;
-			goto err;
-		}
-		binder_debug(BINDER_DEBUG_READ_WRITE,
-			     "%d:%d write %lld at %016llx, read %lld at %016llx\n",
-			     proc->pid, thread->pid,
-			     (u64)bwr.write_size, (u64)bwr.write_buffer,
-			     (u64)bwr.read_size, (u64)bwr.read_buffer);
-
-		if (bwr.write_size > 0) {
-			ret = binder_thread_write(proc, thread,
-						  bwr.write_buffer,
-						  bwr.write_size,
-						  &bwr.write_consumed);
-			trace_binder_write_done(ret);
-			if (ret < 0) {
-				bwr.read_consumed = 0;
-				if (copy_to_user(ubuf, &bwr, sizeof(bwr)))
-					ret = -EFAULT;
-				goto err;
-			}
-		}
-		if (bwr.read_size > 0) {
-			ret = binder_thread_read(proc, thread, bwr.read_buffer,
-						 bwr.read_size,
-						 &bwr.read_consumed,
-						 filp->f_flags & O_NONBLOCK);
-			trace_binder_read_done(ret);
-			if (!list_empty(&proc->todo))
-				wake_up_interruptible(&proc->wait);
-			if (ret < 0) {
-				if (copy_to_user(ubuf, &bwr, sizeof(bwr)))
-					ret = -EFAULT;
-				goto err;
-			}
-		}
-		binder_debug(BINDER_DEBUG_READ_WRITE,
-			     "%d:%d wrote %lld of %lld, read return %lld of %lld\n",
-			     proc->pid, thread->pid,
-			     (u64)bwr.write_consumed, (u64)bwr.write_size,
-			     (u64)bwr.read_consumed, (u64)bwr.read_size);
-		if (copy_to_user(ubuf, &bwr, sizeof(bwr))) {
-			ret = -EFAULT;
-			goto err;
-		}
 		break;
-	}
 	case BINDER_SET_MAX_THREADS:
 		if (copy_from_user(&proc->max_threads, ubuf, sizeof(proc->max_threads))) {
 			ret = -EINVAL;
@@ -2681,31 +2731,9 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		}
 		break;
 	case BINDER_SET_CONTEXT_MGR:
-		if (binder_context_mgr_node != NULL) {
-			pr_err("BINDER_SET_CONTEXT_MGR already set\n");
-			ret = -EBUSY;
+		ret = binder_ioctl_set_ctx_mgr(filp);
+		if (ret)
 			goto err;
-		}
-		if (uid_valid(binder_context_mgr_uid)) {
-			if (!uid_eq(binder_context_mgr_uid, curr_euid)) {
-				pr_err("BINDER_SET_CONTEXT_MGR bad uid %d != %d\n",
-				       from_kuid(&init_user_ns, curr_euid),
-				       from_kuid(&init_user_ns, binder_context_mgr_uid));
-				ret = -EPERM;
-				goto err;
-			}
-		} else {
-			binder_context_mgr_uid = curr_euid;
-		}
-		binder_context_mgr_node = binder_new_node(proc, 0, 0);
-		if (binder_context_mgr_node == NULL) {
-			ret = -ENOMEM;
-			goto err;
-		}
-		binder_context_mgr_node->local_weak_refs++;
-		binder_context_mgr_node->local_strong_refs++;
-		binder_context_mgr_node->has_strong_ref = 1;
-		binder_context_mgr_node->has_weak_ref = 1;
 		break;
 	case BINDER_THREAD_EXIT:
 		binder_debug(BINDER_DEBUG_THREADS, "%d:%d exit\n",
-- 
1.9.1


