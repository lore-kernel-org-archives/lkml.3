Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932444Ab3FQIbP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 04:31:15 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:39265 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932359Ab3FQIbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 04:31:13 -0400
From: Andrey Vagin <avagin@openvz.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrey Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Kees Cook <keescook@chromium.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>
Subject: [PATCH] [RFC] mnt: restrict a number of "struct mnt"
Date: Mon, 17 Jun 2013 12:24:58 +0400
Message-Id: <1371457498-27241-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.8.1.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found that a few processes can eat all host memory and nobody can kill them.
$ mount -t tmpfs xxx /mnt
$ mount --make-shared /mnt
$ for i in `seq 30`; do mount --bind /mnt `mktemp -d /mnt/test.XXXXXX` & done

All this processes are unkillable, because they took i_mutex and waits
namespace_lock.

...
21715 pts/0    D      0:00          \_ mount --bind /mnt /mnt/test.ht6jzO
21716 pts/0    D      0:00          \_ mount --bind /mnt /mnt/test.97K4mI
21717 pts/0    R      0:01          \_ mount --bind /mnt /mnt/test.gO2CD9
...

Each of this process doubles a number of mounts, so at the end we will
have about 2^32 mounts and the size of struct mnt is 256 bytes, so we
need about 1TB of RAM.

Another problem is that “umount” of a big tree is very hard operation
and it requires a lot of time.
E.g.:
16411
umount("/tmp/xxx", MNT_DETACH)          = 0 <7.852066> (7.8 sec)
32795
umount("/tmp/xxx", MNT_DETACH)          = 0 <34.485501> ( 34 sec)

For all this time sys_umoun takes namespace_sem and vfsmount_lock...

Due to all this reasons I suggest to restrict a number of mounts.
Probably we can optimize this code in a future, but now this restriction
can help.

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 fs/namespace.c                | 66 +++++++++++++++++++++++++------------------
 include/linux/mnt_namespace.h |  2 ++
 kernel/sysctl.c               |  8 ++++++
 3 files changed, 49 insertions(+), 27 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 7b1ca9b..d22e54c 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -41,6 +41,9 @@ static struct list_head *mountpoint_hashtable __read_mostly;
 static struct kmem_cache *mnt_cache __read_mostly;
 static struct rw_semaphore namespace_sem;
 
+unsigned int sysctl_mount_nr __read_mostly = 16384;
+static atomic_t mount_nr = ATOMIC_INIT(0);
+
 /* /sys/fs */
 struct kobject *fs_kobj;
 EXPORT_SYMBOL_GPL(fs_kobj);
