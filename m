Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597AbaD0RR0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 13:17:26 -0400
Received: from linuxhacker.ru ([217.76.32.60]:48058 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754227AbaD0RIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 13:08:13 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Jinshan Xiong <jinshan.xiong@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 26/47] staging/lustre/llite: access layout version under a lock
Date: Sun, 27 Apr 2014 13:06:50 -0400
Message-Id: <1398618431-29757-27-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
References: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jinshan Xiong <jinshan.xiong@intel.com>

We used to access layout version under the protection of ldlm
lock, this introduces extra overhead for dlm lock matching.

In this patch, lli_layout_lock is introduced to access the layout
version. Also, when a layout lock is losing, we should tear down
mmap of the correspoding inode to avoid stale data accessing in the
future.

This is part of technical verification of replication.

Signed-off-by: Jinshan Xiong <jinshan.xiong@intel.com>
Reviewed-on: http://review.whamcloud.com/8689
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3254
Reviewed-by: Lai Siyao <lai.siyao@intel.com>
Reviewed-by: Bobi Jam <bobijam@gmail.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/llite/file.c         | 22 ++++-----------
 .../staging/lustre/lustre/llite/llite_internal.h   | 21 ++++++++++++++-
 drivers/staging/lustre/lustre/llite/llite_lib.c    |  3 ++-
 drivers/staging/lustre/lustre/llite/vvp_io.c       |  2 +-
 drivers/staging/lustre/lustre/llite/vvp_object.c   | 31 ++++++++++++++++------
 5 files changed, 51 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index 166321c..e3bc2b0 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -3436,7 +3436,7 @@ static int ll_layout_lock_set(struct lustre_handle *lockh, ldlm_mode_t mode,
 		if (lvb_ready) {
 			/* layout_gen must be valid if layout lock is not
 			 * cancelled and stripe has already set */
-			*gen = lli->lli_layout_gen;
+			*gen = ll_layout_version_get(lli);
 			rc = 0;
 		}
 		GOTO(out, rc);
@@ -3534,32 +3534,20 @@ int ll_layout_refresh(struct inode *inode, __u32 *gen)
 	};
 	int rc;
 
-	*gen = lli->lli_layout_gen;
-	if (!(sbi->ll_flags & LL_SBI_LAYOUT_LOCK))
+	*gen = ll_layout_version_get(lli);
+	if (!(sbi->ll_flags & LL_SBI_LAYOUT_LOCK) || *gen != LL_LAYOUT_GEN_NONE)
 		return 0;
 
 	/* sanity checks */
 	LASSERT(fid_is_sane(ll_inode2fid(inode)));
 	LASSERT(S_ISREG(inode->i_mode));
 
-	/* mostly layout lock is caching on the local side, so try to match
-	 * it before grabbing layout lock mutex. */
-	mode = ll_take_md_lock(inode, MDS_INODELOCK_LAYOUT, &lockh, 0,
-			       LCK_CR | LCK_CW | LCK_PR | LCK_PW);
-	if (mode != 0) { /* hit cached lock */
-		rc = ll_layout_lock_set(&lockh, mode, inode, gen, false);
-		if (rc == 0)
-			return 0;
-
-		/* better hold lli_layout_mutex to try again otherwise
-		 * it will have starvation problem. */
-	}
-
 	/* take layout lock mutex to enqueue layout lock exclusively. */
 	mutex_lock(&lli->lli_layout_mutex);
 
 again:
