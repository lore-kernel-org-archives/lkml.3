Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934658Ab3GWWzN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:55:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41502 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934428Ab3GWW1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:27:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 017/103] powerpc/perf: Rework disable logic in pmu_disable()
Date: Tue, 23 Jul 2013 15:25:28 -0700
Message-Id: <20130723220420.492517297@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130723220418.532514378@linuxfoundation.org>
References: <20130723220418.532514378@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Ellerman <michael@ellerman.id.au>

commit 378a6ee99e4a431ec84e4e61893445c041c93007 upstream.

In pmu_disable() we disable the PMU by setting the FC (Freeze Counters)
bit in MMCR0. In order to do this we have to read/modify/write MMCR0.

It's possible that we read a value from MMCR0 which has PMAO (PMU Alert
Occurred) set. When we write that value back it will cause an interrupt
to occur. We will then end up in the PMU interrupt handler even though
we are supposed to have just disabled the PMU.

We can avoid this by making sure we never write PMAO back. We should not
lose interrupts because when the PMU is re-enabled the overflowed values
will cause another interrupt.

We also reorder the clearing of SAMPLE_ENABLE so that is done after the
PMU is frozen. Otherwise there is a small window between the clearing of
SAMPLE_ENABLE and the setting of FC where we could take an interrupt and
incorrectly see SAMPLE_ENABLE not set. This would for example change the
logic in perf_read_regs().

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/perf/core-book3s.c |   31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

--- a/arch/powerpc/perf/core-book3s.c
+++ b/arch/powerpc/perf/core-book3s.c
@@ -75,6 +75,7 @@ static unsigned int freeze_events_kernel
 
 #define MMCR0_FCHV		0
 #define MMCR0_PMCjCE		MMCR0_PMCnCE
+#define MMCR0_PMAO		0
 
 #define SPRN_MMCRA		SPRN_MMCR2
 #define MMCRA_SAMPLE_ENABLE	0
@@ -852,7 +853,7 @@ static void write_mmcr0(struct cpu_hw_ev
 static void power_pmu_disable(struct pmu *pmu)
 {
 	struct cpu_hw_events *cpuhw;
-	unsigned long flags;
+	unsigned long flags, val;
 
 	if (!ppmu)
 		return;
@@ -860,9 +861,6 @@ static void power_pmu_disable(struct pmu
 	cpuhw = &__get_cpu_var(cpu_hw_events);
 
 	if (!cpuhw->disabled) {
-		cpuhw->disabled = 1;
-		cpuhw->n_added = 0;
-
 		/*
 		 * Check if we ever enabled the PMU on this cpu.
 		 */
@@ -872,6 +870,21 @@ static void power_pmu_disable(struct pmu
 		}
 
 		/*
+		 * Set the 'freeze counters' bit, clear PMAO.
+		 */
+		val  = mfspr(SPRN_MMCR0);
+		val |= MMCR0_FC;
+		val &= ~MMCR0_PMAO;
+
+		/*
+		 * The barrier is to make sure the mtspr has been
+		 * executed and the PMU has frozen the events etc.
+		 * before we return.
+		 */
+		write_mmcr0(cpuhw, val);
+		mb();
+
+		/*
 		 * Disable instruction sampling if it was enabled
 		 */
 		if (cpuhw->mmcr[2] & MMCRA_SAMPLE_ENABLE) {
@@ -880,14 +893,8 @@ static void power_pmu_disable(struct pmu
 			mb();
 		}
 
-		/*
-		 * Set the 'freeze counters' bit.
-		 * The barrier is to make sure the mtspr has been
-		 * executed and the PMU has frozen the events
-		 * before we return.
-		 */
-		write_mmcr0(cpuhw, mfspr(SPRN_MMCR0) | MMCR0_FC);
-		mb();
+		cpuhw->disabled = 1;
+		cpuhw->n_added = 0;
 	}
 	local_irq_restore(flags);
 }


