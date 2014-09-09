Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625AbaIINo4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 09:44:56 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:59460 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754052AbaIINoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 09:44:54 -0400
X-IronPort-AV: E=Sophos;i="5.04,491,1406584800"; 
   d="scan'208";a="93767731"
Date: Tue, 9 Sep 2014 15:44:08 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: devel@driverdev.osuosl.org, "Dilger, Andreas" <andreas.dilger@intel.com>,
        Peng Tao <bergwolf@gmail.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Drokin, Oleg" <oleg.drokin@intel.com>
Subject: Re: [PATCH 3/7] staging: lustre: lov: expand the GOTO macro
In-Reply-To: <20140908195033.GA7006@kroah.com>
Message-ID: <alpine.DEB.2.10.1409091539530.2766@hadrien>
References: <1410106715-9573-3-git-send-email-Julia.Lawall@lip6.fr> <20140908195033.GA7006@kroah.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
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
identifier rc;
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

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
v2: eliminate a merge conflict

 drivers/staging/lustre/lustre/lov/lov_obd.c     |  152 +++++++++++++++---------
 drivers/staging/lustre/lustre/lov/lov_object.c  |   13 +-
 drivers/staging/lustre/lustre/lov/lov_pack.c    |   23 ++-
 drivers/staging/lustre/lustre/lov/lov_page.c    |   12 +
 drivers/staging/lustre/lustre/lov/lov_pool.c    |   38 +++---
 drivers/staging/lustre/lustre/lov/lov_request.c |   97 ++++++++++-----
 6 files changed, 217 insertions(+), 118 deletions(-)

diff --git a/drivers/staging/lustre/lustre/lov/lov_obd.c b/drivers/staging/lustre/lustre/lov/lov_obd.c
index f0beb4c..94dfd64 100644
--- a/drivers/staging/lustre/lustre/lov/lov_obd.c
+++ b/drivers/staging/lustre/lustre/lov/lov_obd.c
@@ -388,8 +388,10 @@ static int lov_set_osc_active(struct obd_device *obd, struct obd_uuid *uuid,
 			break;
 	}

