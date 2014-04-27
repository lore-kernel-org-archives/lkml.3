Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611AbaD0RJX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 13:09:23 -0400
Received: from linuxhacker.ru ([217.76.32.60]:48161 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754565AbaD0RIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 13:08:51 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Oleg Drokin <green@linuxhacker.ru>, Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 46/47] staging/lustre: Fix unsafe userspace access in many proc files
Date: Sun, 27 Apr 2014 13:07:10 -0400
Message-Id: <1398618431-29757-47-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
References: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apparently we are pretty bad about verifying our buffers passed
from userspace.

Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
Reviewed-on: http://review.whamcloud.com/9059
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4563
Reviewed-by: Dmitry Eremin <dmitry.eremin@intel.com>
Reviewed-by: James Simmons <uja.ornl@gmail.com>
---
 drivers/staging/lustre/lustre/fid/lproc_fid.c      | 41 +++++++---
 .../lustre/lustre/include/lustre/lustre_idl.h      |  2 +-
 drivers/staging/lustre/lustre/llite/lproc_llite.c  | 91 +++++++++++++++++-----
 .../lustre/lustre/obdclass/linux/linux-module.c    |  9 ++-
 drivers/staging/lustre/lustre/osc/lproc_osc.c      | 16 +++-
 5 files changed, 124 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/lustre/lustre/fid/lproc_fid.c b/drivers/staging/lustre/lustre/fid/lproc_fid.c
index ddd813c..6f5674d 100644
--- a/drivers/staging/lustre/lustre/fid/lproc_fid.c
+++ b/drivers/staging/lustre/lustre/fid/lproc_fid.c
@@ -54,32 +54,49 @@
 #include <lustre_fid.h>
 #include "fid_internal.h"
 
+/* Format: [0x64BIT_INT - 0x64BIT_INT] + 32 bytes just in case */
+#define MAX_FID_RANGE_STRLEN (32 + 2 * 2 * sizeof(__u64))
 /*
  * Note: this function is only used for testing, it is no safe for production
  * use.
  */
