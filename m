Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932582Ab3D3Q2q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 12:28:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18361 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932252Ab3D3Q2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 12:28:43 -0400
Date: Tue, 30 Apr 2013 12:28:40 -0400
From: David Teigland <teigland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] dlm updates for 3.10
Message-ID: <20130430162840.GA14735@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull dlm updates from tag:

git://git.kernel.org/pub/scm/linux/kernel/git/teigland/linux-dlm.git dlm-3.10

This includes a single patch to avoid fully processing a
posix unlock from close when no posix locks exist on the file.

Patch copied below.

Thanks,
Dave


dlm: avoid unnecessary posix unlock

When the kernel clears flocks/plocks during close, it calls posix
unlock when there are flocks but no posix locks.  Without this
patch, that unnecessary posix unlock is passed to userland
(dlm_controld), across the cluster, and back to the kernel.
This can create a lot of plock activity, even when no posix
locks had been used.

This patch copies the nfs approach, and skips the full posix
unlock if there is no plock found during the vfs unlock phase.

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/plock.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/dlm/plock.c b/fs/dlm/plock.c
index 01fd5c1..f704458 100644
--- a/fs/dlm/plock.c
+++ b/fs/dlm/plock.c
@@ -247,6 +247,7 @@ int dlm_posix_unlock(dlm_lockspace_t *lockspace, u64 number, struct file *file,
 	struct dlm_ls *ls;
 	struct plock_op *op;
 	int rv;
+	unsigned char fl_flags = fl->fl_flags;
 
 	ls = dlm_find_lockspace_local(lockspace);
 	if (!ls)
@@ -258,9 +259,18 @@ int dlm_posix_unlock(dlm_lockspace_t *lockspace, u64 number, struct file *file,
 		goto out;
 	}
 
-	if (posix_lock_file_wait(file, fl) < 0)
-		log_error(ls, "dlm_posix_unlock: vfs unlock error %llx",
-			  (unsigned long long)number);
+	/* cause the vfs unlock to return ENOENT if lock is not found */
+	fl->fl_flags |= FL_EXISTS;
+
+	rv = posix_lock_file_wait(file, fl);
+	if (rv == -ENOENT) {
+		rv = 0;
+		goto out_free;
+	}
+	if (rv < 0) {
+		log_error(ls, "dlm_posix_unlock: vfs unlock error %d %llx",
+			  rv, (unsigned long long)number);
+	}
 
 	op->info.optype		= DLM_PLOCK_OP_UNLOCK;
 	op->info.pid		= fl->fl_pid;
@@ -296,9 +306,11 @@ int dlm_posix_unlock(dlm_lockspace_t *lockspace, u64 number, struct file *file,
 	if (rv == -ENOENT)
 		rv = 0;
 
+out_free:
 	kfree(op);
 out:
 	dlm_put_lockspace(ls);
+	fl->fl_flags = fl_flags;
 	return rv;
 }
 EXPORT_SYMBOL_GPL(dlm_posix_unlock);
-- 
1.8.1.rc1.5.g7e0651a

