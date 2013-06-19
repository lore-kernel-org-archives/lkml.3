Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965065Ab3FSSnN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:43:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40285 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964945Ab3FSSnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:43:06 -0400
Date: Wed, 19 Jun 2013 11:42:46 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-72db55964695dcd4aa15950f3b2fb7c09ad79829@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, ak@linux.jf.intel.com,
        ak@linux.intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        ak@linux.jf.intel.com, ak@linux.intel.com, tglx@linutronix.de
In-Reply-To: <1371515812-9646-5-git-send-email-andi@firstfloor.org>
References: <1371515812-9646-5-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86/intel:
  Move NMI clearing to end of PMI handler
Git-Commit-ID: 72db55964695dcd4aa15950f3b2fb7c09ad79829
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 19 Jun 2013 11:42:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  72db55964695dcd4aa15950f3b2fb7c09ad79829
Gitweb:     http://git.kernel.org/tip/72db55964695dcd4aa15950f3b2fb7c09ad79829
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Mon, 17 Jun 2013 17:36:50 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 19 Jun 2013 14:43:34 +0200

perf/x86/intel: Move NMI clearing to end of PMI handler

This avoids some problems with spurious PMIs on Haswell.
Haswell seems to behave more like P4 in this regard. Do
the same thing as the P4 perf handler by unmasking
the NMI only at the end. Shouldn't make any difference
for earlier family 6 cores.

(Tested on Haswell, IvyBridge, Westmere, Saltwell (Atom).)

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <ak@linux.jf.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Link: http://lkml.kernel.org/r/1371515812-9646-5-git-send-email-andi@firstfloor.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event.h       |  1 +
 arch/x86/kernel/cpu/perf_event_intel.c | 20 ++++++++++++--------
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index fb7fe44..f43473c 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -378,6 +378,7 @@ struct x86_pmu {
 	struct event_constraint *event_constraints;
 	struct x86_pmu_quirk *quirks;
 	int		perfctr_second_write;
+	bool		late_ack;
 
 	/*
 	 * sysfs attrs
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 4a4c4ba..877672c 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1185,15 +1185,11 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
 	cpuc = &__get_cpu_var(cpu_hw_events);
 
 	/*
-	 * Some chipsets need to unmask the LVTPC in a particular spot
-	 * inside the nmi handler.  As a result, the unmasking was pushed
-	 * into all the nmi handlers.
-	 *
-	 * This handler doesn't seem to have any issues with the unmasking
-	 * so it was left at the top.
+	 * No known reason to not always do late ACK,
+	 * but just in case do it opt-in.
 	 */
-	apic_write(APIC_LVTPC, APIC_DM_NMI);
-
+	if (!x86_pmu.late_ack)
+		apic_write(APIC_LVTPC, APIC_DM_NMI);
 	intel_pmu_disable_all();
 	handled = intel_pmu_drain_bts_buffer();
 	status = intel_pmu_get_status();
@@ -1257,6 +1253,13 @@ again:
 
 done:
 	intel_pmu_enable_all(0);
+	/*
+	 * Only unmask the NMI after the overflow counters
+	 * have been reset. This avoids spurious NMIs on
+	 * Haswell CPUs.
+	 */
+	if (x86_pmu.late_ack)
+		apic_write(APIC_LVTPC, APIC_DM_NMI);
 	return handled;
 }
 
@@ -2260,6 +2263,7 @@ __init int intel_pmu_init(void)
 	case 70:
 	case 71:
 	case 63:
+		x86_pmu.late_ack = true;
 		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids, sizeof(hw_cache_event_ids));
 		memcpy(hw_cache_extra_regs, snb_hw_cache_extra_regs, sizeof(hw_cache_extra_regs));
 
