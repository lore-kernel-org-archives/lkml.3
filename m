Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939Ab3DQJ5p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 05:57:45 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:57073 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757782Ab3DQJ5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 05:57:43 -0400
Date: Wed, 17 Apr 2013 11:57:28 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: Colin Cross <ccross@android.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, fuse-devel@lists.sourceforge.net,
        Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>
Subject: Re: [PATCH] fuse: use kernel headers when __KERNEL__ is set
Message-ID: <20130417095728.GA20829@tucsk.piliscsaba.szeredi.hu>
References: <1366058481-21033-1-git-send-email-ccross@android.com>
 <CAMbhsRT08Li=P0GnbW-XdwyDSFtOfbr2MiTLeh-DduMOx-g=zw@mail.gmail.com>
 <CAJfpegtJW+k6gLZ+jxJKp3Zj0UhCst3WD7N_xrybD59_0o7h5Q@mail.gmail.com>
 <CA+55aFzUFMOAfxBpsGLYW3R5NA+f+LWCcKoGdizh_PAhQiXDvg@mail.gmail.com>
 <CAJfpegtJrkii6LRxfoywyXsVtnBAgO4ZzBZOPd71BMz7evhPcQ@mail.gmail.com>
 <CA+55aFzA66RHjB2KsdCCbEf2NNBnO=-o_rAJ-xZ3sqY1mHoCRA@mail.gmail.com>
 <CAMbhsRSsd_zRApscGK5cUqR=ykuvEWA-DCMAXC1raWPtcuk4Dw@mail.gmail.com>
 <CAJfpegt53MRwiMgZTW2DogMWAR54vrPMG=D5Yqs_vpfccPi_5Q@mail.gmail.com>
 <CAMbhsRR7iWabAgMqJ8g6FJK+SMAf_s0Rrz+wHiODzoB6joAzCw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMbhsRR7iWabAgMqJ8g6FJK+SMAf_s0Rrz+wHiODzoB6joAzCw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 01:00:37PM -0700, Colin Cross wrote:

> Every other uapi header includes linux/types.h to get its type
> definitions, and fuse.h should do the same when compiling for
> userspace targeting linux

Not necessarily.

Here's a patch (largish but only search&replace) that should fix all the issues
and actually removes a hack instead of adding more.

Thanks,
Miklos
----

From: Miklos Szeredi <mszeredi@suse.cz>
Subject: fuse: fix type definitions in uapi header

Commit 7e98d53086d18c877cb44e9065219335184024de (Synchronize fuse
header with one used in library) added #ifdef __linux__ around
defines if it is not set.  The kernel build is self-contained and
can be built on non-Linux toolchains.  After the mentioned commit
builds on non-Linux toolchains will try to include stdint.h and
fail due to -nostdinc, and then fail with a bunch of undefined
type errors.

Fix by checking for __KERNEL__ instead of __linux__ and using the standard int
types instead of the linux specific ones.

Reported-by: Arve Hjønnevåg <arve@android.com>
Reported-by: Colin Cross <ccross@android.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 include/uapi/linux/fuse.h |  436 ++++++++++++++++++++++------------------------
 1 file changed, 216 insertions(+), 220 deletions(-)

--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -95,15 +95,10 @@
 #ifndef _LINUX_FUSE_H
 #define _LINUX_FUSE_H
 
-#ifdef __linux__
+#ifdef __KERNEL__
 #include <linux/types.h>
 #else
 #include <stdint.h>
