Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab3LCOv7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:51:59 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:55449 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164Ab3LCOvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:51:55 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 9/9] staging/lustre: don't compile procfs code when CONFIG_PROC_FS is off
Date: Tue,  3 Dec 2013 22:42:09 +0800
Message-Id: <1386081729-9481-13-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386081729-9481-1-git-send-email-bergwolf@gmail.com>
References: <1386081729-9481-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch changes to conditionally compile procfs related source files.
This includes lproc_fid.c, lproc_fld.c, lproc_lov.c, lvfs_lib.c, lproc_mdc.c,
lproc_mgc.c, lprocfs_status.c, lproc_osc.c and sec_lproc.c.

There is a checkpatch warning about usage of simple_strtoul() in the patch.
But it needs to be fixed in a separate patch because it is not related to
CONFIG_PROC_FS breakage here.

Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/fid/Makefile         |    3 +-
 drivers/staging/lustre/lustre/fid/lproc_fid.c      |    2 -
 drivers/staging/lustre/lustre/fld/Makefile         |    3 +-
 drivers/staging/lustre/lustre/fld/lproc_fld.c      |    3 -
 .../staging/lustre/lustre/include/lprocfs_status.h |    8 +-
 drivers/staging/lustre/lustre/include/lustre_sec.h |   17 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_pool.c     |    9 +
 drivers/staging/lustre/lustre/llite/Makefile       |    3 +-
 .../staging/lustre/lustre/llite/llite_internal.h   |   14 +-
 drivers/staging/lustre/lustre/llite/llite_lib.c    |    1 +
 drivers/staging/lustre/lustre/llite/lproc_llite.c  |    4 -
 drivers/staging/lustre/lustre/lmv/Makefile         |    4 +-
 drivers/staging/lustre/lustre/lmv/lproc_lmv.c      |    5 -
 drivers/staging/lustre/lustre/lov/Makefile         |    3 +-
 drivers/staging/lustre/lustre/lov/lov_internal.h   |    2 +-
 drivers/staging/lustre/lustre/lov/lproc_lov.c      |    4 +-
 drivers/staging/lustre/lustre/lvfs/Makefile        |    3 +-
 drivers/staging/lustre/lustre/lvfs/lvfs_lib.c      |    2 -
 drivers/staging/lustre/lustre/mdc/Makefile         |    3 +-
 drivers/staging/lustre/lustre/mdc/lproc_mdc.c      |    3 -
 drivers/staging/lustre/lustre/mgc/Makefile         |    3 +-
 drivers/staging/lustre/lustre/mgc/lproc_mgc.c      |    3 -
 drivers/staging/lustre/lustre/mgc/mgc_internal.h   |    2 +-
 drivers/staging/lustre/lustre/mgc/mgc_request.c    |    2 +
 drivers/staging/lustre/lustre/obdclass/class_obd.c |    7 +
 .../lustre/lustre/obdclass/linux/linux-module.c    |    4 +-
 .../lustre/lustre/obdclass/lprocfs_status.c        |  348 ++++++++++----------
 drivers/staging/lustre/lustre/osc/Makefile         |    3 +-
 drivers/staging/lustre/lustre/osc/lproc_osc.c      |    2 -
 drivers/staging/lustre/lustre/ptlrpc/Makefile      |    3 +-
 .../staging/lustre/lustre/ptlrpc/ptlrpc_internal.h |    6 +
 31 files changed, 247 insertions(+), 232 deletions(-)

diff --git a/drivers/staging/lustre/lustre/fid/Makefile b/drivers/staging/lustre/lustre/fid/Makefile
index ed21bea..d24f2df 100644
--- a/drivers/staging/lustre/lustre/fid/Makefile
+++ b/drivers/staging/lustre/lustre/fid/Makefile
@@ -1,5 +1,6 @@
 obj-$(CONFIG_LUSTRE_FS) += fid.o
-fid-y := fid_request.o lproc_fid.o fid_lib.o
+fid-y := fid_request.o fid_lib.o
+fid-$(CONFIG_PROC_FS) += lproc_fid.o
 
 
 ccflags-y := -I$(src)/../include
diff --git a/drivers/staging/lustre/lustre/fid/lproc_fid.c b/drivers/staging/lustre/lustre/fid/lproc_fid.c
index 294070d..ddd813c 100644
--- a/drivers/staging/lustre/lustre/fid/lproc_fid.c
+++ b/drivers/staging/lustre/lustre/fid/lproc_fid.c
@@ -54,7 +54,6 @@
 #include <lustre_fid.h>
 #include "fid_internal.h"
 
