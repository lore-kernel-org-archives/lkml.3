Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab3AXLLF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 06:11:05 -0500
Received: from us02smtp1.synopsys.com ([198.182.60.75]:47394 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306Ab3AXLKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 06:10:45 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH v3 08/71] ARC: [optim] uaccess __{get,put}_user() optimised
Date: Thu, 24 Jan 2013 16:35:49 +0530
Message-ID: <1359025589-22277-6-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1359025589-22277-1-git-send-email-vgupta@synopsys.com>
References: <1359025589-22277-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Override asm-generic implementations. We basically gain on 2 fronts

* checks for alignment no longer needed as we are only doing "unit"
  sized copies.

  (Careful observer could argue that While the kernel buffers are aligned,
   the user buffer in theory might not be - however in that case the
   user space is already broken when it tries to deref a hword/word
   straddling word boundary - so we are not making it any worse).

* __copy_{to,from}_user( ) returns bytes that couldn't be copied,
  whereas get_user() returns 0 for success or -EFAULT (not size). Thus
  the code to do leftover bytes calculation can be avoided as well.

The savings were significant: ~17k of code.

bloat-o-meter vmlinux_uaccess_pre vmlinux_uaccess_post
add/remove: 0/4 grow/shrink: 8/118 up/down: 1262/-18758 (-17496)
							^^^^^^^^^
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arc/include/asm/uaccess.h |  105 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 105 insertions(+), 0 deletions(-)

diff --git a/arch/arc/include/asm/uaccess.h b/arch/arc/include/asm/uaccess.h
index f13bca4..3242082 100644
--- a/arch/arc/include/asm/uaccess.h
+++ b/arch/arc/include/asm/uaccess.h
@@ -57,6 +57,111 @@
 #define __access_ok(addr, sz)	(unlikely(__kernel_ok) || \
 				 likely(__user_ok((addr), (sz))))
 
+/*********** Single byte/hword/word copies ******************/
+
+#define __get_user_fn(sz, u, k)					\
+({								\
+	long __ret = 0;	/* success by default */	\
+	switch (sz) {						\
+	case 1: __arc_get_user_one(*(k), u, "ldb", __ret); break;	\
+	case 2: __arc_get_user_one(*(k), u, "ldw", __ret); break;	\
+	case 4: __arc_get_user_one(*(k), u, "ld", __ret);  break;	\
+	case 8: __arc_get_user_one_64(*(k), u, __ret);     break;	\
+	}							\
+	__ret;							\
+})
+
+/*
+ * Returns 0 on success, -EFAULT if not.
+ * @ret already contains 0 - given that errors will be less likely
+ * (hence +r asm constraint below).
+ * In case of error, fixup code will make it -EFAULT
+ */
+#define __arc_get_user_one(dst, src, op, ret)	\
+	__asm__ __volatile__(                   \
+	"1:	"op"    %1,[%2]\n"		\
+	"2:	;nop\n"				\
+	"	.section .fixup, \"ax\"\n"	\
+	"	.align 4\n"			\
+	"3:	mov %0, %3\n"			\
+	"	j   2b\n"			\
+	"	.previous\n"			\
+	"	.section __ex_table, \"a\"\n"	\
+	"	.align 4\n"			\
+	"	.word 1b,3b\n"			\
+	"	.previous\n"			\
+						\
+	: "+r" (ret), "=r" (dst)		\
+	: "r" (src), "ir" (-EFAULT))
+
+#define __arc_get_user_one_64(dst, src, ret)	\
+	__asm__ __volatile__(                   \
+	"1:	ld   %1,[%2]\n"			\
+	"4:	ld  %R1,[%2, 4]\n"		\
+	"2:	;nop\n"				\
+	"	.section .fixup, \"ax\"\n"	\
+	"	.align 4\n"			\
+	"3:	mov %0, %3\n"			\
+	"	j   2b\n"			\
+	"	.previous\n"			\
+	"	.section __ex_table, \"a\"\n"	\
+	"	.align 4\n"			\
+	"	.word 1b,3b\n"			\
+	"	.word 4b,3b\n"			\
+	"	.previous\n"			\
+						\
+	: "+r" (ret), "=r" (dst)		\
+	: "r" (src), "ir" (-EFAULT))
+
+#define __put_user_fn(sz, u, k)					\
+({								\
+	long __ret = 0;	/* success by default */	\
+	switch (sz) {						\
+	case 1: __arc_put_user_one(*(k), u, "stb", __ret); break;	\
+	case 2: __arc_put_user_one(*(k), u, "stw", __ret); break;	\
+	case 4: __arc_put_user_one(*(k), u, "st", __ret);  break;	\
+	case 8: __arc_put_user_one_64(*(k), u, __ret);     break;	\
+	}							\
+	__ret;							\
+})
+
+#define __arc_put_user_one(src, dst, op, ret)	\
+	__asm__ __volatile__(                   \
+	"1:	"op"    %1,[%2]\n"		\
+	"2:	;nop\n"				\
+	"	.section .fixup, \"ax\"\n"	\
+	"	.align 4\n"			\
+	"3:	mov %0, %3\n"			\
+	"	j   2b\n"			\
+	"	.previous\n"			\
+	"	.section __ex_table, \"a\"\n"	\
+	"	.align 4\n"			\
+	"	.word 1b,3b\n"			\
+	"	.previous\n"			\
+						\
+	: "+r" (ret)				\
+	: "r" (src), "r" (dst), "ir" (-EFAULT))
+
+#define __arc_put_user_one_64(src, dst, ret)	\
+	__asm__ __volatile__(                   \
+	"1:	st   %1,[%2]\n"			\
+	"4:	st  %R1,[%2, 4]\n"		\
+	"2:	;nop\n"				\
+	"	.section .fixup, \"ax\"\n"	\
+	"	.align 4\n"			\
+	"3:	mov %0, %3\n"			\
+	"	j   2b\n"			\
+	"	.previous\n"			\
+	"	.section __ex_table, \"a\"\n"	\
+	"	.align 4\n"			\
+	"	.word 1b,3b\n"			\
+	"	.word 4b,3b\n"			\
+	"	.previous\n"			\
+						\
+	: "+r" (ret)				\
+	: "r" (src), "r" (dst), "ir" (-EFAULT))
+
+
 static inline unsigned long
 __arc_copy_from_user(void *to, const void __user *from, unsigned long n)
 {
-- 
1.7.4.1

