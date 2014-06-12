Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129AbaFLP6y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 11:58:54 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:56072 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753090AbaFLP6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 11:58:52 -0400
Date: Thu, 12 Jun 2014 16:58:44 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Rob Clark <robdclark@gmail.com>, Nicolas Pitre <nicolas.pitre@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH v3] ARM: add get_user() support for 8 byte types
Message-ID: <20140612155843.GK23430@n2100.arm.linux.org.uk>
References: <1402587755-29245-1-git-send-email-daniel.thompson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402587755-29245-1-git-send-email-daniel.thompson@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 04:42:35PM +0100, Daniel Thompson wrote:
> A new atomic modeset/pageflip ioctl being developed in DRM requires
> get_user() to work for 64bit types (in addition to just put_user()).
> 
> v1: original
> v2: pass correct size to check_uaccess, and better handling of narrowing
>     double word read with __get_user_xb() (Russell King's suggestion)
> v3: fix a couple of checkpatch issues

This is still unsafe.

>  #define __get_user_check(x,p)							\
>  	({								\
>  		unsigned long __limit = current_thread_info()->addr_limit - 1; \
>  		register const typeof(*(p)) __user *__p asm("r0") = (p);\
> -		register unsigned long __r2 asm("r2");			\
> +		register typeof(x) __r2 asm("r2");			\

So, __r2 becomes the type of 'x'.  If 'x' is a 64-bit type, and *p is
an 8-bit, 16-bit, or 32-bit type, this fails horribly by leaving the
upper word of __r2 undefined.

__r2 must follow the size of the value we are reading.  I think the
last solution which was proposed was this:

 arch/arm/include/asm/uaccess.h |   17 +++++++++++++----
 arch/arm/lib/getuser.S         |   33 ++++++++++++++++++++++++++++++++-
 2 files changed, 45 insertions(+), 5 deletions(-)

diff --git a/arch/arm/include/asm/uaccess.h b/arch/arm/include/asm/uaccess.h
index 72abdc5..747f2cb 100644
--- a/arch/arm/include/asm/uaccess.h
+++ b/arch/arm/include/asm/uaccess.h
@@ -93,6 +93,9 @@ static inline void set_fs(mm_segment_t fs)
 		: "cc"); \
 	flag; })
 
+#define __inttype(x) \
+	__typeof__(__builtin_choose_expr(sizeof(x) > sizeof(0UL), 0ULL, 0UL))
+
 /*
  * Single-value transfer routines.  They automatically use the right
  * size if we just have the right pointer type.  Note that the functions
@@ -107,14 +110,16 @@ static inline void set_fs(mm_segment_t fs)
 extern int __get_user_1(void *);
 extern int __get_user_2(void *);
 extern int __get_user_4(void *);
+extern int __get_user_8(void *);
 
-#define __GUP_CLOBBER_1	"lr", "cc"
+#define __GUP_CLOBBER_1 "lr", "cc"
 #ifdef CONFIG_CPU_USE_DOMAINS
-#define __GUP_CLOBBER_2	"ip", "lr", "cc"
+#define __GUP_CLOBBER_2 "ip", "lr", "cc"
 #else
 #define __GUP_CLOBBER_2 "lr", "cc"
 #endif
-#define __GUP_CLOBBER_4	"lr", "cc"
+#define __GUP_CLOBBER_4 "lr", "cc"
+#define __GUP_CLOBBER_8 "lr", "cc"
 
 #define __get_user_x(__r2,__p,__e,__l,__s)				\
 	   __asm__ __volatile__ (					\
@@ -129,7 +134,7 @@ extern int __get_user_4(void *);
 	({								\
 		unsigned long __limit = current_thread_info()->addr_limit - 1; \
 		register const typeof(*(p)) __user *__p asm("r0") = (p);\
-		register unsigned long __r2 asm("r2");			\
+		register __inttype(*p) __r2 asm("r2");			\
 		register unsigned long __l asm("r1") = __limit;		\
 		register int __e asm("r0");				\
 		switch (sizeof(*(__p))) {				\
@@ -142,6 +147,9 @@ extern int __get_user_4(void *);
 		case 4:							\
 			__get_user_x(__r2, __p, __e, __l, 4);		\
 			break;						\
+		case 8:							\
+			__get_user_x(__r2, __p, __e, __l, 8);		\
+			break;						\
 		default: __e = __get_user_bad(); break;			\
 		}							\
 		x = (typeof(*(p))) __r2;				\
@@ -150,6 +158,7 @@ extern int __get_user_4(void *);
 
 #define get_user(x,p)							\
 	({								\
+		__chk_user_ptr(ptr);					\
 		might_fault();						\
 		__get_user_check(x,p);					\
 	 })
diff --git a/arch/arm/lib/getuser.S b/arch/arm/lib/getuser.S
index 9b06bb4..3583c83 100644
--- a/arch/arm/lib/getuser.S
+++ b/arch/arm/lib/getuser.S
@@ -18,7 +18,7 @@
  * Inputs:	r0 contains the address
  *		r1 contains the address limit, which must be preserved
  * Outputs:	r0 is the error code
- *		r2 contains the zero-extended value
+ *		r2/r3 contains the zero-extended value
  *		lr corrupted
  *
  * No other registers must be altered.  (see <asm/uaccess.h>
@@ -32,6 +32,14 @@
 #include <asm/errno.h>
 #include <asm/domain.h>
 
+#ifdef __ARMEB__
+#define rlo8	r3
+#define rhi8	r2
+#else
+#define	rlo8	r2
+#define rhi8	r3
+#endif
+
 ENTRY(__get_user_1)
 	check_uaccess r0, 1, r1, r2, __get_user_bad
 1: TUSER(ldrb)	r2, [r0]
@@ -66,15 +74,38 @@ ENTRY(__get_user_4)
 	mov	pc, lr
 ENDPROC(__get_user_4)
 
+ENTRY(__get_user_8)
+	check_uaccess r0, 4, r1, r2, __get_user_bad8
+#ifdef CONFIG_CPU_USE_DOMAINS
+#define	GU8_FIXUPS	5b, 6b
+5:	ldrt	rlo8, [r0], #4
+6:	ldrt	rhi8, [r0], #0
+#elif __LINUX_ARM_ARCH__ >= 6
+#define	GU8_FIXUPS	5b
+5:	ldrd	r2, [r0]
+#else
+#define	GU8_FIXUPS	5b, 6b
+5:	ldr	rlo8, [r0, #0]
+6:	ldr	rhi8, [r0, #4]
+#endif
+	mov	r0, #0
+	mov	pc, lr
+
+__get_user_bad8:
+	mov	r3, #0
 __get_user_bad:
 	mov	r2, #0
 	mov	r0, #-EFAULT
 	mov	pc, lr
 ENDPROC(__get_user_bad)
+ENDPROC(__get_user_bad8)
 
 .pushsection __ex_table, "a"
 	.long	1b, __get_user_bad
 	.long	2b, __get_user_bad
 	.long	3b, __get_user_bad
 	.long	4b, __get_user_bad
+	.irp	param, GU8_FIXUPS
+	.long	\param, __get_user_bad8
+	.endr
 .popsection


-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
