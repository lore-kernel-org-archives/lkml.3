Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029AbaIDPhi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 11:37:38 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:16720 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbaIDPhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 11:37:37 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: akpm@linuxfoundation.org
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] kernel: add support for gcc 5
Date: Thu,  4 Sep 2014 11:37:19 -0400
Message-Id: <1409845039-5751-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.9.1
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're missing include/linux/compiler-gcc5.h which is required now
because gcc branched off to v5 in trunk.

Just copy the relevant bits out of include/linux/compiler-gcc4.h,
no new code is added as of now.

This fixes a build error when using gcc 5.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 include/linux/compiler-gcc5.h |   66 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)
 create mode 100644 include/linux/compiler-gcc5.h

diff --git a/include/linux/compiler-gcc5.h b/include/linux/compiler-gcc5.h
new file mode 100644
index 0000000..b989d55
--- /dev/null
+++ b/include/linux/compiler-gcc5.h
@@ -0,0 +1,66 @@
+#ifndef __LINUX_COMPILER_H
+#error "Please don't include <linux/compiler-gcc5.h> directly, include <linux/compiler.h> instead."
+#endif
+
+#define __used			__attribute__((__used__))
+#define __must_check 		__attribute__((warn_unused_result))
+#define __compiler_offsetof(a,b) __builtin_offsetof(a,b)
+
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
+
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
+/*
+ * Tell the optimizer that something else uses this function or variable.
+ */
+#define __visible __attribute__((externally_visible))
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
+#define __HAVE_BUILTIN_BSWAP32__
+#define __HAVE_BUILTIN_BSWAP64__
+#define __HAVE_BUILTIN_BSWAP16__
+#endif /* CONFIG_ARCH_USE_BUILTIN_BSWAP */
-- 
1.7.10.4

