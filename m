Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215Ab3KNQo0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:44:26 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:33010 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757005Ab3KNQny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:43:54 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
        Sebastien Buisson <sebastien.buisson@bull.net>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 06/26] staging/lustre/build: fix 'NULL pointer dereference' errors
Date: Fri, 15 Nov 2013 00:42:53 +0800
Message-Id: <1384447393-13838-7-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384447393-13838-1-git-send-email-bergwolf@gmail.com>
References: <1384447393-13838-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastien Buisson <sebastien.buisson@bull.net>

Fix 'NULL pointer dereference' defects found by Coverity version
6.5.3:
Dereference after null check (FORWARD_NULL)
For instance, Passing null pointer to a function which dereferences
it.
Dereference before null check (REVERSE_INULL)
Null-checking variable suggests that it may be null, but it has
already been dereferenced on all paths leading to the check.
Dereference null return value (NULL_RETURNS)

Lustre-change: http://review.whamcloud.com/4720
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-2217
Signed-off-by: Sebastien Buisson <sebastien.buisson@bull.net>
Reviewed-by: Dmitry Eremin <dmitry.eremin@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c    |    2 +-
 drivers/staging/lustre/lnet/lnet/lib-move.c        |    2 +
 drivers/staging/lustre/lnet/selftest/conctl.c      |   51 ++++++++++----------
 .../lustre/lustre/include/lustre/lustre_user.h     |    3 ++
 drivers/staging/lustre/lustre/ldlm/ldlm_request.c  |   14 +++++-
 drivers/staging/lustre/lustre/lmv/lmv_obd.c        |    2 +-
 drivers/staging/lustre/lustre/lov/lov_request.c    |    2 +-
 drivers/staging/lustre/lustre/mdc/mdc_lib.c        |   38 +++++++--------
 drivers/staging/lustre/lustre/mgc/mgc_request.c    |   10 +++-
 .../lustre/lustre/obdclass/lprocfs_status.c        |   24 ++++-----
 drivers/staging/lustre/lustre/ptlrpc/layout.c      |    2 +-
 drivers/staging/lustre/lustre/ptlrpc/sec_config.c  |   10 ++--
 12 files changed, 94 insertions(+), 66 deletions(-)

diff --git a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
index 86397f9..9c6b7d0 100644
--- a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
+++ b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
@@ -3217,7 +3217,7 @@ kiblnd_startup (lnet_ni_t *ni)
 	return 0;
 
 failed:
-	if (net->ibn_dev == NULL && ibdev != NULL)
+	if (net != NULL && net->ibn_dev == NULL && ibdev != NULL)
 		kiblnd_destroy_dev(ibdev);
 
 	kiblnd_shutdown(ni);
