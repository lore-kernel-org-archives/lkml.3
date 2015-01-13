Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419AbbAMTyJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 14:54:09 -0500
Received: from usmamail.tilera.com ([12.216.194.151]:38218 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbbAMTyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 14:54:07 -0500
X-Greylist: delayed 323 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Jan 2015 14:53:57 EST
X-CheckPoint: {54B577D4-2-2100090A-C0000000}
Message-ID: <201501131950.t0DJognR027020@lab-37.internal.tilera.com>
From: Chris Metcalf <cmetcalf@ezchip.com>
Date: Tue, 13 Jan 2015 14:39:05 -0500
Subject: [PATCH 1/2] tile: fix put_user sparse errors
To: <linux-kernel@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, <linux-arch@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use x86's __inttype macro instead of using the typeof(x-x) trick to
generate a suitable integer size type.  This avoids a sparse warning
when examining the x-x type with a bitwise type.

Signed-off-by: Chris Metcalf <cmetcalf@ezchip.com>
---
 arch/tile/include/asm/uaccess.h | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/tile/include/asm/uaccess.h b/arch/tile/include/asm/uaccess.h
index b6cde3209b96..b81b24a8489b 100644
--- a/arch/tile/include/asm/uaccess.h
+++ b/arch/tile/include/asm/uaccess.h
@@ -114,14 +114,14 @@ struct exception_table_entry {
 extern int fixup_exception(struct pt_regs *regs);
 
 /*
+ * This is a type: either unsigned long, if the argument fits into
+ * that type, or otherwise unsigned long long.
+ */
+#define __inttype(x) \
+	__typeof__(__builtin_choose_expr(sizeof(x) > sizeof(0UL), 0ULL, 0UL))
+
+/*
  * Support macros for __get_user().
- *
- * Implementation note: The "case 8" logic of casting to the type of
- * the result of subtracting the value from itself is basically a way
- * of keeping all integer types the same, but casting any pointers to
- * ptrdiff_t, i.e. also an integer type.  This way there are no
- * questionable casts seen by the compiler on an ILP32 platform.
- *
  * Note that __get_user() and __put_user() assume proper alignment.
  */
 
@@ -178,7 +178,7 @@ extern int fixup_exception(struct pt_regs *regs);
 			     "9:"					\
 			     : "=r" (ret), "=r" (__a), "=&r" (__b)	\
 			     : "r" (ptr), "i" (-EFAULT));		\
-		(x) = (__typeof(x))(__typeof((x)-(x)))			\
+		(x) = (__force __typeof(x))(__inttype(x))		\
 			(((u64)__hi32(__a, __b) << 32) |		\
 			 __lo32(__a, __b));				\
 	})
@@ -246,7 +246,7 @@ extern int __get_user_bad(void)
 #define __put_user_4(x, ptr, ret) __put_user_asm(sw, x, ptr, ret)
 #define __put_user_8(x, ptr, ret)					\
 	({								\
-		u64 __x = (__typeof((x)-(x)))(x);			\
+		u64 __x = (__force __inttype(x))(x);			\
 		int __lo = (int) __x, __hi = (int) (__x >> 32);		\
 		asm volatile("1: { sw %1, %2; addi %0, %1, 4 }\n"	\
 			     "2: { sw %0, %3; movei %0, 0 }\n"		\
-- 
2.1.2

