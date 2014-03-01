Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440AbaCACVN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 21:21:13 -0500
Received: from linuxhacker.ru ([217.76.32.60]:42584 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752815AbaCACRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 21:17:15 -0500
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: "John L. Hammond" <john.hammond@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 06/17] lustre/clio: honor O_NOATIME
Date: Fri, 28 Feb 2014 21:16:35 -0500
Message-Id: <1393640206-20286-7-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393640206-20286-1-git-send-email-green@linuxhacker.ru>
References: <1393640206-20286-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John L. Hammond" <john.hammond@intel.com>

Add a ci_noatime bit to struct cl_io. In ll_io_init() set this bit if
O_NOATIME is set in f_flags. Ensure that this bit is propagated down
to lower layers. In osc_io_read_start() don't update atime if this bit
is set. Add sanity test 39n to check that passing O_NOATIME to open()
is honored.

Signed-off-by: John L. Hammond <john.hammond@intel.com>
Reviewed-on: http://review.whamcloud.com/7442
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3832
Reviewed-by: Jinshan Xiong <jinshan.xiong@intel.com>
Reviewed-by: Lai Siyao <lai.siyao@intel.com>
Tested-by: Maloo <whamcloud.maloo@gmail.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/include/cl_object.h |  6 ++++-
 drivers/staging/lustre/lustre/llite/file.c        | 29 +++++++++++++++++++++++
 drivers/staging/lustre/lustre/lov/lov_io.c        |  1 +
 drivers/staging/lustre/lustre/osc/osc_io.c        | 14 ++++-------
 4 files changed, 40 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/cl_object.h b/drivers/staging/lustre/lustre/include/cl_object.h
index 4d692dc..76e1b68 100644
--- a/drivers/staging/lustre/lustre/include/cl_object.h
+++ b/drivers/staging/lustre/lustre/include/cl_object.h
@@ -2392,7 +2392,11 @@ struct cl_io {
 	/**
 	 * file is released, restore has to to be triggered by vvp layer
 	 */
-			     ci_restore_needed:1;
+			     ci_restore_needed:1,
+	/**
+	 * O_NOATIME
+	 */
+			     ci_noatime:1;
 	/**
 	 * Number of pages owned by this IO. For invariant checking.
 	 */
diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index 36c54aa..362f5ec 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -1035,6 +1035,33 @@ int ll_glimpse_ioctl(struct ll_sb_info *sbi, struct lov_stripe_md *lsm,
 	return rc;
 }
 
+static bool file_is_noatime(const struct file *file)
+{
+	const struct vfsmount *mnt = file->f_path.mnt;
+	const struct inode *inode = file->f_path.dentry->d_inode;
+
+	/* Adapted from file_accessed() and touch_atime().*/
+	if (file->f_flags & O_NOATIME)
+		return true;
+
+	if (inode->i_flags & S_NOATIME)
+		return true;
+
+	if (IS_NOATIME(inode))
+		return true;
+
+	if (mnt->mnt_flags & (MNT_NOATIME | MNT_READONLY))
+		return true;
+
+	if ((mnt->mnt_flags & MNT_NODIRATIME) && S_ISDIR(inode->i_mode))
+		return true;
+
+	if ((inode->i_sb->s_flags & MS_NODIRATIME) && S_ISDIR(inode->i_mode))
+		return true;
+
+	return false;
+}
+
 void ll_io_init(struct cl_io *io, const struct file *file, int write)
 {
 	struct inode *inode = file->f_dentry->d_inode;
@@ -1054,6 +1081,8 @@ void ll_io_init(struct cl_io *io, const struct file *file, int write)
 	} else if (file->f_flags & O_APPEND) {
 		io->ci_lockreq = CILR_MANDATORY;
 	}
+
+	io->ci_noatime = file_is_noatime(file);
 }
 
 static ssize_t
diff --git a/drivers/staging/lustre/lustre/lov/lov_io.c b/drivers/staging/lustre/lustre/lov/lov_io.c
index 5a6ab70..65133ea 100644
--- a/drivers/staging/lustre/lustre/lov/lov_io.c
+++ b/drivers/staging/lustre/lustre/lov/lov_io.c
@@ -194,6 +194,7 @@ static int lov_io_sub_init(const struct lu_env *env, struct lov_io *lio,
 		sub_io->ci_lockreq = io->ci_lockreq;
 		sub_io->ci_type    = io->ci_type;
 		sub_io->ci_no_srvlock = io->ci_no_srvlock;
+		sub_io->ci_noatime = io->ci_noatime;
 
 		lov_sub_enter(sub);
 		result = cl_io_sub_init(sub->sub_env, sub_io,
diff --git a/drivers/staging/lustre/lustre/osc/osc_io.c b/drivers/staging/lustre/lustre/osc/osc_io.c
index 777ae24..5f3c545 100644
--- a/drivers/staging/lustre/lustre/osc/osc_io.c
+++ b/drivers/staging/lustre/lustre/osc/osc_io.c
@@ -512,19 +512,15 @@ static int osc_io_read_start(const struct lu_env *env,
 	struct osc_io    *oio   = cl2osc_io(env, slice);
 	struct cl_object *obj   = slice->cis_obj;
 	struct cl_attr   *attr  = &osc_env_info(env)->oti_attr;
-	int	      result = 0;
+	int rc = 0;
 
-	if (oio->oi_lockless == 0) {
+	if (oio->oi_lockless == 0 && !slice->cis_io->ci_noatime) {
 		cl_object_attr_lock(obj);
-		result = cl_object_attr_get(env, obj, attr);
-		if (result == 0) {
-			attr->cat_atime = LTIME_S(CURRENT_TIME);
-			result = cl_object_attr_set(env, obj, attr,
-						    CAT_ATIME);
-		}
+		attr->cat_atime = LTIME_S(CURRENT_TIME);
+		rc = cl_object_attr_set(env, obj, attr, CAT_ATIME);
 		cl_object_attr_unlock(obj);
 	}
-	return result;
+	return rc;
 }
 
 static int osc_io_write_start(const struct lu_env *env,
-- 
1.8.5.3

