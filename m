Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab3BLFwb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 00:52:31 -0500
Received: from ozlabs.org ([203.10.76.45]:58395 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292Ab3BLFw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 00:52:29 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
        Stewart Smith <stewart@flamingspork.com>
Subject: Re: RFC: mincore: add a bit to indicate a page is dirty.
In-Reply-To: <20130211141239.f4decf03.akpm@linux-foundation.org>
References: <87a9rbh7b4.fsf@rustcorp.com.au> <20130211162701.GB13218@cmpxchg.org> <20130211141239.f4decf03.akpm@linux-foundation.org>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Tue, 12 Feb 2013 16:14:24 +1030
Message-ID: <87r4kmf5mv.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:
> On Mon, 11 Feb 2013 11:27:01 -0500
> Johannes Weiner <hannes@cmpxchg.org> wrote:
>
>> > Is PG_dirty the right choice?  Is that right for huge pages?  Should I
>> > assume is_migration_entry(entry) means it's not dirty, or is there some
>> > other check here?
>> 
>> If your only consequence of finding dirty pages is to sync, would you
>> be better off using fsync/fdatasync maybe?
>
> Yes, if the data is all on disk then an fsync() will be a no-op.  IOW,
>
> 	if (I need to fsync)
> 		fsync();
>
> is equivalent to
>
> 	fsync();
>
>
> Methinks we need to understand the requirement better.

I have a simple journalling system in userspace, to avoid sync
(ie. consistency, not necessarily durability).  It just records all the
write() calls.  See prototype code here (in ccan/softsync dir):

        https://github.com/rustyrussell/ccan/tree/softsync

The question is, when to do check/recovery.  I currently do it on every
open (yech).  One way is to only do that if the file is older than the
mount it's on (see attached patch, which has its own issues).  Or I can
delete the journal altogether any time the file is on disk, to indicate
no recovery is needed.

> Also, having to mmap the file to be able to query pagecache state is a
> hack.  Whatever happened to the fincore() patch?

Yes.  That would be great for non-thrashing backup programs, too.

Cheers,
Rusty.
diff --git a/fs/mount.h b/fs/mount.h
index cd50079..57e0113 100644
--- a/fs/mount.h
+++ b/fs/mount.h
@@ -49,6 +49,9 @@ struct mount {
 	int mnt_expiry_mark;		/* true if marked for expiry */
 	int mnt_pinned;
 	int mnt_ghosts;
+#ifdef CONFIG_PROC_FS
+	union ktime mnt_time;		/* time created. */
+#endif
 };
 
 #define MNT_NS_INTERNAL ERR_PTR(-EINVAL) /* distinct from any mnt_namespace */
diff --git a/fs/namespace.c b/fs/namespace.c
index 55605c5..19b5f1b 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -198,6 +198,9 @@ static struct mount *alloc_vfsmnt(const char *name)
 #ifdef CONFIG_FSNOTIFY
 		INIT_HLIST_HEAD(&mnt->mnt_fsnotify_marks);
 #endif
+#ifdef CONFIG_PROC_FS
+		mnt->mnt_time = ktime_get();
+#endif
 	}
 	return mnt;
 
diff --git a/fs/proc_namespace.c b/fs/proc_namespace.c
index 5fe34c3..0341c34 100644
--- a/fs/proc_namespace.c
+++ b/fs/proc_namespace.c
@@ -75,6 +75,15 @@ static void show_mnt_opts(struct seq_file *m, struct vfsmount *mnt)
 	}
 }
 
+static void show_mount_age(struct seq_file *m, struct mount *r)
+{
+	struct timeval age;
+
+	/* Age wearies us, but it's independent of time changes since boot. */
+	age = ktime_to_timeval(ktime_sub(ktime_get(), r->mnt_time));
+	seq_printf(m, ",age=%lu.%06lu", age.tv_sec, age.tv_usec);
+}
+
 static inline void mangle(struct seq_file *m, const char *s)
 {
 	seq_escape(m, s, " \t\n\\");
@@ -112,6 +121,7 @@ static int show_vfsmnt(struct seq_file *m, struct vfsmount *mnt)
 	if (err)
 		goto out;
 	show_mnt_opts(m, mnt);
+	show_mount_age(m, r);
 	if (sb->s_op->show_options)
 		err = sb->s_op->show_options(m, mnt_path.dentry);
 	seq_puts(m, " 0 0\n");
@@ -145,6 +155,7 @@ static int show_mountinfo(struct seq_file *m, struct vfsmount *mnt)
 
 	seq_puts(m, mnt->mnt_flags & MNT_READONLY ? " ro" : " rw");
 	show_mnt_opts(m, mnt);
+	show_mount_age(m, r);
 
 	/* Tagged fields ("foo:X" or "bar") */
 	if (IS_MNT_SHARED(r))
