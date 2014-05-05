Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610AbaEEGSX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 02:18:23 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:42139 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473AbaEEGSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 02:18:22 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-55-53672d2bfa92
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: linux@arm.linux.org.uk
Cc: nicolas.pitre@linaro.org, will.deacon@arm.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: [PATCH] arm: put_user: fix possible data corruption in put_user
Date: Mon, 05 May 2014 10:13:58 +0400
Message-id: <1399270438-26181-1-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 1.8.3.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLJMWRmVeSWpSXmKPExsVy+t/xy7rauunBBnPfC1ts+/WIzWLT42us
	Fpd3zWGzuH2Z1+LTs3/sFi8/nmBxYPNYM28No0dLcw+bx51re9g8Ni+p9+jbsorR4/MmuQC2
	KC6blNSczLLUIn27BK6M1z+msBcc4Kxo2r+auYHxKnsXIyeHhICJxOWFLUwQtpjEhXvr2boY
	uTiEBJYySjxfuYQVwulhkljRuBqsg01AT+LfrO1sILaIgJTEjJ1L2UGKmAUWM0qseP2EGSQh
	LOAhceBDG1gDi4CqxNx3h8BsXgE3ifbPk9gg1ilILPuylnkCI/cCRoZVjKKppckFxUnpuUZ6
	xYm5xaV56XrJ+bmbGCFB8nUH49JjVocYBTgYlXh4PbxTgoVYE8uKK3MPMUpwMCuJ8M5iTA8W
	4k1JrKxKLcqPLyrNSS0+xMjEwSnVwNg5eb4XQ3TID36JG84nGLz9Sir0Wnbez9N9/Xk2n6rj
	worMGbWzH6xXt5F0e1bS8XlzdtumaVeu9BeLC4Qce/Bpja9H+MpXx0OcOF6tKLt0S+mH1lyx
	yR0C+p4rBS2EFYIyNes2h+5YIKaWMX3xrYfrvKMn9WzTfBB58kvXxi1+P5pD3svaeiuxFGck
	GmoxFxUnAgD+pw0r8AEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to arm procedure call standart r2 register is call-cloberred.
So after the result of x expression was put into r2 any following
function call in p may overwrite r2. To fix this, the result of p
expression must be saved to the temporary variable before the
assigment x expression to __r2.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 arch/arm/include/asm/uaccess.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/uaccess.h b/arch/arm/include/asm/uaccess.h
index 12c3a5d..4b584ac 100644
--- a/arch/arm/include/asm/uaccess.h
+++ b/arch/arm/include/asm/uaccess.h
@@ -171,8 +171,9 @@ extern int __put_user_8(void *, unsigned long long);
 #define __put_user_check(x,p)							\
 	({								\
 		unsigned long __limit = current_thread_info()->addr_limit - 1; \
+		const typeof(*(p)) __user *tmp_p = (p);			\
 		register const typeof(*(p)) __r2 asm("r2") = (x);	\
-		register const typeof(*(p)) __user *__p asm("r0") = (p);\
+		register const typeof(*(p)) __user *__p asm("r0") = tmp_p; \
 		register unsigned long __l asm("r1") = __limit;		\
 		register int __e asm("r0");				\
 		switch (sizeof(*(__p))) {				\
-- 
1.8.3.2

