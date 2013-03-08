Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469Ab3CHFzO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 00:55:14 -0500
Received: from mga14.intel.com ([143.182.124.37]:47484 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000Ab3CHFzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 00:55:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,806,1355126400"; 
   d="scan'208";a="266562262"
Subject: [PATCH 2/3] intel_idle: Removing the redundant calculating for
 dev->state_count
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: lenb@kernel.org
Cc: daniel.lezcano@linaro.org, len.brown@intel.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, chuansheng.liu@intel.com
In-Reply-To: <1362754926.31506.42.camel@cliu38-desktop-build>
References: <1362674529.31506.17.camel@cliu38-desktop-build>
	 <1362754926.31506.42.camel@cliu38-desktop-build>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Mar 2013 23:04:34 +0800
Message-ID: <1362755074.31506.45.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In function intel_idle_cpu_init() and intel_idle_cpuidle_driver_init(),
they are having the same for(;;) loop.

Here in intel_idle_cpu_init(), the dev->state_count can be assigned by
drv->state_count directly.

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 drivers/idle/intel_idle.c |   30 ++----------------------------
 1 files changed, 2 insertions(+), 28 deletions(-)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 17c9cf9..503b401 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -599,38 +599,12 @@ static int intel_idle_cpuidle_driver_init(void)
  */
 static int intel_idle_cpu_init(int cpu)
 {
-	int cstate;
 	struct cpuidle_device *dev;
+	struct cpuidle_driver *drv = &intel_idle_driver;
 
 	dev = per_cpu_ptr(intel_idle_cpuidle_devices, cpu);
 
-	dev->state_count = 1;
-
-	for (cstate = 0; cstate < CPUIDLE_STATE_MAX; ++cstate) {
-		int num_substates, mwait_hint, mwait_cstate, mwait_substate;
-
-		if (cpuidle_state_table[cstate].enter == NULL)
-			break;
-
-		if (cstate + 1 > max_cstate) {
-			printk(PREFIX "max_cstate %d reached\n", max_cstate);
-			break;
-		}
-
-		mwait_hint = flg2MWAIT(cpuidle_state_table[cstate].flags);
-		mwait_cstate = MWAIT_HINT2CSTATE(mwait_hint);
-		mwait_substate = MWAIT_HINT2SUBSTATE(mwait_hint);
-
-		/* does the state exist in CPUID.MWAIT? */
-		num_substates = (mwait_substates >> ((mwait_cstate + 1) * 4))
-					& MWAIT_SUBSTATE_MASK;
-
-		/* if sub-state in table is not enumerated by CPUID */
-		if ((mwait_substate + 1) > num_substates)
-			continue;
-
-		dev->state_count += 1;
-	}
+	dev->state_count = drv->state_count;
 
 	dev->cpu = cpu;
 
-- 
1.7.0.4



