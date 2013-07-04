Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933194Ab3GDJzR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 05:55:17 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:49462 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754973Ab3GDJyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 05:54:41 -0400
From: Serban Constantinescu <serban.constantinescu@arm.com>
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        kernel-team@android.com, arve@android.com, john.stultz@linaro.org,
        Dave.Butcher@arm.com
Cc: Serban Constantinescu <serban.constantinescu@arm.com>
Subject: [PATCH v6 6/6] staging: android: binder: fix binder interface for 64bit compat layer
Date: Thu,  4 Jul 2013 10:54:48 +0100
Message-Id: <1372931688-18553-7-git-send-email-serban.constantinescu@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1372931688-18553-1-git-send-email-serban.constantinescu@arm.com>
References: <1372931688-18553-1-git-send-email-serban.constantinescu@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The changes in this patch will fix the binder interface for use on 64bit
machines and stand as the base of the 64bit compat support. The changes
apply to the structures that are passed between the kernel and
userspace.

Most of the  changes applied mirror the change to struct binder_version
where there is no need for a 64bit wide protocol_version(on 64bit
machines). The change inlines with the existing 32bit userspace(the
structure has the same size) and simplifies the compat layer such that
the same handler can service the BINDER_VERSION ioctl.

Other changes make use of kernel types as well as user-exportable ones
and fix format specifier issues.

The changes do not affect existing 32bit ABI.

Signed-off-by: Serban Constantinescu <serban.constantinescu@arm.com>
Acked-by: Arve Hjønnevåg <arve@android.com>
---
 drivers/staging/android/binder.c |   20 ++++++++++----------
 drivers/staging/android/binder.h |   12 ++++++------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index 7450d56..056afe7 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -1271,7 +1271,7 @@ static void binder_transaction_buffer_release(struct binder_proc *proc,
 		case BINDER_TYPE_WEAK_HANDLE: {
 			struct binder_ref *ref = binder_get_ref(proc, fp->handle);
 			if (ref == NULL) {
-				pr_err("transaction release %d bad handle %ld\n",
+				pr_err("transaction release %d bad handle %d\n",
 				 debug_id, fp->handle);
 				break;
 			}
@@ -1283,13 +1283,13 @@ static void binder_transaction_buffer_release(struct binder_proc *proc,
 
 		case BINDER_TYPE_FD:
 			binder_debug(BINDER_DEBUG_TRANSACTION,
-				     "        fd %ld\n", fp->handle);
+				     "        fd %d\n", fp->handle);
 			if (failed_at)
 				task_close_fd(proc, fp->handle);
 			break;
 
 		default:
-			pr_err("transaction release %d bad object type %lx\n",
+			pr_err("transaction release %d bad object type %x\n",
 				debug_id, fp->type);
 			break;
 		}
@@ -1547,7 +1547,7 @@ static void binder_transaction(struct binder_proc *proc,
 		case BINDER_TYPE_WEAK_HANDLE: {
 			struct binder_ref *ref = binder_get_ref(proc, fp->handle);
 			if (ref == NULL) {
-				binder_user_error("%d:%d got transaction with invalid handle, %ld\n",
+				binder_user_error("%d:%d got transaction with invalid handle, %d\n",
 						proc->pid,
 						thread->pid, fp->handle);
 				return_error = BR_FAILED_REPLY;
@@ -1590,13 +1590,13 @@ static void binder_transaction(struct binder_proc *proc,
 
 			if (reply) {
 				if (!(in_reply_to->flags & TF_ACCEPT_FDS)) {
-					binder_user_error("%d:%d got reply with fd, %ld, but target does not allow fds\n",
+					binder_user_error("%d:%d got reply with fd, %d, but target does not allow fds\n",
 						proc->pid, thread->pid, fp->handle);
 					return_error = BR_FAILED_REPLY;
 					goto err_fd_not_allowed;
 				}
 			} else if (!target_node->accept_fds) {
-				binder_user_error("%d:%d got transaction with fd, %ld, but target does not allow fds\n",
+				binder_user_error("%d:%d got transaction with fd, %d, but target does not allow fds\n",
 					proc->pid, thread->pid, fp->handle);
 				return_error = BR_FAILED_REPLY;
 				goto err_fd_not_allowed;
@@ -1604,7 +1604,7 @@ static void binder_transaction(struct binder_proc *proc,
 
 			file = fget(fp->handle);
 			if (file == NULL) {
-				binder_user_error("%d:%d got transaction with invalid fd, %ld\n",
+				binder_user_error("%d:%d got transaction with invalid fd, %d\n",
 					proc->pid, thread->pid, fp->handle);
 				return_error = BR_FAILED_REPLY;
 				goto err_fget_failed;
@@ -1618,13 +1618,13 @@ static void binder_transaction(struct binder_proc *proc,
 			task_fd_install(target_proc, target_fd, file);
 			trace_binder_transaction_fd(t, fp->handle, target_fd);
 			binder_debug(BINDER_DEBUG_TRANSACTION,
-				     "        fd %ld -> %d\n", fp->handle, target_fd);
+				     "        fd %d -> %d\n", fp->handle, target_fd);
 			/* TODO: fput? */
 			fp->handle = target_fd;
 		} break;
 
 		default:
-			binder_user_error("%d:%d got transaction with invalid object type, %lx\n",
+			binder_user_error("%d:%d got transaction with invalid object type, %x\n",
 				proc->pid, thread->pid, fp->type);
 			return_error = BR_FAILED_REPLY;
 			goto err_bad_object_type;
@@ -2578,7 +2578,7 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			goto err;
 		}
 		binder_debug(BINDER_DEBUG_READ_WRITE,
-			     "%d:%d write %zd at %08lx, read %zd at %08lx\n",
+			     "%d:%d write %zd at %016lx, read %zd at %016lx\n",
 			     proc->pid, thread->pid, bwr.write_size,
 			     bwr.write_buffer, bwr.read_size, bwr.read_buffer);
 
diff --git a/drivers/staging/android/binder.h b/drivers/staging/android/binder.h
index dadfce0..cbe3451 100644
--- a/drivers/staging/android/binder.h
+++ b/drivers/staging/android/binder.h
@@ -48,13 +48,13 @@ enum {
  */
 struct flat_binder_object {
 	/* 8 bytes for large_flat_header. */
-	unsigned long		type;
-	unsigned long		flags;
+	__u32		type;
+	__u32		flags;
 
 	/* 8 bytes of data. */
 	union {
 		void __user	*binder;	/* local object */
-		signed long	handle;		/* remote object */
+		__u32	    handle;		/* remote object */
 	};
 
 	/* extra data associated with local object */
@@ -78,7 +78,7 @@ struct binder_write_read {
 /* Use with BINDER_VERSION, driver fills in fields. */
 struct binder_version {
 	/* driver protocol version -- increment with incompatible change */
-	signed long	protocol_version;
+	__s32       protocol_version;
 };
 
 /* This is the current protocol version. */
@@ -119,7 +119,7 @@ struct binder_transaction_data {
 	 * identifying the target and contents of the transaction.
 	 */
 	union {
-		size_t	handle;	/* target descriptor of command transaction */
+		__u32	handle;	/* target descriptor of command transaction */
 		void	*ptr;	/* target descriptor of return transaction */
 	} target;
 	void		*cookie;	/* target object cookie */
@@ -154,7 +154,7 @@ struct binder_ptr_cookie {
 
 struct binder_pri_desc {
 	__s32 priority;
-	__s32 desc;
+	__u32 desc;
 };
 
 struct binder_pri_ptr_cookie {
-- 
1.7.9.5

