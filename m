Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757609AbaDKKgB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 06:36:01 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:41081 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755814AbaDKKfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 06:35:55 -0400
Subject: [PATCH 1/3] ppc/powernv: Set the runlatch bits correctly for
 offline cpus
To: linuxppc-dev@ozlabs.org
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: benh@kernel.crashing.org, paulus@samba.org, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com
Date: Fri, 11 Apr 2014 16:01:48 +0530
Message-ID: <20140411103148.27683.20726.stgit@preeti.in.ibm.com>
In-Reply-To: <20140411103030.27683.2107.stgit@preeti.in.ibm.com>
References: <20140411103030.27683.2107.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14041110-0320-0000-0000-000002F5DBA4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Up until now we have been setting the runlatch bits for a busy CPU and
clearing it when a CPU enters idle state. The runlatch bit has thus
been consistent with the utilization of a CPU as long as the CPU is online.

However when a CPU is hotplugged out the runlatch bit is not cleared. It
needs to be cleared to indicate an unused CPU. Hence this patch has the
runlatch bit cleared for an offline CPU just before entering an idle state
and sets it immediately after it exits the idle state.

Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Acked-by: Paul Mackerras <paulus@samba.org>
Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 arch/powerpc/platforms/powernv/smp.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/powerpc/platforms/powernv/smp.c b/arch/powerpc/platforms/powernv/smp.c
index 908672b..bf5fcd4 100644
--- a/arch/powerpc/platforms/powernv/smp.c
+++ b/arch/powerpc/platforms/powernv/smp.c
@@ -30,6 +30,7 @@
 #include <asm/cputhreads.h>
 #include <asm/xics.h>
 #include <asm/opal.h>
+#include <asm/runlatch.h>
 
 #include "powernv.h"
 
@@ -156,7 +157,9 @@ static void pnv_smp_cpu_kill_self(void)
 	 */
 	mtspr(SPRN_LPCR, mfspr(SPRN_LPCR) & ~(u64)LPCR_PECE1);
 	while (!generic_check_cpu_restart(cpu)) {
+		ppc64_runlatch_off();
 		power7_nap();
+		ppc64_runlatch_on();
 		if (!generic_check_cpu_restart(cpu)) {
 			DBG("CPU%d Unexpected exit while offline !\n", cpu);
 			/* We may be getting an IPI, so we re-enable

