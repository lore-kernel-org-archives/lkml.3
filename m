Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932825Ab3GVQLt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:11:49 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:47587 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932634Ab3GVQLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:11:44 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Liu Xuezhao <xuezhao.liu@emc.com>,
        "John L. Hammond" <john.hammond@intel.com>,
        Peng Tao <tao.peng@emc.com>, Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 23/48] staging/lustre/fid: prepare FID module for client server split
Date: Tue, 23 Jul 2013 00:06:44 +0800
Message-Id: <1374509230-3324-24-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
References: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Xuezhao <xuezhao.liu@emc.com>

Split FID server from client, fid_{handler,store,lib}.c are not
compliled unless server support is enabled.  Generally cleanup
includes in lustre/fid/ and reduce the need for client code to
directly or indirectly include {dt,md}_object.h.

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-1330
Lustre-change: http://review.whamcloud.com/2673
Signed-off-by: Liu Xuezhao <xuezhao.liu@emc.com>
Signed-off-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: Nathaniel Clark <nathaniel.l.clark@intel.com>
Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/fid/Makefile         |    2 +-
 drivers/staging/lustre/lustre/fid/fid_handler.c    |  661 --------------------
 drivers/staging/lustre/lustre/fid/fid_internal.h   |   36 +-
 drivers/staging/lustre/lustre/fid/fid_lib.c        |   14 +-
 drivers/staging/lustre/lustre/fid/fid_request.c    |  133 ++--
 drivers/staging/lustre/lustre/fid/fid_store.c      |  259 --------
 drivers/staging/lustre/lustre/fid/lproc_fid.c      |    3 -
 drivers/staging/lustre/lustre/include/lu_object.h  |    5 +
 drivers/staging/lustre/lustre/include/lustre_fid.h |   24 +-
 drivers/staging/lustre/lustre/include/md_object.h  |    5 -
 drivers/staging/lustre/lustre/include/obd.h        |    7 +-
 11 files changed, 131 insertions(+), 1018 deletions(-)
 delete mode 100644 drivers/staging/lustre/lustre/fid/fid_handler.c
 delete mode 100644 drivers/staging/lustre/lustre/fid/fid_store.c

diff --git a/drivers/staging/lustre/lustre/fid/Makefile b/drivers/staging/lustre/lustre/fid/Makefile
index b8d6d21..ed21bea 100644
--- a/drivers/staging/lustre/lustre/fid/Makefile
+++ b/drivers/staging/lustre/lustre/fid/Makefile
@@ -1,5 +1,5 @@
 obj-$(CONFIG_LUSTRE_FS) += fid.o
-fid-y := fid_handler.o fid_store.o fid_request.o lproc_fid.o fid_lib.o
+fid-y := fid_request.o lproc_fid.o fid_lib.o
 
 
 ccflags-y := -I$(src)/../include
