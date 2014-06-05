Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674AbaFEOjk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:39:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48654 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbaFEOji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:39:38 -0400
Date: Thu, 5 Jun 2014 07:38:44 -0700
From: tip-bot for Vince Weaver <tipbot@zytor.com>
Message-ID: <tip-c184c980de30dc5f6fec4b281928aa6743708da9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, acme@kernel.org,
        vincent.weaver@maine.edu, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, acme@kernel.org,
        vincent.weaver@maine.edu, tglx@linutronix.de
In-Reply-To: <alpine.DEB.2.10.1405161715560.11099@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.10.1405161715560.11099@vincent-weaver-1.umelst.maine.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86: Use common PMU interrupt disabled code
Git-Commit-ID: c184c980de30dc5f6fec4b281928aa6743708da9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c184c980de30dc5f6fec4b281928aa6743708da9
Gitweb:     http://git.kernel.org/tip/c184c980de30dc5f6fec4b281928aa6743708da9
Author:     Vince Weaver <vincent.weaver@maine.edu>
AuthorDate: Fri, 16 May 2014 17:18:07 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 5 Jun 2014 12:30:03 +0200

perf/x86: Use common PMU interrupt disabled code

Make the x86 perf code use the new common PMU interrupt disabled code.

Typically most x86 machines have working PMU interrupts, although
some older p6-class machines had this problem.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1405161715560.11099@vincent-weaver-1.umelst.maine.edu
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 32029e3..2bdfbff 100644
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
@@ -1367,6 +1358,15 @@ static void __init pmu_check_apic(void)
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
+	pmu.capabilities |= PERF_PMU_CAP_NO_INTERRUPT;
+
 }
 
 static struct attribute_group x86_pmu_format_group = {
