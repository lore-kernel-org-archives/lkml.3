Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbaBQPbL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 10:31:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32470 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752097AbaBQPbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 10:31:10 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH] FS-Cache: Handle removal of unadded object to the
 fscache_object_list rb tree
From: David Howells <dhowells@redhat.com>
To: torvalds@linux-foundation.org
Cc: neilb@suse.de, linux-fsdevel@vger.kernel.org, linux-cachefs@redhat.com,
        linux-kernel@vger.kernel.org
Date: Mon, 17 Feb 2014 15:01:47 +0000
Message-ID: <20140217150147.10752.50186.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When FS-Cache allocates an object, the following sequence of events can occur:

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

The problem is that the object is only added to fscache_object_list on the
success path of fscache_attach_object() where it calls fscache_objlist_add().

So if fscache_attach_object() fails, the object won't have been added to the
objlist rbtree.  We do, however, unconditionally try to remove the object from
the tree.

Thanks to NeilBrown for finding this and suggesting this solution.

Reported-by: NeilBrown <neilb@suse.de>
Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: (a customer of) NeilBrown <neilb@suse.de>
---

 fs/fscache/object-list.c |    5 +++++
 fs/fscache/object.c      |    3 +++
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
index 53d35c504240..d3b4539f1651 100644
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

