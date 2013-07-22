Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932994Ab3GVQMv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:12:51 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:32899 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932942Ab3GVQMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:12:35 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Liu Xuezhao <xuezhao.liu@emc.com>,
        "John L. Hammond" <john.hammond@intel.com>,
        Peng Tao <tao.peng@emc.com>, Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 33/48] staging/lustre/fld: prepare FLD module for client server split
Date: Tue, 23 Jul 2013 00:06:54 +0800
Message-Id: <1374509230-3324-34-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
References: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Xuezhao <xuezhao.liu@emc.com>

Split FLD server from client, fld_{handler,index}.c are not compliled
unless server support is enabled.  Do not include dt_object.h or
lustre_mdt.h in lustre_fld.h and fix the minor breakages caused by
this elsewhere.  Generally cleanup includes in lustre/fld.

Signed-off-by: Liu Xuezhao <xuezhao.liu@emc.com>
Signed-off-by: John L. Hammond <john.hammond@intel.com>
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-1330
Lustre-change: http://review.whamcloud.com/2675
Reviewed-by: Nathaniel Clark <nathaniel.l.clark@intel.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/fld/Makefile         |    2 +-
 drivers/staging/lustre/lustre/fld/fld_handler.c    |  447 --------------------
 drivers/staging/lustre/lustre/fld/fld_index.c      |  426 -------------------
 drivers/staging/lustre/lustre/fld/fld_internal.h   |   29 --
 drivers/staging/lustre/lustre/fld/fld_request.c    |   40 +-
 drivers/staging/lustre/lustre/fld/lproc_fld.c      |  205 +--------
 drivers/staging/lustre/lustre/include/lustre_fld.h |   41 --
 drivers/staging/lustre/lustre/include/lustre_mdt.h |   84 ----
 .../staging/lustre/lustre/obdecho/echo_client.c    |    1 +
 9 files changed, 37 insertions(+), 1238 deletions(-)
 delete mode 100644 drivers/staging/lustre/lustre/fld/fld_handler.c
 delete mode 100644 drivers/staging/lustre/lustre/fld/fld_index.c
 delete mode 100644 drivers/staging/lustre/lustre/include/lustre_mdt.h

diff --git a/drivers/staging/lustre/lustre/fld/Makefile b/drivers/staging/lustre/lustre/fld/Makefile
index e7f2881..90d46d8 100644
--- a/drivers/staging/lustre/lustre/fld/Makefile
+++ b/drivers/staging/lustre/lustre/fld/Makefile
@@ -1,5 +1,5 @@
 obj-$(CONFIG_LUSTRE_FS) += fld.o
-fld-y := fld_handler.o fld_request.o fld_cache.o fld_index.o lproc_fld.o
+fld-y := fld_request.o fld_cache.o lproc_fld.o
 
 
 ccflags-y := -I$(src)/../include
