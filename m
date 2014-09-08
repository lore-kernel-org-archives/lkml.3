Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477AbaIHJhj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 05:37:39 -0400
Received: from mail-bn1bon0099.outbound.protection.outlook.com ([157.56.111.99]:23072
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753326AbaIHJhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 05:37:31 -0400
X-Greylist: delayed 843 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Sep 2014 05:37:30 EDT
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC: Ley Foon Tan <lftan@altera.com>, <lftan.linux@gmail.com>,
        <cltang@codesourcery.com>
Subject: [PATCH v3 01/29] asm-generic: add generic futex for !CONFIG_SMP
Date: Mon, 8 Sep 2014 17:22:12 +0800
Message-ID: <1410168160-3624-2-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1410168160-3624-1-git-send-email-lftan@altera.com>
References: <1410168160-3624-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009017)(6009001)(199003)(189002)(2201001)(36756003)(44976005)(77156001)(83322001)(50466002)(83072002)(48376002)(85852003)(62966002)(89996001)(104166001)(87936001)(92726001)(92566001)(97736003)(33646002)(88136002)(80022001)(102836001)(81342001)(76176999)(20776003)(85306004)(50986999)(47776003)(21056001)(105596002)(68736004)(107046002)(86362001)(106466001)(81542001)(31966008)(229853001)(76482001)(6806004)(50226001)(74502001)(95666004)(90102001)(74662001)(19580395003)(46102001)(77982001)(93916002)(99396002)(79102001)(84676001)(4396001)(42186005)(19580405001)(87286001)(77096002);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB034;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03283976A6
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=lftan@altera.com; 
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Follow m68k futex implementation for !CONFIG_SMP.

Signed-off-by: Ley Foon Tan <lftan@altera.com>
---
 include/asm-generic/futex.h | 82 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 82 insertions(+)

diff --git a/include/asm-generic/futex.h b/include/asm-generic/futex.h
index 01f227e..f5650a5 100644
--- a/include/asm-generic/futex.h
+++ b/include/asm-generic/futex.h
@@ -5,6 +5,87 @@
 #include <linux/uaccess.h>
 #include <asm/errno.h>
 
+#ifndef CONFIG_SMP
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
+	pagefault_disable();	/* implies preempt_disable() */
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
+	pagefault_enable();	/* subsumes preempt_enable() */
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
@@ -54,4 +135,5 @@ futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
 	return -ENOSYS;
 }
 
+#endif /* CONFIG_SMP */
 #endif
-- 
1.8.2.1

