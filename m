Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238Ab3BLWEG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 17:04:06 -0500
Received: from mout.gmx.net ([212.227.17.20]:56945 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754572Ab3BLWEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 17:04:04 -0500
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX1/DeJlWJMnDFLoNLlWlhl6SkMbTMoafOLOVvWPUkr
	nhb29SHwalV/zr
Date: Tue, 12 Feb 2013 23:03:55 +0100
From: Helge Deller <deller@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ian Kent <raven@themaw.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: [GIT PULL] autofs: automounter fix for 3.8
Message-ID: <20130212220355.GA1379@p100.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please consider pulling this late fix for autofs, which unbreaks
automounter support for the parisc architecture (and probably aarch64 as
well).

Thanks,
Helge
---

The following changes since commit 124b69b6cc1020fff589312c62fcaf360abd8d12:

  Merge tag 'fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux (2013-02-08 12:22:30 +1100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux.git autofs-fix

for you to fetch changes up to 4f4ffc3a5398ef9bdbb32db04756d7d34e356fcf:

  unbreak automounter support on 64-bit kernel with 32-bit userspace (v2) (2013-02-08 20:42:18 +0100)

----------------------------------------------------------------
Helge Deller (1):
      unbreak automounter support on 64-bit kernel with 32-bit userspace (v2)

 include/uapi/linux/auto_fs.h | 25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)


----------------------------------------------------------------

unbreak automounter support on 64-bit kernel with 32-bit userspace (v2)

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

diff --git a/include/uapi/linux/auto_fs.h b/include/uapi/linux/auto_fs.h
index 77cdba9..bb991df 100644
--- a/include/uapi/linux/auto_fs.h
+++ b/include/uapi/linux/auto_fs.h
@@ -28,25 +28,16 @@
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

