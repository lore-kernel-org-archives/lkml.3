Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861AbaATMZM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 07:25:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60247 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753817AbaATMZC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 07:25:02 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH 22/24] GFS2: Don't use ENOBUFS when ENOMEM is the correct error code
Date: Mon, 20 Jan 2014 12:23:45 +0000
Message-Id: <1390220627-1571-23-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1390220627-1571-1-git-send-email-swhiteho@redhat.com>
References: <1390220627-1571-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro has tactfully pointed out that we are using the incorrect
error code in some cases. This patch fixes that, and also removes
the (unused) return value for glock dumping.

>        * gfs2_iget() - ENOBUFS instead of ENOMEM.  ENOBUFS is
> "No buffer space available (POSIX.1 (XSI STREAMS option))" and since
> we don't support STREAMS it's probably fair game, but... what the hell?

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 6f7a47c..ca0be6c 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1552,13 +1552,11 @@ void gfs2_glock_thaw(struct gfs2_sbd *sdp)
 	glock_hash_walk(thaw_glock, sdp);
 }
 
-static int dump_glock(struct seq_file *seq, struct gfs2_glock *gl)
+static void dump_glock(struct seq_file *seq, struct gfs2_glock *gl)
 {
-	int ret;
 	spin_lock(&gl->gl_spin);
-	ret = gfs2_dump_glock(seq, gl);
+	gfs2_dump_glock(seq, gl);
 	spin_unlock(&gl->gl_spin);
-	return ret;
 }
 
 static void dump_glock_func(struct gfs2_glock *gl)
@@ -1647,10 +1645,9 @@ static const char *hflags2str(char *buf, unsigned flags, unsigned long iflags)
  * @seq: the seq_file struct
  * @gh: the glock holder
  *
- * Returns: 0 on success, -ENOBUFS when we run out of space
  */
 
-static int dump_holder(struct seq_file *seq, const struct gfs2_holder *gh)
+static void dump_holder(struct seq_file *seq, const struct gfs2_holder *gh)
 {
 	struct task_struct *gh_owner = NULL;
 	char flags_buf[32];
@@ -1666,7 +1663,6 @@ static int dump_holder(struct seq_file *seq, const struct gfs2_holder *gh)
 		       gh_owner ? gh_owner->comm : "(ended)",
 		       (void *)gh->gh_ip);
 	rcu_read_unlock();
-	return 0;
 }
 
 static const char *gflags2str(char *buf, const struct gfs2_glock *gl)
@@ -1721,16 +1717,14 @@ static const char *gflags2str(char *buf, const struct gfs2_glock *gl)
  * example. The field's are n = number (id of the object), f = flags,
  * t = type, s = state, r = refcount, e = error, p = pid.
  *
- * Returns: 0 on success, -ENOBUFS when we run out of space
  */
 
-int gfs2_dump_glock(struct seq_file *seq, const struct gfs2_glock *gl)
+void gfs2_dump_glock(struct seq_file *seq, const struct gfs2_glock *gl)
 {
 	const struct gfs2_glock_operations *glops = gl->gl_ops;
 	unsigned long long dtime;
 	const struct gfs2_holder *gh;
 	char gflags_buf[32];
-	int error = 0;
 
 	dtime = jiffies - gl->gl_demote_time;
 	dtime *= 1000000/HZ; /* demote time in uSec */
@@ -1747,15 +1741,11 @@ int gfs2_dump_glock(struct seq_file *seq, const struct gfs2_glock *gl)
 		  atomic_read(&gl->gl_revokes),
 		  (int)gl->gl_lockref.count, gl->gl_hold_time);
 
-	list_for_each_entry(gh, &gl->gl_holders, gh_list) {
-		error = dump_holder(seq, gh);
-		if (error)
-			goto out;
-	}
+	list_for_each_entry(gh, &gl->gl_holders, gh_list)
+		dump_holder(seq, gh);
+
 	if (gl->gl_state != LM_ST_UNLOCKED && glops->go_dump)
-		error = glops->go_dump(seq, gl);
-out:
-	return error;
+		glops->go_dump(seq, gl);
 }
 
 static int gfs2_glstats_seq_show(struct seq_file *seq, void *iter_ptr)
@@ -1953,7 +1943,8 @@ static void gfs2_glock_seq_stop(struct seq_file *seq, void *iter_ptr)
 
 static int gfs2_glock_seq_show(struct seq_file *seq, void *iter_ptr)
 {
-	return dump_glock(seq, iter_ptr);
+	dump_glock(seq, iter_ptr);
+	return 0;
 }
 
 static void *gfs2_sbstats_seq_start(struct seq_file *seq, loff_t *pos)
diff --git a/fs/gfs2/glock.h b/fs/gfs2/glock.h
index 6647d77..32572f7 100644
--- a/fs/gfs2/glock.h
+++ b/fs/gfs2/glock.h
@@ -199,7 +199,7 @@ extern int gfs2_glock_nq_num(struct gfs2_sbd *sdp, u64 number,
 			     struct gfs2_holder *gh);
 extern int gfs2_glock_nq_m(unsigned int num_gh, struct gfs2_holder *ghs);
 extern void gfs2_glock_dq_m(unsigned int num_gh, struct gfs2_holder *ghs);
