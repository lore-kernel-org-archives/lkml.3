Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933852AbaGWVUZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 17:20:25 -0400
Received: from smtp-69.nebula.fi ([83.145.220.69]:40899 "EHLO smtp.nebula.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933790AbaGWVUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 17:20:22 -0400
From: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
To: linux-kernel@vger.kernel.org, linux@openrisc.net
Cc: jonas@southpole.se,
        Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Subject: [PATCH 4/6] openrisc: add atomic operations implementations
Date: Thu, 24 Jul 2014 00:18:14 +0300
Message-Id: <1406150296-13308-5-git-send-email-stefan.kristiansson@saunalahti.fi>
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
 arch/openrisc/include/asm/Kbuild   |  1 -
 arch/openrisc/include/asm/atomic.h | 88 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 88 insertions(+), 1 deletion(-)
 create mode 100644 arch/openrisc/include/asm/atomic.h

diff --git a/arch/openrisc/include/asm/Kbuild b/arch/openrisc/include/asm/Kbuild
index 013b64a..1e759d5 100644
--- a/arch/openrisc/include/asm/Kbuild
+++ b/arch/openrisc/include/asm/Kbuild
@@ -1,7 +1,6 @@
 
 header-y += ucontext.h
 
-generic-y += atomic.h
 generic-y += auxvec.h
 generic-y += barrier.h
 generic-y += bitsperlong.h
diff --git a/arch/openrisc/include/asm/atomic.h b/arch/openrisc/include/asm/atomic.h
new file mode 100644
index 0000000..253edcc
--- /dev/null
+++ b/arch/openrisc/include/asm/atomic.h
@@ -0,0 +1,88 @@
+/*
+ * Copyright (C) 2014 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2.  This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+
+#ifndef __ASM_OPENRISC_ATOMIC_H
+#define __ASM_OPENRISC_ATOMIC_H
+
+#include <linux/types.h>
+
+#ifdef CONFIG_OPENRISC_HAVE_INST_LWA_SWA
+
+static inline int atomic_add_return(int i, atomic_t *v)
+{
+	int tmp;
+
+	__asm__ __volatile__(
+		"1:	l.lwa	%0,0(%1)	\n"
+		"	l.add	%0,%0,%2	\n"
+		"	l.swa	0(%1),%0	\n"
+		"	l.bnf	1b		\n"
+		"	 l.nop			\n"
+		: "=&r"(tmp)
+		: "r"(&v->counter), "r"(i)
+		: "cc", "memory");
+
+	return tmp;
+}
+
+static inline int atomic_sub_return(int i, atomic_t *v)
+{
+	int tmp;
+
+	__asm__ __volatile__(
+		"1:	l.lwa	%0,0(%1)	\n"
+		"	l.sub	%0,%0,%2	\n"
+		"	l.swa	0(%1),%0	\n"
+		"	l.bnf	1b		\n"
+		"	 l.nop			\n"
+		: "=&r"(tmp)
+		: "r"(&v->counter), "r"(i)
+		: "cc", "memory");
+
+	return tmp;
+}
+
+static inline void atomic_clear_mask(unsigned long mask, atomic_t *v)
+{
+	unsigned long tmp;
+
+	__asm__ __volatile__(
+		"1:	l.lwa	%0,0(%1)	\n"
+		"	l.and	%0,%0,%2	\n"
+		"	l.swa	0(%1),%0	\n"
+		"	l.bnf	1b		\n"
+		"	 l.nop			\n"
+		: "=&r"(tmp)
+		: "r"(&v->counter), "r"(mask)
+		: "cc", "memory");
+}
+
+static inline void atomic_set_mask(unsigned long mask, atomic_t *v)
+{
+	unsigned long tmp;
+
+	__asm__ __volatile__(
+		"1:	l.lwa	%0,0(%1)	\n"
+		"	l.or	%0,%0,%2	\n"
+		"	l.swa	0(%1),%0	\n"
+		"	l.bnf	1b		\n"
+		"	 l.nop			\n"
+		: "=&r"(tmp)
+		: "r"(&v->counter), "r"(mask)
+		: "cc", "memory");
+}
+
+#define atomic_add_return	atomic_add_return
+#define atomic_sub_return	atomic_sub_return
+#define atomic_clear_mask	atomic_clear_mask
+#define atomic_set_mask		atomic_set_mask
+
+#endif
+#include <asm-generic/atomic.h>
+
+#endif /* __ASM_OPENRISC_ATOMIC_H */
-- 
1.8.3.2

