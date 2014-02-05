Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910AbaBESjz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 13:39:55 -0500
Received: from relay.parallels.com ([195.214.232.42]:35632 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753760AbaBESji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 13:39:38 -0500
From: Vladimir Davydov <vdavydov@parallels.com>
To: <akpm@linux-foundation.org>
CC: <dchinner@redhat.com>, <mhocko@suse.cz>, <hannes@cmpxchg.org>,
        <glommer@gmail.com>, <rientjes@google.com>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <devel@openvz.org>, Glauber Costa <glommer@openvz.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH -mm v15 07/13] fs: do not call destroy_super() in atomic context
Date: Wed, 5 Feb 2014 22:39:23 +0400
Message-ID: <81263f0532a3550bd8a82aaa9b0aabae8a1f011d.1391624021.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1391624021.git.vdavydov@parallels.com>
References: <cover.1391624021.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.24.25.229]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To make list_lru per-memcg, I'll have to add some code that might sleep
to list_lru_destroy(), but it is impossible to do now, because
list_lru_destroy() is currently called by destroy_super(), which can be
called in atomic context from __put_super().

To overcome this, in this patch I make __put_super() schedule the super
block destruction in an asynchronous work instead of calling
destroy_super() directly.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Glauber Costa <glommer@openvz.org>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/super.c         |   10 +++++++++-
 include/linux/fs.h |    2 ++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/super.c b/fs/super.c
index ff9ff5fad70c..33cbff3769e7 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -147,6 +147,13 @@ static void destroy_super(struct super_block *s)
 	kfree_rcu(s, rcu);
 }
 
+static void destroy_super_work_func(struct work_struct *w)
+{
+	struct super_block *s = container_of(w, struct super_block, destroy);
+
+	destroy_super(s);
+}
+
 /**
  *	alloc_super	-	create new superblock
  *	@type:	filesystem type superblock should belong to
@@ -182,6 +189,7 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags)
 	INIT_HLIST_NODE(&s->s_instances);
 	INIT_HLIST_BL_HEAD(&s->s_anon);
 	INIT_LIST_HEAD(&s->s_inodes);
+	INIT_WORK(&s->destroy, destroy_super_work_func);
 
 	if (list_lru_init(&s->s_dentry_lru))
 		goto fail;
@@ -239,7 +247,7 @@ static void __put_super(struct super_block *sb)
 {
 	if (!--sb->s_count) {
 		list_del_init(&sb->s_list);
-		destroy_super(sb);
+		schedule_work(&sb->destroy);
 	}
 }
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 3a87b0254408..200cbf804335 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1328,7 +1328,9 @@ struct super_block {
 	 */
 	struct list_lru		s_dentry_lru ____cacheline_aligned_in_smp;
 	struct list_lru		s_inode_lru ____cacheline_aligned_in_smp;
+
 	struct rcu_head		rcu;
+	struct work_struct	destroy;
 };
 
 extern struct timespec current_fs_time(struct super_block *sb);
-- 
1.7.10.4

