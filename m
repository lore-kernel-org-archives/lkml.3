Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965430Ab3GCUVQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 16:21:16 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:21118 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964853Ab3GCUVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 16:21:11 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Sage Weil <sage@inktank.com>, ceph-devel@vger.kernel.org,
        Waiman Long <Waiman.Long@hp.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH v3 09/25] ceph-fs: Change how dentry's d_lock and d_count fields are accessed
Date: Wed,  3 Jul 2013 16:20:57 -0400
Message-Id: <1372882857-22813-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
To: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because of the changes made in dcache.h header file, files that use
the d_lock and d_count fields of the dentry structure need to be
changed accordingly.  All the d_lock's spin_lock() and spin_unlock()
calls are replaced by the corresponding d_lock() and d_unlock() calls.
References to d_count are replaced by the d_ret_count() calls.
There is no change in logic and everything should just work.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 fs/ceph/caps.c       |    8 ++++----
 fs/ceph/debugfs.c    |    8 ++++----
 fs/ceph/dir.c        |   34 +++++++++++++++++-----------------
 fs/ceph/export.c     |    4 ++--
 fs/ceph/inode.c      |   24 ++++++++++++------------
 fs/ceph/mds_client.c |   22 +++++++++++-----------
 6 files changed, 50 insertions(+), 50 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index da0f9b8..4703347 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -3098,14 +3098,14 @@ int ceph_encode_dentry_release(void **p, struct dentry *dentry,
 	 * doesn't have to be perfect; the mds will revoke anything we don't
 	 * release.
 	 */
-	spin_lock(&dentry->d_lock);
+	d_lock(dentry);
 	if (di->lease_session && di->lease_session->s_mds == mds)
 		force = 1;
-	spin_unlock(&dentry->d_lock);
+	d_unlock(dentry);
 
 	ret = ceph_encode_inode_release(p, dir, mds, drop, unless, force);
 
-	spin_lock(&dentry->d_lock);
+	d_lock(dentry);
 	if (ret && di->lease_session && di->lease_session->s_mds == mds) {
 		dout("encode_dentry_release %p mds%d seq %d\n",
 		     dentry, mds, (int)di->lease_seq);
@@ -3115,6 +3115,6 @@ int ceph_encode_dentry_release(void **p, struct dentry *dentry,
 		rel->dname_seq = cpu_to_le32(di->lease_seq);
 		__ceph_mdsc_drop_dentry_lease(dentry);
 	}
-	spin_unlock(&dentry->d_lock);
+	d_unlock(dentry);
 	return ret;
 }
diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index 6d59006..3575341 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -82,13 +82,13 @@ static int mdsc_show(struct seq_file *s, void *p)
 						    &pathbase, 0);
 			if (IS_ERR(path))
 				path = NULL;
-			spin_lock(&req->r_dentry->d_lock);
+			d_lock(req->r_dentry);
 			seq_printf(s, " #%llx/%.*s (%s)",
 				   ceph_ino(req->r_dentry->d_parent->d_inode),
 				   req->r_dentry->d_name.len,
 				   req->r_dentry->d_name.name,
 				   path ? path : "");
-			spin_unlock(&req->r_dentry->d_lock);
+			d_unlock(req->r_dentry);
 			kfree(path);
 		} else if (req->r_path1) {
 			seq_printf(s, " #%llx/%s", req->r_ino1.ino,
@@ -100,13 +100,13 @@ static int mdsc_show(struct seq_file *s, void *p)
 						    &pathbase, 0);
 			if (IS_ERR(path))
 				path = NULL;
-			spin_lock(&req->r_old_dentry->d_lock);
+			d_lock(req->r_old_dentry);
 			seq_printf(s, " #%llx/%.*s (%s)",
 			   ceph_ino(req->r_old_dentry_dir),
 				   req->r_old_dentry->d_name.len,
 				   req->r_old_dentry->d_name.name,
 				   path ? path : "");
-			spin_unlock(&req->r_old_dentry->d_lock);
+			d_unlock(req->r_old_dentry);
 			kfree(path);
 		} else if (req->r_path2) {
 			if (req->r_ino2.ino)
diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index f02d82b..91c420d 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -44,7 +44,7 @@ int ceph_init_dentry(struct dentry *dentry)
 	if (!di)
 		return -ENOMEM;          /* oh well */
 
-	spin_lock(&dentry->d_lock);
+	d_lock(dentry);
 	if (dentry->d_fsdata) {
 		/* lost a race */
 		kmem_cache_free(ceph_dentry_cachep, di);
@@ -66,7 +66,7 @@ int ceph_init_dentry(struct dentry *dentry)
 	dentry->d_fsdata = di;
 	ceph_dentry_lru_add(dentry);
 out_unlock:
-	spin_unlock(&dentry->d_lock);
+	d_unlock(dentry);
 	return 0;
 }
 
@@ -77,12 +77,12 @@ struct inode *ceph_get_dentry_parent_inode(struct dentry *dentry)
 	if (!dentry)
 		return NULL;
 
-	spin_lock(&dentry->d_lock);
+	d_lock(dentry);
 	if (!IS_ROOT(dentry)) {
 		inode = dentry->d_parent->d_inode;
 		ihold(inode);
 	}
-	spin_unlock(&dentry->d_lock);
+	d_unlock(dentry);
 	return inode;
 }
 
