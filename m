Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbaLGADO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 19:03:14 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:42748 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720AbaLGADM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 19:03:12 -0500
From: Tristan Lelong <tristan@lelong.xyz>
To: oleg.drokin@intel.com, andreas.dilger@intel.com,
        gregkh@linuxfoundation.org, askb23@gmail.com, john.hammond@intel.com,
        gdonald@gmail.com, anhlq2110@gmail.com, fabio.falzoi84@gmail.com,
        oort10@gmail.com, agimenez@sysvalve.es, rupran@einserver.de,
        surya.seetharaman9@gmail.com, Julia.Lawall@lip6.fr, joe@perches.com,
        a.terekhov@gmail.com, liang.zhen@intel.com, vthakkar1994@gmail.com,
        amk@cray.com, srikrishanmalik@gmail.com, rd@radekdostal.com,
        bergwolf@gmail.com, dan.carpenter@oracle.com,
        paul.gortmaker@windriver.com, tapaswenipathak@gmail.com,
        email@christophjaeger.info, uja.ornl@gmail.com, brilliantov@inbox.ru,
        dmitry.eremin@intel.com
Cc: HPDD-discuss@ml01.01.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Tristan Lelong <tristan@lelong.xyz>
Subject: [PATCH v3] staging: lustre: fix sparse warning on LPROC_SEQ_FOPS macros
Date: Sat,  6 Dec 2014 16:03:22 -0800
Message-Id: <1417910602-20953-1-git-send-email-tristan@lelong.xyz>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix a sparse warning in lustre sources

warning: incorrect type in argument 1 (different address spaces)
    expected void [noderef] <asn:1>*to
    got char *<noident>

This is done by adding the missing __user attribute on userland pointers inside the LPROC_SEQ_FOPS like macros:
- LPROC_SEQ_FOPS
- LPROC_SEQ_FOPS_RW_TYPE
- LPROC_SEQ_FOPS_WR_ONLY
- LDLM_POOL_PROC_WRITER

The patch also updates all the functions that are used by this macro:
- lprocfs_wr_*
- *_seq_write

as well as some helpers used by the previously modified functions (otherwise fixing the sparse warning add some new ones):
- lprocfs_write_frac_helper
- lprocfs_write_helper
- lprocfs_write_u64_helper

The patch also fixes one __user pointer direct dereference by strncmp in function fld_proc_hash_seq_write.

Signed-off-by: Tristan Lelong <tristan@lelong.xyz>
---
Changes in v2:
        Use dynamic allocation for 'name' variable instead of having it on the stack, per Greg K-H suggestion.

Changes in v3:
	Rename added variable from 'name' to 'fh_name'.
	Revert to a stack declaration of 'fh_name' since it is not 80 bytes but only 8, per Andreas Dilger comment.
---
 drivers/staging/lustre/lustre/fld/lproc_fld.c      | 14 ++++--
 .../staging/lustre/lustre/include/lprocfs_status.h | 44 +++++++++--------
 drivers/staging/lustre/lustre/ldlm/ldlm_internal.h |  5 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_pool.c     |  4 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_resource.c |  7 +--
 drivers/staging/lustre/lustre/lov/lproc_lov.c      | 20 +++++---
 drivers/staging/lustre/lustre/mdc/lproc_mdc.c      |  7 +--
 .../lustre/lustre/obdclass/linux/linux-module.c    |  5 +-
 .../lustre/lustre/obdclass/lprocfs_status.c        |  2 +-
 drivers/staging/lustre/lustre/osc/lproc_osc.c      | 57 +++++++++++++---------
 .../staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c    | 25 +++++-----
 11 files changed, 114 insertions(+), 76 deletions(-)

diff --git a/drivers/staging/lustre/lustre/fld/lproc_fld.c b/drivers/staging/lustre/lustre/fld/lproc_fld.c
index 95e7de1..9b26bb5 100644
--- a/drivers/staging/lustre/lustre/fld/lproc_fld.c
+++ b/drivers/staging/lustre/lustre/fld/lproc_fld.c
@@ -87,13 +87,21 @@ fld_proc_hash_seq_show(struct seq_file *m, void *unused)
 }
 
 static ssize_t
