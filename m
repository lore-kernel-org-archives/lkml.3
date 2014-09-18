Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290AbaIRU2P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 16:28:15 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:41296
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756767AbaIRU2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 16:28:08 -0400
X-IronPort-AV: E=Sophos;i="5.04,549,1406584800"; 
   d="scan'208";a="79973360"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Oleg Drokin <oleg.drokin@intel.com>
Cc: kernel-janitors@vger.kernel.org, Andreas Dilger <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        HPDD-discuss@ml01.01.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: lustre: llite: Use kzalloc and rewrite null tests
Date: Thu, 18 Sep 2014 22:24:02 +0200
Message-Id: <1411071842-24714-2-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1411071842-24714-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1411071842-24714-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

This patch removes some kzalloc-related macros and rewrites the
associated null tests to use !x rather than x == NULL.

A simplified version of the semantic patch that makes this change is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression ptr;
statement S,S1;
@@

  \(OBD_ALLOC\|OBD_ALLOC_WAIT\|OBD_ALLOC_PTR\|OBD_ALLOC_PTR_WAIT\)(ptr,...);
  if (
+     !
      ptr
-      == NULL
     ) S else S1

@@
expression ptr,size;
@@

- OBD_ALLOC(ptr,size)
+ ptr = kzalloc(size, GFP_NOFS)

@@
expression ptr,size;
@@

- OBD_ALLOC_WAIT(ptr,size)
+ ptr = kzalloc(size, GFP_KERNEL)

@@
expression ptr,size;
@@

- OBD_ALLOC_PTR(ptr)
+ ptr = kzalloc(sizeof(*ptr), GFP_NOFS)

@@
expression ptr,size;
@@

- OBD_ALLOC_PTR_WAIT(ptr,size)
+ ptr = kzalloc(sizeof(*ptr), GFP_KERNEL)
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/staging/lustre/lustre/llite/dcache.c       |    4 -
 drivers/staging/lustre/lustre/llite/dir.c          |   48 +++++++++---------
 drivers/staging/lustre/lustre/llite/file.c         |   56 ++++++++++-----------
 drivers/staging/lustre/lustre/llite/llite_close.c  |    8 +--
 drivers/staging/lustre/lustre/llite/llite_lib.c    |   32 ++++++------
 drivers/staging/lustre/lustre/llite/llite_nfs.c    |    4 -
 drivers/staging/lustre/lustre/llite/llite_rmtacl.c |    4 -
 drivers/staging/lustre/lustre/llite/lloop.c        |    4 -
 drivers/staging/lustre/lustre/llite/namei.c        |    2 
 drivers/staging/lustre/lustre/llite/statahead.c    |   14 ++---
 drivers/staging/lustre/lustre/llite/symlink.c      |    2 
 drivers/staging/lustre/lustre/llite/xattr_cache.c  |    4 -
 12 files changed, 91 insertions(+), 91 deletions(-)

