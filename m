Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbaD0RYe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 13:24:34 -0400
Received: from linuxhacker.ru ([217.76.32.60]:47962 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753235AbaD0RHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 13:07:42 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Andrew Korty <ajk@iu.edu>, Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 03/47] staging/lustre/gss: gssnull security flavor
Date: Sun, 27 Apr 2014 13:06:27 -0400
Message-Id: <1398618431-29757-4-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
References: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Korty <ajk@iu.edu>

This change implements the gssnull security flavor for the purpose of
testing the Lustre GSS code.  It provides and uses a null GSS
mechanism so this testing doesn't have to involve any code related to
Kerberos or any other authentication method.

Signed-off-by: Andrew Korty <ajk@iu.edu>
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3289
Reviewed-on: http://review.whamcloud.com/8475
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: Thomas Stibor <thomas@stibor.net>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/include/lustre_sec.h |   8 +
 drivers/staging/lustre/lustre/ptlrpc/gss/Makefile  |   2 +-
 .../lustre/lustre/ptlrpc/gss/gss_internal.h        |   4 +
 .../lustre/lustre/ptlrpc/gss/gss_null_mech.c       | 195 +++++++++++++++++++++
 drivers/staging/lustre/lustre/ptlrpc/gss/sec_gss.c |   8 +-
 drivers/staging/lustre/lustre/ptlrpc/sec.c         |   4 +
 6 files changed, 219 insertions(+), 2 deletions(-)
 create mode 100644 drivers/staging/lustre/lustre/ptlrpc/gss/gss_null_mech.c

