Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757619Ab3ANRGu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 12:06:50 -0500
Received: from service87.mimecast.com ([91.220.42.44]:55252 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756389Ab3ANRGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 12:06:48 -0500
From: Mark Rutland <mark.rutland@arm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, tglx@linutronix.de, nico@linaro.org,
        Will.Deacon@arm.com, Marc.Zyngier@arm.com, john.stultz@linaro.org,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCHv3 4/4] arm: Add generic timer broadcast support
Date: Mon, 14 Jan 2013 17:05:24 +0000
Message-Id: <1358183124-28461-5-git-send-email-mark.rutland@arm.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1358183124-28461-1-git-send-email-mark.rutland@arm.com>
References: <1358183124-28461-1-git-send-email-mark.rutland@arm.com>
X-OriginalArrivalTime: 14 Jan 2013 17:06:46.0973 (UTC) FILETIME=[8928CED0:01CDF279]
X-MC-Unique: 113011417064714501
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r0EH6pmo001328

Implement timer_broadcast for the arm architecture, allowing for the use
of clock_event_device_drivers decoupled from the timer tick broadcast
mechanism.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Tested-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/Kconfig      |    1 +
 arch/arm/kernel/smp.c |    3 +--
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 67874b8..65ae737 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -4,6 +4,7 @@ config ARM
 	select ARCH_BINFMT_ELF_RANDOMIZE_PIE
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	select ARCH_HAVE_CUSTOM_GPIO_H
+	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select BUILDTIME_EXTABLE_SORT if MMU
 	select CPU_PM if (SUSPEND || CPU_IDLE)
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 9308519..b7e3b50 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -476,7 +476,7 @@ u64 smp_irq_stat_cpu(unsigned int cpu)
 static DEFINE_PER_CPU(struct clock_event_device, percpu_clockevent);
 
 #ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
-static void smp_timer_broadcast(const struct cpumask *mask)
+void tick_broadcast(const struct cpumask *mask)
 {
 	smp_cross_call(mask, IPI_TIMER);
 }
@@ -524,7 +524,6 @@ static void __cpuinit percpu_timer_setup(void)
 	struct clock_event_device *evt = &per_cpu(percpu_clockevent, cpu);
 
 	evt->cpumask = cpumask_of(cpu);
-	evt->broadcast = smp_timer_broadcast;
 
 	if (!lt_ops || lt_ops->setup(evt))
 		broadcast_timer_setup(evt);
-- 
1.7.0.4


