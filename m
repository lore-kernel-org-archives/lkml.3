Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758093Ab3BFTtb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 14:49:31 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:63448 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755031Ab3BFTtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:49:23 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/77] idr: make idr_destroy() imply idr_remove_all()
Date: Wed,  6 Feb 2013 11:39:34 -0800
Message-Id: <1360179649-22465-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360179649-22465-1-git-send-email-tj@kernel.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

idr is silly in quite a few ways, one of which is how it's supposed to
be destroyed - idr_destroy() doesn't release IDs and doesn't even
whine if the idr isn't empty.  If the caller forgets idr_remove_all(),
it simply leaks memory.

Even ida gets this wrong and leaks memory on destruction.  There is
absoltely no reason not to call idr_remove_all() from idr_destroy().
Nobody is abusing idr_destroy() for shrinking free layer buffer and
continues to use idr after idr_destroy(), so it's safe to do
remove_all from destroy.

In the whole kernel, there is only one place where idr_remove_all() is
legitimiately used without following idr_destroy() while there are
quite a few places where the caller forgets either idr_remove_all() or
idr_destroy() leaking memory.

This patch makes idr_destroy() call idr_destroy_all() and updates the
function description accordingly.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 lib/idr.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/lib/idr.c b/lib/idr.c
index ca5aa00..b8602e0 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -436,15 +436,6 @@ EXPORT_SYMBOL(idr_remove);
 /**
  * idr_remove_all - remove all ids from the given idr tree
  * @idp: idr handle
- *
- * idr_destroy() only frees up unused, cached idp_layers, but this
- * function will remove all id mappings and leave all idp_layers
- * unused.
- *
- * A typical clean-up sequence for objects stored in an idr tree will
- * use idr_for_each() to free all objects, if necessay, then
- * idr_remove_all() to remove all ids, and idr_destroy() to free
- * up the cached idr_layers.
  */
 void idr_remove_all(struct idr *idp)
 {
@@ -484,9 +475,20 @@ EXPORT_SYMBOL(idr_remove_all);
 /**
  * idr_destroy - release all cached layers within an idr tree
  * @idp: idr handle
+ *
+ * Free all id mappings and all idp_layers.  After this function, @idp is
+ * completely unused and can be freed / recycled.  The caller is
+ * responsible for ensuring that no one else accesses @idp during or after
+ * idr_destroy().
+ *
+ * A typical clean-up sequence for objects stored in an idr tree will use
+ * idr_for_each() to free all objects, if necessay, then idr_destroy() to
+ * free up the id mappings and cached idr_layers.
  */
 void idr_destroy(struct idr *idp)
 {
+	idr_remove_all(idp);
+
 	while (idp->id_free_cnt) {
 		struct idr_layer *p = get_from_free_list(idp);
 		kmem_cache_free(idr_layer_cache, p);
-- 
1.8.1

