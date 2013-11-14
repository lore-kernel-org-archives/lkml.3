Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895Ab3KNQnd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:43:33 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:47489 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756637Ab3KNQkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:40:52 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "John L. Hammond" <jhammond@tacc.utexas.edu>,
        "John L. Hammond" <john.hammond@intel.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 37/39] staging/lustre/obd: add md_stats to MDC and LMV devices
Date: Fri, 15 Nov 2013 00:33:00 +0800
Message-Id: <1384446782-13741-38-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
References: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John L. Hammond" <jhammond@tacc.utexas.edu>

Enable md_stats for MDC and LMV devices and fix the definition of
EXP_MD_COUNTER_INCREMENT() so that they will be tallied. These stats
track usage of the md_ops methods (from the OBD layer, not to be
confused with md_device methods) and are exported through the files
/proc/fs/lustre/{lmv,mdc}/*/md_stats.

Rename m_sync to m_fsync making the counter name (fsync) more
intuitive. Prune the minimally useful operations from set of md_ops to
be counted. The operations counted are close, create, enqueue,
getattr, intent_lock, link, rename, setattr, fsync, readpage, unlink,
setxattr, egtxattr, intent_getattr_async, and revalidate_lock.

Add assertions to lprocfs_counter_{add,sub}() to ensure that the
counter index lies in the appropriate range for stats. Remove the
corresponding assertions from OBD_COUNTER_INCREMENT(),
EXP_COUNTER_INCREMENT(), and EXP_MD_COUNTER_INCREMENT(). Add macros
NUM_OBD_STATS and NUM_MD_STATS for use when allocating stats.

In mdt_export_stats_init() allocate and initialize the nid_stats
member of struct exp_nid_stats using only the MDT private
counters. This does not affect the contents of
/proc/fs/lustre/mdt/*/exports/*/stats but does save memory.

Add a flag to struct obd_device to indicate if EXP_COUNTER_INCREMENT()
should increment stats in the nid_stats member (as in the case of OFD)
or not (MDT).

Remove the unused member exp_md_stats from struct obd_export.

Lustre-change: http://review.whamcloud.com/4827
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-2484
Signed-off-by: John L. Hammond <jhammond@tacc.utexas.edu>
Signed-off-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: wangdi <di.wang@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../staging/lustre/lustre/include/lustre_export.h  |    1 -
 drivers/staging/lustre/lustre/include/obd.h        |  139 ++++++++++++--------
 drivers/staging/lustre/lustre/include/obd_class.h  |  119 +++++++----------
 drivers/staging/lustre/lustre/llite/file.c         |    4 +-
 drivers/staging/lustre/lustre/lmv/lmv_obd.c        |   21 +--
 drivers/staging/lustre/lustre/lvfs/lvfs_lib.c      |    6 +
 drivers/staging/lustre/lustre/mdc/mdc_request.c    |    8 +-
 .../lustre/lustre/obdclass/lprocfs_status.c        |   58 +++++---
 8 files changed, 198 insertions(+), 158 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre_export.h b/drivers/staging/lustre/lustre/include/lustre_export.h
index 2feb38b..6db935e 100644
--- a/drivers/staging/lustre/lustre/include/lustre_export.h
+++ b/drivers/staging/lustre/lustre/include/lustre_export.h
@@ -191,7 +191,6 @@ struct obd_export {
 	 */
 	struct obd_import	*exp_imp_reverse;
 	struct nid_stat	  *exp_nid_stats;
-	struct lprocfs_stats     *exp_md_stats;
 	/** Active connetion */
 	struct ptlrpc_connection *exp_connection;
 	/** Connection count value from last succesful reconnect rpc */
