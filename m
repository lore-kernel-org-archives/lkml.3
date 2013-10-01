Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751477Ab3JAFMi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 01:12:38 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:63010 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab3JAFMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 01:12:36 -0400
Message-ID: <1380604354.19002.9.camel@edumazet-glaptop.roam.corp.google.com>
Subject: Re: spinlock contention of files->file_lock
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Waiman Long <Waiman.Long@hp.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Date: Mon, 30 Sep 2013 22:12:34 -0700
In-Reply-To: <1380598571.19002.6.camel@edumazet-glaptop.roam.corp.google.com>
References: <CA+55aFwp-RAKEMVvbMG53C=kTMqS09NPXy1eP4xEUYZpvV8X5Q@mail.gmail.com>
	 <1380589503.5326.13.camel@edumazet-glaptop.roam.corp.google.com>
	 <20131001015344.GV13318@ZenIV.linux.org.uk>
	 <CA+55aFz3gJE_DpZufTDNoRZ=vgJS3OwMspR7ZSqzGY_rWMq4gQ@mail.gmail.com>
	 <20131001032715.GW13318@ZenIV.linux.org.uk>
	 <1380598571.19002.6.camel@edumazet-glaptop.roam.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-30 at 20:36 -0700, Eric Dumazet wrote:

> I have a patch mostly working here, and pretty short.

Here is the RFC patch. Unfortunately I cant really give performance
numbers, as a patch like this would need weeks before being tested here.

 fs/file.c               |   66 ++++++++++++++++++++------------------
 include/linux/fdtable.h |    1 
 2 files changed, 37 insertions(+), 30 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index 4a78f98..b511f14 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -62,15 +62,23 @@ static void free_fdtable_rcu(struct rcu_head *rcu)
  * Expand the fdset in the files_struct.  Called with the files spinlock
  * held for write.
  */
-static void copy_fdtable(struct fdtable *nfdt, struct fdtable *ofdt)
+static void copy_fdtable(struct fdtable *nfdt, struct fdtable *ofdt,
+			 bool shared)
 {
-	unsigned int cpy, set;
+	unsigned int cpy, set, i;
 
 	BUG_ON(nfdt->max_fds < ofdt->max_fds);
 
 	cpy = ofdt->max_fds * sizeof(struct file *);
 	set = (nfdt->max_fds - ofdt->max_fds) * sizeof(struct file *);
-	memcpy(nfdt->fd, ofdt->fd, cpy);
+
+	if (shared) {
+		/* see fd_install() why we need xchg() */
+		for (i = 0; i < ofdt->max_fds; i++)
+			nfdt->fd[i] = xchg(&ofdt->fd[i], NULL);
+	} else {
+		memcpy(nfdt->fd, ofdt->fd, cpy);
+	}
 	memset((char *)(nfdt->fd) + cpy, 0, set);
 
 	cpy = ofdt->max_fds / BITS_PER_BYTE;
@@ -167,8 +175,12 @@ static int expand_fdtable(struct files_struct *files, int nr)
 	cur_fdt = files_fdtable(files);
 	if (nr >= cur_fdt->max_fds) {
 		/* Continue as planned */
-		copy_fdtable(new_fdt, cur_fdt);
+
+		write_seqlock(&files->resize);
+		copy_fdtable(new_fdt, cur_fdt, atomic_read(&files->count) > 1);
 		rcu_assign_pointer(files->fdt, new_fdt);
+		write_sequnlock(&files->resize);
+
 		if (cur_fdt != &files->fdtab)
 			call_rcu(&cur_fdt->rcu, free_fdtable_rcu);
 	} else {
@@ -258,6 +270,7 @@ struct files_struct *dup_fd(struct files_struct *oldf, int *errorp)
 	atomic_set(&newf->count, 1);
 
 	spin_lock_init(&newf->file_lock);
+	seqlock_init(&newf->resize);
 	newf->next_fd = 0;
 	new_fdt = &newf->fdtab;
 	new_fdt->max_fds = NR_OPEN_DEFAULT;
@@ -453,6 +466,7 @@ struct files_struct init_files = {
 		.open_fds	= init_files.open_fds_init,
 	},
 	.file_lock	= __SPIN_LOCK_UNLOCKED(init_files.file_lock),
+	.resize		= __SEQLOCK_UNLOCKED(init_task.resize),
 };
 
 /*
@@ -569,11 +583,24 @@ void __fd_install(struct files_struct *files, unsigned int fd,
 		struct file *file)
 {
 	struct fdtable *fdt;
-	spin_lock(&files->file_lock);
+	struct file *old;
+	unsigned int seq;
+
+	rcu_read_lock();
+retry:
+	seq = read_seqbegin(&files->resize);
 	fdt = files_fdtable(files);
-	BUG_ON(fdt->fd[fd] != NULL);
-	rcu_assign_pointer(fdt->fd[fd], file);
-	spin_unlock(&files->file_lock);
+	old = xchg(&fdt->fd[fd], file);
+	if (unlikely(old)) {
+		/* dup2() race */
+		fput(old);
+	}
+	if (unlikely(read_seqretry(&files->resize, seq))) {
+		if (cmpxchg(&fdt->fd[fd], file, NULL) == file)
+			goto retry;
+		/* 'file' was consumed by resizer or dup2(), we are done */
+	}
+	rcu_read_unlock();
 }
 
 void fd_install(unsigned int fd, struct file *file)
@@ -783,26 +810,9 @@ static int do_dup2(struct files_struct *files,
 	struct file *tofree;
 	struct fdtable *fdt;
 
-	/*
-	 * We need to detect attempts to do dup2() over allocated but still
-	 * not finished descriptor.  NB: OpenBSD avoids that at the price of
-	 * extra work in their equivalent of fget() - they insert struct
-	 * file immediately after grabbing descriptor, mark it larval if
-	 * more work (e.g. actual opening) is needed and make sure that
-	 * fget() treats larval files as absent.  Potentially interesting,
-	 * but while extra work in fget() is trivial, locking implications
-	 * and amount of surgery on open()-related paths in VFS are not.
-	 * FreeBSD fails with -EBADF in the same situation, NetBSD "solution"
-	 * deadlocks in rather amusing ways, AFAICS.  All of that is out of
-	 * scope of POSIX or SUS, since neither considers shared descriptor
-	 * tables and this condition does not arise without those.
-	 */
 	fdt = files_fdtable(files);
-	tofree = fdt->fd[fd];
-	if (!tofree && fd_is_open(fd, fdt))
-		goto Ebusy;
 	get_file(file);
-	rcu_assign_pointer(fdt->fd[fd], file);
+	tofree = xchg(&fdt->fd[fd], file);
 	__set_open_fd(fd, fdt);
 	if (flags & O_CLOEXEC)
 		__set_close_on_exec(fd, fdt);
@@ -814,10 +824,6 @@ static int do_dup2(struct files_struct *files,
 		filp_close(tofree, files);
 
 	return fd;
-
-Ebusy:
-	spin_unlock(&files->file_lock);
-	return -EBUSY;
 }
 
 int replace_fd(unsigned fd, struct file *file, unsigned flags)
diff --git a/include/linux/fdtable.h b/include/linux/fdtable.h
index 085197b..893c60f 100644
--- a/include/linux/fdtable.h
+++ b/include/linux/fdtable.h
@@ -49,6 +49,7 @@ struct files_struct {
 	atomic_t count;
 	struct fdtable __rcu *fdt;
 	struct fdtable fdtab;
+	seqlock_t resize;
   /*
    * written part on a separate cache line in SMP
    */


