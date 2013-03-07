Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932713Ab3CGLp6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 06:45:58 -0500
Received: from multi.imgtec.com ([194.200.65.239]:27822 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756704Ab3CGLp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 06:45:56 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Al Viro <viro@zeniv.linux.org.uk>
CC: Michal Marek <mmarek@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, Jean Delvare <khali@linux-fr.org>,
        Rusty Russell <rusty@rustcorp.com.au>, <linux-kbuild@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Mike Frysinger <vapier@gentoo.org>,
        <uclinux-dist-devel@blackfin.uclinux.org>,
        <linux-next@vger.kernel.org>, James Hogan <james.hogan@imgtec.com>
Subject: [RFC -next] linux/linkage.h: fix symbol prefix handling
Date: Thu, 7 Mar 2013 11:44:02 +0000
Message-ID: <1362656642-2693-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_03_07_11_45_47
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit "consolidate cond_syscall and SYSCALL_ALIAS declarations"
broke the build on blackfin and metag due to the following code:

  #ifndef SYMBOL_NAME
  #ifdef CONFIG_SYMBOL_PREFIX
  #define SYMBOL_NAME(x) CONFIG_SYMBOL_PREFIX ## x
  #else
  #define SYMBOL_NAME(x) x
  #endif
  #endif
  #define __SYMBOL_NAME(x) __stringify(SYMBOL_NAME(x))

__stringify literally stringifies CONFIG_SYMBOL_PREFIX ##x, so you get
lines like this in the assembly output:

  .weak CONFIG_SYMBOL_PREFIXsys_quotactl
  .set
  CONFIG_SYMBOL_PREFIXsys_quotactl,CONFIG_SYMBOL_PREFIXsys_ni_syscall

This is fixed by defining SYMBOL_PREFIX from the command line for c
files in addition to assembly for architectures that set
CONFIG_SYMBOL_PREFIX (scripts/Makefile.lib), and defining __SYMBOL_NAME
as:

  #define __SYMBOL_NAME(x) __stringify(SYMBOL_PREFIX) #x

We first have to ensure SYMBOL_PREFIX is defined (which avoids polluting
the command lines for architectures that don't use symbol prefixes).
Also the definition of SYMBOL_PREFIX in <linux/kernel.h> is removed as
it conflicts, isn't used anywhere, and is defined as a string so differs
from the assembly definition.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
This is just one possible way of fixing it. It felt the cleanest out of
the ways I tried, but feel free to suggest something better!

 include/linux/kernel.h  |  7 -------
 include/linux/linkage.h | 12 +++++-------
 scripts/Makefile.lib    |  1 +
 3 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 80d3687..e13e992 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -723,13 +723,6 @@ static inline void ftrace_dump(enum ftrace_dump_mode oops_dump_mode) { }
 /* Trap pasters of __FUNCTION__ at compile-time */
 #define __FUNCTION__ (__func__)
 
-/* This helps us to avoid #ifdef CONFIG_SYMBOL_PREFIX */
-#ifdef CONFIG_SYMBOL_PREFIX
-#define SYMBOL_PREFIX CONFIG_SYMBOL_PREFIX
-#else
-#define SYMBOL_PREFIX ""
-#endif
-
 /* Rebuild everything on CONFIG_FTRACE_MCOUNT_RECORD */
 #ifdef CONFIG_FTRACE_MCOUNT_RECORD
 # define REBUILD_DUE_TO_FTRACE_MCOUNT_RECORD
diff --git a/include/linux/linkage.h b/include/linux/linkage.h
index 829d66c..acb869b 100644
--- a/include/linux/linkage.h
+++ b/include/linux/linkage.h
@@ -15,14 +15,12 @@
 #define asmlinkage CPP_ASMLINKAGE
 #endif
 
-#ifndef SYMBOL_NAME
-#ifdef CONFIG_SYMBOL_PREFIX
-#define SYMBOL_NAME(x) CONFIG_SYMBOL_PREFIX ## x
-#else
-#define SYMBOL_NAME(x) x
-#endif
+/* This helps us to avoid #ifdef SYMBOL_PREFIX */
+#ifndef SYMBOL_PREFIX
+#define SYMBOL_PREFIX
 #endif
-#define __SYMBOL_NAME(x) __stringify(SYMBOL_NAME(x))
+
+#define __SYMBOL_NAME(x) __stringify(SYMBOL_PREFIX) #x
 
 #ifndef cond_syscall
 #define cond_syscall(x) asm(".weak\t" __SYMBOL_NAME(x) \
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 07125e6..f1cce6a 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -123,6 +123,7 @@ ifdef CONFIG_SYMBOL_PREFIX
 _sym_flags = -DSYMBOL_PREFIX=$(patsubst "%",%,$(CONFIG_SYMBOL_PREFIX))
 _cpp_flags += $(_sym_flags)
 _a_flags += $(_sym_flags)
+_c_flags += $(_sym_flags)
 endif
 
 
-- 
1.8.1.2