-	if (index == lov->desc.ld_tgt_count)
-		GOTO(out, index = -EINVAL);
+	if (index == lov->desc.ld_tgt_count) {
+		index = -EINVAL;
+		goto out;
+	}

 	if (ev == OBD_NOTIFY_DEACTIVATE || ev == OBD_NOTIFY_ACTIVATE) {
 		activate = (ev == OBD_NOTIFY_ACTIVATE) ? 1 : 0;
@@ -409,7 +411,7 @@ static int lov_set_osc_active(struct obd_device *obd, struct obd_uuid *uuid,
 		if (lov->lov_tgts[index]->ltd_active == active) {
 			CDEBUG(D_INFO, "OSC %s already %sactive!\n",
 			       uuid->uuid, active ? "" : "in");
-			GOTO(out, index);
+			goto out;
 		} else {
 			CDEBUG(D_CONFIG, "Marking OSC %s %sactive\n",
 			       obd_uuid2str(uuid), active ? "" : "in");
@@ -617,11 +619,13 @@ static int lov_add_target(struct obd_device *obd, struct obd_uuid *uuidp,

 	rc = lov_connect_obd(obd, index, active, &lov->lov_ocd);
 	if (rc)
-		GOTO(out, rc);
+		goto out;

 	/* connect to administrative disabled ost */
-	if (!tgt->ltd_exp)
-		GOTO(out, rc = 0);
+	if (!tgt->ltd_exp) {
+		rc = 0;
+		goto out;
+	}

 	if (lov->lov_cache != NULL) {
 		rc = obd_set_info_async(NULL, tgt->ltd_exp,
@@ -629,7 +633,7 @@ static int lov_add_target(struct obd_device *obd, struct obd_uuid *uuidp,
 				sizeof(struct cl_client_cache), lov->lov_cache,
 				NULL);
 		if (rc < 0)
-			GOTO(out, rc);
+			goto out;
 	}

 	rc = lov_notify(obd, tgt->ltd_exp->exp_obd,
@@ -666,14 +670,16 @@ int lov_del_target(struct obd_device *obd, __u32 index,

 	if (!lov->lov_tgts[index]) {
 		CERROR("LOV target at index %d is not setup.\n", index);
-		GOTO(out, rc = -EINVAL);
+		rc = -EINVAL;
+		goto out;
 	}

 	if (uuidp && !obd_uuid_equals(uuidp, &lov->lov_tgts[index]->ltd_uuid)) {
 		CERROR("LOV target UUID %s at index %d doesn't match %s.\n",
 		       lov_uuid2str(lov, index), index,
 		       obd_uuid2str(uuidp));
-		GOTO(out, rc = -EINVAL);
+		rc = -EINVAL;
+		goto out;
 	}

 	CDEBUG(D_CONFIG, "uuid: %s idx: %d gen: %d exp: %p active: %d\n",
@@ -815,7 +821,7 @@ int lov_setup(struct obd_device *obd, struct lustre_cfg *lcfg)
 	lov->lov_pool_count = 0;
 	rc = lov_ost_pool_init(&lov->lov_packed, 0);
 	if (rc)
-		GOTO(out, rc);
+		goto out;

 	lprocfs_lov_init_vars(&lvars);
 	lprocfs_obd_setup(obd, lvars.obd_vars);
@@ -922,15 +928,21 @@ int lov_process_config_base(struct obd_device *obd, struct lustre_cfg *lcfg,
 		__u32 index;
 		int gen;
 		/* lov_modify_tgts add  0:lov_mdsA  1:ost1_UUID  2:0  3:1 */
-		if (LUSTRE_CFG_BUFLEN(lcfg, 1) > sizeof(obd_uuid.uuid))
-			GOTO(out, rc = -EINVAL);
+		if (LUSTRE_CFG_BUFLEN(lcfg, 1) > sizeof(obd_uuid.uuid)) {
+			rc = -EINVAL;
+			goto out;
+		}

 		obd_str2uuid(&obd_uuid,  lustre_cfg_buf(lcfg, 1));

-		if (sscanf(lustre_cfg_buf(lcfg, 2), "%d", indexp) != 1)
-			GOTO(out, rc = -EINVAL);
-		if (sscanf(lustre_cfg_buf(lcfg, 3), "%d", genp) != 1)
-			GOTO(out, rc = -EINVAL);
+		if (sscanf(lustre_cfg_buf(lcfg, 2), "%d", indexp) != 1) {
+			rc = -EINVAL;
+			goto out;
+		}
+		if (sscanf(lustre_cfg_buf(lcfg, 3), "%d", genp) != 1) {
+			rc = -EINVAL;
+			goto out;
+		}
 		index = *indexp;
 		gen = *genp;
 		if (cmd == LCFG_LOV_ADD_OBD)
@@ -939,14 +951,16 @@ int lov_process_config_base(struct obd_device *obd, struct lustre_cfg *lcfg,
 			rc = lov_add_target(obd, &obd_uuid, index, gen, 0);
 		else
 			rc = lov_del_target(obd, index, &obd_uuid, gen);
-		GOTO(out, rc);
+		goto out;
 	}
 	case LCFG_PARAM: {
 		struct lprocfs_static_vars lvars = { NULL };
 		struct lov_desc *desc = &(obd->u.lov.desc);

-		if (!desc)
-			GOTO(out, rc = -EINVAL);
+		if (!desc) {
+			rc = -EINVAL;
+			goto out;
+		}

 		lprocfs_lov_init_vars(&lvars);

@@ -954,17 +968,18 @@ int lov_process_config_base(struct obd_device *obd, struct lustre_cfg *lcfg,
 					      lcfg, obd);
 		if (rc > 0)
 			rc = 0;
-		GOTO(out, rc);
+		goto out;
 	}
 	case LCFG_POOL_NEW:
 	case LCFG_POOL_ADD:
 	case LCFG_POOL_DEL:
 	case LCFG_POOL_REM:
-		GOTO(out, rc);
+		goto out;

 	default: {
 		CERROR("Unknown command: %d\n", lcfg->lcfg_command);
-		GOTO(out, rc = -EINVAL);
+		rc = -EINVAL;
+		goto out;

 	}
 	}
@@ -989,22 +1004,30 @@ static int lov_recreate(struct obd_export *exp, struct obdo *src_oa,

 	ost_idx = src_oa->o_nlink;
 	lsm = *ea;
-	if (lsm == NULL)
-		GOTO(out, rc = -EINVAL);
+	if (lsm == NULL) {
+		rc = -EINVAL;
+		goto out;
+	}
 	if (ost_idx >= lov->desc.ld_tgt_count ||
-	    !lov->lov_tgts[ost_idx])
-		GOTO(out, rc = -EINVAL);
+	    !lov->lov_tgts[ost_idx]) {
+		rc = -EINVAL;
+		goto out;
+	}

 	for (i = 0; i < lsm->lsm_stripe_count; i++) {
 		if (lsm->lsm_oinfo[i]->loi_ost_idx == ost_idx) {
 			if (ostid_id(&lsm->lsm_oinfo[i]->loi_oi) !=
-					ostid_id(&src_oa->o_oi))
-				GOTO(out, rc = -EINVAL);
+					ostid_id(&src_oa->o_oi)) {
+				rc = -EINVAL;
+				goto out;
+			}
 			break;
 		}
 	}
-	if (i == lsm->lsm_stripe_count)
-		GOTO(out, rc = -EINVAL);
+	if (i == lsm->lsm_stripe_count) {
+		rc = -EINVAL;
+		goto out;
+	}

 	rc = obd_create(NULL, lov->lov_tgts[ost_idx]->ltd_exp,
 			src_oa, &obj_mdp, oti);
@@ -1080,7 +1103,7 @@ static int lov_destroy(const struct lu_env *env, struct obd_export *exp,
 	obd_getref(exp->exp_obd);
 	rc = lov_prep_destroy_set(exp, &oinfo, oa, lsm, oti, &set);
 	if (rc)
-		GOTO(out, rc);
+		goto out;

 	list_for_each(pos, &set->set_list) {
 		req = list_entry(pos, struct lov_request, rq_link);
@@ -1165,7 +1188,7 @@ static int lov_getattr_async(struct obd_export *exp, struct obd_info *oinfo,
 			       POSTID(&oinfo->oi_oa->o_oi),
 			       POSTID(&req->rq_oi.oi_oa->o_oi),
 			       req->rq_idx, rc);
-			GOTO(out, rc);
+			goto out;
 		}
 	}

@@ -1718,15 +1741,19 @@ static int lov_fiemap(struct lov_obd *lov, __u32 keylen, void *key,
 	int cur_stripe = 0, cur_stripe_wrap = 0, stripe_count;
 	unsigned int buffer_size = FIEMAP_BUFFER_SIZE;

-	if (!lsm_has_objects(lsm))
-		GOTO(out, rc = 0);
+	if (!lsm_has_objects(lsm)) {
+		rc = 0;
+		goto out;
+	}

 	if (fiemap_count_to_size(fm_key->fiemap.fm_extent_count) < buffer_size)
 		buffer_size = fiemap_count_to_size(fm_key->fiemap.fm_extent_count);

 	OBD_ALLOC_LARGE(fm_local, buffer_size);
-	if (fm_local == NULL)
-		GOTO(out, rc = -ENOMEM);
+	if (fm_local == NULL) {
+		rc = -ENOMEM;
+		goto out;
+	}
 	lcl_fm_ext = &fm_local->fm_extents[0];

 	count_local = fiemap_size_to_count(buffer_size);
@@ -1747,8 +1774,10 @@ static int lov_fiemap(struct lov_obd *lov, __u32 keylen, void *key,

 	fm_end_offset = fiemap_calc_fm_end_offset(fiemap, lsm, fm_start,
 						  fm_end, &start_stripe);
-	if (fm_end_offset == -EINVAL)
-		GOTO(out, rc = -EINVAL);
+	if (fm_end_offset == -EINVAL) {
+		rc = -EINVAL;
+		goto out;
+	}

 	if (fiemap_count_to_size(fiemap->fm_extent_count) > *vallen)
 		fiemap->fm_extent_count = fiemap_size_to_count(*vallen);
@@ -1817,8 +1846,11 @@ static int lov_fiemap(struct lov_obd *lov, __u32 keylen, void *key,
 			fm_key->oa.o_oi = lsm->lsm_oinfo[cur_stripe]->loi_oi;
 			ost_index = lsm->lsm_oinfo[cur_stripe]->loi_ost_idx;

-			if (ost_index < 0 || ost_index >=lov->desc.ld_tgt_count)
-				GOTO(out, rc = -EINVAL);
+			if (ost_index < 0 ||
+			    ost_index >= lov->desc.ld_tgt_count) {
+				rc = -EINVAL;
+				goto out;
+			}

 			/* If OST is inactive, return extent with UNKNOWN flag */
 			if (!lov->lov_tgts[ost_index]->ltd_active) {
@@ -1841,7 +1873,7 @@ static int lov_fiemap(struct lov_obd *lov, __u32 keylen, void *key,
 					  lov->lov_tgts[ost_index]->ltd_exp,
 					  keylen, key, vallen, fm_local, lsm);
 			if (rc != 0)
-				GOTO(out, rc);
+				goto out;

 inactive_tgt:
 			ext_count = fm_local->fm_mapped_extents;
@@ -1944,8 +1976,10 @@ static int lov_get_info(const struct lu_env *env, struct obd_export *exp,
 		struct lov_oinfo *loi;
 		__u32 *stripe = val;

-		if (*vallen < sizeof(*stripe))
-			GOTO(out, rc = -EFAULT);
+		if (*vallen < sizeof(*stripe)) {
+			rc = -EFAULT;
+			goto out;
+		}
 		*vallen = sizeof(*stripe);

 		/* XXX This is another one of those bits that will need to
@@ -1962,12 +1996,14 @@ static int lov_get_info(const struct lu_env *env, struct obd_export *exp,
 			    data->lock->l_conn_export &&
 			    ostid_res_name_eq(&loi->loi_oi, res_id)) {
 				*stripe = i;
-				GOTO(out, rc = 0);
+				rc = 0;
+				goto out;
 			}
 		}
 		LDLM_ERROR(data->lock, "lock on inode without such object");
 		dump_lsm(D_ERROR, lsm);
-		GOTO(out, rc = -ENXIO);
+		rc = -ENXIO;
+		goto out;
 	} else if (KEY_IS(KEY_LAST_ID)) {
 		struct obd_id_info *info = val;
 		__u32 size = sizeof(u64);
@@ -1976,20 +2012,24 @@ static int lov_get_info(const struct lu_env *env, struct obd_export *exp,
 		LASSERT(*vallen == sizeof(struct obd_id_info));
 		tgt = lov->lov_tgts[info->idx];

-		if (!tgt || !tgt->ltd_active)
-			GOTO(out, rc = -ESRCH);
+		if (!tgt || !tgt->ltd_active) {
+			rc = -ESRCH;
+			goto out;
+		}

 		rc = obd_get_info(env, tgt->ltd_exp, keylen, key,
 				  &size, info->data, NULL);
-		GOTO(out, rc = 0);
+		rc = 0;
+		goto out;
 	} else if (KEY_IS(KEY_LOVDESC)) {
 		struct lov_desc *desc_ret = val;
 		*desc_ret = lov->desc;

-		GOTO(out, rc = 0);
+		rc = 0;
+		goto out;
 	} else if (KEY_IS(KEY_FIEMAP)) {
 		rc = lov_fiemap(lov, keylen, key, vallen, val, lsm);
-		GOTO(out, rc);
+		goto out;
 	} else if (KEY_IS(KEY_CONNECT_FLAG)) {
 		struct lov_tgt_desc *tgt;
 		__u64 ost_idx = *((__u64 *)val);
@@ -1998,14 +2038,18 @@ static int lov_get_info(const struct lu_env *env, struct obd_export *exp,
 		LASSERT(ost_idx < lov->desc.ld_tgt_count);
 		tgt = lov->lov_tgts[ost_idx];

-		if (!tgt || !tgt->ltd_exp)
-			GOTO(out, rc = -ESRCH);
+		if (!tgt || !tgt->ltd_exp) {
+			rc = -ESRCH;
+			goto out;
+		}

 		*((__u64 *)val) = exp_connect_flags(tgt->ltd_exp);
-		GOTO(out, rc = 0);
+		rc = 0;
+		goto out;
 	} else if (KEY_IS(KEY_TGT_COUNT)) {
 		*((int *)val) = lov->desc.ld_tgt_count;
-		GOTO(out, rc = 0);
+		rc = 0;
+		goto out;
 	}

 	rc = -EINVAL;
diff --git a/drivers/staging/lustre/lustre/lov/lov_object.c b/drivers/staging/lustre/lustre/lov/lov_object.c
index 992c80a..4cab730 100644
--- a/drivers/staging/lustre/lustre/lov/lov_object.c
+++ b/drivers/staging/lustre/lustre/lov/lov_object.c
@@ -233,7 +233,7 @@ static int lov_init_raid0(const struct lu_env *env,
 			result = ostid_to_fid(ofid, &oinfo->loi_oi,
 					      oinfo->loi_ost_idx);
 			if (result != 0)
-				GOTO(out, result);
+				goto out;

 			subdev = lovsub2cl_dev(dev->ld_target[ost_idx]);
 			subconf->u.coc_oinfo = oinfo;
@@ -747,7 +747,8 @@ static int lov_conf_set(const struct lu_env *env, struct cl_object *obj,
 	lov_conf_lock(lov);
 	if (conf->coc_opc == OBJECT_CONF_INVALIDATE) {
 		lov->lo_layout_invalid = true;
-		GOTO(out, result = 0);
+		result = 0;
+		goto out;
 	}

 	if (conf->coc_opc == OBJECT_CONF_WAIT) {
@@ -757,7 +758,7 @@ static int lov_conf_set(const struct lu_env *env, struct cl_object *obj,
 			result = lov_layout_wait(env, lov);
 			lov_conf_lock(lov);
 		}
-		GOTO(out, result);
+		goto out;
 	}

 	LASSERT(conf->coc_opc == OBJECT_CONF_SET);
@@ -770,13 +771,15 @@ static int lov_conf_set(const struct lu_env *env, struct cl_object *obj,
 	     (lov->lo_lsm->lsm_pattern == lsm->lsm_pattern))) {
 		/* same version of layout */
 		lov->lo_layout_invalid = false;
-		GOTO(out, result = 0);
+		result = 0;
+		goto out;
 	}

 	/* will change layout - check if there still exists active IO. */
 	if (atomic_read(&lov->lo_active_ios) > 0) {
 		lov->lo_layout_invalid = true;
-		GOTO(out, result = -EBUSY);
+		result = -EBUSY;
+		goto out;
 	}

 	lov->lo_layout_invalid = lov_layout_change(env, lov, conf);
diff --git a/drivers/staging/lustre/lustre/lov/lov_pack.c b/drivers/staging/lustre/lustre/lov/lov_pack.c
index db5ce8b..5edd6a3 100644
--- a/drivers/staging/lustre/lustre/lov/lov_pack.c
+++ b/drivers/staging/lustre/lustre/lov/lov_pack.c
@@ -435,22 +435,27 @@ int lov_getstripe(struct obd_export *exp, struct lov_stripe_md *lsm,
 	/* we only need the header part from user space to get lmm_magic and
 	 * lmm_stripe_count, (the header part is common to v1 and v3) */
 	lum_size = sizeof(struct lov_user_md_v1);
-	if (copy_from_user(&lum, lump, lum_size))
-		GOTO(out_set, rc = -EFAULT);
+	if (copy_from_user(&lum, lump, lum_size)) {
+		rc = -EFAULT;
+		goto out_set;
+	}
 	else if ((lum.lmm_magic != LOV_USER_MAGIC) &&
-		 (lum.lmm_magic != LOV_USER_MAGIC_V3))
-		GOTO(out_set, rc = -EINVAL);
+		 (lum.lmm_magic != LOV_USER_MAGIC_V3)) {
+		rc = -EINVAL;
+		goto out_set;
+	}

 	if (lum.lmm_stripe_count &&
 	    (lum.lmm_stripe_count < lsm->lsm_stripe_count)) {
 		/* Return right size of stripe to user */
 		lum.lmm_stripe_count = lsm->lsm_stripe_count;
 		rc = copy_to_user(lump, &lum, lum_size);
-		GOTO(out_set, rc = -EOVERFLOW);
+		rc = -EOVERFLOW;
+		goto out_set;
 	}
 	rc = lov_packmd(exp, &lmmk, lsm);
 	if (rc < 0)
-		GOTO(out_set, rc);
+		goto out_set;
 	lmm_size = rc;
 	rc = 0;

@@ -485,8 +490,10 @@ int lov_getstripe(struct obd_export *exp, struct lov_stripe_md *lsm,
 	/* User wasn't expecting this many OST entries */
 	if (lum.lmm_stripe_count == 0)
 		lmm_size = lum_size;
-	else if (lum.lmm_stripe_count < lmmk->lmm_stripe_count)
-		GOTO(out_set, rc = -EOVERFLOW);
+	else if (lum.lmm_stripe_count < lmmk->lmm_stripe_count) {
+		rc = -EOVERFLOW;
+		goto out_set;
+	}
 	/*
 	 * Have a difference between lov_mds_md & lov_user_md.
 	 * So we have to re-order the data before copy to user.
diff --git a/drivers/staging/lustre/lustre/lov/lov_page.c b/drivers/staging/lustre/lustre/lov/lov_page.c
index 24f4e20..c4596e8 100644
--- a/drivers/staging/lustre/lustre/lov/lov_page.c
+++ b/drivers/staging/lustre/lustre/lov/lov_page.c
@@ -180,15 +180,19 @@ int lov_page_init_raid0(const struct lu_env *env, struct cl_object *obj,
 	cl_page_slice_add(page, &lpg->lps_cl, obj, &lov_page_ops);

 	sub = lov_sub_get(env, lio, stripe);
-	if (IS_ERR(sub))
-		GOTO(out, rc = PTR_ERR(sub));
+	if (IS_ERR(sub)) {
+		rc = PTR_ERR(sub);
+		goto out;
+	}

 	subobj = lovsub2cl(r0->lo_sub[stripe]);
 	subpage = cl_page_find_sub(sub->sub_env, subobj,
 				   cl_index(subobj, suboff), vmpage, page);
 	lov_sub_put(sub);
-	if (IS_ERR(subpage))
-		GOTO(out, rc = PTR_ERR(subpage));
+	if (IS_ERR(subpage)) {
+		rc = PTR_ERR(subpage);
+		goto out;
+	}

 	if (likely(subpage->cp_parent == page)) {
 		lu_ref_add(&subpage->cp_reference, "lov", page);
diff --git a/drivers/staging/lustre/lustre/lov/lov_pool.c b/drivers/staging/lustre/lustre/lov/lov_pool.c
index ec48ea4..0e0ea60 100644
--- a/drivers/staging/lustre/lustre/lov/lov_pool.c
+++ b/drivers/staging/lustre/lustre/lov/lov_pool.c
@@ -367,12 +367,14 @@ int lov_ost_pool_add(struct ost_pool *op, __u32 idx, unsigned int min_count)

 	rc = lov_ost_pool_extend(op, min_count);
 	if (rc)
-		GOTO(out, rc);
+		goto out;

 	/* search ost in pool array */
 	for (i = 0; i < op->op_count; i++) {
-		if (op->op_array[i] == idx)
-			GOTO(out, rc = -EEXIST);
+		if (op->op_array[i] == idx) {
+			rc = -EEXIST;
+			goto out;
+		}
 	}
 	/* ost not found we add it */
 	op->op_array[op->op_count] = idx;
@@ -443,12 +445,12 @@ int lov_pool_new(struct obd_device *obd, char *poolname)
 	atomic_set(&new_pool->pool_refcount, 1);
 	rc = lov_ost_pool_init(&new_pool->pool_obds, 0);
 	if (rc)
-	       GOTO(out_err, rc);
+		goto out_err;

 	memset(&(new_pool->pool_rr), 0, sizeof(struct lov_qos_rr));
 	rc = lov_ost_pool_init(&new_pool->pool_rr.lqr_pool, 0);
 	if (rc)
-		GOTO(out_free_pool_obds, rc);
+		goto out_free_pool_obds;

 	INIT_HLIST_NODE(&new_pool->pool_hash);

@@ -475,8 +477,10 @@ int lov_pool_new(struct obd_device *obd, char *poolname)
 	/* add to find only when it fully ready  */
 	rc = cfs_hash_add_unique(lov->lov_pools_hash_body, poolname,
 				 &new_pool->pool_hash);
-	if (rc)
-		GOTO(out_err, rc = -EEXIST);
+	if (rc) {
+		rc = -EEXIST;
+		goto out_err;
+	}

 	CDEBUG(D_CONFIG, LOV_POOLNAMEF" is pool #%d\n",
 	       poolname, lov->lov_pool_count);
@@ -555,12 +559,14 @@ int lov_pool_add(struct obd_device *obd, char *poolname, char *ostname)
 			break;
 	}
 	/* test if ost found in lov */
-	if (lov_idx == lov->desc.ld_tgt_count)
-		GOTO(out, rc = -EINVAL);
+	if (lov_idx == lov->desc.ld_tgt_count) {
+		rc = -EINVAL;
+		goto out;
+	}

 	rc = lov_ost_pool_add(&pool->pool_obds, lov_idx, lov->lov_tgt_size);
 	if (rc)
-		GOTO(out, rc);
+		goto out;

 	pool->pool_rr.lqr_dirty = 1;

@@ -601,8 +607,10 @@ int lov_pool_remove(struct obd_device *obd, char *poolname, char *ostname)
 	}

 	/* test if ost found in lov */
-	if (lov_idx == lov->desc.ld_tgt_count)
-		GOTO(out, rc = -EINVAL);
+	if (lov_idx == lov->desc.ld_tgt_count) {
+		rc = -EINVAL;
+		goto out;
+	}

 	lov_ost_pool_remove(&pool->pool_obds, lov_idx);

@@ -630,8 +638,10 @@ int lov_check_index_in_pool(__u32 idx, struct pool_desc *pool)
 	down_read(&pool_tgt_rw_sem(pool));

 	for (i = 0; i < pool_tgt_count(pool); i++) {
-		if (pool_tgt_array(pool)[i] == idx)
-			GOTO(out, rc = 0);
+		if (pool_tgt_array(pool)[i] == idx) {
+			rc = 0;
+			goto out;
+		}
 	}
 	rc = -ENOENT;
 out:
diff --git a/drivers/staging/lustre/lustre/lov/lov_request.c b/drivers/staging/lustre/lustre/lov/lov_request.c
index f576750..7358b9d 100644
--- a/drivers/staging/lustre/lustre/lov/lov_request.c
+++ b/drivers/staging/lustre/lustre/lov/lov_request.c
@@ -167,14 +167,20 @@ int lov_check_and_wait_active(struct lov_obd *lov, int ost_idx)

 	tgt = lov->lov_tgts[ost_idx];

-	if (unlikely(tgt == NULL))
-		GOTO(out, rc = 0);
+	if (unlikely(tgt == NULL)) {
+		rc = 0;
+		goto out;
+	}

-	if (likely(tgt->ltd_active))
-		GOTO(out, rc = 1);
+	if (likely(tgt->ltd_active)) {
+		rc = 1;
+		goto out;
+	}

-	if (tgt->ltd_exp && class_exp2cliimp(tgt->ltd_exp)->imp_connect_tried)
-		GOTO(out, rc = 0);
+	if (tgt->ltd_exp && class_exp2cliimp(tgt->ltd_exp)->imp_connect_tried) {
+		rc = 0;
+		goto out;
+	}

 	mutex_unlock(&lov->lov_lock);

@@ -209,8 +215,10 @@ static int common_attr_done(struct lov_request_set *set)
 		return -EIO;

 	OBDO_ALLOC(tmp_oa);
-	if (tmp_oa == NULL)
-		GOTO(out, rc = -ENOMEM);
+	if (tmp_oa == NULL) {
+		rc = -ENOMEM;
+		goto out;
+	}

 	list_for_each(pos, &set->set_list) {
 		req = list_entry(pos, struct lov_request, rq_link);
@@ -232,7 +240,8 @@ static int common_attr_done(struct lov_request_set *set)
 		/* When we take attributes of some epoch, we require all the
 		 * ost to be active. */
 		CERROR("Not all the stripes had valid attrs\n");
-		GOTO(out, rc = -EIO);
+		rc = -EIO;
+		goto out;
 	}

 	tmp_oa->o_oi = set->set_oi->oi_oa->o_oi;
@@ -292,15 +301,19 @@ int lov_prep_getattr_set(struct obd_export *exp, struct obd_info *oinfo,
 		loi = oinfo->oi_md->lsm_oinfo[i];
 		if (!lov_check_and_wait_active(lov, loi->loi_ost_idx)) {
 			CDEBUG(D_HA, "lov idx %d inactive\n", loi->loi_ost_idx);
-			if (oinfo->oi_oa->o_valid & OBD_MD_FLEPOCH)
+			if (oinfo->oi_oa->o_valid & OBD_MD_FLEPOCH) {
 				/* SOM requires all the OSTs to be active. */
-				GOTO(out_set, rc = -EIO);
+				rc = -EIO;
+				goto out_set;
+			}
 			continue;
 		}

 		OBD_ALLOC(req, sizeof(*req));
-		if (req == NULL)
-			GOTO(out_set, rc = -ENOMEM);
+		if (req == NULL) {
+			rc = -ENOMEM;
+			goto out_set;
+		}

 		req->rq_stripe = i;
 		req->rq_idx = loi->loi_ost_idx;
@@ -308,7 +321,8 @@ int lov_prep_getattr_set(struct obd_export *exp, struct obd_info *oinfo,
 		OBDO_ALLOC(req->rq_oi.oi_oa);
 		if (req->rq_oi.oi_oa == NULL) {
 			OBD_FREE(req, sizeof(*req));
-			GOTO(out_set, rc = -ENOMEM);
+			rc = -ENOMEM;
+			goto out_set;
 		}
 		memcpy(req->rq_oi.oi_oa, oinfo->oi_oa,
 		       sizeof(*req->rq_oi.oi_oa));
@@ -318,8 +332,10 @@ int lov_prep_getattr_set(struct obd_export *exp, struct obd_info *oinfo,

 		lov_set_add_req(req, set);
 	}
-	if (!set->set_count)
-		GOTO(out_set, rc = -EIO);
+	if (!set->set_count) {
+		rc = -EIO;
+		goto out_set;
+	}
 	*reqset = set;
 	return rc;
 out_set:
@@ -374,8 +390,10 @@ int lov_prep_destroy_set(struct obd_export *exp, struct obd_info *oinfo,
 		}

 		OBD_ALLOC(req, sizeof(*req));
-		if (req == NULL)
-			GOTO(out_set, rc = -ENOMEM);
+		if (req == NULL) {
+			rc = -ENOMEM;
+			goto out_set;
+		}

 		req->rq_stripe = i;
 		req->rq_idx = loi->loi_ost_idx;
@@ -383,14 +401,17 @@ int lov_prep_destroy_set(struct obd_export *exp, struct obd_info *oinfo,
 		OBDO_ALLOC(req->rq_oi.oi_oa);
 		if (req->rq_oi.oi_oa == NULL) {
 			OBD_FREE(req, sizeof(*req));
-			GOTO(out_set, rc = -ENOMEM);
+			rc = -ENOMEM;
+			goto out_set;
 		}
 		memcpy(req->rq_oi.oi_oa, src_oa, sizeof(*req->rq_oi.oi_oa));
 		req->rq_oi.oi_oa->o_oi = loi->loi_oi;
 		lov_set_add_req(req, set);
 	}
-	if (!set->set_count)
-		GOTO(out_set, rc = -EIO);
+	if (!set->set_count) {
+		rc = -EIO;
+		goto out_set;
+	}
 	*reqset = set;
 	return rc;
 out_set:
@@ -482,15 +503,18 @@ int lov_prep_setattr_set(struct obd_export *exp, struct obd_info *oinfo,
 		}

 		OBD_ALLOC(req, sizeof(*req));
-		if (req == NULL)
-			GOTO(out_set, rc = -ENOMEM);
+		if (req == NULL) {
+			rc = -ENOMEM;
+			goto out_set;
+		}
 		req->rq_stripe = i;
 		req->rq_idx = loi->loi_ost_idx;

 		OBDO_ALLOC(req->rq_oi.oi_oa);
 		if (req->rq_oi.oi_oa == NULL) {
 			OBD_FREE(req, sizeof(*req));
-			GOTO(out_set, rc = -ENOMEM);
+			rc = -ENOMEM;
+			goto out_set;
 		}
 		memcpy(req->rq_oi.oi_oa, oinfo->oi_oa,
 		       sizeof(*req->rq_oi.oi_oa));
@@ -513,8 +537,10 @@ int lov_prep_setattr_set(struct obd_export *exp, struct obd_info *oinfo,
 		}
 		lov_set_add_req(req, set);
 	}
-	if (!set->set_count)
-		GOTO(out_set, rc = -EIO);
+	if (!set->set_count) {
+		rc = -EIO;
+		goto out_set;
+	}
 	*reqset = set;
 	return rc;
 out_set:
@@ -646,12 +672,12 @@ static int cb_statfs_update(void *cookie, int rc)
 	   lovset->set_exp is not initialized. */
 	lov_update_set(set, lovreq, rc);
 	if (rc)
-		GOTO(out, rc);
+		goto out;

 	obd_getref(lovobd);
 	tgt = lov->lov_tgts[lovreq->rq_idx];
 	if (!tgt || !tgt->ltd_active)
-		GOTO(out_update, rc);
+		goto out_update;

 	tgtobd = class_exp2obd(tgt->ltd_exp);
 	spin_lock(&tgtobd->obd_osfs_lock);
@@ -708,13 +734,16 @@ int lov_prep_statfs_set(struct obd_device *obd, struct obd_info *oinfo,
 		}

 		OBD_ALLOC(req, sizeof(*req));
-		if (req == NULL)
-			GOTO(out_set, rc = -ENOMEM);
+		if (req == NULL) {
+			rc = -ENOMEM;
+			goto out_set;
+		}

 		OBD_ALLOC(req->rq_oi.oi_osfs, sizeof(*req->rq_oi.oi_osfs));
 		if (req->rq_oi.oi_osfs == NULL) {
 			OBD_FREE(req, sizeof(*req));
-			GOTO(out_set, rc = -ENOMEM);
+			rc = -ENOMEM;
+			goto out_set;
 		}

 		req->rq_idx = i;
@@ -723,8 +752,10 @@ int lov_prep_statfs_set(struct obd_device *obd, struct obd_info *oinfo,

 		lov_set_add_req(req, set);
 	}
-	if (!set->set_count)
-		GOTO(out_set, rc = -EIO);
+	if (!set->set_count) {
+		rc = -EIO;
+		goto out_set;
+	}
 	*reqset = set;
 	return rc;
 out_set:
