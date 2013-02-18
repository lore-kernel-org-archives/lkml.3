Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288Ab3BRLhB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 06:37:01 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:33164 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab3BRLg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 06:36:59 -0500
From: Afzal Mohammed <afzal@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Russell King <linux@arm.linux.org.uk>, Tony Lindgren <tony@atomide.com>,
        Marc Zyngier <marc.zyngier@arm.com>, Nicolas Pitre <nico@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Will Deacon <will.deacon@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>, Sekhar Nori <nsekhar@ti.com>,
        Syed Mohammed Khasim <khasim@ti.com>
Subject: [PATCH, RFC 1/8] ARM: localtimer: return percpu clkevt on register
Date: Mon, 18 Feb 2013 17:06:39 +0530
Message-ID: <e7cbb10903841ba23a93f71e7a06ae34a43adc70.1361186097.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <cover.1361186097.git.afzal@ti.com>
References: <cover.1361186097.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return percpu clock event on local timer register. It is the boot cpu
that calls this and it can use the returned percpu clock event to
register a clock event in the case of SMP configuration with one core.
This helps to have a booting Kernel even if no other timer is
registered for clock tick.

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---
 arch/arm/include/asm/localtimer.h | 7 ++++---
 arch/arm/kernel/smp.c             | 8 ++++----
 arch/arm/kernel/smp_twd.c         | 5 +++--
 3 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/arch/arm/include/asm/localtimer.h b/arch/arm/include/asm/localtimer.h
index f77ffc1..c3f89c0 100644
--- a/arch/arm/include/asm/localtimer.h
+++ b/arch/arm/include/asm/localtimer.h
@@ -23,11 +23,12 @@ struct local_timer_ops {
 /*
  * Register a local timer driver
  */
-int local_timer_register(struct local_timer_ops *);
+struct clock_event_device *local_timer_register(struct local_timer_ops *);
 #else
-static inline int local_timer_register(struct local_timer_ops *ops)
+static inline
+struct clock_event_device *local_timer_register(struct local_timer_ops *ops)
 {
-	return -ENXIO;
+	return ERR_PTR(-ENXIO);
 }
 #endif
 
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 5f73f70..42d95d6 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -491,16 +491,16 @@ static void __cpuinit broadcast_timer_setup(struct clock_event_device *evt)
 static struct local_timer_ops *lt_ops;
 
 #ifdef CONFIG_LOCAL_TIMERS
-int local_timer_register(struct local_timer_ops *ops)
+struct clock_event_device *local_timer_register(struct local_timer_ops *ops)
 {
 	if (!is_smp() || !setup_max_cpus)
-		return -ENXIO;
+		return ERR_PTR(-ENXIO);
 
 	if (lt_ops)
-		return -EBUSY;
+		return ERR_PTR(-EBUSY);
 
 	lt_ops = ops;
-	return 0;
+	return &per_cpu(percpu_clockevent, smp_processor_id());
 }
 #endif
 
diff --git a/arch/arm/kernel/smp_twd.c b/arch/arm/kernel/smp_twd.c
index c092115..616268c 100644
--- a/arch/arm/kernel/smp_twd.c
+++ b/arch/arm/kernel/smp_twd.c
@@ -315,6 +315,7 @@ static struct local_timer_ops twd_lt_ops __cpuinitdata = {
 static int __init twd_local_timer_common_register(struct device_node *np)
 {
 	int err;
+	struct clock_event_device *evt;
 
 	twd_evt = alloc_percpu(struct clock_event_device *);
 	if (!twd_evt) {
@@ -328,8 +329,8 @@ static int __init twd_local_timer_common_register(struct device_node *np)
 		goto out_free;
 	}
 
-	err = local_timer_register(&twd_lt_ops);
-	if (err)
+	evt = local_timer_register(&twd_lt_ops);
+	if (IS_ERR(evt))
 		goto out_irq;
 
 	twd_get_clock(np);
-- 
1.7.12

