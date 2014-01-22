Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735AbaAVNhB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 08:37:01 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:37999 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755703AbaAVNg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 08:36:56 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Lai Siyao <laisiyao@whamcloud.com>,
        Lai Siyao <lai.siyao@intel.com>, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH v2 RESEND 1/8] staging/lustre/llite: remove ll_d_root_ops
Date: Wed, 22 Jan 2014 21:36:12 +0800
Message-Id: <1390397779-30975-2-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1390397779-30975-1-git-send-email-bergwolf@gmail.com>
References: <1390397779-30975-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Siyao <laisiyao@whamcloud.com>

Mnt root dentry will never be revalidated, but its d_op->d_compare
will be called for its children, to simplify code, we use the same
ll_d_ops as normal dentries.
But its attribute may be invalid before access, this won't cause
any issue because it always exists, and the only operation depends
on its attribute is .permission, which has revalidated it in lustre
code.

So it's okay to remove ll_d_root_ops, and remove unnecessary checks
in lookup/revalidate/statahead.

Lustre-change: http://review.whamcloud.com/6797
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3486
Signed-off-by: Lai Siyao <lai.siyao@intel.com>
Reviewed-by: James Simmons <uja.ornl@gmail.com>
Reviewed-by: Peng Tao <bergwolf@gmail.com>
Reviewed-by: Bobi Jam <bobijam@gmail.com>
Reviewed-by: Fan Yong <fan.yong@intel.com>
Reviewed-by: Alexey Shvetsov <alexxy@gentoo.org>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/llite/dcache.c       |   40 ++++----------------
 .../staging/lustre/lustre/llite/llite_internal.h   |    5 ++-
 drivers/staging/lustre/lustre/llite/llite_lib.c    |   11 +-----
 drivers/staging/lustre/lustre/llite/llite_nfs.c    |    6 +--
 drivers/staging/lustre/lustre/llite/namei.c        |   28 +++++++-------
 drivers/staging/lustre/lustre/llite/statahead.c    |    7 ++--
 6 files changed, 33 insertions(+), 64 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/dcache.c b/drivers/staging/lustre/lustre/llite/dcache.c
index cbd663e..3907c87 100644
--- a/drivers/staging/lustre/lustre/llite/dcache.c
+++ b/drivers/staging/lustre/lustre/llite/dcache.c
@@ -176,7 +176,7 @@ static int ll_ddelete(const struct dentry *de)
 	return 0;
 }
 
-static int ll_set_dd(struct dentry *de)
+int ll_d_init(struct dentry *de)
 {
 	LASSERT(de != NULL);
 
@@ -190,40 +190,22 @@ static int ll_set_dd(struct dentry *de)
 		OBD_ALLOC_PTR(lld);
 		if (likely(lld != NULL)) {
 			spin_lock(&de->d_lock);
-			if (likely(de->d_fsdata == NULL))
+			if (likely(de->d_fsdata == NULL)) {
 				de->d_fsdata = lld;
-			else
+				__d_lustre_invalidate(de);
+			} else {
 				OBD_FREE_PTR(lld);
+			}
 			spin_unlock(&de->d_lock);
 		} else {
 			return -ENOMEM;
 		}
 	}
+	LASSERT(de->d_op == &ll_d_ops);
 
 	return 0;
 }
 
