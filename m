Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618Ab3CKBeC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 21:34:02 -0400
Received: from mga02.intel.com ([134.134.136.20]:30245 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753425Ab3CKBeA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 21:34:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,819,1355126400"; 
   d="scan'208";a="275933461"
Subject: [PATCH 2/3 V2] intel_idle: Removing the redundant calculating for
 dev->state_count
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: lenb@kernel.org, daniel.lezcano@linaro.org
Cc: len.brown@intel.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, chuansheng.liu@intel.com
In-Reply-To: <1362755074.31506.45.camel@cliu38-desktop-build>
References: <1362674529.31506.17.camel@cliu38-desktop-build>
	 <1362754926.31506.42.camel@cliu38-desktop-build>
	 <1362755074.31506.45.camel@cliu38-desktop-build>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Mar 2013 18:44:17 +0800
Message-ID: <1362998657.31506.52.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In function intel_idle_cpu_init() and intel_idle_cpuidle_driver_init(),
they are having the same for(;;) loop to count the ->state_count.

Although intel_idle_cpu_init() can be called at runtime CPU HOTPLUG case,
but max_cstate can not be changed at runtime.

So the dev->state_count should be == drv->state_count, in the function
cpuidle_register_device() has done the initialization.

Here we can clean up these pieces of code.

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 drivers/idle/intel_idle.c |   29 -----------------------------
 1 files changed, 0 insertions(+), 29 deletions(-)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 17c9cf9..bb0ae0b 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -599,39 +599,10 @@ static int intel_idle_cpuidle_driver_init(void)
  */
 static int intel_idle_cpu_init(int cpu)
 {
-	int cstate;
 	struct cpuidle_device *dev;
 
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
-
 	dev->cpu = cpu;
 
 	if (cpuidle_register_device(dev)) {
-- 
1.7.0.4



