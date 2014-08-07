Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbaHGR7N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 13:59:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:33122 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763AbaHGR7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 13:59:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,819,1400050800"; 
   d="scan'208";a="555293079"
Subject: [PATCH] [BUGFIX] x86: mm: fix rcu splat from new TLB tracepoints
To: linux-kernel@vger.kernel.org
Cc: Dave Hansen <dave@sr71.net>, dave.hansen@linux.intel.com, davej@redhat.com,
        paulmck@linux.vnet.ibm.com, hpa@zytor.com, x86@kernel.org
From: Dave Hansen <dave@sr71.net>
Date: Thu, 07 Aug 2014 10:58:41 -0700
Message-Id: <20140807175841.5C92D878@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

This is a bug fix that needs to be pushed to mainline before the
3.17 release.

Dave Jones reported seeing a bug from one of my TLB tracepoints:

        http://lkml.kernel.org/r/20140806181801.GA4605@redhat.com

According to Paul McKenney, the right way to fix this is adding
an _rcuidle suffix to the tracepoint.

        http://lkml.kernel.org/r/20140807065055.GA5821@linux.vnet.ibm.com

This patch does just that.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reported-by: Dave Jones <davej@redhat.com>,
Cc: paulmck@linux.vnet.ibm.com
---

 b/arch/x86/mm/tlb.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN arch/x86/mm/tlb.c~mm-fix-rcu-splat-from-tlb-tracepoints arch/x86/mm/tlb.c
--- a/arch/x86/mm/tlb.c~mm-fix-rcu-splat-from-tlb-tracepoints	2014-08-07 10:55:43.312283542 -0700
+++ b/arch/x86/mm/tlb.c	2014-08-07 10:56:49.763352575 -0700
@@ -49,7 +49,13 @@ void leave_mm(int cpu)
 	if (cpumask_test_cpu(cpu, mm_cpumask(active_mm))) {
 		cpumask_clear_cpu(cpu, mm_cpumask(active_mm));
 		load_cr3(swapper_pg_dir);
-		trace_tlb_flush(TLB_FLUSH_ON_TASK_SWITCH, TLB_FLUSH_ALL);
+		/*
+		 * This gets called in the idle path where RCU
+		 * functions differently.  Tracing normally
+		 * uses RCU, so we have to call the tracepoint
+		 * specially here.
+		 */
+		trace_tlb_flush_rcuidle(TLB_FLUSH_ON_TASK_SWITCH, TLB_FLUSH_ALL);
 	}
 }
 EXPORT_SYMBOL_GPL(leave_mm);
_
