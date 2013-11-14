Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055Ab3KNQjY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:39:24 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:43817 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755919Ab3KNQi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:38:58 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Andreas Dilger <andreas.dilger@intel.com>,
        Dmitry Eremin <dmitry.eremin@intel.com>, Peng Tao <bergwolf@gmail.com>
Subject: [PATCH 07/39] staging/lustre/osd-ldiskfs: remove dependency on mdd module
Date: Fri, 15 Nov 2013 00:32:30 +0800
Message-Id: <1384446782-13741-8-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
References: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Dilger <andreas.dilger@intel.com>

Move the lu_capainfo_get() function (formerly named md_capainfo())
into obdclass/capa.c instead of mdd_device.c.  Otherwise, the
osd-ldiskfs.ko module depends on mdd.ko in order to load, and that
doesn't really make sense.

Move the lu_capainfo structure (formerly named md_capainfo) into
lustre_capa.h, and change the structure field prefix to match the
new name.  Fix up the users of this structure/function, and do some
code style cleanup in those functions at the same time.

Move the mdt_set_capainfo() and mdt_dump_capainfo() structures from
being static inline in mdt_internal.h into mdt_lib.c, since they are
too big to be static inline functions.  mdt_dump_capainfo() isn't
used anywhere, so it is put under #ifdef DEBUG_CAPA.  They should
really be named mdt_capainfo_{set,dump}(), but that was too big a
change for this patch.

Lustre-change: http://review.whamcloud.com/6945
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3556
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Dmitry Eremin <dmitry.eremin@intel.com>
Reviewed-by: Alex Zhuravlev <alexey.zhuravlev@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../staging/lustre/lustre/include/lustre_capa.h    |   25 ++++++++++--
 drivers/staging/lustre/lustre/include/md_object.h  |   20 ----------
 drivers/staging/lustre/lustre/obdclass/capa.c      |   41 ++++++++++++++++++++
 drivers/staging/lustre/lustre/obdclass/class_obd.c |    5 +++
 4 files changed, 67 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre_capa.h b/drivers/staging/lustre/lustre/include/lustre_capa.h
index d77bffc..3d608ed 100644
--- a/drivers/staging/lustre/lustre/include/lustre_capa.h
+++ b/drivers/staging/lustre/lustre/include/lustre_capa.h
@@ -292,14 +292,31 @@ struct filter_capa_key {
 	struct lustre_capa_key  k_key;
 };
 
-enum {
-	LC_ID_NONE      = 0,
-	LC_ID_PLAIN     = 1,
-	LC_ID_CONVERT   = 2
+enum lc_auth_id {
+	LC_ID_NONE	= 0,
+	LC_ID_PLAIN	= 1,
+	LC_ID_CONVERT	= 2
 };
 
 #define BYPASS_CAPA (struct lustre_capa *)ERR_PTR(-ENOENT)
 
+enum {
+	LU_CAPAINFO_MAX = 5
+};
+
+/** there are at most 5 FIDs in one operation, see rename,
+ *  NOTE the last one is a temporary one used for is_subdir() */
+struct lu_capainfo {
+	enum lc_auth_id		 lci_auth;
+	__u32			 lci_padding;
+	struct lu_fid		 lci_fid[LU_CAPAINFO_MAX];
+	struct lustre_capa	*lci_capa[LU_CAPAINFO_MAX];
+};
+
+int  lu_capainfo_init(void);
+void lu_capainfo_fini(void);
+struct lu_capainfo *lu_capainfo_get(const struct lu_env *env);
+
 /** @} capa */
 
 #endif /* __LINUX_CAPA_H_ */
diff --git a/drivers/staging/lustre/lustre/include/md_object.h b/drivers/staging/lustre/lustre/include/md_object.h
index 7b45b47..a25a5a3 100644
--- a/drivers/staging/lustre/lustre/include/md_object.h
+++ b/drivers/staging/lustre/lustre/include/md_object.h
@@ -70,30 +70,10 @@ enum {
 	UCRED_NEW       = 2
 };
 
-enum {
-	MD_CAPAINFO_MAX = 5
-};
-
-/** there are at most 5 fids in one operation, see rename, NOTE the last one
- * is a temporary one used for is_subdir() */
-struct md_capainfo {
-	__u32		   mc_auth;
-	__u32		   mc_padding;
-	struct lu_fid	   mc_fid[MD_CAPAINFO_MAX];
-	struct lustre_capa     *mc_capa[MD_CAPAINFO_MAX];
-};
-
 struct md_quota {
 	struct obd_export       *mq_exp;
 };
 
-/**
- * Implemented in mdd/mdd_handler.c.
- *
- * XXX should be moved into separate .h/.c together with all md security
- * related definitions.
- */
-struct md_capainfo *md_capainfo(const struct lu_env *env);
 struct md_quota *md_quota(const struct lu_env *env);
 
 /** metadata attributes */
diff --git a/drivers/staging/lustre/lustre/obdclass/capa.c b/drivers/staging/lustre/lustre/obdclass/capa.c
index 68d797b..63981d0 100644
--- a/drivers/staging/lustre/lustre/obdclass/capa.c
+++ b/drivers/staging/lustre/lustre/obdclass/capa.c
@@ -416,3 +416,44 @@ void _debug_capa(struct lustre_capa *c,
 	va_end(args);
 }
 EXPORT_SYMBOL(_debug_capa);
+
+/*
+ * context key constructor/destructor:
+ * lu_capainfo_key_init, lu_capainfo_key_fini
+ */
+LU_KEY_INIT_FINI(lu_capainfo, struct lu_capainfo);
+
+struct lu_context_key lu_capainfo_key = {
+	.lct_tags = LCT_SESSION,
+	.lct_init = lu_capainfo_key_init,
+	.lct_fini = lu_capainfo_key_fini
+};
+
+struct lu_capainfo *lu_capainfo_get(const struct lu_env *env)
+{
+	/* NB, in mdt_init0 */
+	if (env->le_ses == NULL)
+		return NULL;
+	return lu_context_key_get(env->le_ses, &lu_capainfo_key);
+}
+EXPORT_SYMBOL(lu_capainfo_get);
+
+/**
+ * Initialization of lu_capainfo_key data.
+ */
+int lu_capainfo_init(void)
+{
+	int rc;
+
+	LU_CONTEXT_KEY_INIT(&lu_capainfo_key);
+	rc = lu_context_key_register(&lu_capainfo_key);
+	return rc;
+}
+
+/**
+ * Dual to lu_capainfo_init().
+ */
+void lu_capainfo_fini(void)
+{
+	lu_context_key_degister(&lu_capainfo_key);
+}
diff --git a/drivers/staging/lustre/lustre/obdclass/class_obd.c b/drivers/staging/lustre/lustre/obdclass/class_obd.c
index 4afd962..8d2c6a8 100644
--- a/drivers/staging/lustre/lustre/obdclass/class_obd.c
+++ b/drivers/staging/lustre/lustre/obdclass/class_obd.c
@@ -572,6 +572,10 @@ static int __init init_obdclass(void)
 	if (err)
 		return err;
 
+	err = lu_capainfo_init();
+	if (err)
+		return err;
+
 	err = cl_global_init();
 	if (err != 0)
 		return err;
@@ -651,6 +655,7 @@ static void cleanup_obdclass(void)
 	}
 	llog_info_fini();
 	cl_global_fini();
+	lu_capainfo_fini();
 	lu_global_fini();
 
 	obd_cleanup_caches();
-- 
1.7.9.5