diff -u -p a/drivers/staging/lustre/lustre/llite/statahead.c b/drivers/staging/lustre/lustre/llite/statahead.c
--- a/drivers/staging/lustre/lustre/llite/statahead.c
+++ b/drivers/staging/lustre/lustre/llite/statahead.c
@@ -202,8 +202,8 @@ ll_sa_entry_alloc(struct ll_statahead_in
 	char		 *dname;
 
 	entry_size = sizeof(struct ll_sa_entry) + (len & ~3) + 4;
-	OBD_ALLOC(entry, entry_size);
-	if (unlikely(entry == NULL))
+	entry = kzalloc(entry_size, GFP_NOFS);
+	if (unlikely(!entry))
 		return ERR_PTR(-ENOMEM);
 
 	CDEBUG(D_READA, "alloc sa entry %.*s(%p) index %llu\n",
@@ -465,7 +465,7 @@ static struct ll_statahead_info *ll_sai_
 	struct ll_statahead_info *sai;
 	int		       i;
 
-	OBD_ALLOC_PTR(sai);
+	sai = kzalloc(sizeof(*sai), GFP_NOFS);
 	if (!sai)
 		return NULL;
 
@@ -802,12 +802,12 @@ static int sa_args_init(struct inode *di
 	struct ldlm_enqueue_info *einfo;
 	struct md_op_data	*op_data;
 
-	OBD_ALLOC_PTR(einfo);
-	if (einfo == NULL)
+	einfo = kzalloc(sizeof(*einfo), GFP_NOFS);
+	if (!einfo)
 		return -ENOMEM;
 
-	OBD_ALLOC_PTR(minfo);
-	if (minfo == NULL) {
+	minfo = kzalloc(sizeof(*minfo), GFP_NOFS);
+	if (!minfo) {
 		OBD_FREE_PTR(einfo);
 		return -ENOMEM;
 	}
diff -u -p a/drivers/staging/lustre/lustre/llite/llite_nfs.c b/drivers/staging/lustre/lustre/llite/llite_nfs.c
--- a/drivers/staging/lustre/lustre/llite/llite_nfs.c
+++ b/drivers/staging/lustre/lustre/llite/llite_nfs.c
@@ -106,8 +106,8 @@ struct inode *search_inode_for_lustre(st
 
 	/* Because inode is NULL, ll_prep_md_op_data can not
 	 * be used here. So we allocate op_data ourselves */
-	OBD_ALLOC_PTR(op_data);
-	if (op_data == NULL)
+	op_data = kzalloc(sizeof(*op_data), GFP_NOFS);
+	if (!op_data)
 		return ERR_PTR(-ENOMEM);
 
 	op_data->op_fid1 = *fid;
diff -u -p a/drivers/staging/lustre/lustre/llite/dcache.c b/drivers/staging/lustre/lustre/llite/dcache.c
--- a/drivers/staging/lustre/lustre/llite/dcache.c
+++ b/drivers/staging/lustre/lustre/llite/dcache.c
@@ -187,8 +187,8 @@ int ll_d_init(struct dentry *de)
 	if (de->d_fsdata == NULL) {
 		struct ll_dentry_data *lld;
 
-		OBD_ALLOC_PTR(lld);
-		if (likely(lld != NULL)) {
+		lld = kzalloc(sizeof(*lld), GFP_NOFS);
+		if (likely(lld)) {
 			spin_lock(&de->d_lock);
 			if (likely(de->d_fsdata == NULL)) {
 				de->d_fsdata = lld;
diff -u -p a/drivers/staging/lustre/lustre/llite/dir.c b/drivers/staging/lustre/lustre/llite/dir.c
--- a/drivers/staging/lustre/lustre/llite/dir.c
+++ b/drivers/staging/lustre/lustre/llite/dir.c
@@ -163,8 +163,8 @@ static int ll_dir_filler(void *_hash, st
 
 	LASSERT(max_pages > 0 && max_pages <= MD_MAX_BRW_PAGES);
 
-	OBD_ALLOC(page_pool, sizeof(page) * max_pages);
-	if (page_pool != NULL) {
+	page_pool = kzalloc(sizeof(page) * max_pages, GFP_NOFS);
+	if (page_pool) {
 		page_pool[0] = page0;
 	} else {
 		page_pool = &page0;
@@ -638,7 +638,7 @@ static int ll_send_mgc_param(struct obd_
 	struct mgs_send_param *msp;
 	int rc = 0;
 
-	OBD_ALLOC_PTR(msp);
+	msp = kzalloc(sizeof(*msp), GFP_NOFS);
 	if (!msp)
 		return -ENOMEM;
 
@@ -751,8 +751,8 @@ int ll_dir_setstripe(struct inode *inode
 		char *param = NULL;
 		char *buf;
 
-		OBD_ALLOC(param, MGS_PARAM_MAXLEN);
-		if (param == NULL) {
+		param = kzalloc(MGS_PARAM_MAXLEN, GFP_NOFS);
+		if (!param) {
 			rc = -ENOMEM;
 			goto end;
 		}
@@ -1061,8 +1061,8 @@ static int copy_and_ioctl(int cmd, struc
 	void *copy;
 	int rc;
 
-	OBD_ALLOC(copy, size);
-	if (copy == NULL)
+	copy = kzalloc(size, GFP_NOFS);
+	if (!copy)
 		return -ENOMEM;
 
 	if (copy_from_user(copy, data, size)) {
@@ -1152,8 +1152,8 @@ static int quotactl_ioctl(struct ll_sb_i
 	} else {
 		struct obd_quotactl *oqctl;
 
-		OBD_ALLOC_PTR(oqctl);
-		if (oqctl == NULL)
+		oqctl = kzalloc(sizeof(*oqctl), GFP_NOFS);
+		if (!oqctl)
 			return -ENOMEM;
 
 		QCTL_COPY(oqctl, qctl);
@@ -1173,8 +1173,8 @@ static int quotactl_ioctl(struct ll_sb_i
 		    !oqctl->qc_dqblk.dqb_curspace) {
 			struct obd_quotactl *oqctl_tmp;
 
-			OBD_ALLOC_PTR(oqctl_tmp);
-			if (oqctl_tmp == NULL) {
+			oqctl_tmp = kzalloc(sizeof(*oqctl_tmp), GFP_NOFS);
+			if (!oqctl_tmp) {
 				rc = -ENOMEM;
 				goto out;
 			}
@@ -1412,8 +1412,8 @@ lmv_out_free:
 			return -EINVAL;
 
 		lum_size = lmv_user_md_size(1, LMV_MAGIC_V1);
-		OBD_ALLOC(tmp, lum_size);
-		if (tmp == NULL) {
+		tmp = kzalloc(lum_size, GFP_NOFS);
+		if (!tmp) {
 			rc = -ENOMEM;
 			goto free_lmv;
 		}
@@ -1643,7 +1643,7 @@ free_lmm:
 		    sbi->ll_flags & LL_SBI_RMT_CLIENT)
 			return -EPERM;
 
-		OBD_ALLOC_PTR(oqctl);
+		oqctl = kzalloc(sizeof(*oqctl), GFP_NOFS);
 		if (!oqctl)
 			return -ENOMEM;
 		oqctl->qc_type = arg;
@@ -1667,7 +1667,7 @@ free_lmm:
 		    sbi->ll_flags & LL_SBI_RMT_CLIENT)
 			return -EPERM;
 
-		OBD_ALLOC_PTR(check);
+		check = kzalloc(sizeof(*check), GFP_NOFS);
 		if (!check)
 			return -ENOMEM;
 
@@ -1701,11 +1701,11 @@ out_poll:
 		struct if_quotactl_18 *qctl_18;
 		struct if_quotactl *qctl_20;
 
-		OBD_ALLOC_PTR(qctl_18);
+		qctl_18 = kzalloc(sizeof(*qctl_18), GFP_NOFS);
 		if (!qctl_18)
 			return -ENOMEM;
 
-		OBD_ALLOC_PTR(qctl_20);
+		qctl_20 = kzalloc(sizeof(*qctl_20), GFP_NOFS);
 		if (!qctl_20) {
 			rc = -ENOMEM;
 			goto out_quotactl_18;
@@ -1755,7 +1755,7 @@ out_quotactl_18:
 	case LL_IOC_QUOTACTL: {
 		struct if_quotactl *qctl;
 
-		OBD_ALLOC_PTR(qctl);
+		qctl = kzalloc(sizeof(*qctl), GFP_NOFS);
 		if (!qctl)
 			return -ENOMEM;
 
@@ -1834,8 +1834,8 @@ out_quotactl:
 		struct hsm_user_request	*hur;
 		ssize_t			 totalsize;
 
-		OBD_ALLOC_PTR(hur);
-		if (hur == NULL)
+		hur = kzalloc(sizeof(*hur), GFP_NOFS);
+		if (!hur)
 			return -ENOMEM;
 
 		/* We don't know the true size yet; copy the fixed-size part */
@@ -1920,8 +1920,8 @@ out_quotactl:
 		struct hsm_copy	*copy;
 		int		 rc;
 
-		OBD_ALLOC_PTR(copy);
-		if (copy == NULL)
+		copy = kzalloc(sizeof(*copy), GFP_NOFS);
+		if (!copy)
 			return -ENOMEM;
 		if (copy_from_user(copy, (char *)arg, sizeof(*copy))) {
 			OBD_FREE_PTR(copy);
@@ -1939,8 +1939,8 @@ out_quotactl:
 		struct hsm_copy	*copy;
 		int		 rc;
 
-		OBD_ALLOC_PTR(copy);
-		if (copy == NULL)
+		copy = kzalloc(sizeof(*copy), GFP_NOFS);
+		if (!copy)
 			return -ENOMEM;
 		if (copy_from_user(copy, (char *)arg, sizeof(*copy))) {
 			OBD_FREE_PTR(copy);
diff -u -p a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -146,8 +146,8 @@ static int ll_close_inode_openhandle(str
 		goto out;
 	}
 
-	OBD_ALLOC_PTR(op_data);
-	if (op_data == NULL) {
+	op_data = kzalloc(sizeof(*op_data), GFP_NOFS);
+	if (!op_data) {
 		/* XXX We leak openhandle and request here. */
 		rc = -ENOMEM;
 		goto out;
@@ -659,7 +659,7 @@ restart:
 
 			goto restart;
 		}
-		OBD_ALLOC(*och_p, sizeof (struct obd_client_handle));
+		*och_p = kzalloc(sizeof(struct obd_client_handle), GFP_NOFS);
 		if (!*och_p) {
 			rc = -ENOMEM;
 			goto out_och_free;
@@ -811,8 +811,8 @@ ll_lease_open(struct inode *inode, struc
 		old_handle = fd->fd_och->och_fh;
 	}
 
-	OBD_ALLOC_PTR(och);
-	if (och == NULL)
+	och = kzalloc(sizeof(*och), GFP_NOFS);
+	if (!och)
 		return ERR_PTR(-ENOMEM);
 
 	op_data = ll_prep_md_op_data(NULL, inode, inode, NULL, 0, 0,
@@ -1655,7 +1655,7 @@ int ll_release_openhandle(struct dentry
 
 	LASSERT(it_open_error(DISP_OPEN_OPEN, it) == 0);
 
-	OBD_ALLOC(och, sizeof(*och));
+	och = kzalloc(sizeof(*och), GFP_NOFS);
 	if (!och) {
 		rc = -ENOMEM;
 		goto out;
@@ -1759,8 +1759,8 @@ int ll_fid2path(struct inode *inode, voi
 
 	outsize = sizeof(*gfout) + pathlen;
 
-	OBD_ALLOC(gfout, outsize);
-	if (gfout == NULL)
+	gfout = kzalloc(outsize, GFP_NOFS);
+	if (!gfout)
 		return -ENOMEM;
 
 	if (copy_from_user(gfout, arg, sizeof(*gfout))) {
@@ -1867,8 +1867,8 @@ int ll_data_version(struct inode *inode,
 		goto out;
 	}
 
-	OBD_ALLOC_PTR(obdo);
-	if (obdo == NULL) {
+	obdo = kzalloc(sizeof(*obdo), GFP_NOFS);
+	if (!obdo) {
 		rc = -ENOMEM;
 		goto out;
 	}
@@ -1955,8 +1955,8 @@ static int ll_swap_layouts(struct file *
 	struct ll_swap_stack	*llss = NULL;
 	int			 rc;
 
-	OBD_ALLOC_PTR(llss);
-	if (llss == NULL)
+	llss = kzalloc(sizeof(*llss), GFP_NOFS);
+	if (!llss)
 		return -ENOMEM;
 
 	llss->inode1 = file1->f_dentry->d_inode;
@@ -2149,8 +2149,8 @@ static int ll_hsm_import(struct inode *i
 		return -EINVAL;
 
 	/* set HSM flags */
-	OBD_ALLOC_PTR(hss);
-	if (hss == NULL) {
+	hss = kzalloc(sizeof(*hss), GFP_NOFS);
+	if (!hss) {
 		rc = -ENOMEM;
 		goto out;
 	}
@@ -2162,8 +2162,8 @@ static int ll_hsm_import(struct inode *i
 	if (rc != 0)
 		goto out;
 
-	OBD_ALLOC_PTR(attr);
-	if (attr == NULL) {
+	attr = kzalloc(sizeof(*attr), GFP_NOFS);
+	if (!attr) {
 		rc = -ENOMEM;
 		goto out;
 	}
@@ -2341,8 +2341,8 @@ ll_file_ioctl(struct file *file, unsigne
 		struct hsm_user_state	*hus;
 		int			 rc;
 
-		OBD_ALLOC_PTR(hus);
-		if (hus == NULL)
+		hus = kzalloc(sizeof(*hus), GFP_NOFS);
+		if (!hus)
 			return -ENOMEM;
 
 		op_data = ll_prep_md_op_data(NULL, inode, NULL, NULL, 0, 0,
@@ -2366,8 +2366,8 @@ ll_file_ioctl(struct file *file, unsigne
 		struct hsm_state_set	*hss;
 		int			 rc;
 
-		OBD_ALLOC_PTR(hss);
-		if (hss == NULL)
+		hss = kzalloc(sizeof(*hss), GFP_NOFS);
+		if (!hss)
 			return -ENOMEM;
 
 		if (copy_from_user(hss, (char *)arg, sizeof(*hss))) {
@@ -2385,8 +2385,8 @@ ll_file_ioctl(struct file *file, unsigne
 		struct hsm_current_action	*hca;
 		int				 rc;
 
-		OBD_ALLOC_PTR(hca);
-		if (hca == NULL)
+		hca = kzalloc(sizeof(*hca), GFP_NOFS);
+		if (!hca)
 			return -ENOMEM;
 
 		op_data = ll_prep_md_op_data(NULL, inode, NULL, NULL, 0, 0,
@@ -2493,8 +2493,8 @@ ll_file_ioctl(struct file *file, unsigne
 	case LL_IOC_HSM_IMPORT: {
 		struct hsm_user_import *hui;
 
-		OBD_ALLOC_PTR(hui);
-		if (hui == NULL)
+		hui = kzalloc(sizeof(*hui), GFP_NOFS);
+		if (!hui)
 			return -ENOMEM;
 
 		if (copy_from_user(hui, (void *)arg, sizeof(*hui))) {
@@ -3229,8 +3229,8 @@ void *ll_iocontrol_register(llioc_callba
 		return NULL;
 
 	size = sizeof(*in_data) + count * sizeof(unsigned int);
-	OBD_ALLOC(in_data, size);
-	if (in_data == NULL)
+	in_data = kzalloc(size, GFP_NOFS);
+	if (!in_data)
 		return NULL;
 
 	memset(in_data, 0, sizeof(*in_data));
@@ -3618,8 +3618,8 @@ int ll_layout_restore(struct inode *inod
 
 	len = sizeof(struct hsm_user_request) +
 	      sizeof(struct hsm_user_item);
-	OBD_ALLOC(hur, len);
-	if (hur == NULL)
+	hur = kzalloc(len, GFP_NOFS);
+	if (!hur)
 		return -ENOMEM;
 
 	hur->hur_request.hr_action = HUA_RESTORE;
diff -u -p a/drivers/staging/lustre/lustre/llite/lloop.c b/drivers/staging/lustre/lustre/llite/lloop.c
--- a/drivers/staging/lustre/lustre/llite/lloop.c
+++ b/drivers/staging/lustre/lustre/llite/lloop.c
@@ -793,11 +793,11 @@ static int __init lloop_init(void)
 	if (ll_iocontrol_magic == NULL)
 		goto out_mem1;
 
-	OBD_ALLOC_WAIT(loop_dev, max_loop * sizeof(*loop_dev));
+	loop_dev = kzalloc(max_loop * sizeof(*loop_dev), GFP_KERNEL);
 	if (!loop_dev)
 		goto out_mem1;
 
-	OBD_ALLOC_WAIT(disks, max_loop * sizeof(*disks));
+	disks = kzalloc(max_loop * sizeof(*disks), GFP_KERNEL);
 	if (!disks)
 		goto out_mem2;
 
diff -u -p a/drivers/staging/lustre/lustre/llite/llite_lib.c b/drivers/staging/lustre/lustre/llite/llite_lib.c
--- a/drivers/staging/lustre/lustre/llite/llite_lib.c
+++ b/drivers/staging/lustre/lustre/llite/llite_lib.c
@@ -75,7 +75,7 @@ static struct ll_sb_info *ll_init_sbi(vo
 	class_uuid_t uuid;
 	int i;
 
-	OBD_ALLOC(sbi, sizeof(*sbi));
+	sbi = kzalloc(sizeof(*sbi), GFP_NOFS);
 	if (!sbi)
 		return NULL;
 
@@ -172,12 +172,12 @@ static int client_common_fill_super(stru
 		return -EINVAL;
 	}
 
-	OBD_ALLOC_PTR(data);
-	if (data == NULL)
+	data = kzalloc(sizeof(*data), GFP_NOFS);
+	if (!data)
 		return -ENOMEM;
 
-	OBD_ALLOC_PTR(osfs);
-	if (osfs == NULL) {
+	osfs = kzalloc(sizeof(*osfs), GFP_NOFS);
+	if (!osfs) {
 		OBD_FREE_PTR(data);
 		return -ENOMEM;
 	}
@@ -293,7 +293,7 @@ static int client_common_fill_super(stru
 	    valid != CLIENT_CONNECT_MDT_REQD) {
 		char *buf;
 
-		OBD_ALLOC_WAIT(buf, PAGE_CACHE_SIZE);
+		buf = kzalloc(PAGE_CACHE_SIZE, GFP_KERNEL);
 		obd_connect_flags2str(buf, PAGE_CACHE_SIZE,
 				      valid ^ CLIENT_CONNECT_MDT_REQD, ",");
 		LCONSOLE_ERROR_MSG(0x170, "Server %s does not support "
@@ -496,8 +496,8 @@ static int client_common_fill_super(stru
 	else if (sbi->ll_flags & LL_SBI_ACL)
 		valid |= OBD_MD_FLACL;
 
-	OBD_ALLOC_PTR(op_data);
-	if (op_data == NULL) {
+	op_data = kzalloc(sizeof(*op_data), GFP_NOFS);
+	if (!op_data) {
 		err = -ENOMEM;
 		goto out_lock_cn_cb;
 	}
@@ -993,8 +993,8 @@ int ll_fill_super(struct super_block *sb
 
 	CDEBUG(D_VFSTRACE, "VFS Op: sb %p\n", sb);
 
-	OBD_ALLOC_PTR(cfg);
-	if (cfg == NULL)
+	cfg = kzalloc(sizeof(*cfg), GFP_NOFS);
+	if (!cfg)
 		return -ENOMEM;
 
 	try_module_get(THIS_MODULE);
@@ -1049,14 +1049,14 @@ int ll_fill_super(struct super_block *sb
 	CDEBUG(D_CONFIG, "Found profile %s: mdc=%s osc=%s\n", profilenm,
 	       lprof->lp_md, lprof->lp_dt);
 
-	OBD_ALLOC(dt, strlen(lprof->lp_dt) + instlen + 2);
+	dt = kzalloc(strlen(lprof->lp_dt) + instlen + 2, GFP_NOFS);
 	if (!dt) {
 		err = -ENOMEM;
 		goto out_free;
 	}
 	sprintf(dt, "%s-%p", lprof->lp_dt, cfg->cfg_instance);
 
-	OBD_ALLOC(md, strlen(lprof->lp_md) + instlen + 2);
+	md = kzalloc(strlen(lprof->lp_md) + instlen + 2, GFP_NOFS);
 	if (!md) {
 		err = -ENOMEM;
 		goto out_free;
@@ -1437,8 +1437,8 @@ int ll_setattr_raw(struct dentry *dentry
 	/* We always do an MDS RPC, even if we're only changing the size;
 	 * only the MDS knows whether truncate() should fail with -ETXTBUSY */
 
-	OBD_ALLOC_PTR(op_data);
-	if (op_data == NULL)
+	op_data = kzalloc(sizeof(*op_data), GFP_NOFS);
+	if (!op_data)
 		return -ENOMEM;
 
 	if (!S_ISDIR(inode->i_mode)) {
@@ -2029,7 +2029,7 @@ void ll_umount_begin(struct super_block
 	}
 	obd->obd_force = 1;
 
-	OBD_ALLOC_PTR(ioc_data);
+	ioc_data = kzalloc(sizeof(*ioc_data), GFP_NOFS);
 	if (ioc_data) {
 		obd_iocontrol(IOC_OSC_SET_ACTIVE, sbi->ll_md_exp,
 			      sizeof(*ioc_data), ioc_data, NULL);
@@ -2251,7 +2251,7 @@ struct md_op_data *ll_prep_md_op_data(st
 		return ERR_PTR(-ENAMETOOLONG);
 
 	if (op_data == NULL)
-		OBD_ALLOC_PTR(op_data);
+		op_data = kzalloc(sizeof(*op_data), GFP_NOFS);
 
 	if (op_data == NULL)
 		return ERR_PTR(-ENOMEM);
diff -u -p a/drivers/staging/lustre/lustre/llite/xattr_cache.c b/drivers/staging/lustre/lustre/llite/xattr_cache.c
--- a/drivers/staging/lustre/lustre/llite/xattr_cache.c
+++ b/drivers/staging/lustre/lustre/llite/xattr_cache.c
@@ -128,13 +128,13 @@ static int ll_xattr_cache_add(struct lis
 
 	xattr->xe_namelen = strlen(xattr_name) + 1;
 
-	OBD_ALLOC(xattr->xe_name, xattr->xe_namelen);
+	xattr->xe_name = kzalloc(xattr->xe_namelen, GFP_NOFS);
 	if (!xattr->xe_name) {
 		CDEBUG(D_CACHE, "failed to alloc xattr name %u\n",
 		       xattr->xe_namelen);
 		goto err_name;
 	}
-	OBD_ALLOC(xattr->xe_value, xattr_val_len);
+	xattr->xe_value = kzalloc(xattr_val_len, GFP_NOFS);
 	if (!xattr->xe_value) {
 		CDEBUG(D_CACHE, "failed to alloc xattr value %d\n",
 		       xattr_val_len);
diff -u -p a/drivers/staging/lustre/lustre/llite/llite_close.c b/drivers/staging/lustre/lustre/llite/llite_close.c
--- a/drivers/staging/lustre/lustre/llite/llite_close.c
+++ b/drivers/staging/lustre/lustre/llite/llite_close.c
@@ -285,8 +285,8 @@ static void ll_done_writing(struct inode
 
 	LASSERT(exp_connect_som(ll_i2mdexp(inode)));
 
-	OBD_ALLOC_PTR(op_data);
-	if (op_data == NULL) {
+	op_data = kzalloc(sizeof(*op_data), GFP_NOFS);
+	if (!op_data) {
 		CERROR("can't allocate op_data\n");
 		return;
 	}
@@ -367,8 +367,8 @@ int ll_close_thread_start(struct ll_clos
 	if (OBD_FAIL_CHECK(OBD_FAIL_LDLM_CLOSE_THREAD))
 		return -EINTR;
 
-	OBD_ALLOC(lcq, sizeof(*lcq));
-	if (lcq == NULL)
+	lcq = kzalloc(sizeof(*lcq), GFP_NOFS);
+	if (!lcq)
 		return -ENOMEM;
 
 	spin_lock_init(&lcq->lcq_lock);
diff -u -p a/drivers/staging/lustre/lustre/llite/symlink.c b/drivers/staging/lustre/lustre/llite/symlink.c
--- a/drivers/staging/lustre/lustre/llite/symlink.c
+++ b/drivers/staging/lustre/lustre/llite/symlink.c
@@ -106,7 +106,7 @@ static int ll_readlink_internal(struct i
 		goto failed;
 	}
 
-	OBD_ALLOC(lli->lli_symlink_name, symlen);
+	lli->lli_symlink_name = kzalloc(symlen, GFP_NOFS);
 	/* do not return an error if we cannot cache the symlink locally */
 	if (lli->lli_symlink_name) {
 		memcpy(lli->lli_symlink_name, *symname, symlen);
diff -u -p a/drivers/staging/lustre/lustre/llite/namei.c b/drivers/staging/lustre/lustre/llite/namei.c
--- a/drivers/staging/lustre/lustre/llite/namei.c
+++ b/drivers/staging/lustre/lustre/llite/namei.c
@@ -624,7 +624,7 @@ static int ll_atomic_open(struct inode *
 	       dentry->d_name.len, dentry->d_name.name, dir->i_ino,
 	       dir->i_generation, dir, file, open_flags, mode, *opened);
 
-	OBD_ALLOC(it, sizeof(*it));
+	it = kzalloc(sizeof(*it), GFP_NOFS);
 	if (!it)
 		return -ENOMEM;
 
diff -u -p a/drivers/staging/lustre/lustre/llite/llite_rmtacl.c b/drivers/staging/lustre/lustre/llite/llite_rmtacl.c
--- a/drivers/staging/lustre/lustre/llite/llite_rmtacl.c
+++ b/drivers/staging/lustre/lustre/llite/llite_rmtacl.c
@@ -78,7 +78,7 @@ static struct rmtacl_ctl_entry *rce_allo
 {
 	struct rmtacl_ctl_entry *rce;
 
-	OBD_ALLOC_PTR(rce);
+	rce = kzalloc(sizeof(*rce), GFP_NOFS);
 	if (!rce)
 		return NULL;
 
@@ -184,7 +184,7 @@ static struct eacl_entry *ee_alloc(pid_t
 {
 	struct eacl_entry *ee;
 
-	OBD_ALLOC_PTR(ee);
+	ee = kzalloc(sizeof(*ee), GFP_NOFS);
 	if (!ee)
 		return NULL;
 

