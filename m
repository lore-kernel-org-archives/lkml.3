Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596Ab3ANRGH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 12:06:07 -0500
Received: from service87.mimecast.com ([91.220.42.44]:58281 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756505Ab3ANRGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 12:06:05 -0500
From: Mark Rutland <mark.rutland@arm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, tglx@linutronix.de, nico@linaro.org,
        Will.Deacon@arm.com, Marc.Zyngier@arm.com, john.stultz@linaro.org,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCHv3 3/4] arm: Use generic timer broadcast receiver
Date: Mon, 14 Jan 2013 17:05:23 +0000
Message-Id: <1358183124-28461-4-git-send-email-mark.rutland@arm.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1358183124-28461-1-git-send-email-mark.rutland@arm.com>
References: <1358183124-28461-1-git-send-email-mark.rutland@arm.com>
X-OriginalArrivalTime: 14 Jan 2013 17:06:00.0318 (UTC) FILETIME=[6D59D1E0:01CDF279]
X-MC-Unique: 113011417060203501
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r0EH696m001324

Currently, the ARM backend must maintain a redundant list of timers for
the purpose of centralising timer broadcast functionality. This prevents
sharing timer drivers across architectures.

This patch moves the pain of dealing with timer broadcasts to the core
clockevents tick broadcast code, which already maintains its own list
of timers.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Tested-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/kernel/smp.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 84f4cbf..9308519 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -475,12 +475,6 @@ u64 smp_irq_stat_cpu(unsigned int cpu)
  */
 static DEFINE_PER_CPU(struct clock_event_device, percpu_clockevent);
 
-static void ipi_timer(void)
-{
-	struct clock_event_device *evt = &__get_cpu_var(percpu_clockevent);
-	evt->event_handler(evt);
-}
-
 #ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
 static void smp_timer_broadcast(const struct cpumask *mask)
 {
@@ -596,11 +590,13 @@ void handle_IPI(int ipinr, struct pt_regs *regs)
 	case IPI_WAKEUP:
 		break;
 
+#ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
 	case IPI_TIMER:
 		irq_enter();
-		ipi_timer();
+		tick_receive_broadcast();
 		irq_exit();
 		break;
+#endif
 
 	case IPI_RESCHEDULE:
 		scheduler_ipi();
-- 
1.7.0.4


