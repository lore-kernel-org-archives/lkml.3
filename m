Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185Ab3IAVYQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 17:24:16 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49927 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784Ab3IAVYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 17:24:12 -0400
Date: Sun, 1 Sep 2013 22:23:56 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sedat Dilek <sedat.dilek@gmail.com>, Waiman Long <waiman.long@hp.com>,
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
Message-ID: <20130901212355.GU13318@ZenIV.linux.org.uk>
References: <CA+icZUX3zQEWDoaXk0RMKmbQhDRo0Z7jGZ=9tJu1gZWvGodMkg@mail.gmail.com>
 <CA+icZUUDKExRW3iNXj6jTs8A4DwQNaWvPuUfV5_ExXNPzq=+rA@mail.gmail.com>
 <CA+55aFxvEjdEFK0dXn783eVN0PEXVhb5k8OnrbxSWDpXgyTwWw@mail.gmail.com>
 <CA+icZUXcn6-A+AW5bu_pfRdOcScsNyn3-OZe6n93S5NUEzHtcg@mail.gmail.com>
 <CA+55aFwHx=tCzdo50jJB0ey7-CTVSo6RRQHe6R9fAya7nPn00A@mail.gmail.com>
 <CA+icZUWmQHWHMr1symL7j0iYqUMJBiOuRJ=EJz4F-xkQtdnJLg@mail.gmail.com>
 <CA+55aFxwjx30pC=kcfvOzgJvt2KK9DLm2i6JKYYz+mtOOJEnMA@mail.gmail.com>
 <CA+icZUUwy=sbt6BOirH6N4mSrQOykb=Z3GSdCb7vy_eVfG2RYw@mail.gmail.com>
 <CA+55aFwU054C+zC+G+JrF4ngWvVmvD9WPGWaT_2=nF2j7bpHxA@mail.gmail.com>
 <CA+55aFyc17miqwhncAKsanPQ9fHX_czQx+g-a9At_S1-XNpyKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyc17miqwhncAKsanPQ9fHX_czQx+g-a9At_S1-XNpyKA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 01, 2013 at 01:59:22PM -0700, Linus Torvalds wrote:

> [ Side note: Al, that lg_local_lock really is annoying: it's
> br_read_lock(mntput_no_expire), with two thirds of the calls coming
> from mntput_no_expire, and the rest from path_init -> lock_rcu_walk.

How much of that is due to br_write_lock() taken in mntput_no_expire()
for no good reason?  IOW, could you try shmem.c patch I've sent yesterday
and see how much effect does it have?[1]  Basically, we get it grabbed
exclusive on each final fput() of a struct file created by shmem_file_setup(),
which is _not_ a rare event.  And the only reason for that is not having
shm_mnt marked long-living, even though its refcount never hits 0...
 
>   I really really wonder if we could get rid of the
> br_read_lock(&vfsmount_lock) for rcu_walk_init(), and use just the RCU
> read accesses for the mount-namespaces too. What is that lock really
> protecting against during lookup anyway? ]

A lot of things, I'm afraid.  It's not as simple as just the access
to vfsmount hash... ;-/  I'll need to do some digging to put together
a full analysis, but there had been quite a few subtle issues where
it played...

[1] sits in the local queue, will push tonight:

commit e7db6c4c1d01032f53262f03b5f38899f9db8add
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Sat Aug 31 12:57:10 2013 -0400

shm_mnt is as longterm as it gets, TYVM...
    
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
