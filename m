Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332AbaG1JcG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 05:32:06 -0400
Received: from mx2.parallels.com ([199.115.105.18]:38254 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226AbaG1JcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 05:32:02 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: <akpm@linux-foundation.org>
CC: <hannes@cmpxchg.org>, <mhocko@suse.cz>, <glommer@gmail.com>,
        <david@fromorbit.com>, <viro@zeniv.linux.org.uk>, <gthelen@google.com>,
        <mgorman@suse.de>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH -mm 5/6] fs: make shrinker memcg aware
Date: Mon, 28 Jul 2014 13:31:27 +0400
Message-ID: <7fe5b4cbc8263a3d284b3056c6cd995724da50ce.1406536261.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1406536261.git.vdavydov@parallels.com>
References: <cover.1406536261.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, to make any list_lru-based shrinker memcg aware we should only
initialize its list_lru as memcg-enabled. Let's do it for the general FS
shrinker (super_block::s_shrink) and mark it as memcg aware.

There are other FS-specific shrinkers that use list_lru for storing
objects, such as XFS and GFS2 dquot cache shrinkers, but since they
reclaim objects that are shared among different cgroups, there is no
point making them memcg aware.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 fs/super.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 477102d59c7e..2e5ed2b51b37 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -34,6 +34,7 @@
 #include <linux/cleancache.h>
 #include <linux/fsnotify.h>
 #include <linux/lockdep.h>
+#include <linux/memcontrol.h>
 #include "internal.h"
 
 
@@ -187,9 +188,9 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags)
 	INIT_HLIST_BL_HEAD(&s->s_anon);
 	INIT_LIST_HEAD(&s->s_inodes);
 
-	if (list_lru_init(&s->s_dentry_lru, false))
+	if (list_lru_init(&s->s_dentry_lru, true))
 		goto fail;
-	if (list_lru_init(&s->s_inode_lru, false))
+	if (list_lru_init(&s->s_inode_lru, true))
 		goto fail;
 
 	init_rwsem(&s->s_umount);
@@ -225,7 +226,7 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags)
 	s->s_shrink.scan_objects = super_cache_scan;
 	s->s_shrink.count_objects = super_cache_count;
 	s->s_shrink.batch = 1024;
-	s->s_shrink.flags = SHRINKER_NUMA_AWARE;
+	s->s_shrink.flags = SHRINKER_NUMA_AWARE | SHRINKER_MEMCG_AWARE;
 	return s;
 
 fail:
@@ -280,6 +281,16 @@ void deactivate_locked_super(struct super_block *s)
 		unregister_shrinker(&s->s_shrink);
 		fs->kill_sb(s);
 
+		/*
+		 * list_lru_destroy() may sleep on memcg-aware lrus. Since
+		 * put_super() calls destroy_super() under a spin lock, we must
+		 * unregister lrus from memcg here to avoid sleeping in atomic
+		 * context. It's safe, because by the time we get here, lrus
+		 * must be empty.
+		 */
+		memcg_unregister_list_lru(&s->s_dentry_lru);
+		memcg_unregister_list_lru(&s->s_inode_lru);
+
 		put_filesystem(fs);
 		put_super(s);
 	} else {
-- 
1.7.10.4

