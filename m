Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758780AbaGDPMn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 11:12:43 -0400
Received: from mout.gmx.net ([212.227.15.15]:49246 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751989AbaGDPMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 11:12:42 -0400
Date: Fri, 4 Jul 2014 17:12:35 +0200
From: Helge Deller <deller@gmx.de>
To: Eric Paris <eparis@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: Heinrich Schuchardt <xypron.glpk@gmx.de>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] fix fanotify_mark() breakage on big endian 32bit kernel
Message-ID: <20140704151235.GA22454@ls3530.dhcp.wdf.sap.corp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Provags-ID: V03:K0:m20eBqjmuoCLNrL/9XQ8e383jG6AjnQ2DltjC3+zCKqwIfF3CQ7
 CrL1Hug5bOkibvm3/oEGFMCXf6qdGIBrg3mPDyhFUABCaq/NVMFX/GJnF1sFwf44ISoSb6C
 rZlXR/LdsjBH+Qy42TzvdmhLtKYhX4NjQyCltRW1XxogAnMCF6LkOFrqCm5GW8bfkO3RXTY
 aH91zdQgkc1H8ewOpj5wQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch affects big endian architectures only.

On those with 32bit userspace and 64bit kernel (CONFIG_COMPAT=y) the
64bit mask parameter is correctly constructed out of two 32bit values in
the compat_fanotify_mark() function and then passed as 64bit parameter
to the fanotify_mark() syscall.

But for the CONFIG_COMPAT=n case (32bit kernel & userspace),
compat_fanotify_mark() isn't used and the fanotify_mark syscall implementation
is used directly. In that case the upper and lower 32 bits of the 64bit mask
parameter is still swapped on big endian machines and thus leads to
fanotify_mark failing with -EINVAL.

Here is a strace of the same 32bit executable (fanotify01 testcase from LTP):

On a 64bit kernel it suceeds:
syscall_322(0, 0, 0x3, 0x3, 0x266c8, 0x1) = 0x3
syscall_323(0x3, 0x1, 0, 0x3b, 0xffffff9c, 0x266c8) = 0

On a 32bit kernel it fails:
syscall_322(0, 0, 0x3, 0x3, 0x266c8, 0x1) = 0x3
syscall_323(0x3, 0x1, 0, 0x3b, 0xffffff9c, 0x266c8) = -1 (errno 22)

Below is the easiest fix for this problem by simply swapping the upper and
lower 32bit of the 64 bit mask parameter when building a pure 32bit kernel.

But on the other side, using __u64 in a syscall API is IMHO wrong.  This may
easily break 32bit kernel builds, esp. on big endian machines.

The clean solution would probably be to use SYSCALL_DEFINE5() when
building a 64bit-kernel, and SYSCALL_DEFINE6() for fanotify_mark() when
building a pure 32bit kernel, something like this:

#ifdef CONFIG_64BIT
SYSCALL_DEFINE5(fanotify_mark, int, fanotify_fd, unsigned int, flags,
                              __u64, mask, int, dfd,
                              const char  __user *, pathname)
#else
SYSCALL_DEFINE6(fanotify_mark, int, fanotify_fd, unsigned int, flags,
                                __u32, mask0, __u32, mask1, int, dfd,
                                const char  __user *, pathname)
#endif


Signed-off-by: Helge Deller <deller@gmx.de>
To: Eric Paris <eparis@redhat.com>
Cc: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>


diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 3fdc8a3..374261c 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -787,6 +787,10 @@ SYSCALL_DEFINE5(fanotify_mark, int, fanotify_fd, unsigned int, flags,
 	struct path path;
 	int ret;
 
+#if defined(__BIG_ENDIAN) && !defined(CONFIG_64BIT)
+	mask = (mask << 32) | (mask >> 32);
+#endif
+
 	pr_debug("%s: fanotify_fd=%d flags=%x dfd=%d pathname=%p mask=%llx\n",
 		 __func__, fanotify_fd, flags, dfd, pathname, mask);
 
