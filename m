Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751701AbaH3OZF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 10:25:05 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:15767 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751390AbaH3OZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 10:25:00 -0400
X-IronPort-AV: E=Sophos;i="5.04,431,1406584800"; 
   d="scan'208";a="92245627"
Date: Sat, 30 Aug 2014 16:24:55 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Dilger, Andreas" <andreas.dilger@intel.com>,
        "Drokin, Oleg" <oleg.drokin@intel.com>, Peng Tao <bergwolf@gmail.com>
Subject: [PATCH] staging: lustre: llite: expand the GOTO macro
Message-ID: <alpine.DEB.2.02.1408301624010.2087@localhost6.localdomain6>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier lbl;
@@

if (...)
  GOTO(lbl,...);
+else
GOTO(lbl,...);

@@
identifier lbl,rc;
constant c;
expression e,e1;
@@

if (
-   e
+   !e
   )
-  GOTO(lbl,\(rc\|c\));
-else GOTO(lbl,e1);
+  e1;
+goto lbl;

@@
identifier lbl,rc;
constant c;
expression e,e1;
@@

if (e)
-  GOTO(lbl,e1);
-else GOTO(lbl,\(rc\|c\));
+  e1;
+goto lbl;

@@
identifier lbl;
expression e,e1,e2;
@@

if (e)
-  GOTO(lbl,e1);
-else GOTO(lbl,e2);
+  e1;
+else e2;
+goto lbl;

// ------------------------------------------------------------------------

@@
identifier lbl,rc;
constant c;
@@

- GOTO(lbl,\(rc\|c\));
+ goto lbl;

@@
identifier lbl;
expression rc;
@@

- GOTO(lbl,rc);
+ rc;
+ goto lbl;
// </smpl>

The rules above the line deal with the case where the goto desination is
the same whether or not the the branch is taken.  In that case, the goto is
created in just one instance after the if.  This affects only the files
namei.c and llite_lib.c.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/staging/lustre/lustre/llite/dir.c         |  171 ++++++++-----
 drivers/staging/lustre/lustre/llite/file.c        |  274 +++++++++++++---------
 drivers/staging/lustre/lustre/llite/llite_capa.c  |    2 
 drivers/staging/lustre/lustre/llite/llite_close.c |   10 
 drivers/staging/lustre/lustre/llite/llite_lib.c   |  110 +++++---
 drivers/staging/lustre/lustre/llite/llite_mmap.c  |    8 
 drivers/staging/lustre/lustre/llite/llite_nfs.c   |   12 
 drivers/staging/lustre/lustre/llite/lloop.c       |   48 ++-
 drivers/staging/lustre/lustre/llite/lproc_llite.c |   39 +--
 drivers/staging/lustre/lustre/llite/namei.c       |   53 ++--
 drivers/staging/lustre/lustre/llite/remote_perm.c |    6 
 drivers/staging/lustre/lustre/llite/rw.c          |   22 +
 drivers/staging/lustre/lustre/llite/rw26.c        |    2 
 drivers/staging/lustre/lustre/llite/statahead.c   |   66 +++--
 drivers/staging/lustre/lustre/llite/symlink.c     |   11 
 drivers/staging/lustre/lustre/llite/vvp_io.c      |   14 -
 drivers/staging/lustre/lustre/llite/xattr.c       |   51 ++--
 drivers/staging/lustre/lustre/llite/xattr_cache.c |   22 +
 18 files changed, 576 insertions(+), 345 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/dir.c b/drivers/staging/lustre/lustre/llite/dir.c
