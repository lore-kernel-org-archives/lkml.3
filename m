Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761668Ab3ECMUZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 08:20:25 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41302 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761381Ab3ECMUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 08:20:24 -0400
Message-Id: <20130503121256.158211806@chello.nl>
User-Agent: quilt/0.48-1
Date: Fri, 03 May 2013 14:11:24 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, ak@linux.intel.com, eranian@google.com,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/3] perf, x86, lbr: Fix LBR filter
References: <20130503121122.931661809@chello.nl>
Content-Disposition: inline; filename=peterz-perf-x86-lbr-kernel-text.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The LBR 'from' adddress is under full userspace control; ensure we
validate it before reading from it.

Note: is_module_text_address() can potentially be quite expensive;
      for those running into that either stop using modules as
      all sane people do or optimize it using an RCU backed rb-tree.

Reported-by: Andi Kleen <ak@linux.intel.com>
Cc: eranian@google.com
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-mk8i82ffzax01cnqo829iy1q@git.kernel.org
---
 arch/x86/kernel/cpu/perf_event_intel_lbr.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -442,8 +442,18 @@ static int branch_type(unsigned long fro
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


