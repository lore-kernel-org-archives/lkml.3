Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282AbaISPaw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 11:30:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:60855 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756626AbaISPat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 11:30:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,555,1406617200"; 
   d="scan'208";a="605437157"
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: sparse@chrisli.org
Cc: Mark Rustad <mark.d.rustad@intel.com>, linux-sparse@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Brian Norris <computersforpeace@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH 1/7] compiler: Add diagnostic control macros
Date: Fri, 19 Sep 2014 08:29:34 -0700
Message-Id: <1411140580-20909-2-git-send-email-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411140580-20909-1-git-send-email-jeffrey.t.kirsher@intel.com>
References: <1411140580-20909-1-git-send-email-jeffrey.t.kirsher@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Rustad <mark.d.rustad@intel.com>

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

CC: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 include/linux/compiler-clang.h | 26 ++++++++++++++++++++++++++
 include/linux/compiler-gcc4.h  | 31 +++++++++++++++++++++++++++++++
 include/linux/compiler.h       | 20 ++++++++++++++++++++
 3 files changed, 77 insertions(+)

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
+ *	DIAG_PUSH DIAG_IGNORE(aggregate-return)
+ *	struct timespec ns_to_timespec(const s64 nsec)
+ *	{
+ *		...
+ *	}
+ *	DIAG_POP
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
+ *	DIAG_PUSH DIAG_IGNORE(aggregate-return)
+ *	struct timespec ns_to_timespec(const s64 nsec)
+ *	{
+ *		...
+ *	}
+ *	DIAG_POP
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
1.9.3