index de5892c..e5d31f4 100644
--- a/drivers/staging/lustre/lustre/llite/dir.c
+++ b/drivers/staging/lustre/lustre/llite/dir.c
@@ -398,7 +398,7 @@ struct page *ll_get_dir_page(struct inode *dir, __u64 hash,
 	if (IS_ERR(page)) {
 		CERROR("dir page locate: "DFID" at %llu: rc %ld\n",
 		       PFID(ll_inode2fid(dir)), lhash, PTR_ERR(page));
-		GOTO(out_unlock, page);
+		goto out_unlock;
 	} else if (page != NULL) {
 		/*
 		 * XXX nikita: not entirely correct handling of a corner case:
@@ -414,7 +414,7 @@ struct page *ll_get_dir_page(struct inode *dir, __u64 hash,
 		 * it as an "overflow" page. 1. invalidate all pages at
 		 * once. 2. use HASH|1 as an index for P1.
 		 */
-		GOTO(hash_collision, page);
+		goto hash_collision;
 	}
 
 	page = read_cache_page(mapping, hash_x_index(hash, hash64),
@@ -422,7 +422,7 @@ struct page *ll_get_dir_page(struct inode *dir, __u64 hash,
 	if (IS_ERR(page)) {
 		CERROR("read cache page: "DFID" at %llu: rc %ld\n",
 		       PFID(ll_inode2fid(dir)), hash, PTR_ERR(page));
-		GOTO(out_unlock, page);
+		goto out_unlock;
 	}
 
 	wait_on_page_locked(page);
@@ -604,11 +604,13 @@ static int ll_readdir(struct file *filp, struct dir_context *ctx)
 	       " 32bit_api %d\n", inode->i_ino, inode->i_generation,
 	       inode, (unsigned long)lfd->lfd_pos, i_size_read(inode), api32);
 
-	if (lfd->lfd_pos == MDS_DIR_END_OFF)
+	if (lfd->lfd_pos == MDS_DIR_END_OFF) {
 		/*
 		 * end-of-file.
 		 */
-		GOTO(out, rc = 0);
+		rc = 0;
+		goto out;
+	}
 
 	ctx->pos = lfd->lfd_pos;
 	rc = ll_dir_read(inode, ctx);
@@ -663,8 +665,10 @@ int ll_dir_setdirstripe(struct inode *dir, struct lmv_user_md *lump,
 	op_data = ll_prep_md_op_data(NULL, dir, NULL, filename,
 				     strlen(filename), mode, LUSTRE_OPC_MKDIR,
 				     lump);
-	if (IS_ERR(op_data))
-		GOTO(err_exit, err = PTR_ERR(op_data));
+	if (IS_ERR(op_data)) {
+		err = PTR_ERR(op_data);
+		goto err_exit;
+	}
 
 	op_data->op_cli_flags |= CLI_SET_MEA;
 	err = md_create(sbi->ll_md_exp, op_data, lump, sizeof(*lump), mode,
@@ -673,7 +677,7 @@ int ll_dir_setdirstripe(struct inode *dir, struct lmv_user_md *lump,
 			cfs_curproc_cap_pack(), 0, &request);
 	ll_finish_md_op_data(op_data);
 	if (err)
-		GOTO(err_exit, err);
+		goto err_exit;
 err_exit:
 	ptlrpc_req_finished(request);
 	return err;
@@ -748,8 +752,10 @@ int ll_dir_setstripe(struct inode *inode, struct lov_user_md *lump,
 		char *buf;
 
 		OBD_ALLOC(param, MGS_PARAM_MAXLEN);
-		if (param == NULL)
-			GOTO(end, rc = -ENOMEM);
+		if (param == NULL) {
+			rc = -ENOMEM;
+			goto end;
+		}
 
 		buf = param;
 		/* Get fsname and assume devname to be -MDT0000. */
@@ -762,14 +768,14 @@ int ll_dir_setstripe(struct inode *inode, struct lov_user_md *lump,
 			lump ? le32_to_cpu(lump->lmm_stripe_size) : 0);
 		rc = ll_send_mgc_param(mgc->u.cli.cl_mgc_mgsexp, param);
 		if (rc)
-			GOTO(end, rc);
+			goto end;
 
 		/* Set root stripecount */
 		sprintf(buf, ".stripecount=%hd",
 			lump ? le16_to_cpu(lump->lmm_stripe_count) : 0);
 		rc = ll_send_mgc_param(mgc->u.cli.cl_mgc_mgsexp, param);
 		if (rc)
-			GOTO(end, rc);
+			goto end;
 
 		/* Set root stripeoffset */
 		sprintf(buf, ".stripeoffset=%hd",
@@ -811,7 +817,7 @@ int ll_dir_getstripe(struct inode *inode, struct lov_mds_md **lmmp,
 		CDEBUG(D_INFO, "md_getattr failed on inode "
 		       "%lu/%u: rc %d\n", inode->i_ino,
 		       inode->i_generation, rc);
-		GOTO(out, rc);
+		goto out;
 	}
 
 	body = req_capsule_server_get(&req->rq_pill, &RMF_MDT_BODY);
@@ -821,7 +827,8 @@ int ll_dir_getstripe(struct inode *inode, struct lov_mds_md **lmmp,
 
 	if (!(body->valid & (OBD_MD_FLEASIZE | OBD_MD_FLDIREA)) ||
 	    lmmsize == 0) {
-		GOTO(out, rc = -ENODATA);
+		rc = -ENODATA;
+		goto out;
 	}
 
 	lmm = req_capsule_server_sized_get(&req->rq_pill,
@@ -917,7 +924,8 @@ static int ll_ioc_copy_start(struct super_block *sb, struct hsm_copy *copy)
 			hpk.hpk_flags |= HP_FLAG_RETRY;
 			/* hpk_errval is >= 0 */
 			hpk.hpk_errval = -PTR_ERR(inode);
-			GOTO(progress, rc = PTR_ERR(inode));
+			rc = PTR_ERR(inode);
+			goto progress;
 		}
 
 		/* Read current file data version */
@@ -931,7 +939,7 @@ static int ll_ioc_copy_start(struct super_block *sb, struct hsm_copy *copy)
 			hpk.hpk_flags |= HP_FLAG_RETRY;
 			/* hpk_errval must be >= 0 */
 			hpk.hpk_errval = -rc;
-			GOTO(progress, rc);
+			goto progress;
 		}
 
 		/* Store it the hsm_copy for later copytool use.
@@ -997,7 +1005,8 @@ static int ll_ioc_copy_end(struct super_block *sb, struct hsm_copy *copy)
 			hpk.hpk_flags |= HP_FLAG_RETRY;
 			/* hpk_errval must be >= 0 */
 			hpk.hpk_errval = -PTR_ERR(inode);
-			GOTO(progress, rc = PTR_ERR(inode));
+			rc = PTR_ERR(inode);
+			goto progress;
 		}
 
 		rc = ll_data_version(inode, &data_version,
@@ -1008,7 +1017,7 @@ static int ll_ioc_copy_end(struct super_block *sb, struct hsm_copy *copy)
 				      "Request could not be confirmed.\n");
 			if (hpk.hpk_errval == 0)
 				hpk.hpk_errval = -rc;
-			GOTO(progress, rc);
+			goto progress;
 		}
 
 		/* Store it the hsm_copy for later copytool use.
@@ -1165,8 +1174,10 @@ static int quotactl_ioctl(struct ll_sb_info *sbi, struct if_quotactl *qctl)
 			struct obd_quotactl *oqctl_tmp;
 
 			OBD_ALLOC_PTR(oqctl_tmp);
-			if (oqctl_tmp == NULL)
-				GOTO(out, rc = -ENOMEM);
+			if (oqctl_tmp == NULL) {
+				rc = -ENOMEM;
+				goto out;
+			}
 
 			oqctl_tmp->qc_cmd = Q_GETOQUOTA;
 			oqctl_tmp->qc_id = oqctl->qc_id;
@@ -1286,20 +1297,23 @@ static long ll_dir_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 		if (namelen < 1) {
 			CDEBUG(D_INFO, "IOC_MDC_LOOKUP missing filename\n");
-			GOTO(out_free, rc = -EINVAL);
+			rc = -EINVAL;
+			goto out_free;
 		}
 
 		op_data = ll_prep_md_op_data(NULL, inode, NULL, filename, namelen,
 					     0, LUSTRE_OPC_ANY, NULL);
-		if (IS_ERR(op_data))
-			GOTO(out_free, rc = PTR_ERR(op_data));
+		if (IS_ERR(op_data)) {
+			rc = PTR_ERR(op_data);
+			goto out_free;
+		}
 
 		op_data->op_valid = OBD_MD_FLID;
 		rc = md_getattr_name(sbi->ll_md_exp, op_data, &request);
 		ll_finish_md_op_data(op_data);
 		if (rc < 0) {
 			CDEBUG(D_INFO, "md_getattr_name: %d\n", rc);
-			GOTO(out_free, rc);
+			goto out_free;
 		}
 		ptlrpc_req_finished(request);
 out_free:
@@ -1321,15 +1335,18 @@ out_free:
 
 		data = (void *)buf;
 		if (data->ioc_inlbuf1 == NULL || data->ioc_inlbuf2 == NULL ||
-		    data->ioc_inllen1 == 0 || data->ioc_inllen2 == 0)
-			GOTO(lmv_out_free, rc = -EINVAL);
+		    data->ioc_inllen1 == 0 || data->ioc_inllen2 == 0) {
+			rc = -EINVAL;
+			goto lmv_out_free;
+		}
 
 		filename = data->ioc_inlbuf1;
 		namelen = data->ioc_inllen1;
 
 		if (namelen < 1) {
 			CDEBUG(D_INFO, "IOC_MDC_LOOKUP missing filename\n");
-			GOTO(lmv_out_free, rc = -EINVAL);
+			rc = -EINVAL;
+			goto lmv_out_free;
 		}
 		lum = (struct lmv_user_md *)data->ioc_inlbuf2;
 		lumlen = data->ioc_inllen2;
@@ -1338,7 +1355,8 @@ out_free:
 		    lumlen != sizeof(*lum)) {
 			CERROR("%s: wrong lum magic %x or size %d: rc = %d\n",
 			       filename, lum->lum_magic, lumlen, -EFAULT);
-			GOTO(lmv_out_free, rc = -EINVAL);
+			rc = -EINVAL;
+			goto lmv_out_free;
 		}
 
 		/**
@@ -1395,22 +1413,28 @@ lmv_out_free:
 
 		lum_size = lmv_user_md_size(1, LMV_MAGIC_V1);
 		OBD_ALLOC(tmp, lum_size);
-		if (tmp == NULL)
-			GOTO(free_lmv, rc = -ENOMEM);
+		if (tmp == NULL) {
+			rc = -ENOMEM;
+			goto free_lmv;
+		}
 
 		*tmp = lum;
 		tmp->lum_type = LMV_STRIPE_TYPE;
 		tmp->lum_stripe_count = 1;
 		mdtindex = ll_get_mdt_idx(inode);
-		if (mdtindex < 0)
-			GOTO(free_lmv, rc = -ENOMEM);
+		if (mdtindex < 0) {
+			rc = -ENOMEM;
+			goto free_lmv;
+		}
 
 		tmp->lum_stripe_offset = mdtindex;
 		tmp->lum_objects[0].lum_mds = mdtindex;
 		memcpy(&tmp->lum_objects[0].lum_fid, ll_inode2fid(inode),
 		       sizeof(struct lu_fid));
-		if (copy_to_user((void *)arg, tmp, lum_size))
-			GOTO(free_lmv, rc = -EFAULT);
+		if (copy_to_user((void *)arg, tmp, lum_size)) {
+			rc = -EFAULT;
+			goto free_lmv;
+		}
 free_lmv:
 		if (tmp)
 			OBD_FREE(tmp, lum_size);
@@ -1434,8 +1458,10 @@ free_lmv:
 			return PTR_ERR(filename);
 
 		namelen = strlen(filename);
-		if (namelen < 1)
-			GOTO(out_rmdir, rc = -EINVAL);
+		if (namelen < 1) {
+			rc = -EINVAL;
+			goto out_rmdir;
+		}
 
 		rc = ll_rmdir_entry(inode, filename, namelen);
 out_rmdir:
@@ -1475,15 +1501,17 @@ out_rmdir:
 						      &RMF_MDT_BODY);
 			LASSERT(body != NULL);
 		} else {
-			GOTO(out_req, rc);
+			goto out_req;
 		}
 
 		if (rc < 0) {
 			if (rc == -ENODATA && (cmd == IOC_MDC_GETFILEINFO ||
-					       cmd == LL_IOC_MDC_GETINFO))
-				GOTO(skip_lmm, rc = 0);
+					       cmd == LL_IOC_MDC_GETINFO)) {
+				rc = 0;
+				goto skip_lmm;
+			}
 			else
-				GOTO(out_req, rc);
+				goto out_req;
 		}
 
 		if (cmd == IOC_MDC_GETFILESTRIPE ||
@@ -1495,8 +1523,10 @@ out_rmdir:
 			lump = &lmdp->lmd_lmm;
 		}
 		if (copy_to_user(lump, lmm, lmmsize)) {
-			if (copy_to_user(lump, lmm, sizeof(*lump)))
-				GOTO(out_req, rc = -EFAULT);
+			if (copy_to_user(lump, lmm, sizeof(*lump))) {
+				rc = -EFAULT;
+				goto out_req;
+			}
 			rc = -EOVERFLOW;
 		}
 skip_lmm:
@@ -1519,8 +1549,10 @@ skip_lmm:
 			st.st_ino     = inode->i_ino;
 
 			lmdp = (struct lov_user_mds_data *)arg;
-			if (copy_to_user(&lmdp->lmd_st, &st, sizeof(st)))
-				GOTO(out_req, rc = -EFAULT);
+			if (copy_to_user(&lmdp->lmd_st, &st, sizeof(st))) {
+				rc = -EFAULT;
+				goto out_req;
+			}
 		}
 
 out_req:
@@ -1547,8 +1579,10 @@ out_req:
 		OBD_ALLOC_LARGE(lmm, lmmsize);
 		if (lmm == NULL)
 			return -ENOMEM;
-		if (copy_from_user(lmm, lum, lmmsize))
-			GOTO(free_lmm, rc = -EFAULT);
+		if (copy_from_user(lmm, lum, lmmsize)) {
+			rc = -EFAULT;
+			goto free_lmm;
+		}
 
 		switch (lmm->lmm_magic) {
 		case LOV_USER_MAGIC_V1:
@@ -1570,22 +1604,27 @@ out_req:
 			lustre_swab_lov_user_md_v3((struct lov_user_md_v3 *)lmm);
 			break;
 		default:
-			GOTO(free_lmm, rc = -EINVAL);
+			rc = -EINVAL;
+			goto free_lmm;
 		}
 
 		rc = obd_unpackmd(sbi->ll_dt_exp, &lsm, lmm, lmmsize);
-		if (rc < 0)
-			GOTO(free_lmm, rc = -ENOMEM);
+		if (rc < 0) {
+			rc = -ENOMEM;
+			goto free_lmm;
+		}
 
 		/* Perform glimpse_size operation. */
 		memset(&st, 0, sizeof(st));
 
 		rc = ll_glimpse_ioctl(sbi, lsm, &st);
 		if (rc)
-			GOTO(free_lsm, rc);
+			goto free_lsm;
 
-		if (copy_to_user(&lumd->lmd_st, &st, sizeof(st)))
-			GOTO(free_lsm, rc = -EFAULT);
+		if (copy_to_user(&lumd->lmd_st, &st, sizeof(st))) {
+			rc = -EFAULT;
+			goto free_lsm;
+		}
 
 free_lsm:
 		obd_free_memmd(sbi->ll_dt_exp, &lsm);
@@ -1639,7 +1678,7 @@ free_lmm:
 			if (copy_to_user((void *)arg, check,
 					     sizeof(*check)))
 				CDEBUG(D_QUOTA, "copy_to_user failed\n");
-			GOTO(out_poll, rc);
+			goto out_poll;
 		}
 
 		rc = obd_iocontrol(cmd, sbi->ll_dt_exp, 0, (void *)check,
@@ -1649,7 +1688,7 @@ free_lmm:
 			if (copy_to_user((void *)arg, check,
 					     sizeof(*check)))
 				CDEBUG(D_QUOTA, "copy_to_user failed\n");
-			GOTO(out_poll, rc);
+			goto out_poll;
 		}
 out_poll:
 		OBD_FREE_PTR(check);
@@ -1667,11 +1706,15 @@ out_poll:
 			return -ENOMEM;
 
 		OBD_ALLOC_PTR(qctl_20);
-		if (!qctl_20)
-			GOTO(out_quotactl_18, rc = -ENOMEM);
+		if (!qctl_20) {
+			rc = -ENOMEM;
+			goto out_quotactl_18;
+		}
 
-		if (copy_from_user(qctl_18, (void *)arg, sizeof(*qctl_18)))
-			GOTO(out_quotactl_20, rc = -ENOMEM);
+		if (copy_from_user(qctl_18, (void *)arg, sizeof(*qctl_18))) {
+			rc = -ENOMEM;
+			goto out_quotactl_20;
+		}
 
 		QCTL_COPY(qctl_20, qctl_18);
 		qctl_20->qc_idx = 0;
@@ -1716,8 +1759,10 @@ out_quotactl_18:
 		if (!qctl)
 			return -ENOMEM;
 
-		if (copy_from_user(qctl, (void *)arg, sizeof(*qctl)))
-			GOTO(out_quotactl, rc = -EFAULT);
+		if (copy_from_user(qctl, (void *)arg, sizeof(*qctl))) {
+			rc = -EFAULT;
+			goto out_quotactl;
+		}
 
 		rc = quotactl_ioctl(sbi, qctl);
 
@@ -1931,14 +1976,14 @@ static loff_t ll_dir_seek(struct file *file, loff_t offset, int origin)
 			break;
 		case SEEK_END:
 			if (offset > 0)
-				GOTO(out, ret);
+				goto out;
 			if (api32)
 				offset += LL_DIR_END_OFF_32BIT;
 			else
 				offset += LL_DIR_END_OFF;
 			break;
 		default:
-			GOTO(out, ret);
+			goto out;
 	}
 
 	if (offset >= 0 &&
@@ -1957,7 +2002,7 @@ static loff_t ll_dir_seek(struct file *file, loff_t offset, int origin)
 		}
 		ret = offset;
 	}
-	GOTO(out, ret);
+	goto out;
 
 out:
 	mutex_unlock(&inode->i_mutex);
diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index 6ffbe7cb..531e062 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -142,12 +142,16 @@ static int ll_close_inode_openhandle(struct obd_export *md_exp,
 		 */
 		CERROR("Invalid MDC connection handle %#llx\n",
 		       ll_i2mdexp(inode)->exp_handle.h_cookie);
-		GOTO(out, rc = 0);
+		rc = 0;
+		goto out;
 	}
 
 	OBD_ALLOC_PTR(op_data);
-	if (op_data == NULL)
-		GOTO(out, rc = -ENOMEM); // XXX We leak openhandle and request here.
+	if (op_data == NULL) {
+		/* XXX We leak openhandle and request here. */
+		rc = -ENOMEM;
+		goto out;
+	}
 
 	ll_prepare_close(inode, op_data, och);
 	if (data_version != NULL) {
@@ -283,7 +287,7 @@ static int ll_md_close(struct obd_export *md_exp, struct inode *inode,
 	if (fd->fd_och != NULL) {
 		rc = ll_close_inode_openhandle(md_exp, inode, fd->fd_och, NULL);
 		fd->fd_och = NULL;
-		GOTO(out, rc);
+		goto out;
 	}
 
 	/* Let's see if we have good enough OPEN lock on the file and if
@@ -436,18 +440,20 @@ static int ll_intent_file_open(struct file *file, void *lmm,
 		*/
 		if (!it_disposition(itp, DISP_OPEN_OPEN) ||
 		     it_open_error(DISP_OPEN_OPEN, itp))
-			GOTO(out, rc);
+			goto out;
 		ll_release_openhandle(file->f_dentry, itp);
-		GOTO(out, rc);
+		goto out;
 	}
 
-	if (it_disposition(itp, DISP_LOOKUP_NEG))
-		GOTO(out, rc = -ENOENT);
+	if (it_disposition(itp, DISP_LOOKUP_NEG)) {
+		rc = -ENOENT;
+		goto out;
+	}
 
 	if (rc != 0 || it_open_error(DISP_OPEN_OPEN, itp)) {
 		rc = rc ? rc : it_open_error(DISP_OPEN_OPEN, itp);
 		CDEBUG(D_VFSTRACE, "lock enqueue: err: %d\n", rc);
-		GOTO(out, rc);
+		goto out;
 	}
 
 	rc = ll_prep_inode(&file->f_dentry->d_inode, req, NULL, itp);
@@ -551,8 +557,10 @@ int ll_file_open(struct inode *inode, struct file *file)
 	file->private_data = NULL; /* prevent ll_local_open assertion */
 
 	fd = ll_file_data_get();
-	if (fd == NULL)
-		GOTO(out_openerr, rc = -ENOMEM);
+	if (fd == NULL) {
+		rc = -ENOMEM;
+		goto out_openerr;
+	}
 
 	fd->fd_file = file;
 	if (S_ISDIR(inode->i_mode)) {
@@ -621,7 +629,7 @@ restart:
 			rc = it_open_error(DISP_OPEN_OPEN, it);
 			if (rc) {
 				mutex_unlock(&lli->lli_och_mutex);
-				GOTO(out_openerr, rc);
+				goto out_openerr;
 			}
 
 			ll_release_openhandle(file->f_dentry, it);
@@ -632,7 +640,7 @@ restart:
 		if (rc) {
 			(*och_usecount)--;
 			mutex_unlock(&lli->lli_och_mutex);
-			GOTO(out_openerr, rc);
+			goto out_openerr;
 		}
 	} else {
 		LASSERT(*och_usecount == 0);
@@ -647,13 +655,15 @@ restart:
 			rc = ll_intent_file_open(file, NULL, 0, it);
 			it->it_create_mode &= ~M_CHECK_STALE;
 			if (rc)
-				GOTO(out_openerr, rc);
+				goto out_openerr;
 
 			goto restart;
 		}
 		OBD_ALLOC(*och_p, sizeof (struct obd_client_handle));
-		if (!*och_p)
-			GOTO(out_och_free, rc = -ENOMEM);
+		if (!*och_p) {
+			rc = -ENOMEM;
+			goto out_och_free;
+		}
 
 		(*och_usecount)++;
 
@@ -664,13 +674,13 @@ restart:
 		 * just open error? */
 		rc = it_open_error(DISP_OPEN_OPEN, it);
 		if (rc)
-			GOTO(out_och_free, rc);
+			goto out_och_free;
 
 		LASSERT(it_disposition(it, DISP_ENQ_OPEN_REF));
 
 		rc = ll_local_open(file, it, fd, *och_p);
 		if (rc)
-			GOTO(out_och_free, rc);
+			goto out_och_free;
 	}
 	mutex_unlock(&lli->lli_och_mutex);
 	fd = NULL;
@@ -679,7 +689,7 @@ restart:
 	   different kind of OPEN lock for this same inode gets cancelled
 	   by ldlm_cancel_lru */
 	if (!S_ISREG(inode->i_mode))
-		GOTO(out_och_free, rc);
+		goto out_och_free;
 
 	ll_capa_open(inode);
 
@@ -687,10 +697,10 @@ restart:
 	    (cl_is_lov_delay_create(file->f_flags) ||
 	     (file->f_mode & FMODE_WRITE) == 0)) {
 		CDEBUG(D_INODE, "object creation was delayed\n");
-		GOTO(out_och_free, rc);
+		goto out_och_free;
 	}
 	cl_lov_delay_create_clear(&file->f_flags);
