Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010Ab3HUV3i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 17:29:38 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:58928 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976Ab3HUV3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 17:29:35 -0400
Date: Wed, 21 Aug 2013 17:29:38 -0400
From: Hongyi Jia <milosz@adfin.com>
To: ceph-devel@vger.kernel.org
Cc: sage@inktank.com, zheng.z.yan@intel.com, dhowells@redhat.com,
        linux-cachefs@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] new fscache interface to check cache consistency
Message-ID: <306cbe63f85921ad40b00e3c7071be19cb6adf04.1375999914.git.milosz@adfin.com>
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
 fs/fscache/cookie.c           | 22 ++++++++++++++++++++++
 include/linux/fscache-cache.h |  4 ++++
 include/linux/fscache.h       | 17 +++++++++++++++++
 3 files changed, 43 insertions(+)

diff --git a/fs/fscache/cookie.c b/fs/fscache/cookie.c
index 0e91a3c..bfa1d3b 100644
--- a/fs/fscache/cookie.c
+++ b/fs/fscache/cookie.c
@@ -533,6 +533,28 @@ void __fscache_relinquish_cookie(struct fscache_cookie *cookie, int retire)
 EXPORT_SYMBOL(__fscache_relinquish_cookie);
 
 /*
+ * check the consistency between the netfs inode and the backing cache
+ *
+ * NOTE: it only serves no-index type
+ */
+bool __fscache_check_consistency(struct fscache_cookie *cookie)
+{
+	struct fscache_object *object;
+
+	if (cookie->def->type != FSCACHE_COOKIE_TYPE_DATAFILE)
+		return false;
+
+	if (hlist_empty(&cookie->backing_objects))
+		return false;
+
+	object = hlist_entry(cookie->backing_objects.first,
+			struct fscache_object, cookie_link);
+
+	return object->cache->ops->check_consistency(object);
+}
+EXPORT_SYMBOL(__fscache_check_consistency);
+
+/*
  * destroy a cookie
  */
 void __fscache_cookie_put(struct fscache_cookie *cookie)
diff --git a/include/linux/fscache-cache.h b/include/linux/fscache-cache.h
index a9ff9a3..5513342 100644
--- a/include/linux/fscache-cache.h
+++ b/include/linux/fscache-cache.h
@@ -302,6 +302,10 @@ struct fscache_cache_ops {
 
 	/* dissociate a cache from all the pages it was backing */
 	void (*dissociate_pages)(struct fscache_cache *cache);
+
+	/* check the consistency between the backing cache and the FS-Cache
+	 * cookie */
+	bool (*check_consistency)(struct fscache_object *object);
 };
 
 /*
diff --git a/include/linux/fscache.h b/include/linux/fscache.h
index 7a08623..7a49e8f 100644
--- a/include/linux/fscache.h
+++ b/include/linux/fscache.h
@@ -183,6 +183,7 @@ extern struct fscache_cookie *__fscache_acquire_cookie(
 	const struct fscache_cookie_def *,
 	void *);
 extern void __fscache_relinquish_cookie(struct fscache_cookie *, int);
+extern bool __fscache_check_consistency(struct fscache_cookie *);
 extern void __fscache_update_cookie(struct fscache_cookie *);
 extern int __fscache_attr_changed(struct fscache_cookie *);
 extern void __fscache_invalidate(struct fscache_cookie *);
@@ -326,6 +327,22 @@ void fscache_relinquish_cookie(struct fscache_cookie *cookie, int retire)
 }
 
 /**
+ * fscache_check_consistency - Request that if the cache is updated
+ * @cookie: The cookie representing the cache object
+ *
+ * Request an consistency check from fscache, which resorts to backing
+ * cache.
+ */
+static inline
+bool fscache_check_consistency(struct fscache_cookie *cookie)
+{
+	if (fscache_cookie_valid(cookie))
+		return __fscache_check_consistency(cookie);
+	else
+		return false;
+}
+
+/**
  * fscache_update_cookie - Request that a cache object be updated
  * @cookie: The cookie representing the cache object
  *
-- 
1.8.1.2

