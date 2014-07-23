Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933879AbaGWVU3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 17:20:29 -0400
Received: from smtp-69.nebula.fi ([83.145.220.69]:41144 "EHLO smtp.nebula.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933849AbaGWVU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 17:20:26 -0400
From: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
To: linux-kernel@vger.kernel.org, linux@openrisc.net
Cc: jonas@southpole.se,
        Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Subject: [PATCH 6/6] openrisc: add futex_atomic_* implementations
Date: Thu, 24 Jul 2014 00:18:16 +0300
Message-Id: <1406150296-13308-7-git-send-email-stefan.kristiansson@saunalahti.fi>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406150296-13308-1-git-send-email-stefan.kristiansson@saunalahti.fi>
References: <1406150296-13308-1-git-send-email-stefan.kristiansson@saunalahti.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support for the futex_atomic_* operations by using the
load-link/store-conditional l.lwa/l.swa instructions.

A fallback to the generic implementation is provided when those
implementations aren't available.
The generic implementation however only provides stubs for the
functions, so to obtain proper futex support, the implementation
that is added here is needed.

Signed-off-by: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
---
 arch/openrisc/include/asm/Kbuild  |   1 -
 arch/openrisc/include/asm/futex.h | 140 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 140 insertions(+), 1 deletion(-)
 create mode 100644 arch/openrisc/include/asm/futex.h

diff --git a/arch/openrisc/include/asm/Kbuild b/arch/openrisc/include/asm/Kbuild
index 1e759d5..5bc2246 100644
--- a/arch/openrisc/include/asm/Kbuild
+++ b/arch/openrisc/include/asm/Kbuild
@@ -20,7 +20,6 @@ generic-y += exec.h
 generic-y += fb.h
 generic-y += fcntl.h
 generic-y += ftrace.h
-generic-y += futex.h
 generic-y += hardirq.h
 generic-y += hash.h
 generic-y += hw_irq.h
diff --git a/arch/openrisc/include/asm/futex.h b/arch/openrisc/include/asm/futex.h
new file mode 100644
index 0000000..f4b654f
--- /dev/null
+++ b/arch/openrisc/include/asm/futex.h
@@ -0,0 +1,140 @@
+#ifndef __ASM_OPENRISC_FUTEX_H
+#define __ASM_OPENRISC_FUTEX_H
+
+#ifdef CONFIG_OPENRISC_HAVE_INST_LWA_SWA
+#ifdef __KERNEL__
+
+#include <linux/futex.h>
+#include <linux/uaccess.h>
+#include <asm/errno.h>
+
+#define __futex_atomic_op(insn, ret, oldval, uaddr, oparg) \
+({								\
+	__asm__ __volatile__ (					\
+		"1:	l.lwa	%0, %2			\n"	\
+			insn				"\n"	\
+		"2:	l.swa	%2, %1			\n"	\
+		"	l.bnf	1b			\n"	\
+		"	 l.ori	%1, r0, 0		\n"	\
+		"3:					\n"	\
+		".section .fixup,\"ax\"			\n"	\
+		"4:	l.j	3b			\n"	\
+		"	 l.addi	%1, r0, %3		\n"	\
+		".previous				\n"	\
+		".section __ex_table,\"a\"		\n"	\
+		".word	1b,4b,2b,4b			\n"	\
+		".previous				\n"	\
+		: "=&r" (oldval), "=&r" (ret), "+m" (*uaddr)	\
+		: "i" (-EFAULT), "r" (oparg)			\
+		: "cc", "memory"				\
+		);						\
+})
+
+static inline int
+futex_atomic_op_inuser(int encoded_op, u32 __user *uaddr)
+{
+	int op = (encoded_op >> 28) & 7;
+	int cmp = (encoded_op >> 24) & 15;
+	int oparg = (encoded_op << 8) >> 20;
+	int cmparg = (encoded_op << 20) >> 20;
+	int oldval = 0, ret;
+
+	if (encoded_op & (FUTEX_OP_OPARG_SHIFT << 28))
+		oparg = 1 << oparg;
+
+	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
+		return -EFAULT;
+
+	pagefault_disable();
+
+	switch (op) {
+	case FUTEX_OP_SET:
+		__futex_atomic_op("l.or %1,%4,%4", ret, oldval, uaddr, oparg);
+		break;
+	case FUTEX_OP_ADD:
+		__futex_atomic_op("l.add %1,%0,%4", ret, oldval, uaddr, oparg);
+		break;
+	case FUTEX_OP_OR:
+		__futex_atomic_op("l.or %1,%0,%4", ret, oldval, uaddr, oparg);
+		break;
+	case FUTEX_OP_ANDN:
+		__futex_atomic_op("l.and %1,%0,%4", ret, oldval, uaddr, ~oparg);
+		break;
+	case FUTEX_OP_XOR:
+		__futex_atomic_op("l.xor %1,%0,%4", ret, oldval, uaddr, oparg);
+		break;
+	default:
+		ret = -ENOSYS;
+	}
+
+	pagefault_enable();
+
+	if (!ret) {
+		switch (cmp) {
+		case FUTEX_OP_CMP_EQ:
+			ret = (oldval == cmparg);
+			break;
+		case FUTEX_OP_CMP_NE:
+			ret = (oldval != cmparg);
+			break;
+		case FUTEX_OP_CMP_LT:
+			ret = (oldval < cmparg);
+			break;
+		case FUTEX_OP_CMP_GE:
+			ret = (oldval >= cmparg);
+			break;
+		case FUTEX_OP_CMP_LE:
+			ret = (oldval <= cmparg);
+			break;
+		case FUTEX_OP_CMP_GT:
+			ret = (oldval > cmparg);
+			break;
+		default:
+			ret = -ENOSYS;
+		}
+	}
+	return ret;
+}
+
+static inline int
+futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
+			      u32 oldval, u32 newval)
+{
+	int ret = 0;
+	u32 prev;
+
+	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
+		return -EFAULT;
+
+	__asm__ __volatile__ (				\
+		"1:	l.lwa	%1, %2		\n"	\
+		"	l.sfeq	%1, %3		\n"	\
+		"	l.bnf	3f		\n"	\
+		"	 l.nop			\n"	\
+		"2:	l.swa	%2, %4		\n"	\
+		"	l.bnf	1b		\n"	\
+		"	 l.nop			\n"	\
+		"3:				\n"	\
+		".section .fixup,\"ax\"		\n"	\
+		"4:	l.j	3b		\n"	\
+		"	 l.addi	%0, r0, %5	\n"	\
+		".previous			\n"	\
+		".section __ex_table,\"a\"	\n"	\
+		".word	1b,4b,2b,4b		\n"	\
+		".previous			\n"	\
+		: "+r" (ret), "=&r" (prev), "+m" (*uaddr) \
+		: "r" (oldval), "r" (newval), "i" (-EFAULT) \
+		: "cc",	"memory"			\
+		);
+
+	*uval = prev;
+	return ret;
+}
+
+#endif /* __KERNEL__ */
+
+#else
+#include <asm-generic/futex.h>
+#endif
+
+#endif /* __ASM_OPENRISC_FUTEX_H */
-- 
1.8.3.2