diff --git a/drivers/staging/lustre/lnet/lnet/lib-move.c b/drivers/staging/lustre/lnet/lnet/lib-move.c
index a5f25a2..cd768f6 100644
--- a/drivers/staging/lustre/lnet/lnet/lib-move.c
+++ b/drivers/staging/lustre/lnet/lnet/lib-move.c
@@ -162,6 +162,7 @@ lnet_iov_nob(unsigned int niov, struct iovec *iov)
 {
 	unsigned int nob = 0;
 
+	LASSERT(niov == 0 || iov != NULL);
 	while (niov-- > 0)
 		nob += (iov++)->iov_len;
 
@@ -281,6 +282,7 @@ lnet_kiov_nob(unsigned int niov, lnet_kiov_t *kiov)
 {
 	unsigned int  nob = 0;
 
+	LASSERT(niov == 0 || kiov != NULL);
 	while (niov-- > 0)
 		nob += (kiov++)->kiov_len;
 
diff --git a/drivers/staging/lustre/lnet/selftest/conctl.c b/drivers/staging/lustre/lnet/selftest/conctl.c
index cbc416d..4ed1388 100644
--- a/drivers/staging/lustre/lnet/selftest/conctl.c
+++ b/drivers/staging/lustre/lnet/selftest/conctl.c
@@ -679,45 +679,46 @@ int
 lst_stat_query_ioctl(lstio_stat_args_t *args)
 {
 	int	     rc;
-	char	   *name;
+	char           *name = NULL;
 
 	/* TODO: not finished */
 	if (args->lstio_sta_key != console_session.ses_key)
 		return -EACCES;
 
-	if (args->lstio_sta_resultp == NULL ||
-	    (args->lstio_sta_namep  == NULL &&
-	     args->lstio_sta_idsp   == NULL) ||
-	    args->lstio_sta_nmlen <= 0 ||
-	    args->lstio_sta_nmlen > LST_NAME_SIZE)
-		return -EINVAL;
-
-	if (args->lstio_sta_idsp != NULL &&
-	    args->lstio_sta_count <= 0)
+	if (args->lstio_sta_resultp == NULL)
 		return -EINVAL;
 
-	LIBCFS_ALLOC(name, args->lstio_sta_nmlen + 1);
-	if (name == NULL)
-		return -ENOMEM;
-
-	if (copy_from_user(name, args->lstio_sta_namep,
-			       args->lstio_sta_nmlen)) {
-		LIBCFS_FREE(name, args->lstio_sta_nmlen + 1);
-		return -EFAULT;
-	}
+	if (args->lstio_sta_idsp != NULL) {
+		if (args->lstio_sta_count <= 0)
+			return -EINVAL;
 
-	if (args->lstio_sta_idsp == NULL) {
-		rc = lstcon_group_stat(name, args->lstio_sta_timeout,
-				       args->lstio_sta_resultp);
-	} else {
 		rc = lstcon_nodes_stat(args->lstio_sta_count,
 				       args->lstio_sta_idsp,
 				       args->lstio_sta_timeout,
 				       args->lstio_sta_resultp);
-	}
+	} else if (args->lstio_sta_namep != NULL) {
+		if (args->lstio_sta_nmlen <= 0 ||
+		    args->lstio_sta_nmlen > LST_NAME_SIZE)
+			return -EINVAL;
+
+		LIBCFS_ALLOC(name, args->lstio_sta_nmlen + 1);
+		if (name == NULL)
+			return -ENOMEM;
 
-	LIBCFS_FREE(name, args->lstio_sta_nmlen + 1);
+		rc = copy_from_user(name, args->lstio_sta_namep,
+				    args->lstio_sta_nmlen);
+		if (rc == 0)
+			rc = lstcon_group_stat(name, args->lstio_sta_timeout,
+					       args->lstio_sta_resultp);
+		else
+			rc = -EFAULT;
 
+	} else {
+		rc = -EINVAL;
+	}
+
+	if (name != NULL)
+		LIBCFS_FREE(name, args->lstio_sta_nmlen + 1);
 	return rc;
 }
 
diff --git a/drivers/staging/lustre/lustre/include/lustre/lustre_user.h b/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
index e982dbc..e4d69e59 100644
--- a/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
+++ b/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
@@ -451,6 +451,9 @@ static inline void obd_str2uuid(struct obd_uuid *uuid, const char *tmp)
 /* For printf's only, make sure uuid is terminated */
 static inline char *obd_uuid2str(const struct obd_uuid *uuid)
 {
+	if (uuid == NULL)
+		return NULL;
+
 	if (uuid->uuid[sizeof(*uuid) - 1] != '\0') {
 		/* Obviously not safe, but for printfs, no real harm done...
 		   we're always null-terminated, even in a race. */
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_request.c b/drivers/staging/lustre/lustre/ldlm/ldlm_request.c
index 68ace4a..0ace4fe 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_request.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_request.c
@@ -439,8 +439,13 @@ int ldlm_cli_enqueue_local(struct ldlm_namespace *ns,
 		lock->l_policy_data = *policy;
 	if (client_cookie != NULL)
 		lock->l_client_cookie = *client_cookie;
-	if (type == LDLM_EXTENT)
+	if (type == LDLM_EXTENT) {
+		/* extent lock without policy is a bug */
+		if (policy == NULL)
+			LBUG();
+
 		lock->l_req_extent = policy->l_extent;
+	}
 
 	err = ldlm_lock_enqueue(ns, &lock, policy, flags);
 	if (unlikely(err != ELDLM_OK))
@@ -892,8 +897,13 @@ int ldlm_cli_enqueue(struct obd_export *exp, struct ptlrpc_request **reqp,
 				lock->l_policy_data = *policy;
 		}
 
-		if (einfo->ei_type == LDLM_EXTENT)
+		if (einfo->ei_type == LDLM_EXTENT) {
+			/* extent lock without policy is a bug */
+			if (policy == NULL)
+				LBUG();
+
 			lock->l_req_extent = policy->l_extent;
+		}
 		LDLM_DEBUG(lock, "client-side enqueue START, flags %llx\n",
 			   *flags);
 	}
diff --git a/drivers/staging/lustre/lustre/lmv/lmv_obd.c b/drivers/staging/lustre/lustre/lmv/lmv_obd.c
index 2a1d6e0..abbde7e 100644
--- a/drivers/staging/lustre/lustre/lmv/lmv_obd.c
+++ b/drivers/staging/lustre/lustre/lmv/lmv_obd.c
@@ -244,7 +244,7 @@ static int lmv_connect(const struct lu_env *env,
 	 * and MDC stuff will be called directly, for instance while reading
 	 * ../mdc/../kbytesfree procfs file, etc.
 	 */
-	if (data->ocd_connect_flags & OBD_CONNECT_REAL)
+	if (data != NULL && (data->ocd_connect_flags & OBD_CONNECT_REAL))
 		rc = lmv_check_connect(obd);
 
 	if (rc && lmv_proc_dir) {
diff --git a/drivers/staging/lustre/lustre/lov/lov_request.c b/drivers/staging/lustre/lustre/lov/lov_request.c
index bf324ae..378e48e 100644
--- a/drivers/staging/lustre/lustre/lov/lov_request.c
+++ b/drivers/staging/lustre/lustre/lov/lov_request.c
@@ -185,7 +185,7 @@ int lov_check_and_wait_active(struct lov_obd *lov, int ost_idx)
 				   cfs_time_seconds(1), NULL, NULL);
 
 	rc = l_wait_event(waitq, lov_check_set(lov, ost_idx), &lwi);
-	if (tgt != NULL && tgt->ltd_active)
+	if (tgt->ltd_active)
 		return 1;
 
 	return 0;
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_lib.c b/drivers/staging/lustre/lustre/mdc/mdc_lib.c
index a839c96..dafa2c1 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_lib.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_lib.c
@@ -223,29 +223,29 @@ void mdc_open_pack(struct ptlrpc_request *req, struct md_op_data *op_data,
 	rec->cr_fsuid    = from_kuid(&init_user_ns, current_fsuid());
 	rec->cr_fsgid    = from_kgid(&init_user_ns, current_fsgid());
 	rec->cr_cap      = cfs_curproc_cap_pack();
-	if (op_data != NULL) {
-		rec->cr_fid1 = op_data->op_fid1;
-		rec->cr_fid2 = op_data->op_fid2;
-	}
 	rec->cr_mode     = mode;
 	cr_flags = mds_pack_open_flags(flags, mode);
 	rec->cr_rdev     = rdev;
-	rec->cr_time     = op_data->op_mod_time;
-	rec->cr_suppgid1 = op_data->op_suppgids[0];
-	rec->cr_suppgid2 = op_data->op_suppgids[1];
-	rec->cr_bias     = op_data->op_bias;
 	rec->cr_umask    = current_umask();
-	rec->cr_old_handle = op_data->op_handle;
-
-	mdc_pack_capa(req, &RMF_CAPA1, op_data->op_capa1);
-	/* the next buffer is child capa, which is used for replay,
-	 * will be packed from the data in reply message. */
-
-	if (op_data->op_name) {
-		tmp = req_capsule_client_get(&req->rq_pill, &RMF_NAME);
-		LOGL0(op_data->op_name, op_data->op_namelen, tmp);
-		if (op_data->op_bias & MDS_CREATE_VOLATILE)
-			cr_flags |= MDS_OPEN_VOLATILE;
+	if (op_data != NULL) {
+		rec->cr_fid1       = op_data->op_fid1;
+		rec->cr_fid2       = op_data->op_fid2;
+		rec->cr_time       = op_data->op_mod_time;
+		rec->cr_suppgid1   = op_data->op_suppgids[0];
+		rec->cr_suppgid2   = op_data->op_suppgids[1];
+		rec->cr_bias       = op_data->op_bias;
+		rec->cr_old_handle = op_data->op_handle;
+
+		mdc_pack_capa(req, &RMF_CAPA1, op_data->op_capa1);
+		/* the next buffer is child capa, which is used for replay,
+		 * will be packed from the data in reply message. */
+
+		if (op_data->op_name) {
+			tmp = req_capsule_client_get(&req->rq_pill, &RMF_NAME);
+			LOGL0(op_data->op_name, op_data->op_namelen, tmp);
+			if (op_data->op_bias & MDS_CREATE_VOLATILE)
+				cr_flags |= MDS_OPEN_VOLATILE;
+		}
 	}
 
 	if (lmm) {
diff --git a/drivers/staging/lustre/lustre/mgc/mgc_request.c b/drivers/staging/lustre/lustre/mgc/mgc_request.c
index f4ecd29..94e11bd 100644
--- a/drivers/staging/lustre/lustre/mgc/mgc_request.c
+++ b/drivers/staging/lustre/lustre/mgc/mgc_request.c
@@ -352,7 +352,15 @@ static int config_log_add(struct obd_device *obd, char *logname,
 	LASSERT(lsi->lsi_lmd);
 	if (!(lsi->lsi_lmd->lmd_flags & LMD_FLG_NOIR)) {
 		struct config_llog_data *recover_cld;
-		*strrchr(seclogname, '-') = 0;
+		ptr = strrchr(seclogname, '-');
+		if (ptr != NULL) {
+			*ptr = 0;
+		}
+		else {
+			CERROR("sptlrpc log name not correct: %s", seclogname);
+			config_log_put(cld);
+			return -EINVAL;
+		}
 		recover_cld = config_recover_log_add(obd, seclogname, cfg, sb);
 		if (IS_ERR(recover_cld))
 			GOTO(out_err3, rc = PTR_ERR(recover_cld));
diff --git a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
index 8f91ab9..428a023 100644
--- a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
+++ b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
@@ -1847,17 +1847,19 @@ int lprocfs_write_frac_u64_helper(const char *buffer, unsigned long count,
 	}
 
 	units = 1;
-	switch(*end) {
-	case 'p': case 'P':
-		units <<= 10;
-	case 't': case 'T':
-		units <<= 10;
-	case 'g': case 'G':
-		units <<= 10;
-	case 'm': case 'M':
-		units <<= 10;
-	case 'k': case 'K':
-		units <<= 10;
+	if (end != NULL) {
+		switch (*end) {
+		case 'p': case 'P':
+			units <<= 10;
+		case 't': case 'T':
+			units <<= 10;
+		case 'g': case 'G':
+			units <<= 10;
+		case 'm': case 'M':
+			units <<= 10;
+		case 'k': case 'K':
+			units <<= 10;
+		}
 	}
 	/* Specified units override the multiplier */
 	if (units)
diff --git a/drivers/staging/lustre/lustre/ptlrpc/layout.c b/drivers/staging/lustre/lustre/ptlrpc/layout.c
index 3aa5539..75b92c8 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/layout.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/layout.c
@@ -1893,7 +1893,7 @@ swabber_dumper_helper(struct req_capsule *pill,
 			return;
 		swabber(value);
 		ptlrpc_buf_set_swabbed(pill->rc_req, inout, offset);
-		if (dump) {
+		if (dump && field->rmf_dumper) {
 			CDEBUG(D_RPCTRACE, "Dump of swabbed field %s "
 			       "follows\n", field->rmf_name);
 			field->rmf_dumper(value);
diff --git a/drivers/staging/lustre/lustre/ptlrpc/sec_config.c b/drivers/staging/lustre/lustre/ptlrpc/sec_config.c
index 6b4c971..cd93acd 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/sec_config.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/sec_config.c
@@ -745,11 +745,13 @@ void sptlrpc_conf_log_update_begin(const char *logname)
 	mutex_lock(&sptlrpc_conf_lock);
 
 	conf = sptlrpc_conf_get(fsname, 0);
-	if (conf && conf->sc_local) {
-		LASSERT(conf->sc_updated == 0);
-		sptlrpc_conf_free_rsets(conf);
+	if (conf) {
+		if (conf->sc_local) {
+			LASSERT(conf->sc_updated == 0);
+			sptlrpc_conf_free_rsets(conf);
+		}
+		conf->sc_modified = 0;
 	}
-	conf->sc_modified = 0;
 
 	mutex_unlock(&sptlrpc_conf_lock);
 }
-- 
1.7.9.5

