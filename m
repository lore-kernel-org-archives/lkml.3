Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746Ab3FML7y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 07:59:54 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:45918 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214Ab3FML7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 07:59:53 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: Andreas Schwab <schwab@linux-m68k.org>, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] m68k/uaccess: Fix asm constraints for userspace access
Date: Thu, 13 Jun 2013 13:59:44 +0200
Message-Id: <1371124784-13306-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When compiling a MMU kernel with CPU_HAS_ADDRESS_SPACES=n (e.g. "MMU=y
allnoconfig": "echo CONFIG_MMU=y > allno.config && make KCONFIG_ALLCONFIG=1
allnoconfig"), we use plain "move" instead of "moves", and I got:

  CC      arch/m68k/lib/uaccess.o
{standard input}: Assembler messages:
{standard input}:47: Error: operands mismatch -- statement `move.b %a0,(%a1)' ignored

This happens because plain "move" doesn't support byte transfers between
memory and address registers, while "moves" does.

Fix the asm constraints for __generic_copy_from_user(),
__generic_copy_to_user(), and __clear_user() to only use data registers
when accessing userspace.

Also, relax the asm constraints for 16-bit userspace accesses in
__put_user() and __get_user(), as both "move" and "moves" do support
such transfers between memory and address registers.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/include/asm/uaccess_mm.h |    4 ++--
 arch/m68k/lib/uaccess.c            |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/m68k/include/asm/uaccess_mm.h b/arch/m68k/include/asm/uaccess_mm.h
index 472c891..7aa681b 100644
--- a/arch/m68k/include/asm/uaccess_mm.h
+++ b/arch/m68k/include/asm/uaccess_mm.h
@@ -90,7 +90,7 @@ asm volatile ("\n"					\
 		__put_user_asm(__pu_err, __pu_val, ptr, b, d, -EFAULT);	\
 		break;							\
 	case 2:								\
-		__put_user_asm(__pu_err, __pu_val, ptr, w, d, -EFAULT);	\
+		__put_user_asm(__pu_err, __pu_val, ptr, w, r, -EFAULT);	\
 		break;							\
 	case 4:								\
 		__put_user_asm(__pu_err, __pu_val, ptr, l, r, -EFAULT);	\
@@ -158,7 +158,7 @@ asm volatile ("\n"					\
 		__get_user_asm(__gu_err, x, ptr, u8, b, d, -EFAULT);	\
 		break;							\
 	case 2:								\
-		__get_user_asm(__gu_err, x, ptr, u16, w, d, -EFAULT);	\
+		__get_user_asm(__gu_err, x, ptr, u16, w, r, -EFAULT);	\
 		break;							\
 	case 4:								\
 		__get_user_asm(__gu_err, x, ptr, u32, l, r, -EFAULT);	\
diff --git a/arch/m68k/lib/uaccess.c b/arch/m68k/lib/uaccess.c
index 5e97f2e..35d1442 100644
--- a/arch/m68k/lib/uaccess.c
+++ b/arch/m68k/lib/uaccess.c
@@ -52,7 +52,7 @@ unsigned long __generic_copy_from_user(void *to, const void __user *from,
 		"	.long	3b,30b\n"
 		"	.long	5b,50b\n"
 		"	.previous"
-		: "=d" (res), "+a" (from), "+a" (to), "=&r" (tmp)
+		: "=d" (res), "+a" (from), "+a" (to), "=&d" (tmp)
 		: "0" (n / 4), "d" (n & 3));
 
 	return res;
@@ -96,7 +96,7 @@ unsigned long __generic_copy_to_user(void __user *to, const void *from,
 		"	.long	7b,50b\n"
 		"	.long	8b,50b\n"
 		"	.previous"
-		: "=d" (res), "+a" (from), "+a" (to), "=&r" (tmp)
+		: "=d" (res), "+a" (from), "+a" (to), "=&d" (tmp)
 		: "0" (n / 4), "d" (n & 3));
 
 	return res;
@@ -141,7 +141,7 @@ unsigned long __clear_user(void __user *to, unsigned long n)
 		"	.long	7b,40b\n"
 		"	.previous"
 		: "=d" (res), "+a" (to)
-		: "r" (0), "0" (n / 4), "d" (n & 3));
+		: "d" (0), "0" (n / 4), "d" (n & 3));
 
     return res;
 }
-- 
1.7.0.4

