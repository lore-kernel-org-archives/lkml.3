Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933019Ab3DLWzS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 18:55:18 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:32792 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758748Ab3DLWzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 18:55:12 -0400
From: Nishanth Menon <nm@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, Paul Walmsley <paul@pwsan.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Mike Turquette <mturquette@linaro.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH V4 5/6] ARM: OMAP2+: AM33XX: add lateinit hook for calling pm late init
Date: Fri, 12 Apr 2013 17:54:37 -0500
Message-ID: <1365807278-554-6-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365807278-554-1-git-send-email-nm@ti.com>
References: <1365807278-554-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call OMAP2+ generic lateinit hook from AM specific late init hook.
This allows the generic late initializations such as cpufreq hooks
to be active.

Cc: Benoit Cousson <b-cousson@ti.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Paul Walmsley <paul@pwsan.com>
Cc: Tony Lindgren <tony@atomide.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
---
Introduced as a result of alignment in http://marc.info/?t=136450773400004&r=1&w=2
previous versions do not use this approach.

[Probably belongs to Kevin/Tony's tree?]
 arch/arm/mach-omap2/board-generic.c |    1 +
 arch/arm/mach-omap2/common.h        |    1 +
 arch/arm/mach-omap2/io.c            |    6 ++++++
 3 files changed, 8 insertions(+)

diff --git a/arch/arm/mach-omap2/board-generic.c b/arch/arm/mach-omap2/board-generic.c
index afa509a..86e8479 100644
--- a/arch/arm/mach-omap2/board-generic.c
+++ b/arch/arm/mach-omap2/board-generic.c
@@ -141,6 +141,7 @@ DT_MACHINE_START(AM33XX_DT, "Generic AM33XX (Flattened Device Tree)")
 	.init_irq	= omap_intc_of_init,
 	.handle_irq	= omap3_intc_handle_irq,
 	.init_machine	= omap_generic_init,
+	.init_late	= am33xx_init_late,
 	.init_time	= omap3_am33xx_gptimer_timer_init,
 	.dt_compat	= am33xx_boards_compat,
 	.restart	= am33xx_restart,
diff --git a/arch/arm/mach-omap2/common.h b/arch/arm/mach-omap2/common.h
index 14522d0..65f2ebc 100644
--- a/arch/arm/mach-omap2/common.h
+++ b/arch/arm/mach-omap2/common.h
@@ -108,6 +108,7 @@ void omap35xx_init_late(void);
 void omap3630_init_late(void);
 void am35xx_init_late(void);
 void ti81xx_init_late(void);
+void am33xx_init_late(void);
 int omap2_common_pm_late_init(void);
 
 #if defined(CONFIG_SOC_OMAP2420) || defined(CONFIG_SOC_OMAP2430)
diff --git a/arch/arm/mach-omap2/io.c b/arch/arm/mach-omap2/io.c
index 5c445ca..61f5b84 100644
--- a/arch/arm/mach-omap2/io.c
+++ b/arch/arm/mach-omap2/io.c
@@ -576,6 +576,12 @@ void __init am33xx_init_early(void)
 	omap_hwmod_init_postsetup();
 	omap_clk_init = am33xx_clk_init;
 }
+
+void __init am33xx_init_late(void)
+{
+	omap2_common_pm_late_init();
+}
+
 #endif
 
 #ifdef CONFIG_ARCH_OMAP4
-- 
1.7.9.5

