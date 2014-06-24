Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565AbaFXUct (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 16:32:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47794 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200AbaFXUcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 16:32:47 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 48/65] ARM: 8051/1: put_user: fix possible data corruption in put_user
Date: Tue, 24 Jun 2014 13:30:08 -0700
Message-Id: <1403641825-12825-49-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403641825-12825-1-git-send-email-kamal@canonical.com>
References: <1403641825-12825-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.25 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrey Ryabinin <a.ryabinin@samsung.com>

commit 537094b64b229bf3ad146042f83e74cf6abe59df upstream.

According to arm procedure call standart r2 register is call-cloberred.
So after the result of x expression was put into r2 any following
function call in p may overwrite r2. To fix this, the result of p
expression must be saved to the temporary variable before the
assigment x expression to __r2.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
Reviewed-by: Nicolas Pitre <nico@linaro.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/include/asm/uaccess.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/uaccess.h b/arch/arm/include/asm/uaccess.h
index 7e1f760..20e1c99 100644
--- a/arch/arm/include/asm/uaccess.h
+++ b/arch/arm/include/asm/uaccess.h
@@ -164,8 +164,9 @@ extern int __put_user_8(void *, unsigned long long);
 #define __put_user_check(x,p)							\
 	({								\
 		unsigned long __limit = current_thread_info()->addr_limit - 1; \
+		const typeof(*(p)) __user *__tmp_p = (p);		\
 		register const typeof(*(p)) __r2 asm("r2") = (x);	\
-		register const typeof(*(p)) __user *__p asm("r0") = (p);\
+		register const typeof(*(p)) __user *__p asm("r0") = __tmp_p; \
 		register unsigned long __l asm("r1") = __limit;		\
 		register int __e asm("r0");				\
 		switch (sizeof(*(__p))) {				\
-- 
1.9.1

