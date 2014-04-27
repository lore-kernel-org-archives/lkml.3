Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbaD0RY3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 13:24:29 -0400
Received: from linuxhacker.ru ([217.76.32.60]:47963 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753269AbaD0RHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 13:07:42 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Andrew Korty <ajk@iu.edu>, Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 04/47] staging/lustre/gss: Shared key mechanism & flavors
Date: Sun, 27 Apr 2014 13:06:28 -0400
Message-Id: <1398618431-29757-5-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
References: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Korty <ajk@iu.edu>

Implement security flavors and GSSAPI mechanism to perform shared key
authentication (ski) and encryption (skpi).

Signed-off-by: Andrew Korty <ajk@iu.edu>
Reviewed-on: http://review.whamcloud.com/8629
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3289
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: Ken Hornstein <kenh@cmf.nrl.navy.mil>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/include/lustre_sec.h |  17 ++
 drivers/staging/lustre/lustre/ptlrpc/gss/Makefile  |   3 +-
 .../lustre/lustre/ptlrpc/gss/gss_internal.h        |   3 +
 .../staging/lustre/lustre/ptlrpc/gss/gss_sk_mech.c | 226 +++++++++++++++++++++
 drivers/staging/lustre/lustre/ptlrpc/gss/sec_gss.c |   8 +-
 drivers/staging/lustre/lustre/ptlrpc/sec.c         |   8 +
 6 files changed, 263 insertions(+), 2 deletions(-)
 create mode 100644 drivers/staging/lustre/lustre/ptlrpc/gss/gss_sk_mech.c

