Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220AbaFLPmq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 11:42:46 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:49646 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008AbaFLPmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 11:42:45 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        Rob Clark <robdclark@gmail.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org
Subject: [PATCH v3] ARM: add get_user() support for 8 byte types
Date: Thu, 12 Jun 2014 16:42:35 +0100
Message-Id: <1402587755-29245-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A new atomic modeset/pageflip ioctl being developed in DRM requires
get_user() to work for 64bit types (in addition to just put_user()).

v1: original
v2: pass correct size to check_uaccess, and better handling of narrowing
    double word read with __get_user_xb() (Russell King's suggestion)
v3: fix a couple of checkpatch issues

Signed-off-by: Rob Clark <robdclark@gmail.com>
Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
---

Notes:
    I'd like to wake this patch up again. It was rejected back in 2012 on
    the grounds that other architectures (notably x86-32) didn't implement
    this so adding for ARM risked portability problems in drivers. However
    shortly after the discussion (in fact I believe that as a *result* of
    that discussion) support for 64-bit get_user() was added for x86-32.
    
    A quick review of different architectures uaccess.h shows that ARM is
    in the minority (even after excluding 64-bit architectures) in not
    implementing this feature.
    
    The reasons to wake it up are the same as before. Recent contributions,
    including to DRM[1] and binder[2] would prefer to use the 64-bit values
    in their interfaces without gotchas like having to use copy_from_user().
    
    [1] http://thread.gmane.org/gmane.comp.video.dri.devel/102135/focus=102149
    [2] http://thread.gmane.org/gmane.linux.kernel/1653448/focus=1653449

 arch/arm/include/asm/uaccess.h | 18 +++++++++++++++++-
 arch/arm/lib/getuser.S         | 17 ++++++++++++++++-
 2 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/uaccess.h b/arch/arm/include/asm/uaccess.h
index 75d9579..5f7db3fb 100644
--- a/arch/arm/include/asm/uaccess.h
+++ b/arch/arm/include/asm/uaccess.h
@@ -107,6 +107,7 @@ static inline void set_fs(mm_segment_t fs)
 extern int __get_user_1(void *);
 extern int __get_user_2(void *);
 extern int __get_user_4(void *);
+extern int __get_user_8(void *);
 
 #define __GUP_CLOBBER_1	"lr", "cc"
 #ifdef CONFIG_CPU_USE_DOMAINS
@@ -115,6 +116,7 @@ extern int __get_user_4(void *);
 #define __GUP_CLOBBER_2 "lr", "cc"
 #endif
 #define __GUP_CLOBBER_4	"lr", "cc"
+#define __GUP_CLOBBER_8	"lr", "cc"
 
 #define __get_user_x(__r2,__p,__e,__l,__s)				\
 	   __asm__ __volatile__ (					\
@@ -125,11 +127,19 @@ extern int __get_user_4(void *);
 		: "0" (__p), "r" (__l)					\
 		: __GUP_CLOBBER_##__s)
 
+/* narrowing a double-word get into a single 32bit word register: */
+#ifdef BIG_ENDIAN
+#define __get_user_xb(__r2, __p, __e, __l, __s)				\
+	__get_user_x(__r2, (uintptr_t)__p + 4, __e, __l, __s)
+#else
+#define __get_user_xb __get_user_x
+#endif
+
 #define __get_user_check(x,p)							\
 	({								\
 		unsigned long __limit = current_thread_info()->addr_limit - 1; \
 		register const typeof(*(p)) __user *__p asm("r0") = (p);\
-		register unsigned long __r2 asm("r2");			\
+		register typeof(x) __r2 asm("r2");			\
 		register unsigned long __l asm("r1") = __limit;		\
 		register int __e asm("r0");				\
 		switch (sizeof(*(__p))) {				\
@@ -142,6 +152,12 @@ extern int __get_user_4(void *);
 		case 4:							\
 			__get_user_x(__r2, __p, __e, __l, 4);		\
 			break;						\
+		case 8:							\
+			if (sizeof((x)) < 8)				\
+				__get_user_xb(__r2, __p, __e, __l, 4);	\
+			else						\
+				__get_user_x(__r2, __p, __e, __l, 8);	\
+			break;						\
 		default: __e = __get_user_bad(); break;			\
 		}							\
 		x = (typeof(*(p))) __r2;				\
diff --git a/arch/arm/lib/getuser.S b/arch/arm/lib/getuser.S
index 9b06bb4..ed98707 100644
--- a/arch/arm/lib/getuser.S
+++ b/arch/arm/lib/getuser.S
@@ -18,7 +18,7 @@
  * Inputs:	r0 contains the address
  *		r1 contains the address limit, which must be preserved
  * Outputs:	r0 is the error code
- *		r2 contains the zero-extended value
+ *		r2, r3 contains the zero-extended value
  *		lr corrupted
  *
  * No other registers must be altered.  (see <asm/uaccess.h>
@@ -66,6 +66,19 @@ ENTRY(__get_user_4)
 	mov	pc, lr
 ENDPROC(__get_user_4)
 
+ENTRY(__get_user_8)
+	check_uaccess r0, 8, r1, r2, __get_user_bad
+#ifdef CONFIG_THUMB2_KERNEL
+5: TUSER(ldr)	r2, [r0]
+6: TUSER(ldr)	r3, [r0, #4]
+#else
+5: TUSER(ldr)	r2, [r0], #4
+6: TUSER(ldr)	r3, [r0]
+#endif
+	mov	r0, #0
+	mov	pc, lr
+ENDPROC(__get_user_8)
+
 __get_user_bad:
 	mov	r2, #0
 	mov	r0, #-EFAULT
@@ -77,4 +90,6 @@ ENDPROC(__get_user_bad)
 	.long	2b, __get_user_bad
 	.long	3b, __get_user_bad
 	.long	4b, __get_user_bad
+	.long	5b, __get_user_bad
+	.long	6b, __get_user_bad
 .popsection
-- 
1.9.3