diff --git a/drivers/staging/lustre/lustre/fid/fid_handler.c b/drivers/staging/lustre/lustre/fid/fid_handler.c
deleted file mode 100644
index bbbb3cf..0000000
--- a/drivers/staging/lustre/lustre/fid/fid_handler.c
+++ /dev/null
@@ -1,661 +0,0 @@
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
- * Copyright (c) 2011, 2012, Intel Corporation.
- */
-/*
- * This file is part of Lustre, http://www.lustre.org/
- * Lustre is a trademark of Sun Microsystems, Inc.
- *
- * lustre/fid/fid_handler.c
- *
- * Lustre Sequence Manager
- *
- * Author: Yury Umanets <umka@clusterfs.com>
- */
-
-#define DEBUG_SUBSYSTEM S_FID
-
-# include <linux/libcfs/libcfs.h>
-# include <linux/module.h>
-
-#include <obd.h>
-#include <obd_class.h>
-#include <dt_object.h>
-#include <md_object.h>
-#include <obd_support.h>
-#include <lustre_req_layout.h>
-#include <lustre_fid.h>
-#include "fid_internal.h"
-
-int client_fid_init(struct obd_device *obd,
-		    struct obd_export *exp, enum lu_cli_type type)
-{
-	struct client_obd *cli = &obd->u.cli;
-	char *prefix;
-	int rc;
-	ENTRY;
-
-	OBD_ALLOC_PTR(cli->cl_seq);
-	if (cli->cl_seq == NULL)
-		RETURN(-ENOMEM);
-
-	OBD_ALLOC(prefix, MAX_OBD_NAME + 5);
-	if (prefix == NULL)
-		GOTO(out_free_seq, rc = -ENOMEM);
-
-	snprintf(prefix, MAX_OBD_NAME + 5, "cli-%s", obd->obd_name);
-
-	/* Init client side sequence-manager */
-	rc = seq_client_init(cli->cl_seq, exp, type, prefix, NULL);
-	OBD_FREE(prefix, MAX_OBD_NAME + 5);
-	if (rc)
-		GOTO(out_free_seq, rc);
-
-	RETURN(rc);
-out_free_seq:
-	OBD_FREE_PTR(cli->cl_seq);
-	cli->cl_seq = NULL;
-	return rc;
-}
-EXPORT_SYMBOL(client_fid_init);
-
-int client_fid_fini(struct obd_device *obd)
-{
-	struct client_obd *cli = &obd->u.cli;
-	ENTRY;
-
-	if (cli->cl_seq != NULL) {
-		seq_client_fini(cli->cl_seq);
-		OBD_FREE_PTR(cli->cl_seq);
-		cli->cl_seq = NULL;
-	}
-
-	RETURN(0);
-}
-EXPORT_SYMBOL(client_fid_fini);
-
-static void seq_server_proc_fini(struct lu_server_seq *seq);
-
-/* Assigns client to sequence controller node. */
-int seq_server_set_cli(struct lu_server_seq *seq,
-		       struct lu_client_seq *cli,
-		       const struct lu_env *env)
-{
-	int rc = 0;
-	ENTRY;
-
-	/*
-	 * Ask client for new range, assign that range to ->seq_space and write
-	 * seq state to backing store should be atomic.
-	 */
-	mutex_lock(&seq->lss_mutex);
-
-	if (cli == NULL) {
-		CDEBUG(D_INFO, "%s: Detached sequence client %s\n",
-		       seq->lss_name, cli->lcs_name);
-		seq->lss_cli = cli;
-		GOTO(out_up, rc = 0);
-	}
-
-	if (seq->lss_cli != NULL) {
-		CDEBUG(D_HA, "%s: Sequence controller is already "
-		       "assigned\n", seq->lss_name);
-		GOTO(out_up, rc = -EEXIST);
-	}
-
-	CDEBUG(D_INFO, "%s: Attached sequence controller %s\n",
-	       seq->lss_name, cli->lcs_name);
-
-	seq->lss_cli = cli;
-	cli->lcs_space.lsr_index = seq->lss_site->ss_node_id;
-	EXIT;
-out_up:
-	mutex_unlock(&seq->lss_mutex);
-	return rc;
-}
-EXPORT_SYMBOL(seq_server_set_cli);
-/*
- * allocate \a w units of sequence from range \a from.
- */
-static inline void range_alloc(struct lu_seq_range *to,
-			       struct lu_seq_range *from,
-			       __u64 width)
-{
-	width = min(range_space(from), width);
-	to->lsr_start = from->lsr_start;
-	to->lsr_end = from->lsr_start + width;
-	from->lsr_start += width;
-}
-
-/**
- * On controller node, allocate new super sequence for regular sequence server.
- * As this super sequence controller, this node suppose to maintain fld
- * and update index.
- * \a out range always has currect mds node number of requester.
- */
-
-static int __seq_server_alloc_super(struct lu_server_seq *seq,
-				    struct lu_seq_range *out,
-				    const struct lu_env *env)
-{
-	struct lu_seq_range *space = &seq->lss_space;
-	int rc;
-	ENTRY;
-
-	LASSERT(range_is_sane(space));
-
-	if (range_is_exhausted(space)) {
-		CERROR("%s: Sequences space is exhausted\n",
-		       seq->lss_name);
-		RETURN(-ENOSPC);
-	} else {
-		range_alloc(out, space, seq->lss_width);
-	}
-
-	rc = seq_store_update(env, seq, out, 1 /* sync */);
-
-	LCONSOLE_INFO("%s: super-sequence allocation rc = %d " DRANGE"\n",
-		      seq->lss_name, rc, PRANGE(out));
-
-	RETURN(rc);
-}
-
-int seq_server_alloc_super(struct lu_server_seq *seq,
-			   struct lu_seq_range *out,
-			   const struct lu_env *env)
-{
-	int rc;
-	ENTRY;
-
-	mutex_lock(&seq->lss_mutex);
-	rc = __seq_server_alloc_super(seq, out, env);
-	mutex_unlock(&seq->lss_mutex);
-
-	RETURN(rc);
-}
-
-static int __seq_set_init(const struct lu_env *env,
-			    struct lu_server_seq *seq)
-{
-	struct lu_seq_range *space = &seq->lss_space;
-	int rc;
-
-	range_alloc(&seq->lss_lowater_set, space, seq->lss_set_width);
-	range_alloc(&seq->lss_hiwater_set, space, seq->lss_set_width);
-
-	rc = seq_store_update(env, seq, NULL, 1);
-
-	return rc;
-}
-
-/*
- * This function implements new seq allocation algorithm using async
- * updates to seq file on disk. ref bug 18857 for details.
- * there are four variable to keep track of this process
- *
- * lss_space; - available lss_space
- * lss_lowater_set; - lu_seq_range for all seqs before barrier, i.e. safe to use
- * lss_hiwater_set; - lu_seq_range after barrier, i.e. allocated but may be
- *		    not yet committed
- *
- * when lss_lowater_set reaches the end it is replaced with hiwater one and
- * a write operation is initiated to allocate new hiwater range.
- * if last seq write opearion is still not commited, current operation is
- * flaged as sync write op.
- */
-static int range_alloc_set(const struct lu_env *env,
-			    struct lu_seq_range *out,
-			    struct lu_server_seq *seq)
-{
-	struct lu_seq_range *space = &seq->lss_space;
-	struct lu_seq_range *loset = &seq->lss_lowater_set;
-	struct lu_seq_range *hiset = &seq->lss_hiwater_set;
-	int rc = 0;
-
-	if (range_is_zero(loset))
-		__seq_set_init(env, seq);
-
-	if (OBD_FAIL_CHECK(OBD_FAIL_SEQ_ALLOC)) /* exhaust set */
-		loset->lsr_start = loset->lsr_end;
-
-	if (range_is_exhausted(loset)) {
-		/* reached high water mark. */
-		struct lu_device *dev = seq->lss_site->ss_lu->ls_top_dev;
-		int obd_num_clients = dev->ld_obd->obd_num_exports;
-		__u64 set_sz;
-
-		/* calculate new seq width based on number of clients */
-		set_sz = max(seq->lss_set_width,
-			     obd_num_clients * seq->lss_width);
-		set_sz = min(range_space(space), set_sz);
-
-		/* Switch to hiwater range now */
-		*loset = *hiset;
-		/* allocate new hiwater range */
-		range_alloc(hiset, space, set_sz);
-
-		/* update ondisk seq with new *space */
-		rc = seq_store_update(env, seq, NULL, seq->lss_need_sync);
-	}
-
-	LASSERTF(!range_is_exhausted(loset) || range_is_sane(loset),
-		 DRANGE"\n", PRANGE(loset));
-
-	if (rc == 0)
-		range_alloc(out, loset, seq->lss_width);
-
-	RETURN(rc);
-}
-
-static int __seq_server_alloc_meta(struct lu_server_seq *seq,
-				   struct lu_seq_range *out,
-				   const struct lu_env *env)
-{
-	struct lu_seq_range *space = &seq->lss_space;
-	int rc = 0;
-
-	ENTRY;
-
-	LASSERT(range_is_sane(space));
-
-	/* Check if available space ends and allocate new super seq */
-	if (range_is_exhausted(space)) {
-		if (!seq->lss_cli) {
-			CERROR("%s: No sequence controller is attached.\n",
-			       seq->lss_name);
-			RETURN(-ENODEV);
-		}
-
-		rc = seq_client_alloc_super(seq->lss_cli, env);
-		if (rc) {
-			CERROR("%s: Can't allocate super-sequence, rc %d\n",
-			       seq->lss_name, rc);
-			RETURN(rc);
-		}
-
-		/* Saving new range to allocation space. */
-		*space = seq->lss_cli->lcs_space;
-		LASSERT(range_is_sane(space));
-	}
-
-	rc = range_alloc_set(env, out, seq);
-	if (rc != 0) {
-		CERROR("%s: Allocated meta-sequence failed: rc = %d\n",
-			seq->lss_name, rc);
-		RETURN(rc);
-	}
-
-	CDEBUG(D_INFO, "%s: Allocated meta-sequence " DRANGE"\n",
-		seq->lss_name, PRANGE(out));
-
-	RETURN(rc);
-}
-
-int seq_server_alloc_meta(struct lu_server_seq *seq,
-			  struct lu_seq_range *out,
-			  const struct lu_env *env)
-{
-	int rc;
-	ENTRY;
-
-	mutex_lock(&seq->lss_mutex);
-	rc = __seq_server_alloc_meta(seq, out, env);
-	mutex_unlock(&seq->lss_mutex);
-
-	RETURN(rc);
-}
-EXPORT_SYMBOL(seq_server_alloc_meta);
-
-static int seq_server_handle(struct lu_site *site,
-			     const struct lu_env *env,
-			     __u32 opc, struct lu_seq_range *out)
-{
-	int rc;
-	struct seq_server_site *ss_site;
-	ENTRY;
-
-	ss_site = lu_site2seq(site);
-
-	switch (opc) {
-	case SEQ_ALLOC_META:
-		if (!ss_site->ss_server_seq) {
-			CERROR("Sequence server is not "
-			       "initialized\n");
-			RETURN(-EINVAL);
-		}
-		rc = seq_server_alloc_meta(ss_site->ss_server_seq, out, env);
-		break;
-	case SEQ_ALLOC_SUPER:
-		if (!ss_site->ss_control_seq) {
-			CERROR("Sequence controller is not "
-			       "initialized\n");
-			RETURN(-EINVAL);
-		}
-		rc = seq_server_alloc_super(ss_site->ss_control_seq, out, env);
-		break;
-	default:
-		rc = -EINVAL;
-		break;
-	}
-
-	RETURN(rc);
-}
-
-static int seq_req_handle(struct ptlrpc_request *req,
-			  const struct lu_env *env,
-			  struct seq_thread_info *info)
-{
-	struct lu_seq_range *out, *tmp;
-	struct lu_site *site;
-	int rc = -EPROTO;
-	__u32 *opc;
-	ENTRY;
-
-	LASSERT(!(lustre_msg_get_flags(req->rq_reqmsg) & MSG_REPLAY));
-	site = req->rq_export->exp_obd->obd_lu_dev->ld_site;
-	LASSERT(site != NULL);
-
-	rc = req_capsule_server_pack(info->sti_pill);
-	if (rc)
-		RETURN(err_serious(rc));
-
-	opc = req_capsule_client_get(info->sti_pill, &RMF_SEQ_OPC);
-	if (opc != NULL) {
-		out = req_capsule_server_get(info->sti_pill, &RMF_SEQ_RANGE);
-		if (out == NULL)
-			RETURN(err_serious(-EPROTO));
-
-		tmp = req_capsule_client_get(info->sti_pill, &RMF_SEQ_RANGE);
-
-		/* seq client passed mdt id, we need to pass that using out
-		 * range parameter */
-
-		out->lsr_index = tmp->lsr_index;
-		out->lsr_flags = tmp->lsr_flags;
-		rc = seq_server_handle(site, env, *opc, out);
-	} else
-		rc = err_serious(-EPROTO);
-
-	RETURN(rc);
-}
-
-/* context key constructor/destructor: seq_key_init, seq_key_fini */
-LU_KEY_INIT_FINI(seq, struct seq_thread_info);
-
-/* context key: seq_thread_key */
-LU_CONTEXT_KEY_DEFINE(seq, LCT_MD_THREAD | LCT_DT_THREAD);
-
-static void seq_thread_info_init(struct ptlrpc_request *req,
-				 struct seq_thread_info *info)
-{
-	info->sti_pill = &req->rq_pill;
-	/* Init request capsule */
-	req_capsule_init(info->sti_pill, req, RCL_SERVER);
-	req_capsule_set(info->sti_pill, &RQF_SEQ_QUERY);
-}
-
-static void seq_thread_info_fini(struct seq_thread_info *info)
-{
-	req_capsule_fini(info->sti_pill);
-}
-
-int seq_handle(struct ptlrpc_request *req)
-{
-	const struct lu_env *env;
-	struct seq_thread_info *info;
-	int rc;
-
-	env = req->rq_svc_thread->t_env;
-	LASSERT(env != NULL);
-
-	info = lu_context_key_get(&env->le_ctx, &seq_thread_key);
-	LASSERT(info != NULL);
-
-	seq_thread_info_init(req, info);
-	rc = seq_req_handle(req, env, info);
-	/* XXX: we don't need replay but MDT assign transno in any case,
-	 * remove it manually before reply*/
-	lustre_msg_set_transno(req->rq_repmsg, 0);
-	seq_thread_info_fini(info);
-
-	return rc;
-}
-EXPORT_SYMBOL(seq_handle);
-
-/*
- * Entry point for handling FLD RPCs called from MDT.
- */
-int seq_query(struct com_thread_info *info)
-{
-	return seq_handle(info->cti_pill->rc_req);
-}
-EXPORT_SYMBOL(seq_query);
-
-
-#ifdef LPROCFS
-static int seq_server_proc_init(struct lu_server_seq *seq)
-{
-	int rc;
-	ENTRY;
-
-	seq->lss_proc_dir = lprocfs_register(seq->lss_name,
-					     seq_type_proc_dir,
-					     NULL, NULL);
-	if (IS_ERR(seq->lss_proc_dir)) {
-		rc = PTR_ERR(seq->lss_proc_dir);
-		RETURN(rc);
-	}
-
-	rc = lprocfs_add_vars(seq->lss_proc_dir,
-			      seq_server_proc_list, seq);
-	if (rc) {
-		CERROR("%s: Can't init sequence manager "
-		       "proc, rc %d\n", seq->lss_name, rc);
-		GOTO(out_cleanup, rc);
-	}
-
-	RETURN(0);
-
-out_cleanup:
-	seq_server_proc_fini(seq);
-	return rc;
-}
-
-static void seq_server_proc_fini(struct lu_server_seq *seq)
-{
-	ENTRY;
-	if (seq->lss_proc_dir != NULL) {
-		if (!IS_ERR(seq->lss_proc_dir))
-			lprocfs_remove(&seq->lss_proc_dir);
-		seq->lss_proc_dir = NULL;
-	}
-	EXIT;
-}
-#else
-static int seq_server_proc_init(struct lu_server_seq *seq)
-{
-	return 0;
-}
-
-static void seq_server_proc_fini(struct lu_server_seq *seq)
-{
-	return;
-}
-#endif
-
-
-int seq_server_init(struct lu_server_seq *seq,
-		    struct dt_device *dev,
-		    const char *prefix,
-		    enum lu_mgr_type type,
-		    struct seq_server_site *ss,
-		    const struct lu_env *env)
-{
-	int rc, is_srv = (type == LUSTRE_SEQ_SERVER);
-	ENTRY;
-
-	LASSERT(dev != NULL);
-	LASSERT(prefix != NULL);
-	LASSERT(ss != NULL);
-	LASSERT(ss->ss_lu != NULL);
-
-	seq->lss_cli = NULL;
-	seq->lss_type = type;
-	seq->lss_site = ss;
-	range_init(&seq->lss_space);
-
-	range_init(&seq->lss_lowater_set);
-	range_init(&seq->lss_hiwater_set);
-	seq->lss_set_width = LUSTRE_SEQ_BATCH_WIDTH;
-
-	mutex_init(&seq->lss_mutex);
-
-	seq->lss_width = is_srv ?
-		LUSTRE_SEQ_META_WIDTH : LUSTRE_SEQ_SUPER_WIDTH;
-
-	snprintf(seq->lss_name, sizeof(seq->lss_name),
-		 "%s-%s", (is_srv ? "srv" : "ctl"), prefix);
-
-	rc = seq_store_init(seq, env, dev);
-	if (rc)
-		GOTO(out, rc);
-	/* Request backing store for saved sequence info. */
-	rc = seq_store_read(seq, env);
-	if (rc == -ENODATA) {
-
-		/* Nothing is read, init by default value. */
-		seq->lss_space = is_srv ?
-			LUSTRE_SEQ_ZERO_RANGE:
-			LUSTRE_SEQ_SPACE_RANGE;
-
-		LASSERT(ss != NULL);
-		seq->lss_space.lsr_index = ss->ss_node_id;
-		LCONSOLE_INFO("%s: No data found "
-			      "on store. Initialize space\n",
-			      seq->lss_name);
-
-		rc = seq_store_update(env, seq, NULL, 0);
-		if (rc) {
-			CERROR("%s: Can't write space data, "
-			       "rc %d\n", seq->lss_name, rc);
-		}
-	} else if (rc) {
-		CERROR("%s: Can't read space data, rc %d\n",
-		       seq->lss_name, rc);
-		GOTO(out, rc);
-	}
-
-	if (is_srv) {
-		LASSERT(range_is_sane(&seq->lss_space));
-	} else {
-		LASSERT(!range_is_zero(&seq->lss_space) &&
-			range_is_sane(&seq->lss_space));
-	}
-
-	rc  = seq_server_proc_init(seq);
-	if (rc)
-		GOTO(out, rc);
-
-	EXIT;
-out:
-	if (rc)
-		seq_server_fini(seq, env);
-	return rc;
-}
-EXPORT_SYMBOL(seq_server_init);
-
-void seq_server_fini(struct lu_server_seq *seq,
-		     const struct lu_env *env)
-{
-	ENTRY;
-
-	seq_server_proc_fini(seq);
-	seq_store_fini(seq, env);
-
-	EXIT;
-}
-EXPORT_SYMBOL(seq_server_fini);
-
-int seq_site_fini(const struct lu_env *env, struct seq_server_site *ss)
-{
-	if (ss == NULL)
-		RETURN(0);
-
-	if (ss->ss_server_seq) {
-		seq_server_fini(ss->ss_server_seq, env);
-		OBD_FREE_PTR(ss->ss_server_seq);
-		ss->ss_server_seq = NULL;
-	}
-
-	if (ss->ss_control_seq) {
-		seq_server_fini(ss->ss_control_seq, env);
-		OBD_FREE_PTR(ss->ss_control_seq);
-		ss->ss_control_seq = NULL;
-	}
-
-	if (ss->ss_client_seq) {
-		seq_client_fini(ss->ss_client_seq);
-		OBD_FREE_PTR(ss->ss_client_seq);
-		ss->ss_client_seq = NULL;
-	}
-
-	RETURN(0);
-}
-EXPORT_SYMBOL(seq_site_fini);
-
-proc_dir_entry_t *seq_type_proc_dir = NULL;
-
-static int __init fid_mod_init(void)
-{
-	seq_type_proc_dir = lprocfs_register(LUSTRE_SEQ_NAME,
-					     proc_lustre_root,
-					     NULL, NULL);
-	if (IS_ERR(seq_type_proc_dir))
-		return PTR_ERR(seq_type_proc_dir);
-
-	LU_CONTEXT_KEY_INIT(&seq_thread_key);
-	lu_context_key_register(&seq_thread_key);
-	return 0;
-}
-
-static void __exit fid_mod_exit(void)
-{
-	lu_context_key_degister(&seq_thread_key);
-	if (seq_type_proc_dir != NULL && !IS_ERR(seq_type_proc_dir)) {
-		lprocfs_remove(&seq_type_proc_dir);
-		seq_type_proc_dir = NULL;
-	}
-}
-
-MODULE_AUTHOR("Sun Microsystems, Inc. <http://www.lustre.org/>");
-MODULE_DESCRIPTION("Lustre FID Module");
-MODULE_LICENSE("GPL");
-
-cfs_module(fid, "0.1.0", fid_mod_init, fid_mod_exit);
diff --git a/drivers/staging/lustre/lustre/fid/fid_internal.h b/drivers/staging/lustre/lustre/fid/fid_internal.h
index 407a743..1dbe46b 100644
--- a/drivers/staging/lustre/lustre/fid/fid_internal.h
+++ b/drivers/staging/lustre/lustre/fid/fid_internal.h
@@ -41,44 +41,16 @@
 #define __FID_INTERNAL_H
 
 #include <lustre/lustre_idl.h>