diff --git a/drivers/staging/lustre/lustre/include/lustre_sec.h b/drivers/staging/lustre/lustre/include/lustre_sec.h
index 40d463f..e46c0e5 100644
--- a/drivers/staging/lustre/lustre/include/lustre_sec.h
+++ b/drivers/staging/lustre/lustre/include/lustre_sec.h
@@ -103,6 +103,7 @@ enum sptlrpc_mech_plain {
 enum sptlrpc_mech_gss {
 	SPTLRPC_MECH_GSS_NULL	   = 0,
 	SPTLRPC_MECH_GSS_KRB5	   = 1,
+	SPTLRPC_MECH_GSS_SK             = 2,
 	SPTLRPC_MECH_GSS_MAX,
 };
 
@@ -180,6 +181,10 @@ enum sptlrpc_bulk_service {
 	MAKE_BASE_SUBFLVR(SPTLRPC_MECH_GSS_KRB5, SPTLRPC_SVC_INTG)
 #define SPTLRPC_SUBFLVR_KRB5P					   \
 	MAKE_BASE_SUBFLVR(SPTLRPC_MECH_GSS_KRB5, SPTLRPC_SVC_PRIV)
+#define SPTLRPC_SUBFLVR_SKI                                             \
+	MAKE_BASE_SUBFLVR(SPTLRPC_MECH_GSS_SK, SPTLRPC_SVC_INTG)
+#define SPTLRPC_SUBFLVR_SKPI                                            \
+	MAKE_BASE_SUBFLVR(SPTLRPC_MECH_GSS_SK, SPTLRPC_SVC_PRIV)
 
 /*
  * "end user" flavors
@@ -226,6 +231,18 @@ enum sptlrpc_bulk_service {
 		  SPTLRPC_SVC_PRIV,		     \
 		  SPTLRPC_BULK_DEFAULT,		 \
 		  SPTLRPC_BULK_SVC_PRIV)
+#define SPTLRPC_FLVR_SKI                                \
+	MAKE_FLVR(SPTLRPC_POLICY_GSS,                   \
+		  SPTLRPC_MECH_GSS_SK,                  \
+		  SPTLRPC_SVC_INTG,                     \
+		  SPTLRPC_BULK_DEFAULT,                 \
+		  SPTLRPC_BULK_SVC_PRIV)
+#define SPTLRPC_FLVR_SKPI                               \
+	MAKE_FLVR(SPTLRPC_POLICY_GSS,                   \
+		  SPTLRPC_MECH_GSS_SK,                  \
+		  SPTLRPC_SVC_PRIV,                     \
+		  SPTLRPC_BULK_DEFAULT,                 \
+		  SPTLRPC_BULK_SVC_PRIV)
 
 #define SPTLRPC_FLVR_DEFAULT	    SPTLRPC_FLVR_NULL
 
diff --git a/drivers/staging/lustre/lustre/ptlrpc/gss/Makefile b/drivers/staging/lustre/lustre/ptlrpc/gss/Makefile
index ab16596..bf16b97 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/gss/Makefile
+++ b/drivers/staging/lustre/lustre/ptlrpc/gss/Makefile
@@ -2,7 +2,8 @@ obj-$(CONFIG_LUSTRE_FS) := ptlrpc_gss.o
 
 ptlrpc_gss-y := sec_gss.o gss_bulk.o gss_cli_upcall.o gss_svc_upcall.o	\
 		gss_rawobj.o lproc_gss.o gss_generic_token.o		\
-		gss_mech_switch.o gss_krb5_mech.o gss_null_mech.o
+		gss_mech_switch.o gss_krb5_mech.o gss_null_mech.o	\
+		gss_sk_mech.o
 
 
 ccflags-y := -I$(src)/../include
diff --git a/drivers/staging/lustre/lustre/ptlrpc/gss/gss_internal.h b/drivers/staging/lustre/lustre/ptlrpc/gss/gss_internal.h
index 1a0c7d5..a693a4a 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/gss/gss_internal.h
+++ b/drivers/staging/lustre/lustre/ptlrpc/gss/gss_internal.h
@@ -506,6 +506,9 @@ void cleanup_null_module(void);
 int __init init_kerberos_module(void);
 void __exit cleanup_kerberos_module(void);
 
+/* gss_sk_mech.c */
+int __init init_sk_module(void);
+void cleanup_sk_module(void);
 
 /* debug */
 static inline
diff --git a/drivers/staging/lustre/lustre/ptlrpc/gss/gss_sk_mech.c b/drivers/staging/lustre/lustre/ptlrpc/gss/gss_sk_mech.c
new file mode 100644
index 0000000..df31b18
--- /dev/null
+++ b/drivers/staging/lustre/lustre/ptlrpc/gss/gss_sk_mech.c
@@ -0,0 +1,226 @@
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
+struct sk_ctx {
+};
+
+static
+__u32 gss_import_sec_context_sk(rawobj_t *inbuf, struct gss_ctx *gss_context)
+{
+	struct sk_ctx *sk_context;
+
+	if (inbuf == NULL || inbuf->data == NULL)
+		return GSS_S_FAILURE;
+
+	OBD_ALLOC_PTR(sk_context);
+	if (sk_context == NULL)
+		return GSS_S_FAILURE;
+
+	gss_context->internal_ctx_id = sk_context;
+	CDEBUG(D_SEC, "succesfully imported sk context\n");
+
+	return GSS_S_COMPLETE;
+}
+
+static
+__u32 gss_copy_reverse_context_sk(struct gss_ctx *gss_context_old,
+				    struct gss_ctx *gss_context_new)
+{
+	struct sk_ctx *sk_context_old;
+	struct sk_ctx *sk_context_new;
+
+	OBD_ALLOC_PTR(sk_context_new);
+	if (sk_context_new == NULL)
+		return GSS_S_FAILURE;
+
+	sk_context_old = gss_context_old->internal_ctx_id;
+	memcpy(sk_context_new, sk_context_old, sizeof(*sk_context_new));
+	gss_context_new->internal_ctx_id = sk_context_new;
+	CDEBUG(D_SEC, "succesfully copied reverse sk context\n");
+
+	return GSS_S_COMPLETE;
+}
+
+static
+__u32 gss_inquire_context_sk(struct gss_ctx *gss_context,
+			       unsigned long *endtime)
+{
+	*endtime = 0;
+	return GSS_S_COMPLETE;
+}
+
+static
+__u32 gss_get_mic_sk(struct gss_ctx *gss_context,
+		     int message_count,
+		     rawobj_t *messages,
+		     int iov_count,
+		     lnet_kiov_t *iovs,
+		     rawobj_t *token)
+{
+	token->data = NULL;
+	token->len = 0;
+
+	return GSS_S_COMPLETE;
+}
+
+static
+__u32 gss_verify_mic_sk(struct gss_ctx *gss_context,
+			int message_count,
+			rawobj_t *messages,
+			int iov_count,
+			lnet_kiov_t *iovs,
+			rawobj_t *token)
+{
+	return GSS_S_COMPLETE;
+}
+
+static
+__u32 gss_wrap_sk(struct gss_ctx *gss_context, rawobj_t *gss_header,
+		    rawobj_t *message, int message_buffer_length,
+		    rawobj_t *token)
+{
+	return GSS_S_COMPLETE;
+}
+
+static
+__u32 gss_unwrap_sk(struct gss_ctx *gss_context, rawobj_t *gss_header,
+		      rawobj_t *token, rawobj_t *message)
+{
+	return GSS_S_COMPLETE;
+}
+
+static
+__u32 gss_prep_bulk_sk(struct gss_ctx *gss_context,
+			 struct ptlrpc_bulk_desc *desc)
+{
+	return GSS_S_COMPLETE;
+}
+
+static
+__u32 gss_wrap_bulk_sk(struct gss_ctx *gss_context,
+			 struct ptlrpc_bulk_desc *desc, rawobj_t *token,
+			 int adj_nob)
+{
+	return GSS_S_COMPLETE;
+}
+
+static
+__u32 gss_unwrap_bulk_sk(struct gss_ctx *gss_context,
+			   struct ptlrpc_bulk_desc *desc,
+			   rawobj_t *token, int adj_nob)
+{
+	return GSS_S_COMPLETE;
+}
+
+static
+void gss_delete_sec_context_sk(void *internal_context)
+{
+	struct sk_ctx *sk_context = internal_context;
+
+	OBD_FREE_PTR(sk_context);
+}
+
+int gss_display_sk(struct gss_ctx *gss_context, char *buf, int bufsize)
+{
+	return snprintf(buf, bufsize, "sk");
+}
+
+static struct gss_api_ops gss_sk_ops = {
+	.gss_import_sec_context     = gss_import_sec_context_sk,
+	.gss_copy_reverse_context   = gss_copy_reverse_context_sk,
+	.gss_inquire_context        = gss_inquire_context_sk,
+	.gss_get_mic                = gss_get_mic_sk,
+	.gss_verify_mic             = gss_verify_mic_sk,
+	.gss_wrap                   = gss_wrap_sk,
+	.gss_unwrap                 = gss_unwrap_sk,
+	.gss_prep_bulk              = gss_prep_bulk_sk,
+	.gss_wrap_bulk              = gss_wrap_bulk_sk,
+	.gss_unwrap_bulk            = gss_unwrap_bulk_sk,
+	.gss_delete_sec_context     = gss_delete_sec_context_sk,
+	.gss_display                = gss_display_sk,
+};
+
+static struct subflavor_desc gss_sk_sfs[] = {
+	{
+		.sf_subflavor   = SPTLRPC_SUBFLVR_SKI,
+		.sf_qop         = 0,
+		.sf_service     = SPTLRPC_SVC_INTG,
+		.sf_name        = "ski"
+	},
+	{
+		.sf_subflavor   = SPTLRPC_SUBFLVR_SKPI,
+		.sf_qop         = 0,
+		.sf_service     = SPTLRPC_SVC_PRIV,
+		.sf_name        = "skpi"
+	},
+};
+
+/*
+ * currently we leave module owner NULL
+ */
+static struct gss_api_mech gss_sk_mech = {
+	.gm_owner       = NULL, /*THIS_MODULE, */
+	.gm_name        = "sk",
+	.gm_oid         = (rawobj_t) {
+		12,
+		"\053\006\001\004\001\311\146\215\126\001\000\001",
+	},
+	.gm_ops         = &gss_sk_ops,
+	.gm_sf_num      = 2,
+	.gm_sfs         = gss_sk_sfs,
+};
+
+int __init init_sk_module(void)
+{
+	int status;
+
+	status = lgss_mech_register(&gss_sk_mech);
+	if (status)
+		CERROR("Failed to register sk gss mechanism!\n");
+
+	return status;
+}
+
+void cleanup_sk_module(void)
+{
+	lgss_mech_unregister(&gss_sk_mech);
+}
diff --git a/drivers/staging/lustre/lustre/ptlrpc/gss/sec_gss.c b/drivers/staging/lustre/lustre/ptlrpc/gss/sec_gss.c
index a3b4b21..91a43d1 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/gss/sec_gss.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/gss/sec_gss.c
@@ -2840,12 +2840,16 @@ int __init sptlrpc_gss_init(void)
 	if (rc)
 		goto out_null;
 
+	rc = init_sk_module();
+	if (rc)
+		goto out_kerberos;
+
 	/* register policy after all other stuff be initialized, because it
 	 * might be in used immediately after the registration. */
 
 	rc = gss_init_keyring();
 	if (rc)
-		goto out_kerberos;
+		goto out_sk;
 
 #ifdef HAVE_GSS_PIPEFS
 	rc = gss_init_pipefs();
@@ -2862,6 +2866,8 @@ out_keyring:
 	gss_exit_keyring();
 #endif
 
+out_sk:
+	cleanup_sk_module();
 out_kerberos:
 	cleanup_kerberos_module();
 out_null:
diff --git a/drivers/staging/lustre/lustre/ptlrpc/sec.c b/drivers/staging/lustre/lustre/ptlrpc/sec.c
index 639791c..a6d0f73 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/sec.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/sec.c
@@ -167,6 +167,10 @@ __u32 sptlrpc_name2flavor_base(const char *name)
 		return SPTLRPC_FLVR_KRB5I;
 	if (!strcmp(name, "krb5p"))
 		return SPTLRPC_FLVR_KRB5P;
+	if (!strcmp(name, "ski"))
+		return SPTLRPC_FLVR_SKI;
+	if (!strcmp(name, "skpi"))
+		return SPTLRPC_FLVR_SKPI;
 
 	return SPTLRPC_FLVR_INVALID;
 }
@@ -190,6 +194,10 @@ const char *sptlrpc_flavor2name_base(__u32 flvr)
 		return "krb5i";
 	else if (base == SPTLRPC_FLVR_BASE(SPTLRPC_FLVR_KRB5P))
 		return "krb5p";
+	else if (base == SPTLRPC_FLVR_BASE(SPTLRPC_FLVR_SKI))
+		return "ski";
+	else if (base == SPTLRPC_FLVR_BASE(SPTLRPC_FLVR_SKPI))
+		return "skpi";
 
 	CERROR("invalid wire flavor 0x%x\n", flvr);
 	return "invalid";
-- 
1.8.5.3

