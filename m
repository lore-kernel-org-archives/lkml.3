Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818AbaANKzo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 05:55:44 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:45855 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794AbaANKzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 05:55:41 -0500
Subject: [PATCH v1 1/6] pseries/cpuidle: Remove redundant call to
 ppc64_runlatch_off() in cpu idle routines
To: linux-pm@vger.kernel.org, benh@kernel.crashing.org,
        daniel.lezcano@linaro.org, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com, preeti@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Date: Tue, 14 Jan 2014 16:25:54 +0530
Message-ID: <20140114105547.3064.55112.stgit@deepthi.in.ibm.com>
In-Reply-To: <20140114105525.3064.52013.stgit@deepthi.in.ibm.com>
References: <20140114105525.3064.52013.stgit@deepthi.in.ibm.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011410-5564-0000-0000-00000B8AB67F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Preeti U Murthy <preeti@linux.vnet.ibm.com>

Commit fbd7740fdfdf9475f(powerpc: Simplify pSeries idle loop) switched pseries
cpu idle handling from complete idle loops to ppc_md.powersave functions.
Earlier to this switch, ppc64_runlatch_off() had to be called in each of the
idle routines. But after the switch, this call is handled in arch_cpu_idle(),
just before the call to ppc_md.powersave, where platform specific idle
routines are called.

As a consequence, the call to ppc64_runlatch_off() got duplicated in the
arch_cpu_idle() routine as well as in the some of the idle routines in
pseries and commit fbd7740fdfdf9475f missed to get rid of these redundant
calls. These calls were carried over subsequent enhancements to the pseries
cpuidle routines.

Although multiple calls to ppc64_runlatch_off() is harmless, there is still some
overhead due to it. Besides that, these calls could also make way for a
misunderstanding that it is *necessary* to call ppc64_runlatch_off() multiple
times, when that is not the case. Hence this patch takes care of eliminating
this redundancy.

Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
---
 arch/powerpc/platforms/pseries/processor_idle.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/processor_idle.c b/arch/powerpc/platforms/pseries/processor_idle.c
index a166e38..09e4f56 100644
--- a/arch/powerpc/platforms/pseries/processor_idle.c
+++ b/arch/powerpc/platforms/pseries/processor_idle.c
@@ -17,7 +17,6 @@
 #include <asm/reg.h>
 #include <asm/machdep.h>
 #include <asm/firmware.h>
-#include <asm/runlatch.h>
 #include <asm/plpar_wrappers.h>
 
 struct cpuidle_driver pseries_idle_driver = {
@@ -63,7 +62,6 @@ static int snooze_loop(struct cpuidle_device *dev,
 	set_thread_flag(TIF_POLLING_NRFLAG);
 
 	while ((!need_resched()) && cpu_online(cpu)) {
-		ppc64_runlatch_off();
 		HMT_low();
 		HMT_very_low();
 	}
@@ -103,7 +101,6 @@ static int dedicated_cede_loop(struct cpuidle_device *dev,
 	idle_loop_prolog(&in_purr);
 	get_lppaca()->donate_dedicated_cpu = 1;
 
-	ppc64_runlatch_off();
 	HMT_medium();
 	check_and_cede_processor();
 