-#include <dt_object.h>
-
 #include <linux/libcfs/libcfs.h>
 
-struct seq_thread_info {
-	struct req_capsule     *sti_pill;
-	struct lu_seq_range     sti_space;
-	struct lu_buf	   sti_buf;
-};
-
-enum {
-	SEQ_TXN_STORE_CREDITS = 20
-};
-
-extern struct lu_context_key seq_thread_key;
-
+/* Functions used internally in module. */
 int seq_client_alloc_super(struct lu_client_seq *seq,
 			   const struct lu_env *env);
-/* Store API functions. */
-int seq_store_init(struct lu_server_seq *seq,
-		   const struct lu_env *env,
-		   struct dt_device *dt);
 
-void seq_store_fini(struct lu_server_seq *seq,
-		    const struct lu_env *env);
-
-int seq_store_read(struct lu_server_seq *seq,
-		   const struct lu_env *env);
-
-int seq_store_update(const struct lu_env *env, struct lu_server_seq *seq,
-		     struct lu_seq_range *out, int sync);
-
-#ifdef LPROCFS
-extern struct lprocfs_vars seq_server_proc_list[];
+# ifdef LPROCFS
 extern struct lprocfs_vars seq_client_proc_list[];
-#endif
-
+# endif
 
-extern proc_dir_entry_t *seq_type_proc_dir;
+extern struct proc_dir_entry *seq_type_proc_dir;
 
 #endif /* __FID_INTERNAL_H */