@@ -129,7 +129,7 @@ static int __dcache_readdir(struct file *filp,
 	dout("__dcache_readdir %p at %llu (last %p)\n", dir, filp->f_pos,
 	     last);
 
-	spin_lock(&parent->d_lock);
+	d_lock(parent);
 
 	/* start at beginning? */
 	if (filp->f_pos == 2 || last == NULL ||
@@ -153,7 +153,7 @@ more:
 			fi->flags |= CEPH_F_ATEND;
 			goto out_unlock;
 		}
-		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
+		d_lock_nested(dentry, DENTRY_D_LOCK_NESTED);
 		if (!d_unhashed(dentry) && dentry->d_inode &&
 		    ceph_snap(dentry->d_inode) != CEPH_SNAPDIR &&
 		    ceph_ino(dentry->d_inode) != CEPH_INO_CEPH &&
@@ -163,15 +163,15 @@ more:
 		     dentry->d_name.len, dentry->d_name.name, di->offset,
 		     filp->f_pos, d_unhashed(dentry) ? " unhashed" : "",
 		     !dentry->d_inode ? " null" : "");
-		spin_unlock(&dentry->d_lock);
+		d_unlock(dentry);
 		p = p->prev;
 		dentry = list_entry(p, struct dentry, d_u.d_child);
 		di = ceph_dentry(dentry);
 	}
 
 	dget_dlock(dentry);
-	spin_unlock(&dentry->d_lock);
-	spin_unlock(&parent->d_lock);
+	d_unlock(dentry);
+	d_unlock(parent);
 
 	dout(" %llu (%llu) dentry %p %.*s %p\n", di->offset, filp->f_pos,
 	     dentry, dentry->d_name.len, dentry->d_name.name, dentry->d_inode);
@@ -204,12 +204,12 @@ more:
 		goto out;
 	}
 
-	spin_lock(&parent->d_lock);
+	d_lock(parent);
 	p = p->prev;	/* advance to next dentry */
 	goto more;
 
 out_unlock:
-	spin_unlock(&parent->d_lock);
+	d_unlock(parent);
 out:
 	if (last)
 		dput(last);
