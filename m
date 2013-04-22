Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839Ab3DVMyB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 08:54:01 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:59938 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753613Ab3DVMx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 08:53:59 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-parisc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH v2] parisc: uaccess: fix compiler warnings caused by __put_user casting
Date: Mon, 22 Apr 2013 13:53:43 +0100
Message-Id: <1366635223-4207-1-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When targetting 32-bit processors, __put_user emits a pair of stw
instructions for the 8-byte case. If the type of __val is a pointer, the
marshalling code casts it to the wider integer type of u64, resulting
in the following compiler warnings:

  kernel/signal.c: In function 'copy_siginfo_to_user':
  kernel/signal.c:2752:11: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
  kernel/signal.c:2752:11: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
  [...]

This patch fixes the warnings by removing the marshalling code and using
the correct output modifiers in the __put_{user,kernel}_asm64 macros
so that GCC will allocate the right registers without the need to
extract the two words explicitly.

Cc: Helge Deller <deller@gmx.de>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---

v1->v2: Put the output modifier on the correct word, so 64-bit put_user
        doesn't end up word-swapped.

 arch/parisc/include/asm/uaccess.h | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/arch/parisc/include/asm/uaccess.h b/arch/parisc/include/asm/uaccess.h
index 4ba2c93..e0a8235 100644
--- a/arch/parisc/include/asm/uaccess.h
+++ b/arch/parisc/include/asm/uaccess.h
@@ -181,30 +181,24 @@ struct exception_data {
 #if !defined(CONFIG_64BIT)
 
 #define __put_kernel_asm64(__val,ptr) do {		    \
-	u64 __val64 = (u64)(__val);			    \
-	u32 hi = (__val64) >> 32;			    \
-	u32 lo = (__val64) & 0xffffffff;		    \
 	__asm__ __volatile__ (				    \
 		"\n1:\tstw %2,0(%1)"			    \
-		"\n2:\tstw %3,4(%1)\n\t"		    \
+		"\n2:\tstw %R2,4(%1)\n\t"		    \
 		ASM_EXCEPTIONTABLE_ENTRY(1b,fixup_put_user_skip_2)\
 		ASM_EXCEPTIONTABLE_ENTRY(2b,fixup_put_user_skip_1)\
 		: "=r"(__pu_err)                            \
-		: "r"(ptr), "r"(hi), "r"(lo), "0"(__pu_err) \
+		: "r"(ptr), "r"(__val), "0"(__pu_err) \
 		: "r1");				    \
 } while (0)
 
 #define __put_user_asm64(__val,ptr) do {	    	    \
-	u64 __val64 = (u64)(__val);			    \
-	u32 hi = (__val64) >> 32;			    \
-	u32 lo = (__val64) & 0xffffffff;		    \
 	__asm__ __volatile__ (				    \
 		"\n1:\tstw %2,0(%%sr3,%1)"		    \
-		"\n2:\tstw %3,4(%%sr3,%1)\n\t"		    \
+		"\n2:\tstw %R2,4(%%sr3,%1)\n\t"		    \
 		ASM_EXCEPTIONTABLE_ENTRY(1b,fixup_put_user_skip_2)\
 		ASM_EXCEPTIONTABLE_ENTRY(2b,fixup_put_user_skip_1)\
 		: "=r"(__pu_err)                            \
-		: "r"(ptr), "r"(hi), "r"(lo), "0"(__pu_err) \
+		: "r"(ptr), "r"(__val), "0"(__pu_err) \
 		: "r1");				    \
 } while (0)
 
-- 
1.8.0

