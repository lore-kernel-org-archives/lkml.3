Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790Ab3DQKGq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 06:06:46 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40835 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754420Ab3DQKGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 06:06:45 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-parisc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH] parisc: uaccess: fix compiler warnings caused by __put_user casting
Date: Wed, 17 Apr 2013 11:06:26 +0100
Message-Id: <1366193186-24859-1-git-send-email-will.deacon@arm.com>
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
 arch/parisc/include/asm/uaccess.h | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/arch/parisc/include/asm/uaccess.h b/arch/parisc/include/asm/uaccess.h
index 4ba2c93..a95af07 100644
--- a/arch/parisc/include/asm/uaccess.h
+++ b/arch/parisc/include/asm/uaccess.h
@@ -181,30 +181,24 @@ struct exception_data {
 #if !defined(CONFIG_64BIT)
 
 #define __put_kernel_asm64(__val,ptr) do {		    \
-	u64 __val64 = (u64)(__val);			    \
-	u32 hi = (__val64) >> 32;			    \
-	u32 lo = (__val64) & 0xffffffff;		    \
 	__asm__ __volatile__ (				    \
-		"\n1:\tstw %2,0(%1)"			    \
-		"\n2:\tstw %3,4(%1)\n\t"		    \
+		"\n1:\tstw %R2,0(%1)"			    \
+		"\n2:\tstw %2,4(%1)\n\t"		    \
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
-		"\n1:\tstw %2,0(%%sr3,%1)"		    \
-		"\n2:\tstw %3,4(%%sr3,%1)\n\t"		    \
+		"\n1:\tstw %R2,0(%%sr3,%1)"		    \
+		"\n2:\tstw %2,4(%%sr3,%1)\n\t"		    \
 		ASM_EXCEPTIONTABLE_ENTRY(1b,fixup_put_user_skip_2)\
 		ASM_EXCEPTIONTABLE_ENTRY(2b,fixup_put_user_skip_1)\
 		: "=r"(__pu_err)                            \
-		: "r"(ptr), "r"(hi), "r"(lo), "0"(__pu_err) \
+		: "r"(ptr), "r"(__val), "0"(__pu_err) \
 		: "r1");				    \
 } while (0)
 
-- 
1.8.0

