Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541AbaJ1Doo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:44:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45299 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317AbaJ1Dol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:44:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.16 071/127] kernel: add support for gcc 5
Date: Tue, 28 Oct 2014 11:35:06 +0800
Message-Id: <20141028033423.957752390@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033420.925922046@linuxfoundation.org>
References: <20141028033420.925922046@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sasha Levin <sasha.levin@oracle.com>

commit 71458cfc782eafe4b27656e078d379a34e472adf upstream.

We're missing include/linux/compiler-gcc5.h which is required now
because gcc branched off to v5 in trunk.

Just copy the relevant bits out of include/linux/compiler-gcc4.h,
no new code is added as of now.

This fixes a build error when using gcc 5.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/compiler-gcc5.h |   66 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

--- /dev/null
+++ b/include/linux/compiler-gcc5.h
@@ -0,0 +1,66 @@
+#ifndef __LINUX_COMPILER_H
+#error "Please don't include <linux/compiler-gcc5.h> directly, include <linux/compiler.h> instead."
+#endif
+
+#define __used				__attribute__((__used__))
+#define __must_check			__attribute__((warn_unused_result))
+#define __compiler_offsetof(a, b)	__builtin_offsetof(a, b)
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