diff --git a/drivers/staging/lustre/lustre/fid/fid_lib.c b/drivers/staging/lustre/lustre/fid/fid_lib.c
index eaff51a..f03afde 100644
--- a/drivers/staging/lustre/lustre/fid/fid_lib.c
+++ b/drivers/staging/lustre/lustre/fid/fid_lib.c
@@ -43,11 +43,9 @@
 
 #define DEBUG_SUBSYSTEM S_FID
 
-# include <linux/libcfs/libcfs.h>
-# include <linux/module.h>
-
-#include <obd.h>
-#include <lu_object.h>
+#include <linux/libcfs/libcfs.h>
+#include <linux/module.h>
+#include <lustre/lustre_idl.h>
 #include <lustre_fid.h>
 
 /**
@@ -56,9 +54,9 @@
  *
  * Fid namespace:
  * <pre>
- * Normal FID:	seq:64 [2^33,2^64-1]      oid:32	  ver:32
- * IGIF      :	0:32, ino:32	      gen:32	  0:32
- * IDIF      :	0:31, 1:1, ost-index:16,  objd:48	 0:32
+ * Normal FID:        seq:64 [2^33,2^64-1]      oid:32          ver:32
+ * IGIF      :        0:32, ino:32              gen:32          0:32
+ * IDIF      :        0:31, 1:1, ost-index:16,  objd:48         0:32
  * </pre>
  *
  * The first 0x400 sequences of normal FID are reserved for special purpose.
diff --git a/drivers/staging/lustre/lustre/fid/fid_request.c b/drivers/staging/lustre/lustre/fid/fid_request.c
index fcaaca7..a279b5a 100644
--- a/drivers/staging/lustre/lustre/fid/fid_request.c
+++ b/drivers/staging/lustre/lustre/fid/fid_request.c
@@ -27,7 +27,7 @@
  * Copyright (c) 2007, 2010, Oracle and/or its affiliates. All rights reserved.
  * Use is subject to license terms.
  *
- * Copyright (c) 2011, 2012, Intel Corporation.
+ * Copyright (c) 2011, 2013, Intel Corporation.
  */
 /*
  * This file is part of Lustre, http://www.lustre.org/
@@ -42,15 +42,12 @@
 
 #define DEBUG_SUBSYSTEM S_FID
 
-# include <linux/libcfs/libcfs.h>
-# include <linux/module.h>
+#include <linux/libcfs/libcfs.h>
+#include <linux/module.h>
 
 #include <obd.h>
 #include <obd_class.h>
-#include <dt_object.h>
-#include <md_object.h>
 #include <obd_support.h>
-#include <lustre_req_layout.h>
 #include <lustre_fid.h>
 /* mdc RPC locks */
 #include <lustre_mdc.h>
