Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757644Ab3GLTjW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 15:39:22 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36897 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757444Ab3GLTjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 15:39:20 -0400
Date: Fri, 12 Jul 2013 20:39:19 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [git pull] vfs.git part 2
Message-ID: <20130712193919.GC4165@ZenIV.linux.org.uk>
References: <20130703122918.GK4165@ZenIV.linux.org.uk>
 <CA+55aFyyxJL1LyXZeBsf2ypriraj5ut1XkNDsunRBqgVjZU_6Q@mail.gmail.com>
 <20130712054817.GY4165@ZenIV.linux.org.uk>
 <8738rk9eai.fsf@rasmusvillemoes.dk>
 <20130712154833.GA4165@ZenIV.linux.org.uk>
 <87wqovviyy.fsf@rasmusvillemoes.dk>
 <20130712191321.GB4165@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130712191321.GB4165@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 08:13:21PM +0100, Al Viro wrote:

> > Using O_DIRECTORY when we don't want to open a directory, and omitting
> > O_CREAT when we do want to create something new, is somewhat
> > counter-intuitive, but I think this would solve the problem with old
> > kernels.
> 
> Hrm...  I can't say I like it, but it's almost OK; the only problem here
> is the bug fixed by commit bc77daa78 - on some of the old kernels (including
> 3.10, BTW) we used to allow opening /proc/self/fd/0 with O_DIRECTORY|O_RDWR ;-/
> 
> Said that, I think it's more tolerable than the kludge I came up with -
> one would need to pass it a procfs symlink as argument to hit that.
> Linus, your opinion?

I mean something like this:

Safer ABI for O_TMPFILE

[suggested by Rasmus Villemoes] make O_DIRECTORY | O_RDWR part of O_TMPFILE;
that will fail on old kernels in a lot more cases than what I came up with.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/arch/alpha/include/uapi/asm/fcntl.h b/arch/alpha/include/uapi/asm/fcntl.h
index dfdadb0..09f49a6 100644
--- a/arch/alpha/include/uapi/asm/fcntl.h
+++ b/arch/alpha/include/uapi/asm/fcntl.h
@@ -32,7 +32,7 @@
 #define O_SYNC		(__O_SYNC|O_DSYNC)
 
 #define O_PATH		040000000
-#define O_TMPFILE	0100000000
+#define __O_TMPFILE	0100000000
 
 #define F_GETLK		7
 #define F_SETLK		8
diff --git a/arch/parisc/include/uapi/asm/fcntl.h b/arch/parisc/include/uapi/asm/fcntl.h
index cc61c47..34a46cb 100644
--- a/arch/parisc/include/uapi/asm/fcntl.h
+++ b/arch/parisc/include/uapi/asm/fcntl.h
@@ -20,7 +20,7 @@
 #define O_INVISIBLE	004000000 /* invisible I/O, for DMAPI/XDSM */
 
 #define O_PATH		020000000
-#define O_TMPFILE	040000000
+#define __O_TMPFILE	040000000
 
 #define F_GETLK64	8
 #define F_SETLK64	9
diff --git a/arch/sparc/include/uapi/asm/fcntl.h b/arch/sparc/include/uapi/asm/fcntl.h
index d73e5e0..7e8ace5 100644
--- a/arch/sparc/include/uapi/asm/fcntl.h
+++ b/arch/sparc/include/uapi/asm/fcntl.h
@@ -35,7 +35,7 @@
 #define O_SYNC		(__O_SYNC|O_DSYNC)
 
 #define O_PATH		0x1000000
-#define O_TMPFILE	0x2000000
+#define __O_TMPFILE	0x2000000
 
 #define F_GETOWN	5	/*  for sockets. */
 #define F_SETOWN	6	/*  for sockets. */
diff --git a/fs/namei.c b/fs/namei.c
index b2beee7..8b61d10 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2977,7 +2977,7 @@ static struct file *path_openat(int dfd, struct filename *pathname,
 
 	file->f_flags = op->open_flag;
 
-	if (unlikely(file->f_flags & O_TMPFILE)) {
+	if (unlikely(file->f_flags & __O_TMPFILE)) {
 		error = do_tmpfile(dfd, pathname, nd, flags, op, file, &opened);
 		goto out;
 	}
diff --git a/fs/open.c b/fs/open.c
index fca72c4..2a7d4ee 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -840,8 +840,8 @@ static inline int build_open_flags(int flags, umode_t mode, struct open_flags *o
 	if (flags & __O_SYNC)
 		flags |= O_DSYNC;
 
-	if (flags & O_TMPFILE) {
-		if (!(flags & O_CREAT))
+	if (flags & __O_TMPFILE) {
+		if ((flags & O_TMPFILE) != O_TMPFILE)
 			return -EINVAL;
 		acc_mode = MAY_OPEN | ACC_MODE(flags);
 	} else if (flags & O_PATH) {
diff --git a/include/uapi/asm-generic/fcntl.h b/include/uapi/asm-generic/fcntl.h
index 06632be..9b19c49 100644
--- a/include/uapi/asm-generic/fcntl.h
+++ b/include/uapi/asm-generic/fcntl.h
@@ -84,10 +84,13 @@
 #define O_PATH		010000000
 #endif
 
-#ifndef O_TMPFILE
-#define O_TMPFILE	020000000
+#ifndef __O_TMPFILE
+#define __O_TMPFILE	020000000
 #endif
 
+/* a horrid kludge trying to make sure that this will fail on old kernels */
+#define O_TMPFILE (__O_TMPFILE | O_DIRECTORY | O_RDWR)
+
 #ifndef O_NDELAY
 #define O_NDELAY	O_NONBLOCK
 #endif
