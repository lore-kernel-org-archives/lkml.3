Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261Ab3KWSfq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 13:35:46 -0500
Received: from mail-qe0-f47.google.com ([209.85.128.47]:37523 "EHLO
	mail-qe0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756219Ab3KWSfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 13:35:43 -0500
Date: Sat, 23 Nov 2013 13:35:40 -0500
From: Tejun Heo <tj@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH v3.13-rc1 2/2] sysfs: use a separate locking class for open
 files depending on mmap
Message-ID: <20131123183540.GB28162@mtj.dyndns.org>
References: <20131123183508.GA28162@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131123183508.GA28162@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 0a0e6b9eec8c8c1168b282150e9de43c2445f475 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Sun, 17 Nov 2013 11:17:36 +0900

The following two commits implemented mmap support in the regular file
path and merged bin file support into the regular path.

 73d9714627ad ("sysfs: copy bin mmap support from fs/sysfs/bin.c to fs/sysfs/file.c")
 3124eb1679b2 ("sysfs: merge regular and bin file handling")

After the merge, the following commands trigger a spurious lockdep
warning.  "test-mmap-read" simply mmaps the file and dumps the
content.

  $ cat /sys/block/sda/trace/act_mask
  $ test-mmap-read /sys/devices/pci0000\:00/0000\:00\:03.0/resource0 4096

  ======================================================
  [ INFO: possible circular locking dependency detected ]
  3.12.0-work+ #378 Not tainted
  -------------------------------------------------------
  test-mmap-read/567 is trying to acquire lock:
   (&of->mutex){+.+.+.}, at: [<ffffffff8120a8df>] sysfs_bin_mmap+0x4f/0x120

  but task is already holding lock:
   (&mm->mmap_sem){++++++}, at: [<ffffffff8114b399>] vm_mmap_pgoff+0x49/0xa0

  which lock already depends on the new lock.


  the existing dependency chain (in reverse order) is:

  -> #3 (&mm->mmap_sem){++++++}:
  ...
  -> #2 (sr_mutex){+.+.+.}:
  ...
  -> #1 (&bdev->bd_mutex){+.+.+.}:
  ...
  -> #0 (&of->mutex){+.+.+.}:
  ...

  other info that might help us debug this:

  Chain exists of:
   &of->mutex --> sr_mutex --> &mm->mmap_sem

   Possible unsafe locking scenario:

	 CPU0                    CPU1
	 ----                    ----
    lock(&mm->mmap_sem);
				 lock(sr_mutex);
				 lock(&mm->mmap_sem);
    lock(&of->mutex);

   *** DEADLOCK ***

  1 lock held by test-mmap-read/567:
   #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff8114b399>] vm_mmap_pgoff+0x49/0xa0

  stack backtrace:
  CPU: 3 PID: 567 Comm: test-mmap-read Not tainted 3.12.0-work+ #378
  Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
   ffffffff81ed41a0 ffff880009441bc8 ffffffff81611ad2 ffffffff81eccb80
   ffff880009441c08 ffffffff8160f215 ffff880009441c60 ffff880009c75208
   0000000000000000 ffff880009c751e0 ffff880009c75208 ffff880009c74ac0
  Call Trace:
   [<ffffffff81611ad2>] dump_stack+0x4e/0x7a
   [<ffffffff8160f215>] print_circular_bug+0x2b0/0x2bf
   [<ffffffff8109ca0a>] __lock_acquire+0x1a3a/0x1e60
   [<ffffffff8109d6ba>] lock_acquire+0x9a/0x1d0
   [<ffffffff81615547>] mutex_lock_nested+0x67/0x3f0
   [<ffffffff8120a8df>] sysfs_bin_mmap+0x4f/0x120
   [<ffffffff8115d363>] mmap_region+0x3b3/0x5b0
   [<ffffffff8115d8ae>] do_mmap_pgoff+0x34e/0x3d0
   [<ffffffff8114b3ba>] vm_mmap_pgoff+0x6a/0xa0
   [<ffffffff8115be3e>] SyS_mmap_pgoff+0xbe/0x250
   [<ffffffff81008282>] SyS_mmap+0x22/0x30
   [<ffffffff8161a4d2>] system_call_fastpath+0x16/0x1b

This happens because one file nests sr_mutex, which nests mm->mmap_sem
under it, under of->mutex while mmap implementation naturally nests
of->mutex under mm->mmap_sem.  The warning is false positive as
of->mutex is per open-file and the two paths belong to two different
files.  This warning didn't trigger before regular and bin file
supports were merged because only bin file supported mmap and the
other side of locking happened only on regular files which used
equivalent but separate locking.

It'd be best if we give separate locking classes per file but we can't
easily do that.  Let's differentiate on ->mmap() for now.  Later we'll
add explicit file operations struct and can add per-ops lockdep key
there.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Dave Jones <davej@redhat.com>
---
 fs/sysfs/file.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 79b5da2..b94f936 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -609,7 +609,7 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
 	struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
 	struct sysfs_open_file *of;
-	bool has_read, has_write;
+	bool has_read, has_write, has_mmap;
 	int error = -EACCES;
 
 	/* need attr_sd for attr and ops, its parent for kobj */
@@ -621,6 +621,7 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 
 		has_read = battr->read || battr->mmap;
 		has_write = battr->write || battr->mmap;
+		has_mmap = battr->mmap;
 	} else {
 		const struct sysfs_ops *ops = sysfs_file_ops(attr_sd);
 
@@ -632,6 +633,7 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 
 		has_read = ops->show;
 		has_write = ops->store;
+		has_mmap = false;
 	}
 
 	/* check perms and supported operations */
@@ -649,7 +651,23 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 	if (!of)
 		goto err_out;
 
-	mutex_init(&of->mutex);
+	/*
+	 * The following is done to give a different lockdep key to
+	 * @of->mutex for files which implement mmap.  This is a rather
+	 * crude way to avoid false positive lockdep warning around
+	 * mm->mmap_sem - mmap nests @of->mutex under mm->mmap_sem and
+	 * reading /sys/block/sda/trace/act_mask grabs sr_mutex, under
+	 * which mm->mmap_sem nests, while holding @of->mutex.  As each
+	 * open file has a separate mutex, it's okay as long as those don't
+	 * happen on the same file.  At this point, we can't easily give
+	 * each file a separate locking class.  Let's differentiate on
+	 * whether the file has mmap or not for now.
+	 */
+	if (has_mmap)
+		mutex_init(&of->mutex);
+	else
+		mutex_init(&of->mutex);
+
 	of->sd = attr_sd;
 	of->file = file;
 
-- 
1.8.4.2

