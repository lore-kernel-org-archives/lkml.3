Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbaIDXrk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 19:47:40 -0400
Received: from smtprelay0155.hostedemail.com ([216.40.44.155]:34756 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754375AbaIDXrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 19:47:39 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:1:2:41:69:355:379:541:599:960:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1593:1594:1605:1730:1747:1777:1792:2393:2525:2561:2564:2682:2685:2693:2828:2840:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3870:3871:3872:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4052:4321:5007:6119:6120:6238:7652:7875:7901:7903:8531:8599:8660:9025:9140:9388:9592:10004:10026:10848:11026:11232:11473:11657:11658:11914:12043:12291:12295:12296:12438:12517:12519:12555:12660:12679:12683:12698:12737:12740:13019:13025:13148:13230:14094:14096:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,Doma
X-HE-Tag: unit21_426e94b12571c
X-Filterd-Recvd-Size: 10444
Message-ID: <1409874455.2770.26.camel@joe-AO725>
Subject: Re: [PATCH] kernel: add support for gcc 5
From: Joe Perches <joe@perches.com>
To: Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>, Sasha Levin <sasha.levin@oracle.com>,
        akpm@linuxfoundation.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 04 Sep 2014 16:47:35 -0700
In-Reply-To: <1409870628.2310799.163815377.623F33D2@webmail.messagingengine.com>
References: <1409845039-5751-1-git-send-email-sasha.levin@oracle.com>
	 <20140904212535.GA5059@drone.musicnaut.iki.fi>
	 <1409870628.2310799.163815377.623F33D2@webmail.messagingengine.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-09-05 at 00:43 +0200, Hannes Frederic Sowa wrote:
> Most statements are already depending on GCC_VERSION, maybe we can just
> unify all gcc specific headers to one, still trying to keep the file
> organized? ;)

Maybe something like:

gnu development of gcc will be more frequent and the use of
compiler-gcc<major>.h likely will not be convenient anymore.

Integrate the individual compiler-gcc<major>.h files into
compiler-gcc.h.
---
 include/linux/compiler-gcc.h  | 113 ++++++++++++++++++++++++++++++++++++++++--
 include/linux/compiler-gcc3.h |  23 ---------
 include/linux/compiler-gcc4.h |  88 --------------------------------
 3 files changed, 109 insertions(+), 115 deletions(-)
 delete mode 100644 include/linux/compiler-gcc3.h
 delete mode 100644 include/linux/compiler-gcc4.h

diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index 02ae99e..ec73109 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -100,10 +100,115 @@
 #define __maybe_unused			__attribute__((unused))
 #define __always_unused			__attribute__((unused))
 
