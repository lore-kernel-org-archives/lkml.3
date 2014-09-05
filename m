Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbaIEUK3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 16:10:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:45940 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752670AbaIEUKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 16:10:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,474,1406617200"; 
   d="scan'208";a="598712976"
From: "John L. Hammond" <john.hammond@intel.com>
To: <greg@kroah.com>, <andreas.dilger@intel.com>, <oleg.drokin@intel.com>
CC: <linux-kernel@vger.kernel.org>, "John L. Hammond" <john.hammond@intel.com>
Subject: [PATCH 11/12] staging/lustre/obdclass: remove llog_ioctl.c
Date: Fri, 5 Sep 2014 15:08:17 -0500
Message-ID: <1409947698-30781-12-git-send-email-john.hammond@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1409947698-30781-1-git-send-email-john.hammond@intel.com>
References: <1409947698-30781-1-git-send-email-john.hammond@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.1.200.106]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John L. Hammond" <john.hammond@intel.com>

Remove the unused function llog_ioctl() and the file
lustre/obdclass/llog_ioctl.c.

Signed-off-by: John L. Hammond <john.hammond@intel.com>
---
 drivers/staging/lustre/lustre/include/lustre_log.h |    4 -
 drivers/staging/lustre/lustre/obdclass/Makefile    |    2 +-
 .../staging/lustre/lustre/obdclass/llog_ioctl.c    |  418 --------------------
 3 files changed, 1 insertion(+), 423 deletions(-)
 delete mode 100644 drivers/staging/lustre/lustre/obdclass/llog_ioctl.c

diff --git a/drivers/staging/lustre/lustre/include/lustre_log.h b/drivers/staging/lustre/lustre/include/lustre_log.h
index c10029c..2187fb6 100644
--- a/drivers/staging/lustre/lustre/include/lustre_log.h
+++ b/drivers/staging/lustre/lustre/include/lustre_log.h
@@ -206,10 +206,6 @@ int llog_sync(struct llog_ctxt *ctxt, struct obd_export *exp, int flags);
 int llog_cancel(const struct lu_env *env, struct llog_ctxt *ctxt,
 		struct llog_cookie *cookies, int flags);
 
-/* llog_ioctl.c */
-int llog_ioctl(const struct lu_env *env, struct llog_ctxt *ctxt, int cmd,
-	       struct obd_ioctl_data *data);
-
 /* llog_net.c */
 int llog_initiator_connect(struct llog_ctxt *ctxt);
 
diff --git a/drivers/staging/lustre/lustre/obdclass/Makefile b/drivers/staging/lustre/lustre/obdclass/Makefile
index c8c95e1..77fd94c 100644
--- a/drivers/staging/lustre/lustre/obdclass/Makefile
+++ b/drivers/staging/lustre/lustre/obdclass/Makefile
@@ -2,7 +2,7 @@ obj-$(CONFIG_LUSTRE_FS) += obdclass.o
 
 obdclass-y := linux/linux-module.o linux/linux-obdo.o linux/linux-sysctl.o \
 	      llog.o llog_cat.o llog_obd.o llog_swab.o class_obd.o debug.o \
-	      genops.o uuid.o llog_ioctl.o lprocfs_status.o		   \
+	      genops.o uuid.o lprocfs_status.o \
 	      lustre_handles.o lustre_peer.o \
 	      local_storage.o statfs_pack.o obdo.o obd_config.o obd_mount.o\
 	      lu_object.o dt_object.o capa.o cl_object.o   \
