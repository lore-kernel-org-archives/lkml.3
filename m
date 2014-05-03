Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbaECUyp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 16:54:45 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:32459 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752794AbaECUyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 16:54:44 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjsTACtXZVNXQD6Q/2dsb2JhbABZgwaDPagtCgUBmgYCAoERF3SCUxMcIxiBAiQTiEUBygWFVoh8hEYBA48aihkBin6HdoM2Ow
Date: Sat, 3 May 2014 22:54:34 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: dhowells <dhowells@redhat.com>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 2/2] FS/FSCACHE: convert printk to pr_foo()
Message-Id: <20140503225434.da9554fcb7702af2be43142c@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-All printk converted to pr_foo() except internal.h: printk(KERN_DEBUG
-Coalesce formats.
-Add pr_fmt

Cc: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/fscache/cache.c     | 13 ++++++-------
 fs/fscache/cookie.c    |  2 +-
 fs/fscache/internal.h  | 26 ++++++++++++++++----------
 fs/fscache/main.c      |  7 +++----
 fs/fscache/netfs.c     |  7 +++----
 fs/fscache/operation.c |  3 +--
 fs/fscache/page.c      |  6 ++----
 7 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/fs/fscache/cache.c b/fs/fscache/cache.c
index f7cff36..56cce7f 100644
--- a/fs/fscache/cache.c
+++ b/fs/fscache/cache.c
@@ -280,15 +280,15 @@ int fscache_add_cache(struct fscache_cache *cache,
 	spin_unlock(&fscache_fsdef_index.lock);
 	up_write(&fscache_addremove_sem);
 
-	printk(KERN_NOTICE "FS-Cache: Cache \"%s\" added (type %s)\n",
-	       cache->tag->name, cache->ops->name);
+	pr_notice("Cache \"%s\" added (type %s)\n",
+		  cache->tag->name, cache->ops->name);
 	kobject_uevent(cache->kobj, KOBJ_ADD);
 
 	_leave(" = 0 [%s]", cache->identifier);
 	return 0;
 
 tag_in_use:
-	printk(KERN_ERR "FS-Cache: Cache tag '%s' already in use\n", tagname);
+	pr_err("Cache tag '%s' already in use\n", tagname);
 	__fscache_release_cache_tag(tag);
 	_leave(" = -EXIST");
 	return -EEXIST;
@@ -317,8 +317,7 @@ EXPORT_SYMBOL(fscache_add_cache);
 void fscache_io_error(struct fscache_cache *cache)
 {
 	if (!test_and_set_bit(FSCACHE_IOERROR, &cache->flags))
-		printk(KERN_ERR "FS-Cache:"
-		       " Cache '%s' stopped due to I/O error\n",
+		pr_err("Cache '%s' stopped due to I/O error\n",
 		       cache->ops->name);
 }
 EXPORT_SYMBOL(fscache_io_error);
@@ -369,8 +368,8 @@ void fscache_withdraw_cache(struct fscache_cache *cache)
 
 	_enter("");
 
-	printk(KERN_NOTICE "FS-Cache: Withdrawing cache \"%s\"\n",
-	       cache->tag->name);
+	pr_notice("Withdrawing cache \"%s\"\n",
+		  cache->tag->name);
 
 	/* make the cache unavailable for cookie acquisition */
 	if (test_and_set_bit(FSCACHE_CACHE_WITHDRAWN, &cache->flags))
diff --git a/fs/fscache/cookie.c b/fs/fscache/cookie.c
index 29d7feb..aec01be 100644
--- a/fs/fscache/cookie.c
+++ b/fs/fscache/cookie.c
@@ -519,7 +519,7 @@ void __fscache_disable_cookie(struct fscache_cookie *cookie, bool invalidate)
 	ASSERTCMP(atomic_read(&cookie->n_active), >, 0);
 
 	if (atomic_read(&cookie->n_children) != 0) {
-		printk(KERN_ERR "FS-Cache: Cookie '%s' still has children\n",
+		pr_err("Cookie '%s' still has children\n",
 		       cookie->def->name);
 		BUG();
 	}
diff --git a/fs/fscache/internal.h b/fs/fscache/internal.h
index 4226f66..bc6c08f 100644
--- a/fs/fscache/internal.h
+++ b/fs/fscache/internal.h
@@ -22,6 +22,12 @@
  *
  */
 
+#ifdef pr_fmt
+#undef pr_fmt
+#endif
+
+#define pr_fmt(fmt) "FS-Cache: " fmt
+
 #include <linux/fscache-cache.h>
 #include <linux/sched.h>
 
@@ -413,8 +419,8 @@ do {						\
 #define ASSERT(X)							\
 do {									\
 	if (unlikely(!(X))) {						\
-		printk(KERN_ERR "\n");					\
-		printk(KERN_ERR "FS-Cache: Assertion failed\n");	\
+		pr_err("\n");					\
+		pr_err("Assertion failed\n");	\
 		BUG();							\
 	}								\
 } while (0)
@@ -422,9 +428,9 @@ do {									\
 #define ASSERTCMP(X, OP, Y)						\
 do {									\
 	if (unlikely(!((X) OP (Y)))) {					\
-		printk(KERN_ERR "\n");					\
-		printk(KERN_ERR "FS-Cache: Assertion failed\n");	\
-		printk(KERN_ERR "%lx " #OP " %lx is false\n",		\
+		pr_err("\n");					\
+		pr_err("Assertion failed\n");	\
+		pr_err("%lx " #OP " %lx is false\n",		\
 		       (unsigned long)(X), (unsigned long)(Y));		\
 		BUG();							\
 	}								\
@@ -433,8 +439,8 @@ do {									\
 #define ASSERTIF(C, X)							\
 do {									\
 	if (unlikely((C) && !(X))) {					\
-		printk(KERN_ERR "\n");					\
-		printk(KERN_ERR "FS-Cache: Assertion failed\n");	\
+		pr_err("\n");					\
+		pr_err("Assertion failed\n");	\
 		BUG();							\
 	}								\
 } while (0)
@@ -442,9 +448,9 @@ do {									\
 #define ASSERTIFCMP(C, X, OP, Y)					\
 do {									\
 	if (unlikely((C) && !((X) OP (Y)))) {				\
-		printk(KERN_ERR "\n");					\
-		printk(KERN_ERR "FS-Cache: Assertion failed\n");	\
-		printk(KERN_ERR "%lx " #OP " %lx is false\n",		\
+		pr_err("\n");					\
+		pr_err("Assertion failed\n");	\
+		pr_err("%lx " #OP " %lx is false\n",		\
 		       (unsigned long)(X), (unsigned long)(Y));		\
 		BUG();							\
 	}								\
diff --git a/fs/fscache/main.c b/fs/fscache/main.c
index 7c27907..acd4bf1 100644
--- a/fs/fscache/main.c
+++ b/fs/fscache/main.c
@@ -146,8 +146,7 @@ static int __init fscache_init(void)
 					       0,
 					       fscache_cookie_init_once);
 	if (!fscache_cookie_jar) {
-		printk(KERN_NOTICE
-		       "FS-Cache: Failed to allocate a cookie jar\n");
+		pr_notice("Failed to allocate a cookie jar\n");
 		ret = -ENOMEM;
 		goto error_cookie_jar;
 	}
@@ -156,7 +155,7 @@ static int __init fscache_init(void)
 	if (!fscache_root)
 		goto error_kobj;
 
-	printk(KERN_NOTICE "FS-Cache: Loaded\n");
+	pr_notice("Loaded\n");
 	return 0;
 
 error_kobj:
@@ -192,7 +191,7 @@ static void __exit fscache_exit(void)
 	fscache_proc_cleanup();
 	destroy_workqueue(fscache_op_wq);
 	destroy_workqueue(fscache_object_wq);
-	printk(KERN_NOTICE "FS-Cache: Unloaded\n");
+	pr_notice("Unloaded\n");
 }
 
 module_exit(fscache_exit);
diff --git a/fs/fscache/netfs.c b/fs/fscache/netfs.c
index 989f394..6d941f5 100644
--- a/fs/fscache/netfs.c
+++ b/fs/fscache/netfs.c
@@ -65,8 +65,7 @@ int __fscache_register_netfs(struct fscache_netfs *netfs)
 	list_add(&netfs->link, &fscache_netfs_list);
 	ret = 0;
 
-	printk(KERN_NOTICE "FS-Cache: Netfs '%s' registered for caching\n",
-	       netfs->name);
+	pr_notice("Netfs '%s' registered for caching\n", netfs->name);
 
 already_registered:
 	up_write(&fscache_addremove_sem);
@@ -97,8 +96,8 @@ void __fscache_unregister_netfs(struct fscache_netfs *netfs)
 
 	up_write(&fscache_addremove_sem);
 
-	printk(KERN_NOTICE "FS-Cache: Netfs '%s' unregistered from caching\n",
-	       netfs->name);
+	pr_notice("Netfs '%s' unregistered from caching\n",
+		  netfs->name);
 
 	_leave("");
 }
diff --git a/fs/fscache/operation.c b/fs/fscache/operation.c
index 318071a..e7b87a0 100644
--- a/fs/fscache/operation.c
+++ b/fs/fscache/operation.c
@@ -51,8 +51,7 @@ void fscache_enqueue_operation(struct fscache_operation *op)
 		_debug("queue for caller's attention");
 		break;
 	default:
-		printk(KERN_ERR "FS-Cache: Unexpected op type %lx",
-		       op->flags);
+		pr_err("Unexpected op type %lx", op->flags);
 		BUG();
 		break;
 	}
diff --git a/fs/fscache/page.c b/fs/fscache/page.c
index 7f5c658..ed70714 100644
--- a/fs/fscache/page.c
+++ b/fs/fscache/page.c
@@ -1108,10 +1108,8 @@ void fscache_mark_page_cached(struct fscache_retrieval *op, struct page *page)
 		static bool once_only;
 		if (!once_only) {
 			once_only = true;
-			printk(KERN_WARNING "FS-Cache:"
-			       " Cookie type %s marked page %lx"
-			       " multiple times\n",
-			       cookie->def->name, page->index);
+			pr_warn("Cookie type %s marked page %lx multiple times\n",
+				cookie->def->name, page->index);
 		}
 	}
 
-- 
1.8.4.5