-static int
-lprocfs_fid_write_common(const char *buffer, unsigned long count,
-			 struct lu_seq_range *range)
+static int lprocfs_fid_write_common(const char __user *buffer, size_t count,
+				    struct lu_seq_range *range)
 {
 	struct lu_seq_range tmp;
 	int rc;
+	char kernbuf[MAX_FID_RANGE_STRLEN];
 
 	LASSERT(range != NULL);
 
-	rc = sscanf(buffer, "[%llx - %llx]\n",
+	if (count >= sizeof(kernbuf))
+		return -EINVAL;
+
+	if (copy_from_user(kernbuf, buffer, count))
+		return -EFAULT;
+
+	kernbuf[count] = 0;
+
+	if (count == 5 && strcmp(kernbuf, "clear") == 0) {
+		memset(range, 0, sizeof(*range));
+		return count;
+	}
+
+	/* of the form "[0x0000000240000400 - 0x000000028000400]" */
+	rc = sscanf(kernbuf, "[%llx - %llx]\n",
 		    (long long unsigned *)&tmp.lsr_start,
 		    (long long unsigned *)&tmp.lsr_end);
-	if (rc != 2 || !range_is_sane(&tmp) || range_is_zero(&tmp))
+	if (!range_is_sane(&tmp) || range_is_zero(&tmp) ||
+	    tmp.lsr_start < range->lsr_start || tmp.lsr_end > range->lsr_end)
 		return -EINVAL;
 	*range = tmp;
-	return 0;
+	return count;
 }
 
 /* Client side procfs stuff */
-static ssize_t
-lprocfs_fid_space_seq_write(struct file *file, const char *buffer,
-			    size_t count, loff_t *off)
+static ssize_t lprocfs_fid_space_seq_write(struct file *file,
+					   const char __user *buffer,
+					   size_t count, loff_t *off)
 {
 	struct lu_client_seq *seq = ((struct seq_file *)file->private_data)->private;
 	int rc;
@@ -114,9 +131,9 @@ lprocfs_fid_space_seq_show(struct seq_file *m, void *unused)
 	return rc;
 }
 
-static ssize_t
-lprocfs_fid_width_seq_write(struct file *file, const char *buffer,
-			    size_t count, loff_t *off)
+static ssize_t lprocfs_fid_width_seq_write(struct file *file,
+					   const char __user *buffer,
+					   size_t count, loff_t *off)
 {
 	struct lu_client_seq *seq = ((struct seq_file *)file->private_data)->private;
 	__u64  max;
diff --git a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
index abd29bf..83014c9 100644
--- a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
+++ b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
@@ -265,7 +265,7 @@ static inline __u64 range_space(const struct lu_seq_range *range)
 
 static inline void range_init(struct lu_seq_range *range)
 {
-	range->lsr_start = range->lsr_end = range->lsr_index = 0;
+	memset(range, 0, sizeof(*range));
 }
 
 /**
diff --git a/drivers/staging/lustre/lustre/llite/lproc_llite.c b/drivers/staging/lustre/lustre/llite/lproc_llite.c
index 6d70c65..77ee9e5 100644
--- a/drivers/staging/lustre/lustre/llite/lproc_llite.c
+++ b/drivers/staging/lustre/lustre/llite/lproc_llite.c
@@ -367,8 +367,9 @@ static int ll_max_cached_mb_seq_show(struct seq_file *m, void *v)
 			cache->ccc_lru_shrinkers);
 }
 
-static ssize_t ll_max_cached_mb_seq_write(struct file *file, const char *buffer,
-				      size_t count, loff_t *off)
+static ssize_t ll_max_cached_mb_seq_write(struct file *file,
+					  const char __user *buffer,
+					  size_t count, loff_t *off)
 {
 	struct super_block *sb = ((struct seq_file *)file->private_data)->private;
 	struct ll_sb_info *sbi = ll_s2sbi(sb);
@@ -376,9 +377,18 @@ static ssize_t ll_max_cached_mb_seq_write(struct file *file, const char *buffer,
 	int mult, rc, pages_number;
 	int diff = 0;
 	int nrpages = 0;
+	char kernbuf[128];
+
+	if (count >= sizeof(kernbuf))
+		return -EINVAL;
+
+	if (copy_from_user(kernbuf, buffer, count))
+		return -EFAULT;
+	kernbuf[count] = 0;
 
 	mult = 1 << (20 - PAGE_CACHE_SHIFT);
-	buffer = lprocfs_find_named_value(buffer, "max_cached_mb:", &count);
+	buffer += lprocfs_find_named_value(kernbuf, "max_cached_mb:", &count) -
+		  kernbuf;
 	rc = lprocfs_write_frac_helper(buffer, count, &pages_number, mult);
 	if (rc)
 		return rc;
@@ -1163,7 +1173,8 @@ static int ll_rw_extents_stats_pp_seq_show(struct seq_file *seq, void *v)
 }
 
 static ssize_t ll_rw_extents_stats_pp_seq_write(struct file *file,
-						const char *buf, size_t len,
+						const char __user *buf,
+						size_t len,
 						loff_t *off)
 {
 	struct seq_file *seq = file->private_data;
@@ -1172,10 +1183,24 @@ static ssize_t ll_rw_extents_stats_pp_seq_write(struct file *file,
 	int i;
 	int value = 1, rc = 0;
 
+	if (len == 0)
+		return -EINVAL;
+
 	rc = lprocfs_write_helper(buf, len, &value);
-	if (rc < 0 && (strcmp(buf, "disabled") == 0 ||
-		       strcmp(buf, "Disabled") == 0))
-		value = 0;
+	if (rc < 0 && len < 16) {
+		char kernbuf[16];
+
+		if (copy_from_user(kernbuf, buf, len))
+			return -EFAULT;
+		kernbuf[len] = 0;
+
+		if (kernbuf[len - 1] == '\n')
+			kernbuf[len - 1] = 0;
+
+		if (strcmp(kernbuf, "disabled") == 0 ||
+		    strcmp(kernbuf, "Disabled") == 0)
+			value = 0;
+	}
 
 	if (value == 0)
 		sbi->ll_rw_stats_on = 0;
@@ -1222,8 +1247,9 @@ static int ll_rw_extents_stats_seq_show(struct seq_file *seq, void *v)
 	return 0;
 }
 
-static ssize_t ll_rw_extents_stats_seq_write(struct file *file, const char *buf,
-					size_t len, loff_t *off)
+static ssize_t ll_rw_extents_stats_seq_write(struct file *file,
+					     const char __user *buf,
+					     size_t len, loff_t *off)
 {
 	struct seq_file *seq = file->private_data;
 	struct ll_sb_info *sbi = seq->private;
@@ -1231,15 +1257,30 @@ static ssize_t ll_rw_extents_stats_seq_write(struct file *file, const char *buf,
 	int i;
 	int value = 1, rc = 0;
 
+	if (len == 0)
+		return -EINVAL;
+
 	rc = lprocfs_write_helper(buf, len, &value);
-	if (rc < 0 && (strcmp(buf, "disabled") == 0 ||
-		       strcmp(buf, "Disabled") == 0))
-		value = 0;
+	if (rc < 0 && len < 16) {
+		char kernbuf[16];
+
+		if (copy_from_user(kernbuf, buf, len))
+			return -EFAULT;
+		kernbuf[len] = 0;
+
+		if (kernbuf[len - 1] == '\n')
+			kernbuf[len - 1] = 0;
+
+		if (strcmp(kernbuf, "disabled") == 0 ||
+		    strcmp(kernbuf, "Disabled") == 0)
+			value = 0;
+	}
 
 	if (value == 0)
 		sbi->ll_rw_stats_on = 0;
 	else
 		sbi->ll_rw_stats_on = 1;
+
 	spin_lock(&sbi->ll_pp_extent_lock);
 	for (i = 0; i <= LL_PROCESS_HIST_MAX; i++) {
 		io_extents->pp_extents[i].pid = 0;
@@ -1250,7 +1291,6 @@ static ssize_t ll_rw_extents_stats_seq_write(struct file *file, const char *buf,
 
 	return len;
 }
-
 LPROC_SEQ_FOPS(ll_rw_extents_stats);
 
 void ll_rw_stats_tally(struct ll_sb_info *sbi, pid_t pid,
@@ -1410,8 +1450,9 @@ static int ll_rw_offset_stats_seq_show(struct seq_file *seq, void *v)
 	return 0;
 }
 
-static ssize_t ll_rw_offset_stats_seq_write(struct file *file, const char *buf,
-				       size_t len, loff_t *off)
+static ssize_t ll_rw_offset_stats_seq_write(struct file *file,
+					    const char __user *buf,
+					    size_t len, loff_t *off)
 {
 	struct seq_file *seq = file->private_data;
 	struct ll_sb_info *sbi = seq->private;
@@ -1419,11 +1460,25 @@ static ssize_t ll_rw_offset_stats_seq_write(struct file *file, const char *buf,
 	struct ll_rw_process_info *offset_info = sbi->ll_rw_offset_info;
 	int value = 1, rc = 0;
 
+	if (len == 0)
+		return -EINVAL;
+
 	rc = lprocfs_write_helper(buf, len, &value);
 
-	if (rc < 0 && (strcmp(buf, "disabled") == 0 ||
-			   strcmp(buf, "Disabled") == 0))
-		value = 0;
+	if (rc < 0 && len < 16) {
+		char kernbuf[16];
+
+		if (copy_from_user(kernbuf, buf, len))
+			return -EFAULT;
+		kernbuf[len] = 0;
+
+		if (kernbuf[len - 1] == '\n')
+			kernbuf[len - 1] = 0;
+
+		if (strcmp(kernbuf, "disabled") == 0 ||
+		    strcmp(kernbuf, "Disabled") == 0)
+			value = 0;
+	}
 
 	if (value == 0)
 		sbi->ll_rw_stats_on = 0;
diff --git a/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c b/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c
index dec1037..0334882 100644
--- a/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c
+++ b/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c
@@ -279,8 +279,15 @@ static ssize_t obd_proc_jobid_var_seq_write(struct file *file, const char *buffe
 		return -EINVAL;
 
 	memset(obd_jobid_var, 0, JOBSTATS_JOBID_VAR_MAX_LEN + 1);
+
+	/* This might leave the var invalid on error, which is probably fine.*/
+	if (copy_from_user(obd_jobid_var, buffer, count))
+		return -EFAULT;
+
 	/* Trim the trailing '\n' if any */
-	memcpy(obd_jobid_var, buffer, count - (buffer[count - 1] == '\n'));
+	if (obd_jobid_var[count - 1] == '\n')
+		obd_jobid_var[count - 1] = 0;
+
 	return count;
 }
 LPROC_SEQ_FOPS(obd_proc_jobid_var);
diff --git a/drivers/staging/lustre/lustre/osc/lproc_osc.c b/drivers/staging/lustre/lustre/osc/lproc_osc.c
index 0b59fc1..358e32c 100644
--- a/drivers/staging/lustre/lustre/osc/lproc_osc.c
+++ b/drivers/staging/lustre/lustre/osc/lproc_osc.c
@@ -174,15 +174,25 @@ static int osc_cached_mb_seq_show(struct seq_file *m, void *v)
 }
 
 /* shrink the number of caching pages to a specific number */
-static ssize_t osc_cached_mb_seq_write(struct file *file, const char *buffer,
-				   size_t count, loff_t *off)
+static ssize_t osc_cached_mb_seq_write(struct file *file,
+				       const char __user *buffer,
+				       size_t count, loff_t *off)
 {
 	struct obd_device *dev = ((struct seq_file *)file->private_data)->private;
 	struct client_obd *cli = &dev->u.cli;
 	int pages_number, mult, rc;
+	char kernbuf[128];
+
+	if (count >= sizeof(kernbuf))
+		return -EINVAL;
+
+	if (copy_from_user(kernbuf, buffer, count))
+		return -EFAULT;
+	kernbuf[count] = 0;
 
 	mult = 1 << (20 - PAGE_CACHE_SHIFT);
-	buffer = lprocfs_find_named_value(buffer, "used_mb:", &count);
+	buffer += lprocfs_find_named_value(kernbuf, "used_mb:", &count) -
+		  kernbuf;
 	rc = lprocfs_write_frac_helper(buffer, count, &pages_number, mult);
 	if (rc)
 		return rc;
-- 
1.8.5.3