-	GOTO(out_och_free, rc);
+	goto out_och_free;
 
 out_och_free:
 	if (rc) {
@@ -807,8 +817,10 @@ ll_lease_open(struct inode *inode, struct file *file, fmode_t fmode,
 
 	op_data = ll_prep_md_op_data(NULL, inode, inode, NULL, 0, 0,
 					LUSTRE_OPC_ANY, NULL);
-	if (IS_ERR(op_data))
-		GOTO(out, rc = PTR_ERR(op_data));
+	if (IS_ERR(op_data)) {
+		rc = PTR_ERR(op_data);
+		goto out;
+	}
 
 	/* To tell the MDT this openhandle is from the same owner */
 	op_data->op_handle = old_handle;
@@ -827,20 +839,24 @@ ll_lease_open(struct inode *inode, struct file *file, fmode_t fmode,
 	ll_finish_md_op_data(op_data);
 	ptlrpc_req_finished(req);
 	if (rc < 0)
-		GOTO(out_release_it, rc);
+		goto out_release_it;
 
-	if (it_disposition(&it, DISP_LOOKUP_NEG))
-		GOTO(out_release_it, rc = -ENOENT);
+	if (it_disposition(&it, DISP_LOOKUP_NEG)) {
+		rc = -ENOENT;
+		goto out_release_it;
+	}
 
 	rc = it_open_error(DISP_OPEN_OPEN, &it);
 	if (rc)
-		GOTO(out_release_it, rc);
+		goto out_release_it;
 
 	LASSERT(it_disposition(&it, DISP_ENQ_OPEN_REF));
 	ll_och_fill(sbi->ll_md_exp, &it, och);
 
-	if (!it_disposition(&it, DISP_OPEN_LEASE)) /* old server? */
-		GOTO(out_close, rc = -EOPNOTSUPP);
+	if (!it_disposition(&it, DISP_OPEN_LEASE)) /* old server? */ {
+		rc = -EOPNOTSUPP;
+		goto out_close;
+	}
 
 	/* already get lease, handle lease lock */
 	ll_set_lock_data(sbi->ll_md_exp, inode, &it, NULL);
@@ -850,7 +866,8 @@ ll_lease_open(struct inode *inode, struct file *file, fmode_t fmode,
 		CERROR(DFID "lease granted but no open lock, %d/%llu.\n",
 			PFID(ll_inode2fid(inode)), it.d.lustre.it_lock_mode,
 			it.d.lustre.it_lock_bits);
-		GOTO(out_close, rc = -EPROTO);
+		rc = -EPROTO;
+		goto out_close;
 	}
 
 	ll_intent_release(&it);
@@ -1119,8 +1136,10 @@ restart:
 			if ((iot == CIT_WRITE) &&
 			    !(cio->cui_fd->fd_flags & LL_FILE_GROUP_LOCKED)) {
 				if (mutex_lock_interruptible(&lli->
-							       lli_write_mutex))
-					GOTO(out, result = -ERESTARTSYS);
+							       lli_write_mutex)) {
+					result = -ERESTARTSYS;
+					goto out;
+				}
 				write_mutex_locked = 1;
 			} else if (iot == CIT_READ) {
 				down_read(&lli->lli_trunc_sem);
@@ -1148,7 +1167,7 @@ restart:
 		result = io->ci_nob;
 		*ppos = io->u.ci_wr.wr.crw_pos;
 	}
-	GOTO(out, result);
+	goto out;
 out:
 	cl_io_fini(env, io);
 	/* If any bit been read/written (result != 0), we just return
@@ -1262,15 +1281,19 @@ static int ll_lov_recreate(struct inode *inode, struct ost_id *oi, u32 ost_idx)
 		return -ENOMEM;
 
 	lsm = ccc_inode_lsm_get(inode);
-	if (!lsm_has_objects(lsm))
-		GOTO(out, rc = -ENOENT);
+	if (!lsm_has_objects(lsm)) {
+		rc = -ENOENT;
+		goto out;
+	}
 
 	lsm_size = sizeof(*lsm) + (sizeof(struct lov_oinfo) *
 		   (lsm->lsm_stripe_count));
 
 	OBD_ALLOC_LARGE(lsm2, lsm_size);
-	if (lsm2 == NULL)
-		GOTO(out, rc = -ENOMEM);
+	if (lsm2 == NULL) {
+		rc = -ENOMEM;
+		goto out;
+	}
 
 	oa->o_oi = *oi;
 	oa->o_nlink = ost_idx;
@@ -1285,7 +1308,7 @@ static int ll_lov_recreate(struct inode *inode, struct ost_id *oi, u32 ost_idx)
 	ll_inode_size_unlock(inode);
 
 	OBD_FREE_LARGE(lsm2, lsm_size);
-	GOTO(out, rc);
+	goto out;
 out:
 	ccc_inode_lsm_put(inode, lsm);
 	OBDO_FREE(oa);
@@ -1338,16 +1361,17 @@ int ll_lov_setstripe_ea_info(struct inode *inode, struct file *file,
 		ccc_inode_lsm_put(inode, lsm);
 		CDEBUG(D_IOCTL, "stripe already exists for ino %lu\n",
 		       inode->i_ino);
-		GOTO(out, rc = -EEXIST);
+		rc = -EEXIST;
+		goto out;
 	}
 
 	ll_inode_size_lock(inode);
 	rc = ll_intent_file_open(file, lum, lum_size, &oit);
 	if (rc)
-		GOTO(out_unlock, rc);
+		goto out_unlock;
 	rc = oit.d.lustre.it_status;
 	if (rc < 0)
-		GOTO(out_req_free, rc);
+		goto out_req_free;
 
 	ll_release_openhandle(file->f_dentry, &oit);
 
@@ -1390,7 +1414,7 @@ int ll_lov_getstripe_ea_info(struct inode *inode, const char *filename,
 	if (rc < 0) {
 		CDEBUG(D_INFO, "md_getattr_name failed "
 		       "on %s: rc %d\n", filename, rc);
-		GOTO(out, rc);
+		goto out;
 	}
 
 	body = req_capsule_server_get(&req->rq_pill, &RMF_MDT_BODY);
@@ -1400,7 +1424,8 @@ int ll_lov_getstripe_ea_info(struct inode *inode, const char *filename,
 
 	if (!(body->valid & (OBD_MD_FLEASIZE | OBD_MD_FLDIREA)) ||
 			lmmsize == 0) {
-		GOTO(out, rc = -ENODATA);
+		rc = -ENODATA;
+		goto out;
 	}
 
 	lmm = req_capsule_server_sized_get(&req->rq_pill, &RMF_MDT_MD, lmmsize);
@@ -1408,7 +1433,8 @@ int ll_lov_getstripe_ea_info(struct inode *inode, const char *filename,
 
 	if ((lmm->lmm_magic != cpu_to_le32(LOV_MAGIC_V1)) &&
 	    (lmm->lmm_magic != cpu_to_le32(LOV_MAGIC_V3))) {
-		GOTO(out, rc = -EPROTO);
+		rc = -EPROTO;
+		goto out;
 	}
 
 	/*
@@ -1625,8 +1651,10 @@ int ll_release_openhandle(struct dentry *dentry, struct lookup_intent *it)
 	LASSERT(it_open_error(DISP_OPEN_OPEN, it) == 0);
 
 	OBD_ALLOC(och, sizeof(*och));
-	if (!och)
-		GOTO(out, rc = -ENOMEM);
+	if (!och) {
+		rc = -ENOMEM;
+		goto out;
+	}
 
 	ll_och_fill(ll_i2sbi(inode)->ll_md_exp, it, och);
 
@@ -1675,8 +1703,10 @@ static int ll_do_fiemap(struct inode *inode, struct ll_user_fiemap *fiemap,
 	 * DEVICE_ORDER flag, then it cannot interpret the extents correctly.
 	 */
 	if (lsm->lsm_stripe_count > 1 &&
-	    !(fiemap->fm_flags & FIEMAP_FLAG_DEVICE_ORDER))
-		GOTO(out, rc = -EOPNOTSUPP);
+	    !(fiemap->fm_flags & FIEMAP_FLAG_DEVICE_ORDER)) {
+		rc = -EOPNOTSUPP;
+		goto out;
+	}
 
 	fm_key.oa.o_oi = lsm->lsm_oi;
 	fm_key.oa.o_valid = OBD_MD_FLID | OBD_MD_FLGROUP;
@@ -1686,7 +1716,8 @@ static int ll_do_fiemap(struct inode *inode, struct ll_user_fiemap *fiemap,
 	/* If filesize is 0, then there would be no objects for mapping */
 	if (fm_key.oa.o_size == 0) {
 		fiemap->fm_mapped_extents = 0;
-		GOTO(out, rc = 0);
+		rc = 0;
+		goto out;
 	}
 
 	memcpy(&fm_key.fiemap, fiemap, sizeof(*fiemap));
@@ -1727,13 +1758,15 @@ int ll_fid2path(struct inode *inode, void __user *arg)
 	if (gfout == NULL)
 		return -ENOMEM;
 
-	if (copy_from_user(gfout, arg, sizeof(*gfout)))
-		GOTO(gf_free, rc = -EFAULT);
+	if (copy_from_user(gfout, arg, sizeof(*gfout))) {
+		rc = -EFAULT;
+		goto gf_free;
+	}
 
 	/* Call mdc_iocontrol */
 	rc = obd_iocontrol(OBD_IOC_FID2PATH, exp, outsize, gfout, NULL);
 	if (rc != 0)
-		GOTO(gf_free, rc);
+		goto gf_free;
 
 	if (copy_to_user(arg, gfout, outsize))
 		rc = -EFAULT;
@@ -1768,8 +1801,10 @@ static int ll_ioctl_fiemap(struct inode *inode, unsigned long arg)
 
 	/* get the fiemap value */
 	if (copy_from_user(fiemap_s, (struct ll_user_fiemap __user *)arg,
-			   sizeof(*fiemap_s)))
-		GOTO(error, rc = -EFAULT);
+			   sizeof(*fiemap_s))) {
+		rc = -EFAULT;
+		goto error;
+	}
 
 	/* If fm_extent_count is non-zero, read the first extent since
 	 * it is used to calculate end_offset and device from previous
@@ -1777,13 +1812,15 @@ static int ll_ioctl_fiemap(struct inode *inode, unsigned long arg)
 	if (extent_count) {
 		if (copy_from_user(&fiemap_s->fm_extents[0],
 		    (char __user *)arg + sizeof(*fiemap_s),
-		    sizeof(struct ll_fiemap_extent)))
-			GOTO(error, rc = -EFAULT);
+		    sizeof(struct ll_fiemap_extent))) {
+			rc = -EFAULT;
+			goto error;
+		}
 	}
 
 	rc = ll_do_fiemap(inode, fiemap_s, num_bytes);
 	if (rc)
-		GOTO(error, rc);
+		goto error;
 
 	ret_bytes = sizeof(struct ll_user_fiemap);
 
@@ -1821,12 +1858,15 @@ int ll_data_version(struct inode *inode, __u64 *data_version,
 	if (!lsm_has_objects(lsm)) {
 		*data_version = 0;
 		CDEBUG(D_INODE, "No object for inode\n");
-		GOTO(out, rc = 0);
+		rc = 0;
+		goto out;
 	}
 
 	OBD_ALLOC_PTR(obdo);
-	if (obdo == NULL)
-		GOTO(out, rc = -ENOMEM);
+	if (obdo == NULL) {
+		rc = -ENOMEM;
+		goto out;
+	}
 
 	rc = ll_lsm_getattr(lsm, sbi->ll_dt_exp, NULL, obdo, 0, extent_lock);
 	if (rc == 0) {
@@ -1859,17 +1899,21 @@ int ll_hsm_release(struct inode *inode)
 	       PFID(&ll_i2info(inode)->lli_fid));
 
 	och = ll_lease_open(inode, NULL, FMODE_WRITE, MDS_OPEN_RELEASE);
-	if (IS_ERR(och))
-		GOTO(out, rc = PTR_ERR(och));
+	if (IS_ERR(och)) {
+		rc = PTR_ERR(och);
+		goto out;
+	}
 
 	/* Grab latest data_version and [am]time values */
 	rc = ll_data_version(inode, &data_version, 1);
 	if (rc != 0)
-		GOTO(out, rc);
+		goto out;
 
 	env = cl_env_nested_get(&nest);
-	if (IS_ERR(env))
-		GOTO(out, rc = PTR_ERR(env));
+	if (IS_ERR(env)) {
+		rc = PTR_ERR(env);
+		goto out;
+	}
 
 	ll_merge_lvb(env, inode);
 	cl_env_nested_put(&nest, env);
