Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340AbaI1RNF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 13:13:05 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:49998 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411AbaI1RND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 13:13:03 -0400
Date: Sun, 28 Sep 2014 13:12:54 -0400
From: Tejun Heo <tj@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH driver-core-next] kernfs: fix fill_super failure path
Message-ID: <20140928171254.GA29787@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After kernfs_fill_super() failure, the half-initialized sb still goes
through kernfs_kill_sb() for destruction; unfortunately,
kernfs_kill_sb() dereferences sb->s_root which may be NULL after
fill_super failure triggering the following oops when such error
condition is artificially injected.

  BUG: unable to handle kernel NULL pointer dereference at 00000000000000d8
  IP: [<ffffffff8121aa15>] kernfs_kill_sb+0x25/0x90
  PGD 0
  Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
  Modules linked in:
  CPU: 0 PID: 524 Comm: mount Not tainted 3.17.0-rc6-work+ #90
  Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
  task: ffff88001119c650 ti: ffff880015ee4000 task.ti: ffff880015ee4000
  RIP: 0010:[<ffffffff8121aa15>]  [<ffffffff8121aa15>] kernfs_kill_sb+0x25/0x90
  RSP: 0018:ffff880015ee7d18  EFLAGS: 00010246
  RAX: 0000000000000000 RBX: ffff880010bbccc0 RCX: 0000000000000006
  RDX: 0000000000000006 RSI: 0000000000000000 RDI: ffffffff819457c0
  RBP: ffff880015ee7d30 R08: 0000000000000000 R09: 0000000000000001
  R10: 0000000000000000 R11: ffff88001119ceb0 R12: ffff880014222800
  R13: ffff88001101c010 R14: ffff8800076b4c70 R15: ffff880010bbccc0
  FS:  00007f65c3c51880(0000) GS:ffff88001fa00000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
  CR2: 00000000000000d8 CR3: 000000001623e000 CR4: 00000000000006f0
  Stack:
   ffff88001101c000 ffff880014222800 ffff88001101c010 ffff880015ee7d58
   ffffffff810e7073 ffff880014222800 ffffffff81921140 ffff880014222800
   ffff880015ee7d78 ffffffff811a8794 ffff880010bbccc0 ffff88001127ef00
  Call Trace:
   [<ffffffff810e7073>] cgroup_kill_sb+0x53/0x80
   [<ffffffff811a8794>] deactivate_locked_super+0x44/0x60
   [<ffffffff8121a934>] kernfs_mount_ns+0x164/0x220
   [<ffffffff810e3aa6>] cgroup_mount+0x336/0x970
   [<ffffffff811a9e05>] mount_fs+0x15/0xc0
   [<ffffffff811c81fb>] vfs_kern_mount+0x6b/0x160
   [<ffffffff811cb33d>] do_mount+0x1fd/0xc30
   [<ffffffff811cc073>] SyS_mount+0x83/0xc0
   [<ffffffff81624812>] system_call_fastpath+0x16/0x1b
  Code: 84 00 00 00 00 00 0f 1f 44 00 00 55 31 f6 48 89 e5 41 55 41 54 49 89 fc 53 48 8b 9f 40 05 00 00 48 8b 47 60 48 c7 c7 c0 57 94 81 <4c> 8b a8 d8 00 00 00 e8 0f 50 40 00 48 8b 53 18 48 8b 43 20 48
  RIP  [<ffffffff8121aa15>] kernfs_kill_sb+0x25/0x90
   RSP <ffff880015ee7d18>
  CR2: 00000000000000d8

kernfs_fill_super() can only fail after a GFP_KERNEL allocation
failure of a sub-page allocation which doesn't happen in practice.  As
such, the above oops won't take place in practice and this patch isn't
marked for -stable.

Note that the unconditional kernfs_put(root_kn) in kernfs_kill_sb() is
fine as kernfs_put() takes NULL input and ignores it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Alexander Viro <viro@zeniv.linux.org.uk>
Link: http://lkml.kernel.org/g/20140926045352.GN7996@ZenIV.linux.org.uk
---
 fs/kernfs/mount.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
index f973ae9..86087c3 100644
--- a/fs/kernfs/mount.c
+++ b/fs/kernfs/mount.c
@@ -157,6 +157,7 @@ struct dentry *kernfs_mount_ns(struct file_system_type *fs_type, int flags,
 
 	info->root = root;
 	info->ns = ns;
+	INIT_LIST_HEAD(&info->node);
 
 	sb = sget(fs_type, kernfs_test_super, kernfs_set_super, flags, info);
 	if (IS_ERR(sb) || sb->s_fs_info != info)
@@ -196,7 +197,7 @@ struct dentry *kernfs_mount_ns(struct file_system_type *fs_type, int flags,
 void kernfs_kill_sb(struct super_block *sb)
 {
 	struct kernfs_super_info *info = kernfs_info(sb);
-	struct kernfs_node *root_kn = sb->s_root->d_fsdata;
+	struct kernfs_node *root_kn = sb->s_root ? sb->s_root->d_fsdata : NULL;
 
 	mutex_lock(&kernfs_mutex);
 	list_del(&info->node);
