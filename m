Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822AbaBGQVL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 11:21:11 -0500
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:51493 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752144AbaBGQVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 11:21:08 -0500
From: Fabrice GASNIER <fabrice.gasnier@st.com>
To: linux@arm.linux.org.uk, u.kleine-koenig@pengutronix.de,
        jonathan.austin@arm.com, catalin.marinas@arm.com, will.deacon@arm.com,
        nico@linaro.org, sboyd@codeaurora.org, marc.zyngier@arm.com,
        ben.dooks@codethink.co.uk, vgupta@synopsys.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: maxime.coquelin@st.com
Subject: [RFC PATCH] ARM: Add imprecise abort enable/disable macro
Date: Fri,  7 Feb 2014 17:19:15 +0100
Message-Id: <1391789955-26927-2-git-send-email-fabrice.gasnier@st.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391789955-26927-1-git-send-email-fabrice.gasnier@st.com>
References: <1391789955-26927-1-git-send-email-fabrice.gasnier@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds imprecise abort enable/disable macros.
It also enables imprecise aborts when starting kernel.

Signed-off-by: Fabrice Gasnier <fabrice.gasnier@st.com>
---
 arch/arm/include/asm/irqflags.h |   33 +++++++++++++++++++++++++++++++++
 arch/arm/kernel/smp.c           |    1 +
 arch/arm/kernel/traps.c         |    4 ++++
 3 files changed, 38 insertions(+)

diff --git a/arch/arm/include/asm/irqflags.h b/arch/arm/include/asm/irqflags.h
index 3b763d6..82e3834 100644
--- a/arch/arm/include/asm/irqflags.h
+++ b/arch/arm/include/asm/irqflags.h
@@ -51,6 +51,9 @@ static inline void arch_local_irq_disable(void)
 
 #define local_fiq_enable()  __asm__("cpsie f	@ __stf" : : : "memory", "cc")
 #define local_fiq_disable() __asm__("cpsid f	@ __clf" : : : "memory", "cc")
+
+#define local_abt_enable()  __asm__("cpsie a	@ __sta" : : : "memory", "cc")
+#define local_abt_disable() __asm__("cpsid a	@ __cla" : : : "memory", "cc")
 #else
 
 /*
@@ -130,6 +133,36 @@ static inline void arch_local_irq_disable(void)
 	: "memory", "cc");					\
 	})
 
+/*
+ * Enable Aborts
+ */
+#define local_abt_enable()					\
+	({							\
+		unsigned long temp;				\
+	__asm__ __volatile__(					\
+	"mrs	%0, cpsr		@ sta\n"		\
+"	bic	%0, %0, %1\n"					\
+"	msr	cpsr_c, %0"					\
+	: "=r" (temp)						\
+	: "r" (PSR_A_BIT)					\
+	: "memory", "cc");					\
+	})
+
+/*
+ * Disable Aborts
+ */
+#define local_abt_disable()					\
+	({							\
+		unsigned long temp;				\
+	__asm__ __volatile__(					\
+	"mrs	%0, cpsr		@ cla\n"		\
+"	orr	%0, %0, %1\n"					\
+"	msr	cpsr_c, %0"					\
+	: "=r" (temp)						\
+	: "r" (PSR_A_BIT)					\
+	: "memory", "cc");					\
+	})
+
 #endif
 
 /*
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index dc894ab..c2093cb 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -377,6 +377,7 @@ asmlinkage void secondary_start_kernel(void)
 
 	local_irq_enable();
 	local_fiq_enable();
+	local_abt_enable();
 
 	/*
 	 * OK, it's off to the idle thread for us
diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index 4636d56..ef15709 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -900,6 +900,10 @@ void __init early_trap_init(void *vectors_base)
 
 	flush_icache_range(vectors, vectors + PAGE_SIZE * 2);
 	modify_domain(DOMAIN_USER, DOMAIN_CLIENT);
+
+	/* Enable imprecise aborts */
+	local_abt_enable();
+
 #else /* ifndef CONFIG_CPU_V7M */
 	/*
 	 * on V7-M there is no need to copy the vector table to a dedicated
-- 
1.7.9.5

