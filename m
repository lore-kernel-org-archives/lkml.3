Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760644Ab3DCNL3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 09:11:29 -0400
Received: from mail.abilis.ch ([195.70.19.74]:12204 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758611Ab3DCNL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 09:11:28 -0400
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Christian Ruppert <christian.ruppert@abilis.com>
Subject: [RFC] Add implicit barriers to irqsave/restore class of functions
Date: Wed,  3 Apr 2013 15:10:22 +0200
Message-Id: <1364994622-14110-1-git-send-email-christian.ruppert@abilis.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20130403130340.GA13826@ab42.lan>
References: <20130403130340.GA13826@ab42.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds implicit memory barriers to irqsave/restore functions of
the ARC architecture port in line with what is done in other architectures.

It seems to fix several seemingly unrelated issues in our platform but for
the moment it is insufficiently tested (and might even be incomplete).
Please comment.

Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
---
 arch/arc/include/asm/irqflags.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arc/include/asm/irqflags.h b/arch/arc/include/asm/irqflags.h
index ccd8480..c8147d1 100644
--- a/arch/arc/include/asm/irqflags.h
+++ b/arch/arc/include/asm/irqflags.h
@@ -39,7 +39,7 @@ static inline long arch_local_irq_save(void)
 	"	flag.nz %0		\n"
 	: "=r"(temp), "=r"(flags)
 	: "n"((STATUS_E1_MASK | STATUS_E2_MASK))
-	: "cc");
+	: "memory", "cc");
 
 	return flags;
 }
@@ -53,7 +53,7 @@ static inline void arch_local_irq_restore(unsigned long flags)
 	__asm__ __volatile__(
 	"	flag %0			\n"
 	:
-	: "r"(flags));
+	: "r"(flags) : "memory");
 }
 
 /*
@@ -73,7 +73,7 @@ static inline void arch_local_irq_disable(void)
 	"	and %0, %0, %1		\n"
 	"	flag %0			\n"
 	: "=&r"(temp)
-	: "n"(~(STATUS_E1_MASK | STATUS_E2_MASK)));
+	: "n"(~(STATUS_E1_MASK | STATUS_E2_MASK)) : "memory");
 }
 
 /*
@@ -85,7 +85,7 @@ static inline long arch_local_save_flags(void)
 
 	__asm__ __volatile__(
 	"	lr  %0, [status32]	\n"
-	: "=&r"(temp));
+	: "=&r"(temp) : : "memory");
 
 	return temp;
 }
-- 
1.7.1