@@ -1913,15 +1957,21 @@ static int ll_swap_layouts(struct file *file1, struct file *file2,
 	llss->inode1 = file1->f_dentry->d_inode;
 	llss->inode2 = file2->f_dentry->d_inode;
 
-	if (!S_ISREG(llss->inode2->i_mode))
-		GOTO(free, rc = -EINVAL);
+	if (!S_ISREG(llss->inode2->i_mode)) {
+		rc = -EINVAL;
+		goto free;
+	}
 
 	if (inode_permission(llss->inode1, MAY_WRITE) ||
-	    inode_permission(llss->inode2, MAY_WRITE))
-		GOTO(free, rc = -EPERM);
+	    inode_permission(llss->inode2, MAY_WRITE)) {
+		rc = -EPERM;
+		goto free;
+	}
 
-	if (llss->inode2->i_sb != llss->inode1->i_sb)
-		GOTO(free, rc = -EXDEV);
+	if (llss->inode2->i_sb != llss->inode1->i_sb) {
+		rc = -EXDEV;
+		goto free;
+	}
 
 	/* we use 2 bool because it is easier to swap than 2 bits */
 	if (lsl->sl_flags & SWAP_LAYOUTS_CHECK_DV1)
@@ -1935,8 +1985,10 @@ static int ll_swap_layouts(struct file *file1, struct file *file2,
 	llss->dv2 = lsl->sl_dv2;
 
 	rc = lu_fid_cmp(ll_inode2fid(llss->inode1), ll_inode2fid(llss->inode2));
-	if (rc == 0) /* same file, done! */
-		GOTO(free, rc = 0);
+	if (rc == 0) /* same file, done! */ {
+		rc = 0;
+		goto free;
+	}
 
 	if (rc < 0) { /* sequentialize it */
 		swap(llss->inode1, llss->inode2);
@@ -1949,12 +2001,12 @@ static int ll_swap_layouts(struct file *file1, struct file *file2,
 	if (gid != 0) { /* application asks to flush dirty cache */
 		rc = ll_get_grouplock(llss->inode1, file1, gid);
 		if (rc < 0)
-			GOTO(free, rc);
+			goto free;
 
 		rc = ll_get_grouplock(llss->inode2, file2, gid);
 		if (rc < 0) {
 			ll_put_grouplock(llss->inode1, file1, gid);
-			GOTO(free, rc);
+			goto free;
 		}
 	}
 
@@ -1975,17 +2027,21 @@ static int ll_swap_layouts(struct file *file1, struct file *file2,
 	if (llss->check_dv1) {
 		rc = ll_data_version(llss->inode1, &dv, 0);
 		if (rc)
-			GOTO(putgl, rc);
-		if (dv != llss->dv1)
-			GOTO(putgl, rc = -EAGAIN);
+			goto putgl;
+		if (dv != llss->dv1) {
+			rc = -EAGAIN;
+			goto putgl;
+		}
 	}
 
 	if (llss->check_dv2) {
 		rc = ll_data_version(llss->inode2, &dv, 0);
 		if (rc)
-			GOTO(putgl, rc);
-		if (dv != llss->dv2)
-			GOTO(putgl, rc = -EAGAIN);
+			goto putgl;
+		if (dv != llss->dv2) {
+			rc = -EAGAIN;
+			goto putgl;
+		}
 	}
 
 	/* struct md_op_data is used to send the swap args to the mdt
@@ -1997,8 +2053,10 @@ static int ll_swap_layouts(struct file *file1, struct file *file2,
 	rc = -ENOMEM;
 	op_data = ll_prep_md_op_data(NULL, llss->inode1, llss->inode2, NULL, 0,
 				     0, LUSTRE_OPC_ANY, &msl);
-	if (IS_ERR(op_data))
-		GOTO(free, rc = PTR_ERR(op_data));
+	if (IS_ERR(op_data)) {
+		rc = PTR_ERR(op_data);
+		goto free;
+	}
 
 	rc = obd_iocontrol(LL_IOC_LOV_SWAP_LAYOUTS, ll_i2mdexp(llss->inode1),
 			   sizeof(*op_data), op_data, NULL);
@@ -2012,7 +2070,7 @@ putgl:
 
 	/* rc can be set from obd_iocontrol() or from a GOTO(putgl, ...) */
 	if (rc != 0)
-		GOTO(free, rc);
+		goto free;
 
 	/* clear useless flags */
 	if (!(lsl->sl_flags & SWAP_LAYOUTS_KEEP_MTIME)) {
@@ -2087,19 +2145,23 @@ static int ll_hsm_import(struct inode *inode, struct file *file,
 
 	/* set HSM flags */
 	OBD_ALLOC_PTR(hss);
-	if (hss == NULL)
-		GOTO(out, rc = -ENOMEM);
+	if (hss == NULL) {
+		rc = -ENOMEM;
+		goto out;
+	}
 
 	hss->hss_valid = HSS_SETMASK | HSS_ARCHIVE_ID;
 	hss->hss_archive_id = hui->hui_archive_id;
 	hss->hss_setmask = HS_ARCHIVED | HS_EXISTS | HS_RELEASED;
 	rc = ll_hsm_state_set(inode, hss);
 	if (rc != 0)
-		GOTO(out, rc);
+		goto out;
 
 	OBD_ALLOC_PTR(attr);
-	if (attr == NULL)
-		GOTO(out, rc = -ENOMEM);
+	if (attr == NULL) {
+		rc = -ENOMEM;
+		goto out;
+	}
 
 	attr->ia_mode = hui->hui_mode & (S_IRWXU | S_IRWXG | S_IRWXO);
 	attr->ia_mode |= S_IFREG;
@@ -2873,13 +2935,13 @@ static int __ll_inode_revalidate(struct dentry *dentry, __u64 ibits)
 		oit.it_create_mode &= ~M_CHECK_STALE;
 		if (rc < 0) {
 			rc = ll_inode_revalidate_fini(inode, rc);
-			GOTO (out, rc);
+			goto out;
 		}
 
 		rc = ll_revalidate_it_finish(req, &oit, dentry);
 		if (rc != 0) {
 			ll_intent_release(&oit);
-			GOTO(out, rc);
+			goto out;
 		}
 
 		/* Unlinked? Unhash dentry, so it is not picked up later by
@@ -3303,20 +3365,28 @@ static int ll_layout_fetch(struct inode *inode, struct ldlm_lock *lock)
 		return rc;
 
 	body = req_capsule_server_get(&req->rq_pill, &RMF_MDT_BODY);
-	if (body == NULL)
-		GOTO(out, rc = -EPROTO);
+	if (body == NULL) {
+		rc = -EPROTO;
+		goto out;
+	}
 
 	lmmsize = body->eadatasize;
-	if (lmmsize == 0) /* empty layout */
-		GOTO(out, rc = 0);
+	if (lmmsize == 0) /* empty layout */ {
+		rc = 0;
+		goto out;
+	}
 
 	lmm = req_capsule_server_sized_get(&req->rq_pill, &RMF_EADATA, lmmsize);
-	if (lmm == NULL)
-		GOTO(out, rc = -EFAULT);
+	if (lmm == NULL) {
+		rc = -EFAULT;
+		goto out;
+	}
 
 	OBD_ALLOC_LARGE(lvbdata, lmmsize);
-	if (lvbdata == NULL)
-		GOTO(out, rc = -ENOMEM);
+	if (lvbdata == NULL) {
+		rc = -ENOMEM;
+		goto out;
+	}
 
 	memcpy(lvbdata, lmm, lmmsize);
 	lock_res_and_lock(lock);
@@ -3373,12 +3443,12 @@ static int ll_layout_lock_set(struct lustre_handle *lockh, ldlm_mode_t mode,
 			*gen = ll_layout_version_get(lli);
 			rc = 0;
 		}
-		GOTO(out, rc);
+		goto out;
 	}
 
 	rc = ll_layout_fetch(inode, lock);
 	if (rc < 0)
-		GOTO(out, rc);
+		goto out;
 
 	/* for layout lock, lmm is returned in lock's lvb.
 	 * lvb_data is immutable if the lock is held so it's safe to access it
@@ -3399,7 +3469,7 @@ static int ll_layout_lock_set(struct lustre_handle *lockh, ldlm_mode_t mode,
 		}
 	}
 	if (rc < 0)
-		GOTO(out, rc);
+		goto out;
 
 	/* set layout to file. Unlikely this will fail as old layout was
 	 * surely eliminated */
diff --git a/drivers/staging/lustre/lustre/llite/llite_capa.c b/drivers/staging/lustre/lustre/llite/llite_capa.c
index 023c405..b1e39ee 100644
--- a/drivers/staging/lustre/lustre/llite/llite_capa.c
+++ b/drivers/staging/lustre/lustre/llite/llite_capa.c
@@ -543,7 +543,7 @@ static int ll_update_capa(struct obd_capa *ocapa, struct lustre_capa *capa)
 					   "renewal failed: -EIO, "
 					   "retry in 2 mins");
 				ll_capa_renewal_retries++;
-				GOTO(retry, rc);
+				goto retry;
 			} else {
 				DEBUG_CAPA(D_ERROR, &ocapa->c_capa,
 					   "renewal failed(rc: %d) for", rc);
diff --git a/drivers/staging/lustre/lustre/llite/llite_close.c b/drivers/staging/lustre/lustre/llite/llite_close.c
index 6a3a7a3..79e22f8 100644
--- a/drivers/staging/lustre/lustre/llite/llite_close.c
+++ b/drivers/staging/lustre/lustre/llite/llite_close.c
@@ -155,7 +155,7 @@ void ll_ioepoch_close(struct inode *inode, struct md_op_data *op_data,
 
 			inode = igrab(inode);
 			LASSERT(inode);
-			GOTO(out, 0);
+			goto out;
 		}
 		if (flags & LLIF_DONE_WRITING) {
 			/* Some pages are still dirty, it is early to send
@@ -167,7 +167,7 @@ void ll_ioepoch_close(struct inode *inode, struct md_op_data *op_data,
 
 			inode = igrab(inode);
 			LASSERT(inode);
-			GOTO(out, 0);
+			goto out;
 		}
 	}
 	CDEBUG(D_INODE, "Epoch %llu closed on "DFID"\n",
@@ -184,14 +184,14 @@ void ll_ioepoch_close(struct inode *inode, struct md_op_data *op_data,
 		/* Pack Size-on-MDS inode attributes only if they has changed */
 		if (!(lli->lli_flags & LLIF_SOM_DIRTY)) {
 			spin_unlock(&lli->lli_lock);
-			GOTO(out, 0);
+			goto out;
 		}
 
 		/* There is a pending DONE_WRITE -- close epoch with no
 		 * attribute change. */
 		if (lli->lli_flags & LLIF_EPOCH_PENDING) {
 			spin_unlock(&lli->lli_lock);
-			GOTO(out, 0);
+			goto out;
 		}
 	}
 
@@ -294,7 +294,7 @@ static void ll_done_writing(struct inode *inode)
 	ll_prepare_done_writing(inode, op_data, &och);
 	/* If there is no @och, we do not do D_W yet. */
 	if (och == NULL)
-		GOTO(out, 0);
+		goto out;
 
 	rc = md_done_writing(ll_i2sbi(inode)->ll_md_exp, op_data, NULL);
 	if (rc == -EAGAIN) {
diff --git a/drivers/staging/lustre/lustre/llite/llite_lib.c b/drivers/staging/lustre/lustre/llite/llite_lib.c
index 7874555..5e39e3a 100644
--- a/drivers/staging/lustre/lustre/llite/llite_lib.c
+++ b/drivers/staging/lustre/lustre/llite/llite_lib.c
@@ -255,10 +255,10 @@ static int client_common_fill_super(struct super_block *sb, char *md, char *dt,
 				   "recovery, of which this client is not a "
 				   "part. Please wait for recovery to complete,"
 				   " abort, or time out.\n", md);
-		GOTO(out, err);
+		goto out;
 	} else if (err) {
 		CERROR("cannot connect to %s: rc = %d\n", md, err);
-		GOTO(out, err);
+		goto out;
 	}
 
 	sbi->ll_md_exp->exp_connect_data = *data;
@@ -268,7 +268,7 @@ static int client_common_fill_super(struct super_block *sb, char *md, char *dt,
 	if (err) {
 		CERROR("%s: Can't init metadata layer FID infrastructure, "
 		       "rc = %d\n", sbi->ll_md_exp->exp_obd->obd_name, err);
-		GOTO(out_md, err);
+		goto out_md;
 	}
 
 	/* For mount, we only need fs info from MDT0, and also in DNE, it
@@ -278,7 +278,7 @@ static int client_common_fill_super(struct super_block *sb, char *md, char *dt,
 			cfs_time_shift_64(-OBD_STATFS_CACHE_SECONDS),
 			OBD_STATFS_FOR_MDT0);
 	if (err)
-		GOTO(out_md_fid, err);
+		goto out_md_fid;
 
 	/* This needs to be after statfs to ensure connect has finished.
 	 * Note that "data" does NOT contain the valid connect reply.
@@ -301,7 +301,8 @@ static int client_common_fill_super(struct super_block *sb, char *md, char *dt,
 				   "server or downgrade client.\n",
 				   sbi->ll_md_exp->exp_obd->obd_name, buf);
 		OBD_FREE(buf, PAGE_CACHE_SIZE);
-		GOTO(out_md_fid, err = -EPROTO);
+		err = -EPROTO;
+		goto out_md_fid;
 	}
 
 	size = sizeof(*data);
@@ -310,7 +311,7 @@ static int client_common_fill_super(struct super_block *sb, char *md, char *dt,
 	if (err) {
 		CERROR("%s: Get connect data failed: rc = %d\n",
 		       sbi->ll_md_exp->exp_obd->obd_name, err);
-		GOTO(out_md_fid, err);
+		goto out_md_fid;
 	}
 
 	LASSERT(osfs->os_bsize);
@@ -391,7 +392,8 @@ static int client_common_fill_super(struct super_block *sb, char *md, char *dt,
 	obd = class_name2obd(dt);
 	if (!obd) {
 		CERROR("DT %s: not setup or attached\n", dt);
-		GOTO(out_md_fid, err = -ENODEV);
+		err = -ENODEV;
+		goto out_md_fid;
 	}
 
 	data->ocd_connect_flags = OBD_CONNECT_GRANT     | OBD_CONNECT_VERSION  |
@@ -442,11 +444,11 @@ static int client_common_fill_super(struct super_block *sb, char *md, char *dt,
 				   "recovery, of which this client is not a "
 				   "part.  Please wait for recovery to "
 				   "complete, abort, or time out.\n", dt);
-		GOTO(out_md, err);
+		goto out_md;
 	} else if (err) {
 		CERROR("%s: Cannot connect to %s: rc = %d\n",
 		       sbi->ll_dt_exp->exp_obd->obd_name, dt, err);
-		GOTO(out_md, err);
+		goto out_md;
 	}
 
 	sbi->ll_dt_exp->exp_connect_data = *data;
@@ -456,7 +458,7 @@ static int client_common_fill_super(struct super_block *sb, char *md, char *dt,
 	if (err) {
 		CERROR("%s: Can't init data layer FID infrastructure, "
 		       "rc = %d\n", sbi->ll_dt_exp->exp_obd->obd_name, err);
-		GOTO(out_dt, err);
+		goto out_dt;
 	}
 
 	mutex_lock(&sbi->ll_lco.lco_lock);
@@ -469,13 +471,14 @@ static int client_common_fill_super(struct super_block *sb, char *md, char *dt,
 	err = md_getstatus(sbi->ll_md_exp, &sbi->ll_root_fid, &oc);
 	if (err) {
 		CERROR("cannot mds_connect: rc = %d\n", err);
-		GOTO(out_lock_cn_cb, err);
+		goto out_lock_cn_cb;
 	}
 	if (!fid_is_sane(&sbi->ll_root_fid)) {
 		CERROR("%s: Invalid root fid "DFID" during mount\n",
 		       sbi->ll_md_exp->exp_obd->obd_name,
 		       PFID(&sbi->ll_root_fid));
-		GOTO(out_lock_cn_cb, err = -EINVAL);
+		err = -EINVAL;
+		goto out_lock_cn_cb;
 	}
 	CDEBUG(D_SUPER, "rootfid "DFID"\n", PFID(&sbi->ll_root_fid));
 
@@ -493,8 +496,10 @@ static int client_common_fill_super(struct super_block *sb, char *md, char *dt,
 		valid |= OBD_MD_FLACL;
 
 	OBD_ALLOC_PTR(op_data);
-	if (op_data == NULL)
-		GOTO(out_lock_cn_cb, err = -ENOMEM);
+	if (op_data == NULL) {
+		err = -ENOMEM;
+		goto out_lock_cn_cb;
+	}
 
 	op_data->op_fid1 = sbi->ll_root_fid;
 	op_data->op_mode = 0;
@@ -508,7 +513,7 @@ static int client_common_fill_super(struct super_block *sb, char *md, char *dt,
 	if (err) {
 		CERROR("%s: md_getattr failed for root: rc = %d\n",
 		       sbi->ll_md_exp->exp_obd->obd_name, err);
-		GOTO(out_lock_cn_cb, err);
+		goto out_lock_cn_cb;
 	}
 
 	err = md_get_lustre_md(sbi->ll_md_exp, request, sbi->ll_dt_exp,
@@ -516,7 +521,7 @@ static int client_common_fill_super(struct super_block *sb, char *md, char *dt,
 	if (err) {
 		CERROR("failed to understand root inode md: rc = %d\n", err);
 		ptlrpc_req_finished(request);
-		GOTO(out_lock_cn_cb, err);
+		goto out_lock_cn_cb;
 	}
 
 	LASSERT(fid_is_sane(&sbi->ll_root_fid));
@@ -538,13 +543,13 @@ static int client_common_fill_super(struct super_block *sb, char *md, char *dt,
 		err = IS_ERR(root) ? PTR_ERR(root) : -EBADF;
 		root = NULL;
 		CERROR("lustre_lite: bad iget4 for root\n");
-		GOTO(out_root, err);
+		goto out_root;
 	}
 
 	err = ll_close_thread_start(&sbi->ll_lcq);
 	if (err) {
 		CERROR("cannot start close thread: rc %d\n", err);
-		GOTO(out_root, err);
+		goto out_root;
 	}
 
 #ifdef CONFIG_FS_POSIX_ACL
@@ -568,7 +573,8 @@ static int client_common_fill_super(struct super_block *sb, char *md, char *dt,
 	if (sb->s_root == NULL) {
 		CERROR("%s: can't make root dentry\n",
 			ll_get_fsname(sb, NULL, 0));
-		GOTO(out_root, err = -ENOMEM);
+		err = -ENOMEM;
+		goto out_root;
 	}
 
 	sbi->ll_sdev_orig = sb->s_dev;
@@ -1002,16 +1008,16 @@ int ll_fill_super(struct super_block *sb, struct vfsmount *mnt)
 
 	err = ll_options(lsi->lsi_lmd->lmd_opts, &sbi->ll_flags);
 	if (err)
-		GOTO(out_free, err);
+		goto out_free;
 
 	err = bdi_init(&lsi->lsi_bdi);
 	if (err)
-		GOTO(out_free, err);
+		goto out_free;
 	lsi->lsi_flags |= LSI_BDI_INITIALIZED;
 	lsi->lsi_bdi.capabilities = BDI_CAP_MAP_COPY;
 	err = ll_bdi_register(&lsi->lsi_bdi);
 	if (err)
-		GOTO(out_free, err);
+		goto out_free;
 
 	sb->s_bdi = &lsi->lsi_bdi;
 	/* kernel >= 2.6.38 store dentry operations in sb->s_d_op. */
@@ -1027,7 +1033,7 @@ int ll_fill_super(struct super_block *sb, struct vfsmount *mnt)
 	err = lustre_process_log(sb, profilenm, cfg);
 	if (err < 0) {
 		CERROR("Unable to process log: %d\n", err);
-		GOTO(out_free, err);
+		goto out_free;
 	}
 
 	/* Profile set with LCFG_MOUNTOPT so we can find our mdc and osc obds */
@@ -1036,19 +1042,24 @@ int ll_fill_super(struct super_block *sb, struct vfsmount *mnt)
 		LCONSOLE_ERROR_MSG(0x156, "The client profile '%s' could not be"
 				   " read from the MGS.  Does that filesystem "
 				   "exist?\n", profilenm);
-		GOTO(out_free, err = -EINVAL);
+		err = -EINVAL;
+		goto out_free;
 	}
 	CDEBUG(D_CONFIG, "Found profile %s: mdc=%s osc=%s\n", profilenm,
 	       lprof->lp_md, lprof->lp_dt);
 
 	OBD_ALLOC(dt, strlen(lprof->lp_dt) + instlen + 2);
-	if (!dt)
-		GOTO(out_free, err = -ENOMEM);
+	if (!dt) {
+		err = -ENOMEM;
+		goto out_free;
+	}
 	sprintf(dt, "%s-%p", lprof->lp_dt, cfg->cfg_instance);
 
 	OBD_ALLOC(md, strlen(lprof->lp_md) + instlen + 2);
-	if (!md)
-		GOTO(out_free, err = -ENOMEM);
+	if (!md) {
+		err = -ENOMEM;
+		goto out_free;
+	}
 	sprintf(md, "%s-%p", lprof->lp_md, cfg->cfg_instance);
 
 	/* connections, registrations, sb setup */
@@ -1466,14 +1477,15 @@ int ll_setattr_raw(struct dentry *dentry, struct iattr *attr, bool hsm_import)
 
 	rc = ll_md_setattr(dentry, op_data, &mod);
 	if (rc)
-		GOTO(out, rc);
+		goto out;
 
 	/* truncate failed (only when non HSM import), others succeed */
 	if (file_is_released) {
 		if ((attr->ia_valid & ATTR_SIZE) && !hsm_import)
-			GOTO(out, rc = -ENODATA);
+			rc = -ENODATA;
 		else
-			GOTO(out, rc = 0);
+			rc = 0;
+		goto out;
 	}
 
 	/* RPC to MDT is sent, cancel data modification flag */
@@ -1484,8 +1496,10 @@ int ll_setattr_raw(struct dentry *dentry, struct iattr *attr, bool hsm_import)
 	}
 
 	ll_ioepoch_open(lli, op_data->op_ioepoch);
-	if (!S_ISREG(inode->i_mode))
-		GOTO(out, rc = 0);
+	if (!S_ISREG(inode->i_mode)) {
+		rc = 0;
+		goto out;
+	}
 
 	if (attr->ia_valid & (ATTR_SIZE |
 			      ATTR_ATIME | ATTR_ATIME_SET |
@@ -2101,7 +2115,7 @@ int ll_prep_inode(struct inode **inode, struct ptlrpc_request *req,
 			rc = IS_ERR(*inode) ? PTR_ERR(*inode) : -ENOMEM;
 			*inode = NULL;
 			CERROR("new_inode -fatal: rc %d\n", rc);
-			GOTO(out, rc);
+			goto out;
 		}
 	}
 
@@ -2150,36 +2164,44 @@ int ll_obd_statfs(struct inode *inode, void *arg)
 	__u32 flags;
 	int len = 0, rc;
 
-	if (!inode || !(sbi = ll_i2sbi(inode)))
-		GOTO(out_statfs, rc = -EINVAL);
+	if (!inode || !(sbi = ll_i2sbi(inode))) {
+		rc = -EINVAL;
+		goto out_statfs;
+	}
 
 	rc = obd_ioctl_getdata(&buf, &len, arg);
 	if (rc)
-		GOTO(out_statfs, rc);
+		goto out_statfs;
 
 	data = (void*)buf;
 	if (!data->ioc_inlbuf1 || !data->ioc_inlbuf2 ||
-	    !data->ioc_pbuf1 || !data->ioc_pbuf2)
-		GOTO(out_statfs, rc = -EINVAL);
+	    !data->ioc_pbuf1 || !data->ioc_pbuf2) {
+		rc = -EINVAL;
+		goto out_statfs;
+	}
 
 	if (data->ioc_inllen1 != sizeof(__u32) ||
 	    data->ioc_inllen2 != sizeof(__u32) ||
 	    data->ioc_plen1 != sizeof(struct obd_statfs) ||
-	    data->ioc_plen2 != sizeof(struct obd_uuid))
-		GOTO(out_statfs, rc = -EINVAL);
+	    data->ioc_plen2 != sizeof(struct obd_uuid)) {
+		rc = -EINVAL;
+		goto out_statfs;
+	}
 
 	memcpy(&type, data->ioc_inlbuf1, sizeof(__u32));
 	if (type & LL_STATFS_LMV)
 		exp = sbi->ll_md_exp;
 	else if (type & LL_STATFS_LOV)
 		exp = sbi->ll_dt_exp;
-	else
-		GOTO(out_statfs, rc = -ENODEV);
+	else {
+		rc = -ENODEV;
+		goto out_statfs;
+	}
 
 	flags = (type & LL_STATFS_NODELAY) ? OBD_STATFS_NODELAY : 0;
 	rc = obd_iocontrol(IOC_OBD_STATFS, exp, len, buf, &flags);
 	if (rc)
-		GOTO(out_statfs, rc);
+		goto out_statfs;
 out_statfs:
 	if (buf)
 		obd_ioctl_freedata(buf, len);
diff --git a/drivers/staging/lustre/lustre/llite/llite_mmap.c b/drivers/staging/lustre/lustre/llite/llite_mmap.c
index 5916648..fe5e83a 100644
--- a/drivers/staging/lustre/lustre/llite/llite_mmap.c
+++ b/drivers/staging/lustre/lustre/llite/llite_mmap.c
@@ -181,12 +181,14 @@ static int ll_page_mkwrite0(struct vm_area_struct *vma, struct page *vmpage,
 	LASSERT(vmpage != NULL);
 
 	io = ll_fault_io_init(vma, &env,  &nest, vmpage->index, NULL);
-	if (IS_ERR(io))
-		GOTO(out, result = PTR_ERR(io));
+	if (IS_ERR(io)) {
+		result = PTR_ERR(io);
+		goto out;
+	}
 
 	result = io->ci_result;
 	if (result < 0)
-		GOTO(out_io, result);
+		goto out_io;
 
 	io->u.ci_fault.ft_mkwrite = 1;
 	io->u.ci_fault.ft_writable = 1;
diff --git a/drivers/staging/lustre/lustre/llite/llite_nfs.c b/drivers/staging/lustre/lustre/llite/llite_nfs.c
index 8fdd6e0..3383293 100644
--- a/drivers/staging/lustre/lustre/llite/llite_nfs.c
+++ b/drivers/staging/lustre/lustre/llite/llite_nfs.c
@@ -236,11 +236,15 @@ static int ll_get_name(struct dentry *dentry, char *name,
 		.ctx.actor = ll_nfs_get_name_filldir,
 	};
 
-	if (!dir || !S_ISDIR(dir->i_mode))
-		GOTO(out, rc = -ENOTDIR);
+	if (!dir || !S_ISDIR(dir->i_mode)) {
+		rc = -ENOTDIR;
+		goto out;
+	}
 
-	if (!dir->i_fop)
-		GOTO(out, rc = -EINVAL);
+	if (!dir->i_fop) {
+		rc = -EINVAL;
+		goto out;
+	}
 
 	mutex_lock(&dir->i_mutex);
 	rc = ll_dir_read(dir, &lgd.ctx);
diff --git a/drivers/staging/lustre/lustre/llite/lloop.c b/drivers/staging/lustre/lustre/llite/lloop.c
index 3c29c38..177137a 100644
--- a/drivers/staging/lustre/lustre/llite/lloop.c
+++ b/drivers/staging/lustre/lustre/llite/lloop.c
@@ -409,8 +409,10 @@ static int loop_thread(void *data)
 	lo->lo_state = LLOOP_BOUND;
 
 	env = cl_env_get(&refcheck);
-	if (IS_ERR(env))
-		GOTO(out, ret = PTR_ERR(env));
+	if (IS_ERR(env)) {
+		ret = PTR_ERR(env);
+		goto out;
+	}
 
 	lo->lo_env = env;
 	memset(&lo->lo_pvec, 0, sizeof(lo->lo_pvec));
@@ -670,8 +672,10 @@ static enum llioc_iter lloop_ioctl(struct inode *unused, struct file *file,
 	if (magic != ll_iocontrol_magic)
 		return LLIOC_CONT;
 
-	if (disks == NULL)
-		GOTO(out1, err = -ENODEV);
+	if (disks == NULL) {
+		err = -ENODEV;
+		goto out1;
+	}
 
 	CWARN("Enter llop_ioctl\n");
 
@@ -692,19 +696,25 @@ static enum llioc_iter lloop_ioctl(struct inode *unused, struct file *file,
 			    file->f_dentry->d_inode)
 				break;
 		}
-		if (lo || !lo_free)
-			GOTO(out, err = -EBUSY);
+		if (lo || !lo_free) {
+			err = -EBUSY;
+			goto out;
+		}
 
 		lo = lo_free;
 		dev = MKDEV(lloop_major, lo->lo_number);
 
 		/* quit if the used pointer is writable */
-		if (put_user((long)old_encode_dev(dev), (long*)arg))
-			GOTO(out, err = -EFAULT);
+		if (put_user((long)old_encode_dev(dev), (long*)arg)) {
+			err = -EFAULT;
+			goto out;
+		}
 
 		bdev = blkdev_get_by_dev(dev, file->f_mode, NULL);
-		if (IS_ERR(bdev))
-			GOTO(out, err = PTR_ERR(bdev));
+		if (IS_ERR(bdev)) {
+			err = PTR_ERR(bdev);
+			goto out;
+		}
 
 		get_file(file);
 		err = loop_set_fd(lo, NULL, bdev, file);
@@ -720,16 +730,22 @@ static enum llioc_iter lloop_ioctl(struct inode *unused, struct file *file,
 		int minor;
 
 		dev = old_decode_dev(arg);
-		if (MAJOR(dev) != lloop_major)
-			GOTO(out, err = -EINVAL);
+		if (MAJOR(dev) != lloop_major) {
+			err = -EINVAL;
+			goto out;
+		}
 
 		minor = MINOR(dev);
-		if (minor > max_loop - 1)
-			GOTO(out, err = -EINVAL);
+		if (minor > max_loop - 1) {
+			err = -EINVAL;
+			goto out;
+		}
 
 		lo = &loop_dev[minor];
-		if (lo->lo_state != LLOOP_BOUND)
-			GOTO(out, err = -EINVAL);
+		if (lo->lo_state != LLOOP_BOUND) {
+			err = -EINVAL;
+			goto out;
+		}
 
 		bdev = lo->lo_device;
 		err = loop_clr_fd(lo, bdev, 1);
diff --git a/drivers/staging/lustre/lustre/llite/lproc_llite.c b/drivers/staging/lustre/lustre/llite/lproc_llite.c
index 77f68b5..04ebdd1 100644
--- a/drivers/staging/lustre/lustre/llite/lproc_llite.c
+++ b/drivers/staging/lustre/lustre/llite/lproc_llite.c
@@ -410,7 +410,8 @@ static ssize_t ll_max_cached_mb_seq_write(struct file *file,
 	/* easy - add more LRU slots. */
 	if (diff >= 0) {
 		atomic_add(diff, &cache->ccc_lru_left);
-		GOTO(out, rc = 0);
+		rc = 0;
+		goto out;
 	}
 
 	diff = -diff;
@@ -997,8 +998,10 @@ int lprocfs_register_mountpoint(struct proc_dir_entry *parent,
 	/* File operations stats */
 	sbi->ll_stats = lprocfs_alloc_stats(LPROC_LL_FILE_OPCODES,
 					    LPROCFS_STATS_FLAG_NONE);
-	if (sbi->ll_stats == NULL)
-		GOTO(out, err = -ENOMEM);
+	if (sbi->ll_stats == NULL) {
+		err = -ENOMEM;
+		goto out;
+	}
 	/* do counter init */
 	for (id = 0; id < LPROC_LL_FILE_OPCODES; id++) {
 		__u32 type = llite_opcode_table[id].type;
@@ -1016,12 +1019,14 @@ int lprocfs_register_mountpoint(struct proc_dir_entry *parent,
 	}
 	err = lprocfs_register_stats(sbi->ll_proc_root, "stats", sbi->ll_stats);
 	if (err)
-		GOTO(out, err);
+		goto out;
 
 	sbi->ll_ra_stats = lprocfs_alloc_stats(ARRAY_SIZE(ra_stat_string),
 					       LPROCFS_STATS_FLAG_NONE);
-	if (sbi->ll_ra_stats == NULL)
-		GOTO(out, err = -ENOMEM);
+	if (sbi->ll_ra_stats == NULL) {
+		err = -ENOMEM;
+		goto out;
+	}
 
 	for (id = 0; id < ARRAY_SIZE(ra_stat_string); id++)
 		lprocfs_counter_init(sbi->ll_ra_stats, id, 0,
@@ -1029,12 +1034,12 @@ int lprocfs_register_mountpoint(struct proc_dir_entry *parent,
 	err = lprocfs_register_stats(sbi->ll_proc_root, "read_ahead_stats",
 				     sbi->ll_ra_stats);
 	if (err)
-		GOTO(out, err);
+		goto out;
 
 
 	err = lprocfs_add_vars(sbi->ll_proc_root, lprocfs_llite_obd_vars, sb);
 	if (err)
-		GOTO(out, err);
+		goto out;
 
 	/* MDC info */
 	obd = class_name2obd(mdc);
@@ -1044,20 +1049,22 @@ int lprocfs_register_mountpoint(struct proc_dir_entry *parent,
 	LASSERT(obd->obd_type->typ_name != NULL);
 
 	dir = proc_mkdir(obd->obd_type->typ_name, sbi->ll_proc_root);
-	if (dir == NULL)
-		GOTO(out, err = -ENOMEM);
+	if (dir == NULL) {
+		err = -ENOMEM;
+		goto out;
+	}
 
 	snprintf(name, MAX_STRING_SIZE, "common_name");
 	lvars[0].fops = &llite_name_fops;
 	err = lprocfs_add_vars(dir, lvars, obd);
 	if (err)
-		GOTO(out, err);
+		goto out;
 
 	snprintf(name, MAX_STRING_SIZE, "uuid");
 	lvars[0].fops = &llite_uuid_fops;
 	err = lprocfs_add_vars(dir, lvars, obd);
 	if (err)
-		GOTO(out, err);
+		goto out;
 
 	/* OSC */
 	obd = class_name2obd(osc);
@@ -1067,14 +1074,16 @@ int lprocfs_register_mountpoint(struct proc_dir_entry *parent,
 	LASSERT(obd->obd_type->typ_name != NULL);
 
 	dir = proc_mkdir(obd->obd_type->typ_name, sbi->ll_proc_root);
-	if (dir == NULL)
-		GOTO(out, err = -ENOMEM);
+	if (dir == NULL) {
+		err = -ENOMEM;
+		goto out;
+	}
 
 	snprintf(name, MAX_STRING_SIZE, "common_name");
 	lvars[0].fops = &llite_name_fops;
 	err = lprocfs_add_vars(dir, lvars, obd);
 	if (err)
-		GOTO(out, err);
+		goto out;
 
 	snprintf(name, MAX_STRING_SIZE, "uuid");
 	lvars[0].fops = &llite_uuid_fops;
diff --git a/drivers/staging/lustre/lustre/llite/namei.c b/drivers/staging/lustre/lustre/llite/namei.c
index 0dc7173..f9771ba 100644
--- a/drivers/staging/lustre/lustre/llite/namei.c
+++ b/drivers/staging/lustre/lustre/llite/namei.c
@@ -523,8 +523,10 @@ static struct dentry *ll_lookup_it(struct inode *parent, struct dentry *dentry,
 		rc = ll_statahead_enter(parent, &dentry, 0);
 		if (rc == 1) {
 			if (dentry == save)
-				GOTO(out, retval = NULL);
-			GOTO(out, retval = dentry);
+				retval = NULL;
+			else
+				retval = dentry;
+			goto out;
 		}
 	}
 
@@ -546,13 +548,16 @@ static struct dentry *ll_lookup_it(struct inode *parent, struct dentry *dentry,
 	rc = md_intent_lock(ll_i2mdexp(parent), op_data, NULL, 0, it,
 			    lookup_flags, &req, ll_md_blocking_ast, 0);
 	ll_finish_md_op_data(op_data);
-	if (rc < 0)
-		GOTO(out, retval = ERR_PTR(rc));
+	if (rc < 0) {
+		retval = ERR_PTR(rc);
+		goto out;
+	}
 
 	rc = ll_lookup_it_finish(req, it, parent, &dentry);
 	if (rc != 0) {
 		ll_intent_release(it);
-		GOTO(out, retval = ERR_PTR(rc));
+		retval = ERR_PTR(rc);
+		goto out;
 	}
 
 	if ((it->it_op & IT_OPEN) && dentry->d_inode &&
@@ -563,9 +568,10 @@ static struct dentry *ll_lookup_it(struct inode *parent, struct dentry *dentry,
 	ll_lookup_finish_locks(it, dentry);
 
 	if (dentry == save)
-		GOTO(out, retval = NULL);
+		retval = NULL;
 	else
-		GOTO(out, retval = dentry);
+		retval = dentry;
+	goto out;
  out:
 	if (req)
 		ptlrpc_req_finished(req);
@@ -697,8 +703,10 @@ static struct inode *ll_create_node(struct inode *dir, struct lookup_intent *it)
 	request = it->d.lustre.it_data;
 	it_clear_disposition(it, DISP_ENQ_CREATE_REF);
 	rc = ll_prep_inode(&inode, request, dir->i_sb, it);
-	if (rc)
-		GOTO(out, inode = ERR_PTR(rc));
+	if (rc) {
+		inode = ERR_PTR(rc);
+		goto out;
+	}
 
 	LASSERT(ll_d_hlist_empty(&inode->i_dentry));
 
@@ -783,8 +791,10 @@ static int ll_new_node(struct inode *dir, struct qstr *name,
 
 	op_data = ll_prep_md_op_data(NULL, dir, NULL, name->name,
 				     name->len, 0, opc, NULL);
-	if (IS_ERR(op_data))
-		GOTO(err_exit, err = PTR_ERR(op_data));
+	if (IS_ERR(op_data)) {
+		err = PTR_ERR(op_data);
+		goto err_exit;
+	}
 
 	err = md_create(sbi->ll_md_exp, op_data, tgt, tgt_len, mode,
 			from_kuid(&init_user_ns, current_fsuid()),
@@ -792,14 +802,14 @@ static int ll_new_node(struct inode *dir, struct qstr *name,
 			cfs_curproc_cap_pack(), rdev, &request);
 	ll_finish_md_op_data(op_data);
 	if (err)
-		GOTO(err_exit, err);
+		goto err_exit;
 
 	ll_update_times(request, dir);
 
 	if (dchild) {
 		err = ll_prep_inode(&inode, request, dchild->d_sb, NULL);
 		if (err)
-		     GOTO(err_exit, err);
+			goto err_exit;
 
 		d_instantiate(dchild, inode);
 	}
@@ -907,7 +917,7 @@ static int ll_link_generic(struct inode *src,  struct inode *dir,
 	err = md_link(sbi->ll_md_exp, op_data, &request);
 	ll_finish_md_op_data(op_data);
 	if (err)
-		GOTO(out, err);
+		goto out;
 
 	ll_update_times(request, dir);
 	ll_stats_ops_tally(sbi, LPROC_LL_LINK, 1);
@@ -1028,7 +1038,8 @@ int ll_objects_destroy(struct ptlrpc_request *request, struct inode *dir)
 
 	if (body->eadatasize == 0) {
 		CERROR("OBD_MD_FLEASIZE set but eadatasize zero\n");
-		GOTO(out, rc = -EPROTO);
+		rc = -EPROTO;
+		goto out;
 	}
 
 	/* The MDS sent back the EA because we unlinked the last reference
@@ -1042,13 +1053,15 @@ int ll_objects_destroy(struct ptlrpc_request *request, struct inode *dir)
 	rc = obd_unpackmd(ll_i2dtexp(dir), &lsm, eadata, body->eadatasize);
 	if (rc < 0) {
 		CERROR("obd_unpackmd: %d\n", rc);
-		GOTO(out, rc);
+		goto out;
 	}
 	LASSERT(rc >= sizeof(*lsm));
 
 	OBDO_ALLOC(oa);
-	if (oa == NULL)
-		GOTO(out_free_memmd, rc = -ENOMEM);
+	if (oa == NULL) {
+		rc = -ENOMEM;
+		goto out_free_memmd;
+	}
 
 	oa->o_oi = lsm->lsm_oi;
 	oa->o_mode = body->mode & S_IFMT;
@@ -1070,7 +1083,7 @@ int ll_objects_destroy(struct ptlrpc_request *request, struct inode *dir)
 	if (body->valid & OBD_MD_FLOSSCAPA) {
 		rc = md_unpack_capa(ll_i2mdexp(dir), request, &RMF_CAPA2, &oc);
 		if (rc)
-			GOTO(out_free_memmd, rc);
+			goto out_free_memmd;
 	}
 
 	rc = obd_destroy(NULL, ll_i2dtexp(dir), oa, lsm, &oti,
@@ -1116,7 +1129,7 @@ static int ll_unlink_generic(struct inode *dir, struct dentry *dparent,
 	rc = md_unlink(ll_i2sbi(dir)->ll_md_exp, op_data, &request);
 	ll_finish_md_op_data(op_data);
 	if (rc)
-		GOTO(out, rc);
+		goto out;
 
 	ll_update_times(request, dir);
 	ll_stats_ops_tally(ll_i2sbi(dir), LPROC_LL_UNLINK, 1);
diff --git a/drivers/staging/lustre/lustre/llite/remote_perm.c b/drivers/staging/lustre/lustre/llite/remote_perm.c
index 3a9c8e8..c05a912 100644
--- a/drivers/staging/lustre/lustre/llite/remote_perm.c
+++ b/drivers/staging/lustre/lustre/llite/remote_perm.c
@@ -144,8 +144,10 @@ static int do_check_remote_perm(struct ll_inode_info *lli, int mask)
 		break;
 	}
 
-	if (!found)
-		GOTO(out, rc = -ENOENT);
+	if (!found) {
+		rc = -ENOENT;
+		goto out;
+	}
 
 	CDEBUG(D_SEC, "found remote perm: %u/%u/%u/%u - %#x\n",
 	       lrp->lrp_uid, lrp->lrp_gid, lrp->lrp_fsuid, lrp->lrp_fsgid,
diff --git a/drivers/staging/lustre/lustre/llite/rw.c b/drivers/staging/lustre/lustre/llite/rw.c
index ecd7a22..1f53b98 100644
--- a/drivers/staging/lustre/lustre/llite/rw.c
+++ b/drivers/staging/lustre/lustre/llite/rw.c
@@ -317,8 +317,10 @@ static unsigned long ll_ra_count_get(struct ll_sb_info *sbi,
 	 * otherwise it will form small read RPC(< 1M), which hurt server
 	 * performance a lot. */
 	ret = min(ra->ra_max_pages - atomic_read(&ra->ra_cur_pages), pages);
-	if (ret < 0 || ret < min_t(long, PTLRPC_MAX_BRW_PAGES, pages))
-		GOTO(out, ret = 0);
+	if (ret < 0 || ret < min_t(long, PTLRPC_MAX_BRW_PAGES, pages)) {
+		ret = 0;
+		goto out;
+	}
 
 	/* If the non-strided (ria_pages == 0) readahead window
 	 * (ria_start + ret) has grown across an RPC boundary, then trim
@@ -1018,7 +1020,7 @@ void ras_update(struct ll_sb_info *sbi, struct inode *inode,
 			ras->ras_next_readahead = 0;
 			ras->ras_window_len = min(ra->ra_max_pages_per_file,
 				ra->ra_max_read_ahead_whole_pages);
-			GOTO(out_unlock, 0);
+			goto out_unlock;
 		}
 	}
 	if (zero) {
@@ -1033,7 +1035,7 @@ void ras_update(struct ll_sb_info *sbi, struct inode *inode,
 			}
 			ras_reset(inode, ras, index);
 			ras->ras_consecutive_pages++;
-			GOTO(out_unlock, 0);
+			goto out_unlock;
 		} else {
 			ras->ras_consecutive_pages = 0;
 			ras->ras_consecutive_requests = 0;
@@ -1058,7 +1060,7 @@ void ras_update(struct ll_sb_info *sbi, struct inode *inode,
 				ras_reset(inode, ras, index);
 				ras->ras_consecutive_pages++;
 				ras_stride_reset(ras);
-				GOTO(out_unlock, 0);
+				goto out_unlock;
 			}
 		} else if (stride_io_mode(ras)) {
 			/* If this is contiguous read but in stride I/O mode
@@ -1090,7 +1092,7 @@ void ras_update(struct ll_sb_info *sbi, struct inode *inode,
 	 * is not incremented and thus can't be used to trigger RA */
 	if (!ras->ras_window_len && ras->ras_consecutive_pages == 4) {
 		ras->ras_window_len = RAS_INCREASE_STEP(inode);
-		GOTO(out_unlock, 0);
+		goto out_unlock;
 	}
 
 	/* Initially reset the stride window offset to next_readahead*/
@@ -1136,8 +1138,10 @@ int ll_writepage(struct page *vmpage, struct writeback_control *wbc)
 	LASSERT(ll_i2dtexp(inode) != NULL);
 
 	env = cl_env_nested_get(&nest);
-	if (IS_ERR(env))
-		GOTO(out, result = PTR_ERR(env));
+	if (IS_ERR(env)) {
+		result = PTR_ERR(env);
+		goto out;
+	}
 
 	clob  = ll_i2info(inode)->lli_clob;
 	LASSERT(clob != NULL);
@@ -1197,7 +1201,7 @@ int ll_writepage(struct page *vmpage, struct writeback_control *wbc)
 	}
 
 	cl_env_nested_put(&nest, env);
-	GOTO(out, result);
+	goto out;
 
 out:
 	if (result < 0) {
diff --git a/drivers/staging/lustre/lustre/llite/rw26.c b/drivers/staging/lustre/lustre/llite/rw26.c
index 3f157e7..476e108 100644
--- a/drivers/staging/lustre/lustre/llite/rw26.c
+++ b/drivers/staging/lustre/lustre/llite/rw26.c
@@ -441,7 +441,7 @@ static ssize_t ll_direct_IO_26(int rw, struct kiocb *iocb,
 				continue;
 			}
 
-			GOTO(out, result);
+			goto out;
 		}
 		iov_iter_advance(iter, result);
 		tot_bytes += result;
diff --git a/drivers/staging/lustre/lustre/llite/statahead.c b/drivers/staging/lustre/lustre/llite/statahead.c
index c39cf8d..02cd635 100644
--- a/drivers/staging/lustre/lustre/llite/statahead.c
+++ b/drivers/staging/lustre/lustre/llite/statahead.c
@@ -637,8 +637,10 @@ static void ll_post_statahead(struct ll_statahead_info *sai)
 	it = &minfo->mi_it;
 	req = entry->se_req;
 	body = req_capsule_server_get(&req->rq_pill, &RMF_MDT_BODY);
-	if (body == NULL)
-		GOTO(out, rc = -EFAULT);
+	if (body == NULL) {
+		rc = -EFAULT;
+		goto out;
+	}
 
 	child = entry->se_inode;
 	if (child == NULL) {
@@ -649,8 +651,10 @@ static void ll_post_statahead(struct ll_statahead_info *sai)
 
 		/* XXX: No fid in reply, this is probably cross-ref case.
 		 * SA can't handle it yet. */
-		if (body->valid & OBD_MD_MDS)
-			GOTO(out, rc = -EAGAIN);
+		if (body->valid & OBD_MD_MDS) {
+			rc = -EAGAIN;
+			goto out;
+		}
 	} else {
 		/*
 		 * revalidate.
@@ -665,12 +669,14 @@ static void ll_post_statahead(struct ll_statahead_info *sai)
 
 	it->d.lustre.it_lock_handle = entry->se_handle;
 	rc = md_revalidate_lock(ll_i2mdexp(dir), it, ll_inode2fid(dir), NULL);
-	if (rc != 1)
-		GOTO(out, rc = -EAGAIN);
+	if (rc != 1) {
+		rc = -EAGAIN;
+		goto out;
+	}
 
 	rc = ll_prep_inode(&child, req, dir->i_sb, it);
 	if (rc)
-		GOTO(out, rc);
+		goto out;
 
 	CDEBUG(D_DLMTRACE, "setting l_data to inode %p (%lu/%u)\n",
 	       child, child->i_ino, child->i_generation);
@@ -711,20 +717,23 @@ static int ll_statahead_interpret(struct ptlrpc_request *req,
 	if (unlikely(lli->lli_sai == NULL ||
 		     lli->lli_sai->sai_generation != minfo->mi_generation)) {
 		spin_unlock(&lli->lli_sa_lock);
-		GOTO(out, rc = -ESTALE);
+		rc = -ESTALE;
+		goto out;
 	} else {
 		sai = ll_sai_get(lli->lli_sai);
 		if (unlikely(!thread_is_running(&sai->sai_thread))) {
 			sai->sai_replied++;
 			spin_unlock(&lli->lli_sa_lock);
-			GOTO(out, rc = -EBADFD);
+			rc = -EBADFD;
+			goto out;
 		}
 
 		entry = ll_sa_entry_get_byindex(sai, minfo->mi_cbdata);
 		if (entry == NULL) {
 			sai->sai_replied++;
 			spin_unlock(&lli->lli_sa_lock);
-			GOTO(out, rc = -EIDRM);
+			rc = -EIDRM;
+			goto out;
 		}
 
 		if (rc != 0) {
@@ -1084,7 +1093,7 @@ static int ll_statahead_thread(void *arg)
 			CDEBUG(D_READA, "error reading dir "DFID" at %llu/%llu: [rc %d] [parent %u]\n",
 			       PFID(ll_inode2fid(dir)), pos, sai->sai_index,
 			       rc, plli->lli_opendir_pid);
-			GOTO(out, rc);
+			goto out;
 		}
 
 		dp = page_address(page);
@@ -1149,7 +1158,8 @@ interpret_it:
 
 			if (unlikely(!thread_is_running(thread))) {
 				ll_release_page(page, 0);
-				GOTO(out, rc = 0);
+				rc = 0;
+				goto out;
 			}
 
 			/* If no window for metadata statahead, but there are
@@ -1170,7 +1180,8 @@ interpret_it:
 					if (unlikely(
 						!thread_is_running(thread))) {
 						ll_release_page(page, 0);
-						GOTO(out, rc = 0);
+						rc = 0;
+						goto out;
 					}
 
 					if (!sa_sent_full(sai))
@@ -1202,8 +1213,10 @@ do_it:
 				while (!sa_received_empty(sai))
 					ll_post_statahead(sai);
 
-				if (unlikely(!thread_is_running(thread)))
-					GOTO(out, rc = 0);
+				if (unlikely(!thread_is_running(thread))) {
+					rc = 0;
+					goto out;
+				}
 
 				if (sai->sai_sent == sai->sai_replied &&
 				    sa_received_empty(sai))
@@ -1221,7 +1234,8 @@ do_it:
 			}
 			spin_unlock(&plli->lli_agl_lock);
 
-			GOTO(out, rc = 0);
+			rc = 0;
+			goto out;
 		} else if (1) {
 			/*
 			 * chain is exhausted.
@@ -1421,7 +1435,7 @@ static int is_first_dirent(struct inode *dir, struct dentry *dentry)
 				rc = LS_FIRST_DOT_DE;
 
 			ll_release_page(page, 0);
-			GOTO(out, rc);
+			goto out;
 		}
 		pos = le64_to_cpu(dp->ldp_hash_end);
 		if (pos == MDS_DIR_END_OFF) {
@@ -1625,20 +1639,25 @@ int do_statahead_enter(struct inode *dir, struct dentry **dentryp,
 
 	/* I am the "lli_opendir_pid" owner, only me can set "lli_sai". */
 	rc = is_first_dirent(dir, *dentryp);
-	if (rc == LS_NONE_FIRST_DE)
+	if (rc == LS_NONE_FIRST_DE) {
 		/* It is not "ls -{a}l" operation, no need statahead for it. */
-		GOTO(out, rc = -EAGAIN);
+		rc = -EAGAIN;
+		goto out;
+	}
 
 	sai = ll_sai_alloc();
-	if (sai == NULL)
-		GOTO(out, rc = -ENOMEM);
+	if (sai == NULL) {
+		rc = -ENOMEM;
+		goto out;
+	}
 
 	sai->sai_ls_all = (rc == LS_FIRST_DOT_DE);
 	sai->sai_inode = igrab(dir);
 	if (unlikely(sai->sai_inode == NULL)) {
 		CWARN("Do not start stat ahead on dying inode "DFID"\n",
 		      PFID(&lli->lli_fid));
-		GOTO(out, rc = -ESTALE);
+		rc = -ESTALE;
+		goto out;
 	}
 
 	/* get parent reference count here, and put it in ll_statahead_thread */
@@ -1652,7 +1671,8 @@ int do_statahead_enter(struct inode *dir, struct dentry **dentryp,
 		      PFID(&lli->lli_fid), PFID(&nlli->lli_fid));
 		dput(parent);
 		iput(sai->sai_inode);
-		GOTO(out, rc = -EAGAIN);
+		rc = -EAGAIN;
+		goto out;
 	}
 
 	CDEBUG(D_READA, "start statahead thread: sai %p, parent %.*s\n",
diff --git a/drivers/staging/lustre/lustre/llite/symlink.c b/drivers/staging/lustre/lustre/llite/symlink.c
index 20e678b..29fb16d 100644
--- a/drivers/staging/lustre/lustre/llite/symlink.c
+++ b/drivers/staging/lustre/lustre/llite/symlink.c
@@ -77,21 +77,23 @@ static int ll_readlink_internal(struct inode *inode,
 	if (rc) {
 		if (rc != -ENOENT)
 			CERROR("inode %lu: rc = %d\n", inode->i_ino, rc);
-		GOTO (failed, rc);
+		goto failed;
 	}
 
 	body = req_capsule_server_get(&(*request)->rq_pill, &RMF_MDT_BODY);
 	LASSERT(body != NULL);
 	if ((body->valid & OBD_MD_LINKNAME) == 0) {
 		CERROR("OBD_MD_LINKNAME not set on reply\n");
-		GOTO(failed, rc = -EPROTO);
+		rc = -EPROTO;
+		goto failed;
 	}
 
 	LASSERT(symlen != 0);
 	if (body->eadatasize != symlen) {
 		CERROR("inode %lu: symlink length %d not expected %d\n",
 			inode->i_ino, body->eadatasize - 1, symlen - 1);
-		GOTO(failed, rc = -EPROTO);
+		rc = -EPROTO;
+		goto failed;
 	}
 
 	*symname = req_capsule_server_get(&(*request)->rq_pill, &RMF_MDT_MD);
@@ -100,7 +102,8 @@ static int ll_readlink_internal(struct inode *inode,
 		/* not full/NULL terminated */
 		CERROR("inode %lu: symlink not NULL terminated string"
 			"of length %d\n", inode->i_ino, symlen - 1);
-		GOTO(failed, rc = -EPROTO);
+		rc = -EPROTO;
+		goto failed;
 	}
 
 	OBD_ALLOC(lli->lli_symlink_name, symlen);
diff --git a/drivers/staging/lustre/lustre/llite/vvp_io.c b/drivers/staging/lustre/lustre/llite/vvp_io.c
index fd24874..cfcb8c9 100644
--- a/drivers/staging/lustre/lustre/llite/vvp_io.c
+++ b/drivers/staging/lustre/lustre/llite/vvp_io.c
@@ -704,7 +704,8 @@ static int vvp_io_fault_start(const struct lu_env *env,
 
 		/* return +1 to stop cl_io_loop() and ll_fault() will catch
 		 * and retry. */
-		GOTO(out, result = +1);
+		result = +1;
+		goto out;
 	}
 
 
@@ -733,13 +734,16 @@ static int vvp_io_fault_start(const struct lu_env *env,
 			 * in ll_page_mkwrite0. Thus we return -ENODATA
 			 * to handle both cases
 			 */
-			GOTO(out, result = -ENODATA);
+			result = -ENODATA;
+			goto out;
 		}
 	}
 
 	page = cl_page_find(env, obj, fio->ft_index, vmpage, CPT_CACHEABLE);
-	if (IS_ERR(page))
-		GOTO(out, result = PTR_ERR(page));
+	if (IS_ERR(page)) {
+		result = PTR_ERR(page);
+		goto out;
+	}
 
 	/* if page is going to be written, we should add this page into cache
 	 * earlier. */
@@ -771,7 +775,7 @@ static int vvp_io_fault_start(const struct lu_env *env,
 				/* we're in big trouble, what can we do now? */
 				if (result == -EDQUOT)
 					result = -ENOSPC;
-				GOTO(out, result);
+				goto out;
 			} else
 				cl_page_disown(env, io, page);
 		}
diff --git a/drivers/staging/lustre/lustre/llite/xattr.c b/drivers/staging/lustre/lustre/llite/xattr.c
index 37bd349..252a619 100644
--- a/drivers/staging/lustre/lustre/llite/xattr.c
+++ b/drivers/staging/lustre/lustre/llite/xattr.c
@@ -364,7 +364,7 @@ do_getxattr:
 		if (rc == -EAGAIN)
 			goto getxattr_nocache;
 		if (rc < 0)
-			GOTO(out_xattr, rc);
+			goto out_xattr;
 
 		/* Add "system.posix_acl_access" to the list */
 		if (lli->lli_posix_acl != NULL && valid & OBD_MD_FLXATTRLS) {
@@ -375,7 +375,8 @@ do_getxattr:
 				       sizeof(XATTR_NAME_ACL_ACCESS));
 				rc += sizeof(XATTR_NAME_ACL_ACCESS);
 			} else {
-				GOTO(out_xattr, rc = -ERANGE);
+				rc = -ERANGE;
+				goto out_xattr;
 			}
 		}
 	} else {
@@ -387,29 +388,36 @@ getxattr_nocache:
 		capa_put(oc);
 
 		if (rc < 0)
-			GOTO(out_xattr, rc);
+			goto out_xattr;
 
 		body = req_capsule_server_get(&req->rq_pill, &RMF_MDT_BODY);
 		LASSERT(body);
 
 		/* only detect the xattr size */
-		if (size == 0)
-			GOTO(out, rc = body->eadatasize);
+		if (size == 0) {
+			rc = body->eadatasize;
+			goto out;
+		}
 
 		if (size < body->eadatasize) {
 			CERROR("server bug: replied size %u > %u\n",
 				body->eadatasize, (int)size);
-			GOTO(out, rc = -ERANGE);
+			rc = -ERANGE;
+			goto out;
 		}
 
-		if (body->eadatasize == 0)
-			GOTO(out, rc = -ENODATA);
+		if (body->eadatasize == 0) {
+			rc = -ENODATA;
+			goto out;
+		}
 
 		/* do not need swab xattr data */
 		xdata = req_capsule_server_sized_get(&req->rq_pill, &RMF_EADATA,
 							body->eadatasize);
-		if (!xdata)
-			GOTO(out, rc = -EFAULT);
+		if (!xdata) {
+			rc = -EFAULT;
+			goto out;
+		}
 
 		memcpy(buffer, xdata, body->eadatasize);
 		rc = body->eadatasize;
@@ -421,14 +429,16 @@ getxattr_nocache:
 
 		acl = lustre_posix_acl_xattr_2ext(
 					(posix_acl_xattr_header *)buffer, rc);
-		if (IS_ERR(acl))
-			GOTO(out, rc = PTR_ERR(acl));
+		if (IS_ERR(acl)) {
+			rc = PTR_ERR(acl);
+			goto out;
+		}
 
 		rc = ee_add(&sbi->ll_et, current_pid(), ll_inode2fid(inode),
 			    xattr_type, acl);
 		if (unlikely(rc < 0)) {
 			lustre_ext_acl_xattr_free(acl);
-			GOTO(out, rc);
+			goto out;
 		}
 	}
 #endif
@@ -476,7 +486,8 @@ ssize_t ll_getxattr(struct dentry *dentry, const char *name,
 		if (size == 0 && S_ISDIR(inode->i_mode)) {
 			/* XXX directory EA is fix for now, optimize to save
 			 * RPC transfer */
-			GOTO(out, rc = sizeof(struct lov_user_md));
+			rc = sizeof(struct lov_user_md);
+			goto out;
 		}
 
 		lsm = ccc_inode_lsm_get(inode);
@@ -496,7 +507,7 @@ ssize_t ll_getxattr(struct dentry *dentry, const char *name,
 		ccc_inode_lsm_put(inode, lsm);
 
 		if (rc < 0)
-		       GOTO(out, rc);
+			goto out;
 
 		if (size == 0) {
 			/* used to call ll_get_max_mdsize() forward to get
@@ -504,13 +515,14 @@ ssize_t ll_getxattr(struct dentry *dentry, const char *name,
 			 * rsync 3.0.x) care much about the exact xattr value
 			 * size */
 			rc = lmmsize;
-			GOTO(out, rc);
+			goto out;
 		}
 
 		if (size < lmmsize) {
 			CERROR("server bug: replied size %d > %d for %s (%s)\n",
 			       lmmsize, (int)size, dentry->d_name.name, name);
-			GOTO(out, rc = -ERANGE);
+			rc = -ERANGE;
+			goto out;
 		}
 
 		lump = (struct lov_user_md *)buffer;
@@ -549,7 +561,7 @@ ssize_t ll_listxattr(struct dentry *dentry, char *buffer, size_t size)
 
 	rc = ll_getxattr_common(inode, NULL, buffer, size, OBD_MD_FLXATTRLS);
 	if (rc < 0)
-		GOTO(out, rc);
+		goto out;
 
 	if (buffer != NULL) {
 		struct ll_sb_info *sbi = ll_i2sbi(inode);
@@ -582,7 +594,8 @@ ssize_t ll_listxattr(struct dentry *dentry, char *buffer, size_t size)
 	}
 
 	if (rc2 < 0) {
-		GOTO(out, rc2 = 0);
+		rc2 = 0;
+		goto out;
 	} else if (S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode)) {
 		const int prefix_len = sizeof(XATTR_LUSTRE_PREFIX) - 1;
 		const size_t name_len   = sizeof("lov") - 1;
diff --git a/drivers/staging/lustre/lustre/llite/xattr_cache.c b/drivers/staging/lustre/lustre/llite/xattr_cache.c
index edec945..1d2c7b0 100644
--- a/drivers/staging/lustre/lustre/llite/xattr_cache.c
+++ b/drivers/staging/lustre/lustre/llite/xattr_cache.c
@@ -365,18 +365,20 @@ static int ll_xattr_cache_refill(struct inode *inode, struct lookup_intent *oit)
 
 	rc = ll_xattr_find_get_lock(inode, oit, &req);
 	if (rc)
-		GOTO(out_no_unlock, rc);
+		goto out_no_unlock;
 
 	/* Do we have the data at this point? */
 	if (ll_xattr_cache_valid(lli)) {
 		ll_stats_ops_tally(sbi, LPROC_LL_GETXATTR_HITS, 1);
-		GOTO(out_maybe_drop, rc = 0);
+		rc = 0;
+		goto out_maybe_drop;
 	}
 
 	/* Matched but no cache? Cancelled on error by a parallel refill. */
 	if (unlikely(req == NULL)) {
 		CDEBUG(D_CACHE, "cancelled by a parallel getxattr\n");
-		GOTO(out_maybe_drop, rc = -EIO);
+		rc = -EIO;
+		goto out_maybe_drop;
 	}
 
 	if (oit->d.lustre.it_status < 0) {
@@ -386,13 +388,14 @@ static int ll_xattr_cache_refill(struct inode *inode, struct lookup_intent *oit)
 		/* xattr data is so large that we don't want to cache it */
 		if (rc == -ERANGE)
 			rc = -EAGAIN;
-		GOTO(out_destroy, rc);
+		goto out_destroy;
 	}
 
 	body = req_capsule_server_get(&req->rq_pill, &RMF_MDT_BODY);
 	if (body == NULL) {
 		CERROR("no MDT BODY in the refill xattr reply\n");
-		GOTO(out_destroy, rc = -EPROTO);
+		rc = -EPROTO;
+		goto out_destroy;
 	}
 	/* do not need swab xattr data */
 	xdata = req_capsule_server_sized_get(&req->rq_pill, &RMF_EADATA,
@@ -403,7 +406,8 @@ static int ll_xattr_cache_refill(struct inode *inode, struct lookup_intent *oit)
 					      body->max_mdsize * sizeof(__u32));
 	if (xdata == NULL || xval == NULL || xsizes == NULL) {
 		CERROR("wrong setxattr reply\n");
-		GOTO(out_destroy, rc = -EPROTO);
+		rc = -EPROTO;
+		goto out_destroy;
 	}
 
 	xtail = xdata + body->eadatasize;
@@ -435,7 +439,7 @@ static int ll_xattr_cache_refill(struct inode *inode, struct lookup_intent *oit)
 		}
 		if (rc < 0) {
 			ll_xattr_cache_destroy_locked(lli);
-			GOTO(out_destroy, rc);
+			goto out_destroy;
 		}
 		xdata += strlen(xdata) + 1;
 		xval  += *xsizes;
@@ -447,7 +451,7 @@ static int ll_xattr_cache_refill(struct inode *inode, struct lookup_intent *oit)
 
 	ll_set_lock_data(sbi->ll_md_exp, inode, oit, NULL);
 
-	GOTO(out_maybe_drop, rc);
+	goto out_maybe_drop;
 out_maybe_drop:
 
 		ll_intent_drop_lock(oit);
@@ -528,7 +532,7 @@ int ll_xattr_cache_get(struct inode *inode,
 					 size ? buffer : NULL, size);
 	}
 
-	GOTO(out, rc);
+	goto out;
 out:
 	up_read(&lli->lli_xattrs_list_rwsem);
 

