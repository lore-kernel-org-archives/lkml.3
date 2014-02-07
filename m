Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932534AbaBGLwY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:52:24 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42389 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755291AbaBGLwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:52:17 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: PaX Team <pageexec@freemail.hu>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 199/233] x86, x32: Correct invalid use of user timespec in the kernel
Date: Fri,  7 Feb 2014 11:46:58 +0000
Message-Id: <1391773652-25214-200-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: PaX Team <pageexec@freemail.hu>

commit 2def2ef2ae5f3990aabdbe8a755911902707d268 upstream.

The x32 case for the recvmsg() timout handling is broken:

  asmlinkage long compat_sys_recvmmsg(int fd, struct compat_mmsghdr __user *mmsg,
                                      unsigned int vlen, unsigned int flags,
                                      struct compat_timespec __user *timeout)
  {
          int datagrams;
          struct timespec ktspec;

          if (flags & MSG_CMSG_COMPAT)
                  return -EINVAL;

          if (COMPAT_USE_64BIT_TIME)
                  return __sys_recvmmsg(fd, (struct mmsghdr __user *)mmsg, vlen,
                                        flags | MSG_CMSG_COMPAT,
                                        (struct timespec *) timeout);
          ...

The timeout pointer parameter is provided by userland (hence the __user
annotation) but for x32 syscalls it's simply cast to a kernel pointer
and is passed to __sys_recvmmsg which will eventually directly
dereference it for both reading and writing.  Other callers to
__sys_recvmmsg properly copy from userland to the kernel first.

The bug was introduced by commit ee4fa23c4bfc ("compat: Use
COMPAT_USE_64BIT_TIME in net/compat.c") and should affect all kernels
since 3.4 (and perhaps vendor kernels if they backported x32 support
along with this code).

Note that CONFIG_X86_X32_ABI gets enabled at build time and only if
CONFIG_X86_X32 is enabled and ld can build x32 executables.

Other uses of COMPAT_USE_64BIT_TIME seem fine.

This addresses CVE-2014-0038.

Signed-off-by: PaX Team <pageexec@freemail.hu>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/compat.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/net/compat.c b/net/compat.c
index dd32e34..f50161f 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -780,21 +780,16 @@ asmlinkage long compat_sys_recvmmsg(int fd, struct compat_mmsghdr __user *mmsg,
 	if (flags & MSG_CMSG_COMPAT)
 		return -EINVAL;
 
-	if (COMPAT_USE_64BIT_TIME)
-		return __sys_recvmmsg(fd, (struct mmsghdr __user *)mmsg, vlen,
-				      flags | MSG_CMSG_COMPAT,
-				      (struct timespec *) timeout);
-
 	if (timeout == NULL)
 		return __sys_recvmmsg(fd, (struct mmsghdr __user *)mmsg, vlen,
 				      flags | MSG_CMSG_COMPAT, NULL);
 
-	if (get_compat_timespec(&ktspec, timeout))
+	if (compat_get_timespec(&ktspec, timeout))
 		return -EFAULT;
 
 	datagrams = __sys_recvmmsg(fd, (struct mmsghdr __user *)mmsg, vlen,
 				   flags | MSG_CMSG_COMPAT, &ktspec);
-	if (datagrams > 0 && put_compat_timespec(&ktspec, timeout))
+	if (datagrams > 0 && compat_put_timespec(&ktspec, timeout))
 		datagrams = -EFAULT;
 
 	return datagrams;
-- 
1.8.3.2

