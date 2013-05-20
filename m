Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004Ab3ETLQQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 07:16:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56094 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755897Ab3ETKww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:52:52 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, eranian@google.com,
        Ingo Molnar <mingo@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 039/115] perf/x86/intel/lbr: Fix LBR filter
Date: Mon, 20 May 2013 11:50:39 +0100
Message-Id: <1369047116-9378-40-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

commit 6e15eb3ba6c0249c9e8c783517d131b47db995ca upstream.

The LBR 'from' adddress is under full userspace control; ensure
we validate it before reading from it.

Note: is_module_text_address() can potentially be quite
expensive; for those running into that with high overhead
in modules optimize it using an RCU backed rb-tree.

Reported-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: eranian@google.com
Link: http://lkml.kernel.org/r/20130503121256.158211806@chello.nl
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: http://lkml.kernel.org/n/tip-mk8i82ffzax01cnqo829iy1q@git.kernel.org
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/kernel/cpu/perf_event_intel_lbr.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index 520b426..62a93a4 100644
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
1.8.1.2

