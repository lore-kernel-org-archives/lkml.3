Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab3KNQQi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:16:38 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:41128 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071Ab3KNQPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:15:41 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "John L. Hammond" <john.hammond@intel.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 19/40] staging/lustre/lu: shrink lu_object by 8 bytes on x86_64
Date: Fri, 15 Nov 2013 00:13:21 +0800
Message-Id: <1384445622-12346-20-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384445622-12346-1-git-send-email-bergwolf@gmail.com>
References: <1384445622-12346-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John L. Hammond" <john.hammond@intel.com>

Remove the lo_depth member from struct lu_object.  This field is never
set and only read in lu_object_print().  Remove the lo_flags member.
This field was only used in lu_object_alloc() and can be replaced with
an on-stack mask to keep trace of which layers have been allocated.

Lustre-change: http://review.whamcloud.com/5890
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3059
Signed-off-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: Alex Zhuravlev <alexey.zhuravlev@intel.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/include/lu_object.h  |   19 ----------------
 drivers/staging/lustre/lustre/obdclass/lu_object.c |   24 +++++++++++++-------
 2 files changed, 16 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lu_object.h b/drivers/staging/lustre/lustre/include/lu_object.h
index d5b8225..6773bca 100644
--- a/drivers/staging/lustre/lustre/include/lu_object.h
+++ b/drivers/staging/lustre/lustre/include/lu_object.h
@@ -398,17 +398,6 @@ static inline int lu_device_is_md(const struct lu_device *d)
 }
 
 /**
- * Flags for the object layers.
- */
-enum lu_object_flags {
-	/**
-	 * this flags is set if lu_object_operations::loo_object_init() has
-	 * been called for this layer. Used by lu_object_alloc().
-	 */
-	LU_OBJECT_ALLOCATED = (1 << 0)
-};
-
-/**
  * Common object attributes.
  */
 struct lu_attr {
@@ -486,14 +475,6 @@ struct lu_object {
 	 */
 	struct list_head			 lo_linkage;
 	/**
-	 * Depth. Top level layer depth is 0.
-	 */
-	int				lo_depth;
-	/**
-	 * Flags from enum lu_object_flags.
-	 */
-	__u32					lo_flags;
-	/**
 	 * Link to the device, for debugging.
 	 */
 	struct lu_ref_link                 lo_dev_ref;
diff --git a/drivers/staging/lustre/lustre/obdclass/lu_object.c b/drivers/staging/lustre/lustre/obdclass/lu_object.c
index 346a7b2..9019fd1 100644
--- a/drivers/staging/lustre/lustre/obdclass/lu_object.c
+++ b/drivers/staging/lustre/lustre/obdclass/lu_object.c
@@ -200,6 +200,8 @@ static struct lu_object *lu_object_alloc(const struct lu_env *env,
 	struct lu_object *scan;
 	struct lu_object *top;
 	struct list_head *layers;
+	unsigned int init_mask = 0;
+	unsigned int init_flag;
 	int clean;
 	int result;
 
@@ -218,15 +220,17 @@ static struct lu_object *lu_object_alloc(const struct lu_env *env,
 	 */
 	top->lo_header->loh_fid = *f;
 	layers = &top->lo_header->loh_layers;
+
 	do {
 		/*
 		 * Call ->loo_object_init() repeatedly, until no more new
 		 * object slices are created.
 		 */
 		clean = 1;
+		init_flag = 1;
 		list_for_each_entry(scan, layers, lo_linkage) {
-			if (scan->lo_flags & LU_OBJECT_ALLOCATED)
-				continue;
+			if (init_mask & init_flag)
+				goto next;
 			clean = 0;
 			scan->lo_header = top->lo_header;
 			result = scan->lo_ops->loo_object_init(env, scan, conf);
@@ -234,7 +238,9 @@ static struct lu_object *lu_object_alloc(const struct lu_env *env,
 				lu_object_free(env, top);
 				return ERR_PTR(result);
 			}
-			scan->lo_flags |= LU_OBJECT_ALLOCATED;
+			init_mask |= init_flag;
+next:
+			init_flag <<= 1;
 		}
 	} while (!clean);
 
@@ -487,23 +493,25 @@ void lu_object_print(const struct lu_env *env, void *cookie,
 {
 	static const char ruler[] = "........................................";
 	struct lu_object_header *top;
-	int depth;
+	int depth = 4;
 
 	top = o->lo_header;
 	lu_object_header_print(env, cookie, printer, top);
-	(*printer)(env, cookie, "{ \n");
-	list_for_each_entry(o, &top->loh_layers, lo_linkage) {
-		depth = o->lo_depth + 4;
+	(*printer)(env, cookie, "{\n");
 
+	list_for_each_entry(o, &top->loh_layers, lo_linkage) {
 		/*
 		 * print `.' \a depth times followed by type name and address
 		 */
 		(*printer)(env, cookie, "%*.*s%s@%p", depth, depth, ruler,
 			   o->lo_dev->ld_type->ldt_name, o);
+
 		if (o->lo_ops->loo_object_print != NULL)
-			o->lo_ops->loo_object_print(env, cookie, printer, o);
+			(*o->lo_ops->loo_object_print)(env, cookie, printer, o);
+
 		(*printer)(env, cookie, "\n");
 	}
+
 	(*printer)(env, cookie, "} header@%p\n", top);
 }
 EXPORT_SYMBOL(lu_object_print);
-- 
1.7.9.5

