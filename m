Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161454Ab3LFNBP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:01:15 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43881 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161437Ab3LFNBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:01:11 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 075/272] ARM: at91: fix hanged boot due to early rtt-interrupt
Date: Fri,  6 Dec 2013 12:56:04 +0000
Message-Id: <1386334761-25517-76-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 94c4c79f2f1acca6e69a50bff5a7d9027509c16b upstream.

Make sure the RTT-interrupts are masked at boot by adding a new helper
function to be used at SOC-init.

This fixes hanged boot on all AT91 SOCs with an RTT, for example, if an
RTT-alarm goes off after a non-clean shutdown (e.g. when using RTC
wakeup).

The RTC and RTT-peripherals are powered by backup power (VDDBU) (on all
AT91 SOCs but RM9200) and are not reset on wake-up, user, watchdog or
software reset. This means that their interrupts may be enabled during
early boot if, for example, they where not disabled during a previous
shutdown (e.g. due to a buggy driver or a non-clean shutdown such as a
user reset). Furthermore, an RTC or RTT-alarm may also be active.

The RTC and RTT-interrupts use the shared system-interrupt line, which
is also used by the PIT, and if an interrupt occurs before a handler
(e.g. RTC-driver) has been installed this leads to the system interrupt
being disabled and prevents the system from booting.

Note that when boot hangs due to an early RTC or RTT-interrupt, the only
way to get the system to start again is to remove the backup power (e.g.
battery) or to disable the interrupt manually from the bootloader. In
particular, a user reset is not sufficient.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/mach-at91/at91sam9260.c |  2 ++
 arch/arm/mach-at91/at91sam9261.c |  2 ++
 arch/arm/mach-at91/at91sam9263.c |  3 +++
 arch/arm/mach-at91/at91sam9g45.c |  1 +
 arch/arm/mach-at91/at91sam9rl.c  |  1 +
 arch/arm/mach-at91/generic.h     |  1 +
 arch/arm/mach-at91/sysirq_mask.c | 24 ++++++++++++++++++++++++
 7 files changed, 34 insertions(+)

diff --git a/arch/arm/mach-at91/at91sam9260.c b/arch/arm/mach-at91/at91sam9260.c
index 5de6074..ae10d14 100644
--- a/arch/arm/mach-at91/at91sam9260.c
+++ b/arch/arm/mach-at91/at91sam9260.c
@@ -349,6 +349,8 @@ static void __init at91sam9260_initialize(void)
 	arm_pm_idle = at91sam9_idle;
 	arm_pm_restart = at91sam9_alt_restart;
 
+	at91_sysirq_mask_rtt(AT91SAM9260_BASE_RTT);
+
 	/* Register GPIO subsystem */
 	at91_gpio_init(at91sam9260_gpio, 3);
 }
diff --git a/arch/arm/mach-at91/at91sam9261.c b/arch/arm/mach-at91/at91sam9261.c
index 0e07932..e761e74 100644
--- a/arch/arm/mach-at91/at91sam9261.c
+++ b/arch/arm/mach-at91/at91sam9261.c
@@ -291,6 +291,8 @@ static void __init at91sam9261_initialize(void)
 	arm_pm_idle = at91sam9_idle;
 	arm_pm_restart = at91sam9_alt_restart;
 
+	at91_sysirq_mask_rtt(AT91SAM9261_BASE_RTT);
+
 	/* Register GPIO subsystem */
 	at91_gpio_init(at91sam9261_gpio, 3);
 }
diff --git a/arch/arm/mach-at91/at91sam9263.c b/arch/arm/mach-at91/at91sam9263.c
index 6ce7d18..e6fed62 100644
--- a/arch/arm/mach-at91/at91sam9263.c
+++ b/arch/arm/mach-at91/at91sam9263.c
@@ -328,6 +328,9 @@ static void __init at91sam9263_initialize(void)
 	arm_pm_idle = at91sam9_idle;
 	arm_pm_restart = at91sam9_alt_restart;
 