-#ifdef LPROCFS
 /*
  * Note: this function is only used for testing, it is no safe for production
  * use.
@@ -209,4 +208,3 @@ struct lprocfs_vars seq_client_proc_list[] = {
 	{ "fid", &lprocfs_fid_fid_fops },
 	{ NULL }
 };
-#endif
diff --git a/drivers/staging/lustre/lustre/fld/Makefile b/drivers/staging/lustre/lustre/fld/Makefile
index 90d46d8..640fba4 100644
--- a/drivers/staging/lustre/lustre/fld/Makefile
+++ b/drivers/staging/lustre/lustre/fld/Makefile
@@ -1,5 +1,6 @@
 obj-$(CONFIG_LUSTRE_FS) += fld.o
-fld-y := fld_request.o fld_cache.o lproc_fld.o
+fld-y := fld_request.o fld_cache.o
+fld-$(CONFIG_PROC_FS) += lproc_fld.o
 
 
 ccflags-y := -I$(src)/../include
diff --git a/drivers/staging/lustre/lustre/fld/lproc_fld.c b/drivers/staging/lustre/lustre/fld/lproc_fld.c
index 052f7d5..530adde 100644
--- a/drivers/staging/lustre/lustre/fld/lproc_fld.c
+++ b/drivers/staging/lustre/lustre/fld/lproc_fld.c
@@ -56,7 +56,6 @@
 #include <lustre_fid.h>
 #include "fld_internal.h"
 
-#ifdef LPROCFS
 static int
 fld_proc_targets_seq_show(struct seq_file *m, void *unused)
 {
@@ -162,5 +161,3 @@ struct lprocfs_vars fld_client_proc_list[] = {
 	{ "hash", &fld_proc_hash_fops },
 	{ "cache_flush", &fld_proc_cache_flush_fops },
 	{ NULL }};
-
-#endif /* LPROCFS */
diff --git a/drivers/staging/lustre/lustre/include/lprocfs_status.h b/drivers/staging/lustre/lustre/include/lprocfs_status.h
index 56b0572..428e3e4 100644
--- a/drivers/staging/lustre/lustre/include/lprocfs_status.h
+++ b/drivers/staging/lustre/lustre/include/lprocfs_status.h
@@ -370,6 +370,10 @@ static inline void s2dhms(struct dhms *ts, time_t secs)
 #define JOBSTATS_DISABLE		"disable"
 #define JOBSTATS_PROCNAME_UID		"procname_uid"
 
