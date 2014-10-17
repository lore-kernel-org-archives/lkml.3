Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647AbaJQIzU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 04:55:20 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:59842 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588AbaJQIzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 04:55:15 -0400
Date: Fri, 17 Oct 2014 10:55:09 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Maxim Patlasov <mpatlasov@parallels.com>, Anand Avati <avati@gluster.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael j Theall <mtheall@us.ibm.com>,
        fuse-devel <fuse-devel@lists.sourceforge.net>
Subject: Re: [PATCH 0/5] fuse: handle release synchronously (v4)
Message-ID: <20141017085509.GE5011@tucsk.piliscsaba.szeredi.hu>
References: <CA+55aFwfTeoCJDs6RJg++0SY=SsPrn7Y_Y0Ag_TsNvd6Vsj1Eg@mail.gmail.com>
 <CAFboF2yhGyjk4e_CHQV5b2WvB-QhsWNyHvFiFG_OM_=3-KArLQ@mail.gmail.com>
 <CA+55aFwqAOGbQ-LYmD-aSALTyA0p9=0vNdsJWd+uweUQyzsW8w@mail.gmail.com>
 <20140930191933.GC5011@tucsk.piliscsaba.szeredi.hu>
 <CA+55aFyD2Q6tJzRUbNyNFRdbSN09SAN9CqC5BTmCtOu4W9PKGw@mail.gmail.com>
 <542BE551.1010705@parallels.com>
 <CAJfpegs4Up_feUbqEGxfhq+rZneTmy0qcZy-k3so7VjufQY7-w@mail.gmail.com>
 <543F9E75.2090509@parallels.com>
 <CAJfpegvS+rmFqGgvHq183Z-MxLAwcgEB57LQxAwy3QAe5CaVwg@mail.gmail.com>
 <CA+55aFw68DMazGSu=YaOVVEWp=_LrD+2abah+5Tq3kpmH-r+Hg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw68DMazGSu=YaOVVEWp=_LrD+2abah+5Tq3kpmH-r+Hg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 03:54:42PM +0200, Linus Torvalds wrote:
> On Thu, Oct 16, 2014 at 3:43 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> >
> > One idea is to change ->flush() so it's responsible for fput()-ing the
> > file.  That way we could take control of the actual refcount
> > decrement.  There are only 20 flush instances in the tree, so it
> > wouldn't be a huge change.
> 
> Since that *still* wouldn't fix the problem with the whole "count
> elevated by other things" issue, I really don't want to hear about
> these random broken hacks that are fundamentally broken crap.

The problem with those "count elevated by other things" is that they are
actually bugs.  Take the following test case (this is not made up, I really got
bug reports agains something like this).

mount("/dev/foo", "/mnt");
fd = creat("/mnt/bar");
close(fd);
umount("/mnt")

If that umount fails with EBUSY, that's a bug, since we've released the only
known resource we've opened on that mount.

Now, if some completely unrelated "lsof" instance goes fishing in /proc, then
that will be able to hold that release up, making the test fail.

And it's actually trivially fixable.  See attached patch.

Thanks,
Miklos

diff --git a/fs/proc/fd.c b/fs/proc/fd.c
index e11d7c590bb0..f8a67dafb04f 100644
--- a/fs/proc/fd.c
+++ b/fs/proc/fd.c
@@ -19,6 +19,8 @@ static int seq_show(struct seq_file *m, void *v)
 {
 	struct files_struct *files = NULL;
 	int f_flags = 0, ret = -ENOENT;
+	loff_t f_pos;
+	int mnt_id;
 	struct file *file = NULL;
 	struct task_struct *task;
 
@@ -41,7 +43,13 @@ static int seq_show(struct seq_file *m, void *v)
 			if (close_on_exec(fd, fdt))
 				f_flags |= O_CLOEXEC;
 
-			get_file(file);
+			f_pos = file->f_pos;
+			mnt_id = real_mount(file->f_path.mnt)->mnt_id;
+
+			if (file->f_op->show_fdinfo)
+				get_file(file);
+			else
+				file = NULL;
 			ret = 0;
 		}
 		spin_unlock(&files->file_lock);
@@ -50,11 +58,11 @@ static int seq_show(struct seq_file *m, void *v)
 
 	if (!ret) {
 		seq_printf(m, "pos:\t%lli\nflags:\t0%o\nmnt_id:\t%i\n",
-			   (long long)file->f_pos, f_flags,
-			   real_mount(file->f_path.mnt)->mnt_id);
-		if (file->f_op->show_fdinfo)
+			   (long long) f_pos, f_flags, mnt_id);
+		if (file) {
 			ret = file->f_op->show_fdinfo(m, file);
-		fput(file);
+			fput(file);
+		}
 	}
 
 	return ret;
