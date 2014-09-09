Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244AbaIISko (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 14:40:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:15637 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751977AbaIISkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 14:40:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,492,1406617200"; 
   d="scan'208";a="570725258"
From: "John L. Hammond" <john.hammond@intel.com>
To: <greg@kroah.com>, <andreas.dilger@intel.com>, <oleg.drokin@intel.com>
CC: <linux-kernel@vger.kernel.org>, "John L. Hammond" <john.hammond@intel.com>
Subject: [PATCH 5/7] staging/lustre: remove unused lvfs code
Date: Tue, 9 Sep 2014 13:39:06 -0500
Message-ID: <1410287948-13168-6-git-send-email-john.hammond@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1410287948-13168-1-git-send-email-john.hammond@intel.com>
References: <1410287948-13168-1-git-send-email-john.hammond@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.1.200.107]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John L. Hammond" <john.hammond@intel.com>

Remove the unused "lvfs" functions obd_lvfs_fid2dentry(),
ll_lookup_one_len(), l_dput(), lustre_rename(), push_ctxt(), and
pop_ctxt(). Remove the unused members of struct lvfs_run_ctxt.

Signed-off-by: John L. Hammond <john.hammond@intel.com>
---
 drivers/staging/lustre/lustre/include/linux/lvfs.h |   78 --------------------
 drivers/staging/lustre/lustre/include/lvfs.h       |    8 --
 drivers/staging/lustre/lustre/include/obd_class.h  |   10 ---
 3 files changed, 96 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/linux/lvfs.h b/drivers/staging/lustre/lustre/include/linux/lvfs.h
index ddeb7de..786e779 100644
--- a/drivers/staging/lustre/lustre/include/linux/lvfs.h
+++ b/drivers/staging/lustre/lustre/include/linux/lvfs.h
@@ -50,86 +50,8 @@
 #include <linux/sched.h>
 #include "lustre_compat25.h"
 
-#define LLOG_LVFS
-
-/* simple.c */
-
-struct lvfs_ucred {
-	kuid_t		luc_uid;
-	kgid_t		luc_gid;
-	kuid_t		luc_fsuid;
-	kgid_t		luc_fsgid;
-	kernel_cap_t	luc_cap;
-	__u32		   luc_umask;
-	struct group_info      *luc_ginfo;
-	struct md_identity     *luc_identity;
-};
-
-struct lvfs_callback_ops {
-	struct dentry *(*l_fid2dentry)(__u64 id_ino, __u32 gen, __u64 gr, void *data);
-};
-
-#define OBD_RUN_CTXT_MAGIC      0xC0FFEEAA
-#define OBD_CTXT_DEBUG	  /* development-only debugging */
 struct lvfs_run_ctxt {
-	struct vfsmount	 *pwdmnt;
-	struct dentry	   *pwd;
-	mm_segment_t	     fs;
-	struct lvfs_ucred	luc;
-	int		      ngroups;
-	struct lvfs_callback_ops cb_ops;
-	struct group_info       *group_info;
 	struct dt_device	*dt;
-#ifdef OBD_CTXT_DEBUG
-	__u32		    magic;
-#endif
 };
 
-#ifdef OBD_CTXT_DEBUG
-#define OBD_SET_CTXT_MAGIC(ctxt) (ctxt)->magic = OBD_RUN_CTXT_MAGIC
-#else
-#define OBD_SET_CTXT_MAGIC(ctxt) do {} while (0)
-#endif
-
-
-int lustre_rename(struct dentry *dir, struct vfsmount *mnt, char *oldname,
-		  char *newname);
-
-static inline void l_dput(struct dentry *de)
-{
-	if (!de || IS_ERR(de))
-		return;
-	//shrink_dcache_parent(de);
-	LASSERT(d_count(de) > 0);
-	dput(de);
-}
-
-/* We need to hold the inode semaphore over the dcache lookup itself, or we
- * run the risk of entering the filesystem lookup path concurrently on SMP
- * systems, and instantiating two inodes for the same entry.  We still
- * protect against concurrent addition/removal races with the DLM locking.
- */
-static inline struct dentry *ll_lookup_one_len(const char *fid_name,
-					       struct dentry *dparent,
-					       int fid_namelen)
-{
-	struct dentry *dchild;
-
-	mutex_lock(&dparent->d_inode->i_mutex);
-	dchild = lookup_one_len(fid_name, dparent, fid_namelen);
-	mutex_unlock(&dparent->d_inode->i_mutex);
-
-	if (IS_ERR(dchild) || dchild->d_inode == NULL)
-		return dchild;
-
-	if (is_bad_inode(dchild->d_inode)) {
-		CERROR("bad inode returned %lu/%u\n",
-		       dchild->d_inode->i_ino, dchild->d_inode->i_generation);
-		dput(dchild);
-		dchild = ERR_PTR(-ENOENT);
-	}
-	return dchild;
-}
-
-
 #endif
diff --git a/drivers/staging/lustre/lustre/include/lvfs.h b/drivers/staging/lustre/lustre/include/lvfs.h
index f91907c..83bbce5 100644
--- a/drivers/staging/lustre/lustre/include/lvfs.h
+++ b/drivers/staging/lustre/lustre/include/lvfs.h
@@ -39,17 +39,9 @@
 #ifndef __LVFS_H__
 #define __LVFS_H__
 
-#define LL_FID_NAMELEN (16 + 1 + 8 + 1)
-
 #include "../../include/linux/libcfs/libcfs.h"
 #include "linux/lvfs.h"
 
 #include "../../include/linux/libcfs/lucache.h"
 
-
-/* lvfs_linux.c */
-void push_ctxt(struct lvfs_run_ctxt *save, struct lvfs_run_ctxt *new_ctx,
-	       struct lvfs_ucred *cred);
-void pop_ctxt(struct lvfs_run_ctxt *saved, struct lvfs_run_ctxt *new_ctx,
-	      struct lvfs_ucred *cred);
 #endif
diff --git a/drivers/staging/lustre/lustre/include/obd_class.h b/drivers/staging/lustre/lustre/include/obd_class.h
index 9030171..882e40b 100644
--- a/drivers/staging/lustre/lustre/include/obd_class.h
+++ b/drivers/staging/lustre/lustre/include/obd_class.h
@@ -1090,16 +1090,6 @@ static inline int obd_destroy_export(struct obd_export *exp)
 	return 0;
 }
 
-static inline struct dentry *
-obd_lvfs_fid2dentry(struct obd_export *exp, struct ost_id *oi, __u32 gen)
-{
-	struct lvfs_run_ctxt *ctxt = &exp->exp_obd->obd_lvfs_ctxt;
-	LASSERT(exp->exp_obd);
-
-	return ctxt->cb_ops.l_fid2dentry(ostid_id(oi), gen, ostid_seq(oi),
-					 exp->exp_obd);
-}
-
 /* @max_age is the oldest time in jiffies that we accept using a cached data.
  * If the cache is older than @max_age we will get a new value from the
  * target.  Use a value of "cfs_time_current() + HZ" to guarantee freshness. */
-- 
1.7.9.5