-#define __u64 uint64_t
-#define __s64 int64_t
-#define __u32 uint32_t
-#define __s32 int32_t
-#define __u16 uint16_t
 #endif
 
 /*
@@ -139,42 +134,42 @@
    userspace works under 64bit kernels */
 
 struct fuse_attr {
-	__u64	ino;
-	__u64	size;
-	__u64	blocks;
-	__u64	atime;
-	__u64	mtime;
-	__u64	ctime;
-	__u32	atimensec;
-	__u32	mtimensec;
-	__u32	ctimensec;
-	__u32	mode;
-	__u32	nlink;
-	__u32	uid;
-	__u32	gid;
-	__u32	rdev;
-	__u32	blksize;
-	__u32	padding;
+	uint64_t	ino;
+	uint64_t	size;
+	uint64_t	blocks;
+	uint64_t	atime;
+	uint64_t	mtime;
+	uint64_t	ctime;
+	uint32_t	atimensec;
+	uint32_t	mtimensec;
+	uint32_t	ctimensec;
+	uint32_t	mode;
+	uint32_t	nlink;
+	uint32_t	uid;
+	uint32_t	gid;
+	uint32_t	rdev;
+	uint32_t	blksize;
+	uint32_t	padding;
 };
 
 struct fuse_kstatfs {
-	__u64	blocks;
-	__u64	bfree;
-	__u64	bavail;
-	__u64	files;
-	__u64	ffree;
-	__u32	bsize;
-	__u32	namelen;
-	__u32	frsize;
-	__u32	padding;
-	__u32	spare[6];
+	uint64_t	blocks;
+	uint64_t	bfree;
+	uint64_t	bavail;
+	uint64_t	files;
+	uint64_t	ffree;
+	uint32_t	bsize;
+	uint32_t	namelen;
+	uint32_t	frsize;
+	uint32_t	padding;
+	uint32_t	spare[6];
 };
 
 struct fuse_file_lock {
-	__u64	start;
-	__u64	end;
-	__u32	type;
-	__u32	pid; /* tgid */
+	uint64_t	start;
+	uint64_t	end;
+	uint32_t	type;
+	uint32_t	pid; /* tgid */
 };
 
 /**
@@ -364,143 +359,143 @@ enum fuse_notify_code {
 #define FUSE_COMPAT_ENTRY_OUT_SIZE 120
 
 struct fuse_entry_out {
-	__u64	nodeid;		/* Inode ID */
-	__u64	generation;	/* Inode generation: nodeid:gen must
-				   be unique for the fs's lifetime */
-	__u64	entry_valid;	/* Cache timeout for the name */
-	__u64	attr_valid;	/* Cache timeout for the attributes */
-	__u32	entry_valid_nsec;
-	__u32	attr_valid_nsec;
+	uint64_t	nodeid;		/* Inode ID */
+	uint64_t	generation;	/* Inode generation: nodeid:gen must
+					   be unique for the fs's lifetime */
+	uint64_t	entry_valid;	/* Cache timeout for the name */
+	uint64_t	attr_valid;	/* Cache timeout for the attributes */
+	uint32_t	entry_valid_nsec;
+	uint32_t	attr_valid_nsec;
 	struct fuse_attr attr;
 };
 
 struct fuse_forget_in {
-	__u64	nlookup;
+	uint64_t	nlookup;
 };
 
 struct fuse_forget_one {
-	__u64	nodeid;
-	__u64	nlookup;
+	uint64_t	nodeid;
+	uint64_t	nlookup;
 };
 
 struct fuse_batch_forget_in {
-	__u32	count;
-	__u32	dummy;
+	uint32_t	count;
+	uint32_t	dummy;
 };
 
 struct fuse_getattr_in {
-	__u32	getattr_flags;
-	__u32	dummy;
-	__u64	fh;
+	uint32_t	getattr_flags;
+	uint32_t	dummy;
+	uint64_t	fh;
 };
 
 #define FUSE_COMPAT_ATTR_OUT_SIZE 96
 
 struct fuse_attr_out {
-	__u64	attr_valid;	/* Cache timeout for the attributes */
-	__u32	attr_valid_nsec;
-	__u32	dummy;
+	uint64_t	attr_valid;	/* Cache timeout for the attributes */
+	uint32_t	attr_valid_nsec;
+	uint32_t	dummy;
 	struct fuse_attr attr;
 };
 
 #define FUSE_COMPAT_MKNOD_IN_SIZE 8
 
 struct fuse_mknod_in {
-	__u32	mode;
-	__u32	rdev;
-	__u32	umask;
-	__u32	padding;
+	uint32_t	mode;
+	uint32_t	rdev;
+	uint32_t	umask;
+	uint32_t	padding;
 };
 
 struct fuse_mkdir_in {
-	__u32	mode;
-	__u32	umask;
+	uint32_t	mode;
+	uint32_t	umask;
 };
 
 struct fuse_rename_in {
-	__u64	newdir;
+	uint64_t	newdir;
 };
 
 struct fuse_link_in {
-	__u64	oldnodeid;
+	uint64_t	oldnodeid;
 };
 
 struct fuse_setattr_in {
-	__u32	valid;
-	__u32	padding;
-	__u64	fh;
-	__u64	size;
-	__u64	lock_owner;
-	__u64	atime;
-	__u64	mtime;
-	__u64	unused2;
-	__u32	atimensec;
-	__u32	mtimensec;
-	__u32	unused3;
-	__u32	mode;
-	__u32	unused4;
-	__u32	uid;
-	__u32	gid;
-	__u32	unused5;
+	uint32_t	valid;
+	uint32_t	padding;
+	uint64_t	fh;
+	uint64_t	size;
+	uint64_t	lock_owner;
+	uint64_t	atime;
+	uint64_t	mtime;
+	uint64_t	unused2;
+	uint32_t	atimensec;
+	uint32_t	mtimensec;
+	uint32_t	unused3;
+	uint32_t	mode;
+	uint32_t	unused4;
+	uint32_t	uid;
+	uint32_t	gid;
+	uint32_t	unused5;
 };
 
 struct fuse_open_in {
-	__u32	flags;
-	__u32	unused;
+	uint32_t	flags;
+	uint32_t	unused;
 };
 
 struct fuse_create_in {
-	__u32	flags;
-	__u32	mode;
-	__u32	umask;
-	__u32	padding;
+	uint32_t	flags;
+	uint32_t	mode;
+	uint32_t	umask;
+	uint32_t	padding;
 };
 
 struct fuse_open_out {
-	__u64	fh;
-	__u32	open_flags;
-	__u32	padding;
+	uint64_t	fh;
+	uint32_t	open_flags;
+	uint32_t	padding;
 };
 
 struct fuse_release_in {
-	__u64	fh;
-	__u32	flags;
-	__u32	release_flags;
-	__u64	lock_owner;
+	uint64_t	fh;
+	uint32_t	flags;
+	uint32_t	release_flags;
+	uint64_t	lock_owner;
 };
 
 struct fuse_flush_in {
-	__u64	fh;
-	__u32	unused;
-	__u32	padding;
-	__u64	lock_owner;
+	uint64_t	fh;
+	uint32_t	unused;
+	uint32_t	padding;
+	uint64_t	lock_owner;
 };
 
 struct fuse_read_in {
-	__u64	fh;
-	__u64	offset;
-	__u32	size;
-	__u32	read_flags;
-	__u64	lock_owner;
-	__u32	flags;
-	__u32	padding;
+	uint64_t	fh;
+	uint64_t	offset;
+	uint32_t	size;
+	uint32_t	read_flags;
+	uint64_t	lock_owner;
+	uint32_t	flags;
+	uint32_t	padding;
 };
 
 #define FUSE_COMPAT_WRITE_IN_SIZE 24
 
 struct fuse_write_in {
-	__u64	fh;
-	__u64	offset;
-	__u32	size;
-	__u32	write_flags;
-	__u64	lock_owner;
-	__u32	flags;
-	__u32	padding;
+	uint64_t	fh;
+	uint64_t	offset;
+	uint32_t	size;
+	uint32_t	write_flags;
+	uint64_t	lock_owner;
+	uint32_t	flags;
+	uint32_t	padding;
 };
 
 struct fuse_write_out {
-	__u32	size;
-	__u32	padding;
+	uint32_t	size;
+	uint32_t	padding;
 };
 
 #define FUSE_COMPAT_STATFS_SIZE 48
