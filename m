Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936860Ab3DJPWe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 11:22:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57560 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936127Ab3DJPWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 11:22:32 -0400
Date: Wed, 10 Apr 2013 17:22:29 +0200
From: Michal Marek <mmarek@suse.cz>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k <linux-m68k@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH/RFC] m68k: Add -ffreestanding to KBUILD_CFLAGS
Message-ID: <20130410152229.GC17541@sepie.suse.cz>
References: <1365585879-5321-1-git-send-email-geert@linux-m68k.org>
 <51653C5D.4060408@suse.cz>
 <CAMuHMdXEvLMz5rRjQrhENxJ6UHRnPCtzyNg=hqitspuY88G7sA@mail.gmail.com>
 <20130410122611.GB17541@sepie.suse.cz>
 <CAMuHMdUHiiBEZm7eFYtL3PqCXF6PjscbFKjiJ33BEwQ+YLKOXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdUHiiBEZm7eFYtL3PqCXF6PjscbFKjiJ33BEwQ+YLKOXQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 04:19:14PM +0200, Geert Uytterhoeven wrote:
> Thanks for the patch, but modpost still fails with
> 
> ERROR: "strlen" [net/ipv4/ip_tunnel.ko] undefined!

OK OK, I am convinced. Then how about this? If you prefer speed over
size, the the other option is to add

size_t strlen(const char *s)
{
       return __kernel_strlen(s);
}
EXPORT_SYMBOL(strlen);

to arch/m68k/lib/string.c. On a related note, arch/m68k/lib/string.c is
built only in the CONFIG_MMU case, whereas asm/string.h is shared.

Michal


>From 1b89666d246bcc2bfc4c9e1bdfd1dbd1dafe2e2f Mon Sep 17 00:00:00 2001
From: Michal Marek <mmarek@suse.cz>
Date: Wed, 10 Apr 2013 16:45:21 +0200
Subject: [PATCH] m68k: Remove inline strlen() implementation

GCC can replace a strncat() call with constant second argument into a
strlen + store, which results in a link error:

ERROR: "strlen" [net/ipv4/ip_tunnel.ko] undefined!

The inline function is a simple for loop in C. Other architectures
either use an asm optimized variant, or use the generic function from
lib/string.c.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 arch/m68k/include/asm/string.h |   14 --------------
 arch/m68k/lib/string.c         |    2 +-
 2 files changed, 1 insertion(+), 15 deletions(-)

diff --git a/arch/m68k/include/asm/string.h b/arch/m68k/include/asm/string.h
index 3219845..9aea9f1 100644
--- a/arch/m68k/include/asm/string.h
+++ b/arch/m68k/include/asm/string.h
@@ -4,15 +4,6 @@
 #include <linux/types.h>
 #include <linux/compiler.h>
 
-static inline size_t __kernel_strlen(const char *s)
-{
-	const char *sc;
-
-	for (sc = s; *sc++; )
-		;
-	return sc - s - 1;
-}
-
 static inline char *__kernel_strcpy(char *dest, const char *src)
 {
 	char *xdest = dest;
@@ -27,11 +18,6 @@ static inline char *__kernel_strcpy(char *dest, const char *src)
 
 #ifndef __IN_STRING_C
 
-#define __HAVE_ARCH_STRLEN
-#define strlen(s)	(__builtin_constant_p(s) ?	\
-			 __builtin_strlen(s) :		\
-			 __kernel_strlen(s))
-
 #define __HAVE_ARCH_STRNLEN
 static inline size_t strnlen(const char *s, size_t count)
 {
diff --git a/arch/m68k/lib/string.c b/arch/m68k/lib/string.c
index b9a57ab..4d61fa8 100644
--- a/arch/m68k/lib/string.c
+++ b/arch/m68k/lib/string.c
@@ -17,6 +17,6 @@ EXPORT_SYMBOL(strcpy);
 
 char *strcat(char *dest, const char *src)
 {
-	return __kernel_strcpy(dest + __kernel_strlen(dest), src);
+	return __kernel_strcpy(dest + strlen(dest), src);
 }
 EXPORT_SYMBOL(strcat);
-- 
1.7.10.4

