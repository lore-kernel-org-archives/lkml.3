Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752Ab3H2RPg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 13:15:36 -0400
Received: from mout.gmx.net ([212.227.15.18]:58481 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755686Ab3H2RPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 13:15:35 -0400
From: dl9pf@gmx.de
To: linux-kernel@vger.kernel.org
Cc: dl9pf@gmx.de, x86@kernel.org, hpa@zytor.com, pageexec@freemail.hu,
        llvmlinux@lists.linuxfoundation.org, behanw@converseincode.com
Subject: [PATCH] [RFC] [X86] Fix a compilation issue with clang.
Date: Thu, 29 Aug 2013 19:13:48 +0200
Message-Id: <1377796428-12719-1-git-send-email-dl9pf@gmx.de>
X-Mailer: git-send-email 1.8.1.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:U2dTw71IbwQjLXSc8QMsDNKfqKYBlQSODiVwFq8TYz7QSCH7zgm
 sD1gM6qyK8mRxMu5cBpUTGvsuwXdvOcZKVWGjhLjzom7p6vz4NlPt3BDa1t4l+kumj9i/VP
 NZI1B8N9LRECs4tzuf2qYc2NX6uRPu+9apNgUWjSA8WI2+nc2bmjpCKrv8Mpid5fLBC4b02
 2rCp2+bx8STvAbOawZ5KQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan-Simon Möller <dl9pf@gmx.de>

Clang does not support the "shortcut" we're taking here for gcc (see below).
The patch extends and uses the macro _ASM_DX to do the job.

>From arch/x86/include/asm/uaccess.h:
/*
 * Careful: we have to cast the result to the type of the pointer
 * for sign reasons.
 *
 * The use of %edx as the register specifier is a bit of a
 * simplification, as gcc only cares about it as the starting point
 * and not size: for a 64-bit value it will use %ecx:%edx on 32 bits
 * (%ecx being the next register in gcc's x86 register sequence), and
 * %rdx on 64 bits.
 */

Signed-off-by: Jan-Simon Möller <dl9pf@gmx.de>
CC: pageexec@freemail.hu
CC: llvmlinux@lists.linuxfoundation.org
CC: behanw@converseincode.com
---
 arch/x86/include/asm/asm.h     | 6 +++++-
 arch/x86/include/asm/uaccess.h | 2 +-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/asm.h b/arch/x86/include/asm/asm.h
index 1c2d247..4582e8e 100644
--- a/arch/x86/include/asm/asm.h
+++ b/arch/x86/include/asm/asm.h
@@ -3,21 +3,25 @@
 
 #ifdef __ASSEMBLY__
 # define __ASM_FORM(x)	x
+# define __ASM_FORM_RAW(x)     x
 # define __ASM_FORM_COMMA(x) x,
 #else
 # define __ASM_FORM(x)	" " #x " "
+# define __ASM_FORM_RAW(x)     #x
 # define __ASM_FORM_COMMA(x) " " #x ","
 #endif
 
 #ifdef CONFIG_X86_32
 # define __ASM_SEL(a,b) __ASM_FORM(a)
+# define __ASM_SEL_RAW(a,b) __ASM_FORM_RAW(a)
 #else
 # define __ASM_SEL(a,b) __ASM_FORM(b)
+# define __ASM_SEL_RAW(a,b) __ASM_FORM_RAW(b)
 #endif
 
 #define __ASM_SIZE(inst, ...)	__ASM_SEL(inst##l##__VA_ARGS__, \
 					  inst##q##__VA_ARGS__)
-#define __ASM_REG(reg)		__ASM_SEL(e##reg, r##reg)
+#define __ASM_REG(reg)         __ASM_SEL_RAW(e##reg, r##reg)
 
 #define _ASM_PTR	__ASM_SEL(.long, .quad)
 #define _ASM_ALIGN	__ASM_SEL(.balign 4, .balign 8)
diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 8fa3bd6..32432d1 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -163,7 +163,7 @@ __typeof__(__builtin_choose_expr(sizeof(x) > sizeof(0UL), 0ULL, 0UL))
 #define get_user(x, ptr)						\
 ({									\
 	int __ret_gu;							\
-	register __inttype(*(ptr)) __val_gu asm("%edx");		\
+	register __inttype(*(ptr)) __val_gu asm("%"_ASM_DX);		\
 	__chk_user_ptr(ptr);						\
 	might_fault();							\
 	asm volatile("call __get_user_%P3"				\
-- 
1.8.1.4

