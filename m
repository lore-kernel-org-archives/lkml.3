Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933286AbaDBUZ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 16:25:57 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:42827 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758884AbaDBUN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 16:13:28 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 22/40] FS-Cache: Handle removal of unadded object to the fscache_object_list rb tree
Date: Wed,  2 Apr 2014 22:13:08 +0200
Message-Id: <1dfffe9afcb702234743b6bed968b9cf65cf9493.1396469191.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <4c74007da904cc0411d788200034b2fb4c9e0d01.1396469191.git.jslaby@suse.cz>
References: <4c74007da904cc0411d788200034b2fb4c9e0d01.1396469191.git.jslaby@suse.cz>
In-Reply-To: <cover.1396469191.git.jslaby@suse.cz>
References: <cover.1396469191.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 7026f1929e18921fd67bf478f475a8fdfdff16ae upstream.

When FS-Cache allocates an object, the following sequence of events can
occur:

 -->fscache_alloc_object()
    -->cachefiles_alloc_object() [via cache->ops->alloc_object]
    <--[returns new object]
    -->fscache_attach_object()
    <--[failed]
    -->cachefiles_put_object() [via cache->ops->put_object]
       -->fscache_object_destroy()
          -->fscache_objlist_remove()
             -->rb_erase() to remove the object from fscache_object_list.

resulting in a crash in the rbtree code.

The problem is that the object is only added to fscache_object_list on
the success path of fscache_attach_object() where it calls
fscache_objlist_add().

So if fscache_attach_object() fails, the object won't have been added to
the objlist rbtree.  We do, however, unconditionally try to remove the
object from the tree.

Thanks to NeilBrown for finding this and suggesting this solution.

Reported-by: NeilBrown <neilb@suse.de>
Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: (a customer of) NeilBrown <neilb@suse.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/fscache/object-list.c | 5 +++++
 fs/fscache/object.c      | 3 +++
 2 files changed, 8 insertions(+)

diff --git a/fs/fscache/object-list.c b/fs/fscache/object-list.c
index e1959efad64f..b5ebc2d7d80d 100644
--- a/fs/fscache/object-list.c
+++ b/fs/fscache/object-list.c
@@ -50,6 +50,8 @@ void fscache_objlist_add(struct fscache_object *obj)
 	struct fscache_object *xobj;
 	struct rb_node **p = &fscache_object_list.rb_node, *parent = NULL;
 
+	ASSERT(RB_EMPTY_NODE(&obj->objlist_link));
+
 	write_lock(&fscache_object_list_lock);
 
 	while (*p) {
@@ -75,6 +77,9 @@ void fscache_objlist_add(struct fscache_object *obj)
  */
 void fscache_objlist_remove(struct fscache_object *obj)
 {
+	if (RB_EMPTY_NODE(&obj->objlist_link))
+		return;
+
 	write_lock(&fscache_object_list_lock);
 
 	BUG_ON(RB_EMPTY_ROOT(&fscache_object_list));
diff --git a/fs/fscache/object.c b/fs/fscache/object.c
index 86d75a60b20c..fec41344dacc 100644
--- a/fs/fscache/object.c
+++ b/fs/fscache/object.c
@@ -314,6 +314,9 @@ void fscache_object_init(struct fscache_object *object,
 	object->cache = cache;
 	object->cookie = cookie;
 	object->parent = NULL;
+#ifdef CONFIG_FSCACHE_OBJECT_LIST
+	RB_CLEAR_NODE(&object->objlist_link);
+#endif
 
 	object->oob_event_mask = 0;
 	for (t = object->oob_table; t->events; t++)
-- 
1.9.1

