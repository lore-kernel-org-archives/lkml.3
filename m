Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997AbaA2L52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 06:57:28 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:38893 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbaA2L51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 06:57:27 -0500
From: Nick Alcock <nick.alcock@oracle.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] vfs: respect FMODE_UNSIGNED_OFFSET in p(read|write)[v]*().
Emacs: if it payed rent for disk space, you'd be rich.
Date: Wed, 29 Jan 2014 11:57:20 +0000
Message-ID: <87ppnbf1b3.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because the pread and pwrite functions do not respect the unsigned
offset flag, you can read certain parts of /proc/$pid/mem via lseek()
and read(), but not via pread().  (This probably went unnoticed
because on i386 and x86-64, almost everything except the vdso is
normally located below the region where signed offsets become
negative: but this is not true on all platforms.)

Fixing pwrite() is currently academic because this flag is only
used by files that do not allow writing, but it is easiest to
be consistent and retain a similarity of form between the pread*()
and pwrite*() functions.

Signed-off-by: Nick Alcock <nick.alcock@oracle.com>
---
 fs/read_write.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 58e440d..f33f664 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -534,10 +534,12 @@ SYSCALL_DEFINE4(pread64, unsigned int, fd, char __user *, buf,
 	struct fd f;
 	ssize_t ret = -EBADF;
 
-	if (pos < 0)
+	f = fdget(fd);
+	if ((pos < 0) && (!f.file || !unsigned_offsets(f.file))) {
+		fdput(f);
 		return -EINVAL;
+	}
 
-	f = fdget(fd);
 	if (f.file) {
 		ret = -ESPIPE;
 		if (f.file->f_mode & FMODE_PREAD)
@@ -554,10 +556,12 @@ SYSCALL_DEFINE4(pwrite64, unsigned int, fd, const char __user *, buf,
 	struct fd f;
 	ssize_t ret = -EBADF;
 
-	if (pos < 0)
+	f = fdget(fd);
+	if ((pos < 0) && (!f.file || !unsigned_offsets(f.file))) {
+		fdput(f);
 		return -EINVAL;
+	}
 
-	f = fdget(fd);
 	if (f.file) {
 		ret = -ESPIPE;
 		if (f.file->f_mode & FMODE_PWRITE)  
@@ -847,10 +851,12 @@ SYSCALL_DEFINE5(preadv, unsigned long, fd, const struct iovec __user *, vec,
 	struct fd f;
 	ssize_t ret = -EBADF;
 
-	if (pos < 0)
+	f = fdget(fd);
+	if ((pos < 0) && (!f.file || !unsigned_offsets(f.file))) {
+		fdput(f);
 		return -EINVAL;
+	}
 
-	f = fdget(fd);
 	if (f.file) {
 		ret = -ESPIPE;
 		if (f.file->f_mode & FMODE_PREAD)
@@ -871,8 +877,10 @@ SYSCALL_DEFINE5(pwritev, unsigned long, fd, const struct iovec __user *, vec,
 	struct fd f;
 	ssize_t ret = -EBADF;
 
-	if (pos < 0)
+	if ((pos < 0) && (!f.file || !unsigned_offsets(f.file))) {
+		f = fdget(fd);
 		return -EINVAL;
+	}
 
 	f = fdget(fd);
 	if (f.file) {
-- 
1.8.5.2.169.ge058798
