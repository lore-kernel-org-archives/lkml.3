Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933017Ab3GVQM6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:12:58 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:45630 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932978Ab3GVQMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:12:50 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Liu Xuezhao <xuezhao.liu@emc.com>,
        "John L. Hammond" <john.hammond@intel.com>,
        Peng Tao <tao.peng@emc.com>, Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 36/48] staging/lustre/obdclass: add obd_target.h
Date: Tue, 23 Jul 2013 00:06:57 +0800
Message-Id: <1374509230-3324-37-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
References: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Xuezhao <xuezhao.liu@emc.com>

Move some server-side data structures form obd.h to obd_target.h.  To
remove some code dependencies use HAVE_SERVER_SUPPORT to protect some
llog/fsfilt_* functions.

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-1330
Lustre-change: http://review.whamcloud.com/2678
Signed-off-by: Liu Xuezhao <xuezhao.liu@emc.com>
Signed-off-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: Peng Tao <bergwolf@gmail.com>
Reviewed-by: Mike Pershin <mike.pershin@intel.com>
Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../lustre/lustre/include/linux/lustre_fsfilt.h    |   10 -
 .../staging/lustre/lustre/include/lprocfs_status.h |   36 --
 drivers/staging/lustre/lustre/include/obd.h        |  140 +----
 drivers/staging/lustre/lustre/lvfs/lvfs_linux.c    |    1 -
 drivers/staging/lustre/lustre/obdclass/Makefile    |    2 +-
 .../lustre/lustre/obdclass/lprocfs_jobstats.c      |  560 --------------------
 drivers/staging/lustre/lustre/obdclass/obd_mount.c |    1 -
 7 files changed, 3 insertions(+), 747 deletions(-)
 delete mode 100644 drivers/staging/lustre/lustre/obdclass/lprocfs_jobstats.c

diff --git a/drivers/staging/lustre/lustre/include/linux/lustre_fsfilt.h b/drivers/staging/lustre/lustre/include/linux/lustre_fsfilt.h
index 6c72609..e637006 100644
--- a/drivers/staging/lustre/lustre/include/linux/lustre_fsfilt.h
+++ b/drivers/staging/lustre/lustre/include/linux/lustre_fsfilt.h
@@ -145,16 +145,6 @@ static inline int fsfilt_commit(struct obd_device *obd, struct inode *inode,
 	return rc;
 }
 
