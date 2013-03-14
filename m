Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360Ab3CNKv1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:51:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51941 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756975Ab3CNKhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:37:42 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Helge Deller <deller@gmx.de>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Rolf Eike Beer <eike-kernel@sf-tec.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 47/88] unbreak automounter support on 64-bit kernel with 32-bit userspace (v2)
Date: Thu, 14 Mar 2013 10:35:40 +0000
Message-Id: <1363257381-15900-48-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit 4f4ffc3a5398ef9bdbb32db04756d7d34e356fcf upstream.

automount-support is broken on the parisc architecture, because the existing
architecture is similiar to other 64bit Linux targets where we have to define
autofs_wqt_t (which is passed back and forth to user space) as int type which
has a size of 32bit across 32 and 64bit kernels.

During the discussion on the mailing list, H. Peter Anvin suggested to invert
the #if list since only specific platforms (specifically those who do not have
a 32bit userspace, like IA64 and Alpha) should have autofs_wqt_t as unsigned
long type.

This suggestion is probably the best way to go, since Arm64 (and maybe others?)
seems to have a non-working automounter. So in the long run even for other new
upcoming architectures this inverted check seem to be the best solution, since
it will not require them to change this #if again (unless they are 64bit only).

Signed-off-by: Helge Deller <deller@gmx.de>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Acked-by: Ian Kent <raven@themaw.net>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Rolf Eike Beer <eike-kernel@sf-tec.de>
[ luis: adjusted file name ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/auto_fs.h | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/include/linux/auto_fs.h b/include/linux/auto_fs.h
index da64e15..92bb651 100644
--- a/include/linux/auto_fs.h
+++ b/include/linux/auto_fs.h
@@ -31,25 +31,17 @@
 #define AUTOFS_MIN_PROTO_VERSION	AUTOFS_PROTO_VERSION
 
 /*
- * Architectures where both 32- and 64-bit binaries can be executed
- * on 64-bit kernels need this.  This keeps the structure format
- * uniform, and makes sure the wait_queue_token isn't too big to be
- * passed back down to the kernel.
- *
- * This assumes that on these architectures:
- * mode     32 bit    64 bit
- * -------------------------
- * int      32 bit    32 bit
- * long     32 bit    64 bit
- *
- * If so, 32-bit user-space code should be backwards compatible.
+ * The wait_queue_token (autofs_wqt_t) is part of a structure which is passed
+ * back to the kernel via ioctl from userspace. On architectures where 32- and
+ * 64-bit userspace binaries can be executed it's important that the size of
+ * autofs_wqt_t stays constant between 32- and 64-bit Linux kernels so that we
+ * do not break the binary ABI interface by changing the structure size.
  */
 
-#if defined(__sparc__) || defined(__mips__) || defined(__x86_64__) \
- || defined(__powerpc__) || defined(__s390__)
-typedef unsigned int autofs_wqt_t;
-#else
+#if defined(__ia64__) || defined(__alpha__) /* pure 64bit architectures */
 typedef unsigned long autofs_wqt_t;
+#else
+typedef unsigned int autofs_wqt_t;
 #endif
 
 /* Packet types */
-- 
1.8.1.2

