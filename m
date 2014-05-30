Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030348AbaE3UFx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 16:05:53 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:56957 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030303AbaE3UFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 16:05:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, joseph@codesourcery.com,
        john.stultz@linaro.org, hch@infradead.org, tglx@linutronix.de,
        geert@linux-m68k.org, lftan@altera.com, hpa@zytor.com,
        linux-fsdevel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [RFC 04/32] fs: introduce sys_newfstat64/sys_newfstatat64
Date: Fri, 30 May 2014 22:01:28 +0200
Message-Id: <1401480116-1973111-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:xNBeO36rwAcgTdh52YyANCadDzGwoF5TgKXxsg4D/Sv
 37YmHccoxjzMFvWi0TTxqqNUtijefSfSjXEsKzbZQjVacfA6ps
 n1p/9CzYurR0lKCVAFLoUBSrwPmiIa60wOJrsKGF6EE8/xcryQ
 gX/2G3RfUdxXHTw8m6PObYN7WjdeJ9XChPM3RhBljGXEQ4z6jw
 o6IkOMUtvgDjID5Xt51ipqhn1XigyzMMiGmIHweq3kLITt4iOc
 +T65Rbce4tsYTJCR3cM3hwe8lpnU13pZLvqRt/hMOILkw2B/v3
 u6ON9rdjkGk5QSHDSVBnKkyWaJBQLbqbp1UAfybMbYm+HXfubN
 8+6kRja1cVQPiOIrC6ysWrlOmLbquUgVDuJgtX4oz
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want to be able to read file system timestamps beyond year 2038,
which is currently impossibly on 32-bit systems, since none of the
various stat syscall interfaces (oldstat, stat, stat64) handles
correctly.

This introduces a fourth version of the syscalls, called newfstat64
and newfstatat64, which operate on struct newstat64. Each 32-bit
architecture needs to define a version of this structure.
Architectures that have a 64-bit CPU should use the native 64-bit
'struct stat' if possible, so we can avoid adding a compat_newfstatat64
syscall. Note that there is no sys_newlstat64 or sys_newstat64,
as both can be trivially emulated from libc using newfstatat64.

This approach might not be the best solution, as there have been
proposals in the past to add a new 'struct xstat' interface that
would not only solve the y2038 problem but provide a number of
other extensions as well. I have chickened out and avoided reviving
that discussion for now. This new set of syscalls is a much simpler
addition and is hopefully less controversial.
If we end up merging xstat first, we won't need this patch.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/stat.c | 55 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/fs/stat.c b/fs/stat.c
index ae0c3ce..77fd219 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -445,6 +445,61 @@ SYSCALL_DEFINE4(fstatat64, int, dfd, const char __user *, filename,
 }
 #endif /* __ARCH_WANT_STAT64 || __ARCH_WANT_COMPAT_STAT64 */
 
+#ifdef __ARCH_HAS_NEWSTAT64
+/*
+ * we only need this for the native 32-bit path, all architectures should
+ * define the 32-bit newstat64 as compatible with the 64-bit stat or
+ * stat64.
+ */
+static long cp_new_newstat64(struct kstat *stat, struct newstat64 __user *statbuf)
+{
+	struct newstat64 tmp;
+
+	memset(&tmp, 0, sizeof(tmp));
+	tmp.st_dev = huge_encode_dev(stat->dev);
+	tmp.st_rdev = huge_encode_dev(stat->rdev);
+	tmp.st_ino = stat->ino;
+	tmp.st_mode = stat->mode;
+	tmp.st_nlink = stat->nlink;
+	tmp.st_uid = from_kuid_munged(current_user_ns(), stat->uid);
+	tmp.st_gid = from_kgid_munged(current_user_ns(), stat->gid);
+	tmp.st_atime = stat->atime.tv_sec;
+	tmp.st_atime_nsec = stat->atime.tv_nsec;
+	tmp.st_mtime = stat->mtime.tv_sec;
+	tmp.st_mtime_nsec = stat->mtime.tv_nsec;
+	tmp.st_ctime = stat->ctime.tv_sec;
+	tmp.st_ctime_nsec = stat->ctime.tv_nsec;
+	tmp.st_size = stat->size;
+	tmp.st_blocks = stat->blocks;
+	tmp.st_blksize = stat->blksize;
+	return copy_to_user(statbuf,&tmp,sizeof(tmp)) ? -EFAULT : 0;
+}
+
+SYSCALL_DEFINE2(newfstat64, unsigned long, fd, struct newstat64 __user *, statbuf)
+{
+	struct kstat stat;
+	int error;
+
+	error = vfs_fstat(fd, &stat);
+	if (error)
+		return error;
+
+	return cp_new_newstat64(&stat, statbuf);
+}
+
+SYSCALL_DEFINE4(newfstatat64, int, dfd, const char __user *, filename,
+		struct newstat64 __user *, statbuf, int, flag)
+{
+	struct kstat stat;
+	int error;
+
+	error = vfs_fstatat(dfd, filename, &stat, flag);
+	if (error)
+		return error;
+	return cp_new_newstat64(&stat, statbuf);
+}
+#endif
+
 /* Caller is here responsible for sufficient locking (ie. inode->i_lock) */
 void __inode_add_bytes(struct inode *inode, loff_t bytes)
 {
-- 
1.8.3.2

