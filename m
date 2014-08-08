Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079AbaHHAJB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 20:09:01 -0400
Received: from mga11.intel.com ([192.55.52.93]:43106 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399AbaHHAI4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 20:08:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,820,1400050800"; 
   d="scan'208";a="581709347"
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org
Cc: kan.liang@intel.com, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] perf, x86: Fix :pp without LBR
Date: Thu,  7 Aug 2014 17:08:54 -0700
Message-Id: <1407456534-15747-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

This fixes a side effect of Kan's earlier patch to probe the LBRs at boot
time. Normally when the LBRs are disabled cycles:pp is disabled too.
So for example cycles:pp doesn't work.

However this is not needed with PEBSv2 and later (Haswell) because
it does not need LBRs to correct the IP-off-by-one.

So add an extra check for PEBSv2 that also allows :pp

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 2879ecd..0646d3b 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -387,7 +387,7 @@ int x86_pmu_hw_config(struct perf_event *event)
 			precise++;
 
 			/* Support for IP fixup */
-			if (x86_pmu.lbr_nr)
+			if (x86_pmu.lbr_nr || x86_pmu.intel_cap.pebs_format >= 2)
 				precise++;
 		}
 
-- 
1.9.3

