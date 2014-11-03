Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120AbaKCKxj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 05:53:39 -0500
Received: from mail-by2on0056.outbound.protection.outlook.com ([207.46.100.56]:30751
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751230AbaKCKxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 05:53:33 -0500
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, Ley Foon Tan <lftan@altera.com>,
        <lftan.linux@gmail.com>, <cltang@codesourcery.com>
Subject: [PATCH v6 01/29] asm-generic: add generic futex for !CONFIG_SMP
Date: Mon, 3 Nov 2014 18:51:57 +0800
Message-ID: <1415011945-3297-2-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1415011945-3297-1-git-send-email-lftan@altera.com>
References: <1415011945-3297-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(189002)(199003)(88136002)(50466002)(4396001)(64706001)(106466001)(46102003)(104166001)(95666004)(76176999)(50226001)(68736004)(87286001)(84676001)(77156002)(86362001)(92726001)(47776003)(87936001)(50986999)(42186005)(92566001)(107046002)(89996001)(44976005)(48376002)(36756003)(102836001)(31966008)(21056001)(2201001)(229853001)(6806004)(120916001)(99396003)(33646002)(105596002)(19580395003)(93916002)(97736003)(20776003)(62966003)(77096003)(19580405001)(41533002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB1016;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB1016;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0384275935
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=lftan@altera.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB329;
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Follow m68k futex implementation for !CONFIG_SMP.

Signed-off-by: Ley Foon Tan <lftan@altera.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 include/asm-generic/futex.h | 114 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 114 insertions(+)

diff --git a/include/asm-generic/futex.h b/include/asm-generic/futex.h
index 01f227e..b59b5a5 100644
--- a/include/asm-generic/futex.h
+++ b/include/asm-generic/futex.h
@@ -5,6 +5,119 @@
 #include <linux/uaccess.h>
 #include <asm/errno.h>
 
+#ifndef CONFIG_SMP
+/*
+ * The following implementation only for uniprocessor machines.
+ * For UP, it's relies on the fact that pagefault_disable() also disables
+ * preemption to ensure mutual exclusion.
+ *
+ */
+
+/**
+ * futex_atomic_op_inuser() - Atomic arithmetic operation with constant
+ *			  argument and comparison of the previous
+ *			  futex value with another constant.
+ *
+ * @encoded_op:	encoded operation to execute
+ * @uaddr:	pointer to user space address
+ *
+ * Return:
+ * 0 - On success
+ * <0 - On error
+ */
+static inline int
+futex_atomic_op_inuser(int encoded_op, u32 __user *uaddr)
+{
+	int op = (encoded_op >> 28) & 7;
+	int cmp = (encoded_op >> 24) & 15;
+	int oparg = (encoded_op << 8) >> 20;
+	int cmparg = (encoded_op << 20) >> 20;
+	int oldval, ret;
+	u32 tmp;
+
+	if (encoded_op & (FUTEX_OP_OPARG_SHIFT << 28))
+		oparg = 1 << oparg;
+
+	pagefault_disable();
+
+	ret = -EFAULT;
+	if (unlikely(get_user(oldval, uaddr) != 0))
+		goto out_pagefault_enable;
+
+	ret = 0;
+	tmp = oldval;
+
+	switch (op) {
+	case FUTEX_OP_SET:
+		tmp = oparg;
+		break;
+	case FUTEX_OP_ADD:
+		tmp += oparg;
+		break;
+	case FUTEX_OP_OR:
+		tmp |= oparg;
+		break;
+	case FUTEX_OP_ANDN:
+		tmp &= ~oparg;
+		break;
+	case FUTEX_OP_XOR:
+		tmp ^= oparg;
+		break;
+	default:
+		ret = -ENOSYS;
+	}
+
+	if (ret == 0 && unlikely(put_user(tmp, uaddr) != 0))
+		ret = -EFAULT;
+
+out_pagefault_enable:
+	pagefault_enable();
+
+	if (ret == 0) {
+		switch (cmp) {
+		case FUTEX_OP_CMP_EQ: ret = (oldval == cmparg); break;
+		case FUTEX_OP_CMP_NE: ret = (oldval != cmparg); break;
+		case FUTEX_OP_CMP_LT: ret = (oldval < cmparg); break;
+		case FUTEX_OP_CMP_GE: ret = (oldval >= cmparg); break;
+		case FUTEX_OP_CMP_LE: ret = (oldval <= cmparg); break;
+		case FUTEX_OP_CMP_GT: ret = (oldval > cmparg); break;
+		default: ret = -ENOSYS;
+		}
+	}
+	return ret;
+}
+
+/**
+ * futex_atomic_cmpxchg_inatomic() - Compare and exchange the content of the
+ *				uaddr with newval if the current value is
+ *				oldval.
+ * @uval:	pointer to store content of @uaddr
+ * @uaddr:	pointer to user space address
+ * @oldval:	old value
+ * @newval:	new value to store to @uaddr
+ *
+ * Return:
+ * 0 - On success
+ * <0 - On error
+ */
+static inline int
+futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
+			      u32 oldval, u32 newval)
+{
+	u32 val;
+
+	if (unlikely(get_user(val, uaddr) != 0))
+		return -EFAULT;
+
+	if (val == oldval && unlikely(put_user(newval, uaddr) != 0))
+		return -EFAULT;
+
+	*uval = val;
+
+	return 0;
+}
+
+#else
 static inline int
 futex_atomic_op_inuser (int encoded_op, u32 __user *uaddr)
 {
@@ -54,4 +167,5 @@ futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
 	return -ENOSYS;
 }
 
+#endif /* CONFIG_SMP */
 #endif
-- 
1.8.2.1