-int ll_dops_init(struct dentry *de, int block, int init_sa)
-{
-	struct ll_dentry_data *lld = ll_d2d(de);
-	int rc = 0;
-
-	if (lld == NULL && block != 0) {
-		rc = ll_set_dd(de);
-		if (rc)
-			return rc;
-
-		lld = ll_d2d(de);
-	}
-
-	if (lld != NULL && init_sa != 0)
-		lld->lld_sa_generation = 0;
-
-	/* kernel >= 2.6.38 d_op is set in d_alloc() */
-	LASSERT(de->d_op == &ll_d_ops);
-	return rc;
-}
-
 void ll_intent_drop_lock(struct lookup_intent *it)
 {
 	if (it->it_op && it->d.lustre.it_lock_mode) {
@@ -359,6 +341,8 @@ int ll_revalidate_it(struct dentry *de, int lookup_flags,
 	CDEBUG(D_VFSTRACE, "VFS Op:name=%s,intent=%s\n", de->d_name.name,
 	       LL_IT2STR(it));
 
+	LASSERT(de != de->d_sb->s_root);
+
 	if (de->d_inode == NULL) {
 		__u64 ibits;
 
@@ -383,14 +367,6 @@ int ll_revalidate_it(struct dentry *de, int lookup_flags,
 	if (d_mountpoint(de))
 		GOTO(out_sa, rc = 1);
 
-	/* need to get attributes in case root got changed from other client */
-	if (de == de->d_sb->s_root) {
-		rc = __ll_inode_revalidate_it(de, it, MDS_INODELOCK_LOOKUP);
-		if (rc == 0)
-			rc = 1;
-		GOTO(out_sa, rc);
-	}
-
 	exp = ll_i2mdexp(de->d_inode);
 
 	OBD_FAIL_TIMEOUT(OBD_FAIL_MDC_REVALIDATE_PAUSE, 5);
diff --git a/drivers/staging/lustre/lustre/llite/llite_internal.h b/drivers/staging/lustre/lustre/llite/llite_internal.h
index 7ee5c02..28669ea 100644
--- a/drivers/staging/lustre/lustre/llite/llite_internal.h
+++ b/drivers/staging/lustre/lustre/llite/llite_internal.h
@@ -828,7 +828,7 @@ int ll_lease_close(struct obd_client_handle *och, struct inode *inode,
 
 /* llite/dcache.c */
 
-int ll_dops_init(struct dentry *de, int block, int init_sa);
+int ll_d_init(struct dentry *de);
 extern struct dentry_operations ll_d_ops;
 void ll_intent_drop_lock(struct lookup_intent *);
 void ll_intent_release(struct lookup_intent *);
@@ -1320,7 +1320,8 @@ ll_statahead_mark(struct inode *dir, struct dentry *dentry)
 	if (lli->lli_opendir_pid != current_pid())
 		return;
 
-	if (sai != NULL && ldd != NULL)
+	LASSERT(ldd != NULL);
+	if (sai != NULL)
 		ldd->lld_sa_generation = sai->sai_generation;
 }
 
diff --git a/drivers/staging/lustre/lustre/llite/llite_lib.c b/drivers/staging/lustre/lustre/llite/llite_lib.c
index 6cfdb9e..70a6808 100644
--- a/drivers/staging/lustre/lustre/llite/llite_lib.c
+++ b/drivers/staging/lustre/lustre/llite/llite_lib.c
@@ -155,11 +155,6 @@ void ll_free_sbi(struct super_block *sb)
 	}
 }
 
-static struct dentry_operations ll_d_root_ops = {
-	.d_compare = ll_dcompare,
-	.d_revalidate = ll_revalidate_nd,
-};
-
 static int client_common_fill_super(struct super_block *sb, char *md, char *dt,
 				    struct vfsmount *mnt)
 {
@@ -579,10 +574,6 @@ static int client_common_fill_super(struct super_block *sb, char *md, char *dt,
 		GOTO(out_root, err = -ENOMEM);
 	}
 
-	/* kernel >= 2.6.38 store dentry operations in sb->s_d_op. */
-	d_set_d_op(sb->s_root, &ll_d_root_ops);
-	sb->s_d_op = &ll_d_ops;
-
 	sbi->ll_sdev_orig = sb->s_dev;
 
 	/* We set sb->s_dev equal on all lustre clients in order to support
@@ -1013,6 +1004,8 @@ int ll_fill_super(struct super_block *sb, struct vfsmount *mnt)
 		GOTO(out_free, err);
 
 	sb->s_bdi = &lsi->lsi_bdi;
+	/* kernel >= 2.6.38 store dentry operations in sb->s_d_op. */
+	sb->s_d_op = &ll_d_ops;
 
 	/* Generate a string unique to this super, in case some joker tries
 	   to mount the same fs at two mount points.
diff --git a/drivers/staging/lustre/lustre/llite/llite_nfs.c b/drivers/staging/lustre/lustre/llite/llite_nfs.c
index 1767c74..3580069 100644
--- a/drivers/staging/lustre/lustre/llite/llite_nfs.c
+++ b/drivers/staging/lustre/lustre/llite/llite_nfs.c
@@ -167,10 +167,10 @@ ll_iget_for_nfs(struct super_block *sb, struct lu_fid *fid, struct lu_fid *paren
 	}
 
 	result = d_obtain_alias(inode);
-	if (IS_ERR(result))
+	if (IS_ERR(result)) {
+		iput(inode);
 		return result;
-
-	ll_dops_init(result, 1, 0);
+	}
 
 	return result;
 }
diff --git a/drivers/staging/lustre/lustre/llite/namei.c b/drivers/staging/lustre/lustre/llite/namei.c
index fc8d264..bc1a644 100644
--- a/drivers/staging/lustre/lustre/llite/namei.c
+++ b/drivers/staging/lustre/lustre/llite/namei.c
@@ -400,11 +400,16 @@ static struct dentry *ll_find_alias(struct inode *inode, struct dentry *dentry)
 struct dentry *ll_splice_alias(struct inode *inode, struct dentry *de)
 {
 	struct dentry *new;
+	int rc;
 
 	if (inode) {
 		new = ll_find_alias(inode, de);
 		if (new) {
-			ll_dops_init(new, 1, 1);
+			rc = ll_d_init(new);
+			if (rc < 0) {
+				dput(new);
+				return ERR_PTR(rc);
+			}
 			d_move(new, de);
 			iput(inode);
 			CDEBUG(D_DENTRY,
@@ -413,8 +418,9 @@ struct dentry *ll_splice_alias(struct inode *inode, struct dentry *de)
 			return new;
 		}
 	}
-	ll_dops_init(de, 1, 1);
-	__d_lustre_invalidate(de);
+	rc = ll_d_init(de);
+	if (rc < 0)
+		return ERR_PTR(rc);
 	d_add(de, inode);
 	CDEBUG(D_DENTRY, "Add dentry %p inode %p refc %d flags %#x\n",
 	       de, de->d_inode, d_count(de), de->d_flags);
@@ -455,8 +461,11 @@ int ll_lookup_it_finish(struct ptlrpc_request *request,
 	/* Only hash *de if it is unhashed (new dentry).
 	 * Atoimc_open may passin hashed dentries for open.
 	 */
-	if (d_unhashed(*de))
+	if (d_unhashed(*de)) {
 		*de = ll_splice_alias(inode, *de);
+		if (IS_ERR(*de))
+			return PTR_ERR(*de);
+	}
 
 	if (!it_disposition(it, DISP_LOOKUP_NEG)) {
 		/* we have lookup look - unhide dentry */
@@ -505,16 +514,6 @@ static struct dentry *ll_lookup_it(struct inode *parent, struct dentry *dentry,
 
 	ll_frob_intent(&it, &lookup_it);
 
-	/* As do_lookup is called before follow_mount, root dentry may be left
-	 * not valid, revalidate it here. */
-	if (parent->i_sb->s_root && (parent->i_sb->s_root->d_inode == parent) &&
-	    (it->it_op & (IT_OPEN | IT_CREAT))) {
-		rc = ll_inode_revalidate_it(parent->i_sb->s_root, it,
-					    MDS_INODELOCK_LOOKUP);
-		if (rc)
-			return ERR_PTR(rc);
-	}
-
 	if (it->it_op == IT_GETATTR) {
 		rc = ll_statahead_enter(parent, &dentry, 0);
 		if (rc == 1) {
@@ -585,7 +584,6 @@ static struct dentry *ll_lookup_nd(struct inode *parent, struct dentry *dentry,
 
 	/* Optimize away (CREATE && !OPEN). Let .create handle the race. */
 	if ((flags & LOOKUP_CREATE ) && !(flags & LOOKUP_OPEN)) {
-		ll_dops_init(dentry, 1, 1);
 		__d_lustre_invalidate(dentry);
 		d_add(dentry, NULL);
 		return NULL;
diff --git a/drivers/staging/lustre/lustre/llite/statahead.c b/drivers/staging/lustre/lustre/llite/statahead.c
index f6b5f4b9..183b415 100644
--- a/drivers/staging/lustre/lustre/llite/statahead.c
+++ b/drivers/staging/lustre/lustre/llite/statahead.c
@@ -877,9 +877,6 @@ static int do_sa_revalidate(struct inode *dir, struct ll_sa_entry *entry,
 	if (d_mountpoint(dentry))
 		return 1;
 
-	if (unlikely(dentry == dentry->d_sb->s_root))
-		return 1;
-
 	entry->se_inode = igrab(inode);
 	rc = md_revalidate_lock(ll_i2mdexp(dir), &it, ll_inode2fid(inode),NULL);
 	if (rc == 1) {
@@ -1590,6 +1587,10 @@ int do_statahead_enter(struct inode *dir, struct dentry **dentryp,
 				if ((*dentryp)->d_inode == NULL) {
 					*dentryp = ll_splice_alias(inode,
 								   *dentryp);
+					if (IS_ERR(*dentryp)) {
+						ll_sai_unplug(sai, entry);
+						return PTR_ERR(*dentryp);
+					}
 				} else if ((*dentryp)->d_inode != inode) {
 					/* revalidate, but inode is recreated */
 					CDEBUG(D_READA,
-- 
1.7.9.5

