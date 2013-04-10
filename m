Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936616Ab3DJM0P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 08:26:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49736 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935434Ab3DJM0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 08:26:14 -0400
Date: Wed, 10 Apr 2013 14:26:11 +0200
From: Michal Marek <mmarek@suse.cz>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k <linux-m68k@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH/RFC] m68k: Add -ffreestanding to KBUILD_CFLAGS
Message-ID: <20130410122611.GB17541@sepie.suse.cz>
References: <1365585879-5321-1-git-send-email-geert@linux-m68k.org>
 <51653C5D.4060408@suse.cz>
 <CAMuHMdXEvLMz5rRjQrhENxJ6UHRnPCtzyNg=hqitspuY88G7sA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdXEvLMz5rRjQrhENxJ6UHRnPCtzyNg=hqitspuY88G7sA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 12:59:44PM +0200, Geert Uytterhoeven wrote:
> On Wed, Apr 10, 2013 at 12:18 PM, Michal Marek <mmarek@suse.cz> wrote:
> > On 10.4.2013 11:24, Geert Uytterhoeven wrote:
> > My understanding is, that with -fnobuiltin, the compiler is not allowed
> > to make assumptions about functions if it does not see their definition,
> > even if they resemble standard functions. E.g. on x86_64, strlen() is
> > out-of-line, so gcc would have to assume, that strcmp() has side
> > effects. How about just naming the m68k inline function 'strlen'?
> 
> Having an inline function named "strlen" is not sufficient, as it needs an
> (exported) symbol named "strlen" at link time or module load time.

Really? MIPS and Xtensa both have an inline version of strcpy() and no
exported strcpy symbol. An I would naively assume, that if the compiler
sees a static inline definition of a function, then it will not generate
a function call. Although, the C standard does require the standard
library functions be available as external functions, so the compiler
would not be necessarily wrong :-/. Anyway, can you try if this
(untested) patch fixes the issue?

Thanks,
Michal

>From ac9861ba0bf4257f14d7f7db4b9eb60311986049 Mon Sep 17 00:00:00 2001
From: Michal Marek <mmarek@suse.cz>
Date: Wed, 10 Apr 2013 13:58:55 +0200
Subject: [PATCH] m68k: Do not define string functions as macros

Implement the functions under their real names, so that the compiler can
emit calls to them.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 arch/m68k/include/asm/string.h |   22 ++++++++--------------
 arch/m68k/lib/Makefile         |    2 +-
 arch/m68k/lib/string.c         |   22 ----------------------
 3 files changed, 9 insertions(+), 37 deletions(-)
 delete mode 100644 arch/m68k/lib/string.c

diff --git a/arch/m68k/include/asm/string.h b/arch/m68k/include/asm/string.h
index 3219845..dcd80ae 100644
--- a/arch/m68k/include/asm/string.h
+++ b/arch/m68k/include/asm/string.h
@@ -4,7 +4,7 @@
 #include <linux/types.h>
 #include <linux/compiler.h>
 
-static inline size_t __kernel_strlen(const char *s)
+static inline size_t strlen(const char *s)
 {
 	const char *sc;
 
@@ -13,7 +13,7 @@ static inline size_t __kernel_strlen(const char *s)
 	return sc - s - 1;
 }
 
-static inline char *__kernel_strcpy(char *dest, const char *src)
+static inline char *strcpy(char *dest, const char *src)
 {
 	char *xdest = dest;
 
@@ -25,12 +25,10 @@ static inline char *__kernel_strcpy(char *dest, const char *src)
 	return xdest;
 }
 
-#ifndef __IN_STRING_C
-
 #define __HAVE_ARCH_STRLEN
 #define strlen(s)	(__builtin_constant_p(s) ?	\
 			 __builtin_strlen(s) :		\
-			 __kernel_strlen(s))
+			 strlen(s))
 
 #define __HAVE_ARCH_STRNLEN
 static inline size_t strnlen(const char *s, size_t count)
@@ -53,9 +51,7 @@ static inline size_t strnlen(const char *s, size_t count)
 #define strcpy(d, s)	(__builtin_constant_p(s) &&	\
 			 __builtin_strlen(s) <= 32 ?	\
 			 __builtin_strcpy(d, s) :	\
-			 __kernel_strcpy(d, s))
-#else
-#define strcpy(d, s)	__kernel_strcpy(d, s)
+			 strcpy(d, s))
 #endif
 
 #define __HAVE_ARCH_STRNCPY
@@ -76,10 +72,10 @@ static inline char *strncpy(char *dest, const char *src, size_t n)
 }
 
 #define __HAVE_ARCH_STRCAT
-#define strcat(d, s)	({			\
-	char *__d = (d);			\
-	strcpy(__d + strlen(__d), (s));		\
-})
+static inline char * strcat(char *dest, const char *src)
+{
+	return strcpy(dest + strlen(dest), src);
+}
 
 #ifndef CONFIG_COLDFIRE
 #define __HAVE_ARCH_STRCMP
@@ -114,6 +110,4 @@ extern void *memset(void *, int, __kernel_size_t);
 extern void *memcpy(void *, const void *, __kernel_size_t);
 #define memcpy(d, s, n) __builtin_memcpy(d, s, n)
 
-#endif
-
 #endif /* _M68K_STRING_H_ */
diff --git a/arch/m68k/lib/Makefile b/arch/m68k/lib/Makefile
index a9d782d..fcd8eb1 100644
--- a/arch/m68k/lib/Makefile
+++ b/arch/m68k/lib/Makefile
@@ -6,7 +6,7 @@
 lib-y	:= ashldi3.o ashrdi3.o lshrdi3.o muldi3.o \
 	   memcpy.o memset.o memmove.o
 
-lib-$(CONFIG_MMU) += string.o uaccess.o
+lib-$(CONFIG_MMU) += uaccess.o
 lib-$(CONFIG_CPU_HAS_NO_MULDIV64) += mulsi3.o divsi3.o udivsi3.o
 lib-$(CONFIG_CPU_HAS_NO_MULDIV64) += modsi3.o umodsi3.o
 
diff --git a/arch/m68k/lib/string.c b/arch/m68k/lib/string.c
deleted file mode 100644
index b9a57ab..0000000
--- a/arch/m68k/lib/string.c
+++ /dev/null
@@ -1,22 +0,0 @@
-/*
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file COPYING in the main directory of this archive
- * for more details.
- */
-
-#define __IN_STRING_C
-
-#include <linux/module.h>
-#include <linux/string.h>
-
-char *strcpy(char *dest, const char *src)
-{
-	return __kernel_strcpy(dest, src);
-}
-EXPORT_SYMBOL(strcpy);
-
-char *strcat(char *dest, const char *src)
-{
-	return __kernel_strcpy(dest + __kernel_strlen(dest), src);
-}
-EXPORT_SYMBOL(strcat);
-- 
1.7.10.4

