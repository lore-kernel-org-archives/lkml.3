Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161853Ab3DEKYt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 06:24:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59957 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161175Ab3DEKYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 06:24:47 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: David Teigland <teigland@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 5/6] GFS2: Fix unlock of fcntl locks during withdrawn state
Date: Fri,  5 Apr 2013 10:57:15 +0100
Message-Id: <1365155836-3069-6-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1365155836-3069-1-git-send-email-swhiteho@redhat.com>
References: <1365155836-3069-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Teigland <teigland@redhat.com>

This reminded me of another old patch I had sitting around which I never
had a chance to test.  I copied this idea from the nfs code.  The problem
is that when the kernel clears flocks/plocks during close, it calls posix
unlock even if there are no posix locks on the file.  Without this patch,
that extraneous unlock propagates up to controld, across the cluster, and
back down to the kernel.  That can amount to a lot of plock activity on a
fs that may have never used a single plock (only flocks).  With this
patch, we should detect that the unlock is extraneous (since it doesn't
exist in the vfs), and skip all the userland traffic.

Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

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
1.7.4