@@ -510,32 +505,32 @@ struct fuse_statfs_out {
 };
 
 struct fuse_fsync_in {
-	__u64	fh;
-	__u32	fsync_flags;
-	__u32	padding;
+	uint64_t	fh;
+	uint32_t	fsync_flags;
+	uint32_t	padding;
 };
 
 struct fuse_setxattr_in {
-	__u32	size;
-	__u32	flags;
+	uint32_t	size;
+	uint32_t	flags;
 };
 
 struct fuse_getxattr_in {
-	__u32	size;
-	__u32	padding;
+	uint32_t	size;
+	uint32_t	padding;
 };
 
 struct fuse_getxattr_out {
-	__u32	size;
-	__u32	padding;
+	uint32_t	size;
+	uint32_t	padding;
 };
 
 struct fuse_lk_in {
-	__u64	fh;
-	__u64	owner;
+	uint64_t	fh;
+	uint64_t	owner;
 	struct fuse_file_lock lk;
-	__u32	lk_flags;
-	__u32	padding;
+	uint32_t	lk_flags;
+	uint32_t	padding;
 };
 
 struct fuse_lk_out {
@@ -543,134 +538,135 @@ struct fuse_lk_out {
 };
 
 struct fuse_access_in {
-	__u32	mask;
-	__u32	padding;
+	uint32_t	mask;
+	uint32_t	padding;
 };
 
 struct fuse_init_in {
-	__u32	major;
-	__u32	minor;
-	__u32	max_readahead;
-	__u32	flags;
+	uint32_t	major;
+	uint32_t	minor;
+	uint32_t	max_readahead;
+	uint32_t	flags;
 };
 
 struct fuse_init_out {
-	__u32	major;
-	__u32	minor;
-	__u32	max_readahead;
-	__u32	flags;
-	__u16   max_background;
-	__u16   congestion_threshold;
-	__u32	max_write;
+	uint32_t	major;
+	uint32_t	minor;
+	uint32_t	max_readahead;
+	uint32_t	flags;
+	uint16_t	max_background;
+	uint16_t	congestion_threshold;
+	uint32_t	max_write;
 };
 
 #define CUSE_INIT_INFO_MAX 4096
 
 struct cuse_init_in {
-	__u32	major;
-	__u32	minor;
-	__u32	unused;
-	__u32	flags;
+	uint32_t	major;
+	uint32_t	minor;
+	uint32_t	unused;
+	uint32_t	flags;
 };
 
 struct cuse_init_out {
-	__u32	major;
-	__u32	minor;
-	__u32	unused;
-	__u32	flags;
-	__u32	max_read;
-	__u32	max_write;
-	__u32	dev_major;		/* chardev major */
-	__u32	dev_minor;		/* chardev minor */
-	__u32	spare[10];
+	uint32_t	major;
+	uint32_t	minor;
+	uint32_t	unused;
+	uint32_t	flags;
+	uint32_t	max_read;
+	uint32_t	max_write;
+	uint32_t	dev_major;		/* chardev major */
+	uint32_t	dev_minor;		/* chardev minor */
+	uint32_t	spare[10];
 };
 
 struct fuse_interrupt_in {
-	__u64	unique;
+	uint64_t	unique;
 };
 
 struct fuse_bmap_in {
-	__u64	block;
-	__u32	blocksize;
-	__u32	padding;
+	uint64_t	block;
+	uint32_t	blocksize;
+	uint32_t	padding;
 };
 
 struct fuse_bmap_out {
-	__u64	block;
+	uint64_t	block;
 };
 
 struct fuse_ioctl_in {
-	__u64	fh;
-	__u32	flags;
-	__u32	cmd;
-	__u64	arg;
-	__u32	in_size;
-	__u32	out_size;
+	uint64_t	fh;
+	uint32_t	flags;
+	uint32_t	cmd;
+	uint64_t	arg;
+	uint32_t	in_size;
+	uint32_t	out_size;
 };
 
 struct fuse_ioctl_iovec {
-	__u64	base;
-	__u64	len;
+	uint64_t	base;
+	uint64_t	len;
 };
 
 struct fuse_ioctl_out {
-	__s32	result;
-	__u32	flags;
-	__u32	in_iovs;
-	__u32	out_iovs;
+	int32_t		result;
+	uint32_t	flags;
+	uint32_t	in_iovs;
+	uint32_t	out_iovs;
 };
 
 struct fuse_poll_in {
-	__u64	fh;
-	__u64	kh;
-	__u32	flags;
-	__u32   events;
+	uint64_t	fh;
+	uint64_t	kh;
+	uint32_t	flags;
+	uint32_t	events;
 };
 
 struct fuse_poll_out {
-	__u32	revents;
-	__u32	padding;
+	uint32_t	revents;
+	uint32_t	padding;
 };
 
 struct fuse_notify_poll_wakeup_out {
-	__u64	kh;
+	uint64_t	kh;
 };
 
 struct fuse_fallocate_in {
-	__u64	fh;
-	__u64	offset;
-	__u64	length;
-	__u32	mode;
-	__u32	padding;
+	uint64_t	fh;
+	uint64_t	offset;
+	uint64_t	length;
+	uint32_t	mode;
+	uint32_t	padding;
 };
 
 struct fuse_in_header {
-	__u32	len;
-	__u32	opcode;
-	__u64	unique;
-	__u64	nodeid;
-	__u32	uid;
-	__u32	gid;
-	__u32	pid;
-	__u32	padding;
+	uint32_t	len;
+	uint32_t	opcode;
+	uint64_t	unique;
+	uint64_t	nodeid;
+	uint32_t	uid;
+	uint32_t	gid;
+	uint32_t	pid;
+	uint32_t	padding;
 };
 
 struct fuse_out_header {
-	__u32	len;
-	__s32	error;
-	__u64	unique;
+	uint32_t	len;
+	int32_t		error;
+	uint64_t	unique;
 };
 
 struct fuse_dirent {
-	__u64	ino;
-	__u64	off;
-	__u32	namelen;
-	__u32	type;
+	uint64_t	ino;
+	uint64_t	off;
+	uint32_t	namelen;
+	uint32_t	type;
 	char name[];
 };
 
 #define FUSE_NAME_OFFSET offsetof(struct fuse_dirent, name)
-#define FUSE_DIRENT_ALIGN(x) (((x) + sizeof(__u64) - 1) & ~(sizeof(__u64) - 1))
+#define FUSE_DIRENT_ALIGN(x) \
+	(((x) + sizeof(uint64_t) - 1) & ~(sizeof(uint64_t) - 1))
 #define FUSE_DIRENT_SIZE(d) \
 	FUSE_DIRENT_ALIGN(FUSE_NAME_OFFSET + (d)->namelen)
 
@@ -685,47 +681,47 @@ struct fuse_direntplus {
 	FUSE_DIRENT_ALIGN(FUSE_NAME_OFFSET_DIRENTPLUS + (d)->dirent.namelen)
 
 struct fuse_notify_inval_inode_out {
-	__u64	ino;
-	__s64	off;
-	__s64	len;
+	uint64_t	ino;
+	int64_t		off;
+	int64_t		len;
 };
 
 struct fuse_notify_inval_entry_out {
-	__u64	parent;
-	__u32	namelen;
-	__u32	padding;
+	uint64_t	parent;
+	uint32_t	namelen;
+	uint32_t	padding;
 };
 
 struct fuse_notify_delete_out {
-	__u64	parent;
-	__u64	child;
-	__u32	namelen;
-	__u32	padding;
+	uint64_t	parent;
+	uint64_t	child;
+	uint32_t	namelen;
+	uint32_t	padding;
 };
 
 struct fuse_notify_store_out {
-	__u64	nodeid;
-	__u64	offset;
-	__u32	size;
-	__u32	padding;
+	uint64_t	nodeid;
+	uint64_t	offset;
+	uint32_t	size;
+	uint32_t	padding;
 };
 
 struct fuse_notify_retrieve_out {
-	__u64	notify_unique;
-	__u64	nodeid;
-	__u64	offset;
-	__u32	size;
-	__u32	padding;
+	uint64_t	notify_unique;
+	uint64_t	nodeid;
+	uint64_t	offset;
+	uint32_t	size;
+	uint32_t	padding;
 };
 
 /* Matches the size of fuse_write_in */
 struct fuse_notify_retrieve_in {
-	__u64	dummy1;
-	__u64	offset;
-	__u32	size;
-	__u32	dummy2;
-	__u64	dummy3;
-	__u64	dummy4;
+	uint64_t	dummy1;
+	uint64_t	offset;
+	uint32_t	size;
+	uint32_t	dummy2;
+	uint64_t	dummy3;
+	uint64_t	dummy4;
 };
 
 #endif /* _LINUX_FUSE_H */
