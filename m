Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672Ab3HWQUj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 12:20:39 -0400
Received: from service87.mimecast.com ([91.220.42.44]:56152 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155Ab3HWQU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 12:20:28 -0400
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Sudeep.KarkadaNagesha@arm.com,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
Subject: [PATCH v4 5/5] drivers: clocksource: add CPU PM notifier for ARM architected timer
Date: Fri, 23 Aug 2013 17:19:09 +0100
Message-Id: <1377274749-6196-6-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1377274749-6196-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
References: <1377274749-6196-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-OriginalArrivalTime: 23 Aug 2013 16:20:24.0204 (UTC) FILETIME=[ABCAB4C0:01CEA01C]
X-MC-Unique: 113082317202608101
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r7NGKm6A007985

From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>

Few control settings done in architected timer as part of initialisation
can be lost when CPU enters deeper power states. They need to be
re-initialised when the CPU is (warm)reset again.

This patch adds CPU PM notifiers to do the timer initialisation on warm
resets. It also save the event stream divider value calculated during
cold reset and uses the same in warm reset path.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
---
 drivers/clocksource/arm_arch_timer.c | 47 +++++++++++++++++++++++++++++++++---
 1 file changed, 44 insertions(+), 3 deletions(-)

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index e331818..1d5b75d 100644
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
@@ -124,6 +125,12 @@ static int arch_timer_set_next_event_phys(unsigned long evt,
 }
 
 #ifdef CONFIG_ARM_ARCH_TIMER_EVTSTREAM
+static int arch_timer_evtstream_div;
+static void arch_timer_evtstream_reset(void)
+{
+	/* enable event stream */
+	arch_timer_evtstrm_config(true, arch_timer_evtstream_div);
+}
 static void arch_timer_setup_evtstream(void)
 {
 	int evt_stream_div, pos;
@@ -133,16 +140,19 @@ static void arch_timer_setup_evtstream(void)
 	pos = fls(evt_stream_div);
 	if (pos > 1 && !(evt_stream_div & (1 << (pos - 2))))
 		pos--;
-	/* enable event stream */
-	arch_timer_evtstrm_config(true, min(pos, 15));
+	/* save divider value for use in CPU PM notifier */
+	arch_timer_evtstream_div = min(pos, 15);
+	arch_timer_evtstream_reset();
 	/* enable hwcap definition to the users for event stream feature */
 	arch_timer_set_hwcap_evtstrm();
 }
 #else
-static void arch_timer_setup_evtstream(void)
+static void arch_timer_evtstream_reset(void)
 {
+	/* disable event stream */
 	arch_timer_evtstrm_config(false, 0);
 }
+#define arch_timer_setup_evtstream	arch_timer_evtstream_reset
 #endif
 
 static int arch_timer_setup(struct clock_event_device *clk)
@@ -283,6 +293,31 @@ static struct notifier_block arch_timer_cpu_nb = {
 	.notifier_call = arch_timer_cpu_notify,
 };
 
+#ifdef CONFIG_CPU_PM
+static int arch_timer_cpu_pm_notify(struct notifier_block *self,
+				    unsigned long action, void *hcpu)
+{
+	if (action == CPU_PM_EXIT)
+		arch_timer_evtstream_reset();
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
@@ -332,11 +367,17 @@ static int __init arch_timer_register(void)
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