diff --git a/drivers/staging/lustre/lustre/include/lustre_sec.h b/drivers/staging/lustre/lustre/include/lustre_sec.h
index bf3ee39..40d463f 100644
--- a/drivers/staging/lustre/lustre/include/lustre_sec.h
+++ b/drivers/staging/lustre/lustre/include/lustre_sec.h
@@ -170,6 +170,8 @@ enum sptlrpc_bulk_service {
 	((__u32)(mech) |						\
 	 ((__u32)(svc) << (FLVR_SVC_OFFSET - FLVR_MECH_OFFSET)))
 
+#define SPTLRPC_SUBFLVR_GSSNULL						\
+	MAKE_BASE_SUBFLVR(SPTLRPC_MECH_GSS_NULL, SPTLRPC_SVC_NULL)
 #define SPTLRPC_SUBFLVR_KRB5N					   \
 	MAKE_BASE_SUBFLVR(SPTLRPC_MECH_GSS_KRB5, SPTLRPC_SVC_NULL)
 #define SPTLRPC_SUBFLVR_KRB5A					   \
@@ -194,6 +196,12 @@ enum sptlrpc_bulk_service {
 		  SPTLRPC_SVC_NULL,		     \
 		  SPTLRPC_BULK_HASH,		    \
 		  SPTLRPC_BULK_SVC_INTG)
+#define SPTLRPC_FLVR_GSSNULL				\
+	MAKE_FLVR(SPTLRPC_POLICY_GSS,			\
+		  SPTLRPC_MECH_GSS_NULL,		\
+		  SPTLRPC_SVC_NULL,			\
+		  SPTLRPC_BULK_DEFAULT,			\
+		  SPTLRPC_BULK_SVC_NULL)
 #define SPTLRPC_FLVR_KRB5N			      \
 	MAKE_FLVR(SPTLRPC_POLICY_GSS,		   \
 		  SPTLRPC_MECH_GSS_KRB5,		\
diff --git a/drivers/staging/lustre/lustre/ptlrpc/gss/Makefile b/drivers/staging/lustre/lustre/ptlrpc/gss/Makefile
index 8cdfbee..ab16596 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/gss/Makefile
+++ b/drivers/staging/lustre/lustre/ptlrpc/gss/Makefile
@@ -2,7 +2,7 @@ obj-$(CONFIG_LUSTRE_FS) := ptlrpc_gss.o
 
 ptlrpc_gss-y := sec_gss.o gss_bulk.o gss_cli_upcall.o gss_svc_upcall.o	\
 		gss_rawobj.o lproc_gss.o gss_generic_token.o		\
-		gss_mech_switch.o gss_krb5_mech.o
+		gss_mech_switch.o gss_krb5_mech.o gss_null_mech.o
 
 
 ccflags-y := -I$(src)/../include
diff --git a/drivers/staging/lustre/lustre/ptlrpc/gss/gss_internal.h b/drivers/staging/lustre/lustre/ptlrpc/gss/gss_internal.h
index cbfc47c..1a0c7d5 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/gss/gss_internal.h
+++ b/drivers/staging/lustre/lustre/ptlrpc/gss/gss_internal.h
@@ -498,6 +498,10 @@ void gss_stat_oos_record_svc(int phase, int replay);
 int  __init gss_init_lproc(void);
 void __exit gss_exit_lproc(void);
 
+/* gss_null_mech.c */
+int __init init_null_module(void);
+void cleanup_null_module(void);
+
 /* gss_krb5_mech.c */
 int __init init_kerberos_module(void);
 void __exit cleanup_kerberos_module(void);
diff --git a/drivers/staging/lustre/lustre/ptlrpc/gss/gss_null_mech.c b/drivers/staging/lustre/lustre/ptlrpc/gss/gss_null_mech.c
new file mode 100644
index 0000000..3021d7d
--- /dev/null
+++ b/drivers/staging/lustre/lustre/ptlrpc/gss/gss_null_mech.c
@@ -0,0 +1,195 @@
+/*
+ * GPL HEADER START
+ *
+ * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 only,
+ * as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License version 2 for more details (a copy is included
+ * in the LICENSE file that accompanied this code).
+ *
+ * You should have received a copy of the GNU General Public License
+ * version 2 along with this program; If not, see
+ * http://www.gnu.org/licenses/gpl-2.0.html
+ *
+ * GPL HEADER END
+ */
+/*
+ * Copyright (C) 2013, Trustees of Indiana University
+ * Author: Andrew Korty <ajk@iu.edu>
+ */
+
+#define DEBUG_SUBSYSTEM S_SEC
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/crypto.h>
+#include <linux/mutex.h>
+
+#include <obd.h>
+#include <obd_class.h>
+#include <obd_support.h>
+
+#include "gss_err.h"
+#include "gss_internal.h"
+#include "gss_api.h"
+#include "gss_asn1.h"
+
+struct null_ctx {
+};
+
+static
+__u32 gss_import_sec_context_null(rawobj_t *inbuf, struct gss_ctx *gss_context)
+{
+	struct null_ctx *null_context;
+
+	if (inbuf == NULL || inbuf->data == NULL)
+		return GSS_S_FAILURE;
+
+	OBD_ALLOC_PTR(null_context);
+	if (null_context == NULL)
+		return GSS_S_FAILURE;
+
+	gss_context->internal_ctx_id = null_context;
+	CDEBUG(D_SEC, "succesfully imported null context\n");
+
+	return GSS_S_COMPLETE;
+}
+
+static
+__u32 gss_copy_reverse_context_null(struct gss_ctx *gss_context_old,
+				    struct gss_ctx *gss_context_new)
+{
+	struct null_ctx *null_context_old;
+	struct null_ctx *null_context_new;
+
+	OBD_ALLOC_PTR(null_context_new);
+	if (null_context_new == NULL)
+		return GSS_S_FAILURE;
+
+	null_context_old = gss_context_old->internal_ctx_id;
+	memcpy(null_context_new, null_context_old, sizeof(*null_context_new));
+	gss_context_new->internal_ctx_id = null_context_new;
+	CDEBUG(D_SEC, "succesfully copied reverse null context\n");
+
+	return GSS_S_COMPLETE;
+}
+
+static
+__u32 gss_inquire_context_null(struct gss_ctx *gss_context,
+			       unsigned long *endtime)
+{
+	*endtime = 0;
+	return GSS_S_COMPLETE;
+}
+
+static
+__u32 gss_wrap_null(struct gss_ctx *gss_context, rawobj_t *gss_header,
+		    rawobj_t *message, int message_buffer_length,
+		    rawobj_t *token)
+{
+	return GSS_S_COMPLETE;
+}
+
+static
+__u32 gss_unwrap_null(struct gss_ctx *gss_context, rawobj_t *gss_header,
+		      rawobj_t *token, rawobj_t *message)
+{
+	return GSS_S_COMPLETE;
+}
+
+static
+__u32 gss_prep_bulk_null(struct gss_ctx *gss_context,
+			 struct ptlrpc_bulk_desc *desc)
+{
+	return GSS_S_COMPLETE;
+}
+
+static
+__u32 gss_wrap_bulk_null(struct gss_ctx *gss_context,
+			 struct ptlrpc_bulk_desc *desc, rawobj_t *token,
+			 int adj_nob)
+{
+	return GSS_S_COMPLETE;
+}
+
+static
+__u32 gss_unwrap_bulk_null(struct gss_ctx *gss_context,
+			   struct ptlrpc_bulk_desc *desc,
+			   rawobj_t *token, int adj_nob)
+{
+	return GSS_S_COMPLETE;
+}
+
+static
+void gss_delete_sec_context_null(void *internal_context)
+{
+	struct null_ctx *null_context = internal_context;
+
+	OBD_FREE_PTR(null_context);
+}
+
+int gss_display_null(struct gss_ctx *gss_context, char *buf, int bufsize)
+{
+	return snprintf(buf, bufsize, "null");
+}
+
+static struct gss_api_ops gss_null_ops = {
+	.gss_import_sec_context     = gss_import_sec_context_null,
+	.gss_copy_reverse_context   = gss_copy_reverse_context_null,
+	.gss_inquire_context        = gss_inquire_context_null,
+	.gss_get_mic                = NULL,
+	.gss_verify_mic             = NULL,
+	.gss_wrap                   = gss_wrap_null,
+	.gss_unwrap                 = gss_unwrap_null,
+	.gss_prep_bulk              = gss_prep_bulk_null,
+	.gss_wrap_bulk              = gss_wrap_bulk_null,
+	.gss_unwrap_bulk            = gss_unwrap_bulk_null,
+	.gss_delete_sec_context     = gss_delete_sec_context_null,
+	.gss_display                = gss_display_null,
+};
+
+static struct subflavor_desc gss_null_sfs[] = {
+	{
+		.sf_subflavor   = SPTLRPC_SUBFLVR_GSSNULL,
+		.sf_qop         = 0,
+		.sf_service     = SPTLRPC_SVC_NULL,
+		.sf_name        = "gssnull"
+	},
+};
+
+/*
+ * currently we leave module owner NULL
+ */
+static struct gss_api_mech gss_null_mech = {
+	.gm_owner       = NULL, /*THIS_MODULE, */
+	.gm_name        = "gssnull",
+	.gm_oid         = (rawobj_t) {
+		12,
+		"\053\006\001\004\001\311\146\215\126\001\000\000"
+	},
+	.gm_ops         = &gss_null_ops,
+	.gm_sf_num      = 1,
+	.gm_sfs         = gss_null_sfs,
+};
+
+int __init init_null_module(void)
+{
+	int status;
+
+	status = lgss_mech_register(&gss_null_mech);
+	if (status)
+		CERROR("Failed to register null gss mechanism!\n");
+
+	return status;
+}
+
+void cleanup_null_module(void)
+{
+	lgss_mech_unregister(&gss_null_mech);
+}
diff --git a/drivers/staging/lustre/lustre/ptlrpc/gss/sec_gss.c b/drivers/staging/lustre/lustre/ptlrpc/gss/sec_gss.c
index 383601c..a3b4b21 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/gss/sec_gss.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/gss/sec_gss.c
@@ -2832,10 +2832,14 @@ int __init sptlrpc_gss_init(void)
 	if (rc)
 		goto out_cli_upcall;
 
-	rc = init_kerberos_module();
+	rc = init_null_module();
 	if (rc)
 		goto out_svc_upcall;
 
+	rc = init_kerberos_module();
+	if (rc)
+		goto out_null;
+
 	/* register policy after all other stuff be initialized, because it
 	 * might be in used immediately after the registration. */
 
@@ -2860,6 +2864,8 @@ out_keyring:
 
 out_kerberos:
 	cleanup_kerberos_module();
+out_null:
+	cleanup_null_module();
 out_svc_upcall:
 	gss_exit_svc_upcall();
 out_cli_upcall:
diff --git a/drivers/staging/lustre/lustre/ptlrpc/sec.c b/drivers/staging/lustre/lustre/ptlrpc/sec.c
index 5e75392..639791c 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/sec.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/sec.c
@@ -157,6 +157,8 @@ __u32 sptlrpc_name2flavor_base(const char *name)
 		return SPTLRPC_FLVR_NULL;
 	if (!strcmp(name, "plain"))
 		return SPTLRPC_FLVR_PLAIN;
+	if (!strcmp(name, "gssnull"))
+		return SPTLRPC_FLVR_GSSNULL;
 	if (!strcmp(name, "krb5n"))
 		return SPTLRPC_FLVR_KRB5N;
 	if (!strcmp(name, "krb5a"))
@@ -178,6 +180,8 @@ const char *sptlrpc_flavor2name_base(__u32 flvr)
 		return "null";
 	else if (base == SPTLRPC_FLVR_BASE(SPTLRPC_FLVR_PLAIN))
 		return "plain";
+	else if (base == SPTLRPC_FLVR_BASE(SPTLRPC_FLVR_GSSNULL))
+		return "gssnull";
 	else if (base == SPTLRPC_FLVR_BASE(SPTLRPC_FLVR_KRB5N))
 		return "krb5n";
 	else if (base == SPTLRPC_FLVR_BASE(SPTLRPC_FLVR_KRB5A))
-- 
1.8.5.3

