Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932568AbaGOItC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 04:49:02 -0400
Received: from mail-bl2lp0210.outbound.protection.outlook.com ([207.46.163.210]:14570
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758396AbaGOIsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 04:48:45 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC: Ley Foon Tan <lftan@altera.com>, <lftan.linux@gmail.com>,
        <cltang@codesourcery.com>
Subject: [PATCH v2 21/29] nios2: Futex operations
Date: Tue, 15 Jul 2014 16:45:48 +0800
Message-ID: <1405413956-2772-22-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1405413956-2772-1-git-send-email-lftan@altera.com>
References: <1405413956-2772-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(84676001)(85306003)(83072002)(105596002)(106466001)(89996001)(107046002)(74502001)(4396001)(50226001)(92726001)(88136002)(102836001)(83322001)(95666004)(42186005)(19580405001)(15975445006)(97736001)(92566001)(47776003)(19580395003)(64706001)(36756003)(6806004)(79102001)(74662001)(80022001)(77982001)(76482001)(104166001)(76176999)(68736004)(31966008)(50986999)(77156001)(20776003)(46102001)(21056001)(229853001)(85852003)(77096002)(44976005)(81342001)(48376002)(62966002)(86362001)(81542001)(93916002)(15202345003)(87936001)(87286001)(99396002)(33646002)(2201001)(2004002);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB035;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 027367F73D
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=lftan@altera.com; 
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces the futex operation.

Signed-off-by: Ley Foon Tan <lftan@altera.com>
---
 arch/nios2/include/asm/futex-irq.h | 130 +++++++++++++++++++++++++++++++++++++
 arch/nios2/include/asm/futex.h     | 110 +++++++++++++++++++++++++++++++
 2 files changed, 240 insertions(+)
 create mode 100644 arch/nios2/include/asm/futex-irq.h
 create mode 100644 arch/nios2/include/asm/futex.h

diff --git a/arch/nios2/include/asm/futex-irq.h b/arch/nios2/include/asm/futex-irq.h
new file mode 100644
index 0000000..ade9296
--- /dev/null
+++ b/arch/nios2/include/asm/futex-irq.h
@@ -0,0 +1,130 @@
+/*
+ *  Copyright (C) 2013 Altera Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ * Based on asm/futex.h from sh platform.
+ *
+ */
+
+#ifndef __ASM_NIOS2_FUTEX_IRQ_H
+#define __ASM_NIOS2_FUTEX_IRQ_H
+
+
+static inline int atomic_futex_op_xchg_set(int oparg, u32 __user *uaddr,
+					   int *oldval)
+{
+	unsigned long flags;
+	int ret;
+
+	local_irq_save(flags);
+
+	ret = get_user(*oldval, uaddr);
+	if (!ret)
+		ret = put_user(oparg, uaddr);
+
+	local_irq_restore(flags);
+
+	return ret;
+}
+
+static inline int atomic_futex_op_xchg_add(int oparg, u32 __user *uaddr,
+					   int *oldval)
+{
+	unsigned long flags;
+	int ret;
+
+	local_irq_save(flags);
+
+	ret = get_user(*oldval, uaddr);
+	if (!ret)
+		ret = put_user(*oldval + oparg, uaddr);
+
+	local_irq_restore(flags);
+
+	return ret;
+}
+
+static inline int atomic_futex_op_xchg_or(int oparg, u32 __user *uaddr,
+					  int *oldval)
+{
+	unsigned long flags;
+	int ret;
+
+	local_irq_save(flags);
+
+	ret = get_user(*oldval, uaddr);
+	if (!ret)
+		ret = put_user(*oldval | oparg, uaddr);
+
+	local_irq_restore(flags);
+
+	return ret;
+}
+
+static inline int atomic_futex_op_xchg_and(int oparg, u32 __user *uaddr,
+					   int *oldval)
+{
+	unsigned long flags;
+	int ret;
+
+	local_irq_save(flags);
+
+	ret = get_user(*oldval, uaddr);
+	if (!ret)
+		ret = put_user(*oldval & oparg, uaddr);
+
+	local_irq_restore(flags);
+
+	return ret;
+}
+
+static inline int atomic_futex_op_xchg_xor(int oparg, u32 __user *uaddr,
+					   int *oldval)
+{
+	unsigned long flags;
+	int ret;
+
+	local_irq_save(flags);
+
+	ret = get_user(*oldval, uaddr);
+	if (!ret)
+		ret = put_user(*oldval ^ oparg, uaddr);
+
+	local_irq_restore(flags);
+
+	return ret;
+}
+
+static inline int atomic_futex_op_cmpxchg_inatomic(u32 *uval,
+						u32 __user *uaddr,
+						u32 oldval, u32 newval)
+{
+	unsigned long flags;
+	int ret;
+	u32 prev = 0;
+
+	local_irq_save(flags);
+
+	ret = get_user(prev, uaddr);
+	if (!ret && oldval == prev)
+		ret = put_user(newval, uaddr);
+
+	local_irq_restore(flags);
+
+	*uval = prev;
+	return ret;
+}
+
+#endif /* __ASM_NIOS2_FUTEX_IRQ_H */
diff --git a/arch/nios2/include/asm/futex.h b/arch/nios2/include/asm/futex.h
new file mode 100644
index 0000000..52b2fa9
--- /dev/null
+++ b/arch/nios2/include/asm/futex.h
@@ -0,0 +1,110 @@
+/*
+ *  Copyright (C) 2013 Altera Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ * Based on asm/futex.h from sh platform.
+ *
+ */
+
+#ifndef __ASM_NIOS2_FUTEX_H
+#define __ASM_NIOS2_FUTEX_H
+
+#ifdef __KERNEL__
+
+#include <linux/futex.h>
+#include <linux/uaccess.h>
+#include <linux/errno.h>
+
+#include <asm/futex-irq.h>
+
+static inline int futex_atomic_op_inuser(int encoded_op, u32 __user *uaddr)
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
+		ret = atomic_futex_op_xchg_set(oparg, uaddr, &oldval);
+		break;
+	case FUTEX_OP_ADD:
+		ret = atomic_futex_op_xchg_add(oparg, uaddr, &oldval);
+		break;
+	case FUTEX_OP_OR:
+		ret = atomic_futex_op_xchg_or(oparg, uaddr, &oldval);
+		break;
+	case FUTEX_OP_ANDN:
+		ret = atomic_futex_op_xchg_and(~oparg, uaddr, &oldval);
+		break;
+	case FUTEX_OP_XOR:
+		ret = atomic_futex_op_xchg_xor(oparg, uaddr, &oldval);
+		break;
+	default:
+		ret = -ENOSYS;
+		break;
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
+
+	return ret;
+}
+
+static inline int
+futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
+				u32 oldval, u32 newval)
+{
+	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
+		return -EFAULT;
+
+	return atomic_futex_op_cmpxchg_inatomic(uval, uaddr, oldval, newval);
+}
+
+#endif /* __KERNEL__ */
+#endif /* __ASM_NIOS2_FUTEX_H */
-- 
1.8.2.1

