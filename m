Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbaBESkD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 13:40:03 -0500
Received: from relay.parallels.com ([195.214.232.42]:35668 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725AbaBESjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 13:39:41 -0500
From: Vladimir Davydov <vdavydov@parallels.com>
To: <akpm@linux-foundation.org>
CC: <dchinner@redhat.com>, <mhocko@suse.cz>, <hannes@cmpxchg.org>,
        <glommer@gmail.com>, <rientjes@google.com>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <devel@openvz.org>, Glauber Costa <glommer@openvz.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH -mm v15 10/13] fs: make shrinker memcg aware
Date: Wed, 5 Feb 2014 22:39:26 +0400
Message-ID: <b876ce42d48db8b68fc6b29dd4f1fddc4f5ac949.1391624021.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1391624021.git.vdavydov@parallels.com>
References: <cover.1391624021.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.24.25.229]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, to make any list_lru-based shrinker memcg aware we should only
initialize its list_lru as memcg-enabled. Let's do it for the general FS
shrinker (super_block::s_shrink) and mark it as memcg aware.

There are other FS-specific shrinkers that use list_lru for storing
objects, such as XFS and GFS2 dquot cache shrinkers, but since they
reclaim objects that may be shared among different cgroups, there is no
point making them memcg aware.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Glauber Costa <glommer@openvz.org>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/super.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 33cbff3769e7..6a58a7196fb2 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -191,9 +191,9 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags)
 	INIT_LIST_HEAD(&s->s_inodes);
 	INIT_WORK(&s->destroy, destroy_super_work_func);
 
-	if (list_lru_init(&s->s_dentry_lru))
+	if (list_lru_init_memcg(&s->s_dentry_lru))
 		goto fail;
-	if (list_lru_init(&s->s_inode_lru))
+	if (list_lru_init_memcg(&s->s_inode_lru))
 		goto fail;
 
 	init_rwsem(&s->s_umount);
@@ -230,7 +230,7 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags)
 	s->s_shrink.scan_objects = super_cache_scan;
 	s->s_shrink.count_objects = super_cache_count;
 	s->s_shrink.batch = 1024;
-	s->s_shrink.flags = SHRINKER_NUMA_AWARE;
+	s->s_shrink.flags = SHRINKER_NUMA_AWARE | SHRINKER_MEMCG_AWARE;
 	return s;
 
 fail:
-- 
1.7.10.4