diff --git a/drivers/staging/lustre/lustre/fld/fld_handler.c b/drivers/staging/lustre/lustre/fld/fld_handler.c
deleted file mode 100644
index d2707ae..0000000
--- a/drivers/staging/lustre/lustre/fld/fld_handler.c
+++ /dev/null
@@ -1,447 +0,0 @@
-/*
- * GPL HEADER START
- *
- * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 only,
- * as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License version 2 for more details (a copy is included
- * in the LICENSE file that accompanied this code).
- *
- * You should have received a copy of the GNU General Public License
- * version 2 along with this program; If not, see
- * http://www.sun.com/software/products/lustre/docs/GPLv2.pdf
- *
- * Please contact Sun Microsystems, Inc., 4150 Network Circle, Santa Clara,
- * CA 95054 USA or visit www.sun.com if you need additional information or
- * have any questions.
- *
- * GPL HEADER END
- */
-/*
- * Copyright (c) 2007, 2010, Oracle and/or its affiliates. All rights reserved.
- * Use is subject to license terms.
- *
- * Copyright (c) 2011, 2013, Intel Corporation.
- */
-/*
- * This file is part of Lustre, http://www.lustre.org/
- * Lustre is a trademark of Sun Microsystems, Inc.
- *
- * lustre/fld/fld_handler.c
- *
- * FLD (Fids Location Database)
- *
- * Author: Yury Umanets <umka@clusterfs.com>
- * Author: WangDi <wangdi@clusterfs.com>
- * Author: Pravin Shelar <pravin.shelar@sun.com>
- */
-
-#define DEBUG_SUBSYSTEM S_FLD
-
-# include <linux/libcfs/libcfs.h>
-# include <linux/module.h>
-# include <linux/jbd.h>
-# include <asm/div64.h>
-
-#include <obd.h>
-#include <obd_class.h>
-#include <lustre_ver.h>
-#include <obd_support.h>
-#include <lprocfs_status.h>
-
-#include <md_object.h>
-#include <lustre_fid.h>
-#include <lustre_req_layout.h>
-#include "fld_internal.h"
-#include <lustre_fid.h>
-
-
-/* context key constructor/destructor: fld_key_init, fld_key_fini */
-LU_KEY_INIT_FINI(fld, struct fld_thread_info);
-
-/* context key: fld_thread_key */
-LU_CONTEXT_KEY_DEFINE(fld, LCT_MD_THREAD | LCT_DT_THREAD | LCT_MG_THREAD);
-
-proc_dir_entry_t *fld_type_proc_dir = NULL;
-
-static int __init fld_mod_init(void)
-{
-	fld_type_proc_dir = lprocfs_register(LUSTRE_FLD_NAME,
-					     proc_lustre_root,
-					     NULL, NULL);
-	if (IS_ERR(fld_type_proc_dir))
-		return PTR_ERR(fld_type_proc_dir);
-
-	LU_CONTEXT_KEY_INIT(&fld_thread_key);
-	lu_context_key_register(&fld_thread_key);
-	return 0;
-}
-
-static void __exit fld_mod_exit(void)
-{
-	lu_context_key_degister(&fld_thread_key);
-	if (fld_type_proc_dir != NULL && !IS_ERR(fld_type_proc_dir)) {
-		lprocfs_remove(&fld_type_proc_dir);
-		fld_type_proc_dir = NULL;
-	}
-}
-
-int fld_declare_server_create(const struct lu_env *env,
-			      struct lu_server_fld *fld,
-			      struct lu_seq_range *range,
-			      struct thandle *th)
-{
-	int rc;
-
-	rc = fld_declare_index_create(env, fld, range, th);
-	RETURN(rc);
-}
-EXPORT_SYMBOL(fld_declare_server_create);
-
-/**
- * Insert FLD index entry and update FLD cache.
- *
- * This function is called from the sequence allocator when a super-sequence
- * is granted to a server.
- */
-int fld_server_create(const struct lu_env *env, struct lu_server_fld *fld,
-		      struct lu_seq_range *range, struct thandle *th)
-{
-	int rc;
-
-	mutex_lock(&fld->lsf_lock);
-	rc = fld_index_create(env, fld, range, th);
-	mutex_unlock(&fld->lsf_lock);
-
-	RETURN(rc);
-}
-EXPORT_SYMBOL(fld_server_create);
-
-/**
- *  Lookup mds by seq, returns a range for given seq.
- *
- *  If that entry is not cached in fld cache, request is sent to super
- *  sequence controller node (MDT0). All other MDT[1...N] and client
- *  cache fld entries, but this cache is not persistent.
- */
-int fld_server_lookup(const struct lu_env *env, struct lu_server_fld *fld,
-		      seqno_t seq, struct lu_seq_range *range)
-{
-	struct lu_seq_range *erange;
-	struct fld_thread_info *info;
-	int rc;
-	ENTRY;
-
-	info = lu_context_key_get(&env->le_ctx, &fld_thread_key);
-	LASSERT(info != NULL);
-	erange = &info->fti_lrange;
-
-	/* Lookup it in the cache. */
-	rc = fld_cache_lookup(fld->lsf_cache, seq, erange);
-	if (rc == 0) {
-		if (unlikely(fld_range_type(erange) != fld_range_type(range) &&
-			     !fld_range_is_any(range))) {
-			CERROR("%s: FLD cache range "DRANGE" does not match"
-			       "requested flag %x: rc = %d\n", fld->lsf_name,
-			       PRANGE(erange), range->lsr_flags, -EIO);
-			RETURN(-EIO);
-		}
-		*range = *erange;
-		RETURN(0);
-	}
-
-	if (fld->lsf_obj) {
-		/* On server side, all entries should be in cache.
-		 * If we can not find it in cache, just return error */
-		CERROR("%s: Cannot find sequence "LPX64": rc = %d\n",
-			fld->lsf_name, seq, -EIO);
-		RETURN(-EIO);
-	} else {
-		LASSERT(fld->lsf_control_exp);
-		/* send request to mdt0 i.e. super seq. controller.
-		 * This is temporary solution, long term solution is fld
-		 * replication on all mdt servers.
-		 */
-		range->lsr_start = seq;
-		rc = fld_client_rpc(fld->lsf_control_exp,
-				    range, FLD_LOOKUP);
-		if (rc == 0)
-			fld_cache_insert(fld->lsf_cache, range);
-	}
-	RETURN(rc);
-}
-EXPORT_SYMBOL(fld_server_lookup);
-
-/**
- * All MDT server handle fld lookup operation. But only MDT0 has fld index.
- * if entry is not found in cache we need to forward lookup request to MDT0
- */
-
-static int fld_server_handle(struct lu_server_fld *fld,
-			     const struct lu_env *env,
-			     __u32 opc, struct lu_seq_range *range,
-			     struct fld_thread_info *info)
-{
-	int rc;
-	ENTRY;
-
-	switch (opc) {
-	case FLD_LOOKUP:
-		rc = fld_server_lookup(env, fld, range->lsr_start, range);
-		break;
-	default:
-		rc = -EINVAL;
-		break;
-	}
-
-	CDEBUG(D_INFO, "%s: FLD req handle: error %d (opc: %d, range: "
-	       DRANGE"\n", fld->lsf_name, rc, opc, PRANGE(range));
-
-	RETURN(rc);
-
-}
-
-static int fld_req_handle(struct ptlrpc_request *req,
-			  struct fld_thread_info *info)
-{
-	struct obd_export *exp = req->rq_export;
-	struct lu_site *site = exp->exp_obd->obd_lu_dev->ld_site;
-	struct lu_seq_range *in;
-	struct lu_seq_range *out;
-	int rc;
-	__u32 *opc;
-	ENTRY;
-
-	rc = req_capsule_server_pack(info->fti_pill);
-	if (rc)
-		RETURN(err_serious(rc));
-
-	opc = req_capsule_client_get(info->fti_pill, &RMF_FLD_OPC);
-	if (opc != NULL) {
-		in = req_capsule_client_get(info->fti_pill, &RMF_FLD_MDFLD);
-		if (in == NULL)
-			RETURN(err_serious(-EPROTO));
-		out = req_capsule_server_get(info->fti_pill, &RMF_FLD_MDFLD);
-		if (out == NULL)
-			RETURN(err_serious(-EPROTO));
-		*out = *in;
-
-		/* For old 2.0 client, the 'lsr_flags' is uninitialized.
-		 * Set it as 'LU_SEQ_RANGE_MDT' by default. */
-		if (!(exp_connect_flags(exp) & OBD_CONNECT_64BITHASH) &&
-		    !(exp_connect_flags(exp) & OBD_CONNECT_MDS_MDS) &&
-		    !(exp_connect_flags(exp) & OBD_CONNECT_LIGHTWEIGHT) &&
-		    !exp->exp_libclient)
-			fld_range_set_mdt(out);
-
-		rc = fld_server_handle(lu_site2seq(site)->ss_server_fld,
-				       req->rq_svc_thread->t_env,
-				       *opc, out, info);
-	} else {
-		rc = err_serious(-EPROTO);
-	}
-
-	RETURN(rc);
-}
-
-static void fld_thread_info_init(struct ptlrpc_request *req,
-				 struct fld_thread_info *info)
-{
-	info->fti_pill = &req->rq_pill;
-	/* Init request capsule. */
-	req_capsule_init(info->fti_pill, req, RCL_SERVER);
-	req_capsule_set(info->fti_pill, &RQF_FLD_QUERY);
-}
-
-static void fld_thread_info_fini(struct fld_thread_info *info)
-{
-	req_capsule_fini(info->fti_pill);
-}
-
-static int fld_handle(struct ptlrpc_request *req)
-{
-	struct fld_thread_info *info;
-	const struct lu_env *env;
-	int rc;
-
-	env = req->rq_svc_thread->t_env;
-	LASSERT(env != NULL);
-
-	info = lu_context_key_get(&env->le_ctx, &fld_thread_key);
-	LASSERT(info != NULL);
-
-	fld_thread_info_init(req, info);
-	rc = fld_req_handle(req, info);
-	fld_thread_info_fini(info);
-
-	return rc;
-}
-
-/*
- * Entry point for handling FLD RPCs called from MDT.
- */
-int fld_query(struct com_thread_info *info)
-{
-	return fld_handle(info->cti_pill->rc_req);
-}
-EXPORT_SYMBOL(fld_query);
-
-/*
- * Returns true, if fid is local to this server node.
- *
- * WARNING: this function is *not* guaranteed to return false if fid is
- * remote: it makes an educated conservative guess only.
- *
- * fid_is_local() is supposed to be used in assertion checks only.
- */
-int fid_is_local(const struct lu_env *env,
-		 struct lu_site *site, const struct lu_fid *fid)
-{
-	int result;
-	struct seq_server_site *ss_site;
-	struct lu_seq_range *range;
-	struct fld_thread_info *info;
-	ENTRY;
-
-	info = lu_context_key_get(&env->le_ctx, &fld_thread_key);
-	range = &info->fti_lrange;
-
-	result = 1; /* conservatively assume fid is local */
-	ss_site = lu_site2seq(site);
-	if (ss_site->ss_client_fld != NULL) {
-		int rc;
-
-		rc = fld_cache_lookup(ss_site->ss_client_fld->lcf_cache,
-				      fid_seq(fid), range);
-		if (rc == 0)
-			result = (range->lsr_index == ss_site->ss_node_id);
-	}
-	return result;
-}
-EXPORT_SYMBOL(fid_is_local);
-
-static void fld_server_proc_fini(struct lu_server_fld *fld);
-
-#ifdef LPROCFS
-static int fld_server_proc_init(struct lu_server_fld *fld)
-{
-	int rc = 0;
-	ENTRY;
-
-	fld->lsf_proc_dir = lprocfs_register(fld->lsf_name,
-					     fld_type_proc_dir,
-					     fld_server_proc_list, fld);
-	if (IS_ERR(fld->lsf_proc_dir)) {
-		rc = PTR_ERR(fld->lsf_proc_dir);
-		RETURN(rc);
-	}
-
-	rc = lprocfs_seq_create(fld->lsf_proc_dir, "fldb", 0444,
-				&fld_proc_seq_fops, fld);
-	if (rc) {
-		lprocfs_remove(&fld->lsf_proc_dir);
-		fld->lsf_proc_dir = NULL;
-	}
-
-	RETURN(rc);
-}
-
-static void fld_server_proc_fini(struct lu_server_fld *fld)
-{
-	ENTRY;
-	if (fld->lsf_proc_dir != NULL) {
-		if (!IS_ERR(fld->lsf_proc_dir))
-			lprocfs_remove(&fld->lsf_proc_dir);
-		fld->lsf_proc_dir = NULL;
-	}
-	EXIT;
-}
-#else
-static int fld_server_proc_init(struct lu_server_fld *fld)
-{
-	return 0;
-}
-
-static void fld_server_proc_fini(struct lu_server_fld *fld)
-{
-	return;
-}
-#endif
-
-int fld_server_init(const struct lu_env *env, struct lu_server_fld *fld,
-		    struct dt_device *dt, const char *prefix, int mds_node_id,
-		    int type)
-{
-	int cache_size, cache_threshold;
-	int rc;
-	ENTRY;
-
-	snprintf(fld->lsf_name, sizeof(fld->lsf_name),
-		 "srv-%s", prefix);
-
-	cache_size = FLD_SERVER_CACHE_SIZE /
-		sizeof(struct fld_cache_entry);
-
-	cache_threshold = cache_size *
-		FLD_SERVER_CACHE_THRESHOLD / 100;
-
-	mutex_init(&fld->lsf_lock);
-	fld->lsf_cache = fld_cache_init(fld->lsf_name,
-					cache_size, cache_threshold);
-	if (IS_ERR(fld->lsf_cache)) {
-		rc = PTR_ERR(fld->lsf_cache);
-		fld->lsf_cache = NULL;
-		GOTO(out, rc);
-	}
-
-	if (!mds_node_id && type == LU_SEQ_RANGE_MDT) {
-		rc = fld_index_init(env, fld, dt);
-		if (rc)
-			GOTO(out, rc);
-	} else {
-		fld->lsf_obj = NULL;
-	}
-
-	rc = fld_server_proc_init(fld);
-	if (rc)
-		GOTO(out, rc);
-
-	fld->lsf_control_exp = NULL;
-
-	GOTO(out, rc);
-
-out:
-	if (rc)
-		fld_server_fini(env, fld);
-	return rc;
-}
-EXPORT_SYMBOL(fld_server_init);
-
-void fld_server_fini(const struct lu_env *env, struct lu_server_fld *fld)
-{
-	ENTRY;
-
-	fld_server_proc_fini(fld);
-	fld_index_fini(env, fld);
-
-	if (fld->lsf_cache != NULL) {
-		if (!IS_ERR(fld->lsf_cache))
-			fld_cache_fini(fld->lsf_cache);
-		fld->lsf_cache = NULL;
-	}
-
-	EXIT;
-}
-EXPORT_SYMBOL(fld_server_fini);
-
-MODULE_AUTHOR("Sun Microsystems, Inc. <http://www.lustre.org/>");
-MODULE_DESCRIPTION("Lustre FLD");
-MODULE_LICENSE("GPL");
-
-cfs_module(mdd, "0.1.0", fld_mod_init, fld_mod_exit);
diff --git a/drivers/staging/lustre/lustre/fld/fld_index.c b/drivers/staging/lustre/lustre/fld/fld_index.c
deleted file mode 100644
index ec68a54..0000000
--- a/drivers/staging/lustre/lustre/fld/fld_index.c
+++ /dev/null
@@ -1,426 +0,0 @@
-/*
- * GPL HEADER START
- *
- * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 only,
- * as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License version 2 for more details (a copy is included
- * in the LICENSE file that accompanied this code).
- *
- * You should have received a copy of the GNU General Public License
- * version 2 along with this program; If not, see
- * http://www.sun.com/software/products/lustre/docs/GPLv2.pdf
- *
- * Please contact Sun Microsystems, Inc., 4150 Network Circle, Santa Clara,
- * CA 95054 USA or visit www.sun.com if you need additional information or
- * have any questions.
- *
- * GPL HEADER END
- */
-/*
- * Copyright (c) 2007, 2010, Oracle and/or its affiliates. All rights reserved.
- * Use is subject to license terms.
- *
- * Copyright (c) 2011, 2013, Intel Corporation.
- */
-/*
- * This file is part of Lustre, http://www.lustre.org/
- * Lustre is a trademark of Sun Microsystems, Inc.
- *
- * lustre/fld/fld_index.c
- *
- * Author: WangDi <wangdi@clusterfs.com>
- * Author: Yury Umanets <umka@clusterfs.com>
- */
-
-#define DEBUG_SUBSYSTEM S_FLD
-
-# include <linux/libcfs/libcfs.h>
-# include <linux/module.h>
-# include <linux/jbd.h>
-
-#include <obd.h>
-#include <obd_class.h>
-#include <lustre_ver.h>
-#include <obd_support.h>
-#include <lprocfs_status.h>
-
-#include <dt_object.h>
-#include <md_object.h>
-#include <lustre_mdc.h>
-#include <lustre_fid.h>
-#include <lustre_fld.h>
-#include "fld_internal.h"
-
-const char fld_index_name[] = "fld";
-
-static const struct lu_seq_range IGIF_FLD_RANGE = {
-	.lsr_start = FID_SEQ_IGIF,
-	.lsr_end   = FID_SEQ_IGIF_MAX + 1,
-	.lsr_index = 0,
-	.lsr_flags = LU_SEQ_RANGE_MDT
-};
-
-static const struct lu_seq_range DOT_LUSTRE_FLD_RANGE = {
-	.lsr_start = FID_SEQ_DOT_LUSTRE,
-	.lsr_end   = FID_SEQ_DOT_LUSTRE + 1,
-	.lsr_index = 0,
-	.lsr_flags = LU_SEQ_RANGE_MDT
-};
-
-static const struct lu_seq_range ROOT_FLD_RANGE = {
-	.lsr_start = FID_SEQ_ROOT,
-	.lsr_end   = FID_SEQ_ROOT + 1,
-	.lsr_index = 0,
-	.lsr_flags = LU_SEQ_RANGE_MDT
-};
-
-const struct dt_index_features fld_index_features = {
-	.dif_flags       = DT_IND_UPDATE,
-	.dif_keysize_min = sizeof(seqno_t),
-	.dif_keysize_max = sizeof(seqno_t),
-	.dif_recsize_min = sizeof(struct lu_seq_range),
-	.dif_recsize_max = sizeof(struct lu_seq_range),
-	.dif_ptrsize     = 4
-};
-
-extern struct lu_context_key fld_thread_key;
-
-int fld_declare_index_create(const struct lu_env *env,
-			     struct lu_server_fld *fld,
-			     const struct lu_seq_range *new_range,
-			     struct thandle *th)
-{
-	struct lu_seq_range	*tmp;
-	struct lu_seq_range	*range;
-	struct fld_thread_info	*info;
-	int			rc = 0;
-
-	ENTRY;
-
-	info = lu_context_key_get(&env->le_ctx, &fld_thread_key);
-	range = &info->fti_lrange;
-	tmp = &info->fti_irange;
-	memset(range, 0, sizeof(*range));
-
-	rc = fld_index_lookup(env, fld, new_range->lsr_start, range);
-	if (rc == 0) {
-		/* In case of duplicate entry, the location must be same */
-		LASSERT((range_compare_loc(new_range, range) == 0));
-		GOTO(out, rc = -EEXIST);
-	}
-
-	if (rc != -ENOENT) {
-		CERROR("%s: lookup range "DRANGE" error: rc = %d\n",
-			fld->lsf_name, PRANGE(range), rc);
-		GOTO(out, rc);
-	}
-
-	/* Check for merge case, since the fld entry can only be increamental,
-	 * so we will only check whether it can be merged from the left. */
-	if (new_range->lsr_start == range->lsr_end && range->lsr_end != 0 &&
-	    range_compare_loc(new_range, range) == 0) {
-		range_cpu_to_be(tmp, range);
-		rc = dt_declare_delete(env, fld->lsf_obj,
-				       (struct dt_key *)&tmp->lsr_start, th);
-		if (rc) {
-			CERROR("%s: declare record "DRANGE" failed: rc = %d\n",
-			       fld->lsf_name, PRANGE(range), rc);
-			GOTO(out, rc);
-		}
-		memcpy(tmp, new_range, sizeof(*new_range));
-		tmp->lsr_start = range->lsr_start;
-	} else {
-		memcpy(tmp, new_range, sizeof(*new_range));
-	}
-
-	range_cpu_to_be(tmp, tmp);
-	rc = dt_declare_insert(env, fld->lsf_obj, (struct dt_rec *)tmp,
-			       (struct dt_key *)&tmp->lsr_start, th);
-out:
-	RETURN(rc);
-}
-
-/**
- * insert range in fld store.
- *
- *      \param  range  range to be inserted
- *      \param  th     transaction for this operation as it could compound
- *		     transaction.
- *
- *      \retval  0  success
- *      \retval  -ve error
- *
- * The whole fld index insertion is protected by seq->lss_mutex (see
- * seq_server_alloc_super), i.e. only one thread will access fldb each
- * time, so we do not need worry the fld file and cache will being
- * changed between declare and create.
- * Because the fld entry can only be increamental, so we will only check
- * whether it can be merged from the left.
- **/
-int fld_index_create(const struct lu_env *env, struct lu_server_fld *fld,
-		     const struct lu_seq_range *new_range, struct thandle *th)
-{
-	struct lu_seq_range	*range;
-	struct lu_seq_range	*tmp;
-	struct fld_thread_info	*info;
-	int			rc = 0;
-	int			deleted = 0;
-	struct fld_cache_entry	*flde;
-	ENTRY;
-
-	info = lu_context_key_get(&env->le_ctx, &fld_thread_key);
-
-	LASSERT(mutex_is_locked(&fld->lsf_lock));
-
-	range = &info->fti_lrange;
-	memset(range, 0, sizeof(*range));
-	tmp = &info->fti_irange;
-	rc = fld_index_lookup(env, fld, new_range->lsr_start, range);
-	if (rc != -ENOENT) {
-		rc = rc == 0 ? -EEXIST : rc;
-		GOTO(out, rc);
-	}
-
-	if (new_range->lsr_start == range->lsr_end && range->lsr_end != 0 &&
-	    range_compare_loc(new_range, range) == 0) {
-		range_cpu_to_be(tmp, range);
-		rc = dt_delete(env, fld->lsf_obj,
-			       (struct dt_key *)&tmp->lsr_start, th,
-				BYPASS_CAPA);
-		if (rc != 0)
-			GOTO(out, rc);
-		memcpy(tmp, new_range, sizeof(*new_range));
-		tmp->lsr_start = range->lsr_start;
-		deleted = 1;
-	} else {
-		memcpy(tmp, new_range, sizeof(*new_range));
-	}
-
-	range_cpu_to_be(tmp, tmp);
-	rc = dt_insert(env, fld->lsf_obj, (struct dt_rec *)tmp,
-		       (struct dt_key *)&tmp->lsr_start, th, BYPASS_CAPA, 1);
-	if (rc != 0) {
-		CERROR("%s: insert range "DRANGE" failed: rc = %d\n",
-		       fld->lsf_name, PRANGE(new_range), rc);
-		GOTO(out, rc);
-	}
-
-	flde = fld_cache_entry_create(new_range);
-	if (IS_ERR(flde))
-		GOTO(out, rc = PTR_ERR(flde));
-
-	write_lock(&fld->lsf_cache->fci_lock);
-	if (deleted)
-		fld_cache_delete_nolock(fld->lsf_cache, new_range);
-	rc = fld_cache_insert_nolock(fld->lsf_cache, flde);
-	write_unlock(&fld->lsf_cache->fci_lock);
-	if (rc)
-		OBD_FREE_PTR(flde);
-out:
-	RETURN(rc);
-}
-
-/**
- * lookup range for a seq passed. note here we only care about the start/end,
- * caller should handle the attached location data (flags, index).
- *
- * \param  seq     seq for lookup.
- * \param  range   result of lookup.
- *
- * \retval  0	   found, \a range is the matched range;
- * \retval -ENOENT      not found, \a range is the left-side range;
- * \retval  -ve	 other error;
- */
-int fld_index_lookup(const struct lu_env *env, struct lu_server_fld *fld,
-		     seqno_t seq, struct lu_seq_range *range)
-{
-	struct lu_seq_range     *fld_rec;
-	struct fld_thread_info  *info;
-	int rc;
-
-	ENTRY;
-
-	info = lu_context_key_get(&env->le_ctx, &fld_thread_key);
-	fld_rec = &info->fti_rec;
-
-	rc = fld_cache_lookup(fld->lsf_cache, seq, fld_rec);
-	if (rc == 0) {
-		*range = *fld_rec;
-		if (range_within(range, seq))
-			rc = 0;
-		else
-			rc = -ENOENT;
-	}
-
-	CDEBUG(D_INFO, "%s: lookup seq = "LPX64" range : "DRANGE" rc = %d\n",
-	       fld->lsf_name, seq, PRANGE(range), rc);
-
-	RETURN(rc);
-}
-
-int fld_insert_entry(const struct lu_env *env,
-		     struct lu_server_fld *fld,
-		     const struct lu_seq_range *range)
-{
-	struct thandle *th;
-	int rc;
-	ENTRY;
-
-	th = dt_trans_create(env, lu2dt_dev(fld->lsf_obj->do_lu.lo_dev));
-	if (IS_ERR(th))
-		RETURN(PTR_ERR(th));
-
-	rc = fld_declare_index_create(env, fld, range, th);
-	if (rc != 0) {
-		if (rc == -EEXIST)
-			rc = 0;
-		GOTO(out, rc);
-	}
-
-	rc = dt_trans_start_local(env, lu2dt_dev(fld->lsf_obj->do_lu.lo_dev),
-				  th);
-	if (rc)
-		GOTO(out, rc);
-
-	rc = fld_index_create(env, fld, range, th);
-	if (rc == -EEXIST)
-		rc = 0;
-out:
-	dt_trans_stop(env, lu2dt_dev(fld->lsf_obj->do_lu.lo_dev), th);
-	RETURN(rc);
-}
-EXPORT_SYMBOL(fld_insert_entry);
-
-static int fld_insert_special_entries(const struct lu_env *env,
-				      struct lu_server_fld *fld)
-{
-	int rc;
-
-	rc = fld_insert_entry(env, fld, &IGIF_FLD_RANGE);
-	if (rc != 0)
-		RETURN(rc);
-
-	rc = fld_insert_entry(env, fld, &DOT_LUSTRE_FLD_RANGE);
-	if (rc != 0)
-		RETURN(rc);
-
-	rc = fld_insert_entry(env, fld, &ROOT_FLD_RANGE);
-
-	RETURN(rc);
-}
-
-int fld_index_init(const struct lu_env *env, struct lu_server_fld *fld,
-		   struct dt_device *dt)
-{
-	struct dt_object	*dt_obj = NULL;
-	struct lu_fid		fid;
-	struct lu_attr		*attr = NULL;
-	struct lu_seq_range	*range = NULL;
-	struct fld_thread_info	*info;
-	struct dt_object_format	dof;
-	struct dt_it		*it;
-	const struct dt_it_ops	*iops;
-	int			rc;
-	ENTRY;
-
-	info = lu_context_key_get(&env->le_ctx, &fld_thread_key);
-	LASSERT(info != NULL);
-
-	lu_local_obj_fid(&fid, FLD_INDEX_OID);
-	OBD_ALLOC_PTR(attr);
-	if (attr == NULL)
-		RETURN(-ENOMEM);
-
-	memset(attr, 0, sizeof(*attr));
-	attr->la_valid = LA_MODE;
-	attr->la_mode = S_IFREG | 0666;
-	dof.dof_type = DFT_INDEX;
-	dof.u.dof_idx.di_feat = &fld_index_features;
-
-	dt_obj = dt_find_or_create(env, dt, &fid, &dof, attr);
-	if (IS_ERR(dt_obj)) {
-		rc = PTR_ERR(dt_obj);
-		CERROR("%s: Can't find \"%s\" obj %d\n", fld->lsf_name,
-			fld_index_name, rc);
-		dt_obj = NULL;
-		GOTO(out, rc);
-	}
-
-	fld->lsf_obj = dt_obj;
-	rc = dt_obj->do_ops->do_index_try(env, dt_obj, &fld_index_features);
-	if (rc != 0) {
-		CERROR("%s: File \"%s\" is not an index: rc = %d!\n",
-		       fld->lsf_name, fld_index_name, rc);
-		GOTO(out, rc);
-	}
-
-	range = &info->fti_rec;
-	/* Load fld entry to cache */
-	iops = &dt_obj->do_index_ops->dio_it;
-	it = iops->init(env, dt_obj, 0, NULL);
-	if (IS_ERR(it))
-		GOTO(out, rc = PTR_ERR(it));
-
-	rc = iops->load(env, it, 0);
-	if (rc < 0)
-		GOTO(out_it_fini, rc);
-
-	if (rc > 0) {
-		/* Load FLD entry into server cache */
-		do {
-			rc = iops->rec(env, it, (struct dt_rec *)range, 0);
-			if (rc != 0)
-				GOTO(out_it_put, rc);
-			LASSERT(range != NULL);
-			range_be_to_cpu(range, range);
-			rc = fld_cache_insert(fld->lsf_cache, range);
-			if (rc != 0)
-				GOTO(out_it_put, rc);
-			rc = iops->next(env, it);
-		} while (rc == 0);
-	}
-
-	/* Note: fld_insert_entry will detect whether these
-	 * special entries already exist inside FLDB */
-	mutex_lock(&fld->lsf_lock);
-	rc = fld_insert_special_entries(env, fld);
-	mutex_unlock(&fld->lsf_lock);
-	if (rc != 0) {
-		CERROR("%s: insert special entries failed!: rc = %d\n",
-		       fld->lsf_name, rc);
-		GOTO(out_it_put, rc);
-	}
-
-out_it_put:
-	iops->put(env, it);
-out_it_fini:
-	iops->fini(env, it);
-out:
-	if (attr != NULL)
-		OBD_FREE_PTR(attr);
-
-	if (rc != 0) {
-		if (dt_obj != NULL)
-			lu_object_put(env, &dt_obj->do_lu);
-		fld->lsf_obj = NULL;
-	}
-	RETURN(rc);
-}
-
-void fld_index_fini(const struct lu_env *env, struct lu_server_fld *fld)
-{
-	ENTRY;
-	if (fld->lsf_obj != NULL) {
-		if (!IS_ERR(fld->lsf_obj))
-			lu_object_put(env, &fld->lsf_obj->do_lu);
-		fld->lsf_obj = NULL;
-	}
-	EXIT;
-}
diff --git a/drivers/staging/lustre/lustre/fld/fld_internal.h b/drivers/staging/lustre/lustre/fld/fld_internal.h
index 9fa9e01..6e7ca9e 100644
--- a/drivers/staging/lustre/lustre/fld/fld_internal.h
+++ b/drivers/staging/lustre/lustre/fld/fld_internal.h
@@ -139,38 +139,10 @@ enum {
 
 extern struct lu_fld_hash fld_hash[];
 
-
-struct fld_thread_info {
-	struct req_capsule *fti_pill;
-	__u64	       fti_key;
-	struct lu_seq_range fti_rec;
-	struct lu_seq_range fti_lrange;
-	struct lu_seq_range fti_irange;
-};
-
-extern struct lu_context_key fld_thread_key;
-
-int fld_index_init(const struct lu_env *env, struct lu_server_fld *fld,
-		   struct dt_device *dt);
-
-void fld_index_fini(const struct lu_env *env, struct lu_server_fld *fld);
-
-int fld_declare_index_create(const struct lu_env *env,
-			     struct lu_server_fld *fld,
-			     const struct lu_seq_range *new,
-			     struct thandle *th);
-
-int fld_index_create(const struct lu_env *env, struct lu_server_fld *fld,
-		     const struct lu_seq_range *new, struct thandle *th);
-
-int fld_index_lookup(const struct lu_env *env, struct lu_server_fld *fld,
-		     seqno_t seq, struct lu_seq_range *range);
-
 int fld_client_rpc(struct obd_export *exp,
 		   struct lu_seq_range *range, __u32 fld_op);
 
 #ifdef LPROCFS
-extern struct lprocfs_vars fld_server_proc_list[];
 extern struct lprocfs_vars fld_client_proc_list[];
 #endif
 
@@ -219,5 +191,4 @@ fld_target_name(struct lu_fld_target *tar)
 }
 
 extern proc_dir_entry_t *fld_type_proc_dir;
