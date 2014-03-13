Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360AbaCMUgY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 16:36:24 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57860 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755272AbaCMUgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 16:36:18 -0400
From: Joel Fernandes <joelf@ti.com>
To: Tony Lindgren <tony@atomide.com>, Rob Herring <robh@kernel.org>,
        Tero Kristo <t-kristo@ti.com>, Nishanth Menon <nm@ti.com>,
        Suman Anna <s-anna@ti.com>, Felipe Balbi <balbi@ti.com>
CC: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Joel Fernandes <joelf@ti.com>
Subject: [RFC 3/5] ARM: OMAP2+: timer: Add clocksource initialization and powerup support
Date: Thu, 13 Mar 2014 15:35:17 -0500
Message-ID: <1394742919-32163-4-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394742919-32163-1-git-send-email-joelf@ti.com>
References: <1394742919-32163-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a generic omap timer initialization function that can
be used by all SoCs for which support is available in the clocksource
driver introduced in the series.

The function will also be responsible for calling clock initialization
required for everything else to work.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 arch/arm/mach-omap2/common.h |    1 +
 arch/arm/mach-omap2/timer.c  |   28 ++++++++++++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/arch/arm/mach-omap2/common.h b/arch/arm/mach-omap2/common.h
index a6aae30..e58d9a4 100644
--- a/arch/arm/mach-omap2/common.h
+++ b/arch/arm/mach-omap2/common.h
@@ -92,6 +92,7 @@ extern void omap3_secure_sync32k_timer_init(void);
 extern void omap3_gptimer_timer_init(void);
 extern void omap4_local_timer_init(void);
 extern void omap5_realtime_timer_init(void);
+void omap_generic_timer_init(void);
 
 void omap2420_init_early(void);
 void omap2430_init_early(void);
diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
index 74044aa..08c73a0 100644
--- a/arch/arm/mach-omap2/timer.c
+++ b/arch/arm/mach-omap2/timer.c
@@ -324,6 +324,25 @@ static int __init omap_dm_timer_init_one(struct omap_dm_timer *timer,
 	return r;
 }
 
+int __init omap_dmtimer_powerup(struct omap_dm_timer *timer,
+					struct device_node *np) {
+	struct omap_hwmod *oh;
+	const char *oh_name = NULL;
+
+	of_property_read_string_index(np, "ti,hwmods", 0, &oh_name);
+	if (!oh_name)
+		return -ENODEV;
+
+	oh = omap_hwmod_lookup(oh_name);
+	if (!oh)
+		return -ENODEV;
+
+	omap_hwmod_setup_one(oh_name);
+
+	omap_hwmod_enable(oh);
+	return 0;
+}
+
 static void __init omap2_gp_clockevent_init(int gptimer_id,
 						const char *fck_source,
 						const char *property)
@@ -615,6 +634,15 @@ static OMAP_SYS_32K_TIMER_INIT(4, 1, "timer_32k_ck", "ti,timer-alwon",
 			       2, "sys_clkin_ck", NULL);
 #endif
 
+void omap_generic_timer_init(void)
+{
+	if (!of_have_populated_dt())
+		BUG_ON("Generic timer init should only be used for DT boot\n");
+
+	omap_clk_init();
+	clocksource_of_init();
+}
+
 #ifdef CONFIG_ARCH_OMAP4
 #ifdef CONFIG_HAVE_ARM_TWD
 static DEFINE_TWD_LOCAL_TIMER(twd_local_timer, OMAP44XX_LOCAL_TWD_BASE, 29);
-- 
1.7.9.5

