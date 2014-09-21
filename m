Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbaIUPQR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 11:16:17 -0400
Received: from mx2.parallels.com ([199.115.105.18]:56896 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520AbaIUPQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 11:16:14 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Greg Thelen <gthelen@google.com>, Dave Chinner <david@fromorbit.com>,
        Glauber Costa <glommer@gmail.com>,
        Suleiman Souhlal <suleiman@google.com>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <cgroups@vger.kernel.org>
Subject: [PATCH -mm 14/14] fs: make shrinker memcg aware
Date: Sun, 21 Sep 2014 19:14:46 +0400
Message-ID: <9569ab6091089fd8eee19744de0b6f4f278663b1.1411301245.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1411301245.git.vdavydov@parallels.com>
References: <cover.1411301245.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [81.5.99.36]
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
 fs/super.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index a82e97b0b8b9..9c765d3a14f3 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -189,9 +189,9 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags)
 	INIT_HLIST_BL_HEAD(&s->s_anon);
 	INIT_LIST_HEAD(&s->s_inodes);
 
-	if (list_lru_init(&s->s_dentry_lru, false))
+	if (list_lru_init(&s->s_dentry_lru, true))
 		goto fail;
-	if (list_lru_init(&s->s_inode_lru, false))
+	if (list_lru_init(&s->s_inode_lru, true))
 		goto fail;
 
 	init_rwsem(&s->s_umount);
@@ -227,7 +227,7 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags)
 	s->s_shrink.scan_objects = super_cache_scan;
 	s->s_shrink.count_objects = super_cache_count;
 	s->s_shrink.batch = 1024;
-	s->s_shrink.flags = SHRINKER_NUMA_AWARE;
+	s->s_shrink.flags = SHRINKER_NUMA_AWARE | SHRINKER_MEMCG_AWARE;
 	return s;
 
 fail:
-- 
1.7.10.4

