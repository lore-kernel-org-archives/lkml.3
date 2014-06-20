Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757112AbaFTCMj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 22:12:39 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:51517 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbaFTCMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 22:12:37 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        "Daniel M. Weeks" <dan@danweeks.net>, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] initramfs: Support initrd that is bigger then 2G.
Date: Thu, 19 Jun 2014 19:12:16 -0700
Message-Id: <1403230336-10444-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4.5
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When initrd (compressed or not) is used, kernel report data corrupted
with /dev/ram0.

The root cause:
During initramfs checking, if it is initrd, it will be transferred to
/initrd.image with sys_write.
sys_write only support 2G-4K write, so if the initrd ram is more than
that, /initrd.image will not complete at all.

Add local sys_write_large to loop calling sys_write to workaround the
problem.

Also need to use that in write_buffer path for cpio that have file is
more than file.

At the same time, we don't need to worry about sys_read/sys_write in
do_mounts_rd.c::crd_load. As decompressor will have fill/flush that
means it will allocate buffer and buffer is smaller than 2G.

Test with uncompressed initrd, and compressed with gz, bz2, lzma,xz,
lzop.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 init/initramfs.c |   33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

Index: linux-2.6/init/initramfs.c
===================================================================
--- linux-2.6.orig/init/initramfs.c
+++ linux-2.6/init/initramfs.c
@@ -19,6 +19,26 @@
 #include <linux/syscalls.h>
 #include <linux/utime.h>
 
+static long __init sys_write_large(unsigned int fd, char *p,
+				   size_t count)
+{
+	ssize_t left = count;
+	long written;
+
+	/* sys_write only can write MAX_RW_COUNT aka 2G-4K bytes at most */
+	while (left > 0) {
+		written = sys_write(fd, p, left);
+
+		if (written <= 0)
+			break;
+
+		left -= written;
+		p += written;
+	}
+
+	return (written < 0) ? written : count;
+}
+
 static __initdata char *message;
 static void __init error(char *x)
 {
@@ -346,7 +366,7 @@ static int __init do_name(void)
 static int __init do_copy(void)
 {
 	if (count >= body_len) {
-		sys_write(wfd, victim, body_len);
+		sys_write_large(wfd, victim, body_len);
 		sys_close(wfd);
 		do_utime(vcollected, mtime);
 		kfree(vcollected);
@@ -354,7 +374,7 @@ static int __init do_copy(void)
 		state = SkipIt;
 		return 0;
 	} else {
-		sys_write(wfd, victim, count);
+		sys_write_large(wfd, victim, count);
 		body_len -= count;
 		eat(count);
 		return 1;
@@ -604,8 +624,13 @@ static int __init populate_rootfs(void)
 		fd = sys_open("/initrd.image",
 			      O_WRONLY|O_CREAT, 0700);
 		if (fd >= 0) {
-			sys_write(fd, (char *)initrd_start,
-					initrd_end - initrd_start);
+			long written = sys_write_large(fd, (char *)initrd_start,
+						initrd_end - initrd_start);
+
+			if (written != initrd_end - initrd_start)
+				pr_err("/initrd.image: incomplete write (%ld != %ld)\n",
+				       written, initrd_end - initrd_start);
+
 			sys_close(fd);
 			free_initrd();
 		}
