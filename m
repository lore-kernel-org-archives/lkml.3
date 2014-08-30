Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199AbaH3VNl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 17:13:41 -0400
Received: from linuxhacker.ru ([217.76.32.60]:51532 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752066AbaH3VNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 17:13:24 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Andreas Dilger <andreas.dilger@intel.com>
Cc: "John L. Hammond" <john.hammond@intel.com>, Peng Tao <tao.peng@emc.com>,
        Liu Xuezhao <xuezhao.liu@emc.com>, Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 02/12] staging/lustre/obdecho: remove metadata echo client
Date: Sat, 30 Aug 2014 17:12:41 -0400
Message-Id: <1409433171-23572-3-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409433171-23572-1-git-send-email-green@linuxhacker.ru>
References: <1409433171-23572-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peng Tao <tao.peng@emc.com>

The metadata echo client requires server support and should not have
been included.

Signed-off-by: Liu Xuezhao <xuezhao.liu@emc.com>
Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: John L. Hammond <john.hammond@intel.com>
Reviewed-on: http://review.whamcloud.com/2674
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-1330
Reviewed-by: Nathaniel Clark <nathaniel.l.clark@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 .../staging/lustre/lustre/obdecho/echo_client.c    | 1053 +-------------------
 1 file changed, 46 insertions(+), 1007 deletions(-)

diff --git a/drivers/staging/lustre/lustre/obdecho/echo_client.c b/drivers/staging/lustre/lustre/obdecho/echo_client.c
index ad5acf6..68a5ed1 100644
--- a/drivers/staging/lustre/lustre/obdecho/echo_client.c
+++ b/drivers/staging/lustre/lustre/obdecho/echo_client.c
@@ -43,7 +43,6 @@
 #include "../include/lustre_debug.h"
 #include "../include/lprocfs_status.h"
 #include "../include/cl_object.h"
-#include "../include/md_object.h"
 #include "../include/lustre_fid.h"
 #include "../include/lustre_acl.h"
 #include "../include/lustre_net.h"