diff --git a/drivers/staging/lustre/lustre/obdclass/llog_ioctl.c b/drivers/staging/lustre/lustre/obdclass/llog_ioctl.c
deleted file mode 100644
index 9b7fa1d..0000000
--- a/drivers/staging/lustre/lustre/obdclass/llog_ioctl.c
+++ /dev/null
@@ -1,418 +0,0 @@
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
- * Copyright (c) 2003, 2010, Oracle and/or its affiliates. All rights reserved.
- * Use is subject to license terms.
- *
- * Copyright (c) 2011, 2012, Intel Corporation.
- */
-/*
- * This file is part of Lustre, http://www.lustre.org/
- * Lustre is a trademark of Sun Microsystems, Inc.
- */
-
-#define DEBUG_SUBSYSTEM S_LOG
-
-#include "../include/obd_class.h"
-#include "../include/lustre_log.h"
-#include "llog_internal.h"
-
-static int str2logid(struct llog_logid *logid, char *str, int len)
-{
-	char *start, *end, *endp;
-	__u64 id, seq;
-
-	start = str;
-	if (*start != '#')
-		return -EINVAL;
-
-	start++;
-	if (start - str >= len - 1)
-		return -EINVAL;
-	end = strchr(start, '#');
-	if (end == NULL || end == start)
-		return -EINVAL;
-
-	*end = '\0';
-	id = simple_strtoull(start, &endp, 0);
-	if (endp != end)
-		return -EINVAL;
-
-	start = ++end;
-	if (start - str >= len - 1)
-		return -EINVAL;
-	end = strchr(start, '#');
-	if (end == NULL || end == start)
-		return -EINVAL;
-
-	*end = '\0';
-	seq = simple_strtoull(start, &endp, 0);
-	if (endp != end)
-		return -EINVAL;
-
-	ostid_set_seq(&logid->lgl_oi, seq);
-	ostid_set_id(&logid->lgl_oi, id);
-
-	start = ++end;
-	if (start - str >= len - 1)
-		return -EINVAL;
-	logid->lgl_ogen = simple_strtoul(start, &endp, 16);
-	if (*endp != '\0')
-		return -EINVAL;
-
-	return 0;
-}
-
-static int llog_check_cb(const struct lu_env *env, struct llog_handle *handle,
-			 struct llog_rec_hdr *rec, void *data)
-{
-	struct obd_ioctl_data *ioc_data = (struct obd_ioctl_data *)data;
-	static int l, remains, from, to;
-	static char *out;
-	char *endp;
-	int cur_index, rc = 0;
-
-	if (ioc_data && ioc_data->ioc_inllen1 > 0) {
-		l = 0;
-		remains = ioc_data->ioc_inllen4 +
-			cfs_size_round(ioc_data->ioc_inllen1) +
-			cfs_size_round(ioc_data->ioc_inllen2) +
-			cfs_size_round(ioc_data->ioc_inllen3);
-		from = simple_strtol(ioc_data->ioc_inlbuf2, &endp, 0);
-		if (*endp != '\0')
-			return -EINVAL;
-		to = simple_strtol(ioc_data->ioc_inlbuf3, &endp, 0);
-		if (*endp != '\0')
-			return -EINVAL;
-		ioc_data->ioc_inllen1 = 0;
-		out = ioc_data->ioc_bulk;
-	}
-
-	cur_index = rec->lrh_index;
-	if (cur_index < from)
-		return 0;
-	if (to > 0 && cur_index > to)
-		return -LLOG_EEMPTY;
-
-	if (handle->lgh_hdr->llh_flags & LLOG_F_IS_CAT) {
-		struct llog_logid_rec	*lir = (struct llog_logid_rec *)rec;
-		struct llog_handle	*loghandle;
-
-		if (rec->lrh_type != LLOG_LOGID_MAGIC) {
-			l = snprintf(out, remains, "[index]: %05d  [type]: "
-				     "%02x  [len]: %04d failed\n",
-				     cur_index, rec->lrh_type,
-				     rec->lrh_len);
-		}
-		if (handle->lgh_ctxt == NULL)
-			return -EOPNOTSUPP;
-		rc = llog_cat_id2handle(env, handle, &loghandle, &lir->lid_id);
-		if (rc) {
-			CDEBUG(D_IOCTL, "cannot find log #"DOSTID"#%08x\n",
-			       POSTID(&lir->lid_id.lgl_oi),
-			       lir->lid_id.lgl_ogen);
-			return rc;
-		}
-		rc = llog_process(env, loghandle, llog_check_cb, NULL, NULL);
-		llog_handle_put(loghandle);
-	} else {
-		bool ok;
-
-		switch (rec->lrh_type) {
-		case OST_SZ_REC:
-		case MDS_UNLINK_REC:
-		case MDS_UNLINK64_REC:
-		case MDS_SETATTR64_REC:
-		case OBD_CFG_REC:
-		case LLOG_GEN_REC:
-		case LLOG_HDR_MAGIC:
-			ok = true;
-			break;
-		default:
-			ok = false;
-		}
-
-		l = snprintf(out, remains, "[index]: %05d  [type]: "
-			     "%02x  [len]: %04d %s\n",
-			     cur_index, rec->lrh_type, rec->lrh_len,
-			     ok ? "ok" : "failed");
-		out += l;
-		remains -= l;
-		if (remains <= 0) {
-			CERROR("%s: no space to print log records\n",
-			       handle->lgh_ctxt->loc_obd->obd_name);
-			return -LLOG_EEMPTY;
-		}
-	}
-	return rc;
-}
-
-static int llog_print_cb(const struct lu_env *env, struct llog_handle *handle,
-			 struct llog_rec_hdr *rec, void *data)
-{
-	struct obd_ioctl_data *ioc_data = (struct obd_ioctl_data *)data;
-	static int l, remains, from, to;
-	static char *out;
-	char *endp;
-	int cur_index;
-
-	if (ioc_data != NULL && ioc_data->ioc_inllen1 > 0) {
-		l = 0;
-		remains = ioc_data->ioc_inllen4 +
-			cfs_size_round(ioc_data->ioc_inllen1) +
-			cfs_size_round(ioc_data->ioc_inllen2) +
-			cfs_size_round(ioc_data->ioc_inllen3);
-		from = simple_strtol(ioc_data->ioc_inlbuf2, &endp, 0);
-		if (*endp != '\0')
-			return -EINVAL;
-		to = simple_strtol(ioc_data->ioc_inlbuf3, &endp, 0);
-		if (*endp != '\0')
-			return -EINVAL;
-		out = ioc_data->ioc_bulk;
-		ioc_data->ioc_inllen1 = 0;
-	}
-
-	cur_index = rec->lrh_index;
-	if (cur_index < from)
-		return 0;
-	if (to > 0 && cur_index > to)
-		return -LLOG_EEMPTY;
-
-	if (handle->lgh_hdr->llh_flags & LLOG_F_IS_CAT) {
-		struct llog_logid_rec *lir = (struct llog_logid_rec *)rec;
-
-		if (rec->lrh_type != LLOG_LOGID_MAGIC) {
-			CERROR("invalid record in catalog\n");
-			return -EINVAL;
-		}
-
-		l = snprintf(out, remains,
-			     "[index]: %05d  [logid]: #"DOSTID"#%08x\n",
-			     cur_index, POSTID(&lir->lid_id.lgl_oi),
-			     lir->lid_id.lgl_ogen);
-	} else if (rec->lrh_type == OBD_CFG_REC) {
-		int rc;
-
-		rc = class_config_parse_rec(rec, out, remains);
-		if (rc < 0)
-			return rc;
-		l = rc;
-	} else {
-		l = snprintf(out, remains,
-			     "[index]: %05d  [type]: %02x  [len]: %04d\n",
-			     cur_index, rec->lrh_type, rec->lrh_len);
-	}
-	out += l;
-	remains -= l;
-	if (remains <= 0) {
-		CERROR("not enough space for print log records\n");
-		return -LLOG_EEMPTY;
-	}
-
-	return 0;
-}
-static int llog_remove_log(const struct lu_env *env, struct llog_handle *cat,
-			   struct llog_logid *logid)
-{
-	struct llog_handle	*log;
-	int			 rc;
-
-	rc = llog_cat_id2handle(env, cat, &log, logid);
-	if (rc) {
-		CDEBUG(D_IOCTL, "cannot find log #"DOSTID"#%08x\n",
-		       POSTID(&logid->lgl_oi), logid->lgl_ogen);
-		return -ENOENT;
-	}
-
-	rc = llog_destroy(env, log);
-	if (rc) {
-		CDEBUG(D_IOCTL, "cannot destroy log\n");
-		GOTO(out, rc);
-	}
-	llog_cat_cleanup(env, cat, log, log->u.phd.phd_cookie.lgc_index);
-out:
-	llog_handle_put(log);
-	return rc;
-
-}
-
-static int llog_delete_cb(const struct lu_env *env, struct llog_handle *handle,
-			  struct llog_rec_hdr *rec, void *data)
-{
-	struct llog_logid_rec	*lir = (struct llog_logid_rec *)rec;
-	int			 rc;
-
-	if (rec->lrh_type != LLOG_LOGID_MAGIC)
-		return -EINVAL;
-	rc = llog_remove_log(env, handle, &lir->lid_id);
-
-	return rc;
-}
-
-
-int llog_ioctl(const struct lu_env *env, struct llog_ctxt *ctxt, int cmd,
-	       struct obd_ioctl_data *data)
-{
-	struct llog_logid	 logid;
-	int			 rc = 0;
-	struct llog_handle	*handle = NULL;
-
-	if (*data->ioc_inlbuf1 == '#') {
-		rc = str2logid(&logid, data->ioc_inlbuf1, data->ioc_inllen1);
-		if (rc)
-			return rc;
-		rc = llog_open(env, ctxt, &handle, &logid, NULL,
-			       LLOG_OPEN_EXISTS);
-		if (rc)
-			return rc;
-	} else if (*data->ioc_inlbuf1 == '$') {
-		char *name = data->ioc_inlbuf1 + 1;
-
-		rc = llog_open(env, ctxt, &handle, NULL, name,
-			       LLOG_OPEN_EXISTS);
-		if (rc)
-			return rc;
-	} else {
-		return -EINVAL;
-	}
-
-	rc = llog_init_handle(env, handle, 0, NULL);
-	if (rc)
-		GOTO(out_close, rc = -ENOENT);
-
-	switch (cmd) {
-	case OBD_IOC_LLOG_INFO: {
-		int	 l;
-		int	 remains = data->ioc_inllen2 +
-				   cfs_size_round(data->ioc_inllen1);
-		char	*out = data->ioc_bulk;
-
-		l = snprintf(out, remains,
-			     "logid:	    #"DOSTID"#%08x\n"
-			     "flags:	    %x (%s)\n"
-			     "records count:    %d\n"
-			     "last index:       %d\n",
-			     POSTID(&handle->lgh_id.lgl_oi),
-			     handle->lgh_id.lgl_ogen,
-			     handle->lgh_hdr->llh_flags,
-			     handle->lgh_hdr->llh_flags &
-			     LLOG_F_IS_CAT ? "cat" : "plain",
-			     handle->lgh_hdr->llh_count,
-			     handle->lgh_last_idx);
-		out += l;
-		remains -= l;
-		if (remains <= 0) {
-			CERROR("%s: not enough space for log header info\n",
-			       ctxt->loc_obd->obd_name);
-			rc = -ENOSPC;
-		}
-		break;
-	}
-	case OBD_IOC_LLOG_CHECK:
-		LASSERT(data->ioc_inllen1 > 0);
-		rc = llog_process(env, handle, llog_check_cb, data, NULL);
-		if (rc == -LLOG_EEMPTY)
-			rc = 0;
-		else if (rc)
-			GOTO(out_close, rc);
-		break;
-	case OBD_IOC_LLOG_PRINT:
-		LASSERT(data->ioc_inllen1 > 0);
-		rc = llog_process(env, handle, llog_print_cb, data, NULL);
-		if (rc == -LLOG_EEMPTY)
-			rc = 0;
-		else if (rc)
-			GOTO(out_close, rc);
-		break;
-	case OBD_IOC_LLOG_CANCEL: {
-		struct llog_cookie cookie;
-		struct llog_logid plain;
-		char *endp;
-
-		cookie.lgc_index = simple_strtoul(data->ioc_inlbuf3, &endp, 0);
-		if (*endp != '\0')
-			GOTO(out_close, rc = -EINVAL);
-
-		if (handle->lgh_hdr->llh_flags & LLOG_F_IS_PLAIN) {
-			rc = llog_cancel_rec(NULL, handle, cookie.lgc_index);
-			GOTO(out_close, rc);
-		} else if (!(handle->lgh_hdr->llh_flags & LLOG_F_IS_CAT)) {
-			GOTO(out_close, rc = -EINVAL);
-		}
-
-		if (data->ioc_inlbuf2 == NULL) /* catalog but no logid */
-			GOTO(out_close, rc = -ENOTTY);
-
-		rc = str2logid(&plain, data->ioc_inlbuf2, data->ioc_inllen2);
-		if (rc)
-			GOTO(out_close, rc);
-		cookie.lgc_lgl = plain;
-		rc = llog_cat_cancel_records(env, handle, 1, &cookie);
-		if (rc)
-			GOTO(out_close, rc);
-		break;
-	}
-	case OBD_IOC_LLOG_REMOVE: {
-		struct llog_logid plain;
-
-		if (handle->lgh_hdr->llh_flags & LLOG_F_IS_PLAIN) {
-			rc = llog_destroy(env, handle);
-			GOTO(out_close, rc);
-		} else if (!(handle->lgh_hdr->llh_flags & LLOG_F_IS_CAT)) {
-			GOTO(out_close, rc = -EINVAL);
-		}
-
-		if (data->ioc_inllen2 > 0) {
-			/* remove indicate log from the catalog */
-			rc = str2logid(&plain, data->ioc_inlbuf2,
-				       data->ioc_inllen2);
-			if (rc)
-				GOTO(out_close, rc);
-			rc = llog_remove_log(env, handle, &plain);
-		} else {
-			/* remove all the log of the catalog */
-			rc = llog_process(env, handle, llog_delete_cb, NULL,
-					  NULL);
-			if (rc)
-				GOTO(out_close, rc);
-		}
-		break;
-	}
-	default:
-		CERROR("%s: Unknown ioctl cmd %#x\n",
-		       ctxt->loc_obd->obd_name, cmd);
-		GOTO(out_close, rc = -ENOTTY);
-	}
-
-out_close:
-	if (handle->lgh_hdr &&
-	    handle->lgh_hdr->llh_flags & LLOG_F_IS_CAT)
-		llog_cat_close(env, handle);
-	else
-		llog_close(env, handle);
-	return rc;
-}
-EXPORT_SYMBOL(llog_ioctl);
-- 
1.7.9.5

