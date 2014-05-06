Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934245AbaEFHVM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 03:21:12 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:30344 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933838AbaEFHVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 03:21:05 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-b0-53688d5f1f3b
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: linux@arm.linux.org.uk
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>, stable@vger.kernel.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM PORT),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCHv2] arm: put_user: fix possible data corruption in put_user
Date: Tue, 06 May 2014 11:11:51 +0400
Message-id: <1399360312-13843-1-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <alpine.LFD.2.11.1405050950410.980@knanqh.ubzr>
References: <alpine.LFD.2.11.1405050950410.980@knanqh.ubzr>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFJMWRmVeSWpSXmKPExsVy+t/xq7rxvRnBBpuXslls+/WIzWLT42us
	Fpd3zWGzuH2Z1+LTs3/sFgs2PmK0ePnxBIsDu8eaeWsYPVqae9g87lzbw+axeUm9R9+WVYwe
	nzfJBbBFcdmkpOZklqUW6dslcGX8XNvMWvCfq2Lmkk2MDYxfOLoYOTkkBEwktp//wQhhi0lc
	uLeerYuRi0NIYCmjxJLXbVBOD5PE+s99YFVsAnoS/2ZtZwOxRQSkJGbsXMoOUsQs0MgksfLt
	bLAiYQEviVd/H7CA2CwCqhKL1/4Gs3kF3CRmv37FCrFOQWLZ8plgNqeAjcTWb/1MILaQgLXE
	t1+trBMYeRcwMqxiFE0tTS4oTkrPNdIrTswtLs1L10vOz93ECAmvrzsYlx6zOsQowMGoxMO7
	QCYjWIg1say4MvcQowQHs5IIb30+UIg3JbGyKrUoP76oNCe1+BAjEwenVAOjw6ygHsUMhnVX
	gr7GZq+8pzv7lPlbk9f7fm000Ft09cD9+zuW35NZN8ezxUshS9h2sfxKpR3XM//82nj+Alvf
	ylsTw+pi5l99cqSrqtf6+DIrow+bnzpNC/JJLwuMSr+ltfXXJMZ7DVcdD4tO0l73Ktr8Xr6b
	5XRZ35ZdL+X/2VyfFfgoau+tlUosxRmJhlrMRcWJAItoSNwNAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to arm procedure call standart r2 register is call-cloberred.
So after the result of x expression was put into r2 any following
function call in p may overwrite r2. To fix this, the result of p
expression must be saved to the temporary variable before the
assigment x expression to __r2.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
Reviewed-by: Nicolas Pitre <nico@linaro.org>
Cc: stable@vger.kernel.org
---
Since v1:
 - tmp_p variable renamed to __tmp_p
 - added Reviewed-by tag
 - added Cc: stable@vger.kernel.org

 arch/arm/include/asm/uaccess.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/uaccess.h b/arch/arm/include/asm/uaccess.h
index 12c3a5d..75d9579 100644
--- a/arch/arm/include/asm/uaccess.h
+++ b/arch/arm/include/asm/uaccess.h
@@ -171,8 +171,9 @@ extern int __put_user_8(void *, unsigned long long);
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
1.8.5.5

