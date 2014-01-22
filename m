Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951AbaAVNtu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 08:49:50 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:54432 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755750AbaAVNtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 08:49:49 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 6/6] staging/lustre/libcfs: remove cfs_capable
Date: Wed, 22 Jan 2014 21:47:37 +0800
Message-Id: <1390398457-31140-6-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1390398457-31140-1-git-send-email-bergwolf@gmail.com>
References: <1390398457-31140-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 .../staging/lustre/include/linux/libcfs/curproc.h  |    1 -
 .../lustre/lustre/libcfs/linux/linux-curproc.c     |    6 ------
 .../lustre/lustre/libcfs/linux/linux-module.c      |    4 ++--
 drivers/staging/lustre/lustre/llite/dir.c          |    8 ++++----
 drivers/staging/lustre/lustre/llite/file.c         |   10 +++++-----
 drivers/staging/lustre/lustre/llite/llite_lib.c    |    2 +-
 drivers/staging/lustre/lustre/llite/xattr.c        |    2 +-
 .../lustre/lustre/obdclass/linux/linux-module.c    |    2 +-
 drivers/staging/lustre/lustre/obdclass/obdo.c      |    4 ++--
 .../staging/lustre/lustre/obdecho/echo_client.c    |   16 ++++++++--------
 drivers/staging/lustre/lustre/osc/osc_cache.c      |    4 ++--
 drivers/staging/lustre/lustre/osc/osc_io.c         |    2 +-
 drivers/staging/lustre/lustre/osc/osc_page.c       |    2 +-
 13 files changed, 28 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/lustre/include/linux/libcfs/curproc.h b/drivers/staging/lustre/include/linux/libcfs/curproc.h
index d12cfb1..8fd47c9 100644
--- a/drivers/staging/lustre/include/linux/libcfs/curproc.h
+++ b/drivers/staging/lustre/include/linux/libcfs/curproc.h
@@ -84,7 +84,6 @@ void cfs_cap_raise(cfs_cap_t cap);
 void cfs_cap_lower(cfs_cap_t cap);
 int cfs_cap_raised(cfs_cap_t cap);
 cfs_cap_t cfs_curproc_cap_pack(void);
-int cfs_capable(cfs_cap_t cap);
 
 /* __LIBCFS_CURPROC_H__ */
 #endif
diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c
index 8b3af7f..6d0bd22 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c
@@ -96,11 +96,6 @@ cfs_cap_t cfs_curproc_cap_pack(void)
 	return cap;
 }
 
-int cfs_capable(cfs_cap_t cap)
-{
-	return capable(cap);
-}
-
 static int cfs_access_process_vm(struct task_struct *tsk, unsigned long addr,
 				 void *buf, int len, int write)
 {
@@ -257,7 +252,6 @@ EXPORT_SYMBOL(cfs_cap_raise);
 EXPORT_SYMBOL(cfs_cap_lower);
 EXPORT_SYMBOL(cfs_cap_raised);
 EXPORT_SYMBOL(cfs_curproc_cap_pack);
-EXPORT_SYMBOL(cfs_capable);
 
 /*
  * Local variables:
diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-module.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-module.c
index 55296a3..e6eae06 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-module.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-module.c
@@ -150,12 +150,12 @@ static long libcfs_ioctl(struct file *file,
 	/* Handle platform-dependent IOC requests */
 	switch (cmd) {
 	case IOC_LIBCFS_PANIC:
-		if (!cfs_capable(CFS_CAP_SYS_BOOT))
+		if (!capable(CFS_CAP_SYS_BOOT))
 			return (-EPERM);
 		panic("debugctl-invoked panic");
 		return (0);
 	case IOC_LIBCFS_MEMHOG:
-		if (!cfs_capable(CFS_CAP_SYS_ADMIN))
+		if (!capable(CFS_CAP_SYS_ADMIN))
 			return -EPERM;
 		/* go thought */
 	}
diff --git a/drivers/staging/lustre/lustre/llite/dir.c b/drivers/staging/lustre/lustre/llite/dir.c
index 1b217c8..a6860e8 100644
--- a/drivers/staging/lustre/lustre/llite/dir.c
+++ b/drivers/staging/lustre/lustre/llite/dir.c
@@ -1085,7 +1085,7 @@ static int quotactl_ioctl(struct ll_sb_info *sbi, struct if_quotactl *qctl)
 	case Q_QUOTAOFF:
 	case Q_SETQUOTA:
 	case Q_SETINFO:
-		if (!cfs_capable(CFS_CAP_SYS_ADMIN) ||
+		if (!capable(CFS_CAP_SYS_ADMIN) ||
 		    sbi->ll_flags & LL_SBI_RMT_CLIENT)
 			return -EPERM;
 		break;
@@ -1094,7 +1094,7 @@ static int quotactl_ioctl(struct ll_sb_info *sbi, struct if_quotactl *qctl)
 		      uid_eq(current_euid(), make_kuid(&init_user_ns, id))) ||
 		     (type == GRPQUOTA &&
 		      !in_egroup_p(make_kgid(&init_user_ns, id)))) &&
