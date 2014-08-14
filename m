Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718AbaHNC0A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 22:26:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:15038 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754638AbaHNCZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 22:25:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,859,1400050800"; 
   d="scan'208";a="576431359"
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: rjw@rjwysocki.net, daniel.lezcano@linaro.org
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        changcheng.liu@intel.com, xiaoming.wang@intel.com,
        souvik.k.chakravarty@intel.com, chuansheng.liu@intel.com
Subject: [PATCH] cpuidle: Fix the CPU stuck at C0 for 2-3s after PM_QOS back to DEFAULT
Date: Thu, 14 Aug 2014 10:11:49 +0800
Message-Id: <1407982309-4863-1-git-send-email-chuansheng.liu@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We found sometimes even after we let PM_QOS back to DEFAULT,
the CPU still stuck at C0 for 2-3s, don't do the new suitable C-state
selection immediately after received the IPI interrupt.

The code model is simply like below:
{
	pm_qos_update_request(&pm_qos, C1 - 1);
		< == Here keep all cores at C0
	...;
	pm_qos_update_request(&pm_qos, PM_QOS_DEFAULT_VALUE);
		< == Here some cores still stuck at C0 for 2-3s
}

The reason is when pm_qos come back to DEFAULT, there is IPI interrupt to
wake up the core, but when core is in poll idle state, the IPI interrupt
can not break the polling loop.

So here in the IPI callback interrupt, when currently the idle task is
running, we need to forcedly set reschedule bit to break the polling loop,
as for other non-polling idle state, IPI interrupt can break them directly,
and setting reschedule bit has no harm for them too.

With this fix, we saved about 30mV power in our android platform.

Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
---
 drivers/cpuidle/cpuidle.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index ee9df5e..9e28a13 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -532,7 +532,13 @@ EXPORT_SYMBOL_GPL(cpuidle_register);
 
 static void smp_callback(void *v)
 {
-	/* we already woke the CPU up, nothing more to do */
+	/* we already woke the CPU up, and when the corresponding
+	 * CPU is at polling idle state, we need to set the sched
+	 * bit to trigger reselect the new suitable C-state, it
+	 * will be helpful for power.
+	*/
+	if (is_idle_task(current))
+		set_tsk_need_resched(current);
 }
 
 /*
-- 
1.7.9.5

