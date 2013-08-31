Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab3HaCfo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 22:35:44 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35789 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504Ab3HaCfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 22:35:42 -0400
Date: Sat, 31 Aug 2013 03:35:16 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Waiman Long <waiman.long@hp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
Message-ID: <20130831023516.GI13318@ZenIV.linux.org.uk>
References: <CA+55aFyhTR15GBS4VNoRkcFyubEJU7a+Pzd-6VZeKoU8qB0q5Q@mail.gmail.com>
 <5220E56A.80603@hp.com>
 <CA+55aFzv9BZ2+B2NrNRRtTqnfgbH3LRSvSsUZVsy-g9OpM-8HA@mail.gmail.com>
 <5220F090.5050908@hp.com>
 <20130830194059.GC13318@ZenIV.linux.org.uk>
 <5220F811.9060902@hp.com>
 <20130830202608.GD13318@ZenIV.linux.org.uk>
 <52210225.60805@hp.com>
 <20130830204852.GE13318@ZenIV.linux.org.uk>
 <52214EBC.90100@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52214EBC.90100@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 10:02:36PM -0400, Waiman Long wrote:

> I slapped in the code segment, and the following was logged:
> 
> [  340.871590] type = tmpfs
> [  340.871712]  [<ffffffff8116c5bd>] __fput+0x23d/0x270
> [  340.871715]  [<ffffffff8116c699>] ____fput+0x9/0x10
> [  340.871719]  [<ffffffff81068ae1>] task_work_run+0xb1/0xe0
> [  340.871724]  [<ffffffff81002990>] do_notify_resume+0x80/0x1b0
> [  340.871728]  [<ffffffff811ed120>] ? ipc_lock+0x30/0x50
> [  340.871732]  [<ffffffff8113a356>] ? remove_vma+0x56/0x60
> [  340.871736]  [<ffffffff8113c1bf>] ? do_munmap+0x34f/0x380
> [  340.871741]  [<ffffffff814a5fda>] int_signal+0x12/0x17
> [  340.871744] ---[ end trace aafa6c45f3388d65 ]---

Aha...  OK, I see what's going on.  We end up with shm_mnt *not* marked
as long-living vfsmount, even though it lives forever.  See if the
following helps; if it does (and I very much expect it to), we want to
put it in -stable.  As it is, you get slow path in mntput() each time
a file created by shmem_file_setup() gets closed.  For no reason whatsoever...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/mm/shmem.c b/mm/shmem.c
index e43dc55..445162c 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2615,7 +2615,7 @@ int shmem_fill_super(struct super_block *sb, void *data, int silent)
 	 * tmpfs instance, limiting inodes to one per page of lowmem;
 	 * but the internal instance is left unlimited.
 	 */
-	if (!(sb->s_flags & MS_NOUSER)) {
+	if (!(sb->s_flags & MS_KERNMOUNT)) {
 		sbinfo->max_blocks = shmem_default_max_blocks();
 		sbinfo->max_inodes = shmem_default_max_inodes();
 		if (shmem_parse_options(data, sbinfo, false)) {
@@ -2831,8 +2831,7 @@ int __init shmem_init(void)
 		goto out2;
 	}
 
-	shm_mnt = vfs_kern_mount(&shmem_fs_type, MS_NOUSER,
-				 shmem_fs_type.name, NULL);
+	shm_mnt = kern_mount(&shmem_fs_type);
 	if (IS_ERR(shm_mnt)) {
 		error = PTR_ERR(shm_mnt);
 		printk(KERN_ERR "Could not kern_mount tmpfs\n");
