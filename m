Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792AbaAQQYE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 11:24:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752763AbaAQQYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 11:24:00 -0500
From: Don Zickus <dzickus@redhat.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Don Zickus <dzickus@redhat.com>, Dave Young <dyoung@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Cyrill Gorcunov <gorcunov@openvz.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] x86, perf_p4:  block PMIs on init to prevent a stream of unkown NMIs
Date: Fri, 17 Jan 2014 10:41:41 -0500
Message-Id: <1389973301-134448-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A bunch of unknown NMIs have popped up on a Pentium4 recently when booting
into a kdump kernel.  This was exposed because the watchdog timer went
from 60 seconds down to 10 seconds (increasing the ability to reproduce
this problem).

What is happening is on boot up of the second kernel (the kdump one),
the previous nmi_watchdogs were enabled on thread 0 and thread 1.  The
second kernel only initializes one cpu but the perf counter on thread 1
still counts.

Normally in a kdump scenario, the other cpus are blocking in an NMI loop,
but more importantly their local apics have the performance counters disabled
(iow LVTPC is masked).  So any counters that fire are masked and never get
through to the second kernel.

However, on a P4 the local apic is shared by both threads and thread1's PMI
(despite being configured to only interrupt thread1) will generate an NMI on
thread0.  Because thread0 knows nothing about this NMI, it is seen as an
unknown NMI.

This would be fine because it is a kdump kernel, strange things happen
what is the big deal about a single unknown NMI.

Unfortunately, the P4 comes with another quirk: clearing the overflow bit
to prevent a stream of NMIs.  This is the problem.

The kdump kernel can not execute because of the endless NMIs that happen.

To solve this, I instrumented the p4 perf init code, to walk all the counters
and explicitly disable any overflow bits, but more importantly disable the
ability for the counters to generate a PMI.

Now when the counters go off, they do not generate anything and no unknown
NMIs are seen.

I could have removed the ENABLE bit too, but was worried it would impact
BIOS vendors secret ability to monitor cpu states.  I figured the ability to
generate a PMI or not is not interesting to them and chose that route instead.

I tested this on a P4 we have in our lab.  After two or three crashes, I could
normally reproduce the problem.  Now after 10 crashes, everything continues
to boot correctly.

Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/kernel/cpu/perf_event_p4.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index 3486e66..cff30ab 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -1322,6 +1322,8 @@ static __initconst const struct x86_pmu p4_pmu = {
 __init int p4_pmu_init(void)
 {
 	unsigned int low, high;
+	u64 val;
+	int i, reg;
 
 	/* If we get stripped -- indexing fails */
 	BUILD_BUG_ON(ARCH_P4_MAX_CCCR > INTEL_PMC_MAX_GENERIC);
@@ -1340,5 +1342,29 @@ __init int p4_pmu_init(void)
 
 	x86_pmu = p4_pmu;
 
+	/*
+	 * Even though the counters are configured to interrupt a particular
+	 * logical processor when an overflow happens, testing has shown that
+	 * on kdump kernels (which uses a single cpu), thread1's counter
+	 * continues to run and will report an NMI on thread0.  Due to the
+	 * overflow bug, this leads to a stream of unknown NMIs.
+	 *
+	 * Solve this by disabling all counter's ability to generate a PMI.
+	 * Disabling the ENABLE bit would work too, but I was afraid that would
+	 * cause problems with BIOS vendors that secretly use the PMUs for data
+	 * analysis.  So keep the ENABLE bit on, but prevent PMIs from
+	 * happening.
+	 *
+	 * The clearing of the overflow is to prevent the scenario where an
+	 * overflow happened before the second kernel came up and the second
+	 * kernel blindly does an apic_write(LVTPC, APIC_DM_NMI), again causing
+	 * a stream of endless unknown NMIs.
+	 */
+        for (i = 0; i < x86_pmu.num_counters; i++) {
+		reg = x86_pmu_config_addr(i);
+		rdmsrl_safe(reg, &val);
+		wrmsrl_safe(reg, val & ~(P4_CCCR_OVF|P4_CCCR_OVF_PMI_T0|P4_CCCR_OVF_PMI_T1));
+        }
+
 	return 0;
 }
-- 
1.7.1