-		    (!cfs_capable(CFS_CAP_SYS_ADMIN) ||
+		    (!capable(CFS_CAP_SYS_ADMIN) ||
 		     sbi->ll_flags & LL_SBI_RMT_CLIENT))
 			return -EPERM;
 		break;
@@ -1602,7 +1602,7 @@ out_rmdir:
 		struct obd_quotactl *oqctl;
 		int error = 0;
 
-		if (!cfs_capable(CFS_CAP_SYS_ADMIN) ||
+		if (!capable(CFS_CAP_SYS_ADMIN) ||
 		    sbi->ll_flags & LL_SBI_RMT_CLIENT)
 			return -EPERM;
 
@@ -1626,7 +1626,7 @@ out_rmdir:
 	case OBD_IOC_POLL_QUOTACHECK: {
 		struct if_quotacheck *check;
 
-		if (!cfs_capable(CFS_CAP_SYS_ADMIN) ||
+		if (!capable(CFS_CAP_SYS_ADMIN) ||
 		    sbi->ll_flags & LL_SBI_RMT_CLIENT)
 			return -EPERM;
 
diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index c12821a..19125d5 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -1340,7 +1340,7 @@ static int ll_lov_recreate_obj(struct inode *inode, unsigned long arg)
 	struct ll_recreate_obj ucreat;
 	struct ost_id		oi;
 
-	if (!cfs_capable(CFS_CAP_SYS_ADMIN))
+	if (!capable(CFS_CAP_SYS_ADMIN))
 		return -EPERM;
 
 	if (copy_from_user(&ucreat, (struct ll_recreate_obj *)arg,
@@ -1358,7 +1358,7 @@ static int ll_lov_recreate_fid(struct inode *inode, unsigned long arg)
 	struct ost_id	oi;
 	obd_count	ost_idx;
 
-	if (!cfs_capable(CFS_CAP_SYS_ADMIN))
+	if (!capable(CFS_CAP_SYS_ADMIN))
 		return -EPERM;
 
 	if (copy_from_user(&fid, (struct lu_fid *)arg, sizeof(fid)))
@@ -1497,7 +1497,7 @@ static int ll_lov_setea(struct inode *inode, struct file *file,
 					    sizeof(struct lov_user_ost_data);
 	int			 rc;
 
-	if (!cfs_capable(CFS_CAP_SYS_ADMIN))
+	if (!capable(CFS_CAP_SYS_ADMIN))
 		return -EPERM;
 
 	OBD_ALLOC_LARGE(lump, lum_size);
@@ -1747,7 +1747,7 @@ int ll_fid2path(struct inode *inode, void *arg)
 	struct getinfo_fid2path	*gfout, *gfin;
 	int			 outsize, rc;
 
-	if (!cfs_capable(CFS_CAP_DAC_READ_SEARCH) &&
+	if (!capable(CFS_CAP_DAC_READ_SEARCH) &&
 	    !(ll_i2sbi(inode)->ll_flags & LL_SBI_USER_FID2PATH))
 		return -EPERM;
 
@@ -2093,7 +2093,7 @@ static int ll_hsm_state_set(struct inode *inode, struct hsm_state_set *hss)
 	/* Non-root users are forbidden to set or clear flags which are
 	 * NOT defined in HSM_USER_MASK. */
 	if (((hss->hss_setmask | hss->hss_clearmask) & ~HSM_USER_MASK) &&
-	    !cfs_capable(CFS_CAP_SYS_ADMIN))
+	    !capable(CFS_CAP_SYS_ADMIN))
 		return -EPERM;
 
 	op_data = ll_prep_md_op_data(NULL, inode, NULL, NULL, 0, 0,
diff --git a/drivers/staging/lustre/lustre/llite/llite_lib.c b/drivers/staging/lustre/lustre/llite/llite_lib.c
index b0b6941..85c01e1 100644
--- a/drivers/staging/lustre/lustre/llite/llite_lib.c
+++ b/drivers/staging/lustre/lustre/llite/llite_lib.c
@@ -1403,7 +1403,7 @@ int ll_setattr_raw(struct dentry *dentry, struct iattr *attr, bool hsm_import)
 	/* POSIX: check before ATTR_*TIME_SET set (from inode_change_ok) */
 	if (attr->ia_valid & TIMES_SET_FLAGS) {
 		if ((!uid_eq(current_fsuid(), inode->i_uid)) &&
-		    !cfs_capable(CFS_CAP_FOWNER))
+		    !capable(CFS_CAP_FOWNER))
 			return -EPERM;
 	}
 
diff --git a/drivers/staging/lustre/lustre/llite/xattr.c b/drivers/staging/lustre/lustre/llite/xattr.c
index 3a7d03c..af83580 100644
--- a/drivers/staging/lustre/lustre/llite/xattr.c
+++ b/drivers/staging/lustre/lustre/llite/xattr.c
@@ -95,7 +95,7 @@ int xattr_type_filter(struct ll_sb_info *sbi, int xattr_type)
 
 	if (xattr_type == XATTR_USER_T && !(sbi->ll_flags & LL_SBI_USER_XATTR))
 		return -EOPNOTSUPP;
-	if (xattr_type == XATTR_TRUSTED_T && !cfs_capable(CFS_CAP_SYS_ADMIN))
+	if (xattr_type == XATTR_TRUSTED_T && !capable(CFS_CAP_SYS_ADMIN))
 		return -EPERM;
 	if (xattr_type == XATTR_OTHER_T)
 		return -EOPNOTSUPP;
diff --git a/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c b/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c
index 121a856..ba20776 100644
--- a/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c
+++ b/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c
@@ -184,7 +184,7 @@ static long obd_class_ioctl(struct file *filp, unsigned int cmd,
 	int err = 0;
 
 	/* Allow non-root access for OBD_IOC_PING_TARGET - used by lfs check */
-	if (!cfs_capable(CFS_CAP_SYS_ADMIN) && (cmd != OBD_IOC_PING_TARGET))
+	if (!capable(CFS_CAP_SYS_ADMIN) && (cmd != OBD_IOC_PING_TARGET))
 		return err = -EACCES;
 	if ((cmd & 0xffffff00) == ((int)'T') << 8) /* ignore all tty ioctls */
 		return err = -ENOTTY;
diff --git a/drivers/staging/lustre/lustre/obdclass/obdo.c b/drivers/staging/lustre/lustre/obdclass/obdo.c
index 7099764..e9cd6db 100644
--- a/drivers/staging/lustre/lustre/obdclass/obdo.c
+++ b/drivers/staging/lustre/lustre/obdclass/obdo.c
@@ -233,7 +233,7 @@ void obdo_from_iattr(struct obdo *oa, struct iattr *attr, unsigned int ia_valid)
 		oa->o_mode = attr->ia_mode;
 		oa->o_valid |= OBD_MD_FLTYPE | OBD_MD_FLMODE;
 		if (!in_group_p(make_kgid(&init_user_ns, oa->o_gid)) &&
-		    !cfs_capable(CFS_CAP_FSETID))
+		    !capable(CFS_CAP_FSETID))
 			oa->o_mode &= ~S_ISGID;
 	}
 	if (ia_valid & ATTR_UID) {
@@ -282,7 +282,7 @@ void iattr_from_obdo(struct iattr *attr, struct obdo *oa, obd_flag valid)
 		attr->ia_mode = (attr->ia_mode & S_IFMT)|(oa->o_mode & ~S_IFMT);
 		attr->ia_valid |= ATTR_MODE;
 		if (!in_group_p(make_kgid(&init_user_ns, oa->o_gid)) &&
-		    !cfs_capable(CFS_CAP_FSETID))
+		    !capable(CFS_CAP_FSETID))
 			attr->ia_mode &= ~S_ISGID;
 	}
 	if (valid & OBD_MD_FLUID) {
diff --git a/drivers/staging/lustre/lustre/obdecho/echo_client.c b/drivers/staging/lustre/lustre/obdecho/echo_client.c
index 9b2dea2..268a202 100644
--- a/drivers/staging/lustre/lustre/obdecho/echo_client.c
+++ b/drivers/staging/lustre/lustre/obdecho/echo_client.c
@@ -2764,7 +2764,7 @@ echo_client_iocontrol(unsigned int cmd, struct obd_export *exp, int len,
 
 	switch (cmd) {
 	case OBD_IOC_CREATE:		    /* may create echo object */
-		if (!cfs_capable(CFS_CAP_SYS_ADMIN))
+		if (!capable(CFS_CAP_SYS_ADMIN))
 			GOTO (out, rc = -EPERM);
 
 		rc = echo_create_object(env, ed, 1, oa, data->ioc_pbuf1,
@@ -2778,7 +2778,7 @@ echo_client_iocontrol(unsigned int cmd, struct obd_export *exp, int len,
 		int dirlen;
 		__u64 id;
 
-		if (!cfs_capable(CFS_CAP_SYS_ADMIN))
+		if (!capable(CFS_CAP_SYS_ADMIN))
 			GOTO(out, rc = -EPERM);
 
 		count = data->ioc_count;
@@ -2806,7 +2806,7 @@ echo_client_iocontrol(unsigned int cmd, struct obd_export *exp, int len,
 		__u64	    seq;
 		int	      max_count;
 
-		if (!cfs_capable(CFS_CAP_SYS_ADMIN))
+		if (!capable(CFS_CAP_SYS_ADMIN))
 			GOTO(out, rc = -EPERM);
 
 		cl_env = cl_env_get(&refcheck);
@@ -2838,7 +2838,7 @@ echo_client_iocontrol(unsigned int cmd, struct obd_export *exp, int len,
 		GOTO(out, rc);
 	}
 	case OBD_IOC_DESTROY:
-		if (!cfs_capable(CFS_CAP_SYS_ADMIN))
+		if (!capable(CFS_CAP_SYS_ADMIN))
 			GOTO (out, rc = -EPERM);
 
 		rc = echo_get_object(&eco, ed, oa);
@@ -2863,7 +2863,7 @@ echo_client_iocontrol(unsigned int cmd, struct obd_export *exp, int len,
 		GOTO(out, rc);
 
 	case OBD_IOC_SETATTR:
-		if (!cfs_capable(CFS_CAP_SYS_ADMIN))
+		if (!capable(CFS_CAP_SYS_ADMIN))
 			GOTO (out, rc = -EPERM);
 
 		rc = echo_get_object(&eco, ed, oa);
@@ -2878,7 +2878,7 @@ echo_client_iocontrol(unsigned int cmd, struct obd_export *exp, int len,
 		GOTO(out, rc);
 
 	case OBD_IOC_BRW_WRITE:
-		if (!cfs_capable(CFS_CAP_SYS_ADMIN))
+		if (!capable(CFS_CAP_SYS_ADMIN))
 			GOTO (out, rc = -EPERM);
 
 		rw = OBD_BRW_WRITE;
@@ -2897,7 +2897,7 @@ echo_client_iocontrol(unsigned int cmd, struct obd_export *exp, int len,
 		GOTO(out, rc);
 
 	case ECHO_IOC_SET_STRIPE:
-		if (!cfs_capable(CFS_CAP_SYS_ADMIN))
+		if (!capable(CFS_CAP_SYS_ADMIN))
 			GOTO (out, rc = -EPERM);
 
 		if (data->ioc_pbuf1 == NULL) {  /* unset */
@@ -2914,7 +2914,7 @@ echo_client_iocontrol(unsigned int cmd, struct obd_export *exp, int len,
 		GOTO (out, rc);
 
 	case ECHO_IOC_ENQUEUE:
-		if (!cfs_capable(CFS_CAP_SYS_ADMIN))
+		if (!capable(CFS_CAP_SYS_ADMIN))
 			GOTO (out, rc = -EPERM);
 
 		rc = echo_client_enqueue(exp, oa,
diff --git a/drivers/staging/lustre/lustre/osc/osc_cache.c b/drivers/staging/lustre/lustre/osc/osc_cache.c
index be4511e..b92a02e 100644
--- a/drivers/staging/lustre/lustre/osc/osc_cache.c
+++ b/drivers/staging/lustre/lustre/osc/osc_cache.c
@@ -2146,7 +2146,7 @@ int osc_prep_async_page(struct osc_object *osc, struct osc_page *ops,
 	oap->oap_obj_off = offset;
 	LASSERT(!(offset & ~CFS_PAGE_MASK));
 
-	if (!client_is_remote(exp) && cfs_capable(CFS_CAP_SYS_RESOURCE))
+	if (!client_is_remote(exp) && capable(CFS_CAP_SYS_RESOURCE))
 		oap->oap_brw_flags = OBD_BRW_NOQUOTA;
 
 	INIT_LIST_HEAD(&oap->oap_pending_item);
@@ -2186,7 +2186,7 @@ int osc_queue_async_io(const struct lu_env *env, struct cl_io *io,
 	/* Set the OBD_BRW_SRVLOCK before the page is queued. */
 	brw_flags |= ops->ops_srvlock ? OBD_BRW_SRVLOCK : 0;
 	if (!client_is_remote(osc_export(osc)) &&
-	    cfs_capable(CFS_CAP_SYS_RESOURCE)) {
+	    capable(CFS_CAP_SYS_RESOURCE)) {
 		brw_flags |= OBD_BRW_NOQUOTA;
 		cmd |= OBD_BRW_NOQUOTA;
 	}
diff --git a/drivers/staging/lustre/lustre/osc/osc_io.c b/drivers/staging/lustre/lustre/osc/osc_io.c
index 681d60a..777ae24 100644
--- a/drivers/staging/lustre/lustre/osc/osc_io.c
+++ b/drivers/staging/lustre/lustre/osc/osc_io.c
@@ -297,7 +297,7 @@ static int osc_io_commit_write(const struct lu_env *env,
 	 */
 	osc_page_touch(env, cl2osc_page(slice), to);
 	if (!client_is_remote(osc_export(obj)) &&
-	    cfs_capable(CFS_CAP_SYS_RESOURCE))
+	    capable(CFS_CAP_SYS_RESOURCE))
 		oap->oap_brw_flags |= OBD_BRW_NOQUOTA;
 
 	if (oio->oi_lockless)
diff --git a/drivers/staging/lustre/lustre/osc/osc_page.c b/drivers/staging/lustre/lustre/osc/osc_page.c
index 4909e486..96cb6e2 100644
--- a/drivers/staging/lustre/lustre/osc/osc_page.c
+++ b/drivers/staging/lustre/lustre/osc/osc_page.c
@@ -561,7 +561,7 @@ void osc_page_submit(const struct lu_env *env, struct osc_page *opg,
 	oap->oap_brw_flags = OBD_BRW_SYNC | brw_flags;
 
 	if (!client_is_remote(osc_export(obj)) &&
-			cfs_capable(CFS_CAP_SYS_RESOURCE)) {
+			capable(CFS_CAP_SYS_RESOURCE)) {
 		oap->oap_brw_flags |= OBD_BRW_NOQUOTA;
 		oap->oap_cmd |= OBD_BRW_NOQUOTA;
 	}
-- 
1.7.9.5

