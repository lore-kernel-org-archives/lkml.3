Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956Ab3HUV3X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 17:29:23 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:62138 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781Ab3HUV3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 17:29:19 -0400
Date: Wed, 21 Aug 2013 17:29:21 -0400
From: Hongyi Jia <milosz@adfin.com>
To: ceph-devel@vger.kernel.org
Cc: sage@inktank.com, zheng.z.yan@intel.com, dhowells@redhat.com,
        linux-cachefs@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] new cachefiles interface to check cache consistency
Message-ID: <f4fc963045ec8fe36c8793a599b772c2af1f149f.1375999914.git.milosz@adfin.com>
References: <cover.1375999914.git.milosz@adfin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1375999914.git.milosz@adfin.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Hongyi Jia <jiayisuse@gmail.com>
Tested-by: Milosz Tanski <milosz@adfin.com>
---
 fs/cachefiles/interface.c | 19 +++++++++++++++++++
 fs/cachefiles/internal.h  |  1 +
 fs/cachefiles/xattr.c     | 39 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 59 insertions(+)

diff --git a/fs/cachefiles/interface.c b/fs/cachefiles/interface.c
index d4c1206..0805f23 100644
--- a/fs/cachefiles/interface.c
+++ b/fs/cachefiles/interface.c
@@ -378,6 +378,24 @@ static void cachefiles_sync_cache(struct fscache_cache *_cache)
 }
 
 /*
+ * check if the backing cache is updated to FS-Cache
+ * - called by FS-Cache when evaluates if need to invalidate the cache
+ */
+static bool cachefiles_check_consistency(struct fscache_object *_object)
+{
+	struct cachefiles_object *object;
+	int ret;
+
+	_enter("{OBJ%x}", _object->debug_id);
+
+	object = container_of(_object, struct cachefiles_object, fscache);
+	ret = cachefiles_check_auxdata(object);
+
+	_leave(" = %d", ret);
+	return ret;
+}
+
+/*
  * notification the attributes on an object have changed
  * - called with reads/writes excluded by FS-Cache
  */
@@ -522,4 +540,5 @@ const struct fscache_cache_ops cachefiles_cache_ops = {
 	.write_page		= cachefiles_write_page,
 	.uncache_page		= cachefiles_uncache_page,
 	.dissociate_pages	= cachefiles_dissociate_pages,
+	.check_consistency	= cachefiles_check_consistency,
 };
diff --git a/fs/cachefiles/internal.h b/fs/cachefiles/internal.h
index 4938251..e102d22 100644
--- a/fs/cachefiles/internal.h
+++ b/fs/cachefiles/internal.h
@@ -239,6 +239,7 @@ extern int cachefiles_check_object_xattr(struct cachefiles_object *object,
 					 struct cachefiles_xattr *auxdata);
 extern int cachefiles_remove_object_xattr(struct cachefiles_cache *cache,
 					  struct dentry *dentry);
+extern bool cachefiles_check_auxdata(struct cachefiles_object *object);
 
 
 /*
diff --git a/fs/cachefiles/xattr.c b/fs/cachefiles/xattr.c
index 2476e51..aafaac3 100644
--- a/fs/cachefiles/xattr.c
+++ b/fs/cachefiles/xattr.c
@@ -157,6 +157,45 @@ int cachefiles_update_object_xattr(struct cachefiles_object *object,
 }
 
 /*
+ * check the consistency between the backing cache and the FS-Cache cookie
+ */
+bool cachefiles_check_auxdata(struct cachefiles_object *object)
+{
+	struct cachefiles_xattr *auxbuf;
+	struct dentry *dentry = object->dentry;
+	unsigned int dlen;
+	int ret;
+
+	ASSERT(dentry);
+	ASSERT(dentry->d_inode);
+
+	auxbuf = kmalloc(sizeof(struct cachefiles_xattr) + 512, GFP_KERNEL);
+	if (!auxbuf)
+		return false;
+
+	auxbuf->len = vfs_getxattr(dentry, cachefiles_xattr_cache,
+			&auxbuf->type, 512 + 1);
+	if (auxbuf->len < 1)
+		return false;
+
+	if (auxbuf->type != object->fscache.cookie->def->type)
+		return false;
+
+	if (!object->fscache.cookie->def->check_aux)
+		return false;
+
+	dlen = auxbuf->len - 1;
+	ret = fscache_check_aux(&object->fscache,
+			&auxbuf->data, dlen);
+
+	kfree(auxbuf);
+	if (ret == FSCACHE_CHECKAUX_OKAY)
+		return true;
+	else
+		return false;
+}
+
+/*
  * check the state xattr on a cache file
  * - return -ESTALE if the object should be deleted
  */
-- 
1.8.1.2

