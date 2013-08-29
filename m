Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915Ab3H2TP1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 15:15:27 -0400
Received: from mout.gmx.net ([212.227.15.18]:54952 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756852Ab3H2TPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 15:15:11 -0400
From: dl9pf@gmx.de
To: dl9pf@gmx.de
Cc: pageexec@freemail.hu, llvmlinux@lists.linuxfoundation.org,
        behanw@converseincode.com, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] [X86] Fix a compilation issue with clang.
Date: Thu, 29 Aug 2013 21:13:05 +0200
Message-Id: <1377803585-5913-3-git-send-email-dl9pf@gmx.de>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1377803585-5913-1-git-send-email-dl9pf@gmx.de>
References: <1563930.LeGpPqNO9R@aragorn.auenland.lan>
 <1377803585-5913-1-git-send-email-dl9pf@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:yPMlhQfnWcCzbXDxk+hV/0BSaCqKJW6i/b+Fmjr3/hvveVlqMtL
 BB6ILCCHvrZ6+4nGbGjaqmCm+jGqHS9oGstegvl23xH2L/CfIwIt2q4PtzafNhfud9SqrCr
 tI/abwkTlbdLejMju57U0ggJvlUOPSmS9CRQ0c4E8IN/jleg6ERVzDMXsS5Ol5BaZJtXhGz
 GgY9d/PamLbIag9upvnBA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan-Simon Möller <dl9pf@gmx.de>

Clang does not support the "shortcut" we're taking here for gcc (see below).
The patch uses the macro _ASM_DX to do the job.

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
CC: hpa@zytor.com
CC: linux-kernel@vger.kernel.org
---
 arch/x86/include/asm/uaccess.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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

