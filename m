Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758117Ab3FUAhl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 20:37:41 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:47342 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422804Ab3FUAfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 20:35:53 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Kukjin Kim <kgene.kim@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Mark Brown <broonie@kernel.org>, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>,
        Benoit Cousson <benoit.cousson@linaro.org>,
        devicetree-discuss@lists.ozlabs.org,
        Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org,
        Marc Zyngier <marc.zyngier@arm.com>, Nicolas Pitre <nico@fluxnic.net>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will.deacon@arm.com>, Tomasz Figa <tomasz.figa@gmail.com>
Subject: [PATCH v6 4/8] ARM: Add .init_platform() callback to machine descriptor
Date: Fri, 21 Jun 2013 02:35:20 +0200
Message-Id: <1371774924-9224-5-git-send-email-tomasz.figa@gmail.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1371774924-9224-1-git-send-email-tomasz.figa@gmail.com>
References: <1371774924-9224-1-git-send-email-tomasz.figa@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most ARM platforms have parts that should be initialized as early as
possible, which usually means as soon as memory management (kmalloc,
ioremap) starts to work,

However, currently there is no appropriate callback in machine_desc
struct to use for such initialization and platforms tend to stuff things
up .init_irq() and .init_time() callbacks.

Since all the DT-based platforms are going towards generic IRQ and time
initialization (using irqchip_init and clocksource_of_init) and current
code assumes that if custom callbacks are not provided in machine_desc
then generic ones should be used, this problem has become a bit more
inconvenient.

This patch tries to solve this issue by introducing new callback called
.init_platform(), where any custom low level initialization of platform
can be done safely.

Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
---
 arch/arm/include/asm/mach/arch.h | 1 +
 arch/arm/kernel/irq.c            | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/arch/arm/include/asm/mach/arch.h b/arch/arm/include/asm/mach/arch.h
index 308ad7d..b2f4d11 100644
--- a/arch/arm/include/asm/mach/arch.h
+++ b/arch/arm/include/asm/mach/arch.h
@@ -46,6 +46,7 @@ struct machine_desc {
 	void			(*reserve)(void);/* reserve mem blocks	*/
 	void			(*map_io)(void);/* IO mapping function	*/
 	void			(*init_early)(void);
+	void			(*init_platform)(void);
 	void			(*init_irq)(void);
 	void			(*init_time)(void);
 	void			(*init_machine)(void);
diff --git a/arch/arm/kernel/irq.c b/arch/arm/kernel/irq.c
index 9723d17..61e2000 100644
--- a/arch/arm/kernel/irq.c
+++ b/arch/arm/kernel/irq.c
@@ -115,6 +115,9 @@ EXPORT_SYMBOL_GPL(set_irq_flags);
 
 void __init init_IRQ(void)
 {
+	if (machine_desc->init_platform)
+		machine_desc->init_platform();
+
 	if (IS_ENABLED(CONFIG_OF) && !machine_desc->init_irq)
 		irqchip_init();
 	else
-- 
1.8.2.1