-	/* try again. Maybe somebody else has done this. */
+	/* mostly layout lock is caching on the local side, so try to match
+	 * it before grabbing layout lock mutex. */
 	mode = ll_take_md_lock(inode, MDS_INODELOCK_LAYOUT, &lockh, 0,
 			       LCK_CR | LCK_CW | LCK_PR | LCK_PW);
 	if (mode != 0) { /* hit cached lock */
diff --git a/drivers/staging/lustre/lustre/llite/llite_internal.h b/drivers/staging/lustre/lustre/llite/llite_internal.h
index 4663e82..d2f8250 100644
--- a/drivers/staging/lustre/lustre/llite/llite_internal.h
+++ b/drivers/staging/lustre/lustre/llite/llite_internal.h
@@ -280,14 +280,33 @@ struct ll_inode_info {
 
 	/* mutex to request for layout lock exclusively. */
 	struct mutex			lli_layout_mutex;
-	/* valid only inside LAYOUT ibits lock, protected by lli_layout_mutex */
+	/* Layout version, protected by lli_layout_lock */
 	__u32				lli_layout_gen;
+	spinlock_t			lli_layout_lock;
 
 	struct rw_semaphore		lli_xattrs_list_rwsem;
 	struct mutex			lli_xattrs_enq_lock;
 	struct list_head		lli_xattrs;/* ll_xattr_entry->xe_list */
 };
 
+static inline __u32 ll_layout_version_get(struct ll_inode_info *lli)
+{
+	__u32 gen;
+
+	spin_lock(&lli->lli_layout_lock);
+	gen = lli->lli_layout_gen;
+	spin_unlock(&lli->lli_layout_lock);
+
+	return gen;
+}
+
+static inline void ll_layout_version_set(struct ll_inode_info *lli, __u32 gen)
+{
+	spin_lock(&lli->lli_layout_lock);
+	lli->lli_layout_gen = gen;
+	spin_unlock(&lli->lli_layout_lock);
+}
+
 int ll_xattr_cache_destroy(struct inode *inode);
 
 int ll_xattr_cache_get(struct inode *inode,
diff --git a/drivers/staging/lustre/lustre/llite/llite_lib.c b/drivers/staging/lustre/lustre/llite/llite_lib.c
index 582fafc..befc30b 100644
--- a/drivers/staging/lustre/lustre/llite/llite_lib.c
+++ b/drivers/staging/lustre/lustre/llite/llite_lib.c
@@ -966,7 +966,8 @@ void ll_lli_init(struct ll_inode_info *lli)
 	mutex_init(&lli->lli_och_mutex);
 	spin_lock_init(&lli->lli_agl_lock);
 	lli->lli_has_smd = false;
-	lli->lli_layout_gen = LL_LAYOUT_GEN_NONE;
+	spin_lock_init(&lli->lli_layout_lock);
+	ll_layout_version_set(lli, LL_LAYOUT_GEN_NONE);
 	lli->lli_clob = NULL;
 
 	init_rwsem(&lli->lli_xattrs_list_rwsem);
diff --git a/drivers/staging/lustre/lustre/llite/vvp_io.c b/drivers/staging/lustre/lustre/llite/vvp_io.c
index c7d7009..5156ab8 100644
--- a/drivers/staging/lustre/lustre/llite/vvp_io.c
+++ b/drivers/staging/lustre/lustre/llite/vvp_io.c
@@ -80,7 +80,7 @@ static bool can_populate_pages(const struct lu_env *env, struct cl_io *io,
 	case CIT_WRITE:
 		/* don't need lock here to check lli_layout_gen as we have held
 		 * extent lock and GROUP lock has to hold to swap layout */
-		if (lli->lli_layout_gen != cio->cui_layout_gen) {
+		if (ll_layout_version_get(lli) != cio->cui_layout_gen) {
 			io->ci_need_restart = 1;
 			/* this will return application a short read/write */
 			io->ci_continue = 0;
diff --git a/drivers/staging/lustre/lustre/llite/vvp_object.c b/drivers/staging/lustre/lustre/llite/vvp_object.c
index 25973de..554a5dd 100644
--- a/drivers/staging/lustre/lustre/llite/vvp_object.c
+++ b/drivers/staging/lustre/lustre/llite/vvp_object.c
@@ -126,7 +126,22 @@ int vvp_conf_set(const struct lu_env *env, struct cl_object *obj,
 	struct ll_inode_info *lli = ll_i2info(conf->coc_inode);
 
 	if (conf->coc_opc == OBJECT_CONF_INVALIDATE) {
-		lli->lli_layout_gen = LL_LAYOUT_GEN_NONE;
+		CDEBUG(D_VFSTRACE, DFID ": losing layout lock\n",
+		       PFID(&lli->lli_fid));
+
+		ll_layout_version_set(lli, LL_LAYOUT_GEN_NONE);
+
+		/* Clean up page mmap for this inode.
+		 * The reason for us to do this is that if the page has
+		 * already been installed into memory space, the process
+		 * can access it without interacting with lustre, so this
+		 * page may be stale due to layout change, and the process
+		 * will never be notified.
+		 * This operation is expensive but mmap processes have to pay
+		 * a price themselves. */
+		unmap_mapping_range(conf->coc_inode->i_mapping,
+				    0, OBD_OBJECT_EOF, 0);
+
 		return 0;
 	}
 
@@ -134,18 +149,18 @@ int vvp_conf_set(const struct lu_env *env, struct cl_object *obj,
 		return 0;
 
 	if (conf->u.coc_md != NULL && conf->u.coc_md->lsm != NULL) {
-		CDEBUG(D_VFSTRACE, "layout lock change: %u -> %u\n",
-			lli->lli_layout_gen,
-			conf->u.coc_md->lsm->lsm_layout_gen);
+		CDEBUG(D_VFSTRACE, DFID ": layout version change: %u -> %u\n",
+		       PFID(&lli->lli_fid), lli->lli_layout_gen,
+		       conf->u.coc_md->lsm->lsm_layout_gen);
 
 		lli->lli_has_smd = lsm_has_objects(conf->u.coc_md->lsm);
-		lli->lli_layout_gen = conf->u.coc_md->lsm->lsm_layout_gen;
+		ll_layout_version_set(lli, conf->u.coc_md->lsm->lsm_layout_gen);
 	} else {
-		CDEBUG(D_VFSTRACE, "layout lock destroyed: %u.\n",
-			lli->lli_layout_gen);
+		CDEBUG(D_VFSTRACE, DFID ": layout nuked: %u.\n",
+		       PFID(&lli->lli_fid), lli->lli_layout_gen);
 
 		lli->lli_has_smd = false;
-		lli->lli_layout_gen = LL_LAYOUT_GEN_EMPTY;
+		ll_layout_version_set(lli, LL_LAYOUT_GEN_EMPTY);
 	}
 	return 0;
 }
-- 
1.8.5.3