-static inline int fsfilt_map_inode_pages(struct obd_device *obd,
-					 struct inode *inode,
-					 struct page **page, int pages,
-					 unsigned long *blocks,
-					 int create, struct mutex *mutex)
-{
-	return obd->obd_fsops->fs_map_inode_pages(inode, page, pages, blocks,
-						  create, mutex);
-}
-
 static inline int fsfilt_read_record(struct obd_device *obd, struct file *file,
 				     void *buf, loff_t size, loff_t *offs)
 {
diff --git a/drivers/staging/lustre/lustre/include/lprocfs_status.h b/drivers/staging/lustre/lustre/include/lprocfs_status.h
index 294fb78..20633d4 100644
--- a/drivers/staging/lustre/lustre/include/lprocfs_status.h
+++ b/drivers/staging/lustre/lustre/include/lprocfs_status.h
@@ -370,18 +370,6 @@ static inline void s2dhms(struct dhms *ts, time_t secs)
 #define JOBSTATS_DISABLE		"disable"
 #define JOBSTATS_PROCNAME_UID		"procname_uid"
 
-typedef void (*cntr_init_callback)(struct lprocfs_stats *stats);
-
-struct obd_job_stats {
-	cfs_hash_t	*ojs_hash;
-	struct list_head	 ojs_list;
-	rwlock_t       ojs_lock; /* protect the obj_list */
-	cntr_init_callback ojs_cntr_init_fn;
-	int		ojs_cntr_num;
-	int		ojs_cleanup_interval;
-	time_t		   ojs_last_cleanup;
-};
-
 #ifdef LPROCFS
 
 extern int lprocfs_stats_alloc_one(struct lprocfs_stats *stats,
@@ -748,16 +736,6 @@ struct file_operations name##_fops = {				     \
 		.release = lprocfs_single_release,			\
 	};
 
-/* lprocfs_jobstats.c */
-int lprocfs_job_stats_log(struct obd_device *obd, char *jobid,
-			  int event, long amount);
-void lprocfs_job_stats_fini(struct obd_device *obd);
-int lprocfs_job_stats_init(struct obd_device *obd, int cntr_num,
-			   cntr_init_callback fn);
-int lprocfs_rd_job_interval(struct seq_file *m, void *data);
-int lprocfs_wr_job_interval(struct file *file, const char *buffer,
-			    unsigned long count, void *data);
-
 /* lproc_ptlrpc.c */
 struct ptlrpc_request;
 extern void target_print_req(void *seq_file, struct ptlrpc_request *req);
@@ -1021,20 +999,6 @@ __u64 lprocfs_stats_collector(struct lprocfs_stats *stats, int idx,
 #define LPROC_SEQ_FOPS_RW_TYPE(name, type)
 #define LPROC_SEQ_FOPS_WR_ONLY(name, type)
 
-/* lprocfs_jobstats.c */
-static inline
-int lprocfs_job_stats_log(struct obd_device *obd, char *jobid, int event,
-			  long amount)
-{ return 0; }
-static inline
-void lprocfs_job_stats_fini(struct obd_device *obd)
-{ return; }
-static inline
-int lprocfs_job_stats_init(struct obd_device *obd, int cntr_num,
-			   cntr_init_callback fn)
-{ return 0; }
-
-
 /* lproc_ptlrpc.c */
 #define target_print_req NULL
 
diff --git a/drivers/staging/lustre/lustre/include/obd.h b/drivers/staging/lustre/lustre/include/obd.h
index fbf997f..be3a08f 100644
--- a/drivers/staging/lustre/lustre/include/obd.h
+++ b/drivers/staging/lustre/lustre/include/obd.h
@@ -49,6 +49,8 @@
 #define IOC_MDC_MAX_NR       50
 
 #include <lustre/lustre_idl.h>
+#include <lustre_lib.h>
+#include <linux/libcfs/bitmap.h>
 #include <lu_ref.h>
 #include <lustre_lib.h>
 #include <lustre_export.h>
@@ -56,9 +58,6 @@
 #include <lustre_fld.h>
 #include <lustre_capa.h>
 
-#include <linux/libcfs/bitmap.h>
-
-
 #define MAX_OBD_DEVICES 8192
 
 struct osc_async_rc {
@@ -254,30 +253,6 @@ struct brw_page {
 	obd_flag flag;
 };
 
-/* Individual type definitions */
-
-struct ost_server_data;
-
-struct osd_properties {
-	size_t osd_max_ea_size;
-};
-
-#define OBT_MAGIC       0xBDDECEAE
-/* hold common fields for "target" device */
-struct obd_device_target {
-	__u32		     obt_magic;
-	__u32		     obt_instance;
-	struct super_block       *obt_sb;
-	/** last_rcvd file */
-	struct file	      *obt_rcvd_filp;
-	__u64		     obt_mount_count;
-	struct rw_semaphore	  obt_rwsem;
-	struct vfsmount	  *obt_vfsmnt;
-	struct file	      *obt_health_check_filp;
-	struct osd_properties     obt_osd_properties;
-	struct obd_job_stats      obt_jobstats;
-};
-
 /* llog contexts */
 enum llog_ctxt_id {
 	LLOG_CONFIG_ORIG_CTXT  =  0,
@@ -298,94 +273,6 @@ enum llog_ctxt_id {
 	LLOG_MAX_CTXTS
 };
 
-#define FILTER_SUBDIR_COUNT      32	    /* set to zero for no subdirs */
-
-struct filter_subdirs {
-	struct dentry *dentry[FILTER_SUBDIR_COUNT];
-};
-
-
-struct filter_ext {
-	__u64		fe_start;
-	__u64		fe_end;
-};
-
-struct filter_obd {
-	/* NB this field MUST be first */
-	struct obd_device_target fo_obt;
-	const char		*fo_fstype;
-
-	int			fo_group_count;
-	struct dentry		*fo_dentry_O;
-	struct dentry		**fo_dentry_O_groups;
-	struct filter_subdirs	*fo_dentry_O_sub;
-	struct mutex		fo_init_lock;	/* group initialization lock*/
-	int			fo_committed_group;
-
-	spinlock_t		fo_objidlock;	/* protect fo_lastobjid */
-
-	unsigned long		fo_destroys_in_progress;
-	struct mutex		fo_create_locks[FILTER_SUBDIR_COUNT];
-
-	struct list_head fo_export_list;
-	int		  fo_subdir_count;
-
-	obd_size	     fo_tot_dirty;      /* protected by obd_osfs_lock */
-	obd_size	     fo_tot_granted;    /* all values in bytes */
-	obd_size	     fo_tot_pending;
-	int		  fo_tot_granted_clients;
-
-	obd_size	     fo_readcache_max_filesize;
-	spinlock_t		fo_flags_lock;
-	unsigned int	 fo_read_cache:1,   /**< enable read-only cache */
-			     fo_writethrough_cache:1,/**< read cache writes */
-			     fo_mds_ost_sync:1, /**< MDS-OST orphan recovery*/
-			     fo_raid_degraded:1;/**< RAID device degraded */
-
-	struct obd_import   *fo_mdc_imp;
-	struct obd_uuid      fo_mdc_uuid;
-	struct lustre_handle fo_mdc_conn;
-	struct file	**fo_last_objid_files;
-	__u64	       *fo_last_objids; /* last created objid for groups,
-					      * protected by fo_objidlock */
-
-	struct mutex		fo_alloc_lock;
-
-	atomic_t	 fo_r_in_flight;
-	atomic_t	 fo_w_in_flight;
-
-	/*
-	 * per-filter pool of kiobuf's allocated by filter_common_setup() and
-	 * torn down by filter_cleanup().
-	 *
-	 * This pool contains kiobuf used by
-	 * filter_{prep,commit}rw_{read,write}() and is shared by all OST
-	 * threads.
-	 *
-	 * Locking: protected by internal lock of cfs_hash, pool can be
-	 * found from this hash table by t_id of ptlrpc_thread.
-	 */
-	struct cfs_hash		*fo_iobuf_hash;
-
-	struct brw_stats	 fo_filter_stats;
-
-	int		      fo_fmd_max_num; /* per exp filter_mod_data */
-	int		      fo_fmd_max_age; /* jiffies to fmd expiry */
-	unsigned long	    fo_syncjournal:1, /* sync journal on writes */
-				 fo_sync_lock_cancel:2;/* sync on lock cancel */
-
-
-	/* sptlrpc stuff */
-	rwlock_t		fo_sptlrpc_lock;
-	struct sptlrpc_rule_set  fo_sptlrpc_rset;
-
-	/* capability related */
-	unsigned int	     fo_fl_oss_capa;
-	struct list_head	       fo_capa_keys;
-	struct hlist_head	*fo_capa_hash;
-	int		      fo_sec_level;
-};
-
 struct timeout_item {
 	enum timeout_event ti_event;
 	cfs_time_t	 ti_timeout;
@@ -551,25 +438,6 @@ struct obd_id_info {
 	obd_id  *data;
 };
 
-/* */
-
-struct echo_obd {
-	struct obd_device_target eo_obt;
-	struct obdo		eo_oa;
-	spinlock_t		 eo_lock;
-	__u64			 eo_lastino;
-	struct lustre_handle	eo_nl_lock;
-	atomic_t		eo_prep;
-};
-
-struct ost_obd {
-	struct ptlrpc_service	*ost_service;
-	struct ptlrpc_service	*ost_create_service;
-	struct ptlrpc_service	*ost_io_service;
-	struct ptlrpc_service	*ost_seq_service;
-	struct mutex		ost_health_mutex;
-};
-
 struct echo_client_obd {
 	struct obd_export	*ec_exp;   /* the local connection to osc/lov */
 	spinlock_t		ec_lock;
@@ -1051,12 +919,8 @@ struct obd_device {
 	int			      obd_recovery_stage;
 
 	union {
-		struct obd_device_target obt;
-		struct filter_obd filter;
 		struct client_obd cli;
-		struct ost_obd ost;
 		struct echo_client_obd echo_client;
-		struct echo_obd echo;
 		struct lov_obd lov;
 		struct lmv_obd lmv;
 	} u;
diff --git a/drivers/staging/lustre/lustre/lvfs/lvfs_linux.c b/drivers/staging/lustre/lustre/lvfs/lvfs_linux.c
index e70d8fe..8bfae01 100644
--- a/drivers/staging/lustre/lustre/lvfs/lvfs_linux.c
+++ b/drivers/staging/lustre/lustre/lvfs/lvfs_linux.c
@@ -48,7 +48,6 @@
 #include <linux/quotaops.h>
 #include <linux/version.h>
 #include <linux/libcfs/libcfs.h>
-#include <lustre_fsfilt.h>
 #include <obd.h>
 #include <linux/module.h>
 #include <linux/init.h>
diff --git a/drivers/staging/lustre/lustre/obdclass/Makefile b/drivers/staging/lustre/lustre/obdclass/Makefile
index 9930a9e..023e94f 100644
--- a/drivers/staging/lustre/lustre/obdclass/Makefile
+++ b/drivers/staging/lustre/lustre/obdclass/Makefile
@@ -3,7 +3,7 @@ obj-$(CONFIG_LUSTRE_FS) += obdclass.o llog_test.o
 obdclass-y := linux/linux-module.o linux/linux-obdo.o linux/linux-sysctl.o \
 	      llog.o llog_cat.o llog_obd.o llog_swab.o class_obd.o debug.o \
 	      genops.o uuid.o llog_ioctl.o lprocfs_status.o		   \
-	      lprocfs_jobstats.o lustre_handles.o lustre_peer.o llog_osd.o \
+	      lustre_handles.o lustre_peer.o llog_osd.o \
 	      local_storage.o statfs_pack.o obdo.o obd_config.o obd_mount.o\
 	      mea.o lu_object.o dt_object.o capa.o cl_object.o   \
 	      cl_page.o cl_lock.o cl_io.o acl.o idmap.o	lu_ucred.o
diff --git a/drivers/staging/lustre/lustre/obdclass/lprocfs_jobstats.c b/drivers/staging/lustre/lustre/obdclass/lprocfs_jobstats.c
deleted file mode 100644
index 7f6072c..0000000
--- a/drivers/staging/lustre/lustre/obdclass/lprocfs_jobstats.c
+++ /dev/null
@@ -1,560 +0,0 @@
-/* GPL HEADER START
- *
- * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 only,
- * as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License version 2 for more details (a copy is included
- * in the LICENSE file that accompanied this code).
- *
- * You should have received a copy of the GNU General Public License
- * version 2 along with this program; If not, see
- * http://www.sun.com/software/products/lustre/docs/GPLv2.pdf
- *
- * GPL HEADER END
- */
-/*
- * Copyright (c) 2011, 2012, Intel Corporation.
- * Use is subject to license terms.
- *
- * Author: Niu Yawei <niu@whamcloud.com>
- */
-/*
- * lustre/obdclass/lprocfs_jobstats.c
- */
-
-#ifndef EXPORT_SYMTAB
-# define EXPORT_SYMTAB
-#endif
-#define DEBUG_SUBSYSTEM S_CLASS
-
-
-#include <obd_class.h>
-#include <lprocfs_status.h>
-#include <lustre/lustre_idl.h>
-
-#if defined(LPROCFS)
-
-/*
- * JobID formats & JobID environment variable names for supported
- * job schedulers:
- *
- * SLURM:
- *   JobID format:  32 bit integer.
- *   JobID env var: SLURM_JOB_ID.
- * SGE:
- *   JobID format:  Decimal integer range to 99999.
- *   JobID env var: JOB_ID.
- * LSF:
- *   JobID format:  6 digit integer by default (up to 999999), can be
- *		  increased to 10 digit (up to 2147483646).
- *   JobID env var: LSB_JOBID.
- * Loadleveler:
- *   JobID format:  String of machine_name.cluster_id.process_id, for
- *		  example: fr2n02.32.0
- *   JobID env var: LOADL_STEP_ID.
- * PBS:
- *   JobID format:  String of sequence_number[.server_name][@server].
- *   JobID env var: PBS_JOBID.
- * Maui/MOAB:
- *   JobID format:  Same as PBS.
- *   JobID env var: Same as PBS.
- */
-
-struct job_stat {
-	struct hlist_node      js_hash;
-	struct list_head	    js_list;
-	atomic_t	  js_refcount;
-	char		  js_jobid[JOBSTATS_JOBID_SIZE];
-	time_t		js_timestamp; /* seconds */
-	struct lprocfs_stats *js_stats;
-	struct obd_job_stats *js_jobstats;
-};
-
-static unsigned job_stat_hash(cfs_hash_t *hs, const void *key, unsigned mask)
-{
-	return cfs_hash_djb2_hash(key, strlen(key), mask);
-}
-
-static void *job_stat_key(struct hlist_node *hnode)
-{
-	struct job_stat *job;
-	job = hlist_entry(hnode, struct job_stat, js_hash);
-	return job->js_jobid;
-}
-
-static int job_stat_keycmp(const void *key, struct hlist_node *hnode)
-{
-	struct job_stat *job;
-	job = hlist_entry(hnode, struct job_stat, js_hash);
-	return (strlen(job->js_jobid) == strlen(key)) &&
-	       !strncmp(job->js_jobid, key, strlen(key));
-}
-
-static void *job_stat_object(struct hlist_node *hnode)
-{
-	return hlist_entry(hnode, struct job_stat, js_hash);
-}
-
-static void job_stat_get(cfs_hash_t *hs, struct hlist_node *hnode)
-{
-	struct job_stat *job;
-	job = hlist_entry(hnode, struct job_stat, js_hash);
-	atomic_inc(&job->js_refcount);
-}
-
-static void job_free(struct job_stat *job)
-{
-	LASSERT(atomic_read(&job->js_refcount) == 0);
-	LASSERT(job->js_jobstats);
-
-	write_lock(&job->js_jobstats->ojs_lock);
-	list_del_init(&job->js_list);
-	write_unlock(&job->js_jobstats->ojs_lock);
-
-	lprocfs_free_stats(&job->js_stats);
-	OBD_FREE_PTR(job);
-}
-
-static void job_putref(struct job_stat *job)
-{
-	LASSERT(atomic_read(&job->js_refcount) > 0);
-	if (atomic_dec_and_test(&job->js_refcount))
-		job_free(job);
-}
-
-static void job_stat_put_locked(cfs_hash_t *hs, struct hlist_node *hnode)
-{
-	struct job_stat *job;
-	job = hlist_entry(hnode, struct job_stat, js_hash);
-	job_putref(job);
-}
-
-static void job_stat_exit(cfs_hash_t *hs, struct hlist_node *hnode)
-{
-	CERROR("Should not have any items!");
-}
-
-static cfs_hash_ops_t job_stats_hash_ops = {
-	.hs_hash       = job_stat_hash,
-	.hs_key	= job_stat_key,
-	.hs_keycmp     = job_stat_keycmp,
-	.hs_object     = job_stat_object,
-	.hs_get	= job_stat_get,
-	.hs_put_locked = job_stat_put_locked,
-	.hs_exit       = job_stat_exit,
-};
-
-static int job_iter_callback(cfs_hash_t *hs, cfs_hash_bd_t *bd,
-			     struct hlist_node *hnode, void *data)
-{
-	time_t oldest = *((time_t *)data);
-	struct job_stat *job;
-
-	job = hlist_entry(hnode, struct job_stat, js_hash);
-	if (!oldest || job->js_timestamp < oldest)
-		cfs_hash_bd_del_locked(hs, bd, hnode);
-
-	return 0;
-}
-
-static void lprocfs_job_cleanup(struct obd_job_stats *stats, bool force)
-{
-	time_t oldest, now;
-
-	if (stats->ojs_cleanup_interval == 0)
-		return;
-
-	now = cfs_time_current_sec();
-	if (!force && now < stats->ojs_last_cleanup +
-			    stats->ojs_cleanup_interval)
-		return;
-
-	oldest = now - stats->ojs_cleanup_interval;
-	cfs_hash_for_each_safe(stats->ojs_hash, job_iter_callback,
-			       &oldest);
-	stats->ojs_last_cleanup = cfs_time_current_sec();
-}
-
-static struct job_stat *job_alloc(char *jobid, struct obd_job_stats *jobs)
-{
-	struct job_stat *job;
-
-	LASSERT(jobs->ojs_cntr_num && jobs->ojs_cntr_init_fn);
-
-	OBD_ALLOC_PTR(job);
-	if (job == NULL)
-		return NULL;
-
-	job->js_stats = lprocfs_alloc_stats(jobs->ojs_cntr_num, 0);
-	if (job->js_stats == NULL) {
-		OBD_FREE_PTR(job);
-		return NULL;
-	}
-
-	jobs->ojs_cntr_init_fn(job->js_stats);
-
-	memcpy(job->js_jobid, jobid, JOBSTATS_JOBID_SIZE);
-	job->js_timestamp = cfs_time_current_sec();
-	job->js_jobstats = jobs;
-	INIT_HLIST_NODE(&job->js_hash);
-	INIT_LIST_HEAD(&job->js_list);
-	atomic_set(&job->js_refcount, 1);
-
-	return job;
-}
-
-int lprocfs_job_stats_log(struct obd_device *obd, char *jobid,
-			  int event, long amount)
-{
-	struct obd_job_stats *stats = &obd->u.obt.obt_jobstats;
-	struct job_stat *job, *job2;
-	ENTRY;
-
-	LASSERT(stats && stats->ojs_hash);
-
-	lprocfs_job_cleanup(stats, false);
-
-	if (!jobid || !strlen(jobid))
-		RETURN(-EINVAL);
-
-	if (strlen(jobid) >= JOBSTATS_JOBID_SIZE) {
-		CERROR("Invalid jobid size (%lu), expect(%d)\n",
-		       (unsigned long)strlen(jobid) + 1, JOBSTATS_JOBID_SIZE);
-		RETURN(-EINVAL);
-	}
-
-	job = cfs_hash_lookup(stats->ojs_hash, jobid);
-	if (job)
-		goto found;
-
-	job = job_alloc(jobid, stats);
-	if (job == NULL)
-		RETURN(-ENOMEM);
-
-	job2 = cfs_hash_findadd_unique(stats->ojs_hash, job->js_jobid,
-				       &job->js_hash);
-	if (job2 != job) {
-		job_putref(job);
-		job = job2;
-		/* We cannot LASSERT(!list_empty(&job->js_list)) here,
-		 * since we just lost the race for inserting "job" into the
-		 * ojs_list, and some other thread is doing it _right_now_.
-		 * Instead, be content the other thread is doing this, since
-		 * "job2" was initialized in job_alloc() already. LU-2163 */
-	} else {
-		LASSERT(list_empty(&job->js_list));
-		write_lock(&stats->ojs_lock);
-		list_add_tail(&job->js_list, &stats->ojs_list);
-		write_unlock(&stats->ojs_lock);
-	}
-
-found:
-	LASSERT(stats == job->js_jobstats);
-	LASSERT(stats->ojs_cntr_num > event);
-	job->js_timestamp = cfs_time_current_sec();
-	lprocfs_counter_add(job->js_stats, event, amount);
-
-	job_putref(job);
-	RETURN(0);
-}
-EXPORT_SYMBOL(lprocfs_job_stats_log);
-
-void lprocfs_job_stats_fini(struct obd_device *obd)
-{
-	struct obd_job_stats *stats = &obd->u.obt.obt_jobstats;
-	time_t oldest = 0;
-
-	if (stats->ojs_hash == NULL)
-		return;
-	cfs_hash_for_each_safe(stats->ojs_hash, job_iter_callback, &oldest);
-	cfs_hash_putref(stats->ojs_hash);
-	stats->ojs_hash = NULL;
-	LASSERT(list_empty(&stats->ojs_list));
-}
-EXPORT_SYMBOL(lprocfs_job_stats_fini);
-
-static void *lprocfs_jobstats_seq_start(struct seq_file *p, loff_t *pos)
-{
-	struct obd_job_stats *stats = p->private;
-	loff_t off = *pos;
-	struct job_stat *job;
-
-	read_lock(&stats->ojs_lock);
-	if (off == 0)
-		return SEQ_START_TOKEN;
-	off--;
-	list_for_each_entry(job, &stats->ojs_list, js_list) {
-		if (!off--)
-			return job;
-	}
-	return NULL;
-}
-
-static void lprocfs_jobstats_seq_stop(struct seq_file *p, void *v)
-{
-	struct obd_job_stats *stats = p->private;
-
-	read_unlock(&stats->ojs_lock);
-}
-
-static void *lprocfs_jobstats_seq_next(struct seq_file *p, void *v, loff_t *pos)
-{
-	struct obd_job_stats *stats = p->private;
-	struct job_stat *job;
-	struct list_head *next;
-
-	++*pos;
-	if (v == SEQ_START_TOKEN) {
-		next = stats->ojs_list.next;
-	} else {
-		job = (struct job_stat *)v;
-		next = job->js_list.next;
-	}
-
-	return next == &stats->ojs_list ? NULL :
-		list_entry(next, struct job_stat, js_list);
-}
-
-/*
- * Example of output on MDT:
- *
- * job_stats:
- * - job_id:	test_id.222.25844
- *   snapshot_time: 1322494486
- *   open:	  { samples:	       3, unit: reqs }
- *   close:	 { samples:	       3, unit: reqs }
- *   mknod:	 { samples:	       0, unit: reqs }
- *   link:	  { samples:	       0, unit: reqs }
- *   unlink:	{ samples:	       0, unit: reqs }
- *   mkdir:	 { samples:	       0, unit: reqs }
- *   rmdir:	 { samples:	       0, unit: reqs }
- *   rename:	{ samples:	       1, unit: reqs }
- *   getattr:       { samples:	       7, unit: reqs }
- *   setattr:       { samples:	       0, unit: reqs }
- *   getxattr:      { samples:	       0, unit: reqs }
- *   setxattr:      { samples:	       0, unit: reqs }
- *   statfs:	{ samples:	       0, unit: reqs }
- *   sync:	  { samples:	       0, unit: reqs }
- *
- * Example of output on OST:
- *
- * job_stats:
- * - job_id	 4854
- *   snapshot_time: 1322494602
- *   read:	  { samples:  0, unit: bytes, min:  0, max:  0, sum:  0 }
- *   write:	 { samples:  1, unit: bytes, min: 10, max: 10, sum: 10 }
- *   setattr:       { samples:  0, unit: reqs }
- *   punch:	 { samples:  0, unit: reqs }
- *   sync:	  { samples:  0, unit: reqs }
- */
-
-static const char spaces[] = "		    ";
-
-static int inline width(const char *str, int len)
-{
-	return len - min((int)strlen(str), 15);
-}
-
-static int lprocfs_jobstats_seq_show(struct seq_file *p, void *v)
-{
-	struct job_stat			*job = v;
-	struct lprocfs_stats		*s;
-	struct lprocfs_counter		ret;
-	struct lprocfs_counter_header	*cntr_header;
-	int				i;
-
-	if (v == SEQ_START_TOKEN) {
-		seq_printf(p, "job_stats:\n");
-		return 0;
-	}
-
-	seq_printf(p, "- %-16s %s\n", "job_id:", job->js_jobid);
-	seq_printf(p, "  %-16s %ld\n", "snapshot_time:", job->js_timestamp);
-
-	s = job->js_stats;
-	for (i = 0; i < s->ls_num; i++) {
-		cntr_header = &s->ls_cnt_header[i];
-		lprocfs_stats_collect(s, i, &ret);
-
-		seq_printf(p, "  %s:%.*s { samples: %11"LPF64"u",
-			   cntr_header->lc_name,
-			   width(cntr_header->lc_name, 15), spaces,
-			   ret.lc_count);
-		if (cntr_header->lc_units[0] != '\0')
-			seq_printf(p, ", unit: %5s", cntr_header->lc_units);
-
-		if (cntr_header->lc_config & LPROCFS_CNTR_AVGMINMAX) {
-			seq_printf(p, ", min:%8"LPF64"u, max:%8"LPF64"u,"
-				   " sum:%16"LPF64"u",
-				   ret.lc_count ? ret.lc_min : 0,
-				   ret.lc_count ? ret.lc_max : 0,
-				   ret.lc_count ? ret.lc_sum : 0);
-		}
-		if (cntr_header->lc_config & LPROCFS_CNTR_STDDEV) {
-			seq_printf(p, ", sumsq: %18"LPF64"u",
-				   ret.lc_count ? ret.lc_sumsquare : 0);
-		}
-
-		seq_printf(p, " }\n");
-
-	}
-	return 0;
-}
-
-struct seq_operations lprocfs_jobstats_seq_sops = {
-	start: lprocfs_jobstats_seq_start,
-	stop:  lprocfs_jobstats_seq_stop,
-	next:  lprocfs_jobstats_seq_next,
-	show:  lprocfs_jobstats_seq_show,
-};
-
-static int lprocfs_jobstats_seq_open(struct inode *inode, struct file *file)
-{
-	struct seq_file *seq;
-	int rc;
-
-	rc = seq_open(file, &lprocfs_jobstats_seq_sops);
-	if (rc)
-		return rc;
-	seq = file->private_data;
-	seq->private = PDE_DATA(inode);
-	return 0;
-}
-
-static ssize_t lprocfs_jobstats_seq_write(struct file *file, const char *buf,
-					  size_t len, loff_t *off)
-{
-	struct seq_file *seq = file->private_data;
-	struct obd_job_stats *stats = seq->private;
-	char jobid[JOBSTATS_JOBID_SIZE];
-	int all = 0;
-	struct job_stat *job;
-
-	if (!memcmp(buf, "clear", strlen("clear"))) {
-		all = 1;
-	} else if (len < JOBSTATS_JOBID_SIZE) {
-		memset(jobid, 0, JOBSTATS_JOBID_SIZE);
-		/* Trim '\n' if any */
-		if (buf[len - 1] == '\n')
-			memcpy(jobid, buf, len - 1);
-		else
-			memcpy(jobid, buf, len);
-	} else {
-		return -EINVAL;
-	}
-
-	LASSERT(stats->ojs_hash);
-	if (all) {
-		time_t oldest = 0;
-		cfs_hash_for_each_safe(stats->ojs_hash, job_iter_callback,
-				       &oldest);
-		return len;
-	}
-
-	if (!strlen(jobid))
-		return -EINVAL;
-
-	job = cfs_hash_lookup(stats->ojs_hash, jobid);
-	if (!job)
-		return -EINVAL;
-
-	cfs_hash_del_key(stats->ojs_hash, jobid);
-
-	job_putref(job);
-	return len;
-}
-
-struct file_operations lprocfs_jobstats_seq_fops = {
-	.owner   = THIS_MODULE,
-	.open    = lprocfs_jobstats_seq_open,
-	.read    = seq_read,
-	.write   = lprocfs_jobstats_seq_write,
-	.llseek  = seq_lseek,
-	.release = lprocfs_seq_release,
-};
-
-int lprocfs_job_stats_init(struct obd_device *obd, int cntr_num,
-			   cntr_init_callback init_fn)
-{
-	struct proc_dir_entry *entry;
-	struct obd_job_stats *stats;
-	ENTRY;
-
-	LASSERT(obd->obd_proc_entry != NULL);
-	LASSERT(obd->obd_type->typ_name);
-
-	if (strcmp(obd->obd_type->typ_name, LUSTRE_MDT_NAME) &&
-	    strcmp(obd->obd_type->typ_name, LUSTRE_OST_NAME)) {
-		CERROR("Invalid obd device type.\n");
-		RETURN(-EINVAL);
-	}
-	stats = &obd->u.obt.obt_jobstats;
-
-	LASSERT(stats->ojs_hash == NULL);
-	stats->ojs_hash = cfs_hash_create("JOB_STATS",
-					  HASH_JOB_STATS_CUR_BITS,
-					  HASH_JOB_STATS_MAX_BITS,
-					  HASH_JOB_STATS_BKT_BITS, 0,
-					  CFS_HASH_MIN_THETA,
-					  CFS_HASH_MAX_THETA,
-					  &job_stats_hash_ops,
-					  CFS_HASH_DEFAULT);
-	if (stats->ojs_hash == NULL)
-		RETURN(-ENOMEM);
-
-	INIT_LIST_HEAD(&stats->ojs_list);
-	rwlock_init(&stats->ojs_lock);
-	stats->ojs_cntr_num = cntr_num;
-	stats->ojs_cntr_init_fn = init_fn;
-	stats->ojs_cleanup_interval = 600; /* 10 mins by default */
-	stats->ojs_last_cleanup = cfs_time_current_sec();
-
-	entry = proc_create_data("job_stats", 0644, obd->obd_proc_entry,
-				 &lprocfs_jobstats_seq_fops, stats);
-	if (entry)
-		RETURN(0);
-	else
-		RETURN(-ENOMEM);
-}
-EXPORT_SYMBOL(lprocfs_job_stats_init);
-
-int lprocfs_rd_job_interval(struct seq_file *m, void *data)
-{
-	struct obd_device *obd = (struct obd_device *)data;
-	struct obd_job_stats *stats;
-
-	LASSERT(obd != NULL);
-	stats = &obd->u.obt.obt_jobstats;
-	return seq_printf(m, "%d\n", stats->ojs_cleanup_interval);
-}
-EXPORT_SYMBOL(lprocfs_rd_job_interval);
-
-int lprocfs_wr_job_interval(struct file *file, const char *buffer,
-			    unsigned long count, void *data)
-{
-	struct obd_device *obd = (struct obd_device *)data;
-	struct obd_job_stats *stats;
-	int val, rc;
-
-	LASSERT(obd != NULL);
-	stats = &obd->u.obt.obt_jobstats;
-
-	rc = lprocfs_write_helper(buffer, count, &val);
-	if (rc)
-		return rc;
-
-	stats->ojs_cleanup_interval = val;
-	lprocfs_job_cleanup(stats, true);
-
-	return count;
-
-}
-EXPORT_SYMBOL(lprocfs_wr_job_interval);
-
-#endif /* LPROCFS*/
diff --git a/drivers/staging/lustre/lustre/obdclass/obd_mount.c b/drivers/staging/lustre/lustre/obdclass/obd_mount.c
index 99adad9..4f20723 100644
--- a/drivers/staging/lustre/lustre/obdclass/obd_mount.c
+++ b/drivers/staging/lustre/lustre/obdclass/obd_mount.c
@@ -47,7 +47,6 @@
 
 #include <obd.h>
 #include <lvfs.h>
-#include <lustre_fsfilt.h>
 #include <obd_class.h>
 #include <lustre/lustre_user.h>
 #include <linux/version.h>
-- 
1.7.9.5