+extern int lprocfs_write_frac_helper(const char *buffer, unsigned long count,
+				     int *val, int mult);
+extern int lprocfs_read_frac_helper(char *buffer, unsigned long count,
+				    long val, int mult);
 #ifdef LPROCFS
 
 extern int lprocfs_stats_alloc_one(struct lprocfs_stats *stats,
@@ -641,11 +645,7 @@ extern int lprocfs_rd_filesfree(struct seq_file *m, void *data);
 
 extern int lprocfs_write_helper(const char *buffer, unsigned long count,
 				int *val);
-extern int lprocfs_write_frac_helper(const char *buffer, unsigned long count,
-				     int *val, int mult);
 extern int lprocfs_seq_read_frac_helper(struct seq_file *m, long val, int mult);
-extern int lprocfs_read_frac_helper(char *buffer, unsigned long count,
-				    long val, int mult);
 extern int lprocfs_write_u64_helper(const char *buffer, unsigned long count,
 				    __u64 *val);
 extern int lprocfs_write_frac_u64_helper(const char *buffer,
diff --git a/drivers/staging/lustre/lustre/include/lustre_sec.h b/drivers/staging/lustre/lustre/include/lustre_sec.h
index 70b8b13..885247d 100644
--- a/drivers/staging/lustre/lustre/include/lustre_sec.h
+++ b/drivers/staging/lustre/lustre/include/lustre_sec.h
@@ -903,12 +903,6 @@ struct ptlrpc_bulk_sec_desc {
 
 
 /*
- * lprocfs
- */
-struct proc_dir_entry;
-extern struct proc_dir_entry *sptlrpc_proc_root;
-
-/*
  * round size up to next power of 2, for slab allocation.
  * @size must be sane (can't overflow after round up)
  */
@@ -1067,7 +1061,18 @@ void sptlrpc_gc_add_ctx(struct ptlrpc_cli_ctx *ctx);
 
 /* misc */
 const char * sec2target_str(struct ptlrpc_sec *sec);
+/*
+ * lprocfs
+ */
+#ifdef LPROCFS
+struct proc_dir_entry;
+extern struct proc_dir_entry *sptlrpc_proc_root;
 int sptlrpc_lprocfs_cliobd_attach(struct obd_device *dev);
+#else
+#define sptlrpc_proc_root	NULL
+static inline int sptlrpc_lprocfs_cliobd_attach(struct obd_device *dev)
+{ return 0; }
+#endif
 
 /*
  * server side
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_pool.c b/drivers/staging/lustre/lustre/ldlm/ldlm_pool.c
index 0025ee6..6758646 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_pool.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_pool.c
@@ -638,6 +638,7 @@ int ldlm_pool_setup(struct ldlm_pool *pl, int limit)
 }
 EXPORT_SYMBOL(ldlm_pool_setup);
 
+#ifdef LPROCFS
 static int lprocfs_pool_state_seq_show(struct seq_file *m, void *unused)
 {
 	int granted, grant_rate, cancel_rate, grant_step;
@@ -822,6 +823,14 @@ static void ldlm_pool_proc_fini(struct ldlm_pool *pl)
 		pl->pl_proc_dir = NULL;
 	}
 }
+#else /* !LPROCFS */
+static int ldlm_pool_proc_init(struct ldlm_pool *pl)
+{
+	return 0;
+}
+
+static void ldlm_pool_proc_fini(struct ldlm_pool *pl) {}
+#endif /* LPROCFS */
 
 int ldlm_pool_init(struct ldlm_pool *pl, struct ldlm_namespace *ns,
 		   int idx, ldlm_side_t client)
diff --git a/drivers/staging/lustre/lustre/llite/Makefile b/drivers/staging/lustre/lustre/llite/Makefile
index bb34b8b..c76f3cf 100644
--- a/drivers/staging/lustre/lustre/llite/Makefile
+++ b/drivers/staging/lustre/lustre/llite/Makefile
@@ -1,12 +1,13 @@
 obj-$(CONFIG_LUSTRE_FS) += lustre.o
 obj-$(CONFIG_LUSTRE_LLITE_LLOOP) += llite_lloop.o
 lustre-y := dcache.o dir.o file.o llite_close.o llite_lib.o llite_nfs.o \
-	    rw.o lproc_llite.o namei.o symlink.o llite_mmap.o \
+	    rw.o namei.o symlink.o llite_mmap.o \
 	    xattr.o xattr_cache.o remote_perm.o llite_rmtacl.o llite_capa.o \
 	    rw26.o super25.o statahead.o \
 	    ../lclient/glimpse.o ../lclient/lcommon_cl.o ../lclient/lcommon_misc.o \
 	    vvp_dev.o vvp_page.o vvp_lock.o vvp_io.o vvp_object.o
 
+lustre-$(CONFIG_PROC_FS) += lproc_llite.o
 llite_lloop-y := lloop.o
 
 
diff --git a/drivers/staging/lustre/lustre/llite/llite_internal.h b/drivers/staging/lustre/lustre/llite/llite_internal.h
index 1355de4..d2f9b18 100644
--- a/drivers/staging/lustre/lustre/llite/llite_internal.h
+++ b/drivers/staging/lustre/lustre/llite/llite_internal.h
@@ -701,15 +701,22 @@ int lprocfs_register_mountpoint(struct proc_dir_entry *parent,
 void lprocfs_unregister_mountpoint(struct ll_sb_info *sbi);
 void ll_stats_ops_tally(struct ll_sb_info *sbi, int op, int count);
 void lprocfs_llite_init_vars(struct lprocfs_static_vars *lvars);
+void ll_rw_stats_tally(struct ll_sb_info *sbi, pid_t pid,
+		       struct ll_file_data *file, loff_t pos,
+		       size_t count, int rw);
 #else
 static inline int lprocfs_register_mountpoint(struct proc_dir_entry *parent,
 			struct super_block *sb, char *osc, char *mdc){return 0;}
 static inline void lprocfs_unregister_mountpoint(struct ll_sb_info *sbi) {}
-static void ll_stats_ops_tally(struct ll_sb_info *sbi, int op, int count) {}
-static void lprocfs_llite_init_vars(struct lprocfs_static_vars *lvars)
+static inline
+void ll_stats_ops_tally(struct ll_sb_info *sbi, int op, int count) {}
+static inline void lprocfs_llite_init_vars(struct lprocfs_static_vars *lvars)
 {
 	memset(lvars, 0, sizeof(*lvars));
 }
+static inline void ll_rw_stats_tally(struct ll_sb_info *sbi, pid_t pid,
+				     struct ll_file_data *file, loff_t pos,
+				     size_t count, int rw) {}
 #endif
 
 
@@ -785,9 +792,6 @@ int ll_md_setattr(struct dentry *dentry, struct md_op_data *op_data,
 		  struct md_open_data **mod);
 void ll_pack_inode2opdata(struct inode *inode, struct md_op_data *op_data,
 			  struct lustre_handle *fh);
-extern void ll_rw_stats_tally(struct ll_sb_info *sbi, pid_t pid,
-			      struct ll_file_data *file, loff_t pos,
-			      size_t count, int rw);
 int ll_getattr_it(struct vfsmount *mnt, struct dentry *de,
 	       struct lookup_intent *it, struct kstat *stat);
 int ll_getattr(struct vfsmount *mnt, struct dentry *de, struct kstat *stat);
diff --git a/drivers/staging/lustre/lustre/llite/llite_lib.c b/drivers/staging/lustre/lustre/llite/llite_lib.c
index 154bdb2..1a96786 100644
--- a/drivers/staging/lustre/lustre/llite/llite_lib.c
+++ b/drivers/staging/lustre/lustre/llite/llite_lib.c
@@ -56,6 +56,7 @@
 #include "llite_internal.h"
 
 struct kmem_cache *ll_file_data_slab;
+struct proc_dir_entry *proc_lustre_fs_root;
 
 LIST_HEAD(ll_super_blocks);
 DEFINE_SPINLOCK(ll_sb_lock);
diff --git a/drivers/staging/lustre/lustre/llite/lproc_llite.c b/drivers/staging/lustre/lustre/llite/lproc_llite.c
index 1ded16a..a9a104a 100644
--- a/drivers/staging/lustre/lustre/llite/lproc_llite.c
+++ b/drivers/staging/lustre/lustre/llite/lproc_llite.c
@@ -42,9 +42,6 @@
 
 #include "llite_internal.h"
 
-struct proc_dir_entry *proc_lustre_fs_root;
-
-#ifdef LPROCFS
 /* /proc/lustre/llite mount point registration */
 extern struct file_operations vvp_dump_pgcache_file_ops;
 struct file_operations ll_rw_extents_stats_fops;
@@ -1404,4 +1401,3 @@ void lprocfs_llite_init_vars(struct lprocfs_static_vars *lvars)
     lvars->module_vars  = NULL;
     lvars->obd_vars     = lprocfs_llite_obd_vars;
 }
-#endif /* LPROCFS */
diff --git a/drivers/staging/lustre/lustre/lmv/Makefile b/drivers/staging/lustre/lustre/lmv/Makefile
index 8cc81ad..9162ef7 100644
--- a/drivers/staging/lustre/lustre/lmv/Makefile
+++ b/drivers/staging/lustre/lustre/lmv/Makefile
@@ -1,5 +1,5 @@
 obj-$(CONFIG_LUSTRE_FS) += lmv.o
-lmv-y := lmv_obd.o lmv_intent.o lmv_fld.o lproc_lmv.o
-
+lmv-y := lmv_obd.o lmv_intent.o lmv_fld.o
+lmv-$(CONFIG_PROC_FS) += lproc_lmv.o
 
 ccflags-y := -I$(src)/../include
diff --git a/drivers/staging/lustre/lustre/lmv/lproc_lmv.c b/drivers/staging/lustre/lustre/lmv/lproc_lmv.c
index edb5a3a..b355d01 100644
--- a/drivers/staging/lustre/lustre/lmv/lproc_lmv.c
+++ b/drivers/staging/lustre/lustre/lmv/lproc_lmv.c
@@ -41,10 +41,6 @@
 #include <lprocfs_status.h>
 #include <obd_class.h>
 
-#ifndef LPROCFS
-static struct lprocfs_vars lprocfs_module_vars[] = { {0} };
-static struct lprocfs_vars lprocfs_obd_vars[] = { {0} };
-#else
 static int lmv_numobd_seq_show(struct seq_file *m, void *v)
 {
 	struct obd_device       *dev = (struct obd_device *)m->private;
@@ -226,7 +222,6 @@ struct file_operations lmv_proc_target_fops = {
 	.release	      = seq_release,
 };
 
-#endif /* LPROCFS */
 void lprocfs_lmv_init_vars(struct lprocfs_static_vars *lvars)
 {
 	lvars->module_vars    = lprocfs_lmv_module_vars;
diff --git a/drivers/staging/lustre/lustre/lov/Makefile b/drivers/staging/lustre/lustre/lov/Makefile
index 67eaec2..9a5f26d 100644
--- a/drivers/staging/lustre/lustre/lov/Makefile
+++ b/drivers/staging/lustre/lustre/lov/Makefile
@@ -1,8 +1,9 @@
 obj-$(CONFIG_LUSTRE_FS) += lov.o
-lov-y := lov_log.o lov_obd.o lov_pack.o lproc_lov.o lov_offset.o lov_merge.o \
+lov-y := lov_log.o lov_obd.o lov_pack.o lov_offset.o lov_merge.o \
 	 lov_request.o lov_ea.o lov_dev.o lov_object.o lov_page.o  \
 	 lov_lock.o lov_io.o lovsub_dev.o lovsub_object.o lovsub_page.o      \
 	 lovsub_lock.o lovsub_io.o lov_pool.o
+lov-$(CONFIG_PROC_FS) += lproc_lov.o
 
 
 
diff --git a/drivers/staging/lustre/lustre/lov/lov_internal.h b/drivers/staging/lustre/lustre/lov/lov_internal.h
index 796da89..2b22a03 100644
--- a/drivers/staging/lustre/lustre/lov/lov_internal.h
+++ b/drivers/staging/lustre/lustre/lov/lov_internal.h
@@ -283,8 +283,8 @@ void lsm_free_plain(struct lov_stripe_md *lsm);
 int lovea_destroy_object(struct lov_obd *lov, struct lov_stripe_md *lsm,
 			 struct obdo *oa, void *data);
 /* lproc_lov.c */
-extern struct file_operations lov_proc_target_fops;
 #ifdef LPROCFS
+extern const struct file_operations lov_proc_target_fops;
 void lprocfs_lov_init_vars(struct lprocfs_static_vars *lvars);
 #else
 static inline void lprocfs_lov_init_vars(struct lprocfs_static_vars *lvars)
diff --git a/drivers/staging/lustre/lustre/lov/lproc_lov.c b/drivers/staging/lustre/lustre/lov/lproc_lov.c
index e6f22e3..bd7da56 100644
--- a/drivers/staging/lustre/lustre/lov/lproc_lov.c
+++ b/drivers/staging/lustre/lustre/lov/lproc_lov.c
@@ -41,7 +41,6 @@
 #include <linux/seq_file.h>
 #include "lov_internal.h"
 
-#ifdef LPROCFS
 static int lov_stripesize_seq_show(struct seq_file *m, void *v)
 {
 	struct obd_device *dev = (struct obd_device *)m->private;
@@ -291,11 +290,10 @@ void lprocfs_lov_init_vars(struct lprocfs_static_vars *lvars)
     lvars->obd_vars     = lprocfs_lov_obd_vars;
 }
 
-struct file_operations lov_proc_target_fops = {
+const struct file_operations lov_proc_target_fops = {
 	.owner   = THIS_MODULE,
 	.open    = lov_target_seq_open,
 	.read    = seq_read,
 	.llseek  = seq_lseek,
 	.release = lprocfs_seq_release,
 };
-#endif /* LPROCFS */
diff --git a/drivers/staging/lustre/lustre/lvfs/Makefile b/drivers/staging/lustre/lustre/lvfs/Makefile
index f50b1c5..e0367c3 100644
--- a/drivers/staging/lustre/lustre/lvfs/Makefile
+++ b/drivers/staging/lustre/lustre/lvfs/Makefile
@@ -1,6 +1,7 @@
 obj-$(CONFIG_LUSTRE_FS) += lvfs.o
 
-lvfs-y := lvfs_linux.o fsfilt.o lvfs_lib.o
+lvfs-y := lvfs_linux.o fsfilt.o
+lvfs-$(CONFIG_PROC_FS) += lvfs_lib.o
 
 
 ccflags-y := -I$(src)/../include
diff --git a/drivers/staging/lustre/lustre/lvfs/lvfs_lib.c b/drivers/staging/lustre/lustre/lvfs/lvfs_lib.c
index b21e40c..7e47fc4 100644
--- a/drivers/staging/lustre/lustre/lvfs/lvfs_lib.c
+++ b/drivers/staging/lustre/lustre/lvfs/lvfs_lib.c
@@ -43,7 +43,6 @@
 #include <lustre_lib.h>
 #include <lprocfs_status.h>
 
-#ifdef LPROCFS
 void lprocfs_counter_add(struct lprocfs_stats *stats, int idx, long amount)
 {
 	struct lprocfs_counter		*percpu_cntr;
@@ -169,4 +168,3 @@ int lprocfs_stats_alloc_one(struct lprocfs_stats *stats, unsigned int cpuid)
 	return rc;
 }
 EXPORT_SYMBOL(lprocfs_stats_alloc_one);
-#endif  /* LPROCFS */
diff --git a/drivers/staging/lustre/lustre/mdc/Makefile b/drivers/staging/lustre/lustre/mdc/Makefile
index 93bae24..4c0bed1 100644
--- a/drivers/staging/lustre/lustre/mdc/Makefile
+++ b/drivers/staging/lustre/lustre/mdc/Makefile
@@ -1,5 +1,6 @@
 obj-$(CONFIG_LUSTRE_FS) += mdc.o
-mdc-y := mdc_request.o mdc_reint.o lproc_mdc.o mdc_lib.o mdc_locks.o
+mdc-y := mdc_request.o mdc_reint.o mdc_lib.o mdc_locks.o
+mdc-$(CONFIG_PROC_FS) += lproc_mdc.o
 
 
 ccflags-y := -I$(src)/../include
diff --git a/drivers/staging/lustre/lustre/mdc/lproc_mdc.c b/drivers/staging/lustre/lustre/mdc/lproc_mdc.c
index e0b8f18..2663480 100644
--- a/drivers/staging/lustre/lustre/mdc/lproc_mdc.c
+++ b/drivers/staging/lustre/lustre/mdc/lproc_mdc.c
@@ -39,8 +39,6 @@
 #include <obd_class.h>
 #include <lprocfs_status.h>
 
-#ifdef LPROCFS
-
 static int mdc_max_rpcs_in_flight_seq_show(struct seq_file *m, void *v)
 {
 	struct obd_device *dev = m->private;
@@ -214,4 +212,3 @@ void lprocfs_mdc_init_vars(struct lprocfs_static_vars *lvars)
     lvars->module_vars  = lprocfs_mdc_module_vars;
     lvars->obd_vars     = lprocfs_mdc_obd_vars;
 }
-#endif /* LPROCFS */
diff --git a/drivers/staging/lustre/lustre/mgc/Makefile b/drivers/staging/lustre/lustre/mgc/Makefile
index 2672463..2f5ee64 100644
--- a/drivers/staging/lustre/lustre/mgc/Makefile
+++ b/drivers/staging/lustre/lustre/mgc/Makefile
@@ -1,5 +1,6 @@
 obj-$(CONFIG_LUSTRE_FS) += mgc.o
-mgc-y := mgc_request.o lproc_mgc.o
+mgc-y := mgc_request.o
+mgc-$(CONFIG_PROC_FS) += lproc_mgc.o
 
 
 ccflags-y := -I$(src)/../include
diff --git a/drivers/staging/lustre/lustre/mgc/lproc_mgc.c b/drivers/staging/lustre/lustre/mgc/lproc_mgc.c
index ebecec2..1506af1 100644
--- a/drivers/staging/lustre/lustre/mgc/lproc_mgc.c
+++ b/drivers/staging/lustre/lustre/mgc/lproc_mgc.c
@@ -40,8 +40,6 @@
 #include <lprocfs_status.h>
 #include "mgc_internal.h"
 
-#ifdef LPROCFS
-
 LPROC_SEQ_FOPS_RO_TYPE(mgc, uuid);
 LPROC_SEQ_FOPS_RO_TYPE(mgc, connect_flags);
 LPROC_SEQ_FOPS_RO_TYPE(mgc, server_uuid);
@@ -80,4 +78,3 @@ void lprocfs_mgc_init_vars(struct lprocfs_static_vars *lvars)
 	lvars->module_vars = lprocfs_mgc_module_vars;
 	lvars->obd_vars    = lprocfs_mgc_obd_vars;
 }
-#endif /* LPROCFS */
diff --git a/drivers/staging/lustre/lustre/mgc/mgc_internal.h b/drivers/staging/lustre/lustre/mgc/mgc_internal.h
index dbd6982..73b4548 100644
--- a/drivers/staging/lustre/lustre/mgc/mgc_internal.h
+++ b/drivers/staging/lustre/lustre/mgc/mgc_internal.h
@@ -48,7 +48,7 @@
 void lprocfs_mgc_init_vars(struct lprocfs_static_vars *lvars);
 int lprocfs_mgc_rd_ir_state(struct seq_file *m, void *data);
 #else
-static void lprocfs_mgc_init_vars(struct lprocfs_static_vars *lvars)
+static inline void lprocfs_mgc_init_vars(struct lprocfs_static_vars *lvars)
 {
 	memset(lvars, 0, sizeof(*lvars));
 }
diff --git a/drivers/staging/lustre/lustre/mgc/mgc_request.c b/drivers/staging/lustre/lustre/mgc/mgc_request.c
index f6e4bac..b323820 100644
--- a/drivers/staging/lustre/lustre/mgc/mgc_request.c
+++ b/drivers/staging/lustre/lustre/mgc/mgc_request.c
@@ -397,6 +397,7 @@ static int config_log_end(char *logname, struct config_llog_instance *cfg)
 	return rc;
 }
 
+#ifdef LPROCFS
 int lprocfs_mgc_rd_ir_state(struct seq_file *m, void *data)
 {
 	struct obd_device       *obd = data;
@@ -420,6 +421,7 @@ int lprocfs_mgc_rd_ir_state(struct seq_file *m, void *data)
 
 	return 0;
 }
+#endif
 
 /* reenqueue any lost locks */
 #define RQ_RUNNING 0x1
diff --git a/drivers/staging/lustre/lustre/obdclass/class_obd.c b/drivers/staging/lustre/lustre/obdclass/class_obd.c
index 5f8d9f2..c93131e 100644
--- a/drivers/staging/lustre/lustre/obdclass/class_obd.c
+++ b/drivers/staging/lustre/lustre/obdclass/class_obd.c
@@ -507,8 +507,15 @@ int obd_init_checks(void)
 }
 
 extern spinlock_t obd_types_lock;
+#ifdef LPROCFS
 extern int class_procfs_init(void);
 extern int class_procfs_clean(void);
+#else
+static inline int class_procfs_init(void)
+{ return 0; }
+static inline int class_procfs_clean(void)
+{ return 0; }
+#endif
 
 static int __init init_obdclass(void)
 {
diff --git a/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c b/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c
index 2efc437..a70ead1 100644
--- a/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c
+++ b/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c
@@ -295,9 +295,6 @@ struct lprocfs_vars lprocfs_base[] = {
 	{ "jobid_var", &obd_proc_jobid_var_fops },
 	{ 0 }
 };
-#else
-#define lprocfs_base NULL
-#endif /* LPROCFS */
 
 static void *obd_device_list_seq_start(struct seq_file *p, loff_t *pos)
 {
@@ -403,3 +400,4 @@ int class_procfs_clean(void)
 	}
 	return 0;
 }
+#endif /* LPROCFS */
diff --git a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
index 8828419..ec3b605 100644
--- a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
+++ b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
@@ -46,7 +46,179 @@
 #include <lustre/lustre_idl.h>
 #include <linux/seq_file.h>
 
-#if defined(LPROCFS)
+static const char * const obd_connect_names[] = {
+	"read_only",
+	"lov_index",
+	"unused",
+	"write_grant",
+	"server_lock",
+	"version",
+	"request_portal",
+	"acl",
+	"xattr",
+	"create_on_write",
+	"truncate_lock",
+	"initial_transno",
+	"inode_bit_locks",
+	"join_file(obsolete)",
+	"getattr_by_fid",
+	"no_oh_for_devices",
+	"remote_client",
+	"remote_client_by_force",
+	"max_byte_per_rpc",
+	"64bit_qdata",
+	"mds_capability",
+	"oss_capability",
+	"early_lock_cancel",
+	"som",
+	"adaptive_timeouts",
+	"lru_resize",
+	"mds_mds_connection",
+	"real_conn",
+	"change_qunit_size",
+	"alt_checksum_algorithm",
+	"fid_is_enabled",
+	"version_recovery",
+	"pools",
+	"grant_shrink",
+	"skip_orphan",
+	"large_ea",
+	"full20",
+	"layout_lock",
+	"64bithash",
+	"object_max_bytes",
+	"imp_recov",
+	"jobstats",
+	"umask",
+	"einprogress",
+	"grant_param",
+	"flock_owner",
+	"lvb_type",
+	"nanoseconds_times",
+	"lightweight_conn",
+	"short_io",
+	"pingless",
+	"unknown",
+	NULL
+};
+
+int obd_connect_flags2str(char *page, int count, __u64 flags, char *sep)
+{
+	__u64 mask = 1;
+	int i, ret = 0;
+
+	for (i = 0; obd_connect_names[i] != NULL; i++, mask <<= 1) {
+		if (flags & mask)
+			ret += snprintf(page + ret, count - ret, "%s%s",
+					ret ? sep : "", obd_connect_names[i]);
+	}
+	if (flags & ~(mask - 1))
+		ret += snprintf(page + ret, count - ret,
+				"%sunknown flags "LPX64,
+				ret ? sep : "", flags & ~(mask - 1));
+	return ret;
+}
+EXPORT_SYMBOL(obd_connect_flags2str);
+
+int lprocfs_read_frac_helper(char *buffer, unsigned long count, long val,
+			     int mult)
+{
+	long decimal_val, frac_val;
+	int prtn;
+
+	if (count < 10)
+		return -EINVAL;
+
+	decimal_val = val / mult;
+	prtn = snprintf(buffer, count, "%ld", decimal_val);
+	frac_val = val % mult;
+
+	if (prtn < (count - 4) && frac_val > 0) {
+		long temp_frac;
+		int i, temp_mult = 1, frac_bits = 0;
+
+		temp_frac = frac_val * 10;
+		buffer[prtn++] = '.';
+		while (frac_bits < 2 && (temp_frac / mult) < 1) {
+			/* only reserved 2 bits fraction */
+			buffer[prtn++] = '0';
+			temp_frac *= 10;
+			frac_bits++;
+		}
+		/*
+		 * Need to think these cases :
+		 *      1. #echo x.00 > /proc/xxx       output result : x
+		 *      2. #echo x.0x > /proc/xxx       output result : x.0x
+		 *      3. #echo x.x0 > /proc/xxx       output result : x.x
+		 *      4. #echo x.xx > /proc/xxx       output result : x.xx
+		 *      Only reserved 2 bits fraction.
+		 */
+		for (i = 0; i < (5 - prtn); i++)
+			temp_mult *= 10;
+
+		frac_bits = min((int)count - prtn, 3 - frac_bits);
+		prtn += snprintf(buffer + prtn, frac_bits, "%ld",
+				 frac_val * temp_mult / mult);
+
+		prtn--;
+		while (buffer[prtn] < '1' || buffer[prtn] > '9') {
+			prtn--;
+			if (buffer[prtn] == '.') {
+				prtn--;
+				break;
+			}
+		}
+		prtn++;
+	}
+	buffer[prtn++] = '\n';
+	return prtn;
+}
+EXPORT_SYMBOL(lprocfs_read_frac_helper);
+
+int lprocfs_write_frac_helper(const char *buffer, unsigned long count,
+			      int *val, int mult)
+{
+	char kernbuf[20], *end, *pbuf;
+
+	if (count > (sizeof(kernbuf) - 1))
+		return -EINVAL;
+
+	if (copy_from_user(kernbuf, buffer, count))
+		return -EFAULT;
+
+	kernbuf[count] = '\0';
+	pbuf = kernbuf;
+	if (*pbuf == '-') {
+		mult = -mult;
+		pbuf++;
+	}
+
+	*val = (int)simple_strtoul(pbuf, &end, 10) * mult;
+	if (pbuf == end)
+		return -EINVAL;
+
+	if (end != NULL && *end == '.') {
+		int temp_val, pow = 1;
+		int i;
+
+		pbuf = end + 1;
+		if (strlen(pbuf) > 5)
+			pbuf[5] = '\0'; /*only allow 5bits fractional*/
+
+		temp_val = (int)simple_strtoul(pbuf, &end, 10) * mult;
+
+		if (pbuf < end) {
+			for (i = 0; i < (end - pbuf); i++)
+				pow *= 10;
+
+			*val += temp_val / pow;
+		}
+	}
+	return 0;
+}
+EXPORT_SYMBOL(lprocfs_write_frac_helper);
+
+#ifdef LPROCFS
 
 static int lprocfs_no_percpu_stats = 0;
 module_param(lprocfs_no_percpu_stats, int, 0644);
@@ -479,62 +651,6 @@ static int obd_import_flags2str(struct obd_import *imp, struct seq_file *m)
 }
 #undef flags2str
 
-static const char *obd_connect_names[] = {
-	"read_only",
-	"lov_index",
-	"unused",
-	"write_grant",
-	"server_lock",
-	"version",
-	"request_portal",
-	"acl",
-	"xattr",
-	"create_on_write",
-	"truncate_lock",
-	"initial_transno",
-	"inode_bit_locks",
-	"join_file(obsolete)",
-	"getattr_by_fid",
-	"no_oh_for_devices",
-	"remote_client",
-	"remote_client_by_force",
-	"max_byte_per_rpc",
-	"64bit_qdata",
-	"mds_capability",
-	"oss_capability",
-	"early_lock_cancel",
-	"som",
-	"adaptive_timeouts",
-	"lru_resize",
-	"mds_mds_connection",
-	"real_conn",
-	"change_qunit_size",
-	"alt_checksum_algorithm",
-	"fid_is_enabled",
-	"version_recovery",
-	"pools",
-	"grant_shrink",
-	"skip_orphan",
-	"large_ea",
-	"full20",
-	"layout_lock",
-	"64bithash",
-	"object_max_bytes",
-	"imp_recov",
-	"jobstats",
-	"umask",
-	"einprogress",
-	"grant_param",
-	"flock_owner",
-	"lvb_type",
-	"nanoseconds_times",
-	"lightweight_conn",
-	"short_io",
-	"pingless",
-	"unknown",
-	NULL
-};
-
 static void obd_connect_seq_flags2str(struct seq_file *m, __u64 flags, char *sep)
 {
 	__u64 mask = 1;
@@ -553,24 +669,6 @@ static void obd_connect_seq_flags2str(struct seq_file *m, __u64 flags, char *sep
 				first ? sep : "", flags & ~(mask - 1));
 }
 
-int obd_connect_flags2str(char *page, int count, __u64 flags, char *sep)
-{
-	__u64 mask = 1;
-	int i, ret = 0;
-
-	for (i = 0; obd_connect_names[i] != NULL; i++, mask <<= 1) {
-		if (flags & mask)
-			ret += snprintf(page + ret, count - ret, "%s%s",
-					ret ? sep : "", obd_connect_names[i]);
-	}
-	if (flags & ~(mask - 1))
-		ret += snprintf(page + ret, count - ret,
-				"%sunknown flags "LPX64,
-				ret ? sep : "", flags & ~(mask - 1));
-	return ret;
-}
-EXPORT_SYMBOL(obd_connect_flags2str);
-
 int lprocfs_rd_import(struct seq_file *m, void *data)
 {
 	struct lprocfs_counter		ret;
@@ -1658,104 +1756,6 @@ int lprocfs_write_helper(const char *buffer, unsigned long count,
 }
 EXPORT_SYMBOL(lprocfs_write_helper);
 
-int lprocfs_write_frac_helper(const char *buffer, unsigned long count,
-			      int *val, int mult)
-{
-	char kernbuf[20], *end, *pbuf;
-
-	if (count > (sizeof(kernbuf) - 1))
-		return -EINVAL;
-
-	if (copy_from_user(kernbuf, buffer, count))
-		return -EFAULT;
-
-	kernbuf[count] = '\0';
-	pbuf = kernbuf;
-	if (*pbuf == '-') {
-		mult = -mult;
-		pbuf++;
-	}
-
-	*val = (int)simple_strtoul(pbuf, &end, 10) * mult;
-	if (pbuf == end)
-		return -EINVAL;
-
-	if (end != NULL && *end == '.') {
-		int temp_val, pow = 1;
-		int i;
-
-		pbuf = end + 1;
-		if (strlen(pbuf) > 5)
-			pbuf[5] = '\0'; /*only allow 5bits fractional*/
-
-		temp_val = (int)simple_strtoul(pbuf, &end, 10) * mult;
-
-		if (pbuf < end) {
-			for (i = 0; i < (end - pbuf); i++)
-				pow *= 10;
-
-			*val += temp_val / pow;
-		}
-	}
-	return 0;
-}
-EXPORT_SYMBOL(lprocfs_write_frac_helper);
-
-int lprocfs_read_frac_helper(char *buffer, unsigned long count, long val,
-			     int mult)
-{
-	long decimal_val, frac_val;
-	int prtn;
-
-	if (count < 10)
-		return -EINVAL;
-
-	decimal_val = val / mult;
-	prtn = snprintf(buffer, count, "%ld", decimal_val);
-	frac_val = val % mult;
-
-	if (prtn < (count - 4) && frac_val > 0) {
-		long temp_frac;
-		int i, temp_mult = 1, frac_bits = 0;
-
-		temp_frac = frac_val * 10;
-		buffer[prtn++] = '.';
-		while (frac_bits < 2 && (temp_frac / mult) < 1 ) {
-			/* only reserved 2 bits fraction */
-			buffer[prtn++] ='0';
-			temp_frac *= 10;
-			frac_bits++;
-		}
-		/*
-		 * Need to think these cases :
-		 *      1. #echo x.00 > /proc/xxx       output result : x
-		 *      2. #echo x.0x > /proc/xxx       output result : x.0x
-		 *      3. #echo x.x0 > /proc/xxx       output result : x.x
-		 *      4. #echo x.xx > /proc/xxx       output result : x.xx
-		 *      Only reserved 2 bits fraction.
-		 */
-		for (i = 0; i < (5 - prtn); i++)
-			temp_mult *= 10;
-
-		frac_bits = min((int)count - prtn, 3 - frac_bits);
-		prtn += snprintf(buffer + prtn, frac_bits, "%ld",
-				 frac_val * temp_mult / mult);
-
-		prtn--;
-		while(buffer[prtn] < '1' || buffer[prtn] > '9') {
-			prtn--;
-			if (buffer[prtn] == '.') {
-				prtn--;
-				break;
-			}
-		}
-		prtn++;
-	}
-	buffer[prtn++] ='\n';
-	return prtn;
-}
-EXPORT_SYMBOL(lprocfs_read_frac_helper);
-
 int lprocfs_seq_read_frac_helper(struct seq_file *m, long val, int mult)
 {
 	long decimal_val, frac_val;
@@ -1979,4 +1979,4 @@ int lprocfs_obd_rd_max_pages_per_rpc(struct seq_file *m, void *data)
 }
 EXPORT_SYMBOL(lprocfs_obd_rd_max_pages_per_rpc);
 
-#endif /* LPROCFS*/
+#endif
diff --git a/drivers/staging/lustre/lustre/osc/Makefile b/drivers/staging/lustre/lustre/osc/Makefile
index bbd2f77..4488162 100644
--- a/drivers/staging/lustre/lustre/osc/Makefile
+++ b/drivers/staging/lustre/lustre/osc/Makefile
@@ -1,6 +1,7 @@
 obj-$(CONFIG_LUSTRE_FS) += osc.o
-osc-y := osc_request.o lproc_osc.o osc_dev.o osc_object.o \
+osc-y := osc_request.o osc_dev.o osc_object.o \
 	 osc_page.o osc_lock.o osc_io.o osc_quota.o osc_cache.o
+osc-$(CONFIG_PROC_FS) += lproc_osc.o
 
 
 
diff --git a/drivers/staging/lustre/lustre/osc/lproc_osc.c b/drivers/staging/lustre/lustre/osc/lproc_osc.c
index ef10e2a..0b59fc1 100644
--- a/drivers/staging/lustre/lustre/osc/lproc_osc.c
+++ b/drivers/staging/lustre/lustre/osc/lproc_osc.c
@@ -42,7 +42,6 @@
 #include <linux/seq_file.h>
 #include "osc_internal.h"
 
-#ifdef LPROCFS
 static int osc_active_seq_show(struct seq_file *m, void *v)
 {
 	struct obd_device *dev = m->private;
@@ -724,4 +723,3 @@ void lprocfs_osc_init_vars(struct lprocfs_static_vars *lvars)
 	lvars->module_vars = lprocfs_osc_module_vars;
 	lvars->obd_vars    = lprocfs_osc_obd_vars;
 }
-#endif /* LPROCFS */
diff --git a/drivers/staging/lustre/lustre/ptlrpc/Makefile b/drivers/staging/lustre/lustre/ptlrpc/Makefile
index 2ec0c24..1c338aa 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/Makefile
+++ b/drivers/staging/lustre/lustre/ptlrpc/Makefile
@@ -12,10 +12,11 @@ ptlrpc_objs := client.o recover.o connection.o niobuf.o pack_generic.o
 ptlrpc_objs += events.o ptlrpc_module.o service.o pinger.o
 ptlrpc_objs += llog_net.o llog_client.o import.o ptlrpcd.o
 ptlrpc_objs += pers.o lproc_ptlrpc.o wiretest.o layout.o
-ptlrpc_objs += sec.o sec_bulk.o sec_gc.o sec_config.o sec_lproc.o
+ptlrpc_objs += sec.o sec_bulk.o sec_gc.o sec_config.o
 ptlrpc_objs += sec_null.o sec_plain.o nrs.o nrs_fifo.o
 
 ptlrpc-y := $(ldlm_objs) $(ptlrpc_objs)
+ptlrpc-$(CONFIG_PROC_FS) += sec_lproc.o
 ptlrpc-$(CONFIG_LUSTRE_TRANSLATE_ERRNOS) += errno.o
 
 obj-$(CONFIG_PTLRPC_GSS) += gss/
diff --git a/drivers/staging/lustre/lustre/ptlrpc/ptlrpc_internal.h b/drivers/staging/lustre/lustre/ptlrpc/ptlrpc_internal.h
index 5d0749c..e3b5a92 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/ptlrpc_internal.h
+++ b/drivers/staging/lustre/lustre/ptlrpc/ptlrpc_internal.h
@@ -259,8 +259,14 @@ void sptlrpc_enc_pool_fini(void);
 int sptlrpc_proc_enc_pool_seq_show(struct seq_file *m, void *v);
 
 /* sec_lproc.c */
+#ifdef LPROCFS
 int  sptlrpc_lproc_init(void);
 void sptlrpc_lproc_fini(void);
+#else
+static inline int sptlrpc_lproc_init(void)
+{ return 0; }
+static inline void sptlrpc_lproc_fini(void) {}
+#endif
 
 /* sec_gc.c */
 int sptlrpc_gc_init(void);
-- 
1.7.9.5

