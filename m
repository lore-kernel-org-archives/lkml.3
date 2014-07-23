Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933827AbaGWVUV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 17:20:21 -0400
Received: from smtp-69.nebula.fi ([83.145.220.69]:49557 "EHLO smtp.nebula.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933790AbaGWVUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 17:20:18 -0400
From: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
To: linux-kernel@vger.kernel.org, linux@openrisc.net
Cc: jonas@southpole.se,
        Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Subject: [PATCH 2/6] openrisc: add atomic bitops
Date: Thu, 24 Jul 2014 00:18:12 +0300
Message-Id: <1406150296-13308-3-git-send-email-stefan.kristiansson@saunalahti.fi>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406150296-13308-1-git-send-email-stefan.kristiansson@saunalahti.fi>
References: <1406150296-13308-1-git-send-email-stefan.kristiansson@saunalahti.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This utilize the load-link/store-conditional l.lwa and l.swa
instructions to implement the atomic bitops.
When those instructions are not available, a fallback to the
generic implementation is provided.

Signed-off-by: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
---
 arch/openrisc/include/asm/bitops.h        |   2 +-
 arch/openrisc/include/asm/bitops/atomic.h | 109 ++++++++++++++++++++++++++++++
 2 files changed, 110 insertions(+), 1 deletion(-)
 create mode 100644 arch/openrisc/include/asm/bitops/atomic.h

diff --git a/arch/openrisc/include/asm/bitops.h b/arch/openrisc/include/asm/bitops.h
index 2c64f22..08271bc 100644
--- a/arch/openrisc/include/asm/bitops.h
+++ b/arch/openrisc/include/asm/bitops.h
@@ -52,7 +52,7 @@
 #include <asm-generic/bitops/hweight.h>
 #include <asm-generic/bitops/lock.h>
 
-#include <asm-generic/bitops/atomic.h>
+#include <asm/bitops/atomic.h>
 #include <asm-generic/bitops/non-atomic.h>
 #include <asm-generic/bitops/le.h>
 #include <asm-generic/bitops/ext2-atomic.h>
diff --git a/arch/openrisc/include/asm/bitops/atomic.h b/arch/openrisc/include/asm/bitops/atomic.h
new file mode 100644
index 0000000..ef25cff
--- /dev/null
+++ b/arch/openrisc/include/asm/bitops/atomic.h
@@ -0,0 +1,109 @@
+/*
+ * Copyright (C) 2014 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2.  This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+
+#ifndef __ASM_OPENRISC_BITOPS_ATOMIC_H
+#define __ASM_OPENRISC_BITOPS_ATOMIC_H
+
+#ifdef CONFIG_OPENRISC_HAVE_INST_LWA_SWA
+
+static inline void set_bit(int nr, volatile unsigned long *addr)
+{
+	unsigned long mask = BIT_MASK(nr);
+	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
+	unsigned long tmp;
+
+	__asm__ __volatile__(
+		"1:	l.lwa	%0,0(%1)	\n"
+		"	l.or	%0,%0,%2	\n"
+		"	l.swa	0(%1),%0	\n"
+		"	l.bnf	1b		\n"
+		"	 l.nop			\n"
+		: "=&r"(tmp)
+		: "r"(p), "r"(mask)
+		: "cc", "memory");
+}
+
+static inline void clear_bit(int nr, volatile unsigned long *addr)
+{
+	unsigned long mask = BIT_MASK(nr);
+	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
+	unsigned long tmp;
+
+	__asm__ __volatile__(
+		"1:	l.lwa	%0,0(%1)	\n"
+		"	l.and	%0,%0,%2	\n"
+		"	l.swa	0(%1),%0	\n"
+		"	l.bnf	1b		\n"
+		"	 l.nop			\n"
+		: "=&r"(tmp)
+		: "r"(p), "r"(~mask)
+		: "cc", "memory");
+}
+
+static inline void change_bit(int nr, volatile unsigned long *addr)
+{
+	unsigned long mask = BIT_MASK(nr);
+	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
+	unsigned long tmp;
+
+	__asm__ __volatile__(
+		"1:	l.lwa	%0,0(%1)	\n"
+		"	l.xor	%0,%0,%2	\n"
+		"	l.swa	0(%1),%0	\n"
+		"	l.bnf	1b		\n"
+		"	 l.nop			\n"
+		: "=&r"(tmp)
+		: "r"(p), "r"(mask)
+		: "cc", "memory");
+}
+
+static inline int test_and_set_bit(int nr, volatile unsigned long *addr)
+{
+	unsigned long mask = BIT_MASK(nr);
+	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
+	unsigned long old;
+	unsigned long tmp;
+
+	__asm__ __volatile__(
+		"1:	l.lwa	%0,0(%2)	\n"
+		"	l.or	%1,%0,%3	\n"
+		"	l.swa	0(%2),%1	\n"
+		"	l.bnf	1b		\n"
+		"	 l.nop			\n"
+		: "=&r"(old), "=&r"(tmp)
+		: "r"(p), "r"(mask)
+		: "cc", "memory");
+
+	return (old & mask) != 0;
+}
+
+static inline int test_and_clear_bit(int nr, volatile unsigned long *addr)
+{
+	unsigned long mask = BIT_MASK(nr);
+	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
+	unsigned long old;
+	unsigned long tmp;
+
+	__asm__ __volatile__(
+		"1:	l.lwa	%0,0(%2)	\n"
+		"	l.and	%1,%0,%3	\n"
+		"	l.swa	0(%2),%1	\n"
+		"	l.bnf	1b		\n"
+		"	 l.nop			\n"
+		: "=&r"(old), "=&r"(tmp)
+		: "r"(p), "r"(~mask)
+		: "cc", "memory");
+
+	return (old & mask) != 0;
+}
+
+#else
+#include <asm-generic/bitops/atomic.h>
+#endif
+
+#endif /* __ASM_OPENRISC_BITOPS_ATOMIC_H */
-- 
1.8.3.2

