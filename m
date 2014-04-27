Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949AbaD0RRY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 13:17:24 -0400
Received: from linuxhacker.ru ([217.76.32.60]:48057 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754226AbaD0RIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 13:08:13 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Brian Behlendorf <behlendorf1@llnl.gov>, Lai Siyao <lai.siyao@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 23/47] staging/lustre: Limit reply buffer size
Date: Sun, 27 Apr 2014 13:06:47 -0400
Message-Id: <1398618431-29757-24-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
References: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Brian Behlendorf <behlendorf1@llnl.gov>

When allocating a reply buffer for the striping information don't
assume the unlikely worst case.  Instead, assume the common case
and size the buffer based on the observed default ea/cookie size.

The default size is initialized to a single stripe and allowed to
grow up to an entire page if needed.  This means that for smallish
filesystems (less than ~21 OSTs) where the worst case striping
information can fit in a single page there is effectively no
change.  Only for larger filesystem will the default be less than
the maximum.  This has a number of advantages.

* By limiting the default reply buffer size we avoid always
  vmalloc()'ing the buffer because it exceeds four pages in size
  and instead kmalloc() it.  This prevents the client from
  thrashing on the global vmalloc() spin lock.

* A reply buffer of exactly the right size (no larger) is allocated
  in the overflow case.  These larger reply buffers are still
  unlikely to exceed the 16k limit where a vmalloc() will occur.

* Saves memory in the common case.  Wide striped files exceeded
  the default are expected to be the exception.

The reason this patch works is because the ptlrpc layer is smart
enough to reallocate the reply buffer when an overflow occurs.
Therefore the client doesn't have to drop the incoming reply and
send a new request with a larger reply buffer.

It's also worth mentioning that the reply buffer always contains
a significant amount of extra padding because they are rounded up
to the nearest power of two.  This means that even files striped
wider than the default have a good chance of fitting in the
allocated reply buffer.

Also remove client eadatasize check in mdt xattr packing because
as said above client can handle -EOVERFLOW.

Signed-off-by: Brian Behlendorf <behlendorf1@llnl.gov>
Signed-off-by: Lai Siyao <lai.siyao@intel.com>
Reviewed-on: http://review.whamcloud.com/6339
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3338
Reviewed-by: James Simmons <uja.ornl@gmail.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: Bob Glossman <bob.glossman@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/include/lustre_mdc.h | 23 ++++++---
 drivers/staging/lustre/lustre/include/obd.h        | 15 ++++--
 drivers/staging/lustre/lustre/include/obd_class.h  |  5 +-
 .../staging/lustre/lustre/lclient/lcommon_misc.c   | 15 ++++--
 drivers/staging/lustre/lustre/llite/dir.c          |  2 +-
 drivers/staging/lustre/lustre/llite/file.c         |  8 ++--
 .../staging/lustre/lustre/llite/llite_internal.h   |  8 ++--
 drivers/staging/lustre/lustre/llite/llite_lib.c    | 39 ++++++++++++++++
 drivers/staging/lustre/lustre/llite/llite_nfs.c    |  4 +-
 drivers/staging/lustre/lustre/llite/lproc_llite.c  | 54 ++++++++++++++++++++--
 drivers/staging/lustre/lustre/lmv/lmv_obd.c        | 25 ++++++----
 drivers/staging/lustre/lustre/mdc/mdc_locks.c      | 10 ++--
 drivers/staging/lustre/lustre/mdc/mdc_reint.c      |  8 ++--
 drivers/staging/lustre/lustre/mdc/mdc_request.c    | 49 +++++++++++++++++---
 14 files changed, 206 insertions(+), 59 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre_mdc.h b/drivers/staging/lustre/lustre/include/lustre_mdc.h
index 468f363..66765d4 100644
--- a/drivers/staging/lustre/lustre/include/lustre_mdc.h
+++ b/drivers/staging/lustre/lustre/include/lustre_mdc.h
@@ -140,17 +140,26 @@ static inline void mdc_put_rpc_lock(struct mdc_rpc_lock *lck,
 	mutex_unlock(&lck->rpcl_mutex);
 }
 
