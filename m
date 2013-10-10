Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809Ab3JJArf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 20:47:35 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35435 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754223Ab3JJArd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 20:47:33 -0400
Date: Thu, 10 Oct 2013 01:47:32 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [RFC] do we want pipefs et.al. in /proc/filesystems?
Message-ID: <20131010004732.GJ13318@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	We used to require register_filesystem() before any mounts
(including the internal ones) could be done.  For userland mounts
it's obviously right - how else could fs type name -> file_system_type
lookup be done?  For internal ones, it used to be really needed for
a while, but after some API massage (about 10 years ago, IIRC) it really
became pointless - kern_mount() takes a pointer to file_system_type
and doesn't bother with searching for it by name.  For a while there
was one remaining reason - the list of struct superblock belonging to
given fs type was a list_head one, with register_filesystem() initializing
the list.  A couple of years ago we switched to hlist, which doesn't
require anything of that sort - hlist_head initialized to NULL is an
empty list.

	These days there's no reason to register the filesystem types
that can only be used for internal mounts - ia64 pfmfs, anon_inodes,
bdev, pipefs and sockfs, in the current tree.  The only user-visible
effect of dropping those register_filesystem() would be shorter
/proc/filesystems - that bunch wouldn't be mentioned there anymore.
Does anything care about that?  FWIW, the diff eliminating those
would be as below (net/socket.c init leaks on early failures;
I'd left that as-is - it's a separate story).

diff --git a/arch/ia64/kernel/perfmon.c b/arch/ia64/kernel/perfmon.c
index 5a9ff1c..bb3968e 100644
--- a/arch/ia64/kernel/perfmon.c
+++ b/arch/ia64/kernel/perfmon.c
@@ -1529,16 +1529,10 @@ static struct vfsmount *pfmfs_mnt __read_mostly;
 static int __init
 init_pfm_fs(void)
 {
-	int err = register_filesystem(&pfm_fs_type);
-	if (!err) {
-		pfmfs_mnt = kern_mount(&pfm_fs_type);
-		err = PTR_ERR(pfmfs_mnt);
-		if (IS_ERR(pfmfs_mnt))
-			unregister_filesystem(&pfm_fs_type);
-		else
-			err = 0;
-	}
-	return err;
+	pfmfs_mnt = kern_mount(&pfm_fs_type);
+	if (IS_ERR(pfmfs_mnt))
+		return PTR_ERR(pfmfs_mnt);
+	return 0;
 }
 
 static ssize_t
diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
index 2408473..ad56c5a 100644
--- a/fs/anon_inodes.c
+++ b/fs/anon_inodes.c
@@ -175,22 +175,11 @@ EXPORT_SYMBOL_GPL(anon_inode_getfd);
 
 static int __init anon_inode_init(void)
 {
-	int error;
-
-	error = register_filesystem(&anon_inode_fs_type);
-	if (error)
-		goto err_exit;
 	anon_inode_mnt = kern_mount(&anon_inode_fs_type);
-	if (IS_ERR(anon_inode_mnt)) {
-		error = PTR_ERR(anon_inode_mnt);
-		goto err_unregister_filesystem;
-	}
+	if (IS_ERR(anon_inode_mnt))
+		panic("anon_inode_init() failed (%ld)\n",
+			PTR_ERR(anon_inode_mnt));
 	return 0;
-
-err_unregister_filesystem:
-	unregister_filesystem(&anon_inode_fs_type);
-err_exit:
-	panic(KERN_ERR "anon_inode_init() failed (%d)\n", error);
 }
 
 fs_initcall(anon_inode_init);
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 1e86823..ff3bf6a 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -461,9 +461,6 @@ void __init bdev_cache_init(void)
 			0, (SLAB_HWCACHE_ALIGN|SLAB_RECLAIM_ACCOUNT|
 				SLAB_MEM_SPREAD|SLAB_PANIC),
 			init_once);
-	err = register_filesystem(&bd_type);
-	if (err)
-		panic("Cannot register bdev pseudo-fs");
 	bd_mnt = kern_mount(&bd_type);
 	if (IS_ERR(bd_mnt))
 		panic("Cannot create bdev pseudo-fs");
diff --git a/fs/pipe.c b/fs/pipe.c
index d2c45e14..7a63d0a 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -1311,16 +1311,10 @@ static struct file_system_type pipe_fs_type = {
 
 static int __init init_pipe_fs(void)
 {
-	int err = register_filesystem(&pipe_fs_type);
-
-	if (!err) {
-		pipe_mnt = kern_mount(&pipe_fs_type);
-		if (IS_ERR(pipe_mnt)) {
-			err = PTR_ERR(pipe_mnt);
-			unregister_filesystem(&pipe_fs_type);
-		}
-	}
-	return err;
+	pipe_mnt = kern_mount(&pipe_fs_type);
+	if (IS_ERR(pipe_mnt))
+		panic("pipe init failed\n");
+	return 0;
 }
 
 fs_initcall(init_pipe_fs);
diff --git a/net/socket.c b/net/socket.c
index ebed4b6..ea534a3 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2617,7 +2617,7 @@ static int __init sock_init(void)
 	 */
 	err = net_sysctl_init();
 	if (err)
-		goto out;
+		return err;
 
 	/*
 	 *      Initialize skbuff SLAB cache
@@ -2630,14 +2630,9 @@ static int __init sock_init(void)
 
 	init_inodecache();
 
-	err = register_filesystem(&sock_fs_type);
-	if (err)
-		goto out_fs;
 	sock_mnt = kern_mount(&sock_fs_type);
-	if (IS_ERR(sock_mnt)) {
-		err = PTR_ERR(sock_mnt);
-		goto out_mount;
-	}
+	if (IS_ERR(sock_mnt))
+		return PTR_ERR(sock_mnt);
 
 	/* The real protocol initialization is performed in later initcalls.
 	 */
@@ -2645,20 +2640,13 @@ static int __init sock_init(void)
 #ifdef CONFIG_NETFILTER
 	err = netfilter_init();
 	if (err)
-		goto out;
+		return err;
 #endif
 
 #ifdef CONFIG_NETWORK_PHY_TIMESTAMPING
 	skb_timestamping_init();
 #endif
-
-out:
-	return err;
-
-out_mount:
-	unregister_filesystem(&sock_fs_type);
-out_fs:
-	goto out;
+	return 0;
 }
 
 core_initcall(sock_init);	/* early initcall */
