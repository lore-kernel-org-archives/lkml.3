Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247AbaHOQ4Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 12:56:24 -0400
Received: from linuxhacker.ru ([217.76.32.60]:41329 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536AbaHOQ4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 12:56:11 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Oleg Drokin <green@linuxhacker.ru>
Subject: [PATCH 1/2] staging/lustre: get rid of seqno_t and mdsno_t typedefs
Date: Fri, 15 Aug 2014 12:55:55 -0400
Message-Id: <1408121756-29186-2-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408121756-29186-1-git-send-email-green@linuxhacker.ru>
References: <1408121756-29186-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

seqno_t is u64 and mdsno_t is u32 so just use them as such.

Signed-off-by: Oleg Drokin <green@linuxhacker.ru>
---
 drivers/staging/lustre/lustre/fid/fid_request.c          |  6 +++---
 drivers/staging/lustre/lustre/fld/fld_cache.c            | 16 ++++++++--------
 drivers/staging/lustre/lustre/fld/fld_internal.h         |  2 +-
 drivers/staging/lustre/lustre/fld/fld_request.c          |  9 ++++-----
 .../staging/lustre/lustre/include/lustre/lustre_idl.h    |  2 --
 drivers/staging/lustre/lustre/include/lustre_fid.h       |  2 +-
 drivers/staging/lustre/lustre/include/lustre_fld.h       |  5 ++---
 drivers/staging/lustre/lustre/include/md_object.h        |  2 +-
 drivers/staging/lustre/lustre/include/obd.h              |  2 +-
 drivers/staging/lustre/lustre/lmv/lmv_fld.c              |  2 +-
 drivers/staging/lustre/lustre/lmv/lmv_internal.h         | 10 ++++------
 drivers/staging/lustre/lustre/lmv/lmv_obd.c              |  8 +++-----
 12 files changed, 29 insertions(+), 37 deletions(-)

diff --git a/drivers/staging/lustre/lustre/fid/fid_request.c b/drivers/staging/lustre/lustre/fid/fid_request.c
index 992d075..46c11ca 100644
--- a/drivers/staging/lustre/lustre/fid/fid_request.c
+++ b/drivers/staging/lustre/lustre/fid/fid_request.c
@@ -187,7 +187,7 @@ static int seq_client_alloc_meta(const struct lu_env *env,
 
 /* Allocate new sequence for client. */
 static int seq_client_alloc_seq(const struct lu_env *env,
-				struct lu_client_seq *seq, seqno_t *seqnr)
+				struct lu_client_seq *seq, u64 *seqnr)
 {
 	int rc;
 
@@ -249,7 +249,7 @@ static void seq_fid_alloc_fini(struct lu_client_seq *seq)
  * Allocate the whole seq to the caller.
  **/
 int seq_client_get_seq(const struct lu_env *env,
-		       struct lu_client_seq *seq, seqno_t *seqnr)
+		       struct lu_client_seq *seq, u64 *seqnr)
 {
 	wait_queue_t link;
 	int rc;
@@ -313,7 +313,7 @@ int seq_client_alloc_fid(const struct lu_env *env,
 		seq->lcs_fid.f_oid = seq->lcs_width;
 
 	while (1) {
-		seqno_t seqnr;
+		u64 seqnr;
 
 		if (!fid_is_zero(&seq->lcs_fid) &&
 		    fid_oid(&seq->lcs_fid) < seq->lcs_width) {
diff --git a/drivers/staging/lustre/lustre/fld/fld_cache.c b/drivers/staging/lustre/lustre/fld/fld_cache.c
index 759a233..f5a340a 100644
--- a/drivers/staging/lustre/lustre/fld/fld_cache.c
+++ b/drivers/staging/lustre/lustre/fld/fld_cache.c
@@ -263,8 +263,8 @@ void fld_cache_punch_hole(struct fld_cache *cache,
 			  struct fld_cache_entry *f_new)
 {
 	const struct lu_seq_range *range = &f_new->fce_range;
-	const seqno_t new_start  = range->lsr_start;
-	const seqno_t new_end  = range->lsr_end;
+	const u64 new_start  = range->lsr_start;
+	const u64 new_end  = range->lsr_end;
 	struct fld_cache_entry *fldt;
 
 	OBD_ALLOC_GFP(fldt, sizeof(*fldt), GFP_ATOMIC);
@@ -302,9 +302,9 @@ static void fld_cache_overlap_handle(struct fld_cache *cache,
 				struct fld_cache_entry *f_new)
 {
 	const struct lu_seq_range *range = &f_new->fce_range;
-	const seqno_t new_start  = range->lsr_start;
-	const seqno_t new_end  = range->lsr_end;
-	const mdsno_t mdt = range->lsr_index;
+	const u64 new_start  = range->lsr_start;
+	const u64 new_end  = range->lsr_end;
+	const u32 mdt = range->lsr_index;
 
 	/* this is overlap case, these case are checking overlapping with
 	 * prev range only. fixup will handle overlapping with next range. */
@@ -386,8 +386,8 @@ int fld_cache_insert_nolock(struct fld_cache *cache,
 	struct fld_cache_entry *n;
 	struct list_head *head;
 	struct list_head *prev = NULL;
-	const seqno_t new_start  = f_new->fce_range.lsr_start;
-	const seqno_t new_end  = f_new->fce_range.lsr_end;
+	const u64 new_start  = f_new->fce_range.lsr_start;
+	const u64 new_end  = f_new->fce_range.lsr_end;
 	__u32 new_flags  = f_new->fce_range.lsr_flags;
 
 	/*
@@ -516,7 +516,7 @@ struct fld_cache_entry
  * lookup \a seq sequence for range in fld cache.
  */
 int fld_cache_lookup(struct fld_cache *cache,
-		     const seqno_t seq, struct lu_seq_range *range)
+		     const u64 seq, struct lu_seq_range *range)
 {
 	struct fld_cache_entry *flde;
 	struct fld_cache_entry *prev = NULL;
diff --git a/drivers/staging/lustre/lustre/fld/fld_internal.h b/drivers/staging/lustre/lustre/fld/fld_internal.h
index 5da0c1d..8806b60 100644
--- a/drivers/staging/lustre/lustre/fld/fld_internal.h
+++ b/drivers/staging/lustre/lustre/fld/fld_internal.h
@@ -167,7 +167,7 @@ void fld_cache_delete(struct fld_cache *cache,
 void fld_cache_delete_nolock(struct fld_cache *cache,
 			     const struct lu_seq_range *range);
 int fld_cache_lookup(struct fld_cache *cache,
-		     const seqno_t seq, struct lu_seq_range *range);
+		     const u64 seq, struct lu_seq_range *range);
 
 struct fld_cache_entry*
 fld_cache_entry_lookup(struct fld_cache *cache, struct lu_seq_range *range);
diff --git a/drivers/staging/lustre/lustre/fld/fld_request.c b/drivers/staging/lustre/lustre/fld/fld_request.c
index 8e512f9..4539a02 100644
--- a/drivers/staging/lustre/lustre/fld/fld_request.c
+++ b/drivers/staging/lustre/lustre/fld/fld_request.c
@@ -110,15 +110,14 @@ static void fld_exit_request(struct client_obd *cli)
 	client_obd_list_unlock(&cli->cl_loi_list_lock);
 }
 
-static int fld_rrb_hash(struct lu_client_fld *fld,
-			seqno_t seq)
+static int fld_rrb_hash(struct lu_client_fld *fld, u64 seq)
 {
 	LASSERT(fld->lcf_count > 0);
 	return do_div(seq, fld->lcf_count);
 }
 
 static struct lu_fld_target *
-fld_rrb_scan(struct lu_client_fld *fld, seqno_t seq)
+fld_rrb_scan(struct lu_client_fld *fld, u64 seq)
 {
 	struct lu_fld_target *target;
 	int hash;
@@ -173,7 +172,7 @@ struct lu_fld_hash fld_hash[] = {
 };
 
 static struct lu_fld_target *
-fld_client_get_target(struct lu_client_fld *fld, seqno_t seq)
+fld_client_get_target(struct lu_client_fld *fld, u64 seq)
 {
 	struct lu_fld_target *target;
 
@@ -453,7 +452,7 @@ out_req:
 	return rc;
 }
 
-int fld_client_lookup(struct lu_client_fld *fld, seqno_t seq, mdsno_t *mds,
+int fld_client_lookup(struct lu_client_fld *fld, u64 seq, u32 *mds,
 		      __u32 flags, const struct lu_env *env)
 {
 	struct lu_seq_range res = { 0 };
diff --git a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
index 7571462..186f5e3 100644
--- a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
+++ b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
@@ -165,8 +165,6 @@
 #define LUSTRE_LOG_VERSION  0x00050000
 #define LUSTRE_MGS_VERSION  0x00060000
 
-typedef __u32 mdsno_t;
-typedef __u64 seqno_t;
 typedef __u64 obd_id;
 typedef __u64 obd_seq;
 typedef __s64 obd_time;
diff --git a/drivers/staging/lustre/lustre/include/lustre_fid.h b/drivers/staging/lustre/lustre/include/lustre_fid.h
index ffb00f1..2d6fbb4 100644
--- a/drivers/staging/lustre/lustre/include/lustre_fid.h
+++ b/drivers/staging/lustre/lustre/include/lustre_fid.h
@@ -469,7 +469,7 @@ void seq_client_flush(struct lu_client_seq *seq);
 int seq_client_alloc_fid(const struct lu_env *env, struct lu_client_seq *seq,
 			 struct lu_fid *fid);
 int seq_client_get_seq(const struct lu_env *env, struct lu_client_seq *seq,
-		       seqno_t *seqnr);
+		       u64 *seqnr);
 int seq_site_fini(const struct lu_env *env, struct seq_server_site *ss);
 /* Fids common stuff */
 int fid_is_local(const struct lu_env *env,
diff --git a/drivers/staging/lustre/lustre/include/lustre_fld.h b/drivers/staging/lustre/lustre/include/lustre_fld.h
index ce6330f..64c5048 100644
--- a/drivers/staging/lustre/lustre/include/lustre_fld.h
+++ b/drivers/staging/lustre/lustre/include/lustre_fld.h
@@ -137,15 +137,14 @@ void fld_client_fini(struct lu_client_fld *fld);
 
 void fld_client_flush(struct lu_client_fld *fld);
 
-int fld_client_lookup(struct lu_client_fld *fld, seqno_t seq, mdsno_t *mds,
+int fld_client_lookup(struct lu_client_fld *fld, u64 seq, u32 *mds,
 		      __u32 flags, const struct lu_env *env);
 
 int fld_client_create(struct lu_client_fld *fld,
 		      struct lu_seq_range *range,
 		      const struct lu_env *env);
 
-int fld_client_delete(struct lu_client_fld *fld,
-		      seqno_t seq,
+int fld_client_delete(struct lu_client_fld *fld, u64 seq,
 		      const struct lu_env *env);
 
 int fld_client_add_target(struct lu_client_fld *fld,
diff --git a/drivers/staging/lustre/lustre/include/md_object.h b/drivers/staging/lustre/lustre/include/md_object.h
index 2e5d550..bd5f618 100644
--- a/drivers/staging/lustre/lustre/include/md_object.h
+++ b/drivers/staging/lustre/lustre/include/md_object.h
@@ -451,7 +451,7 @@ struct seq_server_site {
 	/**
 	 * mds number of this site.
 	 */
-	mdsno_t	       ss_node_id;
+	u32		      ss_node_id;
 	/**
 	 * Fid location database
 	 */
diff --git a/drivers/staging/lustre/lustre/include/obd.h b/drivers/staging/lustre/lustre/include/obd.h
index 489bdd3..b472136 100644
--- a/drivers/staging/lustre/lustre/include/obd.h
+++ b/drivers/staging/lustre/lustre/include/obd.h
@@ -1057,7 +1057,7 @@ struct md_op_data {
 	struct lu_fid	   op_fid2; /* operation fid2 (usually child) */
 	struct lu_fid	   op_fid3; /* 2 extra fids to find conflicting */
 	struct lu_fid	   op_fid4; /* to the operation locks. */
-	mdsno_t		 op_mds;  /* what mds server open will go to */
+	u32			op_mds;  /* what mds server open will go to */
 	struct lustre_handle    op_handle;
 	obd_time		op_mod_time;
 	const char	     *op_name;
diff --git a/drivers/staging/lustre/lustre/lmv/lmv_fld.c b/drivers/staging/lustre/lustre/lmv/lmv_fld.c
index 8289bcc..e8421f0 100644
--- a/drivers/staging/lustre/lustre/lmv/lmv_fld.c
+++ b/drivers/staging/lustre/lustre/lmv/lmv_fld.c
@@ -53,7 +53,7 @@
 
 int lmv_fld_lookup(struct lmv_obd *lmv,
 		   const struct lu_fid *fid,
-		   mdsno_t *mds)
+		   u32 *mds)
 {
 	int rc;
 
diff --git a/drivers/staging/lustre/lustre/lmv/lmv_internal.h b/drivers/staging/lustre/lustre/lmv/lmv_internal.h
index eb18a59..80e6604 100644
--- a/drivers/staging/lustre/lustre/lmv/lmv_internal.h
+++ b/drivers/staging/lustre/lustre/lmv/lmv_internal.h
@@ -70,10 +70,8 @@ int lmv_intent_open(struct obd_export *exp, struct md_op_data *op_data,
 
 int lmv_blocking_ast(struct ldlm_lock *, struct ldlm_lock_desc *,
 		     void *, int);
-int lmv_fld_lookup(struct lmv_obd *lmv, const struct lu_fid *fid,
-		   mdsno_t *mds);
-int __lmv_fid_alloc(struct lmv_obd *lmv, struct lu_fid *fid,
-		    mdsno_t mds);
+int lmv_fld_lookup(struct lmv_obd *lmv, const struct lu_fid *fid, u32 *mds);
+int __lmv_fid_alloc(struct lmv_obd *lmv, struct lu_fid *fid, u32 mds);
 int lmv_fid_alloc(struct obd_export *exp, struct lu_fid *fid,
 		  struct md_op_data *op_data);
 
@@ -111,7 +109,7 @@ static inline int lmv_get_easize(struct lmv_obd *lmv)
 }
 
 static inline struct lmv_tgt_desc *
-lmv_get_target(struct lmv_obd *lmv, mdsno_t mds)
+lmv_get_target(struct lmv_obd *lmv, u32 mds)
 {
 	int count = lmv->desc.ld_tgt_count;
 	int i;
@@ -130,7 +128,7 @@ lmv_get_target(struct lmv_obd *lmv, mdsno_t mds)
 static inline struct lmv_tgt_desc *
 lmv_find_target(struct lmv_obd *lmv, const struct lu_fid *fid)
 {
-	mdsno_t mds = 0;
+	u32 mds = 0;
 	int rc;
 
 	if (lmv->desc.ld_tgt_count > 1) {
diff --git a/drivers/staging/lustre/lustre/lmv/lmv_obd.c b/drivers/staging/lustre/lustre/lmv/lmv_obd.c
index a66b3e0..0b1e4a1 100644
--- a/drivers/staging/lustre/lustre/lmv/lmv_obd.c
+++ b/drivers/staging/lustre/lustre/lmv/lmv_obd.c
@@ -1201,8 +1201,7 @@ static int lmv_choose_mds(struct lmv_obd *lmv, struct md_op_data *op_data,
  * This is _inode_ placement policy function (not name).
  */
 static int lmv_placement_policy(struct obd_device *obd,
-				struct md_op_data *op_data,
-				mdsno_t *mds)
+				struct md_op_data *op_data, u32 *mds)
 {
 	struct lmv_obd	  *lmv = &obd->u.lmv;
 
@@ -1241,8 +1240,7 @@ static int lmv_placement_policy(struct obd_device *obd,
 	return 0;
 }
 
-int __lmv_fid_alloc(struct lmv_obd *lmv, struct lu_fid *fid,
-		    mdsno_t mds)
+int __lmv_fid_alloc(struct lmv_obd *lmv, struct lu_fid *fid, u32 mds)
 {
 	struct lmv_tgt_desc	*tgt;
 	int			 rc;
@@ -1279,7 +1277,7 @@ int lmv_fid_alloc(struct obd_export *exp, struct lu_fid *fid,
 {
 	struct obd_device     *obd = class_exp2obd(exp);
 	struct lmv_obd	*lmv = &obd->u.lmv;
-	mdsno_t		mds = 0;
+	u32		       mds = 0;
 	int		    rc;
 
 	LASSERT(op_data != NULL);
-- 
1.9.3

