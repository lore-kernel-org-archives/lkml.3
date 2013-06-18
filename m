Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933599Ab3FRRHL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 13:07:11 -0400
Received: from service87.mimecast.com ([91.220.42.44]:45999 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933173Ab3FRRHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 13:07:05 -0400
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Sudeep.KarkadaNagesha@arm.com, linux@arm.linux.org.uk,
        catalin.marinas@arm.com, will.deacon@arm.com, mark.rutland@arm.com,
        marc.zyngier@arm.com, tglx@linutronix.de,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
Subject: [PATCH 4/4] drivers: clocksource: add CPU PM notifier for ARM architected timer
Date: Tue, 18 Jun 2013 18:07:03 +0100
Message-Id: <1371575223-21702-5-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371575223-21702-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
References: <1371575223-21702-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-OriginalArrivalTime: 18 Jun 2013 17:07:02.0888 (UTC) FILETIME=[40AC7E80:01CE6C46]
X-MC-Unique: 113061818070400301
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r5IH7Kr9002367

From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>

Few control settings done in architected timer as part of initialisation
are lost when CPU enters deeper power states. They need to be re-initialised
when the CPU is (warm)reset again.

This patch moves all such initialisation into separate function that can
be used both in cold and warm CPU reset paths. It also adds CPU PM
notifiers to do the timer initialisation on warm resets.

Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
Reviewed-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Will Deacon <will.deacon@arm.com>
---
 drivers/clocksource/arm_arch_timer.c | 51 +++++++++++++++++++++++++++++++-----
 1 file changed, 44 insertions(+), 7 deletions(-)

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 11aaf06..1c691b1 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -13,6 +13,7 @@
 #include <linux/device.h>
 #include <linux/smp.h>
 #include <linux/cpu.h>
+#include <linux/cpu_pm.h>
 #include <linux/clockchips.h>
 #include <linux/interrupt.h>
 #include <linux/of_irq.h>
@@ -123,10 +124,20 @@ static int arch_timer_set_next_event_phys(unsigned long evt,
 	return 0;
 }
 
-static int __cpuinit arch_timer_setup(struct clock_event_device *clk)
+static void arch_timer_initialise(void)
 {
 	int evt_stream_div, pos;
 
+	/* Find the closest power of two to the divisor */
+	evt_stream_div = arch_timer_rate / ARCH_TIMER_EVT_STREAM_FREQ;
+	pos = fls(evt_stream_div);
+	if (pos > 1 && !(evt_stream_div & (1 << (pos - 2))))
+		pos--;
+	arch_counter_set_user_access(min(pos, 15));
+}
+
+static int __cpuinit arch_timer_setup(struct clock_event_device *clk)
+{
 	clk->features = CLOCK_EVT_FEAT_ONESHOT | CLOCK_EVT_FEAT_C3STOP;
 	clk->name = "arch_sys_timer";
 	clk->rating = 450;
@@ -155,12 +166,7 @@ static int __cpuinit arch_timer_setup(struct clock_event_device *clk)
 			enable_percpu_irq(arch_timer_ppi[PHYS_NONSECURE_PPI], 0);
 	}
 
-	/* Find the closest power of two to the divisor */
-	evt_stream_div = arch_timer_rate / ARCH_TIMER_EVT_STREAM_FREQ;
-	pos = fls(evt_stream_div);
-	if (pos > 1 && !(evt_stream_div & (1 << (pos - 2))))
-		pos--;
-	arch_counter_set_user_access(min(pos, 15));
+	arch_timer_initialise();
 
 	return 0;
 }
@@ -267,6 +273,31 @@ static struct notifier_block arch_timer_cpu_nb __cpuinitdata = {
 	.notifier_call = arch_timer_cpu_notify,
 };
 
+#ifdef CONFIG_CPU_PM
+static int arch_timer_cpu_pm_notify(struct notifier_block *self,
+				    unsigned long action, void *hcpu)
+{
+	if (action == CPU_PM_EXIT)
+		arch_timer_initialise();
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block arch_timer_cpu_pm_notifier = {
+	.notifier_call = arch_timer_cpu_pm_notify,
+};
+
+static int __init arch_timer_cpu_pm_init(void)
+{
+	return cpu_pm_register_notifier(&arch_timer_cpu_pm_notifier);
+}
+#else
+static int __init arch_timer_cpu_pm_init(void)
+{
+	return 0;
+}
+#endif
+
 static int __init arch_timer_register(void)
 {
 	int err;
@@ -316,11 +347,17 @@ static int __init arch_timer_register(void)
 	if (err)
 		goto out_free_irq;
 
+	err = arch_timer_cpu_pm_init();
+	if (err)
+		goto out_unreg_notify;
+
 	/* Immediately configure the timer on the boot CPU */
 	arch_timer_setup(this_cpu_ptr(arch_timer_evt));
 
 	return 0;
 
+out_unreg_notify:
+	unregister_cpu_notifier(&arch_timer_cpu_nb);
 out_free_irq:
 	if (arch_timer_use_virtual)
 		free_percpu_irq(arch_timer_ppi[VIRT_PPI], arch_timer_evt);
-- 
1.8.1.2