@@ -164,43 +167,49 @@ unsigned int mnt_get_count(struct mount *mnt)
 
 static struct mount *alloc_vfsmnt(const char *name)
 {
-	struct mount *mnt = kmem_cache_zalloc(mnt_cache, GFP_KERNEL);
-	if (mnt) {
-		int err;
+	struct mount *mnt;
+	int err;
 
-		err = mnt_alloc_id(mnt);
-		if (err)
-			goto out_free_cache;
+	if (atomic_inc_return(&mount_nr) > sysctl_mount_nr)
+		goto out_dec_mount_nr;
 
-		if (name) {
-			mnt->mnt_devname = kstrdup(name, GFP_KERNEL);
-			if (!mnt->mnt_devname)
-				goto out_free_id;
-		}
+	mnt = kmem_cache_zalloc(mnt_cache, GFP_KERNEL);
+	if (!mnt)
+		goto out_dec_mount_nr;
+
+	err = mnt_alloc_id(mnt);
+	if (err)
+		goto out_free_cache;
+
+	if (name) {
+		mnt->mnt_devname = kstrdup(name, GFP_KERNEL);
+		if (!mnt->mnt_devname)
+			goto out_free_id;
+	}
 
 #ifdef CONFIG_SMP
-		mnt->mnt_pcp = alloc_percpu(struct mnt_pcp);
-		if (!mnt->mnt_pcp)
-			goto out_free_devname;
+	mnt->mnt_pcp = alloc_percpu(struct mnt_pcp);
+	if (!mnt->mnt_pcp)
+		goto out_free_devname;
 
-		this_cpu_add(mnt->mnt_pcp->mnt_count, 1);
+	this_cpu_add(mnt->mnt_pcp->mnt_count, 1);
 #else
-		mnt->mnt_count = 1;
-		mnt->mnt_writers = 0;
+	mnt->mnt_count = 1;
+	mnt->mnt_writers = 0;
 #endif
 
-		INIT_LIST_HEAD(&mnt->mnt_hash);
-		INIT_LIST_HEAD(&mnt->mnt_child);
-		INIT_LIST_HEAD(&mnt->mnt_mounts);
-		INIT_LIST_HEAD(&mnt->mnt_list);
-		INIT_LIST_HEAD(&mnt->mnt_expire);
-		INIT_LIST_HEAD(&mnt->mnt_share);
-		INIT_LIST_HEAD(&mnt->mnt_slave_list);
-		INIT_LIST_HEAD(&mnt->mnt_slave);
+	INIT_LIST_HEAD(&mnt->mnt_hash);
+	INIT_LIST_HEAD(&mnt->mnt_child);
+	INIT_LIST_HEAD(&mnt->mnt_mounts);
+	INIT_LIST_HEAD(&mnt->mnt_list);
+	INIT_LIST_HEAD(&mnt->mnt_expire);
+	INIT_LIST_HEAD(&mnt->mnt_share);
+	INIT_LIST_HEAD(&mnt->mnt_slave_list);
+	INIT_LIST_HEAD(&mnt->mnt_slave);
 #ifdef CONFIG_FSNOTIFY
-		INIT_HLIST_HEAD(&mnt->mnt_fsnotify_marks);
+	INIT_HLIST_HEAD(&mnt->mnt_fsnotify_marks);
 #endif
-	}
+
 	return mnt;
 
 #ifdef CONFIG_SMP
@@ -211,6 +220,8 @@ out_free_id:
 	mnt_free_id(mnt);
 out_free_cache:
 	kmem_cache_free(mnt_cache, mnt);
+out_dec_mount_nr:
+	atomic_dec(&mount_nr);
 	return NULL;
 }
 
@@ -546,6 +557,7 @@ static void free_vfsmnt(struct mount *mnt)
 #ifdef CONFIG_SMP
 	free_percpu(mnt->mnt_pcp);
 #endif
+	atomic_dec(&mount_nr);
 	kmem_cache_free(mnt_cache, mnt);
 }
 
diff --git a/include/linux/mnt_namespace.h b/include/linux/mnt_namespace.h
index 12b2ab5..d8e5ec9 100644
--- a/include/linux/mnt_namespace.h
+++ b/include/linux/mnt_namespace.h
@@ -2,6 +2,8 @@
 #define _NAMESPACE_H_
 #ifdef __KERNEL__
 
+extern unsigned int sysctl_mount_nr;
+
 struct mnt_namespace;
 struct fs_struct;
 struct user_namespace;
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 9edcf45..bebfdd7 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -61,6 +61,7 @@
 #include <linux/kmod.h>
 #include <linux/capability.h>
 #include <linux/binfmts.h>
+#include <linux/mnt_namespace.h>
 #include <linux/sched/sysctl.h>
 
 #include <asm/uaccess.h>
@@ -1616,6 +1617,13 @@ static struct ctl_table fs_table[] = {
 		.proc_handler	= &pipe_proc_fn,
 		.extra1		= &pipe_min_size,
 	},
+	{
+		.procname	= "mount-nr",
+		.data		= &sysctl_mount_nr,
+		.maxlen		= sizeof(sysctl_mount_nr),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
 	{ }
 };
 
-- 
1.8.1.4

