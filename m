Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234AbaGNT23 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 15:28:29 -0400
Received: from mail-qg0-f53.google.com ([209.85.192.53]:47768 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218AbaGNT2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 15:28:20 -0400
From: Vince Weaver <vincent.weaver@maine.edu>
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Mon, 14 Jul 2014 15:33:25 -0400 (EDT)
To: linux-kernel@vger.kernel.org
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Andi Kleen <ak@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Stephane Eranian <eranian@gmail.com>
Subject: [patch] perf: use proper dTLB-load-misses event on Ivybridge
Message-ID: <alpine.DEB.2.11.1407141528200.17214@vincent-weaver-1.umelst.maine.edu>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This was discussed back in February 
	https://lkml.org/lkml/2014/2/18/956
But I never saw a patch come out of it.

On Ivybridge we share the Sandybridge cache event tables, but the
dTLB-load-miss event is not compatible.  Patch it up after
the fact to the proper DTLB_LOAD_MISSES.DEMAND_LD_MISS_CAUSES_A_WALK

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index adb02aa..f5784f0 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2465,6 +2465,9 @@ __init int intel_pmu_init(void)
 	case 62: /* IvyBridge EP */
 		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
+		/* dTLB-load-misses on IVB is different than SNB */
+		hw_cache_event_ids[C(DTLB)][C(OP_READ)][C(RESULT_MISS)] = 0x8108; /* DTLB_LOAD_MISSES.DEMAND_LD_MISS_CAUSES_A_WALK */
+
 		memcpy(hw_cache_extra_regs, snb_hw_cache_extra_regs,
 		       sizeof(hw_cache_extra_regs));
 
