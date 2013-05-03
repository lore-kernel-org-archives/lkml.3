Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762010Ab3ECMUl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 08:20:41 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:47110
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761576Ab3ECMUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 08:20:25 -0400
Message-Id: <20130503121256.230745028@chello.nl>
User-Agent: quilt/0.48-1
Date: Fri, 03 May 2013 14:11:25 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, ak@linux.intel.com, eranian@google.com,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 3/3] perf, x86, lbr: Demand proper privileges for PERF_SAMPLE_BRANCH_KERNEL
References: <20130503121122.931661809@chello.nl>
Content-Disposition: inline; filename=peterz-perf-x86-lbr-priv.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should always have proper privileges when requesting kernel data.

Cc: Andi Kleen <ak@linux.intel.com>
Cc: eranian@google.com
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-v0x9ky3ahzr6nm3c6ilwrili@git.kernel.org
---
 arch/x86/kernel/cpu/perf_event_intel_lbr.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -318,8 +318,11 @@ static void intel_pmu_setup_sw_lbr_filte
 	if (br_type & PERF_SAMPLE_BRANCH_USER)
 		mask |= X86_BR_USER;
 
-	if (br_type & PERF_SAMPLE_BRANCH_KERNEL)
+	if (br_type & PERF_SAMPLE_BRANCH_KERNEL) {
+		if (perf_paranoid_kernel() && !capable(CAP_SYS_ADMIN))
+			return -EACCES;
 		mask |= X86_BR_KERNEL;
+	}
 
 	/* we ignore BRANCH_HV here */
 