@@ -927,10 +927,10 @@ static int ceph_rename(struct inode *old_dir, struct dentry *old_dentry,
  */
 void ceph_invalidate_dentry_lease(struct dentry *dentry)
 {
-	spin_lock(&dentry->d_lock);
+	d_lock(dentry);
 	dentry->d_time = jiffies;
 	ceph_dentry(dentry)->lease_shared_gen = 0;
-	spin_unlock(&dentry->d_lock);
+	d_unlock(dentry);
 }
 
 /*
@@ -948,7 +948,7 @@ static int dentry_lease_is_valid(struct dentry *dentry)
 	struct inode *dir = NULL;
 	u32 seq = 0;
 
-	spin_lock(&dentry->d_lock);
+	d_lock(dentry);
 	di = ceph_dentry(dentry);
 	if (di->lease_session) {
 		s = di->lease_session;
@@ -972,7 +972,7 @@ static int dentry_lease_is_valid(struct dentry *dentry)
 			}
 		}
 	}
-	spin_unlock(&dentry->d_lock);
+	d_unlock(dentry);
 
 	if (session) {
 		ceph_mdsc_lease_send_msg(session, dir, dentry,
@@ -1070,7 +1070,7 @@ static int ceph_snapdir_d_revalidate(struct dentry *dentry,
  * When the VFS prunes a dentry from the cache, we need to clear the
  * complete flag on the parent directory.
  *
- * Called under dentry->d_lock.
+ * Called under d_ret_lock(dentry)
  */
 static void ceph_d_prune(struct dentry *dentry)
 {
@@ -1085,7 +1085,7 @@ static void ceph_d_prune(struct dentry *dentry)
 		return;
 
 	/*
-	 * we hold d_lock, so d_parent is stable, and d_fsdata is never
+	 * we hold d_ret_lock(), so d_parent is stable, and d_fsdata is never
 	 * cleared until d_release
 	 */
 	ceph_dir_clear_complete(dentry->d_parent->d_inode);
diff --git a/fs/ceph/export.c b/fs/ceph/export.c
index 16796be..18c4e04 100644
--- a/fs/ceph/export.c
+++ b/fs/ceph/export.c
@@ -68,7 +68,7 @@ static int ceph_encode_fh(struct inode *inode, u32 *rawfh, int *max_len,
 	/* if we found an alias, generate a connectable fh */
 	if (*max_len >= connected_handle_length && dentry) {
 		dout("encode_fh %p connectable\n", dentry);
-		spin_lock(&dentry->d_lock);
+		d_lock(dentry);
 		parent = dentry->d_parent;
 		cfh->ino = ceph_ino(inode);
 		cfh->parent_ino = ceph_ino(parent->d_inode);
@@ -76,7 +76,7 @@ static int ceph_encode_fh(struct inode *inode, u32 *rawfh, int *max_len,
 							 dentry);
 		*max_len = connected_handle_length;
 		type = 2;
-		spin_unlock(&dentry->d_lock);
+		d_unlock(dentry);
 	} else if (*max_len >= handle_length) {
 		if (parent_inode) {
 			/* nfsd wants connectable */
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index be0f7e2..a704972 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -807,7 +807,7 @@ static void update_dentry_lease(struct dentry *dentry,
 	if (dentry->d_op != &ceph_dentry_ops)
 		return;
 
-	spin_lock(&dentry->d_lock);
+	d_lock(dentry);
 	dout("update_dentry_lease %p duration %lu ms ttl %lu\n",
 	     dentry, duration, ttl);
 
@@ -835,7 +835,7 @@ static void update_dentry_lease(struct dentry *dentry,
 	di->lease_renew_from = 0;
 	dentry->d_time = ttl;
 out_unlock:
-	spin_unlock(&dentry->d_lock);
+	d_unlock(dentry);
 	return;
 }
 
@@ -865,13 +865,13 @@ static void ceph_set_dentry_offset(struct dentry *dn)
 	di->offset = ceph_inode(inode)->i_max_offset++;
 	spin_unlock(&ci->i_ceph_lock);
 
-	spin_lock(&dir->d_lock);
-	spin_lock_nested(&dn->d_lock, DENTRY_D_LOCK_NESTED);
+	d_lock(dir);
+	d_lock_nested(dn, DENTRY_D_LOCK_NESTED);
 	list_move(&dn->d_u.d_child, &dir->d_subdirs);
 	dout("set_dentry_offset %p %lld (%p %p)\n", dn, di->offset,
 	     dn->d_u.d_child.prev, dn->d_u.d_child.next);
-	spin_unlock(&dn->d_lock);
-	spin_unlock(&dir->d_lock);
+	d_unlock(dn);
+	d_unlock(dir);
 }
 
 /*
@@ -903,8 +903,8 @@ static struct dentry *splice_dentry(struct dentry *dn, struct inode *in,
 	} else if (realdn) {
 		dout("dn %p (%d) spliced with %p (%d) "
 		     "inode %p ino %llx.%llx\n",
-		     dn, dn->d_count,
-		     realdn, realdn->d_count,
+		     dn, d_ret_count(dn),
+		     realdn, d_ret_count(realdn),
 		     realdn->d_inode, ceph_vinop(realdn->d_inode));
 		dput(dn);
 		dn = realdn;
@@ -1294,11 +1294,11 @@ retry_lookup:
 			goto retry_lookup;
 		} else {
 			/* reorder parent's d_subdirs */
-			spin_lock(&parent->d_lock);
-			spin_lock_nested(&dn->d_lock, DENTRY_D_LOCK_NESTED);
+			d_lock(parent);
+			d_lock_nested(dn, DENTRY_D_LOCK_NESTED);
 			list_move(&dn->d_u.d_child, &parent->d_subdirs);
-			spin_unlock(&dn->d_lock);
-			spin_unlock(&parent->d_lock);
+			d_unlock(dn);
+			d_unlock(parent);
 		}
 
 		di = dn->d_fsdata;
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 4d29203..24ac9c5 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1515,25 +1515,25 @@ retry:
 	for (temp = dentry; !IS_ROOT(temp) && pos != 0; ) {
 		struct inode *inode;
 
-		spin_lock(&temp->d_lock);
+		d_lock(temp);
 		inode = temp->d_inode;
 		if (inode && ceph_snap(inode) == CEPH_SNAPDIR) {
 			dout("build_path path+%d: %p SNAPDIR\n",
 			     pos, temp);
 		} else if (stop_on_nosnap && inode &&
 			   ceph_snap(inode) == CEPH_NOSNAP) {
-			spin_unlock(&temp->d_lock);
+			d_unlock(temp);
 			break;
 		} else {
 			pos -= temp->d_name.len;
 			if (pos < 0) {
-				spin_unlock(&temp->d_lock);
+				d_unlock(temp);
 				break;
 			}
 			strncpy(path + pos, temp->d_name.name,
 				temp->d_name.len);
 		}
-		spin_unlock(&temp->d_lock);
+		d_unlock(temp);
 		if (pos)
 			path[--pos] = '/';
 		temp = temp->d_parent;
@@ -1553,7 +1553,7 @@ retry:
 	*base = ceph_ino(temp->d_inode);
 	*plen = len;
 	dout("build_path on %p %d built %llx '%.*s'\n",
-	     dentry, dentry->d_count, *base, len, path);
+	     dentry, d_ret_count(dentry), *base, len, path);
 	return path;
 }
 
@@ -2742,7 +2742,7 @@ static void check_new_map(struct ceph_mds_client *mdsc,
  */
 
 /*
- * caller must hold session s_mutex, dentry->d_lock
+ * caller must hold session s_mutex, d_ret_lock(dentry)
  */
 void __ceph_mdsc_drop_dentry_lease(struct dentry *dentry)
 {
@@ -2806,7 +2806,7 @@ static void handle_lease(struct ceph_mds_client *mdsc,
 	if (!dentry)
 		goto release;
 
-	spin_lock(&dentry->d_lock);
+	d_lock(dentry);
 	di = ceph_dentry(dentry);
 	switch (h->action) {
 	case CEPH_MDS_LEASE_REVOKE:
@@ -2834,7 +2834,7 @@ static void handle_lease(struct ceph_mds_client *mdsc,
 		}
 		break;
 	}
-	spin_unlock(&dentry->d_lock);
+	d_unlock(dentry);
 	dput(dentry);
 
 	if (!release)
@@ -2907,7 +2907,7 @@ void ceph_mdsc_lease_release(struct ceph_mds_client *mdsc, struct inode *inode,
 	BUG_ON(dentry == NULL);
 
 	/* is dentry lease valid? */
-	spin_lock(&dentry->d_lock);
+	d_lock(dentry);
 	di = ceph_dentry(dentry);
 	if (!di || !di->lease_session ||
 	    di->lease_session->s_mds < 0 ||
@@ -2916,7 +2916,7 @@ void ceph_mdsc_lease_release(struct ceph_mds_client *mdsc, struct inode *inode,
 		dout("lease_release inode %p dentry %p -- "
 		     "no lease\n",
 		     inode, dentry);
-		spin_unlock(&dentry->d_lock);
+		d_unlock(dentry);
 		return;
 	}
 
@@ -2924,7 +2924,7 @@ void ceph_mdsc_lease_release(struct ceph_mds_client *mdsc, struct inode *inode,
 	session = ceph_get_mds_session(di->lease_session);
 	seq = di->lease_seq;
 	__ceph_mdsc_drop_dentry_lease(dentry);
-	spin_unlock(&dentry->d_lock);
+	d_unlock(dentry);
 
 	dout("lease_release inode %p dentry %p to mds%d\n",
 	     inode, dentry, session->s_mds);
-- 
1.7.1