-extern int gfs2_dump_glock(struct seq_file *seq, const struct gfs2_glock *gl);
+extern void gfs2_dump_glock(struct seq_file *seq, const struct gfs2_glock *gl);
 #define GLOCK_BUG_ON(gl,x) do { if (unlikely(x)) { gfs2_dump_glock(NULL, gl); BUG(); } } while(0)
 extern __printf(2, 3)
 void gfs2_print_dbg(struct seq_file *seq, const char *fmt, ...);
diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index b792dbc..3bf0631 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -437,21 +437,19 @@ static int inode_go_lock(struct gfs2_holder *gh)
  * @seq: The iterator
  * @ip: the inode
  *
- * Returns: 0 on success, -ENOBUFS when we run out of space
  */
 
-static int inode_go_dump(struct seq_file *seq, const struct gfs2_glock *gl)
+static void inode_go_dump(struct seq_file *seq, const struct gfs2_glock *gl)
 {
 	const struct gfs2_inode *ip = gl->gl_object;
 	if (ip == NULL)
-		return 0;
+		return;
 	gfs2_print_dbg(seq, " I: n:%llu/%llu t:%u f:0x%02lx d:0x%08x s:%llu\n",
 		  (unsigned long long)ip->i_no_formal_ino,
 		  (unsigned long long)ip->i_no_addr,
 		  IF2DT(ip->i_inode.i_mode), ip->i_flags,
 		  (unsigned int)ip->i_diskflags,
 		  (unsigned long long)i_size_read(&ip->i_inode));
-	return 0;
 }
 
 /**
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 8c64e26..cf0e344 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -218,7 +218,7 @@ struct gfs2_glock_operations {
 	int (*go_demote_ok) (const struct gfs2_glock *gl);
 	int (*go_lock) (struct gfs2_holder *gh);
 	void (*go_unlock) (struct gfs2_holder *gh);
-	int (*go_dump)(struct seq_file *seq, const struct gfs2_glock *gl);
+	void (*go_dump)(struct seq_file *seq, const struct gfs2_glock *gl);
 	void (*go_callback)(struct gfs2_glock *gl, bool remote);
 	const int go_type;
 	const unsigned long go_flags;
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 51cf10d..b8956f2 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -149,7 +149,7 @@ struct inode *gfs2_inode_lookup(struct super_block *sb, unsigned int type,
 	ip = GFS2_I(inode);
 
 	if (!inode)
-		return ERR_PTR(-ENOBUFS);
+		return ERR_PTR(-ENOMEM);
 
 	if (inode->i_state & I_NEW) {
 		struct gfs2_sbd *sdp = GFS2_SB(inode);
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 06a66c9..1e712b5 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -231,7 +231,7 @@ static int gfs2_read_super(struct gfs2_sbd *sdp, sector_t sector, int silent)
 
 	page = alloc_page(GFP_NOFS);
 	if (unlikely(!page))
-		return -ENOBUFS;
+		return -ENOMEM;
 
 	ClearPageUptodate(page);
 	ClearPageDirty(page);
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 183cf0f..e14e887 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -2120,14 +2120,14 @@ static struct gfs2_rgrpd *rgblk_free(struct gfs2_sbd *sdp, u64 bstart,
  *
  */
 
-int gfs2_rgrp_dump(struct seq_file *seq, const struct gfs2_glock *gl)
+void gfs2_rgrp_dump(struct seq_file *seq, const struct gfs2_glock *gl)
 {
 	struct gfs2_rgrpd *rgd = gl->gl_object;
 	struct gfs2_blkreserv *trs;
 	const struct rb_node *n;
 
 	if (rgd == NULL)
-		return 0;
+		return;
 	gfs2_print_dbg(seq, " R: n:%llu f:%02x b:%u/%u i:%u r:%u e:%u\n",
 		       (unsigned long long)rgd->rd_addr, rgd->rd_flags,
 		       rgd->rd_free, rgd->rd_free_clone, rgd->rd_dinodes,
@@ -2138,7 +2138,6 @@ int gfs2_rgrp_dump(struct seq_file *seq, const struct gfs2_glock *gl)
 		dump_rs(seq, trs);
 	}
 	spin_unlock(&rgd->rd_rsspin);
-	return 0;
 }
 
 static void gfs2_rgrp_error(struct gfs2_rgrpd *rgd)
diff --git a/fs/gfs2/rgrp.h b/fs/gfs2/rgrp.h
index 3a10d2f..463ab2e 100644
--- a/fs/gfs2/rgrp.h
+++ b/fs/gfs2/rgrp.h
@@ -68,7 +68,7 @@ extern void gfs2_rlist_add(struct gfs2_inode *ip, struct gfs2_rgrp_list *rlist,
 extern void gfs2_rlist_alloc(struct gfs2_rgrp_list *rlist, unsigned int state);
 extern void gfs2_rlist_free(struct gfs2_rgrp_list *rlist);
 extern u64 gfs2_ri_total(struct gfs2_sbd *sdp);
-extern int gfs2_rgrp_dump(struct seq_file *seq, const struct gfs2_glock *gl);
+extern void gfs2_rgrp_dump(struct seq_file *seq, const struct gfs2_glock *gl);
 extern int gfs2_rgrp_send_discards(struct gfs2_sbd *sdp, u64 offset,
 				   struct buffer_head *bh,
 				   const struct gfs2_bitmap *bi, unsigned minlen, u64 *ptrimmed);
-- 
1.8.3.1

