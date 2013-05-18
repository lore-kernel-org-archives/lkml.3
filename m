Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759047Ab3ERDIy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:08:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23572 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758758Ab3ERDAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:22 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=1cfSuSqY5N0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=GXg2MX55kj4A:10 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=aCPqOQJ_S1qBLZ7JjQ4A:9 a=LI9Vle30uBYA:10 a=UTB_XpHje0EA:10 a=jeBq3FmKZ4MA:10 a=9AFDjcNqeQJHms3Q:21 a=JRfErz5_wFu0Iu6m:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021656.359259468@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:17:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        <stable@kernel.org>, <eranian@google.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [ 091/136 ] perf/x86/intel/lbr: Fix LBR filter
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0091-perf-x86-intel-lbr-Fix-LBR-filter.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

[ Upstream commit 6e15eb3ba6c0249c9e8c783517d131b47db995ca ]

The LBR 'from' adddress is under full userspace control; ensure
we validate it before reading from it.

Note: is_module_text_address() can potentially be quite
expensive; for those running into that with high overhead
in modules optimize it using an RCU backed rb-tree.

Reported-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: <stable@kernel.org>
Cc: eranian@google.com
Link: http://lkml.kernel.org/r/20130503121256.158211806@chello.nl
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: http://lkml.kernel.org/n/tip-mk8i82ffzax01cnqo829iy1q@git.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/cpu/perf_event_intel_lbr.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index da02e9c..de341d4 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -442,8 +442,18 @@ static int branch_type(unsigned long from, unsigned long to)
 			return X86_BR_NONE;
 
 		addr = buf;
-	} else
-		addr = (void *)from;
+	} else {
+		/*
+		 * The LBR logs any address in the IP, even if the IP just
+		 * faulted. This means userspace can control the from address.
+		 * Ensure we don't blindy read any address by validating it is
+		 * a known text address.
+		 */
+		if (kernel_text_address(from))
+			addr = (void *)from;
+		else
+			return X86_BR_NONE;
+	}
 
 	/*
 	 * decoder needs to know the ABI especially
-- 
1.7.10.4