-#define __gcc_header(x) #x
-#define _gcc_header(x) __gcc_header(linux/compiler-gcc##x.h)
-#define gcc_header(x) _gcc_header(x)
-#include gcc_header(__GNUC__)
+/* gcc version specific checks */
+
+#if GCC_VERSION < 30200
+# error Sorry, your compiler is too old - please upgrade it.
+#endif
+
+#if GCC_VERSION < 30300
+# define __used			__attribute__((__unused__))
+#else
+# define __used			__attribute__((__used__))
+#endif
+
+#ifdef CONFIG_GCOV_KERNEL
+# if GCC_VERSION < 30400
+#   error "GCOV profiling support for gcc versions below 3.4 not included"
+# endif /* __GNUC_MINOR__ */
+#endif /* CONFIG_GCOV_KERNEL */
+
+#if GCC_VERSION >= 30400
+#define __must_check		__attribute__((warn_unused_result))
+#endif
+
+#if GCC_VERSION >= 40000
+
+/* GCC 4.1.[01] miscompiles __weak */
+#ifdef __KERNEL__
+# if GCC_VERSION >= 40100 &&  GCC_VERSION <= 40101
+#  error Your version of gcc miscompiles the __weak directive
+# endif
+#endif
+
+#define __used			__attribute__((__used__))
+#define __compiler_offsetof(a,b) __builtin_offsetof(a,b)
+
+#if GCC_VERSION >= 40100 && GCC_VERSION < 40600
+# define __compiletime_object_size(obj) __builtin_object_size(obj, 0)
+#endif
+
+#if GCC_VERSION >= 40300
+/* Mark functions as cold. gcc will assume any path leading to a call
+   to them will be unlikely.  This means a lot of manual unlikely()s
+   are unnecessary now for any paths leading to the usual suspects
+   like BUG(), printk(), panic() etc. [but let's keep them for now for
+   older compilers]
+
+   Early snapshots of gcc 4.3 don't support this and we can't detect this
+   in the preprocessor, but we can live with this because they're unreleased.
+   Maketime probing would be overkill here.
+
+   gcc also has a __attribute__((__hot__)) to move hot functions into
+   a special section, but I don't see any sense in this right now in
+   the kernel context */
+#define __cold			__attribute__((__cold__))
+
+#define __UNIQUE_ID(prefix) __PASTE(__PASTE(__UNIQUE_ID_, prefix), __COUNTER__)
+
+#ifndef __CHECKER__
+# define __compiletime_warning(message) __attribute__((warning(message)))
+# define __compiletime_error(message) __attribute__((error(message)))
+#endif /* __CHECKER__ */
+#endif /* GCC_VERSION >= 40300 */
+
+#if GCC_VERSION >= 40500
+/*
+ * Mark a position in code as unreachable.  This can be used to
+ * suppress control flow warnings after asm blocks that transfer
+ * control elsewhere.
+ *
+ * Early snapshots of gcc 4.5 don't support this and we can't detect
+ * this in the preprocessor, but we can live with this because they're
+ * unreleased.  Really, we need to have autoconf for the kernel.
+ */
+#define unreachable() __builtin_unreachable()
+
+/* Mark a function definition as prohibited from being cloned. */
+#define __noclone	__attribute__((__noclone__))
+
+#endif /* GCC_VERSION >= 40500 */
+
+#if GCC_VERSION >= 40600
+/*
+ * Tell the optimizer that something else uses this function or variable.
+ */
+#define __visible __attribute__((externally_visible))
+#endif
+
+/*
+ * GCC 'asm goto' miscompiles certain code sequences:
+ *
+ *   http://gcc.gnu.org/bugzilla/show_bug.cgi?id=58670
+ *
+ * Work it around via a compiler barrier quirk suggested by Jakub Jelinek.
+ * Fixed in GCC 4.8.2 and later versions.
+ *
+ * (asm goto is automatically volatile - the naming reflects this.)
+ */
+#define asm_volatile_goto(x...)	do { asm goto(x); asm (""); } while (0)
+
+#ifdef CONFIG_ARCH_USE_BUILTIN_BSWAP
+#if GCC_VERSION >= 40400
+#define __HAVE_BUILTIN_BSWAP32__
+#define __HAVE_BUILTIN_BSWAP64__
+#endif
+#if GCC_VERSION >= 40800 || (defined(__powerpc__) && GCC_VERSION >= 40600)
+#define __HAVE_BUILTIN_BSWAP16__
+#endif
+#endif /* CONFIG_ARCH_USE_BUILTIN_BSWAP */
+
+#endif	/* gcc version specific checks */
 
 #if !defined(__noclone)
 #define __noclone	/* not needed */
