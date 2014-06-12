Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200AbaFLP7K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 11:59:10 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:3298 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088AbaFLP7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 11:59:06 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 12 Jun 2014 08:53:47 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: [PATCH v2 3/3] clocksource: tegra: Use us counter as delay timer
Date: Thu, 12 Jun 2014 18:58:29 +0300
Message-ID: <1402588713-18766-4-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1402588713-18766-1-git-send-email-pdeschrijver@nvidia.com>
References: <1402588713-18766-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All Tegra SoCs have a freerunning microsecond counter which can be used as a
delay timer.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clocksource/tegra20_timer.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/clocksource/tegra20_timer.c b/drivers/clocksource/tegra20_timer.c
index d1869f0..d2616ef 100644
--- a/drivers/clocksource/tegra20_timer.c
+++ b/drivers/clocksource/tegra20_timer.c
@@ -27,6 +27,7 @@
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
 #include <linux/sched_clock.h>
+#include <linux/delay.h>
 
 #include <asm/mach/time.h>
 #include <asm/smp_twd.h>
@@ -53,6 +54,8 @@ static void __iomem *rtc_base;
 static struct timespec persistent_ts;
 static u64 persistent_ms, last_persistent_ms;
 
+static struct delay_timer tegra_delay_timer;
+
 #define timer_writel(value, reg) \
 	__raw_writel(value, timer_reg_base + (reg))
 #define timer_readl(reg) \
@@ -139,6 +142,11 @@ static void tegra_read_persistent_clock(struct timespec *ts)
 	*ts = *tsp;
 }
 
+static unsigned long tegra_delay_timer_read_counter_long(void)
+{
+	return readl(timer_reg_base + TIMERUS_CNTR_1US);
+}
+
 static irqreturn_t tegra_timer_interrupt(int irq, void *dev_id)
 {
 	struct clock_event_device *evt = (struct clock_event_device *)dev_id;
@@ -206,6 +214,11 @@ static void __init tegra20_init_timer(struct device_node *np)
 		BUG();
 	}
 
+	tegra_delay_timer.read_current_timer =
+			tegra_delay_timer_read_counter_long;
+	tegra_delay_timer.freq = 1000000;
+	register_current_timer_delay(&tegra_delay_timer);
+
 	ret = setup_irq(tegra_timer_irq.irq, &tegra_timer_irq);
 	if (ret) {
 		pr_err("Failed to register timer IRQ: %d\n", ret);
-- 
1.7.7.rc0.72.g4b5ea.dirty

