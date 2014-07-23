Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933900AbaGWVVP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 17:21:15 -0400
Received: from smtp-69.nebula.fi ([83.145.220.69]:47595 "EHLO smtp.nebula.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933795AbaGWVUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 17:20:21 -0400
From: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
To: linux-kernel@vger.kernel.org, linux@openrisc.net
Cc: jonas@southpole.se,
        Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Subject: [PATCH 3/6] openrisc: add cmpxchg and xchg implementations
Date: Thu, 24 Jul 2014 00:18:13 +0300
Message-Id: <1406150296-13308-4-git-send-email-stefan.kristiansson@saunalahti.fi>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406150296-13308-1-git-send-email-stefan.kristiansson@saunalahti.fi>
References: <1406150296-13308-1-git-send-email-stefan.kristiansson@saunalahti.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Optimized version that make use of the l.lwa and l.swa instructions
if available.

Signed-off-by: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
---
 arch/openrisc/include/asm/Kbuild    |  2 -
 arch/openrisc/include/asm/cmpxchg.h | 83 +++++++++++++++++++++++++++++++++++++
 2 files changed, 83 insertions(+), 2 deletions(-)
 create mode 100644 arch/openrisc/include/asm/cmpxchg.h

diff --git a/arch/openrisc/include/asm/Kbuild b/arch/openrisc/include/asm/Kbuild
index 17f1e83..013b64a 100644
--- a/arch/openrisc/include/asm/Kbuild
+++ b/arch/openrisc/include/asm/Kbuild
@@ -10,8 +10,6 @@ generic-y += bugs.h
 generic-y += cacheflush.h
 generic-y += checksum.h
 generic-y += clkdev.h
-generic-y += cmpxchg-local.h
-generic-y += cmpxchg.h
 generic-y += cputime.h
 generic-y += current.h
 generic-y += device.h
diff --git a/arch/openrisc/include/asm/cmpxchg.h b/arch/openrisc/include/asm/cmpxchg.h
new file mode 100644
index 0000000..4e40411
--- /dev/null
+++ b/arch/openrisc/include/asm/cmpxchg.h
@@ -0,0 +1,83 @@
+/*
+ * Copyright (C) 2014 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2.  This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+
+#ifndef __ASM_OPENRISC_CMPXCHG_H
+#define __ASM_OPENRISC_CMPXCHG_H
+
+#include  <linux/types.h>
+
+#ifdef CONFIG_OPENRISC_HAVE_INST_LWA_SWA
+
+/*
+ * This function doesn't exist, so you'll get a linker error
+ * if something tries to do an invalid cmpxchg().
+ */
+extern void __cmpxchg_called_with_bad_pointer(void);
+
+#define __HAVE_ARCH_CMPXCHG 1
+
+static inline unsigned long
+__cmpxchg(volatile void *ptr, unsigned long old, unsigned long new, int size)
+{
+	if (size != 4) {
+		__cmpxchg_called_with_bad_pointer();
+		return old;
+	}
+
+	__asm__ __volatile__(
+		"1:	l.lwa %0, 0(%1)		\n"
+		"	l.sfeq %0, %2		\n"
+		"	l.bnf 1f		\n"
+		"	 l.nop			\n"
+		"	l.swa 0(%1), %3		\n"
+		"	l.bnf 1b		\n"
+		"1:	 l.nop			\n"
+		: "=&r"(old)
+		: "r"(ptr), "r"(old), "r"(new)
+		: "cc", "memory");
+
+	return old;
+}
+
+#define cmpxchg(ptr, o, n) ((typeof(*(ptr)))__cmpxchg((ptr), \
+	(unsigned long)(o), (unsigned long)(n), sizeof(*(ptr))))
+
+/*
+ * This function doesn't exist, so you'll get a linker error if
+ * something tries to do an invalidly-sized xchg().
+ */
+extern void __xchg_called_with_bad_pointer(void);
+
+static inline unsigned long __xchg(unsigned long val, volatile void *ptr,
+				   int size)
+{
+	if (size != 4) {
+		__xchg_called_with_bad_pointer();
+		return val;
+	}
+
+	__asm__ __volatile__(
+		"1:	l.lwa %0, 0(%1)		\n"
+		"	l.swa 0(%1), %2		\n"
+		"	l.bnf 1b		\n"
+		"	 l.nop			\n"
+		: "=&r"(val)
+		: "r"(ptr), "r"(val)
+		: "cc", "memory");
+
+	return val;
+}
+
+#define xchg(ptr, with) \
+	((typeof(*(ptr)))__xchg((unsigned long)(with), (ptr), sizeof(*(ptr))))
+
+#else
+#include <asm-generic/cmpxchg.h>
+#endif
+
+#endif /* __ASM_OPENRISC_CMPXCHG_H */
-- 
1.8.3.2