@@ -62,8 +61,6 @@ struct echo_device {
 	struct cl_site	 *ed_site;
 	struct lu_device       *ed_next;
 	int		     ed_next_islov;
-	int		     ed_next_ismd;
-	struct lu_client_seq   *ed_cl_seq;
 };
 
 struct echo_object {
@@ -192,17 +189,6 @@ struct echo_thread_info {
 	struct cl_lock_descr    eti_descr;
 	struct lu_fid	   eti_fid;
 	struct lu_fid		eti_fid2;
-	struct md_op_spec       eti_spec;
-	struct lov_mds_md_v3    eti_lmm;
-	struct lov_user_md_v3   eti_lum;
-	struct md_attr	  eti_ma;
-	struct lu_name	  eti_lname;
-	/* per-thread values, can be re-used */
-	void			*eti_big_lmm;
-	int			eti_big_lmmsize;
-	char		    eti_name[20];
-	struct lu_buf	   eti_buf;
-	char		    eti_xattr_buf[LUSTRE_POSIX_ACL_MAX_SIZE];
 };
 
 /* No session used right now */
@@ -463,6 +449,8 @@ static int echo_object_init(const struct lu_env *env, struct lu_object *obj,
 	struct echo_device *ed	 = cl2echo_dev(lu2cl_dev(obj->lo_dev));
 	struct echo_client_obd *ec     = ed->ed_ec;
 	struct echo_object *eco	= cl2echo_obj(lu2cl(obj));
+	const struct cl_object_conf *cconf;
+	struct echo_object_conf *econf;
 
 	if (ed->ed_next) {
 		struct lu_object  *below;
@@ -476,17 +464,13 @@ static int echo_object_init(const struct lu_env *env, struct lu_object *obj,
 		lu_object_add(obj, below);
 	}
 
-	if (!ed->ed_next_ismd) {
-		const struct cl_object_conf *cconf = lu2cl_conf(conf);
-		struct echo_object_conf *econf = cl2echo_conf(cconf);
+	cconf = lu2cl_conf(conf);
+	econf = cl2echo_conf(cconf);
 
-		LASSERT(econf->eoc_md);
-		eco->eo_lsm = *econf->eoc_md;
-		/* clear the lsm pointer so that it won't get freed. */
-		*econf->eoc_md = NULL;
-	} else {
-		eco->eo_lsm = NULL;
-	}
+	LASSERT(econf->eoc_md);
+	eco->eo_lsm = *econf->eoc_md;
+	/* clear the lsm pointer so that it won't get freed. */
+	*econf->eoc_md = NULL;
 
 	eco->eo_dev = ed;
 	atomic_set(&eco->eo_npages, 0);
@@ -651,8 +635,7 @@ static int echo_site_init(const struct lu_env *env, struct echo_device *ed)
 static void echo_site_fini(const struct lu_env *env, struct echo_device *ed)
 {
 	if (ed->ed_site) {
-		if (!ed->ed_next_ismd)
-			cl_site_fini(ed->ed_site);
+		cl_site_fini(ed->ed_site);
 		ed->ed_site = NULL;
 	}
 }
@@ -719,53 +702,6 @@ static struct lu_context_key echo_session_key = {
 
 LU_TYPE_INIT_FINI(echo, &echo_thread_key, &echo_session_key);
 
-#define ECHO_SEQ_WIDTH 0xffffffff
-static int echo_fid_init(struct echo_device *ed, char *obd_name,
-			 struct seq_server_site *ss)
-{
-	char *prefix;
-	int rc;
-
-	OBD_ALLOC_PTR(ed->ed_cl_seq);
-	if (ed->ed_cl_seq == NULL)
-		return -ENOMEM;
-
-	OBD_ALLOC(prefix, MAX_OBD_NAME + 5);
-	if (prefix == NULL)
-		GOTO(out_free_seq, rc = -ENOMEM);
-
-	snprintf(prefix, MAX_OBD_NAME + 5, "srv-%s", obd_name);
-
-	/* Init client side sequence-manager */
-	rc = seq_client_init(ed->ed_cl_seq, NULL,
-			     LUSTRE_SEQ_METADATA,
-			     prefix, ss->ss_server_seq);
-	ed->ed_cl_seq->lcs_width = ECHO_SEQ_WIDTH;
-	OBD_FREE(prefix, MAX_OBD_NAME + 5);
-	if (rc)
-		GOTO(out_free_seq, rc);
-
-	return 0;
-
-out_free_seq:
-	OBD_FREE_PTR(ed->ed_cl_seq);
-	ed->ed_cl_seq = NULL;
-	return rc;
-}
-
-static int echo_fid_fini(struct obd_device *obddev)
-{
-	struct echo_device *ed = obd2echo_dev(obddev);
-
-	if (ed->ed_cl_seq != NULL) {
-		seq_client_fini(ed->ed_cl_seq);
-		OBD_FREE_PTR(ed->ed_cl_seq);
-		ed->ed_cl_seq = NULL;
-	}
-
-	return 0;
-}
-
 static struct lu_device *echo_device_alloc(const struct lu_env *env,
 					   struct lu_device_type *t,
 					   struct lustre_cfg *cfg)
@@ -806,13 +742,14 @@ static struct lu_device *echo_device_alloc(const struct lu_env *env,
 
 	next = tgt->obd_lu_dev;
 	if (!strcmp(tgt->obd_type->typ_name, LUSTRE_MDT_NAME)) {
-		ed->ed_next_ismd = 1;
-	} else {
-		ed->ed_next_ismd = 0;
-		rc = echo_site_init(env, ed);
-		if (rc)
-			GOTO(out, rc);
+		CERROR("echo MDT client must be run on server\n");
+		GOTO(out, rc = -EOPNOTSUPP);
 	}
+
+	rc = echo_site_init(env, ed);
+	if (rc)
+		GOTO(out, rc);
+
 	cleanup = 3;
 
 	rc = echo_client_setup(env, obd, cfg);
@@ -822,82 +759,34 @@ static struct lu_device *echo_device_alloc(const struct lu_env *env,
 	ed->ed_ec = &obd->u.echo_client;
 	cleanup = 4;
 
-	if (ed->ed_next_ismd) {
-		/* Suppose to connect to some Metadata layer */
-		struct lu_site *ls;
-		struct lu_device *ld;
-		int    found = 0;
-
-		if (next == NULL) {
-			CERROR("%s is not lu device type!\n",
-			       lustre_cfg_string(cfg, 1));
-			GOTO(out, rc = -EINVAL);
-		}
-
-		tgt_type_name = lustre_cfg_string(cfg, 2);
-		if (!tgt_type_name) {
-			CERROR("%s no type name for echo %s setup\n",
-				lustre_cfg_string(cfg, 1),
-				tgt->obd_type->typ_name);
-			GOTO(out, rc = -EINVAL);
-		}
-
-		ls = next->ld_site;
-
-		spin_lock(&ls->ls_ld_lock);
-		list_for_each_entry(ld, &ls->ls_ld_linkage, ld_linkage) {
-			if (strcmp(ld->ld_type->ldt_name, tgt_type_name) == 0) {
-				found = 1;
-				break;
-			}
-		}
-		spin_unlock(&ls->ls_ld_lock);
-
-		if (found == 0) {
-			CERROR("%s is not lu device type!\n",
-			       lustre_cfg_string(cfg, 1));
-			GOTO(out, rc = -EINVAL);
-		}
-
-		next = ld;
-		/* For MD echo client, it will use the site in MDS stack */
-		ed->ed_site_myself.cs_lu = *ls;
-		ed->ed_site = &ed->ed_site_myself;
-		ed->ed_cl.cd_lu_dev.ld_site = &ed->ed_site_myself.cs_lu;
-		rc = echo_fid_init(ed, obd->obd_name, lu_site2seq(ls));
-		if (rc) {
-			CERROR("echo fid init error %d\n", rc);
+	/* if echo client is to be stacked upon ost device, the next is
+	 * NULL since ost is not a clio device so far */
+	if (next != NULL && !lu_device_is_cl(next))
+		next = NULL;
+
+	tgt_type_name = tgt->obd_type->typ_name;
+	if (next != NULL) {
+		LASSERT(next != NULL);
+		if (next->ld_site != NULL)
+			GOTO(out, rc = -EBUSY);
+
+		next->ld_site = &ed->ed_site->cs_lu;
+		rc = next->ld_type->ldt_ops->ldto_device_init(env, next,
+						next->ld_type->ldt_name,
+							      NULL);
+		if (rc)
 			GOTO(out, rc);
-		}
+
+		/* Tricky case, I have to determine the obd type since
+		 * CLIO uses the different parameters to initialize
+		 * objects for lov & osc. */
+		if (strcmp(tgt_type_name, LUSTRE_LOV_NAME) == 0)
+			ed->ed_next_islov = 1;
+		else
+			LASSERT(strcmp(tgt_type_name,
+				       LUSTRE_OSC_NAME) == 0);
 	} else {
-		 /* if echo client is to be stacked upon ost device, the next is
-		  * NULL since ost is not a clio device so far */
-		if (next != NULL && !lu_device_is_cl(next))
-			next = NULL;
-
-		tgt_type_name = tgt->obd_type->typ_name;
-		if (next != NULL) {
-			LASSERT(next != NULL);
-			if (next->ld_site != NULL)
-				GOTO(out, rc = -EBUSY);
-
-			next->ld_site = &ed->ed_site->cs_lu;
-			rc = next->ld_type->ldt_ops->ldto_device_init(env, next,
-						     next->ld_type->ldt_name,
-						     NULL);
-			if (rc)
-				GOTO(out, rc);
-
-			/* Tricky case, I have to determine the obd type since
-			 * CLIO uses the different parameters to initialize
-			 * objects for lov & osc. */
-			if (strcmp(tgt_type_name, LUSTRE_LOV_NAME) == 0)
-				ed->ed_next_islov = 1;
-			else
-				LASSERT(strcmp(tgt_type_name,
-					       LUSTRE_OSC_NAME) == 0);
-		} else
-			LASSERT(strcmp(tgt_type_name, LUSTRE_OST_NAME) == 0);
+		LASSERT(strcmp(tgt_type_name, LUSTRE_OST_NAME) == 0);
 	}
 
 	ed->ed_next = next;
@@ -938,7 +827,7 @@ static struct lu_device *echo_device_fini(const struct lu_env *env,
 	struct echo_device *ed = cl2echo_dev(lu2cl_dev(d));
 	struct lu_device *next = ed->ed_next;
 
-	while (next && !ed->ed_next_ismd)
+	while (next)
 		next = next->ld_type->ldt_ops->ldto_device_fini(env, next);
 	return NULL;
 }
@@ -1008,8 +897,8 @@ static struct lu_device *echo_device_free(const struct lu_env *env,
 	CDEBUG(D_INFO, "No object exists, exiting...\n");
 
 	echo_client_cleanup(d->ld_obd);
-	echo_fid_fini(d->ld_obd);
-	while (next && !ed->ed_next_ismd)
+
+	while (next)
 		next = next->ld_type->ldt_ops->ldto_device_free(env, next);
 
 	LASSERT(ed->ed_site == lu2cl_site(d->ld_site));
@@ -1037,7 +926,7 @@ static struct lu_device_type echo_device_type = {
 	.ldt_tags     = LU_DEVICE_CL,
 	.ldt_name     = LUSTRE_ECHO_CLIENT_NAME,
 	.ldt_ops      = &echo_device_type_ops,
-	.ldt_ctx_tags = LCT_CL_THREAD | LCT_MD_THREAD | LCT_DT_THREAD,
+	.ldt_ctx_tags = LCT_CL_THREAD,
 };
 /** @} echo_init */
 
@@ -1427,773 +1316,6 @@ echo_copyin_lsm (struct echo_device *ed, struct lov_stripe_md *lsm,
 	return 0;
 }
 
-static inline void echo_md_build_name(struct lu_name *lname, char *name,
-				      __u64 id)
-{
-	sprintf(name, "%llu", id);
-	lname->ln_name = name;
-	lname->ln_namelen = strlen(name);
-}
-
-/* similar to mdt_attr_get_complex */
-static int echo_big_lmm_get(const struct lu_env *env, struct md_object *o,
-			    struct md_attr *ma)
-{
-	struct echo_thread_info	*info = echo_env_info(env);
-	int			 rc;
-
-	LASSERT(ma->ma_lmm_size > 0);
-
-	rc = mo_xattr_get(env, o, &LU_BUF_NULL, XATTR_NAME_LOV);
-	if (rc < 0)
-		return rc;
-
-	/* big_lmm may need to be grown */
-	if (info->eti_big_lmmsize < rc) {
-		int size = size_roundup_power2(rc);
-
-		if (info->eti_big_lmmsize > 0) {
-			/* free old buffer */
-			LASSERT(info->eti_big_lmm);
-			OBD_FREE_LARGE(info->eti_big_lmm,
-				       info->eti_big_lmmsize);
-			info->eti_big_lmm = NULL;
-			info->eti_big_lmmsize = 0;
-		}
-
-		OBD_ALLOC_LARGE(info->eti_big_lmm, size);
-		if (info->eti_big_lmm == NULL)
-			return -ENOMEM;
-		info->eti_big_lmmsize = size;
-	}
-	LASSERT(info->eti_big_lmmsize >= rc);
-
-	info->eti_buf.lb_buf = info->eti_big_lmm;
-	info->eti_buf.lb_len = info->eti_big_lmmsize;
-	rc = mo_xattr_get(env, o, &info->eti_buf, XATTR_NAME_LOV);
-	if (rc < 0)
-		return rc;
-
-	ma->ma_valid |= MA_LOV;
-	ma->ma_lmm = info->eti_big_lmm;
-	ma->ma_lmm_size = rc;
-
-	return 0;
-}
-
-int echo_attr_get_complex(const struct lu_env *env, struct md_object *next,
-			  struct md_attr *ma)
-{
-	struct echo_thread_info	*info = echo_env_info(env);
-	struct lu_buf		*buf = &info->eti_buf;
-	umode_t		 mode = lu_object_attr(&next->mo_lu);
-	int			 need = ma->ma_need;
-	int			 rc = 0, rc2;
-
-	ma->ma_valid = 0;
-
-	if (need & MA_INODE) {
-		ma->ma_need = MA_INODE;
-		rc = mo_attr_get(env, next, ma);
-		if (rc)
-			GOTO(out, rc);
-		ma->ma_valid |= MA_INODE;
-	}
-
-	if (need & MA_LOV) {
-		if (S_ISREG(mode) || S_ISDIR(mode)) {
-			LASSERT(ma->ma_lmm_size > 0);
-			buf->lb_buf = ma->ma_lmm;
-			buf->lb_len = ma->ma_lmm_size;
-			rc2 = mo_xattr_get(env, next, buf, XATTR_NAME_LOV);
-			if (rc2 > 0) {
-				ma->ma_lmm_size = rc2;
-				ma->ma_valid |= MA_LOV;
-			} else if (rc2 == -ENODATA) {
-				/* no LOV EA */
-				ma->ma_lmm_size = 0;
-			} else if (rc2 == -ERANGE) {
-				rc2 = echo_big_lmm_get(env, next, ma);
-				if (rc2 < 0)
-					GOTO(out, rc = rc2);
-			} else {
-				GOTO(out, rc = rc2);
-			}
-		}
-	}
-
-#ifdef CONFIG_FS_POSIX_ACL
-	if (need & MA_ACL_DEF && S_ISDIR(mode)) {
-		buf->lb_buf = ma->ma_acl;
-		buf->lb_len = ma->ma_acl_size;
-		rc2 = mo_xattr_get(env, next, buf, XATTR_NAME_ACL_DEFAULT);
-		if (rc2 > 0) {
-			ma->ma_acl_size = rc2;
-			ma->ma_valid |= MA_ACL_DEF;
-		} else if (rc2 == -ENODATA) {
-			/* no ACLs */
-			ma->ma_acl_size = 0;
-		} else {
-			GOTO(out, rc = rc2);
-		}
-	}
-#endif
-out:
-	ma->ma_need = need;
-	CDEBUG(D_INODE, "after getattr rc = %d, ma_valid = %#llx ma_lmm=%p\n",
-	       rc, ma->ma_valid, ma->ma_lmm);
-	return rc;
-}
-
-static int
-echo_md_create_internal(const struct lu_env *env, struct echo_device *ed,
-			struct md_object *parent, struct lu_fid *fid,
-			struct lu_name *lname, struct md_op_spec *spec,
-			struct md_attr *ma)
-{
-	struct lu_object	*ec_child, *child;
-	struct lu_device	*ld = ed->ed_next;
-	struct echo_thread_info *info = echo_env_info(env);
-	struct lu_fid		*fid2 = &info->eti_fid2;
-	struct lu_object_conf    conf = { .loc_flags = LOC_F_NEW };
-	int			 rc;
-
-	rc = mdo_lookup(env, parent, lname, fid2, spec);
-	if (rc == 0)
-		return -EEXIST;
-	else if (rc != -ENOENT)
-		return rc;
-
-	ec_child = lu_object_find_at(env, &ed->ed_cl.cd_lu_dev,
-				     fid, &conf);
-	if (IS_ERR(ec_child)) {
-		CERROR("Can not find the child "DFID": rc = %ld\n", PFID(fid),
-			PTR_ERR(ec_child));
-		return PTR_ERR(ec_child);
-	}
-
-	child = lu_object_locate(ec_child->lo_header, ld->ld_type);
-	if (child == NULL) {
-		CERROR("Can not locate the child "DFID"\n", PFID(fid));
-		GOTO(out_put, rc = -EINVAL);
-	}
-
-	CDEBUG(D_RPCTRACE, "Start creating object "DFID" %s %p\n",
-	       PFID(lu_object_fid(&parent->mo_lu)), lname->ln_name, parent);
-
-	/*
-	 * Do not perform lookup sanity check. We know that name does not exist.
-	 */
-	spec->sp_cr_lookup = 0;
-	rc = mdo_create(env, parent, lname, lu2md(child), spec, ma);
-	if (rc) {
-		CERROR("Can not create child "DFID": rc = %d\n", PFID(fid), rc);
-		GOTO(out_put, rc);
-	}
-	CDEBUG(D_RPCTRACE, "End creating object "DFID" %s %p rc  = %d\n",
-	       PFID(lu_object_fid(&parent->mo_lu)), lname->ln_name, parent, rc);
-out_put:
-	lu_object_put(env, ec_child);
-	return rc;
-}
-
-static int echo_set_lmm_size(const struct lu_env *env, struct lu_device *ld,
-			     struct md_attr *ma)
-{
-	struct echo_thread_info *info = echo_env_info(env);
-
-	if (strcmp(ld->ld_type->ldt_name, LUSTRE_MDD_NAME)) {
-		ma->ma_lmm = (void *)&info->eti_lmm;
-		ma->ma_lmm_size = sizeof(info->eti_lmm);
-	} else {
-		LASSERT(info->eti_big_lmmsize);
-		ma->ma_lmm = info->eti_big_lmm;
-		ma->ma_lmm_size = info->eti_big_lmmsize;
-	}
-
-	return 0;
-}
-
-static int echo_create_md_object(const struct lu_env *env,
-				 struct echo_device *ed,
-				 struct lu_object *ec_parent,
-				 struct lu_fid *fid,
-				 char *name, int namelen,
-				 __u64 id, __u32 mode, int count,
-				 int stripe_count, int stripe_offset)
-{
-	struct lu_object	*parent;
-	struct echo_thread_info *info = echo_env_info(env);
-	struct lu_name	  *lname = &info->eti_lname;
-	struct md_op_spec       *spec = &info->eti_spec;
-	struct md_attr	  *ma = &info->eti_ma;
-	struct lu_device	*ld = ed->ed_next;
-	int		      rc = 0;
-	int		      i;
-
-	if (ec_parent == NULL)
-		return -1;
-	parent = lu_object_locate(ec_parent->lo_header, ld->ld_type);
-	if (parent == NULL)
-		return -ENXIO;
-
-	memset(ma, 0, sizeof(*ma));
-	memset(spec, 0, sizeof(*spec));
-	if (stripe_count != 0) {
-		spec->sp_cr_flags |= FMODE_WRITE;
-		echo_set_lmm_size(env, ld, ma);
-		if (stripe_count != -1) {
-			struct lov_user_md_v3 *lum = &info->eti_lum;
-
-			lum->lmm_magic = LOV_USER_MAGIC_V3;
-			lum->lmm_stripe_count = stripe_count;
-			lum->lmm_stripe_offset = stripe_offset;
-			lum->lmm_pattern = 0;
-			spec->u.sp_ea.eadata = lum;
-			spec->u.sp_ea.eadatalen = sizeof(*lum);
-			spec->sp_cr_flags |= MDS_OPEN_HAS_EA;
-		}
-	}
-
-	ma->ma_attr.la_mode = mode;
-	ma->ma_attr.la_valid = LA_CTIME | LA_MODE;
-	ma->ma_attr.la_ctime = cfs_time_current_64();
-
-	if (name != NULL) {
-		lname->ln_name = name;
-		lname->ln_namelen = namelen;
-		/* If name is specified, only create one object by name */
-		rc = echo_md_create_internal(env, ed, lu2md(parent), fid, lname,
-					     spec, ma);
-		return rc;
-	}
-
-	/* Create multiple object sequenced by id */
-	for (i = 0; i < count; i++) {
-		char *tmp_name = info->eti_name;
-
-		echo_md_build_name(lname, tmp_name, id);
-
-		rc = echo_md_create_internal(env, ed, lu2md(parent), fid, lname,
-					     spec, ma);
-		if (rc) {
-			CERROR("Can not create child %s: rc = %d\n", tmp_name,
-				rc);
-			break;
-		}
-		id++;
-		fid->f_oid++;
-	}
-
-	return rc;
-}
-
-static struct lu_object *echo_md_lookup(const struct lu_env *env,
-					struct echo_device *ed,
-					struct md_object *parent,
-					struct lu_name *lname)
-{
-	struct echo_thread_info *info = echo_env_info(env);
-	struct lu_fid	   *fid = &info->eti_fid;
-	struct lu_object	*child;
-	int    rc;
-
-	CDEBUG(D_INFO, "lookup %s in parent "DFID" %p\n", lname->ln_name,
-	       PFID(fid), parent);
-	rc = mdo_lookup(env, parent, lname, fid, NULL);
-	if (rc) {
-		CERROR("lookup %s: rc = %d\n", lname->ln_name, rc);
-		return ERR_PTR(rc);
-	}
-
-	/* In the function below, .hs_keycmp resolves to
-	 * lu_obj_hop_keycmp() */
-	/* coverity[overrun-buffer-val] */
-	child = lu_object_find_at(env, &ed->ed_cl.cd_lu_dev, fid, NULL);
-
-	return child;
-}
-
-static int echo_setattr_object(const struct lu_env *env,
-			       struct echo_device *ed,
-			       struct lu_object *ec_parent,
-			       __u64 id, int count)
-{
-	struct lu_object	*parent;
-	struct echo_thread_info *info = echo_env_info(env);
-	struct lu_name	  *lname = &info->eti_lname;
-	char		    *name = info->eti_name;
-	struct lu_device	*ld = ed->ed_next;
-	struct lu_buf	   *buf = &info->eti_buf;
-	int		      rc = 0;
-	int		      i;
-
-	if (ec_parent == NULL)
-		return -1;
-	parent = lu_object_locate(ec_parent->lo_header, ld->ld_type);
-	if (parent == NULL)
-		return -ENXIO;
-
-	for (i = 0; i < count; i++) {
-		struct lu_object *ec_child, *child;
-
-		echo_md_build_name(lname, name, id);
-
-		ec_child = echo_md_lookup(env, ed, lu2md(parent), lname);
-		if (IS_ERR(ec_child)) {
-			CERROR("Can't find child %s: rc = %ld\n",
-				lname->ln_name, PTR_ERR(ec_child));
-			return PTR_ERR(ec_child);
-		}
-
-		child = lu_object_locate(ec_child->lo_header, ld->ld_type);
-		if (child == NULL) {
-			CERROR("Can not locate the child %s\n", lname->ln_name);
-			lu_object_put(env, ec_child);
-			rc = -EINVAL;
-			break;
-		}
-
-		CDEBUG(D_RPCTRACE, "Start setattr object "DFID"\n",
-		       PFID(lu_object_fid(child)));
-
-		buf->lb_buf = info->eti_xattr_buf;
-		buf->lb_len = sizeof(info->eti_xattr_buf);
-
-		sprintf(name, "%s.test1", XATTR_USER_PREFIX);
-		rc = mo_xattr_set(env, lu2md(child), buf, name,
-				  LU_XATTR_CREATE);
-		if (rc < 0) {
-			CERROR("Can not setattr child "DFID": rc = %d\n",
-				PFID(lu_object_fid(child)), rc);
-			lu_object_put(env, ec_child);
-			break;
-		}
-		CDEBUG(D_RPCTRACE, "End setattr object "DFID"\n",
-		       PFID(lu_object_fid(child)));
-		id++;
-		lu_object_put(env, ec_child);
-	}
-	return rc;
-}
-
-static int echo_getattr_object(const struct lu_env *env,
-			       struct echo_device *ed,
-			       struct lu_object *ec_parent,
-			       __u64 id, int count)
-{
-	struct lu_object	*parent;
-	struct echo_thread_info *info = echo_env_info(env);
-	struct lu_name	  *lname = &info->eti_lname;
-	char		    *name = info->eti_name;
-	struct md_attr	  *ma = &info->eti_ma;
-	struct lu_device	*ld = ed->ed_next;
-	int		      rc = 0;
-	int		      i;
-
-	if (ec_parent == NULL)
-		return -1;
-	parent = lu_object_locate(ec_parent->lo_header, ld->ld_type);
-	if (parent == NULL)
-		return -ENXIO;
-
-	memset(ma, 0, sizeof(*ma));
-	ma->ma_need |= MA_INODE | MA_LOV | MA_PFID | MA_HSM | MA_ACL_DEF;
-	ma->ma_acl = info->eti_xattr_buf;
-	ma->ma_acl_size = sizeof(info->eti_xattr_buf);
-
-	for (i = 0; i < count; i++) {
-		struct lu_object *ec_child, *child;
-
-		ma->ma_valid = 0;
-		echo_md_build_name(lname, name, id);
-		echo_set_lmm_size(env, ld, ma);
-
-		ec_child = echo_md_lookup(env, ed, lu2md(parent), lname);
-		if (IS_ERR(ec_child)) {
-			CERROR("Can't find child %s: rc = %ld\n",
-			       lname->ln_name, PTR_ERR(ec_child));
-			return PTR_ERR(ec_child);
-		}
-
-		child = lu_object_locate(ec_child->lo_header, ld->ld_type);
-		if (child == NULL) {
-			CERROR("Can not locate the child %s\n", lname->ln_name);
-			lu_object_put(env, ec_child);
-			return -EINVAL;
-		}
-
-		CDEBUG(D_RPCTRACE, "Start getattr object "DFID"\n",
-		       PFID(lu_object_fid(child)));
-		rc = echo_attr_get_complex(env, lu2md(child), ma);
-		if (rc) {
-			CERROR("Can not getattr child "DFID": rc = %d\n",
-				PFID(lu_object_fid(child)), rc);
-			lu_object_put(env, ec_child);
-			break;
-		}
-		CDEBUG(D_RPCTRACE, "End getattr object "DFID"\n",
-		       PFID(lu_object_fid(child)));
-		id++;
-		lu_object_put(env, ec_child);
-	}
-
-	return rc;
-}
-
-static int echo_lookup_object(const struct lu_env *env,
-			      struct echo_device *ed,
-			      struct lu_object *ec_parent,
-			      __u64 id, int count)
-{
-	struct lu_object	*parent;
-	struct echo_thread_info *info = echo_env_info(env);
-	struct lu_name	  *lname = &info->eti_lname;
-	char		    *name = info->eti_name;
-	struct lu_fid	   *fid = &info->eti_fid;
-	struct lu_device	*ld = ed->ed_next;
-	int		      rc = 0;
-	int		      i;
-
-	if (ec_parent == NULL)
-		return -1;
-	parent = lu_object_locate(ec_parent->lo_header, ld->ld_type);
-	if (parent == NULL)
-		return -ENXIO;
-
-	/*prepare the requests*/
-	for (i = 0; i < count; i++) {
-		echo_md_build_name(lname, name, id);
-
-		CDEBUG(D_RPCTRACE, "Start lookup object "DFID" %s %p\n",
-		       PFID(lu_object_fid(parent)), lname->ln_name, parent);
-
-		rc = mdo_lookup(env, lu2md(parent), lname, fid, NULL);
-		if (rc) {
-			CERROR("Can not lookup child %s: rc = %d\n", name, rc);
-			break;
-		}
-		CDEBUG(D_RPCTRACE, "End lookup object "DFID" %s %p\n",
-		       PFID(lu_object_fid(parent)), lname->ln_name, parent);
-
-		id++;
-	}
-	return rc;
-}
-
-static int echo_md_destroy_internal(const struct lu_env *env,
-				    struct echo_device *ed,
-				    struct md_object *parent,
-				    struct lu_name *lname,
-				    struct md_attr *ma)
-{
-	struct lu_device   *ld = ed->ed_next;
-	struct lu_object   *ec_child;
-	struct lu_object   *child;
-	int		 rc;
-
-	ec_child = echo_md_lookup(env, ed, parent, lname);
-	if (IS_ERR(ec_child)) {
-		CERROR("Can't find child %s: rc = %ld\n", lname->ln_name,
-			PTR_ERR(ec_child));
-		return PTR_ERR(ec_child);
-	}
-
-	child = lu_object_locate(ec_child->lo_header, ld->ld_type);
-	if (child == NULL) {
-		CERROR("Can not locate the child %s\n", lname->ln_name);
-		GOTO(out_put, rc = -EINVAL);
-	}
-
-	CDEBUG(D_RPCTRACE, "Start destroy object "DFID" %s %p\n",
-	       PFID(lu_object_fid(&parent->mo_lu)), lname->ln_name, parent);
-
-	rc = mdo_unlink(env, parent, lu2md(child), lname, ma, 0);
-	if (rc) {
-		CERROR("Can not unlink child %s: rc = %d\n",
-			lname->ln_name, rc);
-		GOTO(out_put, rc);
-	}
-	CDEBUG(D_RPCTRACE, "End destroy object "DFID" %s %p\n",
-	       PFID(lu_object_fid(&parent->mo_lu)), lname->ln_name, parent);
-out_put:
-	lu_object_put(env, ec_child);
-	return rc;
-}
-
-static int echo_destroy_object(const struct lu_env *env,
-			       struct echo_device *ed,
-			       struct lu_object *ec_parent,
-			       char *name, int namelen,
-			       __u64 id, __u32 mode,
-			       int count)
-{
-	struct echo_thread_info *info = echo_env_info(env);
-	struct lu_name	  *lname = &info->eti_lname;
-	struct md_attr	  *ma = &info->eti_ma;
-	struct lu_device	*ld = ed->ed_next;
-	struct lu_object	*parent;
-	int		      rc = 0;
-	int		      i;
-
-	parent = lu_object_locate(ec_parent->lo_header, ld->ld_type);
-	if (parent == NULL)
-		return -EINVAL;
-
-	memset(ma, 0, sizeof(*ma));
-	ma->ma_attr.la_mode = mode;
-	ma->ma_attr.la_valid = LA_CTIME;
-	ma->ma_attr.la_ctime = cfs_time_current_64();
-	ma->ma_need = MA_INODE;
-	ma->ma_valid = 0;
-
-	if (name != NULL) {
-		lname->ln_name = name;
-		lname->ln_namelen = namelen;
-		rc = echo_md_destroy_internal(env, ed, lu2md(parent), lname,
-					      ma);
-		return rc;
-	}
-
-	/*prepare the requests*/
-	for (i = 0; i < count; i++) {
-		char *tmp_name = info->eti_name;
-
-		ma->ma_valid = 0;
-		echo_md_build_name(lname, tmp_name, id);
-
-		rc = echo_md_destroy_internal(env, ed, lu2md(parent), lname,
-					      ma);
-		if (rc) {
-			CERROR("Can not unlink child %s: rc = %d\n", name, rc);
-			break;
-		}
-		id++;
-	}
-
-	return rc;
-}
-
-static struct lu_object *echo_resolve_path(const struct lu_env *env,
-					   struct echo_device *ed, char *path,
-					   int path_len)
-{
-	struct lu_device	*ld = ed->ed_next;
-	struct md_device	*md = lu2md_dev(ld);
-	struct echo_thread_info *info = echo_env_info(env);
-	struct lu_fid	   *fid = &info->eti_fid;
-	struct lu_name	  *lname = &info->eti_lname;
-	struct lu_object	*parent = NULL;
-	struct lu_object	*child = NULL;
-	int rc = 0;
-
-	/*Only support MDD layer right now*/
-	rc = md->md_ops->mdo_root_get(env, md, fid);
-	if (rc) {
-		CERROR("get root error: rc = %d\n", rc);
-		return ERR_PTR(rc);
-	}
-
-	/* In the function below, .hs_keycmp resolves to
-	 * lu_obj_hop_keycmp() */
-	/* coverity[overrun-buffer-val] */
-	parent = lu_object_find_at(env, &ed->ed_cl.cd_lu_dev, fid, NULL);
-	if (IS_ERR(parent)) {
-		CERROR("Can not find the parent "DFID": rc = %ld\n",
-			PFID(fid), PTR_ERR(parent));
-		return parent;
-	}
-
-	while (1) {
-		struct lu_object *ld_parent;
-		char *e;
-
-		e = strsep(&path, "/");
-		if (e == NULL)
-			break;
-
-		if (e[0] == 0) {
-			if (!path || path[0] == '\0')
-				break;
-			continue;
-		}
-
-		lname->ln_name = e;
-		lname->ln_namelen = strlen(e);
-
-		ld_parent = lu_object_locate(parent->lo_header, ld->ld_type);
-		if (ld_parent == NULL) {
-			lu_object_put(env, parent);
-			rc = -EINVAL;
-			break;
-		}
-
-		child = echo_md_lookup(env, ed, lu2md(ld_parent), lname);
-		lu_object_put(env, parent);
-		if (IS_ERR(child)) {
-			rc = (int)PTR_ERR(child);
-			CERROR("lookup %s under parent "DFID": rc = %d\n",
-				lname->ln_name, PFID(lu_object_fid(ld_parent)),
-				rc);
-			break;
-		}
-		parent = child;
-	}
-	if (rc)
-		return ERR_PTR(rc);
-
-	return parent;
-}
-
-static void echo_ucred_init(struct lu_env *env)
-{
-	struct lu_ucred *ucred = lu_ucred(env);
-
-	ucred->uc_valid = UCRED_INVALID;
-
-	ucred->uc_suppgids[0] = -1;
-	ucred->uc_suppgids[1] = -1;
-
-	ucred->uc_uid   = ucred->uc_o_uid   =
-				from_kuid(&init_user_ns, current_uid());
-	ucred->uc_gid   = ucred->uc_o_gid   =
-				from_kgid(&init_user_ns, current_gid());
-	ucred->uc_fsuid = ucred->uc_o_fsuid =
-				from_kuid(&init_user_ns, current_fsuid());
-	ucred->uc_fsgid = ucred->uc_o_fsgid =
-				from_kgid(&init_user_ns, current_fsgid());
-	ucred->uc_cap   = cfs_curproc_cap_pack();
-
-	/* remove fs privilege for non-root user. */
-	if (ucred->uc_fsuid)
-		ucred->uc_cap &= ~CFS_CAP_FS_MASK;
-	ucred->uc_valid = UCRED_NEW;
-}
-
-static void echo_ucred_fini(struct lu_env *env)
-{
-	struct lu_ucred *ucred = lu_ucred(env);
-	ucred->uc_valid = UCRED_INIT;
-}
-
-#define ECHO_MD_CTX_TAG (LCT_REMEMBER | LCT_MD_THREAD)
-#define ECHO_MD_SES_TAG (LCT_REMEMBER | LCT_SESSION)
-static int echo_md_handler(struct echo_device *ed, int command,
-			   char *path, int path_len, __u64 id, int count,
-			   struct obd_ioctl_data *data)
-{
-	struct echo_thread_info *info;
-	struct lu_device      *ld = ed->ed_next;
-	struct lu_env	 *env;
-	int		    refcheck;
-	struct lu_object      *parent;
-	char		  *name = NULL;
-	int		    namelen = data->ioc_plen2;
-	int		    rc = 0;
-
-	if (ld == NULL) {
-		CERROR("MD echo client is not being initialized properly\n");
-		return -EINVAL;
-	}
-
-	if (strcmp(ld->ld_type->ldt_name, LUSTRE_MDD_NAME)) {
-		CERROR("Only support MDD layer right now!\n");
-		return -EINVAL;
-	}
-
-	env = cl_env_get(&refcheck);
-	if (IS_ERR(env))
-		return PTR_ERR(env);
-
-	rc = lu_env_refill_by_tags(env, ECHO_MD_CTX_TAG, ECHO_MD_SES_TAG);
-	if (rc != 0)
-		GOTO(out_env, rc);
-
-	/* init big_lmm buffer */
-	info = echo_env_info(env);
-	LASSERT(info->eti_big_lmm == NULL);
-	OBD_ALLOC_LARGE(info->eti_big_lmm, MIN_MD_SIZE);
-	if (info->eti_big_lmm == NULL)
-		GOTO(out_env, rc = -ENOMEM);
-	info->eti_big_lmmsize = MIN_MD_SIZE;
-
-	parent = echo_resolve_path(env, ed, path, path_len);
-	if (IS_ERR(parent)) {
-		CERROR("Can not resolve the path %s: rc = %ld\n", path,
-			PTR_ERR(parent));
-		GOTO(out_free, rc = PTR_ERR(parent));
-	}
-
-	if (namelen > 0) {
-		OBD_ALLOC(name, namelen + 1);
-		if (name == NULL)
-			GOTO(out_put, rc = -ENOMEM);
-		if (copy_from_user(name, data->ioc_pbuf2, namelen))
-			GOTO(out_name, rc = -EFAULT);
-	}
-
-	echo_ucred_init(env);
-
-	switch (command) {
-	case ECHO_MD_CREATE:
-	case ECHO_MD_MKDIR: {
-		struct echo_thread_info *info = echo_env_info(env);
-		__u32 mode = data->ioc_obdo2.o_mode;
-		struct lu_fid *fid = &info->eti_fid;
-		int stripe_count = (int)data->ioc_obdo2.o_misc;
-		int stripe_index = (int)data->ioc_obdo2.o_stripe_idx;
-
-		rc = ostid_to_fid(fid, &data->ioc_obdo1.o_oi, 0);
-		if (rc != 0)
-			break;
-
-		/* In the function below, .hs_keycmp resolves to
-		 * lu_obj_hop_keycmp() */
-		/* coverity[overrun-buffer-val] */
-		rc = echo_create_md_object(env, ed, parent, fid, name, namelen,
-					   id, mode, count, stripe_count,
-					   stripe_index);
-		break;
-	}
-	case ECHO_MD_DESTROY:
-	case ECHO_MD_RMDIR: {
-		__u32 mode = data->ioc_obdo2.o_mode;
-
-		rc = echo_destroy_object(env, ed, parent, name, namelen,
-					 id, mode, count);
-		break;
-	}
-	case ECHO_MD_LOOKUP:
-		rc = echo_lookup_object(env, ed, parent, id, count);
-		break;
-	case ECHO_MD_GETATTR:
-		rc = echo_getattr_object(env, ed, parent, id, count);
-		break;
-	case ECHO_MD_SETATTR:
-		rc = echo_setattr_object(env, ed, parent, id, count);
-		break;
-	default:
-		CERROR("unknown command %d\n", command);
-		rc = -EINVAL;
-		break;
-	}
-	echo_ucred_fini(env);
-
-out_name:
-	if (name != NULL)
-		OBD_FREE(name, namelen + 1);
-out_put:
-	lu_object_put(env, parent);
-out_free:
-	LASSERT(info->eti_big_lmm);
-	OBD_FREE_LARGE(info->eti_big_lmm, info->eti_big_lmmsize);
-	info->eti_big_lmm = NULL;
-	info->eti_big_lmmsize = 0;
-out_env:
-	cl_env_put(env, &refcheck);
-	return rc;
-}
-
 static int echo_create_object(const struct lu_env *env, struct echo_device *ed,
 			      int on_target, struct obdo *oa, void *ulsm,
 			      int ulsm_nob, struct obd_trans_info *oti)
@@ -2770,72 +1892,6 @@ echo_client_iocontrol(unsigned int cmd, struct obd_export *exp, int len,
 					data->ioc_plen1, &dummy_oti);
 		GOTO(out, rc);
 
-	case OBD_IOC_ECHO_MD: {
-		int count;
-		int cmd;
-		char *dir = NULL;
-		int dirlen;
-		__u64 id;
-
-		if (!capable(CFS_CAP_SYS_ADMIN))
-			GOTO(out, rc = -EPERM);
-
-		count = data->ioc_count;
-		cmd = data->ioc_command;
-
-		id = ostid_id(&data->ioc_obdo2.o_oi);
-
-		dirlen = data->ioc_plen1;
-		OBD_ALLOC(dir, dirlen + 1);
-		if (dir == NULL)
-			GOTO(out, rc = -ENOMEM);
-
-		if (copy_from_user(dir, data->ioc_pbuf1, dirlen)) {
-			OBD_FREE(dir, data->ioc_plen1 + 1);
-			GOTO(out, rc = -EFAULT);
-		}
-
-		rc = echo_md_handler(ed, cmd, dir, dirlen, id, count, data);
-		OBD_FREE(dir, dirlen + 1);
-		GOTO(out, rc);
-	}
-	case OBD_IOC_ECHO_ALLOC_SEQ: {
-		struct lu_env   *cl_env;
-		int	      refcheck;
-		__u64	    seq;
-		int	      max_count;
-
-		if (!capable(CFS_CAP_SYS_ADMIN))
-			GOTO(out, rc = -EPERM);
-
-		cl_env = cl_env_get(&refcheck);
-		if (IS_ERR(cl_env))
-			GOTO(out, rc = PTR_ERR(cl_env));
-
-		rc = lu_env_refill_by_tags(cl_env, ECHO_MD_CTX_TAG,
-					    ECHO_MD_SES_TAG);
-		if (rc != 0) {
-			cl_env_put(cl_env, &refcheck);
-			GOTO(out, rc);
-		}
-
-		rc = seq_client_get_seq(cl_env, ed->ed_cl_seq, &seq);
-		cl_env_put(cl_env, &refcheck);
-		if (rc < 0) {
-			CERROR("%s: Can not alloc seq: rc = %d\n",
-			       obd->obd_name, rc);
-			GOTO(out, rc);
-		}
-
-		if (copy_to_user(data->ioc_pbuf1, &seq, data->ioc_plen1))
-			return -EFAULT;
-
-		max_count = LUSTRE_METADATA_SEQ_MAX_WIDTH;
-		if (copy_to_user(data->ioc_pbuf2, &max_count,
-				     data->ioc_plen2))
-			return -EFAULT;
-		GOTO(out, rc);
-	}
 	case OBD_IOC_DESTROY:
 		if (!capable(CFS_CAP_SYS_ADMIN))
 			GOTO (out, rc = -EPERM);
@@ -2973,12 +2029,6 @@ static int echo_client_setup(const struct lu_env *env,
 	ec->ec_unique = 0;
 	ec->ec_nstripes = 0;
 
-	if (!strcmp(tgt->obd_type->typ_name, LUSTRE_MDT_NAME)) {
-		lu_context_tags_update(ECHO_MD_CTX_TAG);
-		lu_session_tags_update(ECHO_MD_SES_TAG);
-		return 0;
-	}
-
 	OBD_ALLOC(ocd, sizeof(*ocd));
 	if (ocd == NULL) {
 		CERROR("Can't alloc ocd connecting to %s\n",
@@ -3016,20 +2066,9 @@ static int echo_client_setup(const struct lu_env *env,
 
 static int echo_client_cleanup(struct obd_device *obddev)
 {
-	struct echo_device *ed = obd2echo_dev(obddev);
 	struct echo_client_obd *ec = &obddev->u.echo_client;
 	int rc;
 
-	/*Do nothing for Metadata echo client*/
-	if (ed == NULL )
-		return 0;
-
-	if (ed->ed_next_ismd) {
-		lu_context_tags_clear(ECHO_MD_CTX_TAG);
-		lu_session_tags_clear(ECHO_MD_SES_TAG);
-		return 0;
-	}
-
 	if (!list_empty(&obddev->obd_exports)) {
 		CERROR("still has clients!\n");
 		return -EBUSY;
-- 
1.9.3

