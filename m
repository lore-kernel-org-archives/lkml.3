Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357AbbALSga (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:36:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58431 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755264AbbALSay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:30:54 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: John David Anglin <dave.anglin@bell.net>, Helge Deller <deller@gmx.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 197/216] parisc: fix out-of-register compiler error in ldcw inline assembler function
Date: Mon, 12 Jan 2015 18:29:35 +0000
Message-Id: <1421087394-2712-85-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: John David Anglin <dave.anglin@bell.net>

commit 45db07382a5c78b0c43b3b0002b63757fb60e873 upstream.

The __ldcw macro has a problem when its argument needs to be reloaded from
memory. The output memory operand and the input register operand both need to
be reloaded using a register in class R1_REGS when generating 64-bit code.
This fails because there's only a single register in the class. Instead, use a
memory clobber. This also makes the __ldcw macro a compiler memory barrier.

Signed-off-by: John David Anglin <dave.anglin@bell.net>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/parisc/include/asm/ldcw.h | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/parisc/include/asm/ldcw.h b/arch/parisc/include/asm/ldcw.h
index d2d11b7055ba..8121aa6db2ff 100644
--- a/arch/parisc/include/asm/ldcw.h
+++ b/arch/parisc/include/asm/ldcw.h
@@ -33,11 +33,18 @@
 
 #endif /*!CONFIG_PA20*/
 
-/* LDCW, the only atomic read-write operation PA-RISC has. *sigh*.  */
+/* LDCW, the only atomic read-write operation PA-RISC has. *sigh*.
+   We don't explicitly expose that "*a" may be written as reload
+   fails to find a register in class R1_REGS when "a" needs to be
+   reloaded when generating 64-bit PIC code.  Instead, we clobber
+   memory to indicate to the compiler that the assembly code reads
+   or writes to items other than those listed in the input and output
+   operands.  This may pessimize the code somewhat but __ldcw is
+   usually used within code blocks surrounded by memory barriors.  */
 #define __ldcw(a) ({						\
 	unsigned __ret;						\
-	__asm__ __volatile__(__LDCW " 0(%2),%0"			\
-		: "=r" (__ret), "+m" (*(a)) : "r" (a));		\
+	__asm__ __volatile__(__LDCW " 0(%1),%0"			\
+		: "=r" (__ret) : "r" (a) : "memory");		\
 	__ret;							\
 })
 
-- 
2.1.4