diff --git a/include/linux/compiler-gcc3.h b/include/linux/compiler-gcc3.h
deleted file mode 100644
index 7d89feb..0000000
--- a/include/linux/compiler-gcc3.h
+++ /dev/null
@@ -1,23 +0,0 @@
-#ifndef __LINUX_COMPILER_H
-#error "Please don't include <linux/compiler-gcc3.h> directly, include <linux/compiler.h> instead."
-#endif
-
-#if GCC_VERSION < 30200
-# error Sorry, your compiler is too old - please upgrade it.
-#endif
-
-#if GCC_VERSION >= 30300
-# define __used			__attribute__((__used__))
-#else
-# define __used			__attribute__((__unused__))
-#endif
-
-#if GCC_VERSION >= 30400
-#define __must_check		__attribute__((warn_unused_result))
-#endif
-
-#ifdef CONFIG_GCOV_KERNEL
-# if GCC_VERSION < 30400
-#   error "GCOV profiling support for gcc versions below 3.4 not included"
-# endif /* __GNUC_MINOR__ */
-#endif /* CONFIG_GCOV_KERNEL */
diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
deleted file mode 100644
index 2507fd2..0000000
--- a/include/linux/compiler-gcc4.h
+++ /dev/null
@@ -1,88 +0,0 @@
-#ifndef __LINUX_COMPILER_H
-#error "Please don't include <linux/compiler-gcc4.h> directly, include <linux/compiler.h> instead."
-#endif
-
-/* GCC 4.1.[01] miscompiles __weak */
-#ifdef __KERNEL__
-# if GCC_VERSION >= 40100 &&  GCC_VERSION <= 40101
-#  error Your version of gcc miscompiles the __weak directive
-# endif
-#endif
-
-#define __used			__attribute__((__used__))
-#define __must_check 		__attribute__((warn_unused_result))
-#define __compiler_offsetof(a,b) __builtin_offsetof(a,b)
-
-#if GCC_VERSION >= 40100 && GCC_VERSION < 40600
-# define __compiletime_object_size(obj) __builtin_object_size(obj, 0)
-#endif
-
-#if GCC_VERSION >= 40300
-/* Mark functions as cold. gcc will assume any path leading to a call
-   to them will be unlikely.  This means a lot of manual unlikely()s
-   are unnecessary now for any paths leading to the usual suspects
-   like BUG(), printk(), panic() etc. [but let's keep them for now for
-   older compilers]
-
-   Early snapshots of gcc 4.3 don't support this and we can't detect this
-   in the preprocessor, but we can live with this because they're unreleased.
-   Maketime probing would be overkill here.
-
-   gcc also has a __attribute__((__hot__)) to move hot functions into
-   a special section, but I don't see any sense in this right now in
-   the kernel context */
-#define __cold			__attribute__((__cold__))
-
-#define __UNIQUE_ID(prefix) __PASTE(__PASTE(__UNIQUE_ID_, prefix), __COUNTER__)
-
-#ifndef __CHECKER__
-# define __compiletime_warning(message) __attribute__((warning(message)))
-# define __compiletime_error(message) __attribute__((error(message)))
-#endif /* __CHECKER__ */
-#endif /* GCC_VERSION >= 40300 */
-
-#if GCC_VERSION >= 40500
-/*
- * Mark a position in code as unreachable.  This can be used to
- * suppress control flow warnings after asm blocks that transfer
- * control elsewhere.
- *
- * Early snapshots of gcc 4.5 don't support this and we can't detect
- * this in the preprocessor, but we can live with this because they're
- * unreleased.  Really, we need to have autoconf for the kernel.
- */
-#define unreachable() __builtin_unreachable()
-
-/* Mark a function definition as prohibited from being cloned. */
-#define __noclone	__attribute__((__noclone__))
-
-#endif /* GCC_VERSION >= 40500 */
-
-#if GCC_VERSION >= 40600
-/*
- * Tell the optimizer that something else uses this function or variable.
- */
-#define __visible __attribute__((externally_visible))
-#endif
-
-/*
- * GCC 'asm goto' miscompiles certain code sequences:
- *
- *   http://gcc.gnu.org/bugzilla/show_bug.cgi?id=58670
- *
- * Work it around via a compiler barrier quirk suggested by Jakub Jelinek.
- * Fixed in GCC 4.8.2 and later versions.
- *
- * (asm goto is automatically volatile - the naming reflects this.)
- */
-#define asm_volatile_goto(x...)	do { asm goto(x); asm (""); } while (0)
-
-#ifdef CONFIG_ARCH_USE_BUILTIN_BSWAP
-#if GCC_VERSION >= 40400
-#define __HAVE_BUILTIN_BSWAP32__
-#define __HAVE_BUILTIN_BSWAP64__
-#endif
-#if GCC_VERSION >= 40800 || (defined(__powerpc__) && GCC_VERSION >= 40600)
-#define __HAVE_BUILTIN_BSWAP16__
-#endif
-#endif /* CONFIG_ARCH_USE_BUILTIN_BSWAP */
-- 
1.8.1.2.459.gbcd45b4.dirty



