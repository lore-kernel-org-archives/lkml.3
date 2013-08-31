Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab3HaCmk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 22:42:40 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35812 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504Ab3HaCmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 22:42:39 -0400
Date: Sat, 31 Aug 2013 03:42:33 +0100
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
Message-ID: <20130831024233.GJ13318@ZenIV.linux.org.uk>
References: <5220E56A.80603@hp.com>
 <CA+55aFzv9BZ2+B2NrNRRtTqnfgbH3LRSvSsUZVsy-g9OpM-8HA@mail.gmail.com>
 <5220F090.5050908@hp.com>
 <20130830194059.GC13318@ZenIV.linux.org.uk>
 <5220F811.9060902@hp.com>
 <20130830202608.GD13318@ZenIV.linux.org.uk>
 <52210225.60805@hp.com>
 <20130830204852.GE13318@ZenIV.linux.org.uk>
 <52214EBC.90100@hp.com>
 <20130831023516.GI13318@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130831023516.GI13318@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 31, 2013 at 03:35:16AM +0100, Al Viro wrote:

> Aha...  OK, I see what's going on.  We end up with shm_mnt *not* marked
> as long-living vfsmount, even though it lives forever.  See if the
> following helps; if it does (and I very much expect it to), we want to
> put it in -stable.  As it is, you get slow path in mntput() each time
> a file created by shmem_file_setup() gets closed.  For no reason whatsoever...

We still want MS_NOUSER on shm_mnt, so we'd better make sure that
shmem_fill_super() sets it on the internal instance...  Fixed variant
follows:

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
diff --git a/mm/shmem.c b/mm/shmem.c
index e43dc55..5261498 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2615,13 +2615,15 @@ int shmem_fill_super(struct super_block *sb, void *data, int silent)
 	 * tmpfs instance, limiting inodes to one per page of lowmem;
 	 * but the internal instance is left unlimited.
 	 */
-	if (!(sb->s_flags & MS_NOUSER)) {
+	if (!(sb->s_flags & MS_KERNMOUNT)) {
 		sbinfo->max_blocks = shmem_default_max_blocks();
 		sbinfo->max_inodes = shmem_default_max_inodes();
 		if (shmem_parse_options(data, sbinfo, false)) {
 			err = -EINVAL;
 			goto failed;
 		}
+	} else {
+		sb->s_flags |= MS_NOUSER;
 	}
 	sb->s_export_op = &shmem_export_ops;
 	sb->s_flags |= MS_NOSEC;
@@ -2831,8 +2833,7 @@ int __init shmem_init(void)
 		goto out2;
 	}
 
-	shm_mnt = vfs_kern_mount(&shmem_fs_type, MS_NOUSER,
-				 shmem_fs_type.name, NULL);
+	shm_mnt = kern_mount(&shmem_fs_type);
 	if (IS_ERR(shm_mnt)) {
 		error = PTR_ERR(shm_mnt);
 		printk(KERN_ERR "Could not kern_mount tmpfs\n");
