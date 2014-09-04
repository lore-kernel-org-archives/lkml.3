Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793AbaIDXJP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 19:09:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:27934 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755720AbaIDXJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 19:09:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,469,1406617200"; 
   d="scan'208";a="568588177"
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com,
        tglx@linutronix.de, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 5/5] perf, x86, uncore: Fix PCU filter setup for Sandy/Ivy/Haswell EP
Date: Thu,  4 Sep 2014 16:08:29 -0700
Message-Id: <1409872109-31645-5-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409872109-31645-1-git-send-email-andi@firstfloor.org>
References: <1409872109-31645-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

The PCU frequency band filters use 8 bit each in a register.
When setting up the value the shift value was not correctly
scaled, which resulted in all filters except for band 0 to
be zero. Fix the scaling.

This allows to correctly monitor multiple uncore frequency bands.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c b/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
index b237abc2..adf138e 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
@@ -841,7 +841,7 @@ static int snbep_pcu_hw_config(struct intel_uncore_box *box, struct perf_event *
 	if (ev_sel >= 0xb && ev_sel <= 0xe) {
 		reg1->reg = SNBEP_PCU_MSR_PMON_BOX_FILTER;
 		reg1->idx = ev_sel - 0xb;
-		reg1->config = event->attr.config1 & (0xff << reg1->idx);
+		reg1->config = event->attr.config1 & (0xff << (reg1->idx * 8));
 	}
 	return 0;
 }
-- 
1.9.3

