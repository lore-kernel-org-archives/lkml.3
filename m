Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab3CATq5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 14:46:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52057 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581Ab3CATqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:46:49 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Helge Deller <deller@gmx.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ian Kent <raven@themaw.net>, Catalin Marinas <catalin.marinas@arm.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: [ 21/30] unbreak automounter support on 64-bit kernel with 32-bit userspace (v2)
Date: Fri,  1 Mar 2013 11:45:42 -0800
Message-Id: <20130301194530.265582062@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130301194527.988540148@linuxfoundation.org>
References: <20130301194527.988540148@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit 4f4ffc3a5398ef9bdbb32db04756d7d34e356fcf upstream.

automount-support is broken on the parisc architecture, because the existing
#if list does not include a check for defined(__hppa__). The HPPA (parisc)
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/auto_fs.h |   25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

--- a/include/linux/auto_fs.h
+++ b/include/linux/auto_fs.h
@@ -31,25 +31,16 @@
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
-
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


