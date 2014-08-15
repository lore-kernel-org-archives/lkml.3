Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbaHOJaw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 05:30:52 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:46479 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbaHOJau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 05:30:50 -0400
MIME-Version: 1.0
In-Reply-To: <20140814222119.GD18411@ld-irv-0074>
References: <20140814222119.GD18411@ld-irv-0074>
Date: Fri, 15 Aug 2014 02:30:49 -0700
X-Google-Sender-Auth: A2cBJ0oxrov8zOn9Hpevx9n1tFI
Message-ID: <CAL3LdT7-Ai7Dv93vrDP1o2BSVrmFAyTN=UAwE8n5+PVjpN1h0Q@mail.gmail.com>
Subject: Re: Overriding -Werror
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Brian Norris <computersforpeace@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>,
        Artem Bityutskiy <dedekind1@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2014 at 3:21 PM, Brian Norris
<computersforpeace@gmail.com> wrote:
> Hi all,
>
> I'm interested in being able to build-test kernels on various
> architectures while enabling extra warnings (make W=[123]). I'd like to
> be able to finish the builds and see all warnings, rather than seeing a
> failed build. However, GCC's -Werror is incompatible with this. There is
> plenty of code that will produce at least one warning, when warning
> verbosity is turned up. And GCC's -Werror is not guaranteed to remain
> stable over time; new versions may develop new warnings that may or may
> not be legitimate.
>
> It seems that there are a few problem ARCHes that enable -Werror by
> default: SuperH (orphaned), SPARC, and MIPS. There are also a few
> scattered Makefiles throughout the build tree. Developers have
> previously tried to remove some of the worst offenders [1], but were
> mostly rejected [2]. It doesn't seem like we can fully prevent
> maintainers from enabling -Werror on their code--or even on their entire
> ARCH build, as with MIPS--for better or worse, so I look to other
> alternatives.
>
> For the easiest approach, I considered how one might add -Wno-error to
> the CFLAGS. 'make KCFLAGS=-Wno-error' looked promising, but
> KBUILD_CFLAGS is applied before the sub-directory Makefiles add their
> own options to ccflags-y. So it seems like others have come to the same
> conclusion as me: that Kbuild doesn't seem to provide a way to override
> the -Werror behvaior from the top level. [3][4]
>
> So, how can we fix this? -Werror may be useful in some cases to
> encourage developers to fix up their code immediately, but it is
> decidedly unhelpful when running code through analysis tools.
>
> Possibilities include:
>
> 1. make -Werror be applied only when we do not have W=[123]. [5]
>
> 2. develop a top-level override for CFLAGS that is applied *after* all
>    sub-directory modifications
>
> 3. make -Werror opt-in / configurable, like PPC's CONFIG_PPC_WERROR
>    (maybe make it a generic CONFIG_WERROR?), and prevent its
>    unconditional use in Makefiles
>
> 4. better ideas?
>
> Regards,
> Brian
>
> [1] http://www.linux-mips.org/archives/linux-mips/2012-04/msg00179.html
>     http://patchwork.ozlabs.org/patch/146297/
>
> [2] http://www.linux-mips.org/archives/linux-mips/2012-05/msg00064.html
>
> [3] http://lists.linaro.org/pipermail/linaro-toolchain/2011-November/001869.html
>
> [4] http://lists.linaro.org/pipermail/linaro-dev/2011-December/008880.html
>
> [5] http://www.linux-mips.org/archives/linux-mips/2012-05/msg00070.html
> --

Funny that you bring this up because I have ~60 patches in my queue to
resolve several thousand of these warnings.  Half of the patches
actually resolve warnings that can be resolved and the other half
implement compiler diagnostic control macros to help silence warnings.
All these were the work of a co-worker Mark Rustad, below is the patch
he put together to implement the compiler diagnostic control macros.

commit 7b9aace02b2405f0714bc08c424b72e6962f1c2e
Author: Mark Rustad <mark.d.rustad@intel.com>
Date:   Fri Aug 15 01:43:44 2014 -0700

    compiler: Add diagnostic control macros

    Add macros to control diagnostic messages where needed. These
    are used to silence warning messages that are expected, normal
    and do not indicate any sort of problem. Reducing the stream
    of messages in this way helps possible problems to stand out.

    The macros provided are:
        DIAG_PUSH() - to save diagnostic settings
        DIAG_POP() - to restore diagnostic settings
        DIAG_IGNORE(option) - to ignore a particular warning
        DIAG_GCC_IGNORE(option) - DIAG_IGNORE for gcc only
        DIAG_CLANG_IGNORE(option) - DIAG_IGNORE for clang only

    Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>