+/* Update the maximum observed easize and cookiesize.  The default easize
+ * and cookiesize is initialized to the minimum value but allowed to grow
+ * up to a single page in size if required to handle the common case.
+ */
 static inline void mdc_update_max_ea_from_body(struct obd_export *exp,
 					       struct mdt_body *body)
 {
 	if (body->valid & OBD_MD_FLMODEASIZE) {
-		if (exp->exp_obd->u.cli.cl_max_mds_easize < body->max_mdsize)
-			exp->exp_obd->u.cli.cl_max_mds_easize =
-						body->max_mdsize;
-		if (exp->exp_obd->u.cli.cl_max_mds_cookiesize <
-						body->max_cookiesize)
-			exp->exp_obd->u.cli.cl_max_mds_cookiesize =
-						body->max_cookiesize;
+		struct client_obd *cli = &exp->exp_obd->u.cli;
+
+		if (cli->cl_max_mds_easize < body->max_mdsize) {
+			cli->cl_max_mds_easize = body->max_mdsize;
+			cli->cl_default_mds_easize =
+			    min_t(__u32, body->max_mdsize, PAGE_CACHE_SIZE);
+		}
+		if (cli->cl_max_mds_cookiesize < body->max_cookiesize) {
+			cli->cl_max_mds_cookiesize = body->max_cookiesize;
+			cli->cl_default_mds_cookiesize =
+			    min_t(__u32, body->max_cookiesize, PAGE_CACHE_SIZE);
+		}
 	}
 }
 
