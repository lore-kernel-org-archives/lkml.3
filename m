Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233AbbAYSob (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:44:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57892 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832AbbAYSKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:10 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        John David Anglin <dave.anglin@bell.net>, Helge Deller <deller@gmx.de>
Subject: [PATCH 3.18 097/183] parisc: fix out-of-register compiler error in ldcw inline assembler function
Date: Sun, 25 Jan 2015 10:06:59 -0800
Message-Id: <20150125180814.373812164@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/parisc/include/asm/ldcw.h |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

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
 