diff --git a/include/linux/compiler-clang.h b/include/linux/compiler-clang.h
index d1e49d5..039b112 100644
--- a/include/linux/compiler-clang.h
+++ b/include/linux/compiler-clang.h
@@ -10,3 +10,29 @@
 #undef uninitialized_var
 #define uninitialized_var(x) x = *(&(x))
 #endif
+
+/*
+ * Provide macros to manipulate diagnostic messages when possible.
+ * DIAG_PUSH pushes the diagnostic settings
+ * DIAG_POP pops the diagnostic settings
+ * DIAG_IGNORE(x) changes the given diagnostic setting to ignore
+ *
+ * Example:
+ *    DIAG_PUSH DIAG_IGNORE(aggregate-return)
+ *    struct timespec ns_to_timespec(const s64 nsec)
+ *    {
+ *        ...
+ *    }
+ *    DIAG_POP
+ *
+ * Will prevent the warning on compilation of the function. Other
+ * steps are necessary to do the same thing for the call sites.
+ */
+#define DIAG_STR(x) #x
+#define DIAG_CAT(x, y) DIAG_STR(x##y)
+#define DIAG_DO_PRAGMA(x) _Pragma(#x)
+#define DIAG_PRAGMA(x) DIAG_DO_PRAGMA(clang diagnostic x)
+#define DIAG_IGNORE(x) DIAG_PRAGMA(ignored DIAG_CAT(-W, x))
+#define DIAG_PUSH DIAG_PRAGMA(push)
+#define DIAG_POP DIAG_PRAGMA(pop)
+#define DIAG_CLANG_IGNORE(x) DIAG_IGNORE(x)
diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
index 2507fd2..78387f6 100644
--- a/include/linux/compiler-gcc4.h
+++ b/include/linux/compiler-gcc4.h
@@ -86,3 +86,34 @@
 #define __HAVE_BUILTIN_BSWAP16__
 #endif
 #endif /* CONFIG_ARCH_USE_BUILTIN_BSWAP */
+
+/*
+ * Provide macros to manipulate diagnostic messages when possible.
+ * DIAG_PUSH pushes the diagnostic settings
+ * DIAG_POP pops the diagnostic settings
+ * DIAG_IGNORE(x) changes the given diagnostic setting to ignore
+ *
+ * Example:
+ *    DIAG_PUSH DIAG_IGNORE(aggregate-return)
+ *    struct timespec ns_to_timespec(const s64 nsec)
+ *    {
+ *        ...
+ *    }
+ *    DIAG_POP
+ *
+ * Will prevent the warning on compilation of the function. Other
+ * steps are necessary to do the same thing for the call sites.
+ */
+#if GCC_VERSION >= 40600
+#define DIAG_STR(x) #x
+#define DIAG_CAT(x, y) DIAG_STR(x##y)
+#define DIAG_DO_PRAGMA(x) _Pragma(#x)
+#define DIAG_PRAGMA(x) DIAG_DO_PRAGMA(GCC diagnostic x)
+#define DIAG_IGNORE(x) DIAG_PRAGMA(ignored DIAG_CAT(-W, x))
+/* GCC 4.8 - 4.8.2 has issues with pop, so do not define push or pop */
+#if GCC_VERSION < 40800 || GCC_VERSION >= 40803
+#define DIAG_PUSH DIAG_PRAGMA(push)
+#define DIAG_POP DIAG_PRAGMA(pop)
+#endif /* GCC_VERSION < 40800 || GCC_VERSION >= 40803 */
+#define DIAG_GCC_IGNORE(x) DIAG_IGNORE(x)
+#endif /* GCC_VERSION >= 40600 */
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index d5ad7b1..fde7b21 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -94,6 +94,26 @@ struct ftrace_branch_data {
 };

 /*
+ * Provide null definitions for diagnostic manipulation macros not provided
+ * for a particular compiler.
+ */
+#ifndef DIAG_PUSH
+#define DIAG_PUSH
+#endif
+#ifndef DIAG_POP
+#define DIAG_POP
+#endif
+#ifndef DIAG_IGNORE
+#define DIAG_IGNORE(x)
+#endif
+#ifndef DIAG_CLANG_IGNORE
+#define DIAG_CLANG_IGNORE(x)
+#endif
+#ifndef DIAG_GCC_IGNORE
+#define DIAG_GCC_IGNORE(x)
+#endif
+
+/*
  * Note: DISABLE_BRANCH_PROFILING can be used by special lowlevel code
  * to disable branch tracing on a per file basis.
  */

-- 
Cheers,
Jeff