diff --git a/drivers/staging/lustre/lustre/include/obd.h b/drivers/staging/lustre/lustre/include/obd.h
index 75fdf19..7ed5fcd 100644
--- a/drivers/staging/lustre/lustre/include/obd.h
+++ b/drivers/staging/lustre/lustre/include/obd.h
@@ -316,9 +316,10 @@ struct client_obd {
 	int		      cl_conn_count;
 	/* max_mds_easize is purely a performance thing so we don't have to
 	 * call obd_size_diskmd() all the time. */
-	int		      cl_default_mds_easize;
-	int		      cl_max_mds_easize;
-	int		      cl_max_mds_cookiesize;
+	int			 cl_default_mds_easize;
+	int			 cl_max_mds_easize;
+	int			 cl_default_mds_cookiesize;
+	int			 cl_max_mds_cookiesize;
 
 	enum lustre_sec_part     cl_sp_me;
 	enum lustre_sec_part     cl_sp_to;
@@ -605,6 +606,7 @@ struct lmv_obd {
 	int			max_easize;
 	int			max_def_easize;
 	int			max_cookiesize;
+	int			max_def_cookiesize;
 	int			server_timeout;
 
 	int			tgts_size; /* size of tgts array */
@@ -996,7 +998,10 @@ enum obd_cleanup_stage {
 #define KEY_LOCK_TO_STRIPE      "lock_to_stripe"
 #define KEY_LOVDESC	     "lovdesc"
 #define KEY_LOV_IDX	     "lov_idx"
-#define KEY_MAX_EASIZE	  "max_easize"
+#define KEY_MAX_EASIZE		"max_easize"
+#define KEY_DEFAULT_EASIZE	"default_easize"
+#define KEY_MAX_COOKIESIZE	"max_cookiesize"
+#define KEY_DEFAULT_COOKIESIZE	"default_cookiesize"
 #define KEY_MDS_CONN	    "mds_conn"
 #define KEY_MGSSEC	      "mgssec"
 #define KEY_NEXT_ID	     "next_id"
@@ -1390,7 +1395,7 @@ struct md_ops {
 			  const char *, int, int, int,
 			  struct ptlrpc_request **);
 
-	int (*m_init_ea_size)(struct obd_export *, int, int, int);
+	int (*m_init_ea_size)(struct obd_export *, int, int, int, int);
 
 	int (*m_get_lustre_md)(struct obd_export *, struct ptlrpc_request *,
 			       struct obd_export *, struct obd_export *,
diff --git a/drivers/staging/lustre/lustre/include/obd_class.h b/drivers/staging/lustre/lustre/include/obd_class.h
index 956abe7..61ba370 100644
--- a/drivers/staging/lustre/lustre/include/obd_class.h
+++ b/drivers/staging/lustre/lustre/include/obd_class.h
@@ -2046,12 +2046,13 @@ static inline ldlm_mode_t md_lock_match(struct obd_export *exp, __u64 flags,
 }
 
 static inline int md_init_ea_size(struct obd_export *exp, int easize,
-				  int def_asize, int cookiesize)
+				  int def_asize, int cookiesize,
+				  int def_cookiesize)
 {
 	EXP_CHECK_MD_OP(exp, init_ea_size);
 	EXP_MD_COUNTER_INCREMENT(exp, init_ea_size);
 	return MDP(exp->exp_obd, init_ea_size)(exp, easize, def_asize,
-					       cookiesize);
+					       cookiesize, def_cookiesize);
 }
 
 static inline int md_get_remote_perm(struct obd_export *exp,
diff --git a/drivers/staging/lustre/lustre/lclient/lcommon_misc.c b/drivers/staging/lustre/lustre/lclient/lcommon_misc.c
index e04c2d3..21de1cd 100644
--- a/drivers/staging/lustre/lustre/lclient/lcommon_misc.c
+++ b/drivers/staging/lustre/lustre/lclient/lcommon_misc.c
@@ -56,7 +56,7 @@ int cl_init_ea_size(struct obd_export *md_exp, struct obd_export *dt_exp)
 	__u32 valsize = sizeof(struct lov_desc);
 	int rc, easize, def_easize, cookiesize;
 	struct lov_desc desc;
-	__u16 stripes;
+	__u16 stripes, def_stripes;
 
 	rc = obd_get_info(NULL, dt_exp, sizeof(KEY_LOVDESC), KEY_LOVDESC,
 			  &valsize, &desc, NULL);
@@ -67,15 +67,20 @@ int cl_init_ea_size(struct obd_export *md_exp, struct obd_export *dt_exp)
 	lsm.lsm_stripe_count = stripes;
 	easize = obd_size_diskmd(dt_exp, &lsm);
 
-	lsm.lsm_stripe_count = desc.ld_default_stripe_count;
+	def_stripes = min_t(__u32, desc.ld_default_stripe_count,
+			    LOV_MAX_STRIPE_COUNT);
+	lsm.lsm_stripe_count = def_stripes;
 	def_easize = obd_size_diskmd(dt_exp, &lsm);
 
 	cookiesize = stripes * sizeof(struct llog_cookie);
 
-	CDEBUG(D_HA, "updating max_mdsize/max_cookiesize: %d/%d\n",
-	       easize, cookiesize);
+	/* default cookiesize is 0 because from 2.4 server doesn't send
+	 * llog cookies to client. */
+	CDEBUG(D_HA,
+	       "updating def/max_easize: %d/%d def/max_cookiesize: 0/%d\n",
+	       def_easize, easize, cookiesize);
 
-	rc = md_init_ea_size(md_exp, easize, def_easize, cookiesize);
+	rc = md_init_ea_size(md_exp, easize, def_easize, cookiesize, 0);
 	return rc;
 }
 
diff --git a/drivers/staging/lustre/lustre/llite/dir.c b/drivers/staging/lustre/lustre/llite/dir.c
index c391b60..f7d3065 100644
--- a/drivers/staging/lustre/lustre/llite/dir.c
+++ b/drivers/staging/lustre/lustre/llite/dir.c
@@ -795,7 +795,7 @@ int ll_dir_getstripe(struct inode *inode, struct lov_mds_md **lmmp,
 	int rc, lmmsize;
 	struct md_op_data *op_data;
 
-	rc = ll_get_max_mdsize(sbi, &lmmsize);
+	rc = ll_get_default_mdsize(sbi, &lmmsize);
 	if (rc)
 		return rc;
 
diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index 872c878..166321c 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -1440,7 +1440,7 @@ int ll_lov_getstripe_ea_info(struct inode *inode, const char *filename,
 	struct md_op_data *op_data;
 	int rc, lmmsize;
 
-	rc = ll_get_max_mdsize(sbi, &lmmsize);
+	rc = ll_get_default_mdsize(sbi, &lmmsize);
 	if (rc)
 		return rc;
 
@@ -2957,7 +2957,7 @@ int __ll_inode_revalidate_it(struct dentry *dentry, struct lookup_intent *it,
 		int ealen = 0;
 
 		if (S_ISREG(inode->i_mode)) {
-			rc = ll_get_max_mdsize(sbi, &ealen);
+			rc = ll_get_default_mdsize(sbi, &ealen);
 			if (rc)
 				return rc;
 			valid |= OBD_MD_FLEASIZE | OBD_MD_FLMODEASIZE;
@@ -3359,7 +3359,7 @@ static int ll_layout_fetch(struct inode *inode, struct ldlm_lock *lock)
 	 * layout here. Please note that we can't use the LVB buffer in
 	 * completion AST because it doesn't have a large enough buffer */
 	oc = ll_mdscapa_get(inode);
-	rc = ll_get_max_mdsize(sbi, &lmmsize);
+	rc = ll_get_default_mdsize(sbi, &lmmsize);
 	if (rc == 0)
 		rc = md_getxattr(sbi->ll_md_exp, ll_inode2fid(inode), oc,
 				OBD_MD_FLXATTR, XATTR_NAME_LOV, NULL, 0,
@@ -3369,7 +3369,7 @@ static int ll_layout_fetch(struct inode *inode, struct ldlm_lock *lock)
 		return rc;
 
 	body = req_capsule_server_get(&req->rq_pill, &RMF_MDT_BODY);
-	if (body == NULL || body->eadatasize > lmmsize)
+	if (body == NULL)
 		GOTO(out, rc = -EPROTO);
 
 	lmmsize = body->eadatasize;
diff --git a/drivers/staging/lustre/lustre/llite/llite_internal.h b/drivers/staging/lustre/lustre/llite/llite_internal.h
index 69aba0a..4663e82 100644
--- a/drivers/staging/lustre/lustre/llite/llite_internal.h
+++ b/drivers/staging/lustre/lustre/llite/llite_internal.h
@@ -865,6 +865,9 @@ void lustre_dump_dentry(struct dentry *, int recur);
 void lustre_dump_inode(struct inode *);
 int ll_obd_statfs(struct inode *inode, void *arg);
 int ll_get_max_mdsize(struct ll_sb_info *sbi, int *max_mdsize);
+int ll_get_default_mdsize(struct ll_sb_info *sbi, int *default_mdsize);
+int ll_get_max_cookiesize(struct ll_sb_info *sbi, int *max_cookiesize);
+int ll_get_default_cookiesize(struct ll_sb_info *sbi, int *default_cookiesize);
 int ll_process_config(struct lustre_cfg *lcfg);
 struct md_op_data *ll_prep_md_op_data(struct md_op_data *op_data,
 				      struct inode *i1, struct inode *i2,
@@ -1127,11 +1130,6 @@ static inline struct lu_fid *ll_inode2fid(struct inode *inode)
 	return fid;
 }
 
-static inline int ll_mds_max_easize(struct super_block *sb)
-{
-	return sbi2mdc(ll_s2sbi(sb))->cl_max_mds_easize;
-}
-
 static inline __u64 ll_file_maxbytes(struct inode *inode)
 {
 	return ll_i2info(inode)->lli_maxbytes;
diff --git a/drivers/staging/lustre/lustre/llite/llite_lib.c b/drivers/staging/lustre/lustre/llite/llite_lib.c
index 373a24f..582fafc 100644
--- a/drivers/staging/lustre/lustre/llite/llite_lib.c
+++ b/drivers/staging/lustre/lustre/llite/llite_lib.c
@@ -634,6 +634,45 @@ int ll_get_max_mdsize(struct ll_sb_info *sbi, int *lmmsize)
 	return rc;
 }
 
+int ll_get_default_mdsize(struct ll_sb_info *sbi, int *lmmsize)
+{
+	int size, rc;
+
+	size = sizeof(int);
+	rc = obd_get_info(NULL, sbi->ll_md_exp, sizeof(KEY_DEFAULT_EASIZE),
+			 KEY_DEFAULT_EASIZE, &size, lmmsize, NULL);
+	if (rc)
+		CERROR("Get default mdsize error rc %d\n", rc);
+
+	return rc;
+}
+
+int ll_get_max_cookiesize(struct ll_sb_info *sbi, int *lmmsize)
+{
+	int size, rc;
+
+	size = sizeof(int);
+	rc = obd_get_info(NULL, sbi->ll_md_exp, sizeof(KEY_MAX_COOKIESIZE),
+			  KEY_MAX_COOKIESIZE, &size, lmmsize, NULL);
+	if (rc)
+		CERROR("Get max cookiesize error rc %d\n", rc);
+
+	return rc;
+}
+
+int ll_get_default_cookiesize(struct ll_sb_info *sbi, int *lmmsize)
+{
+	int size, rc;
+
+	size = sizeof(int);
+	rc = obd_get_info(NULL, sbi->ll_md_exp, sizeof(KEY_DEFAULT_COOKIESIZE),
+			  KEY_DEFAULT_COOKIESIZE, &size, lmmsize, NULL);
+	if (rc)
+		CERROR("Get default cookiesize error rc %d\n", rc);
+
+	return rc;
+}
+
 void ll_dump_inode(struct inode *inode)
 {
 	struct ll_d_hlist_node *tmp;
diff --git a/drivers/staging/lustre/lustre/llite/llite_nfs.c b/drivers/staging/lustre/lustre/llite/llite_nfs.c
index 3580069..e0e112b 100644
--- a/drivers/staging/lustre/lustre/llite/llite_nfs.c
+++ b/drivers/staging/lustre/lustre/llite/llite_nfs.c
@@ -98,7 +98,7 @@ struct inode *search_inode_for_lustre(struct super_block *sb,
 	if (inode)
 		return inode;
 
-	rc = ll_get_max_mdsize(sbi, &eadatalen);
+	rc = ll_get_default_mdsize(sbi, &eadatalen);
 	if (rc)
 		return ERR_PTR(rc);
 
@@ -290,7 +290,7 @@ static struct dentry *ll_get_parent(struct dentry *dchild)
 	CDEBUG(D_INFO, "getting parent for (%lu,"DFID")\n",
 			dir->i_ino, PFID(ll_inode2fid(dir)));
 
-	rc = ll_get_max_mdsize(sbi, &lmmsize);
+	rc = ll_get_default_mdsize(sbi, &lmmsize);
 	if (rc != 0)
 		return ERR_PTR(rc);
 
diff --git a/drivers/staging/lustre/lustre/llite/lproc_llite.c b/drivers/staging/lustre/lustre/llite/lproc_llite.c
index 021deb9..f291254 100644
--- a/drivers/staging/lustre/lustre/llite/lproc_llite.c
+++ b/drivers/staging/lustre/lustre/llite/lproc_llite.c
@@ -681,7 +681,7 @@ static ssize_t ll_lazystatfs_seq_write(struct file *file, const char *buffer,
 }
 LPROC_SEQ_FOPS(ll_lazystatfs);
 
-static int ll_maxea_size_seq_show(struct seq_file *m, void *v)
+static int ll_max_easize_seq_show(struct seq_file *m, void *v)
 {
 	struct super_block *sb = m->private;
 	struct ll_sb_info *sbi = ll_s2sbi(sb);
@@ -694,7 +694,52 @@ static int ll_maxea_size_seq_show(struct seq_file *m, void *v)
 
 	return seq_printf(m, "%u\n", ealen);
 }
-LPROC_SEQ_FOPS_RO(ll_maxea_size);
+LPROC_SEQ_FOPS_RO(ll_max_easize);
+
+static int ll_defult_easize_seq_show(struct seq_file *m, void *v)
+{
+	struct super_block *sb = m->private;
+	struct ll_sb_info *sbi = ll_s2sbi(sb);
+	unsigned int ealen;
+	int rc;
+
+	rc = ll_get_default_mdsize(sbi, &ealen);
+	if (rc)
+		return rc;
+
+	return seq_printf(m, "%u\n", ealen);
+}
+LPROC_SEQ_FOPS_RO(ll_defult_easize);
+
+static int ll_max_cookiesize_seq_show(struct seq_file *m, void *v)
+{
+	struct super_block *sb = m->private;
+	struct ll_sb_info *sbi = ll_s2sbi(sb);
+	unsigned int cookielen;
+	int rc;
+
+	rc = ll_get_max_cookiesize(sbi, &cookielen);
+	if (rc)
+		return rc;
+
+	return seq_printf(m, "%u\n", cookielen);
+}
+LPROC_SEQ_FOPS_RO(ll_max_cookiesize);
+
+static int ll_defult_cookiesize_seq_show(struct seq_file *m, void *v)
+{
+	struct super_block *sb = m->private;
+	struct ll_sb_info *sbi = ll_s2sbi(sb);
+	unsigned int cookielen;
+	int rc;
+
+	rc = ll_get_default_cookiesize(sbi, &cookielen);
+	if (rc)
+		return rc;
+
+	return seq_printf(m, "%u\n", cookielen);
+}
+LPROC_SEQ_FOPS_RO(ll_defult_cookiesize);
 
 static int ll_sbi_flags_seq_show(struct seq_file *m, void *v)
 {
@@ -781,7 +826,10 @@ static struct lprocfs_vars lprocfs_llite_obd_vars[] = {
 	{ "statahead_agl",    &ll_statahead_agl_fops, 0 },
 	{ "statahead_stats",  &ll_statahead_stats_fops, 0, 0 },
 	{ "lazystatfs",       &ll_lazystatfs_fops, 0 },
-	{ "max_easize",       &ll_maxea_size_fops, 0, 0 },
+	{ "max_easize",       &ll_max_easize_fops, 0, 0 },
+	{ "default_easize",   &ll_defult_easize_fops, 0, 0 },
+	{ "max_cookiesize",   &ll_max_cookiesize_fops, 0, 0 },
+	{ "default_cookiesize", &ll_defult_cookiesize_fops, 0, 0 },
 	{ "sbi_flags",	      &ll_sbi_flags_fops, 0, 0 },
 	{ "xattr_cache",      &ll_xattr_cache_fops, 0, 0 },
 	{ 0 }
diff --git a/drivers/staging/lustre/lustre/lmv/lmv_obd.c b/drivers/staging/lustre/lustre/lmv/lmv_obd.c
index 3ba0a0a..4edf8a3 100644
--- a/drivers/staging/lustre/lustre/lmv/lmv_obd.c
+++ b/drivers/staging/lustre/lustre/lmv/lmv_obd.c
@@ -280,7 +280,7 @@ static void lmv_set_timeouts(struct obd_device *obd)
 }
 
 static int lmv_init_ea_size(struct obd_export *exp, int easize,
-			    int def_easize, int cookiesize)
+			    int def_easize, int cookiesize, int def_cookiesize)
 {
 	struct obd_device   *obd = exp->exp_obd;
 	struct lmv_obd      *lmv = &obd->u.lmv;
@@ -300,6 +300,10 @@ static int lmv_init_ea_size(struct obd_export *exp, int easize,
 		lmv->max_cookiesize = cookiesize;
 		change = 1;
 	}
+	if (lmv->max_def_cookiesize < def_cookiesize) {
+		lmv->max_def_cookiesize = def_cookiesize;
+		change = 1;
+	}
 	if (change == 0)
 		return 0;
 
@@ -315,7 +319,7 @@ static int lmv_init_ea_size(struct obd_export *exp, int easize,
 		}
 
 		rc = md_init_ea_size(lmv->tgts[i]->ltd_exp, easize, def_easize,
-				     cookiesize);
+				     cookiesize, def_cookiesize);
 		if (rc) {
 			CERROR("%s: obd_init_ea_size() failed on MDT target %d:"
 			       " rc = %d.\n", obd->obd_name, i, rc);
@@ -400,8 +404,8 @@ int lmv_connect_mdc(struct obd_device *obd, struct lmv_tgt_desc *tgt)
 	tgt->ltd_exp = mdc_exp;
 	lmv->desc.ld_active_tgt_count++;
 
-	md_init_ea_size(tgt->ltd_exp, lmv->max_easize,
-			lmv->max_def_easize, lmv->max_cookiesize);
+	md_init_ea_size(tgt->ltd_exp, lmv->max_easize, lmv->max_def_easize,
+			lmv->max_cookiesize, lmv->max_def_cookiesize);
 
 	CDEBUG(D_CONFIG, "Connected to %s(%s) successfully (%d)\n",
 		mdc_obd->obd_name, mdc_obd->obd_uuid.uuid,
@@ -527,9 +531,8 @@ static int lmv_add_target(struct obd_device *obd, struct obd_uuid *uuidp,
 			spin_unlock(&lmv->lmv_lock);
 		} else {
 			int easize = sizeof(struct lmv_stripe_md) +
-				     lmv->desc.ld_tgt_count *
-				     sizeof(struct lu_fid);
-			lmv_init_ea_size(obd->obd_self_export, easize, 0, 0);
+				lmv->desc.ld_tgt_count * sizeof(struct lu_fid);
+			lmv_init_ea_size(obd->obd_self_export, easize, 0, 0, 0);
 		}
 	}
 
@@ -578,7 +581,7 @@ int lmv_check_connect(struct obd_device *obd)
 	class_export_put(lmv->exp);
 	lmv->connected = 1;
 	easize = lmv_get_easize(lmv);
-	lmv_init_ea_size(obd->obd_self_export, easize, 0, 0);
+	lmv_init_ea_size(obd->obd_self_export, easize, 0, 0, 0);
 	lmv_init_unlock(lmv);
 	return 0;
 
@@ -2340,7 +2343,11 @@ static int lmv_get_info(const struct lu_env *env, struct obd_export *exp,
 				return 0;
 		}
 		return -EINVAL;
-	} else if (KEY_IS(KEY_MAX_EASIZE) || KEY_IS(KEY_CONN_DATA)) {
+	} else if (KEY_IS(KEY_MAX_EASIZE) ||
+		   KEY_IS(KEY_DEFAULT_EASIZE) ||
+		   KEY_IS(KEY_MAX_COOKIESIZE) ||
+		   KEY_IS(KEY_DEFAULT_COOKIESIZE) ||
+		   KEY_IS(KEY_CONN_DATA)) {
 		rc = lmv_check_connect(obd);
 		if (rc)
 			return rc;
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_locks.c b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
index f86f697..41a18f5 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_locks.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
@@ -442,9 +442,9 @@ static struct ptlrpc_request *mdc_intent_unlink_pack(struct obd_export *exp,
 	mdc_unlink_pack(req, op_data);
 
 	req_capsule_set_size(&req->rq_pill, &RMF_MDT_MD, RCL_SERVER,
-			     obddev->u.cli.cl_max_mds_easize);
+			     obddev->u.cli.cl_default_mds_easize);
 	req_capsule_set_size(&req->rq_pill, &RMF_ACL, RCL_SERVER,
-			     obddev->u.cli.cl_max_mds_cookiesize);
+			     obddev->u.cli.cl_default_mds_cookiesize);
 	ptlrpc_request_set_replen(req);
 	return req;
 }
@@ -484,10 +484,10 @@ static struct ptlrpc_request *mdc_intent_getattr_pack(struct obd_export *exp,
 
 	/* pack the intended request */
 	mdc_getattr_pack(req, valid, it->it_flags, op_data,
-			 obddev->u.cli.cl_max_mds_easize);
+			 obddev->u.cli.cl_default_mds_easize);
 
 	req_capsule_set_size(&req->rq_pill, &RMF_MDT_MD, RCL_SERVER,
-			     obddev->u.cli.cl_max_mds_easize);
+			     obddev->u.cli.cl_default_mds_easize);
 	if (client_is_remote(exp))
 		req_capsule_set_size(&req->rq_pill, &RMF_ACL, RCL_SERVER,
 				     sizeof(struct mdt_remote_perm));
@@ -528,7 +528,7 @@ static struct ptlrpc_request *mdc_intent_layout_pack(struct obd_export *exp,
 	layout->li_opc = LAYOUT_INTENT_ACCESS;
 
 	req_capsule_set_size(&req->rq_pill, &RMF_DLM_LVB, RCL_SERVER,
-			obd->u.cli.cl_max_mds_easize);
+			     obd->u.cli.cl_default_mds_easize);
 	ptlrpc_request_set_replen(req);
 	return req;
 }
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_reint.c b/drivers/staging/lustre/lustre/mdc/mdc_reint.c
index d79aa16..19f20c1 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_reint.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_reint.c
@@ -357,9 +357,9 @@ int mdc_unlink(struct obd_export *exp, struct md_op_data *op_data,
 	mdc_unlink_pack(req, op_data);
 
 	req_capsule_set_size(&req->rq_pill, &RMF_MDT_MD, RCL_SERVER,
-			     obd->u.cli.cl_max_mds_easize);
+			     obd->u.cli.cl_default_mds_easize);
 	req_capsule_set_size(&req->rq_pill, &RMF_LOGCOOKIES, RCL_SERVER,
-			     obd->u.cli.cl_max_mds_cookiesize);
+			     obd->u.cli.cl_default_mds_cookiesize);
 	ptlrpc_request_set_replen(req);
 
 	*request = req;
@@ -470,9 +470,9 @@ int mdc_rename(struct obd_export *exp, struct md_op_data *op_data,
 	mdc_rename_pack(req, op_data, old, oldlen, new, newlen);
 
 	req_capsule_set_size(&req->rq_pill, &RMF_MDT_MD, RCL_SERVER,
-			     obd->u.cli.cl_max_mds_easize);
+			     obd->u.cli.cl_default_mds_easize);
 	req_capsule_set_size(&req->rq_pill, &RMF_LOGCOOKIES, RCL_SERVER,
-			     obd->u.cli.cl_max_mds_cookiesize);
+			     obd->u.cli.cl_default_mds_cookiesize);
 	ptlrpc_request_set_replen(req);
 
 	rc = mdc_reint(req, obd->u.cli.cl_rpc_lock, LUSTRE_IMP_FULL);
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_request.c b/drivers/staging/lustre/lustre/mdc/mdc_request.c
index bde9f93..fca43cf 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_request.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_request.c
@@ -903,9 +903,9 @@ int mdc_close(struct obd_export *exp, struct md_op_data *op_data,
 	mdc_close_pack(req, op_data);
 
 	req_capsule_set_size(&req->rq_pill, &RMF_MDT_MD, RCL_SERVER,
-			     obd->u.cli.cl_max_mds_easize);
+			     obd->u.cli.cl_default_mds_easize);
 	req_capsule_set_size(&req->rq_pill, &RMF_LOGCOOKIES, RCL_SERVER,
-			     obd->u.cli.cl_max_mds_cookiesize);
+			     obd->u.cli.cl_default_mds_cookiesize);
 
 	ptlrpc_request_set_replen(req);
 
@@ -2153,12 +2153,40 @@ int mdc_get_info(const struct lu_env *env, struct obd_export *exp,
 
 		if (*vallen != sizeof(int))
 			return -EINVAL;
-		mdsize = *(int*)val;
+		mdsize = *(int *)val;
 		if (mdsize > exp->exp_obd->u.cli.cl_max_mds_easize)
 			exp->exp_obd->u.cli.cl_max_mds_easize = mdsize;
 		max_easize = val;
 		*max_easize = exp->exp_obd->u.cli.cl_max_mds_easize;
 		return 0;
+	} else if (KEY_IS(KEY_DEFAULT_EASIZE)) {
+		int *default_easize;
+
+		if (*vallen != sizeof(int))
+			return -EINVAL;
+		default_easize = val;
+		*default_easize = exp->exp_obd->u.cli.cl_default_mds_easize;
+		return 0;
+	} else if (KEY_IS(KEY_MAX_COOKIESIZE)) {
+		int mdsize, *max_cookiesize;
+
+		if (*vallen != sizeof(int))
+			return -EINVAL;
+		mdsize = *(int *)val;
+		if (mdsize > exp->exp_obd->u.cli.cl_max_mds_cookiesize)
+			exp->exp_obd->u.cli.cl_max_mds_cookiesize = mdsize;
+		max_cookiesize = val;
+		*max_cookiesize = exp->exp_obd->u.cli.cl_max_mds_cookiesize;
+		return 0;
+	} else if (KEY_IS(KEY_DEFAULT_COOKIESIZE)) {
+		int *default_cookiesize;
+
+		if (*vallen != sizeof(int))
+			return -EINVAL;
+		default_cookiesize = val;
+		*default_cookiesize =
+			exp->exp_obd->u.cli.cl_default_mds_cookiesize;
+		return 0;
 	} else if (KEY_IS(KEY_CONN_DATA)) {
 		struct obd_import *imp = class_exp2cliimp(exp);
 		struct obd_connect_data *data = val;
@@ -2439,11 +2467,15 @@ err_rpc_lock:
 }
 
 /* Initialize the default and maximum LOV EA and cookie sizes.  This allows
- * us to make MDS RPCs with large enough reply buffers to hold the
- * maximum-sized (= maximum striped) EA and cookie without having to
- * calculate this (via a call into the LOV + OSCs) each time we make an RPC. */
+ * us to make MDS RPCs with large enough reply buffers to hold a default
+ * sized EA and cookie without having to calculate this (via a call into the
+ * LOV + OSCs) each time we make an RPC.  The maximum size is also tracked
+ * but not used to avoid wastefully vmalloc()'ing large reply buffers when
+ * a large number of stripes is possible.  If a larger reply buffer is
+ * required it will be reallocated in the ptlrpc layer due to overflow.
+ */
 static int mdc_init_ea_size(struct obd_export *exp, int easize,
-		     int def_easize, int cookiesize)
+			    int def_easize, int cookiesize, int def_cookiesize)
 {
 	struct obd_device *obd = exp->exp_obd;
 	struct client_obd *cli = &obd->u.cli;
@@ -2457,6 +2489,9 @@ static int mdc_init_ea_size(struct obd_export *exp, int easize,
 	if (cli->cl_max_mds_cookiesize < cookiesize)
 		cli->cl_max_mds_cookiesize = cookiesize;
 
+	if (cli->cl_default_mds_cookiesize < def_cookiesize)
+		cli->cl_default_mds_cookiesize = def_cookiesize;
+
 	return 0;
 }
 
-- 
1.8.5.3