+	at91_sysirq_mask_rtt(AT91SAM9263_BASE_RTT0);
+	at91_sysirq_mask_rtt(AT91SAM9263_BASE_RTT1);
+
 	/* Register GPIO subsystem */
 	at91_gpio_init(at91sam9263_gpio, 5);
 }
diff --git a/arch/arm/mach-at91/at91sam9g45.c b/arch/arm/mach-at91/at91sam9g45.c
index ff662af..9f7a97c 100644
--- a/arch/arm/mach-at91/at91sam9g45.c
+++ b/arch/arm/mach-at91/at91sam9g45.c
@@ -378,6 +378,7 @@ static void __init at91sam9g45_initialize(void)
 	arm_pm_restart = at91sam9g45_restart;
 
 	at91_sysirq_mask_rtc(AT91SAM9G45_BASE_RTC);
+	at91_sysirq_mask_rtt(AT91SAM9G45_BASE_RTT);
 
 	/* Register GPIO subsystem */
 	at91_gpio_init(at91sam9g45_gpio, 5);
diff --git a/arch/arm/mach-at91/at91sam9rl.c b/arch/arm/mach-at91/at91sam9rl.c
index b5a8c9d..301e172 100644
--- a/arch/arm/mach-at91/at91sam9rl.c
+++ b/arch/arm/mach-at91/at91sam9rl.c
@@ -295,6 +295,7 @@ static void __init at91sam9rl_initialize(void)
 	arm_pm_restart = at91sam9_alt_restart;
 
 	at91_sysirq_mask_rtc(AT91SAM9RL_BASE_RTC);
+	at91_sysirq_mask_rtt(AT91SAM9RL_BASE_RTT);
 
 	/* Register GPIO subsystem */
 	at91_gpio_init(at91sam9rl_gpio, 4);
diff --git a/arch/arm/mach-at91/generic.h b/arch/arm/mach-at91/generic.h
index 80269bd..26dee3c 100644
--- a/arch/arm/mach-at91/generic.h
+++ b/arch/arm/mach-at91/generic.h
@@ -35,6 +35,7 @@ extern int  __init at91_aic_of_init(struct device_node *node,
 extern int  __init at91_aic5_of_init(struct device_node *node,
 				    struct device_node *parent);
 extern void __init at91_sysirq_mask_rtc(u32 rtc_base);
+extern void __init at91_sysirq_mask_rtt(u32 rtt_base);
 
 
  /* Timer */
diff --git a/arch/arm/mach-at91/sysirq_mask.c b/arch/arm/mach-at91/sysirq_mask.c
index ee3e22c..2ba694f 100644
--- a/arch/arm/mach-at91/sysirq_mask.c
+++ b/arch/arm/mach-at91/sysirq_mask.c
@@ -21,6 +21,7 @@
  */
 
 #include <linux/io.h>
+#include <mach/at91_rtt.h>
 
 #include "generic.h"
 
@@ -45,3 +46,26 @@ void __init at91_sysirq_mask_rtc(u32 rtc_base)
 
 	iounmap(base);
 }
+
+void __init at91_sysirq_mask_rtt(u32 rtt_base)
+{
+	void __iomem *base;
+	void __iomem *reg;
+	u32 mode;
+
+	base = ioremap(rtt_base, 16);
+	if (!base)
+		return;
+
+	reg = base + AT91_RTT_MR;
+
+	mode = readl_relaxed(reg);
+	if (mode & (AT91_RTT_ALMIEN | AT91_RTT_RTTINCIEN)) {
+		pr_info("AT91: Disabling rtt irq\n");
+		mode &= ~(AT91_RTT_ALMIEN | AT91_RTT_RTTINCIEN);
+		writel_relaxed(mode, reg);
+		(void)readl_relaxed(reg);			/* flush */
+	}
+
+	iounmap(base);
+}
-- 
1.8.3.2

