Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180Ab3BFUJI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 15:09:08 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:45999 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758133Ab3BFTtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:49:46 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 15/77] idr: deprecate idr_remove_all()
Date: Wed,  6 Feb 2013 11:39:47 -0800
Message-Id: <1360179649-22465-16-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360179649-22465-1-git-send-email-tj@kernel.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There was only one legitimate use of idr_remove_all() and a lot more
of incorrect uses (or lack of it).  Now that idr_destroy() implies
idr_remove_all() and all the in-kernel users updated not to use it,
there's no reason to keep it around.  Mark it deprecated so that we
can later unexport it.

idr_remove_all() is made an inline function calling __idr_remove_all()
to avoid triggering deprecated warning on EXPORT_SYMBOL().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/idr.h | 14 +++++++++++++-
 lib/idr.c           | 10 +++-------
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/include/linux/idr.h b/include/linux/idr.h
index de7e190..1b932e7 100644
--- a/include/linux/idr.h
+++ b/include/linux/idr.h
@@ -110,10 +110,22 @@ int idr_for_each(struct idr *idp,
 void *idr_get_next(struct idr *idp, int *nextid);
 void *idr_replace(struct idr *idp, void *ptr, int id);
 void idr_remove(struct idr *idp, int id);
-void idr_remove_all(struct idr *idp);
 void idr_destroy(struct idr *idp);
 void idr_init(struct idr *idp);
 
+void __idr_remove_all(struct idr *idp);	/* don't use */
+
+/**
+ * idr_remove_all - remove all ids from the given idr tree
+ * @idp: idr handle
+ *
+ * If you're trying to destroy @idp, calling idr_destroy() is enough.
+ * This is going away.  Don't use.
+ */
+static inline void __deprecated idr_remove_all(struct idr *idp)
+{
+	__idr_remove_all(idp);
+}
 
 /*
  * IDA - IDR based id allocator, use when translation from id to
diff --git a/lib/idr.c b/lib/idr.c
index b8602e0..814c53c 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -433,11 +433,7 @@ void idr_remove(struct idr *idp, int id)
 }
 EXPORT_SYMBOL(idr_remove);
 
-/**
- * idr_remove_all - remove all ids from the given idr tree
- * @idp: idr handle
- */
-void idr_remove_all(struct idr *idp)
+void __idr_remove_all(struct idr *idp)
 {
 	int n, id, max;
 	int bt_mask;
@@ -470,7 +466,7 @@ void idr_remove_all(struct idr *idp)
 	}
 	idp->layers = 0;
 }
-EXPORT_SYMBOL(idr_remove_all);
+EXPORT_SYMBOL(__idr_remove_all);
 
 /**
  * idr_destroy - release all cached layers within an idr tree
@@ -487,7 +483,7 @@ EXPORT_SYMBOL(idr_remove_all);
  */
 void idr_destroy(struct idr *idp)
 {
-	idr_remove_all(idp);
+	__idr_remove_all(idp);
 
 	while (idp->id_free_cnt) {
 		struct idr_layer *p = get_from_free_list(idp);
-- 
1.8.1

