Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062AbaIFAIB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 20:08:01 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:40533 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbaIFAHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 20:07:01 -0400
From: behanw@converseincode.com
To: a.ryabinin@samsung.com, anurag19aggarwal@gmail.com, charlebm@gmail.com,
        cl@linux-foundation.org, dave.long@linaro.org,
        k.khlebnikov@samsung.com, linux@arm.linux.org.uk,
        linyongting@gmail.com, Nikolay.Borisov@arm.com, tglx@linutronix.de,
        tj@kernel.org, u.kleine-koenig@pengutronix.de
Cc: behanw@converseincode.com, Dave.Martin@arm.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        rabin@rab.in, rostedt@goodmis.org, rric@kernel.org,
        will.deacon@arm.com
Subject: [PATCH v2 7/7] arm: LLVMLinux: Use global stack register variable for percpu
Date: Fri,  5 Sep 2014 17:06:17 -0700
Message-Id: <1409961977-11762-8-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409961977-11762-1-git-send-email-behanw@converseincode.com>
References: <1409961977-11762-1-git-send-email-behanw@converseincode.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Charlebois <charlebm@gmail.com>

Using global current_stack_pointer works on both clang and gcc.
current_stack_pointer is an unsigned long and needs to be cast
as a pointer to dereference.

Signed-off-by: Mark Charlebois <charlebm@gmail.com>
---
 arch/arm/include/asm/percpu.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/percpu.h b/arch/arm/include/asm/percpu.h
index 209e650..a89b407 100644
--- a/arch/arm/include/asm/percpu.h
+++ b/arch/arm/include/asm/percpu.h
@@ -30,14 +30,14 @@ static inline void set_my_cpu_offset(unsigned long off)
 static inline unsigned long __my_cpu_offset(void)
 {
 	unsigned long off;
-	register unsigned long *sp asm ("sp");
 
 	/*
 	 * Read TPIDRPRW.
 	 * We want to allow caching the value, so avoid using volatile and
 	 * instead use a fake stack read to hazard against barrier().
 	 */
-	asm("mrc p15, 0, %0, c13, c0, 4" : "=r" (off) : "Q" (*sp));
+	asm("mrc p15, 0, %0, c13, c0, 4" : "=r" (off)
+		: "Q" (*(const unsigned long *)current_stack_pointer));
 
 	return off;
 }
-- 
1.9.1

