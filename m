Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328AbaEPVOO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 17:14:14 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:42771 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592AbaEPVOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 17:14:12 -0400
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Fri, 16 May 2014 17:18:07 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Vince Weaver <vincent.weaver@maine.edu>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 3/3] perf,x86: use common PMU interrupt disabled code
In-Reply-To: <alpine.DEB.2.10.1405161701160.11099@vincent-weaver-1.umelst.maine.edu>
Message-ID: <alpine.DEB.2.10.1405161715560.11099@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.10.1405161701160.11099@vincent-weaver-1.umelst.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Make the x86 perf code use the new common PMU interrupt disabled code.

Typically most x86 machines have working PMU interrupts, although
some older p6-class machines had this problem.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index ae407f7..adba966 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -303,15 +303,6 @@ int x86_setup_perfctr(struct perf_event *event)
 		hwc->sample_period = x86_pmu.max_period;
 		hwc->last_period = hwc->sample_period;
 		local64_set(&hwc->period_left, hwc->sample_period);
-	} else {
-		/*
-		 * If we have a PMU initialized but no APIC
-		 * interrupts, we cannot sample hardware
-		 * events (user-space has to fall back and
-		 * sample via a hrtimer based software event):
-		 */
-		if (!x86_pmu.apic)
-			return -EOPNOTSUPP;
 	}
 
 	if (attr->type == PERF_TYPE_RAW)
@@ -1365,6 +1356,15 @@ static void __init pmu_check_apic(void)
 	x86_pmu.apic = 0;
 	pr_info("no APIC, boot with the \"lapic\" boot parameter to force-enable it.\n");
 	pr_info("no hardware sampling interrupt available.\n");
+
+	/*
+	 * If we have a PMU initialized but no APIC
+	 * interrupts, we cannot sample hardware
+	 * events (user-space has to fall back and
+	 * sample via a hrtimer based software event):
+	 */
+	pmu.capabilities |= PERF_PMU_NO_INTERRUPT;
+
 }
 
 static struct attribute_group x86_pmu_format_group = {
