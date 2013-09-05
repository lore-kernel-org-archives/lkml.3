Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab3IEWV2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 18:21:28 -0400
Received: from mail-qe0-f41.google.com ([209.85.128.41]:54004 "EHLO
	mail-qe0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859Ab3IEWV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 18:21:26 -0400
Date: Thu, 5 Sep 2013 18:21:24 -0400
From: David Howells <milosz@adfin.com>
To: ceph-devel@vger.kernel.org
Cc: sage@inktank.com, zheng.z.yan@intel.com, dhowells@redhat.com,
        jiayisuse@gmail.com, linux-cachefs@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] CacheFiles: Implement interface to check cache
 consistency
Message-ID: <d17d0271a4fc090bed7fea903187f02a35def6a3.1378418255.git.milosz@adfin.com>
References: <cover.1378418255.git.milosz@adfin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1378418255.git.milosz@adfin.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement the FS-Cache interface to check the consistency of a cache object in
CacheFiles.

Original-author: Hongyi Jia <jiayisuse@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Hongyi Jia <jiayisuse@gmail.com>
cc: Milosz Tanski <milosz@adfin.com>
---
 fs/cachefiles/interface.c |   26 ++++++++++++++++++++++++++
 fs/cachefiles/internal.h  |    1 +
 fs/cachefiles/xattr.c     |   36 ++++++++++++++++++++++++++++++++++++
 3 files changed, 63 insertions(+)

diff --git a/fs/cachefiles/interface.c b/fs/cachefiles/interface.c
index d4c1206..43eb559 100644
--- a/fs/cachefiles/interface.c
+++ b/fs/cachefiles/interface.c
@@ -378,6 +378,31 @@ static void cachefiles_sync_cache(struct fscache_cache *_cache)
 }
 
 /*
+ * check if the backing cache is updated to FS-Cache
+ * - called by FS-Cache when evaluates if need to invalidate the cache
+ */
+static bool cachefiles_check_consistency(struct fscache_operation *op)
+{
+	struct cachefiles_object *object;
+	struct cachefiles_cache *cache;
+	const struct cred *saved_cred;
+	int ret;
+
+	_enter("{OBJ%x}", op->object->debug_id);
+
+	object = container_of(op->object, struct cachefiles_object, fscache);
+	cache = container_of(object->fscache.cache,
+			     struct cachefiles_cache, cache);
+
+	cachefiles_begin_secure(cache, &saved_cred);
+	ret = cachefiles_check_auxdata(object);
+	cachefiles_end_secure(cache, saved_cred);
+
+	_leave(" = %d", ret);
+	return ret;
+}
+
+/*
  * notification the attributes on an object have changed
  * - called with reads/writes excluded by FS-Cache
  */
@@ -522,4 +547,5 @@ const struct fscache_cache_ops cachefiles_cache_ops = {
 	.write_page		= cachefiles_write_page,
 	.uncache_page		= cachefiles_uncache_page,
 	.dissociate_pages	= cachefiles_dissociate_pages,
+	.check_consistency	= cachefiles_check_consistency,
 };
diff --git a/fs/cachefiles/internal.h b/fs/cachefiles/internal.h
index 4938251..5349473 100644
--- a/fs/cachefiles/internal.h
+++ b/fs/cachefiles/internal.h
@@ -235,6 +235,7 @@ extern int cachefiles_set_object_xattr(struct cachefiles_object *object,
 				       struct cachefiles_xattr *auxdata);
 extern int cachefiles_update_object_xattr(struct cachefiles_object *object,
 					  struct cachefiles_xattr *auxdata);
+extern int cachefiles_check_auxdata(struct cachefiles_object *object);
 extern int cachefiles_check_object_xattr(struct cachefiles_object *object,
 					 struct cachefiles_xattr *auxdata);
 extern int cachefiles_remove_object_xattr(struct cachefiles_cache *cache,
diff --git a/fs/cachefiles/xattr.c b/fs/cachefiles/xattr.c
index 2476e51..34c88b8 100644
--- a/fs/cachefiles/xattr.c
+++ b/fs/cachefiles/xattr.c
@@ -157,6 +157,42 @@ int cachefiles_update_object_xattr(struct cachefiles_object *object,
 }
 
 /*
+ * check the consistency between the backing cache and the FS-Cache cookie
+ */
+int cachefiles_check_auxdata(struct cachefiles_object *object)
+{
+	struct cachefiles_xattr *auxbuf;
+	struct dentry *dentry = object->dentry;
+	unsigned int dlen;
+	int ret;
+
+	ASSERT(dentry);
+	ASSERT(dentry->d_inode);
+	ASSERT(object->fscache.cookie->def->check_aux);
+
+	auxbuf = kmalloc(sizeof(struct cachefiles_xattr) + 512, GFP_KERNEL);
+	if (!auxbuf)
+		return -ENOMEM;
+
+	auxbuf->len = vfs_getxattr(dentry, cachefiles_xattr_cache,
+				   &auxbuf->type, 512 + 1);
+	if (auxbuf->len < 1)
+		return -ESTALE;
+
+	if (auxbuf->type != object->fscache.cookie->def->type)
+		return -ESTALE;
+
+	dlen = auxbuf->len - 1;
+	ret = fscache_check_aux(&object->fscache, &auxbuf->data, dlen);
+
+	kfree(auxbuf);
+	if (ret != FSCACHE_CHECKAUX_OKAY)
+		return -ESTALE;
+
+	return 0;
+}
+
+/*
  * check the state xattr on a cache file
  * - return -ESTALE if the object should be deleted
  */
-- 
1.7.9.5