@@ -63,9 +60,9 @@ static int seq_client_rpc(struct lu_client_seq *seq,
 	struct obd_export     *exp = seq->lcs_exp;
 	struct ptlrpc_request *req;
 	struct lu_seq_range   *out, *in;
-	__u32		 *op;
-	unsigned int	   debug_mask;
-	int		    rc;
+	__u32                 *op;
+	unsigned int           debug_mask;
+	int                    rc;
 	ENTRY;
 
 	req = ptlrpc_request_alloc_pack(class_exp2cliimp(exp), &RQF_SEQ_QUERY,
@@ -153,9 +150,7 @@ int seq_client_alloc_super(struct lu_client_seq *seq,
 	mutex_lock(&seq->lcs_mutex);
 
 	if (seq->lcs_srv) {
-		LASSERT(env != NULL);
-		rc = seq_server_alloc_super(seq->lcs_srv, &seq->lcs_space,
-					    env);
+		rc = 0;
 	} else {
 		/* Check whether the connection to seq controller has been
 		 * setup (lcs_exp != NULL) */
@@ -179,8 +174,7 @@ static int seq_client_alloc_meta(const struct lu_env *env,
 	ENTRY;
 
 	if (seq->lcs_srv) {
-		LASSERT(env != NULL);
-		rc = seq_server_alloc_meta(seq->lcs_srv, &seq->lcs_space, env);
+		rc = 0;
 	} else {
 		do {
 			/* If meta server return -EINPROGRESS or EAGAIN,
@@ -191,6 +185,7 @@ static int seq_client_alloc_meta(const struct lu_env *env,
 					    SEQ_ALLOC_META, "meta");
 		} while (rc == -EINPROGRESS || rc == -EAGAIN);
 	}
+
 	RETURN(rc);
 }
 
@@ -409,11 +404,22 @@ void seq_client_flush(struct lu_client_seq *seq)
 }
 EXPORT_SYMBOL(seq_client_flush);
 
-static void seq_client_proc_fini(struct lu_client_seq *seq);
-
+static void seq_client_proc_fini(struct lu_client_seq *seq)
+{
 #ifdef LPROCFS
+	ENTRY;
+	if (seq->lcs_proc_dir) {
+		if (!IS_ERR(seq->lcs_proc_dir))
+			lprocfs_remove(&seq->lcs_proc_dir);
+		seq->lcs_proc_dir = NULL;
+	}
+	EXIT;
+#endif /* LPROCFS */
+}
+
 static int seq_client_proc_init(struct lu_client_seq *seq)
 {
+#ifdef LPROCFS
 	int rc;
 	ENTRY;
 
@@ -441,29 +447,11 @@ static int seq_client_proc_init(struct lu_client_seq *seq)
 out_cleanup:
 	seq_client_proc_fini(seq);
 	return rc;
-}
 
-static void seq_client_proc_fini(struct lu_client_seq *seq)
-{
-	ENTRY;
-	if (seq->lcs_proc_dir) {
-		if (!IS_ERR(seq->lcs_proc_dir))
-			lprocfs_remove(&seq->lcs_proc_dir);
-		seq->lcs_proc_dir = NULL;
-	}
-	EXIT;
-}
-#else
-static int seq_client_proc_init(struct lu_client_seq *seq)
-{
+#else /* LPROCFS */
 	return 0;
-}
-
-static void seq_client_proc_fini(struct lu_client_seq *seq)
-{
-	return;
-}
 #endif
+}
 
 int seq_client_init(struct lu_client_seq *seq,
 		    struct obd_export *exp,
@@ -520,3 +508,76 @@ void seq_client_fini(struct lu_client_seq *seq)
 	EXIT;
 }
 EXPORT_SYMBOL(seq_client_fini);
+
+int client_fid_init(struct obd_device *obd,
+		    struct obd_export *exp, enum lu_cli_type type)
+{
+	struct client_obd *cli = &obd->u.cli;
+	char *prefix;
+	int rc;
+	ENTRY;
+
+	OBD_ALLOC_PTR(cli->cl_seq);
+	if (cli->cl_seq == NULL)
+		RETURN(-ENOMEM);
+
+	OBD_ALLOC(prefix, MAX_OBD_NAME + 5);
+	if (prefix == NULL)
+		GOTO(out_free_seq, rc = -ENOMEM);
+
+	snprintf(prefix, MAX_OBD_NAME + 5, "cli-%s", obd->obd_name);
+
+	/* Init client side sequence-manager */
+	rc = seq_client_init(cli->cl_seq, exp, type, prefix, NULL);
+	OBD_FREE(prefix, MAX_OBD_NAME + 5);
+	if (rc)
+		GOTO(out_free_seq, rc);
+
+	RETURN(rc);
+out_free_seq:
+	OBD_FREE_PTR(cli->cl_seq);
+	cli->cl_seq = NULL;
+	return rc;
+}
+EXPORT_SYMBOL(client_fid_init);
+
+int client_fid_fini(struct obd_device *obd)
+{
+	struct client_obd *cli = &obd->u.cli;
+	ENTRY;
+
+	if (cli->cl_seq != NULL) {
+		seq_client_fini(cli->cl_seq);
+		OBD_FREE_PTR(cli->cl_seq);
+		cli->cl_seq = NULL;
+	}
+
+	RETURN(0);
+}
+EXPORT_SYMBOL(client_fid_fini);
+
+struct proc_dir_entry *seq_type_proc_dir;
+
+static int __init fid_mod_init(void)
+{
+	seq_type_proc_dir = lprocfs_register(LUSTRE_SEQ_NAME,
+					     proc_lustre_root,
+					     NULL, NULL);
+	if (IS_ERR(seq_type_proc_dir))
+		return PTR_ERR(seq_type_proc_dir);
+	return 0;
+}
+
+static void __exit fid_mod_exit(void)
+{
+	if (seq_type_proc_dir != NULL && !IS_ERR(seq_type_proc_dir)) {
+		lprocfs_remove(&seq_type_proc_dir);
+		seq_type_proc_dir = NULL;
+	}
+}
+
+MODULE_AUTHOR("Sun Microsystems, Inc. <http://www.lustre.org/>");
+MODULE_DESCRIPTION("Lustre FID Module");
+MODULE_LICENSE("GPL");
+
+cfs_module(fid, "0.1.0", fid_mod_init, fid_mod_exit);
diff --git a/drivers/staging/lustre/lustre/fid/fid_store.c b/drivers/staging/lustre/lustre/fid/fid_store.c
deleted file mode 100644
index a90e6e3..0000000
--- a/drivers/staging/lustre/lustre/fid/fid_store.c
+++ /dev/null
@@ -1,259 +0,0 @@
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
- * lustre/fid/fid_store.c
- *
- * Lustre Sequence Manager
- *
- * Author: Yury Umanets <umka@clusterfs.com>
- */
-
-#define DEBUG_SUBSYSTEM S_FID
-
-# include <linux/libcfs/libcfs.h>
-# include <linux/module.h>
-
-#include <obd.h>
-#include <obd_class.h>
-#include <dt_object.h>
-#include <md_object.h>
-#include <obd_support.h>
-#include <lustre_req_layout.h>
-#include <lustre_fid.h>
-#include "fid_internal.h"
-
-
-static struct lu_buf *seq_store_buf(struct seq_thread_info *info)
-{
-	struct lu_buf *buf;
-
-	buf = &info->sti_buf;
-	buf->lb_buf = &info->sti_space;
-	buf->lb_len = sizeof(info->sti_space);
-	return buf;
-}
-
-struct seq_update_callback {
-	struct dt_txn_commit_cb suc_cb;
-	struct lu_server_seq   *suc_seq;
-};
-
-void seq_update_cb(struct lu_env *env, struct thandle *th,
-		   struct dt_txn_commit_cb *cb, int err)
-{
-	struct seq_update_callback *ccb;
-
-	ccb = container_of0(cb, struct seq_update_callback, suc_cb);
-
-	LASSERT(ccb->suc_seq != NULL);
-
-	ccb->suc_seq->lss_need_sync = 0;
-	OBD_FREE_PTR(ccb);
-}
-
-int seq_update_cb_add(struct thandle *th, struct lu_server_seq *seq)
-{
-	struct seq_update_callback *ccb;
-	struct dt_txn_commit_cb	   *dcb;
-	int			   rc;
-
-	OBD_ALLOC_PTR(ccb);
-	if (ccb == NULL)
-		return -ENOMEM;
-
-	ccb->suc_seq	   = seq;
-	seq->lss_need_sync = 1;
-
-	dcb	       = &ccb->suc_cb;
-	dcb->dcb_func  = seq_update_cb;
-	INIT_LIST_HEAD(&dcb->dcb_linkage);
-	strncpy(dcb->dcb_name, "seq_update_cb", MAX_COMMIT_CB_STR_LEN);
-	dcb->dcb_name[MAX_COMMIT_CB_STR_LEN - 1] = '\0';
-
-	rc = dt_trans_cb_add(th, dcb);
-	if (rc)
-		OBD_FREE_PTR(ccb);
-	return rc;
-}
-
-/* This function implies that caller takes care about locking. */
-int seq_store_update(const struct lu_env *env, struct lu_server_seq *seq,
-		     struct lu_seq_range *out, int sync)
-{
-	struct dt_device *dt_dev = lu2dt_dev(seq->lss_obj->do_lu.lo_dev);
-	struct seq_thread_info *info;
-	struct thandle *th;
-	loff_t pos = 0;
-	int rc;
-
-	info = lu_context_key_get(&env->le_ctx, &seq_thread_key);
-	LASSERT(info != NULL);
-
-	th = dt_trans_create(env, dt_dev);
-	if (IS_ERR(th))
-		RETURN(PTR_ERR(th));
-
-	rc = dt_declare_record_write(env, seq->lss_obj,
-				     sizeof(struct lu_seq_range), 0, th);
-	if (rc)
-		GOTO(exit, rc);
-
-	if (out != NULL) {
-		rc = fld_declare_server_create(env,
-					       seq->lss_site->ss_server_fld,
-					       out, th);
-		if (rc)
-			GOTO(exit, rc);
-	}
-
-	rc = dt_trans_start_local(env, dt_dev, th);
-	if (rc)
-		GOTO(exit, rc);
-
-	/* Store ranges in le format. */
-	range_cpu_to_le(&info->sti_space, &seq->lss_space);
-
-	rc = dt_record_write(env, seq->lss_obj, seq_store_buf(info), &pos, th);
-	if (rc) {
-		CERROR("%s: Can't write space data, rc %d\n",
-		       seq->lss_name, rc);
-		GOTO(exit, rc);
-	} else if (out != NULL) {
-		rc = fld_server_create(env, seq->lss_site->ss_server_fld, out,
-				       th);
-		if (rc) {
-			CERROR("%s: Can't Update fld database, rc %d\n",
-				seq->lss_name, rc);
-			GOTO(exit, rc);
-		}
-	}
-	/* next sequence update will need sync until this update is committed
-	 * in case of sync operation this is not needed obviously */
-	if (!sync)
-		/* if callback can't be added then sync always */
-		sync = !!seq_update_cb_add(th, seq);
-
-	th->th_sync |= sync;
-exit:
-	dt_trans_stop(env, dt_dev, th);
-	return rc;
-}
-
-/*
- * This function implies that caller takes care about locking or locking is not
- * needed (init time).
- */
-int seq_store_read(struct lu_server_seq *seq,
-		   const struct lu_env *env)
-{
-	struct seq_thread_info *info;
-	loff_t pos = 0;
-	int rc;
-	ENTRY;
-
-	info = lu_context_key_get(&env->le_ctx, &seq_thread_key);
-	LASSERT(info != NULL);
-
-	rc = seq->lss_obj->do_body_ops->dbo_read(env, seq->lss_obj,
-						 seq_store_buf(info),
-						 &pos, BYPASS_CAPA);
-
-	if (rc == sizeof(info->sti_space)) {
-		range_le_to_cpu(&seq->lss_space, &info->sti_space);
-		CDEBUG(D_INFO, "%s: Space - "DRANGE"\n",
-		       seq->lss_name, PRANGE(&seq->lss_space));
-		rc = 0;
-	} else if (rc == 0) {
-		rc = -ENODATA;
-	} else if (rc > 0) {
-		CERROR("%s: Read only %d bytes of %d\n", seq->lss_name,
-		       rc, (int)sizeof(info->sti_space));
-		rc = -EIO;
-	}
-
-	RETURN(rc);
-}
-
-int seq_store_init(struct lu_server_seq *seq,
-		   const struct lu_env *env,
-		   struct dt_device *dt)
-{
-	struct dt_object *dt_obj;
-	struct lu_fid fid;
-	struct lu_attr attr;
-	struct dt_object_format dof;
-	const char *name;
-	int rc;
-	ENTRY;
-
-	name = seq->lss_type == LUSTRE_SEQ_SERVER ?
-		LUSTRE_SEQ_SRV_NAME : LUSTRE_SEQ_CTL_NAME;
-
-	if (seq->lss_type == LUSTRE_SEQ_SERVER)
-		lu_local_obj_fid(&fid, FID_SEQ_SRV_OID);
-	else
-		lu_local_obj_fid(&fid, FID_SEQ_CTL_OID);
-
-	memset(&attr, 0, sizeof(attr));
-	attr.la_valid = LA_MODE;
-	attr.la_mode = S_IFREG | 0666;
-	dof.dof_type = DFT_REGULAR;
-
-	dt_obj = dt_find_or_create(env, dt, &fid, &dof, &attr);
-	if (!IS_ERR(dt_obj)) {
-		seq->lss_obj = dt_obj;
-		rc = 0;
-	} else {
-		CERROR("%s: Can't find \"%s\" obj %d\n",
-		       seq->lss_name, name, (int)PTR_ERR(dt_obj));
-		rc = PTR_ERR(dt_obj);
-	}
-
-	RETURN(rc);
-}
-
-void seq_store_fini(struct lu_server_seq *seq,
-		    const struct lu_env *env)
-{
-	ENTRY;
-
-	if (seq->lss_obj != NULL) {
-		if (!IS_ERR(seq->lss_obj))
-			lu_object_put(env, &seq->lss_obj->do_lu);
-		seq->lss_obj = NULL;
-	}
-
-	EXIT;
-}
diff --git a/drivers/staging/lustre/lustre/fid/lproc_fid.c b/drivers/staging/lustre/lustre/fid/lproc_fid.c
index af817a8..20d0448 100644
--- a/drivers/staging/lustre/lustre/fid/lproc_fid.c
+++ b/drivers/staging/lustre/lustre/fid/lproc_fid.c
@@ -204,9 +204,6 @@ lprocfs_fid_server_seq_show(struct seq_file *m, void *unused)
 	RETURN(rc);
 }
 
-struct lprocfs_vars seq_server_proc_list[] = {
-};
-
 LPROC_SEQ_FOPS(lprocfs_fid_space);
 LPROC_SEQ_FOPS(lprocfs_fid_width);
 LPROC_SEQ_FOPS_RO(lprocfs_fid_server);
diff --git a/drivers/staging/lustre/lustre/include/lu_object.h b/drivers/staging/lustre/lustre/include/lu_object.h
index f0d6fb1..8077898 100644
--- a/drivers/staging/lustre/lustre/include/lu_object.h
+++ b/drivers/staging/lustre/lustre/include/lu_object.h
@@ -665,6 +665,11 @@ lu_site_bkt_from_fid(struct lu_site *site, struct lu_fid *fid)
 	return cfs_hash_bd_extra_get(site->ls_obj_hash, &bd);
 }
 
+static inline struct seq_server_site *lu_site2seq(const struct lu_site *s)
+{
+	return s->ld_seq_site;
+}
+
 /** \name ctors
  * Constructors/destructors.
  * @{
diff --git a/drivers/staging/lustre/lustre/include/lustre_fid.h b/drivers/staging/lustre/lustre/include/lustre_fid.h
index 7523b40..f8f35c3 100644
--- a/drivers/staging/lustre/lustre/include/lustre_fid.h
+++ b/drivers/staging/lustre/lustre/include/lustre_fid.h
@@ -38,8 +38,8 @@
  * Author: Yury Umanets <umka@clusterfs.com>
  */
 
-#ifndef __LINUX_FID_H
-#define __LINUX_FID_H
+#ifndef __LUSTRE_FID_H
+#define __LUSTRE_FID_H
 
 /** \defgroup fid fid
  *
@@ -154,13 +154,12 @@
 
 #include <linux/libcfs/libcfs.h>
 #include <lustre/lustre_idl.h>
-#include <lustre_req_layout.h>
-#include <lustre_mdt.h>
-#include <obd.h>
-
 
+struct lu_env;
 struct lu_site;
 struct lu_context;
+struct obd_device;
+struct obd_export;
 
 /* Whole sequences space range and zero range definitions */
 extern const struct lu_seq_range LUSTRE_SEQ_SPACE_RANGE;
@@ -320,6 +319,12 @@ static inline void lu_last_id_fid(struct lu_fid *fid, __u64 seq)
 	fid->f_ver = 0;
 }
 
+/* seq client type */
+enum lu_cli_type {
+	LUSTRE_SEQ_METADATA = 1,
+	LUSTRE_SEQ_DATA
+};
+
 enum lu_mgr_type {
 	LUSTRE_SEQ_SERVER,
 	LUSTRE_SEQ_CONTROLLER
@@ -426,10 +431,14 @@ struct lu_server_seq {
 	struct seq_server_site  *lss_site;
 };
 
+struct com_thread_info;
 int seq_query(struct com_thread_info *info);
+
+struct ptlrpc_request;
 int seq_handle(struct ptlrpc_request *req);
 
 /* Server methods */
+
 int seq_server_init(struct lu_server_seq *seq,
 		    struct dt_device *dev,
 		    const char *prefix,
@@ -472,6 +481,7 @@ int seq_site_fini(const struct lu_env *env, struct seq_server_site *ss);
 int fid_is_local(const struct lu_env *env,
 		 struct lu_site *site, const struct lu_fid *fid);
 
+enum lu_cli_type;
 int client_fid_init(struct obd_device *obd, struct obd_export *exp,
 		    enum lu_cli_type type);
 int client_fid_fini(struct obd_device *obd);
@@ -760,4 +770,4 @@ static inline void range_be_to_cpu(struct lu_seq_range *dst, const struct lu_seq
 
 /** @} fid */
 
-#endif /* __LINUX_FID_H */
+#endif /* __LUSTRE_FID_H */
diff --git a/drivers/staging/lustre/lustre/include/md_object.h b/drivers/staging/lustre/lustre/include/md_object.h
index 92d6420..65b270a 100644
--- a/drivers/staging/lustre/lustre/include/md_object.h
+++ b/drivers/staging/lustre/lustre/include/md_object.h
@@ -503,11 +503,6 @@ static inline struct md_device *md_obj2dev(const struct md_object *o)
 	return container_of0(o->mo_lu.lo_dev, struct md_device, md_lu_dev);
 }
 
-static inline struct seq_server_site *lu_site2seq(const struct lu_site *s)
-{
-	return s->ld_seq_site;
-}
-
 static inline int md_device_init(struct md_device *md, struct lu_device_type *t)
 {
 	return lu_device_init(&md->md_lu_dev, t);
diff --git a/drivers/staging/lustre/lustre/include/obd.h b/drivers/staging/lustre/lustre/include/obd.h
index 11d10fe..fbf997f 100644
--- a/drivers/staging/lustre/lustre/include/obd.h
+++ b/drivers/staging/lustre/lustre/include/obd.h
@@ -52,6 +52,7 @@
 #include <lu_ref.h>
 #include <lustre_lib.h>
 #include <lustre_export.h>
+#include <lustre_fid.h>
 #include <lustre_fld.h>
 #include <lustre_capa.h>
 
@@ -1232,12 +1233,6 @@ typedef int (* md_enqueue_cb_t)(struct ptlrpc_request *req,
 				struct md_enqueue_info *minfo,
 				int rc);
 
-/* seq client type */
-enum lu_cli_type {
-	LUSTRE_SEQ_METADATA = 1,
-	LUSTRE_SEQ_DATA
-};
-
 struct md_enqueue_info {
 	struct md_op_data       mi_data;
 	struct lookup_intent    mi_it;
-- 
1.7.9.5

