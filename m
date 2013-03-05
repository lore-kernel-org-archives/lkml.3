Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759416Ab3CED3W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 22:29:22 -0500
Received: from mail-gh0-f179.google.com ([209.85.160.179]:49219 "EHLO
	mail-gh0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759092Ab3CED3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 22:29:21 -0500
From: "Raphael S.Carvalho" <raphael.scarv@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Cyrill Gorcunov <gorcunov@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>
Cc: linux-kernel@vger.kernel.org,
        "Raphael S.Carvalho" <raphael.scarv@gmail.com>
Subject: [PATCH 1/1] kernel/pid_namespace.c: Fixing a lack of cleanup (Probable resources leak).
Date: Tue,  5 Mar 2013 00:28:23 -0300
Message-Id: <1362454103-391-1-git-send-email-raphael.scarv@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Starting point: create_pid_namespace()

Suppose create_pid_cachep() was executed sucessfully, thus:
pcache was allocated by kmalloc().
cachep received a cache created by kmem_cache_create().
and pcache->list was added to the list pid_caches_lh.

So what would happen if proc_alloc_inum() returns an error?
The resources allocated by create_pid_namespace() would be deallocated!
How about those resources allocated by create_pid_cachep()?
By knowing that, I created this patch in order to fix that!

Signed-off-by: Raphael S.Carvalho <raphael.scarv@gmail.com>
---
 kernel/pid_namespace.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index c1c3dc1..d94e4b6 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -37,7 +37,7 @@ static struct kmem_cache *pid_ns_cachep;
  * @nr_ids: the number of numerical ids this pid will have to carry
  */
 
-static struct kmem_cache *create_pid_cachep(int nr_ids)
+static struct pid_cache *create_pid_cachep(int nr_ids)
 {
 	struct pid_cache *pcache;
 	struct kmem_cache *cachep;
@@ -63,7 +63,7 @@ static struct kmem_cache *create_pid_cachep(int nr_ids)
 	list_add(&pcache->list, &pid_caches_lh);
 out:
 	mutex_unlock(&pid_caches_mutex);
-	return pcache->cachep;
+	return pcache;
 
 err_cachep:
 	kfree(pcache);
@@ -85,6 +85,7 @@ static struct pid_namespace *create_pid_namespace(struct user_namespace *user_ns
 	struct pid_namespace *parent_pid_ns)
 {
 	struct pid_namespace *ns;
+	struct pid_cache *pcache;
 	unsigned int level = parent_pid_ns->level + 1;
 	int i;
 	int err;
@@ -103,15 +104,16 @@ static struct pid_namespace *create_pid_namespace(struct user_namespace *user_ns
 	if (!ns->pidmap[0].page)
 		goto out_free;
 
-	ns->pid_cachep = create_pid_cachep(level + 1);
-	if (ns->pid_cachep == NULL)
+	pcache = create_pid_cachep(level + 1);
+	if (pcache == NULL)
 		goto out_free_map;
 
 	err = proc_alloc_inum(&ns->proc_inum);
 	if (err)
-		goto out_free_map;
+		goto out_free_cachep;
 
 	kref_init(&ns->kref);
+	ns->pid_cachep = pcache->cachep;
 	ns->level = level;
 	ns->parent = get_pid_ns(parent_pid_ns);
 	ns->user_ns = get_user_ns(user_ns);
@@ -126,6 +128,10 @@ static struct pid_namespace *create_pid_namespace(struct user_namespace *user_ns
 
 	return ns;
 
+out_free_cachep:
+	kmem_cache_destroy(pcache->cachep);
+	list_del(&pcache->list);
+	kfree(pcache);
 out_free_map:
 	kfree(ns->pidmap[0].page);
 out_free:
-- 
1.7.2.5

