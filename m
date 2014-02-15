Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284AbaBOAoP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 19:44:15 -0500
Received: from mga01.intel.com ([192.55.52.88]:12299 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753212AbaBOAoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 19:44:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,848,1384329600"; 
   d="scan'208";a="475564174"
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org
Cc: mingo@kernel.org, eranian@google.com, linux-kernel@vger.kernel.org,
        Markus Metzger <markus.t.metzger@intel.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] perf, nmi: fix unknown NMI warning
Date: Fri, 14 Feb 2014 16:44:08 -0800
Message-Id: <1392425048-5309-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Metzger <markus.t.metzger@intel.com>

[From Markus, just sending for him because he had problems with his mail]

When using BTS on Core i7-4*, I get the below kernel warning.

$ perf record -c 1 -e branches:u ls
Message from syslogd@labpc1501 at Nov 11 15:49:25 ...
 kernel:[  438.317893] Uhhuh. NMI received for unknown reason 31 on CPU 2.

Message from syslogd@labpc1501 at Nov 11 15:49:25 ...
 kernel:[  438.317920] Do you have a strange power saving mode enabled?

Message from syslogd@labpc1501 at Nov 11 15:49:25 ...
 kernel:[  438.317945] Dazed and confused, but trying to continue

Make intel_pmu_handle_irq() take the full exit path when returning early.

Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 0fa4f24..698ae77 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1361,10 +1361,8 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
 	intel_pmu_disable_all();
 	handled = intel_pmu_drain_bts_buffer();
 	status = intel_pmu_get_status();
-	if (!status) {
-		intel_pmu_enable_all(0);
-		return handled;
-	}
+	if (!status)
+		goto done;
 
 	loops = 0;
 again:
-- 
1.8.5.3