-extern struct file_operations fld_proc_seq_fops;
 #endif /* __FLD_INTERNAL_H */
diff --git a/drivers/staging/lustre/lustre/fld/fld_request.c b/drivers/staging/lustre/lustre/fld/fld_request.c
index e9f0739..c99b945 100644
--- a/drivers/staging/lustre/lustre/fld/fld_request.c
+++ b/drivers/staging/lustre/lustre/fld/fld_request.c
@@ -60,6 +60,8 @@
 #include <lustre_mdc.h>
 #include "fld_internal.h"
 
+struct lu_context_key fld_thread_key;
+
 /* TODO: these 3 functions are copies of flow-control code from mdc_lib.c
  * It should be common thing. The same about mdc RPC lock */
 static int fld_req_avail(struct client_obd *cli, struct mdc_cache_waiter *mcw)
@@ -280,6 +282,8 @@ int fld_client_del_target(struct lu_client_fld *fld, __u64 idx)
 EXPORT_SYMBOL(fld_client_del_target);
 
 #ifdef LPROCFS
+proc_dir_entry_t *fld_type_proc_dir = NULL;
+
 static int fld_client_proc_init(struct lu_client_fld *fld)
 {
 	int rc;
@@ -496,12 +500,7 @@ int fld_client_lookup(struct lu_client_fld *fld, seqno_t seq, mdsno_t *mds,
 
 	res.lsr_start = seq;
 	fld_range_set_type(&res, flags);
-	if (target->ft_srv != NULL) {
-		LASSERT(env != NULL);
-		rc = fld_server_lookup(env, target->ft_srv, seq, &res);
-	} else {
-		rc = fld_client_rpc(target->ft_exp, &res, FLD_LOOKUP);
-	}
+	rc = fld_client_rpc(target->ft_exp, &res, FLD_LOOKUP);
 
 	if (rc == 0) {
 		*mds = res.lsr_index;
@@ -517,3 +516,32 @@ void fld_client_flush(struct lu_client_fld *fld)
 	fld_cache_flush(fld->lcf_cache);
 }
 EXPORT_SYMBOL(fld_client_flush);
+
+static int __init fld_mod_init(void)
+{
+	fld_type_proc_dir = lprocfs_register(LUSTRE_FLD_NAME,
+					     proc_lustre_root,
+					     NULL, NULL);
+	if (IS_ERR(fld_type_proc_dir))
+		return PTR_ERR(fld_type_proc_dir);
+
+	LU_CONTEXT_KEY_INIT(&fld_thread_key);
+	lu_context_key_register(&fld_thread_key);
+	return 0;
+}
+
+static void __exit fld_mod_exit(void)
+{
+	lu_context_key_degister(&fld_thread_key);
+	if (fld_type_proc_dir != NULL && !IS_ERR(fld_type_proc_dir)) {
+		lprocfs_remove(&fld_type_proc_dir);
+		fld_type_proc_dir = NULL;
+	}
+}
+
+MODULE_AUTHOR("Sun Microsystems, Inc. <http://www.lustre.org/>");
+MODULE_DESCRIPTION("Lustre FLD");
+MODULE_LICENSE("GPL");
+
+module_init(fld_mod_init)
+module_exit(fld_mod_exit)
diff --git a/drivers/staging/lustre/lustre/fld/lproc_fld.c b/drivers/staging/lustre/lustre/fld/lproc_fld.c
index c1bd803..77322ba 100644
--- a/drivers/staging/lustre/lustre/fld/lproc_fld.c
+++ b/drivers/staging/lustre/lustre/fld/lproc_fld.c
@@ -158,202 +158,6 @@ struct file_operations fld_proc_cache_flush_fops = {
 	.release	= fld_proc_cache_flush_release,
 };
 
-struct fld_seq_param {
-	struct lu_env		fsp_env;
-	struct dt_it		*fsp_it;
-	struct lu_server_fld	*fsp_fld;
-	unsigned int		fsp_stop:1;
-};
-
-static void *fldb_seq_start(struct seq_file *p, loff_t *pos)
-{
-	struct fld_seq_param    *param = p->private;
-	struct lu_server_fld    *fld;
-	struct dt_object	*obj;
-	const struct dt_it_ops  *iops;
-
-	if (param == NULL || param->fsp_stop)
-		return NULL;
-
-	fld = param->fsp_fld;
-	obj = fld->lsf_obj;
-	LASSERT(obj != NULL);
-	iops = &obj->do_index_ops->dio_it;
-
-	iops->load(&param->fsp_env, param->fsp_it, *pos);
-
-	*pos = be64_to_cpu(*(__u64 *)iops->key(&param->fsp_env, param->fsp_it));
-	return param;
-}
-
-static void fldb_seq_stop(struct seq_file *p, void *v)
-{
-	struct fld_seq_param    *param = p->private;
-	const struct dt_it_ops	*iops;
-	struct lu_server_fld	*fld;
-	struct dt_object	*obj;
-
-	if (param == NULL)
-		return;
-
-	fld = param->fsp_fld;
-	obj = fld->lsf_obj;
-	LASSERT(obj != NULL);
-	iops = &obj->do_index_ops->dio_it;
-
-	iops->put(&param->fsp_env, param->fsp_it);
-}
-
-static void *fldb_seq_next(struct seq_file *p, void *v, loff_t *pos)
-{
-	struct fld_seq_param    *param = p->private;
-	struct lu_server_fld	*fld;
-	struct dt_object	*obj;
-	const struct dt_it_ops	*iops;
-	int			rc;
-
-	if (param == NULL || param->fsp_stop)
-		return NULL;
-
-	fld = param->fsp_fld;
-	obj = fld->lsf_obj;
-	LASSERT(obj != NULL);
-	iops = &obj->do_index_ops->dio_it;
-
-	rc = iops->next(&param->fsp_env, param->fsp_it);
-	if (rc > 0) {
-		param->fsp_stop = 1;
-		return NULL;
-	}
-
-	*pos = be64_to_cpu(*(__u64 *)iops->key(&param->fsp_env, param->fsp_it));
-	return param;
-}
-
-static int fldb_seq_show(struct seq_file *p, void *v)
-{
-	struct fld_seq_param    *param = p->private;
-	struct lu_server_fld	*fld;
-	struct dt_object	*obj;
-	const struct dt_it_ops	*iops;
-	struct fld_thread_info	*info;
-	struct lu_seq_range	*fld_rec;
-	int			rc;
-
-	if (param == NULL || param->fsp_stop)
-		return 0;
-
-	fld = param->fsp_fld;
-	obj = fld->lsf_obj;
-	LASSERT(obj != NULL);
-	iops = &obj->do_index_ops->dio_it;
-
-	info = lu_context_key_get(&param->fsp_env.le_ctx,
-				  &fld_thread_key);
-	fld_rec = &info->fti_rec;
-	rc = iops->rec(&param->fsp_env, param->fsp_it,
-		       (struct dt_rec *)fld_rec, 0);
-	if (rc != 0) {
-		CERROR("%s:read record error: rc %d\n",
-		       fld->lsf_name, rc);
-	} else if (fld_rec->lsr_start != 0) {
-		range_be_to_cpu(fld_rec, fld_rec);
-		rc = seq_printf(p, DRANGE"\n", PRANGE(fld_rec));
-	}
-
-	return rc;
-}
-
-struct seq_operations fldb_sops = {
-	.start = fldb_seq_start,
-	.stop = fldb_seq_stop,
-	.next = fldb_seq_next,
-	.show = fldb_seq_show,
-};
-
-static int fldb_seq_open(struct inode *inode, struct file *file)
-{
-	struct seq_file		*seq;
-	struct lu_server_fld    *fld = (struct lu_server_fld *)PDE_DATA(inode);
-	struct dt_object	*obj;
-	const struct dt_it_ops  *iops;
-	struct fld_seq_param    *param = NULL;
-	int			env_init = 0;
-	int			rc;
-
-	rc = seq_open(file, &fldb_sops);
-	if (rc)
-		GOTO(out, rc);
-
-	obj = fld->lsf_obj;
-	if (obj == NULL) {
-		seq = file->private_data;
-		seq->private = NULL;
-		return 0;
-	}
-
-	OBD_ALLOC_PTR(param);
-	if (param == NULL)
-		GOTO(out, rc = -ENOMEM);
-
-	rc = lu_env_init(&param->fsp_env, LCT_MD_THREAD);
-	if (rc != 0)
-		GOTO(out, rc);
-
-	env_init = 1;
-	iops = &obj->do_index_ops->dio_it;
-	param->fsp_it = iops->init(&param->fsp_env, obj, 0, NULL);
-	if (IS_ERR(param->fsp_it))
-		GOTO(out, rc = PTR_ERR(param->fsp_it));
-
-	param->fsp_fld = fld;
-	param->fsp_stop = 0;
-
-	seq = file->private_data;
-	seq->private = param;
-out:
-	if (rc != 0) {
-		if (env_init == 1)
-			lu_env_fini(&param->fsp_env);
-		if (param != NULL)
-			OBD_FREE_PTR(param);
-	}
-	return rc;
-}
-
-static int fldb_seq_release(struct inode *inode, struct file *file)
-{
-	struct seq_file		*seq = file->private_data;
-	struct fld_seq_param	*param;
-	struct lu_server_fld	*fld;
-	struct dt_object	*obj;
-	const struct dt_it_ops	*iops;
-
-	param = seq->private;
-	if (param == NULL) {
-		lprocfs_seq_release(inode, file);
-		return 0;
-	}
-
-	fld = param->fsp_fld;
-	obj = fld->lsf_obj;
-	LASSERT(obj != NULL);
-	iops = &obj->do_index_ops->dio_it;
-
-	LASSERT(iops != NULL);
-	LASSERT(obj != NULL);
-	LASSERT(param->fsp_it != NULL);
-	iops->fini(&param->fsp_env, param->fsp_it);
-	lu_env_fini(&param->fsp_env);
-	OBD_FREE_PTR(param);
-	lprocfs_seq_release(inode, file);
-
-	return 0;
-}
-
-struct lprocfs_vars fld_server_proc_list[] = {
-	{ NULL }};
-
 LPROC_SEQ_FOPS_RO(fld_proc_targets);
 LPROC_SEQ_FOPS(fld_proc_hash);
 
@@ -363,11 +167,4 @@ struct lprocfs_vars fld_client_proc_list[] = {
 	{ "cache_flush", &fld_proc_cache_flush_fops },
 	{ NULL }};
 
-struct file_operations fld_proc_seq_fops = {
-	.owner   = THIS_MODULE,
-	.open    = fldb_seq_open,
-	.read    = seq_read,
-	.release = fldb_seq_release,
-};
-
-#endif
+#endif /* LPROCFS */
diff --git a/drivers/staging/lustre/lustre/include/lustre_fld.h b/drivers/staging/lustre/lustre/include/lustre_fld.h
index 11e034a..94b697d 100644
--- a/drivers/staging/lustre/lustre/include/lustre_fld.h
+++ b/drivers/staging/lustre/lustre/include/lustre_fld.h
@@ -43,9 +43,6 @@
  */
 
 #include <lustre/lustre_idl.h>
-#include <lustre_mdt.h>
-#include <dt_object.h>
-
 #include <linux/libcfs/libcfs.h>
 
 struct lu_client_fld;
@@ -129,47 +126,9 @@ struct lu_client_fld {
 	 * Client fld proc entry name. */
 	char		     lcf_name[80];
 
-	const struct lu_context *lcf_ctx;
-
 	int		      lcf_flags;
 };
 
-/**
- * number of blocks to reserve for particular operations. Should be function of
- * ... something. Stub for now.
- */
-enum {
-	/* one insert operation can involve two delete and one insert */
-	FLD_TXN_INDEX_INSERT_CREDITS  = 60,
-	FLD_TXN_INDEX_DELETE_CREDITS  = 20,
-};
-
-int fld_query(struct com_thread_info *info);
-
-/* Server methods */
-int fld_server_init(const struct lu_env *env, struct lu_server_fld *fld,
-		    struct dt_device *dt, const char *prefix, int mds_node_id,
-		    int type);
-
-void fld_server_fini(const struct lu_env *env, struct lu_server_fld *fld);
-
-int fld_declare_server_create(const struct lu_env *env,
-			      struct lu_server_fld *fld,
-			      struct lu_seq_range *new,
-			      struct thandle *th);
-
-int fld_server_create(const struct lu_env *env,
-		      struct lu_server_fld *fld,
-		      struct lu_seq_range *add_range,
-		      struct thandle *th);
-
-int fld_insert_entry(const struct lu_env *env,
-		     struct lu_server_fld *fld,
-		     const struct lu_seq_range *range);
-
-int fld_server_lookup(const struct lu_env *env, struct lu_server_fld *fld,
-		      seqno_t seq, struct lu_seq_range *range);
-
 /* Client methods */
 int fld_client_init(struct lu_client_fld *fld,
 		    const char *prefix, int hash);
diff --git a/drivers/staging/lustre/lustre/include/lustre_mdt.h b/drivers/staging/lustre/lustre/include/lustre_mdt.h
deleted file mode 100644
index dba26a6..0000000
--- a/drivers/staging/lustre/lustre/include/lustre_mdt.h
+++ /dev/null
@@ -1,84 +0,0 @@
-/*
- * GPL HEADER START
- *
- * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 only,
- * as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License version 2 for more details (a copy is included
- * in the LICENSE file that accompanied this code).
- *
- * You should have received a copy of the GNU General Public License
- * version 2 along with this program; If not, see
- * http://www.sun.com/software/products/lustre/docs/GPLv2.pdf
- *
- * Please contact Sun Microsystems, Inc., 4150 Network Circle, Santa Clara,
- * CA 95054 USA or visit www.sun.com if you need additional information or
- * have any questions.
- *
- * GPL HEADER END
- */
-/*
- * Copyright (c) 2007, 2010, Oracle and/or its affiliates. All rights reserved.
- * Use is subject to license terms.
- */
-/*
- * This file is part of Lustre, http://www.lustre.org/
- * Lustre is a trademark of Sun Microsystems, Inc.
- */
-
-#ifndef __LINUX_MDT_H
-#define __LINUX_MDT_H
-
-/** \defgroup mdt mdt
- *
- * @{
- */
-
-#include <lustre/lustre_idl.h>
-#include <lustre_req_layout.h>
-#include <md_object.h>
-#include <dt_object.h>
-#include <linux/libcfs/libcfs.h>
-
-/*
- * Common thread info for mdt, seq and fld
- */
-struct com_thread_info {
-	/*
-	 * for req-layout interface.
-	 */
-	struct req_capsule *cti_pill;
-};
-
-enum {
-	ESERIOUS = 0x0001000
-};
-
-static inline int err_serious(int rc)
-{
-	LASSERT(rc < 0);
-	LASSERT(-rc < ESERIOUS);
-	return -(-rc | ESERIOUS);
-}
-
-static inline int clear_serious(int rc)
-{
-	if (rc < 0)
-		rc = -(-rc & ~ESERIOUS);
-	return rc;
-}
-
-static inline int is_serious(int rc)
-{
-	return (rc < 0 && -rc & ESERIOUS);
-}
-
-/** @} mdt */
-
-#endif
diff --git a/drivers/staging/lustre/lustre/obdecho/echo_client.c b/drivers/staging/lustre/lustre/obdecho/echo_client.c
index ae89ea6f..de8f4ea 100644
--- a/drivers/staging/lustre/lustre/obdecho/echo_client.c
+++ b/drivers/staging/lustre/lustre/obdecho/echo_client.c
@@ -43,6 +43,7 @@
 #include <lustre_debug.h>
 #include <lprocfs_status.h>
 #include <cl_object.h>
+#include <md_object.h>
 #include <lustre_fid.h>
 #include <lustre_acl.h>
 #include <lustre_net.h>
-- 
1.7.9.5