-fld_proc_hash_seq_write(struct file *file, const char *buffer,
-			size_t count, loff_t *off)
+fld_proc_hash_seq_write(struct file *file,
+				const char __user *buffer,
+				size_t count, loff_t *off)
 {
 	struct lu_client_fld *fld;
 	struct lu_fld_hash *hash = NULL;
+	char fh_name[8];
 	int i;
 
+	if (count > sizeof(fh_name))
+		return -ENAMETOOLONG;
+
+	if (copy_from_user(fh_name, buffer, count) != 0)
+		return -EFAULT;
+
 	fld = ((struct seq_file *)file->private_data)->private;
 	LASSERT(fld != NULL);
 
@@ -101,7 +109,7 @@ fld_proc_hash_seq_write(struct file *file, const char *buffer,
 		if (count != strlen(fld_hash[i].fh_name))
 			continue;
 
-		if (!strncmp(fld_hash[i].fh_name, buffer, count)) {
+		if (!strncmp(fld_hash[i].fh_name, fh_name, count)) {
 			hash = &fld_hash[i];
 			break;
 		}
diff --git a/drivers/staging/lustre/lustre/include/lprocfs_status.h b/drivers/staging/lustre/lustre/include/lprocfs_status.h
index cfe503b..8a25cf6 100644
--- a/drivers/staging/lustre/lustre/include/lprocfs_status.h
+++ b/drivers/staging/lustre/lustre/include/lprocfs_status.h
@@ -627,16 +627,16 @@ struct adaptive_timeout;
 extern int lprocfs_at_hist_helper(struct seq_file *m,
 				  struct adaptive_timeout *at);
 extern int lprocfs_rd_timeouts(struct seq_file *m, void *data);
-extern int lprocfs_wr_timeouts(struct file *file, const char *buffer,
+extern int lprocfs_wr_timeouts(struct file *file, const char __user *buffer,
 			       unsigned long count, void *data);
-extern int lprocfs_wr_evict_client(struct file *file, const char *buffer,
+extern int lprocfs_wr_evict_client(struct file *file, const char __user *buffer,
 			    size_t count, loff_t *off);
-extern int lprocfs_wr_ping(struct file *file, const char *buffer,
+extern int lprocfs_wr_ping(struct file *file, const char __user *buffer,
 			   size_t count, loff_t *off);
-extern int lprocfs_wr_import(struct file *file, const char *buffer,
+extern int lprocfs_wr_import(struct file *file, const char __user *buffer,
 		      size_t count, loff_t *off);
 extern int lprocfs_rd_pinger_recov(struct seq_file *m, void *n);
-extern int lprocfs_wr_pinger_recov(struct file *file, const char *buffer,
+extern int lprocfs_wr_pinger_recov(struct file *file, const char __user *buffer,
 				   size_t count, loff_t *off);
 
 /* Statfs helpers */
@@ -650,8 +650,8 @@ extern int lprocfs_rd_filesfree(struct seq_file *m, void *data);
 extern int lprocfs_write_helper(const char __user *buffer, unsigned long count,
 				int *val);
 extern int lprocfs_seq_read_frac_helper(struct seq_file *m, long val, int mult);
-extern int lprocfs_write_u64_helper(const char *buffer, unsigned long count,
-				    __u64 *val);
+extern int lprocfs_write_u64_helper(const char __user *buffer,
+				unsigned long count, __u64 *val);
 extern int lprocfs_write_frac_u64_helper(const char *buffer,
 					 unsigned long count,
 					 __u64 *val, int mult);
@@ -716,7 +716,8 @@ static struct file_operations name##_fops = {				\
 		return lprocfs_rd_##type(m, m->private);		\
 	}								\
 	static ssize_t name##_##type##_seq_write(struct file *file,	\
-			const char *buffer, size_t count, loff_t *off)	\
+			const char __user *buffer, size_t count,	\
+						loff_t *off)		\
 	{								\
 		struct seq_file *seq = file->private_data;		\
 		return lprocfs_wr_##type(file, buffer,			\
@@ -726,7 +727,8 @@ static struct file_operations name##_fops = {				\
 
 #define LPROC_SEQ_FOPS_WR_ONLY(name, type)				\
 	static ssize_t name##_##type##_write(struct file *file,		\
-			const char *buffer, size_t count, loff_t *off)	\
+			const char __user *buffer, size_t count,	\
+						loff_t *off)		\
 	{								\
 		return lprocfs_wr_##type(file, buffer, count, off);	\
 	}								\
@@ -939,20 +941,24 @@ static inline int lprocfs_at_hist_helper(struct seq_file *m,
 static inline int lprocfs_rd_timeouts(struct seq_file *m, void *data)
 { return 0; }
 static inline int lprocfs_wr_timeouts(struct file *file,
-				      const char *buffer,
-				      unsigned long count, void *data)
+				const char __user *buffer,
+				unsigned long count, void *data)
 { return 0; }
-static inline int lprocfs_wr_evict_client(struct file *file, const char *buffer,
-				    size_t count, loff_t *off)
+static inline int lprocfs_wr_evict_client(struct file *file,
+				const char __user *buffer,
+				size_t count, loff_t *off)
 { return 0; }
-static inline int lprocfs_wr_ping(struct file *file, const char *buffer,
-			   size_t count, loff_t *off)
+static inline int lprocfs_wr_ping(struct file *file,
+				const char __user *buffer,
+				size_t count, loff_t *off)
 { return 0; }
-static inline int lprocfs_wr_import(struct file *file, const char *buffer,
-			      size_t count, loff_t *off)
+static inline int lprocfs_wr_import(struct file *file,
+				const char __user *buffer,
+				size_t count, loff_t *off)
 { return 0; }
-static inline int lprocfs_wr_pinger_recov(struct file *file, const char *buffer,
-					size_t count, loff_t *off)
+static inline int lprocfs_wr_pinger_recov(struct file *file,
+				const char __user *buffer,
+				size_t count, loff_t *off)
 { return 0; }
 
 /* Statfs helpers */
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_internal.h b/drivers/staging/lustre/lustre/ldlm/ldlm_internal.h
index 6c6c57c..20e64cd 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_internal.h
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_internal.h
@@ -249,8 +249,9 @@ typedef enum ldlm_policy_res ldlm_policy_res_t;
 	struct __##var##__dummy_read {; } /* semicolon catcher */
 
 #define LDLM_POOL_PROC_WRITER(var, type)				    \
-	static int lprocfs_wr_##var(struct file *file, const char *buffer,  \
-			     unsigned long count, void *data)		    \
+	static int lprocfs_wr_##var(struct file *file,			    \
+				const char __user *buffer,		    \
+				unsigned long count, void *data)	    \
 	{								    \
 		struct ldlm_pool *pl = data;				    \
 		type tmp;						    \
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_pool.c b/drivers/staging/lustre/lustre/ldlm/ldlm_pool.c
index 4c838f6..142b3dd 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_pool.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_pool.c
@@ -697,8 +697,8 @@ LPROC_SEQ_FOPS_RO(lprocfs_grant_plan);
 LDLM_POOL_PROC_READER_SEQ_SHOW(recalc_period, int);
 LDLM_POOL_PROC_WRITER(recalc_period, int);
 static ssize_t lprocfs_recalc_period_seq_write(struct file *file,
-					       const char *buf, size_t len,
-					       loff_t *off)
+					       const char __user *buf,
+					       size_t len, loff_t *off)
 {
 	struct seq_file *seq = file->private_data;
 
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_resource.c b/drivers/staging/lustre/lustre/ldlm/ldlm_resource.c
index 1f150e4..c6f62a9 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_resource.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_resource.c
@@ -72,7 +72,7 @@ extern unsigned int ldlm_cancel_unused_locks_before_replay;
 unsigned int ldlm_dump_granted_max = 256;
 
 #if defined(CONFIG_PROC_FS)
-static ssize_t lprocfs_wr_dump_ns(struct file *file, const char *buffer,
+static ssize_t lprocfs_wr_dump_ns(struct file *file, const char __user *buffer,
 				  size_t count, loff_t *off)
 {
 	ldlm_dump_all_namespaces(LDLM_NAMESPACE_SERVER, D_DLMTRACE);
@@ -287,8 +287,9 @@ static int lprocfs_elc_seq_show(struct seq_file *m, void *v)
 	return lprocfs_rd_uint(m, &supp);
 }
 
-static ssize_t lprocfs_elc_seq_write(struct file *file, const char *buffer,
-				 size_t count, loff_t *off)
+static ssize_t lprocfs_elc_seq_write(struct file *file,
+				const char __user *buffer,
+				size_t count, loff_t *off)
 {
 	struct ldlm_namespace *ns = ((struct seq_file *)file->private_data)->private;
 	unsigned int supp = -1;
diff --git a/drivers/staging/lustre/lustre/lov/lproc_lov.c b/drivers/staging/lustre/lustre/lov/lproc_lov.c
index c993f25..c99f2f4 100644
--- a/drivers/staging/lustre/lustre/lov/lproc_lov.c
+++ b/drivers/staging/lustre/lustre/lov/lproc_lov.c
@@ -51,8 +51,9 @@ static int lov_stripesize_seq_show(struct seq_file *m, void *v)
 	return seq_printf(m, "%llu\n", desc->ld_default_stripe_size);
 }
 
-static ssize_t lov_stripesize_seq_write(struct file *file, const char *buffer,
-				    size_t count, loff_t *off)
+static ssize_t lov_stripesize_seq_write(struct file *file,
+				const char __user *buffer,
+				size_t count, loff_t *off)
 {
 	struct obd_device *dev = ((struct seq_file *)file->private_data)->private;
 	struct lov_desc *desc;
@@ -81,8 +82,9 @@ static int lov_stripeoffset_seq_show(struct seq_file *m, void *v)
 	return seq_printf(m, "%llu\n", desc->ld_default_stripe_offset);
 }
 
-static ssize_t lov_stripeoffset_seq_write(struct file *file, const char *buffer,
-				      size_t count, loff_t *off)
+static ssize_t lov_stripeoffset_seq_write(struct file *file,
+				const char __user *buffer,
+				size_t count, loff_t *off)
 {
 	struct obd_device *dev = ((struct seq_file *)file->private_data)->private;
 	struct lov_desc *desc;
@@ -110,8 +112,9 @@ static int lov_stripetype_seq_show(struct seq_file *m, void *v)
 	return seq_printf(m, "%u\n", desc->ld_pattern);
 }
 
-static ssize_t lov_stripetype_seq_write(struct file *file, const char *buffer,
-				    size_t count, loff_t *off)
+static ssize_t lov_stripetype_seq_write(struct file *file,
+				const char __user *buffer,
+				size_t count, loff_t *off)
 {
 	struct obd_device *dev = ((struct seq_file *)file->private_data)->private;
 	struct lov_desc *desc;
@@ -140,8 +143,9 @@ static int lov_stripecount_seq_show(struct seq_file *m, void *v)
 			(__s16)(desc->ld_default_stripe_count + 1) - 1);
 }
 
-static ssize_t lov_stripecount_seq_write(struct file *file, const char *buffer,
-				     size_t count, loff_t *off)
+static ssize_t lov_stripecount_seq_write(struct file *file,
+				const char __user *buffer,
+				size_t count, loff_t *off)
 {
 	struct obd_device *dev = ((struct seq_file *)file->private_data)->private;
 	struct lov_desc *desc;
diff --git a/drivers/staging/lustre/lustre/mdc/lproc_mdc.c b/drivers/staging/lustre/lustre/mdc/lproc_mdc.c
index 16341c8..c420219 100644
--- a/drivers/staging/lustre/lustre/mdc/lproc_mdc.c
+++ b/drivers/staging/lustre/lustre/mdc/lproc_mdc.c
@@ -52,7 +52,7 @@ static int mdc_max_rpcs_in_flight_seq_show(struct seq_file *m, void *v)
 }
 
 static ssize_t mdc_max_rpcs_in_flight_seq_write(struct file *file,
-						const char *buffer,
+						const char __user *buffer,
 						size_t count,
 						loff_t *off)
 {
@@ -82,8 +82,9 @@ static int mdc_kuc_open(struct inode *inode, struct file *file)
 }
 
 /* temporary for testing */
-static ssize_t mdc_kuc_write(struct file *file, const char *buffer,
-			     size_t count, loff_t *off)
+static ssize_t mdc_kuc_write(struct file *file,
+				const char __user *buffer,
+				size_t count, loff_t *off)
 {
 	struct obd_device *obd =
 			((struct seq_file *)file->private_data)->private;
diff --git a/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c b/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c
index 66ceab2..b5007b8 100644
--- a/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c
+++ b/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c
@@ -272,8 +272,9 @@ static int obd_proc_jobid_var_seq_show(struct seq_file *m, void *v)
 	return seq_printf(m, "%s\n", obd_jobid_var);
 }
 
-static ssize_t obd_proc_jobid_var_seq_write(struct file *file, const char *buffer,
-					size_t count, loff_t *off)
+static ssize_t obd_proc_jobid_var_seq_write(struct file *file,
+				const char __user *buffer,
+				size_t count, loff_t *off)
 {
 	if (!count || count > JOBSTATS_JOBID_VAR_MAX_LEN)
 		return -EINVAL;
diff --git a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
index 3b7dfc3..f78a241 100644
--- a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
+++ b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
@@ -1849,7 +1849,7 @@ int lprocfs_seq_read_frac_helper(struct seq_file *m, long val, int mult)
 }
 EXPORT_SYMBOL(lprocfs_seq_read_frac_helper);
 
-int lprocfs_write_u64_helper(const char *buffer, unsigned long count,
+int lprocfs_write_u64_helper(const char __user *buffer, unsigned long count,
 			     __u64 *val)
 {
 	return lprocfs_write_frac_u64_helper(buffer, count, val, 1);
diff --git a/drivers/staging/lustre/lustre/osc/lproc_osc.c b/drivers/staging/lustre/lustre/osc/lproc_osc.c
index 9f719bc..8e22e45 100644
--- a/drivers/staging/lustre/lustre/osc/lproc_osc.c
+++ b/drivers/staging/lustre/lustre/osc/lproc_osc.c
@@ -53,8 +53,9 @@ static int osc_active_seq_show(struct seq_file *m, void *v)
 	return rc;
 }
 
-static ssize_t osc_active_seq_write(struct file *file, const char *buffer,
-				    size_t count, loff_t *off)
+static ssize_t osc_active_seq_write(struct file *file,
+				const char __user *buffer,
+				size_t count, loff_t *off)
 {
 	struct obd_device *dev = ((struct seq_file *)file->private_data)->private;
 	int val, rc;
@@ -88,7 +89,8 @@ static int osc_max_rpcs_in_flight_seq_show(struct seq_file *m, void *v)
 }
 
 static ssize_t osc_max_rpcs_in_flight_seq_write(struct file *file,
-			const char *buffer, size_t count, loff_t *off)
+			const char __user *buffer,
+			size_t count, loff_t *off)
 {
 	struct obd_device *dev = ((struct seq_file *)file->private_data)->private;
 	struct client_obd *cli = &dev->u.cli;
@@ -130,8 +132,9 @@ static int osc_max_dirty_mb_seq_show(struct seq_file *m, void *v)
 	return lprocfs_seq_read_frac_helper(m, val, mult);
 }
 
-static ssize_t osc_max_dirty_mb_seq_write(struct file *file, const char *buffer,
-				      size_t count, loff_t *off)
+static ssize_t osc_max_dirty_mb_seq_write(struct file *file,
+				const char __user *buffer,
+				size_t count, loff_t *off)
 {
 	struct obd_device *dev = ((struct seq_file *)file->private_data)->private;
 	struct client_obd *cli = &dev->u.cli;
@@ -233,8 +236,9 @@ static int osc_cur_grant_bytes_seq_show(struct seq_file *m, void *v)
 	return rc;
 }
 
-static ssize_t osc_cur_grant_bytes_seq_write(struct file *file, const char *buffer,
-				  size_t count, loff_t *off)
+static ssize_t osc_cur_grant_bytes_seq_write(struct file *file,
+				const char __user *buffer,
+				size_t count, loff_t *off)
 {
 	struct obd_device *obd = ((struct seq_file *)file->private_data)->private;
 	struct client_obd *cli = &obd->u.cli;
@@ -290,7 +294,8 @@ static int osc_grant_shrink_interval_seq_show(struct seq_file *m, void *v)
 }
 
 static ssize_t osc_grant_shrink_interval_seq_write(struct file *file,
-				const char *buffer, size_t count, loff_t *off)
+				const char __user *buffer,
+				size_t count, loff_t *off)
 {
 	struct obd_device *obd = ((struct seq_file *)file->private_data)->private;
 	int val, rc;
@@ -322,8 +327,9 @@ static int osc_checksum_seq_show(struct seq_file *m, void *v)
 			obd->u.cli.cl_checksum ? 1 : 0);
 }
 
-static ssize_t osc_checksum_seq_write(struct file *file, const char *buffer,
-			   size_t count, loff_t *off)
+static ssize_t osc_checksum_seq_write(struct file *file,
+				const char __user *buffer,
+				size_t count, loff_t *off)
 {
 	struct obd_device *obd = ((struct seq_file *)file->private_data)->private;
 	int val, rc;
@@ -362,7 +368,8 @@ static int osc_checksum_type_seq_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static ssize_t osc_checksum_type_seq_write(struct file *file, const char *buffer,
+static ssize_t osc_checksum_type_seq_write(struct file *file,
+				const char __user *buffer,
 				size_t count, loff_t *off)
 {
 	struct obd_device *obd = ((struct seq_file *)file->private_data)->private;
@@ -401,8 +408,9 @@ static int osc_resend_count_seq_show(struct seq_file *m, void *v)
 	return seq_printf(m, "%u\n", atomic_read(&obd->u.cli.cl_resends));
 }
 
-static ssize_t osc_resend_count_seq_write(struct file *file, const char *buffer,
-			       size_t count, loff_t *off)
+static ssize_t osc_resend_count_seq_write(struct file *file,
+				const char __user *buffer,
+				size_t count, loff_t *off)
 {
 	struct obd_device *obd = ((struct seq_file *)file->private_data)->private;
 	int val, rc;
@@ -428,8 +436,9 @@ static int osc_contention_seconds_seq_show(struct seq_file *m, void *v)
 	return seq_printf(m, "%u\n", od->od_contention_time);
 }
 
-static ssize_t osc_contention_seconds_seq_write(struct file *file, const char *buffer,
-				     size_t count, loff_t *off)
+static ssize_t osc_contention_seconds_seq_write(struct file *file,
+					const char __user *buffer,
+					size_t count, loff_t *off)
 {
 	struct obd_device *obd = ((struct seq_file *)file->private_data)->private;
 	struct osc_device *od  = obd2osc_dev(obd);
@@ -447,8 +456,9 @@ static int osc_lockless_truncate_seq_show(struct seq_file *m, void *v)
 	return seq_printf(m, "%u\n", od->od_lockless_truncate);
 }
 
-static ssize_t osc_lockless_truncate_seq_write(struct file *file, const char *buffer,
-				    size_t count, loff_t *off)
+static ssize_t osc_lockless_truncate_seq_write(struct file *file,
+					const char __user *buffer,
+					size_t count, loff_t *off)
 {
 	struct obd_device *obd = ((struct seq_file *)file->private_data)->private;
 	struct osc_device *od  = obd2osc_dev(obd);
@@ -472,7 +482,8 @@ static int osc_obd_max_pages_per_rpc_seq_show(struct seq_file *m, void *v)
 }
 
 static ssize_t osc_obd_max_pages_per_rpc_seq_write(struct file *file,
-				const char *buffer, size_t count, loff_t *off)
+				const char __user *buffer,
+				size_t count, loff_t *off)
 {
 	struct obd_device *dev = ((struct seq_file *)file->private_data)->private;
 	struct client_obd *cli = &dev->u.cli;
@@ -664,8 +675,9 @@ static int osc_rpc_stats_seq_show(struct seq_file *seq, void *v)
 }
 #undef pct
 
-static ssize_t osc_rpc_stats_seq_write(struct file *file, const char *buf,
-				       size_t len, loff_t *off)
+static ssize_t osc_rpc_stats_seq_write(struct file *file,
+				const char __user *buf,
+				size_t len, loff_t *off)
 {
 	struct seq_file *seq = file->private_data;
 	struct obd_device *dev = seq->private;
@@ -702,8 +714,9 @@ static int osc_stats_seq_show(struct seq_file *seq, void *v)
 	return 0;
 }
 
-static ssize_t osc_stats_seq_write(struct file *file, const char *buf,
-				   size_t len, loff_t *off)
+static ssize_t osc_stats_seq_write(struct file *file,
+				const char __user *buf,
+				size_t len, loff_t *off)
 {
 	struct seq_file *seq = file->private_data;
 	struct obd_device *dev = seq->private;
diff --git a/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c b/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c
index 4011e00..7b22afd 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c
@@ -284,8 +284,9 @@ ptlrpc_lprocfs_req_history_max_seq_show(struct seq_file *m, void *n)
 }
 
 static ssize_t
-ptlrpc_lprocfs_req_history_max_seq_write(struct file *file, const char *buffer,
-					 size_t count, loff_t *off)
+ptlrpc_lprocfs_req_history_max_seq_write(struct file *file,
+					const char __user *buffer,
+					size_t count, loff_t *off)
 {
 	struct ptlrpc_service *svc = ((struct seq_file *)file->private_data)->private;
 	int			    bufpages;
@@ -329,8 +330,9 @@ ptlrpc_lprocfs_threads_min_seq_show(struct seq_file *m, void *n)
 }
 
 static ssize_t
-ptlrpc_lprocfs_threads_min_seq_write(struct file *file, const char *buffer,
-				     size_t count, loff_t *off)
+ptlrpc_lprocfs_threads_min_seq_write(struct file *file,
+					const char __user *buffer,
+					size_t count, loff_t *off)
 {
 	struct ptlrpc_service *svc = ((struct seq_file *)file->private_data)->private;
 	int	val;
@@ -381,8 +383,9 @@ ptlrpc_lprocfs_threads_max_seq_show(struct seq_file *m, void *n)
 }
 
 static ssize_t
-ptlrpc_lprocfs_threads_max_seq_write(struct file *file, const char *buffer,
-				     size_t count, loff_t *off)
+ptlrpc_lprocfs_threads_max_seq_write(struct file *file,
+				const char __user *buffer,
+				size_t count, loff_t *off)
 {
 	struct ptlrpc_service *svc = ((struct seq_file *)file->private_data)->private;
 	int	val;
@@ -1025,7 +1028,7 @@ static int ptlrpc_lprocfs_hp_ratio_seq_show(struct seq_file *m, void *v)
 }
 
 static ssize_t ptlrpc_lprocfs_hp_ratio_seq_write(struct file *file,
-					     const char *buffer,
+					     const char __user *buffer,
 					     size_t count,
 					     loff_t *off)
 {
@@ -1175,7 +1178,7 @@ EXPORT_SYMBOL(ptlrpc_lprocfs_unregister_obd);
 
 #define BUFLEN (UUID_MAX + 5)
 
-int lprocfs_wr_evict_client(struct file *file, const char *buffer,
+int lprocfs_wr_evict_client(struct file *file, const char __user *buffer,
 			    size_t count, loff_t *off)
 {
 	struct obd_device *obd = ((struct seq_file *)file->private_data)->private;
@@ -1223,7 +1226,7 @@ EXPORT_SYMBOL(lprocfs_wr_evict_client);
 
 #undef BUFLEN
 
-int lprocfs_wr_ping(struct file *file, const char *buffer,
+int lprocfs_wr_ping(struct file *file, const char __user *buffer,
 		    size_t count, loff_t *off)
 {
 	struct obd_device *obd = ((struct seq_file *)file->private_data)->private;
@@ -1251,7 +1254,7 @@ EXPORT_SYMBOL(lprocfs_wr_ping);
  * The connection UUID is a node's primary NID. For example,
  * "echo connection=192.168.0.1@tcp0::instance > .../import".
  */
-int lprocfs_wr_import(struct file *file, const char *buffer,
+int lprocfs_wr_import(struct file *file, const char __user *buffer,
 		      size_t count, loff_t *off)
 {
 	struct obd_device *obd = ((struct seq_file *)file->private_data)->private;
@@ -1329,7 +1332,7 @@ int lprocfs_rd_pinger_recov(struct seq_file *m, void *n)
 }
 EXPORT_SYMBOL(lprocfs_rd_pinger_recov);
 
-int lprocfs_wr_pinger_recov(struct file *file, const char *buffer,
+int lprocfs_wr_pinger_recov(struct file *file, const char __user *buffer,
 		      size_t count, loff_t *off)
 {
 	struct obd_device *obd = ((struct seq_file *)file->private_data)->private;
-- 
2.1.1

