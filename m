Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482Ab3HLT5L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 15:57:11 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:27329 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175Ab3HLT4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 15:56:45 -0400
Message-ID: <201308121956.r7CJuj0n010313@farm-0021.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 12 Aug 2013 15:00:51 -0400
Subject: [PATCH] tile: support FRAME_POINTER
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow enabling frame pointer support; this makes it easier to hook
into the various kernel features that claim they require it without
having to add Kconfig conditionals everywhere (a la mips, ppc, s390,
and microblaze).  When enabled, it basically eliminates leaf functions
as such, and stops optimizing tail and sibling calls.  It adds around
3% to the size of the kernel when enabled.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/Kconfig          |  1 +
 arch/tile/lib/Makefile     | 14 +++++++-------
 arch/tile/lib/cacheflush.c |  3 ++-
 arch/tile/lib/memcpy_64.c  |  3 ++-
 4 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index f965582..21bd588 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -22,6 +22,7 @@ config TILE
 	select GENERIC_CLOCKEVENTS
 	select MODULES_USE_ELF_RELA
 	select HAVE_ARCH_TRACEHOOK
+	select ARCH_WANT_FRAME_POINTERS
 	select HAVE_SYSCALL_TRACEPOINTS
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	select HAVE_DEBUG_STACKOVERFLOW
diff --git a/arch/tile/lib/Makefile b/arch/tile/lib/Makefile
index 5d84437..9adfd76 100644
--- a/arch/tile/lib/Makefile
+++ b/arch/tile/lib/Makefile
@@ -6,13 +6,13 @@ lib-y = cacheflush.o checksum.o cpumask.o delay.o uaccess.o \
 	memmove.o memcpy_$(BITS).o memchr_$(BITS).o memset_$(BITS).o \
 	strchr_$(BITS).o strlen_$(BITS).o strnlen_$(BITS).o
 
-ifeq ($(CONFIG_TILEGX),y)
-CFLAGS_REMOVE_memcpy_user_64.o = -fno-omit-frame-pointer
-lib-y += memcpy_user_64.o
-else
-lib-y += atomic_32.o atomic_asm_32.o memcpy_tile64.o
-endif
-
+lib-$(CONFIG_TILEGX) += memcpy_user_64.o
+lib-$(CONFIG_TILEPRO) += atomic_32.o atomic_asm_32.o memcpy_tile64.o
 lib-$(CONFIG_SMP) += spinlock_$(BITS).o usercopy_$(BITS).o
 
 obj-$(CONFIG_MODULES) += exports.o
+
+# The finv_buffer_remote() and copy_{to,from}_user() routines can't
+# have -pg added, since they both rely on being leaf functions.
+CFLAGS_REMOVE_cacheflush.o = -pg
+CFLAGS_REMOVE_memcpy_user_64.o = -pg
diff --git a/arch/tile/lib/cacheflush.c b/arch/tile/lib/cacheflush.c
index 2238b40..9c0ec22 100644
--- a/arch/tile/lib/cacheflush.c
+++ b/arch/tile/lib/cacheflush.c
@@ -36,7 +36,8 @@ static inline void force_load(char *p)
  * core (if "!hfh") or homed via hash-for-home (if "hfh"), waiting
  * until the memory controller holds the flushed values.
  */
-void finv_buffer_remote(void *buffer, size_t size, int hfh)
+void __attribute__((optimize("omit-frame-pointer")))
+finv_buffer_remote(void *buffer, size_t size, int hfh)
 {
 	char *p, *base;
 	size_t step_size, load_count;
diff --git a/arch/tile/lib/memcpy_64.c b/arch/tile/lib/memcpy_64.c
index 46fc160..4815354 100644
--- a/arch/tile/lib/memcpy_64.c
+++ b/arch/tile/lib/memcpy_64.c
@@ -54,7 +54,8 @@ void *memcpy(void *__restrict dstv, const void *__restrict srcv, size_t n)
  * macros to return a count of uncopied bytes due to mm fault.
  */
 #define RETVAL 0
-int USERCOPY_FUNC(void *__restrict dstv, const void *__restrict srcv, size_t n)
+int __attribute__((optimize("omit-frame-pointer")))
+USERCOPY_FUNC(void *__restrict dstv, const void *__restrict srcv, size_t n)
 #endif
 {
 	char *__restrict dst1 = (char *)dstv;
-- 
1.8.3.1

