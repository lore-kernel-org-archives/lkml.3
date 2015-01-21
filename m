Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397AbbAUREP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 12:04:15 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:53631 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668AbbAURD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 12:03:59 -0500
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        Russell King <linux@arm.linux.org.uk>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Daniel Drake <drake@endlessm.com>,
        Dmitry Pervushin <dpervushin@gmail.com>,
        Tim Sander <tim@krieglstein.org>, Stephen Boyd <sboyd@codeaurora.org>,
        Will Deacon <will.deacon@arm.com>
Subject: [RFC PATCH v2 4/5] arm: perf: Make v7 support FIQ-safe
Date: Wed, 21 Jan 2015 17:03:41 +0000
Message-Id: <1421859822-3621-5-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1421859822-3621-1-git-send-email-daniel.thompson@linaro.org>
References: <1421166931-14134-1-git-send-email-daniel.thompson@linaro.org>
 <1421859822-3621-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

armv7pmu_disable_event() is called during irq handling. If irq handling
switches over to fiq then the spin locks in this function risk deadlock.
Both armv7_pmnc_disable_counter() and armv7_pmnc_disable_intens() are
unconditional co-processor writes. I haven't yet come up with an
schedule where other users of pmu_lock would break if interleaved with
these calls so I have simply removed them.

The other change required us to avoid calling irq_work_run() when run
from a FIQ handler. The pended work will either be dispatched by the
irq work IPI or by a timer handler.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
---
 arch/arm/kernel/perf_event_v7.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/arch/arm/kernel/perf_event_v7.c b/arch/arm/kernel/perf_event_v7.c
index 8993770c47de..08f426486d3e 100644
--- a/arch/arm/kernel/perf_event_v7.c
+++ b/arch/arm/kernel/perf_event_v7.c
@@ -744,7 +744,6 @@ static void armv7pmu_enable_event(struct perf_event *event)
 
 static void armv7pmu_disable_event(struct perf_event *event)
 {
-	unsigned long flags;
 	struct hw_perf_event *hwc = &event->hw;
 	struct arm_pmu *cpu_pmu = to_arm_pmu(event->pmu);
 	struct pmu_hw_events *events = this_cpu_ptr(cpu_pmu->hw_events);
@@ -757,11 +756,6 @@ static void armv7pmu_disable_event(struct perf_event *event)
 	}
 
 	/*
-	 * Disable counter and interrupt
-	 */
-	raw_spin_lock_irqsave(&events->pmu_lock, flags);
-
-	/*
 	 * Disable counter
 	 */
 	armv7_pmnc_disable_counter(idx);
@@ -770,8 +764,6 @@ static void armv7pmu_disable_event(struct perf_event *event)
 	 * Disable interrupt for this counter
 	 */
 	armv7_pmnc_disable_intens(idx);
-
-	raw_spin_unlock_irqrestore(&events->pmu_lock, flags);
 }
 
 static irqreturn_t armv7pmu_handle_irq(int irq_num, void *dev)
@@ -831,7 +823,8 @@ static irqreturn_t armv7pmu_handle_irq(int irq_num, void *dev)
 	 * platforms that can have the PMU interrupts raised as an NMI, this
 	 * will not work.
 	 */
-	irq_work_run();
+	if (!in_nmi())
+		irq_work_run();
 
 	return IRQ_HANDLED;
 }
-- 
1.9.3