diff --git a/drivers/staging/lustre/lustre/include/obd.h b/drivers/staging/lustre/lustre/include/obd.h
index c3470ce..a643bf1 100644
--- a/drivers/staging/lustre/lustre/include/obd.h
+++ b/drivers/staging/lustre/lustre/include/obd.h
@@ -822,35 +822,38 @@ struct obd_llog_group {
 #define OBD_DEV_BY_DEVNAME      0xffffd0de
 
 struct obd_device {
-	struct obd_type	*obd_type;
-	__u32		   obd_magic;
+	struct obd_type		*obd_type;
+	__u32			 obd_magic;
 
 	/* common and UUID name of this device */
-	char		    obd_name[MAX_OBD_NAME];
-	struct obd_uuid	 obd_uuid;
+	char			 obd_name[MAX_OBD_NAME];
+	struct obd_uuid		 obd_uuid;
+	int			 obd_minor;
+	struct lu_device	*obd_lu_dev;
 
-	struct lu_device       *obd_lu_dev;
-
-	int		     obd_minor;
 	/* bitfield modification is protected by obd_dev_lock */
-	unsigned long obd_attached:1,      /* finished attach */
-		      obd_set_up:1,	/* finished setup */
-		      obd_recovering:1,    /* there are recoverable clients */
-		      obd_abort_recovery:1,/* recovery expired */
-		      obd_version_recov:1, /* obd uses version checking */
-		      obd_replayable:1,    /* recovery is enabled; inform clients */
-		      obd_no_transno:1,    /* no committed-transno notification */
-		      obd_no_recov:1,      /* fail instead of retry messages */
-		      obd_stopping:1,      /* started cleanup */
-		      obd_starting:1,      /* started setup */
-		      obd_force:1,	 /* cleanup with > 0 obd refcount */
-		      obd_fail:1,	  /* cleanup with failover */
-		      obd_async_recov:1,   /* allow asynchronous orphan cleanup */
-		      obd_no_conn:1,       /* deny new connections */
-		      obd_inactive:1,      /* device active/inactive
-					   * (for /proc/status only!!) */
-		      obd_no_ir:1,	 /* no imperative recovery. */
-		      obd_process_conf:1;  /* device is processing mgs config */
+	unsigned long
+		obd_attached:1,		/* finished attach */
+		obd_set_up:1,		/* finished setup */
+		obd_recovering:1,	/* there are recoverable clients */
+		obd_abort_recovery:1,	/* recovery expired */
+		obd_version_recov:1,	/* obd uses version checking */
+		obd_replayable:1,	/* recovery is enabled;
+					 * inform clients */
+		obd_no_transno:1,	/* no committed-transno notification */
+		obd_no_recov:1,		/* fail instead of retry messages */
+		obd_stopping:1,		/* started cleanup */
+		obd_starting:1,		/* started setup */
+		obd_force:1,		/* cleanup with > 0 obd refcount */
+		obd_fail:1,		/* cleanup with failover */
+		obd_async_recov:1,	/* allow asynchronous orphan cleanup */
+		obd_no_conn:1,		/* deny new connections */
+		obd_inactive:1,		/* device active/inactive
+					 * (for /proc/status only!!) */
+		obd_no_ir:1,		/* no imperative recovery. */
+		obd_process_conf:1,	/* device is processing mgs config */
+		obd_uses_nid_stats:1;	/* maintain per-client OBD stats */
+
 	/* use separate field as it is set in interrupt to don't mess with
 	 * protection of other bits using _bh lock */
 	unsigned long obd_recovery_expired:1;
@@ -862,7 +865,6 @@ struct obd_device {
 	struct cfs_hash	     *obd_nid_stats_hash;
 	struct list_head	      obd_nid_stats;
 	atomic_t	    obd_refcount;
-	wait_queue_head_t	     obd_refcount_waitq;
 	struct list_head	      obd_exports;
 	struct list_head	      obd_unlinked_exports;
 	struct list_head	      obd_delayed_exports;
@@ -916,7 +918,6 @@ struct obd_device {
 	struct list_head		       obd_req_replay_queue;
 	struct list_head		       obd_lock_replay_queue;
 	struct list_head		       obd_final_req_queue;
-	int			      obd_recovery_stage;
 
 	union {
 		struct client_obd cli;
@@ -928,8 +929,8 @@ struct obd_device {
 	unsigned int	   obd_cntr_base;
 	struct lprocfs_stats  *obd_stats;
 
-	unsigned int	   md_cntr_base;
-	struct lprocfs_stats  *md_stats;
+	unsigned int	       obd_md_cntr_base;
+	struct lprocfs_stats  *obd_md_stats;
 
 	struct proc_dir_entry  *obd_proc_entry;
 	void		  *obd_proc_private; /* type private PDEs */
@@ -1329,43 +1330,52 @@ struct md_open_data {
 struct lookup_intent;
 
 struct md_ops {
-	int (*m_getstatus)(struct obd_export *, struct lu_fid *,
-			   struct obd_capa **);
-	int (*m_null_inode)(struct obd_export *, const struct lu_fid *);
-	int (*m_find_cbdata)(struct obd_export *, const struct lu_fid *,
-			     ldlm_iterator_t, void *);
+	/* Every operation from MD_STATS_FIRST_OP up to and including
+	 * MD_STATS_LAST_OP will be counted by EXP_MD_OP_INCREMENT()
+	 * and will appear in /proc/fs/lustre/{lmv,mdc}/.../md_stats.
+	 * Operations after MD_STATS_LAST_OP are excluded from stats.
+	 * There are a few reasons for doing this: we prune the 17
+	 * counters which will be of minimal use in understanding
+	 * metadata utilization, we save memory by allocating 15
+	 * instead of 32 counters, we save cycles by not counting.
+	 *
+	 * MD_STATS_FIRST_OP must be the first member of md_ops.
+	 */
+#define MD_STATS_FIRST_OP m_close
 	int (*m_close)(struct obd_export *, struct md_op_data *,
 		       struct md_open_data *, struct ptlrpc_request **);
+
 	int (*m_create)(struct obd_export *, struct md_op_data *,
 			const void *, int, int, __u32, __u32, cfs_cap_t,
 			__u64, struct ptlrpc_request **);
-	int (*m_done_writing)(struct obd_export *, struct md_op_data  *,
-			      struct md_open_data *);
+
 	int (*m_enqueue)(struct obd_export *, struct ldlm_enqueue_info *,
 			 struct lookup_intent *, struct md_op_data *,
 			 struct lustre_handle *, void *, int,
 			 struct ptlrpc_request **, __u64);
+
 	int (*m_getattr)(struct obd_export *, struct md_op_data *,
 			 struct ptlrpc_request **);
-	int (*m_getattr_name)(struct obd_export *, struct md_op_data *,
-			      struct ptlrpc_request **);
+
 	int (*m_intent_lock)(struct obd_export *, struct md_op_data *,
 			     void *, int, struct lookup_intent *, int,
 			     struct ptlrpc_request **,
 			     ldlm_blocking_callback, __u64);
+
 	int (*m_link)(struct obd_export *, struct md_op_data *,
 		      struct ptlrpc_request **);
+
 	int (*m_rename)(struct obd_export *, struct md_op_data *,
 			const char *, int, const char *, int,
 			struct ptlrpc_request **);
-	int (*m_is_subdir)(struct obd_export *, const struct lu_fid *,
-			   const struct lu_fid *,
-			   struct ptlrpc_request **);
+
 	int (*m_setattr)(struct obd_export *, struct md_op_data *, void *,
 			 int , void *, int, struct ptlrpc_request **,
 			 struct md_open_data **mod);
-	int (*m_sync)(struct obd_export *, const struct lu_fid *,
-		      struct obd_capa *, struct ptlrpc_request **);
+
+	int (*m_fsync)(struct obd_export *, const struct lu_fid *,
+		       struct obd_capa *, struct ptlrpc_request **);
+
 	int (*m_readpage)(struct obd_export *, struct md_op_data *,
 			  struct page **, struct ptlrpc_request **);
 
@@ -1382,6 +1392,32 @@ struct md_ops {
 			  const char *, int, int, int,
 			  struct ptlrpc_request **);
 
+	int (*m_intent_getattr_async)(struct obd_export *,
+				      struct md_enqueue_info *,
+				      struct ldlm_enqueue_info *);
+
+	int (*m_revalidate_lock)(struct obd_export *, struct lookup_intent *,
+				 struct lu_fid *, __u64 *bits);
+#define MD_STATS_LAST_OP m_revalidate_lock
+
+	int (*m_getstatus)(struct obd_export *, struct lu_fid *,
+			   struct obd_capa **);
+
+	int (*m_null_inode)(struct obd_export *, const struct lu_fid *);
+
+	int (*m_find_cbdata)(struct obd_export *, const struct lu_fid *,
+			     ldlm_iterator_t, void *);
+
+	int (*m_done_writing)(struct obd_export *, struct md_op_data  *,
+			      struct md_open_data *);
+
+	int (*m_getattr_name)(struct obd_export *, struct md_op_data *,
+			      struct ptlrpc_request **);
+
+	int (*m_is_subdir)(struct obd_export *, const struct lu_fid *,
+			   const struct lu_fid *,
+			   struct ptlrpc_request **);
+
 	int (*m_init_ea_size)(struct obd_export *, int, int, int);
 
 	int (*m_get_lustre_md)(struct obd_export *, struct ptlrpc_request *,
@@ -1393,8 +1429,10 @@ struct md_ops {
 	int (*m_set_open_replay_data)(struct obd_export *,
 				      struct obd_client_handle *,
 				      struct ptlrpc_request *);
+
 	int (*m_clear_open_replay_data)(struct obd_export *,
 					struct obd_client_handle *);
+
 	int (*m_set_lock_data)(struct obd_export *, __u64 *, void *, __u64 *);
 
 	ldlm_mode_t (*m_lock_match)(struct obd_export *, __u64,
@@ -1405,27 +1443,16 @@ struct md_ops {
 	int (*m_cancel_unused)(struct obd_export *, const struct lu_fid *,
 			       ldlm_policy_data_t *, ldlm_mode_t,
 			       ldlm_cancel_flags_t flags, void *opaque);
+
 	int (*m_renew_capa)(struct obd_export *, struct obd_capa *oc,
 			    renew_capa_cb_t cb);
+
 	int (*m_unpack_capa)(struct obd_export *, struct ptlrpc_request *,
 			     const struct req_msg_field *, struct obd_capa **);
 
 	int (*m_get_remote_perm)(struct obd_export *, const struct lu_fid *,
 				 struct obd_capa *, __u32,
 				 struct ptlrpc_request **);
-
-	int (*m_intent_getattr_async)(struct obd_export *,
-				      struct md_enqueue_info *,
-				      struct ldlm_enqueue_info *);
-
-	int (*m_revalidate_lock)(struct obd_export *, struct lookup_intent *,
-				 struct lu_fid *, __u64 *bits);
-
-	/*
-	 * NOTE: If adding ops, add another LPROCFS_MD_OP_INIT() line to
-	 * lprocfs_alloc_md_stats() in obdclass/lprocfs_status.c. Also, add a
-	 * wrapper function in include/linux/obd_class.h.
-	 */
 };
 
 struct lsm_operations {
diff --git a/drivers/staging/lustre/lustre/include/obd_class.h b/drivers/staging/lustre/lustre/include/obd_class.h
index 8cb7cdf..9610e96 100644
--- a/drivers/staging/lustre/lustre/include/obd_class.h
+++ b/drivers/staging/lustre/lustre/include/obd_class.h
@@ -348,64 +348,57 @@ do {							    \
 
 
 #ifdef LPROCFS
-#define OBD_COUNTER_OFFSET(op)				  \
-	((offsetof(struct obd_ops, o_ ## op) -		  \
-	  offsetof(struct obd_ops, o_iocontrol))		\
-	 / sizeof(((struct obd_ops *)(0))->o_iocontrol))
-
-#define OBD_COUNTER_INCREMENT(obdx, op)			   \
-	if ((obdx)->obd_stats != NULL) {			  \
-		unsigned int coffset;			     \
-		coffset = (unsigned int)((obdx)->obd_cntr_base) + \
-			OBD_COUNTER_OFFSET(op);		   \
-		LASSERT(coffset < (obdx)->obd_stats->ls_num);     \
-		lprocfs_counter_incr((obdx)->obd_stats, coffset); \
-	}
-
-#define EXP_COUNTER_INCREMENT(export, op)				    \
-	if ((export)->exp_obd->obd_stats != NULL) {			  \
-		unsigned int coffset;					\
-		coffset = (unsigned int)((export)->exp_obd->obd_cntr_base) + \
-			OBD_COUNTER_OFFSET(op);			      \
-		LASSERT(coffset < (export)->exp_obd->obd_stats->ls_num);     \
-		lprocfs_counter_incr((export)->exp_obd->obd_stats, coffset); \
-		if ((export)->exp_nid_stats != NULL &&		       \
-		    (export)->exp_nid_stats->nid_stats != NULL)	      \
-			lprocfs_counter_incr(				\
-				(export)->exp_nid_stats->nid_stats, coffset);\
-	}
-
-#define MD_COUNTER_OFFSET(op)				   \
-	((offsetof(struct md_ops, m_ ## op) -		   \
-	  offsetof(struct md_ops, m_getstatus))		 \
-	 / sizeof(((struct md_ops *)(0))->m_getstatus))
-
-#define MD_COUNTER_INCREMENT(obdx, op)			   \
-	if ((obd)->md_stats != NULL) {			   \
-		unsigned int coffset;			    \
-		coffset = (unsigned int)((obdx)->md_cntr_base) + \
-			MD_COUNTER_OFFSET(op);		   \
-		LASSERT(coffset < (obdx)->md_stats->ls_num);     \
-		lprocfs_counter_incr((obdx)->md_stats, coffset); \
-	}
-
-#define EXP_MD_COUNTER_INCREMENT(export, op)				 \
-	if ((export)->exp_obd->obd_stats != NULL) {			  \
-		unsigned int coffset;					\
-		coffset = (unsigned int)((export)->exp_obd->md_cntr_base) +  \
-			MD_COUNTER_OFFSET(op);			       \
-		LASSERT(coffset < (export)->exp_obd->md_stats->ls_num);      \
-		lprocfs_counter_incr((export)->exp_obd->md_stats, coffset);  \
-		if ((export)->exp_md_stats != NULL)			  \
-			lprocfs_counter_incr(				\
-				(export)->exp_md_stats, coffset);	    \
-	}
+#define OBD_COUNTER_OFFSET(op)						       \
+	((offsetof(struct obd_ops, o_ ## op) -				       \
+	  offsetof(struct obd_ops, o_iocontrol))			       \
+	 / sizeof(((struct obd_ops *)NULL)->o_iocontrol))
+
+/* The '- 1' below is for o_owner. */
+#define NUM_OBD_STATS							       \
+	(sizeof(struct obd_ops) /					       \
+	 sizeof(((struct obd_ops *)NULL)->o_iocontrol) - 1)
+
+#define OBD_COUNTER_INCREMENT(obd, op)					       \
+	lprocfs_counter_incr((obd)->obd_stats,				       \
+			     (obd)->obd_cntr_base + OBD_COUNTER_OFFSET(op))
+
+#define EXP_COUNTER_INCREMENT(exp, op)					       \
+	do {								       \
+		unsigned int _off;					       \
+		_off = (exp)->exp_obd->obd_cntr_base + OBD_COUNTER_OFFSET(op); \
+		lprocfs_counter_incr((exp)->exp_obd->obd_stats, _off);	       \
+		if ((exp)->exp_obd->obd_uses_nid_stats &&		       \
+		    (exp)->exp_nid_stats != NULL)			       \
+			lprocfs_counter_incr((exp)->exp_nid_stats->nid_stats,  \
+					     _off);			       \
+	} while (0)
+
+#define _MD_COUNTER_OFFSET(m_op)					       \
+	((offsetof(struct md_ops, m_op) -				       \
+	  offsetof(struct md_ops, MD_STATS_FIRST_OP)) /			       \
+	 sizeof(((struct md_ops *)NULL)->MD_STATS_FIRST_OP))
+
+#define MD_COUNTER_OFFSET(op) _MD_COUNTER_OFFSET(m_ ## op)
+
+#define NUM_MD_STATS							       \
+	(_MD_COUNTER_OFFSET(MD_STATS_LAST_OP) -				       \
+	 _MD_COUNTER_OFFSET(MD_STATS_FIRST_OP) + 1)
+
+/* Note that we only increment md counters for ops whose offset is less
+ * than NUM_MD_STATS. This is explained in a comment in the definition
+ * of struct md_ops. */
+#define EXP_MD_COUNTER_INCREMENT(exp, op)				       \
+	do {								       \
+		if (MD_COUNTER_OFFSET(op) < NUM_MD_STATS)		       \
+			lprocfs_counter_incr((exp)->exp_obd->obd_md_stats,     \
+					(exp)->exp_obd->obd_md_cntr_base +     \
+					MD_COUNTER_OFFSET(op));	               \
+	} while (0)
 
 #else
 #define OBD_COUNTER_OFFSET(op)
 #define OBD_COUNTER_INCREMENT(obd, op)
 #define EXP_COUNTER_INCREMENT(exp, op)
-#define MD_COUNTER_INCREMENT(obd, op)
 #define EXP_MD_COUNTER_INCREMENT(exp, op)
 #endif
 
@@ -423,16 +416,6 @@ static inline int lprocfs_nid_ldlm_stats_init(struct nid_stat* tmp)
 				      tmp->nid_ldlm_stats);
 }
 
-#define OBD_CHECK_MD_OP(obd, op, err)			   \
-do {							    \
-	if (!OBT(obd) || !MDP((obd), op)) {		     \
-		if (err)					\
-			CERROR("md_" #op ": dev %s/%d no operation\n", \
-			       obd->obd_name, obd->obd_minor);  \
-		return err;				    \
-	}						       \
-} while (0)
-
 #define EXP_CHECK_MD_OP(exp, op)				\
 do {							    \
 	if ((exp) == NULL) {				    \
@@ -1908,14 +1891,14 @@ static inline int md_setattr(struct obd_export *exp, struct md_op_data *op_data,
 	return rc;
 }
 
-static inline int md_sync(struct obd_export *exp, const struct lu_fid *fid,
-			  struct obd_capa *oc, struct ptlrpc_request **request)
+static inline int md_fsync(struct obd_export *exp, const struct lu_fid *fid,
+			   struct obd_capa *oc, struct ptlrpc_request **request)
 {
 	int rc;
 
-	EXP_CHECK_MD_OP(exp, sync);
-	EXP_MD_COUNTER_INCREMENT(exp, sync);
-	rc = MDP(exp->exp_obd, sync)(exp, fid, oc, request);
+	EXP_CHECK_MD_OP(exp, fsync);
+	EXP_MD_COUNTER_INCREMENT(exp, fsync);
+	rc = MDP(exp->exp_obd, fsync)(exp, fid, oc, request);
 	return rc;
 }
 
diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index 9fa2cd6..60b3197 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -2692,8 +2692,8 @@ int ll_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 	}
 
 	oc = ll_mdscapa_get(inode);
-	err = md_sync(ll_i2sbi(inode)->ll_md_exp, ll_inode2fid(inode), oc,
-		      &req);
+	err = md_fsync(ll_i2sbi(inode)->ll_md_exp, ll_inode2fid(inode), oc,
+		       &req);
 	capa_put(oc);
 	if (!rc)
 		rc = err;
diff --git a/drivers/staging/lustre/lustre/lmv/lmv_obd.c b/drivers/staging/lustre/lustre/lmv/lmv_obd.c
index d3e7d6b..2a1d6e0 100644
--- a/drivers/staging/lustre/lustre/lmv/lmv_obd.c
+++ b/drivers/staging/lustre/lustre/lmv/lmv_obd.c
@@ -1338,6 +1338,7 @@ static int lmv_setup(struct obd_device *obd, struct lustre_cfg *lcfg)
 	lprocfs_lmv_init_vars(&lvars);
 
 	lprocfs_obd_setup(obd, lvars.obd_vars);
+	lprocfs_alloc_md_stats(obd, 0);
 #ifdef LPROCFS
 	{
 		rc = lprocfs_seq_create(obd->obd_proc_entry, "target_obd",
@@ -2035,23 +2036,24 @@ static int lmv_setattr(struct obd_export *exp, struct md_op_data *op_data,
 	return rc;
 }
 
-static int lmv_sync(struct obd_export *exp, const struct lu_fid *fid,
-		    struct obd_capa *oc, struct ptlrpc_request **request)
+static int lmv_fsync(struct obd_export *exp, const struct lu_fid *fid,
+		     struct obd_capa *oc, struct ptlrpc_request **request)
 {
-	struct obd_device	 *obd = exp->exp_obd;
-	struct lmv_obd	    *lmv = &obd->u.lmv;
-	struct lmv_tgt_desc       *tgt;
-	int			rc;
+	struct obd_device	*obd = exp->exp_obd;
+	struct lmv_obd		*lmv = &obd->u.lmv;
+	struct lmv_tgt_desc	*tgt;
+	int			 rc;
+
 
 	rc = lmv_check_connect(obd);
-	if (rc)
+	if (rc != 0)
 		return rc;
 
 	tgt = lmv_find_target(lmv, fid);
 	if (IS_ERR(tgt))
 		return PTR_ERR(tgt);
 
-	rc = md_sync(tgt->ltd_exp, fid, oc, request);
+	rc = md_fsync(tgt->ltd_exp, fid, oc, request);
 	return rc;
 }
 
@@ -2298,6 +2300,7 @@ static int lmv_precleanup(struct obd_device *obd, enum obd_cleanup_stage stage)
 	case OBD_CLEANUP_EXPORTS:
 		fld_client_proc_fini(&lmv->lmv_fld);
 		lprocfs_obd_cleanup(obd);
+		lprocfs_free_md_stats(obd);
 		break;
 	default:
 		break;
@@ -2828,7 +2831,7 @@ struct md_ops lmv_md_ops = {
 	.m_rename	       = lmv_rename,
 	.m_setattr	      = lmv_setattr,
 	.m_setxattr	     = lmv_setxattr,
-	.m_sync		 = lmv_sync,
+	.m_fsync		= lmv_fsync,
 	.m_readpage	     = lmv_readpage,
 	.m_unlink	       = lmv_unlink,
 	.m_init_ea_size	 = lmv_init_ea_size,
diff --git a/drivers/staging/lustre/lustre/lvfs/lvfs_lib.c b/drivers/staging/lustre/lustre/lvfs/lvfs_lib.c
index b21e40c..7579fa8 100644
--- a/drivers/staging/lustre/lustre/lvfs/lvfs_lib.c
+++ b/drivers/staging/lustre/lustre/lvfs/lvfs_lib.c
@@ -54,6 +54,9 @@ void lprocfs_counter_add(struct lprocfs_stats *stats, int idx, long amount)
 	if (stats == NULL)
 		return;
 
+	LASSERTF(0 <= idx && idx < stats->ls_num,
+		 "idx %d, ls_num %hu\n", idx, stats->ls_num);
+
 	/* With per-client stats, statistics are allocated only for
 	 * single CPU area, so the smp_id should be 0 always. */
 	smp_id = lprocfs_stats_lock(stats, LPROCFS_GET_SMP_ID, &flags);
@@ -102,6 +105,9 @@ void lprocfs_counter_sub(struct lprocfs_stats *stats, int idx, long amount)
 	if (stats == NULL)
 		return;
 
+	LASSERTF(0 <= idx && idx < stats->ls_num,
+		 "idx %d, ls_num %hu\n", idx, stats->ls_num);
+
 	/* With per-client stats, statistics are allocated only for
 	 * single CPU area, so the smp_id should be 0 always. */
 	smp_id = lprocfs_stats_lock(stats, LPROCFS_GET_SMP_ID, &flags);
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_request.c b/drivers/staging/lustre/lustre/mdc/mdc_request.c
index eb3b44f..4c30fa8 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_request.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_request.c
@@ -2233,8 +2233,8 @@ static int mdc_unpin(struct obd_export *exp, struct obd_client_handle *handle,
 	return rc;
 }
 
-int mdc_sync(struct obd_export *exp, const struct lu_fid *fid,
-	     struct obd_capa *oc, struct ptlrpc_request **request)
+int mdc_fsync(struct obd_export *exp, const struct lu_fid *fid,
+	      struct obd_capa *oc, struct ptlrpc_request **request)
 {
 	struct ptlrpc_request *req;
 	int		    rc;
@@ -2385,6 +2385,7 @@ static int mdc_setup(struct obd_device *obd, struct lustre_cfg *cfg)
 		GOTO(err_close_lock, rc);
 	lprocfs_mdc_init_vars(&lvars);
 	lprocfs_obd_setup(obd, lvars.obd_vars);
+	lprocfs_alloc_md_stats(obd, 0);
 	sptlrpc_lprocfs_cliobd_attach(obd);
 	ptlrpc_lprocfs_register_obd(obd);
 
@@ -2445,6 +2446,7 @@ static int mdc_precleanup(struct obd_device *obd, enum obd_cleanup_stage stage)
 		obd_cleanup_client_import(obd);
 		ptlrpc_lprocfs_unregister_obd(obd);
 		lprocfs_obd_cleanup(obd);
+		lprocfs_free_md_stats(obd);
 
 		rc = obd_llog_finish(obd, 0);
 		if (rc != 0)
@@ -2651,7 +2653,7 @@ struct md_ops mdc_md_ops = {
 	.m_setattr	  = mdc_setattr,
 	.m_setxattr	 = mdc_setxattr,
 	.m_getxattr	 = mdc_getxattr,
-	.m_sync	     = mdc_sync,
+	.m_fsync	    = mdc_fsync,
 	.m_readpage	 = mdc_readpage,
 	.m_unlink	   = mdc_unlink,
 	.m_cancel_unused    = mdc_cancel_unused,
diff --git a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
index 3329055..8f91ab9 100644
--- a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
+++ b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
@@ -1253,6 +1253,8 @@ void lprocfs_init_ops_stats(int num_private_stats, struct lprocfs_stats *stats)
 	LPROCFS_OBD_OP_INIT(num_private_stats, stats, pool_del);
 	LPROCFS_OBD_OP_INIT(num_private_stats, stats, getref);
 	LPROCFS_OBD_OP_INIT(num_private_stats, stats, putref);
+
+	CLASSERT(NUM_OBD_STATS == OBD_COUNTER_OFFSET(putref) + 1);
 }
 EXPORT_SYMBOL(lprocfs_init_ops_stats);
 
@@ -1266,8 +1268,7 @@ int lprocfs_alloc_obd_stats(struct obd_device *obd, unsigned num_private_stats)
 	LASSERT(obd->obd_proc_entry != NULL);
 	LASSERT(obd->obd_cntr_base == 0);
 
-	num_stats = ((int)sizeof(*obd->obd_type->typ_dt_ops) / sizeof(void *)) +
-		num_private_stats - 1 /* o_owner */;
+	num_stats = NUM_OBD_STATS + num_private_stats;
 	stats = lprocfs_alloc_stats(num_stats, 0);
 	if (stats == NULL)
 		return -ENOMEM;
@@ -1302,12 +1303,18 @@ void lprocfs_free_obd_stats(struct obd_device *obd)
 }
 EXPORT_SYMBOL(lprocfs_free_obd_stats);
 
-#define LPROCFS_MD_OP_INIT(base, stats, op)			     \
-do {								    \
-	unsigned int coffset = base + MD_COUNTER_OFFSET(op);	    \
-	LASSERT(coffset < stats->ls_num);			       \
-	lprocfs_counter_init(stats, coffset, 0, #op, "reqs");	   \
-} while (0)
+/* Note that we only init md counters for ops whose offset is less
+ * than NUM_MD_STATS. This is explained in a comment in the definition
+ * of struct md_ops. */
+#define LPROCFS_MD_OP_INIT(base, stats, op)				       \
+	do {								       \
+		unsigned int _idx = base + MD_COUNTER_OFFSET(op);	       \
+									       \
+		if (MD_COUNTER_OFFSET(op) < NUM_MD_STATS) {		       \
+			LASSERT(_idx < stats->ls_num);			       \
+			lprocfs_counter_init(stats, _idx, 0, #op, "reqs");     \
+		}							       \
+	} while (0)
 
 void lprocfs_init_mps_stats(int num_private_stats, struct lprocfs_stats *stats)
 {
@@ -1325,7 +1332,7 @@ void lprocfs_init_mps_stats(int num_private_stats, struct lprocfs_stats *stats)
 	LPROCFS_MD_OP_INIT(num_private_stats, stats, rename);
 	LPROCFS_MD_OP_INIT(num_private_stats, stats, is_subdir);
 	LPROCFS_MD_OP_INIT(num_private_stats, stats, setattr);
-	LPROCFS_MD_OP_INIT(num_private_stats, stats, sync);
+	LPROCFS_MD_OP_INIT(num_private_stats, stats, fsync);
 	LPROCFS_MD_OP_INIT(num_private_stats, stats, readpage);
 	LPROCFS_MD_OP_INIT(num_private_stats, stats, unlink);
 	LPROCFS_MD_OP_INIT(num_private_stats, stats, setxattr);
@@ -1347,18 +1354,29 @@ void lprocfs_init_mps_stats(int num_private_stats, struct lprocfs_stats *stats)
 EXPORT_SYMBOL(lprocfs_init_mps_stats);
 
 int lprocfs_alloc_md_stats(struct obd_device *obd,
-			   unsigned num_private_stats)
+			   unsigned int num_private_stats)
 {
 	struct lprocfs_stats *stats;
 	unsigned int num_stats;
 	int rc, i;
 
-	LASSERT(obd->md_stats == NULL);
+	CLASSERT(offsetof(struct md_ops, MD_STATS_FIRST_OP) == 0);
+	CLASSERT(_MD_COUNTER_OFFSET(MD_STATS_FIRST_OP) == 0);
+	CLASSERT(_MD_COUNTER_OFFSET(MD_STATS_LAST_OP) > 0);
+
+	/* TODO Ensure that this function is only used where
+	 * appropriate by adding an assertion to the effect that
+	 * obd->obd_type->typ_md_ops is not NULL. We can't do this now
+	 * because mdt_procfs_init() uses this function to allocate
+	 * the stats backing /proc/fs/lustre/mdt/.../md_stats but the
+	 * mdt layer does not use the md_ops interface. This is
+	 * confusing and a waste of memory. See LU-2484.
+	 */
 	LASSERT(obd->obd_proc_entry != NULL);
-	LASSERT(obd->md_cntr_base == 0);
+	LASSERT(obd->obd_md_stats == NULL);
+	LASSERT(obd->obd_md_cntr_base == 0);
 
-	num_stats = 1 + MD_COUNTER_OFFSET(revalidate_lock) +
-		    num_private_stats;
+	num_stats = NUM_MD_STATS + num_private_stats;
 	stats = lprocfs_alloc_stats(num_stats, 0);
 	if (stats == NULL)
 		return -ENOMEM;
@@ -1373,24 +1391,26 @@ int lprocfs_alloc_md_stats(struct obd_device *obd,
 			LBUG();
 		}
 	}
+
 	rc = lprocfs_register_stats(obd->obd_proc_entry, "md_stats", stats);
 	if (rc < 0) {
 		lprocfs_free_stats(&stats);
 	} else {
-		obd->md_stats  = stats;
-		obd->md_cntr_base = num_private_stats;
+		obd->obd_md_stats = stats;
+		obd->obd_md_cntr_base = num_private_stats;
 	}
+
 	return rc;
 }
 EXPORT_SYMBOL(lprocfs_alloc_md_stats);
 
 void lprocfs_free_md_stats(struct obd_device *obd)
 {
-	struct lprocfs_stats *stats = obd->md_stats;
+	struct lprocfs_stats *stats = obd->obd_md_stats;
 
 	if (stats != NULL) {
-		obd->md_stats = NULL;
-		obd->md_cntr_base = 0;
+		obd->obd_md_stats = NULL;
+		obd->obd_md_cntr_base = 0;
 		lprocfs_free_stats(&stats);
 	}
 }
-- 
1.7.9.5

