Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070Ab3ICGBg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 02:01:36 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:57567 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab3ICGBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 02:01:34 -0400
Date: Tue, 3 Sep 2013 08:01:30 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Waiman Long <waiman.long@hp.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
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
Message-ID: <20130903060130.GD16261@gmail.com>
References: <5220F090.5050908@hp.com>
 <20130830194059.GC13318@ZenIV.linux.org.uk>
 <5220F811.9060902@hp.com>
 <20130830202608.GD13318@ZenIV.linux.org.uk>
 <52210225.60805@hp.com>
 <20130830204852.GE13318@ZenIV.linux.org.uk>
 <52214EBC.90100@hp.com>
 <20130831023516.GI13318@ZenIV.linux.org.uk>
 <20130831024233.GJ13318@ZenIV.linux.org.uk>
 <5224E647.80303@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5224E647.80303@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Waiman Long <waiman.long@hp.com> wrote:

> On 08/30/2013 10:42 PM, Al Viro wrote:
> >On Sat, Aug 31, 2013 at 03:35:16AM +0100, Al Viro wrote:
> >
> >>Aha...  OK, I see what's going on.  We end up with shm_mnt *not* marked
> >>as long-living vfsmount, even though it lives forever.  See if the
> >>following helps; if it does (and I very much expect it to), we want to
> >>put it in -stable.  As it is, you get slow path in mntput() each time
> >>a file created by shmem_file_setup() gets closed.  For no reason whatsoever...
> >We still want MS_NOUSER on shm_mnt, so we'd better make sure that
> >shmem_fill_super() sets it on the internal instance...  Fixed variant
> >follows:
> >
> >Signed-off-by: Al Viro<viro@zeniv.linux.org.uk>
> >diff --git a/mm/shmem.c b/mm/shmem.c
> >index e43dc55..5261498 100644
> >--- a/mm/shmem.c
> >+++ b/mm/shmem.c
> >@@ -2615,13 +2615,15 @@ int shmem_fill_super(struct super_block *sb, void *data, int silent)
> >  	 * tmpfs instance, limiting inodes to one per page of lowmem;
> >  	 * but the internal instance is left unlimited.
> >  	 */
> >-	if (!(sb->s_flags&  MS_NOUSER)) {
> >+	if (!(sb->s_flags&  MS_KERNMOUNT)) {
> >  		sbinfo->max_blocks = shmem_default_max_blocks();
> >  		sbinfo->max_inodes = shmem_default_max_inodes();
> >  		if (shmem_parse_options(data, sbinfo, false)) {
> >  			err = -EINVAL;
> >  			goto failed;
> >  		}
> >+	} else {
> >+		sb->s_flags |= MS_NOUSER;
> >  	}
> >  	sb->s_export_op =&shmem_export_ops;
> >  	sb->s_flags |= MS_NOSEC;
> >@@ -2831,8 +2833,7 @@ int __init shmem_init(void)
> >  		goto out2;
> >  	}
> >
> >-	shm_mnt = vfs_kern_mount(&shmem_fs_type, MS_NOUSER,
> >-				 shmem_fs_type.name, NULL);
> >+	shm_mnt = kern_mount(&shmem_fs_type);
> >  	if (IS_ERR(shm_mnt)) {
> >  		error = PTR_ERR(shm_mnt);
> >  		printk(KERN_ERR "Could not kern_mount tmpfs\n");
> 
> Yes, that patch worked. It eliminated the lglock as a bottleneck in
> the AIM7 workload. The lg_global_lock did not show up in the perf
> profile, whereas the lg_local_lock was only 0.07%.

Just curious: what's the worst bottleneck now in the optimized kernel? :-)

Thanks,

	Ingo
