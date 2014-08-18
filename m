Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164AbaHRIwG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 04:52:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:55964 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100AbaHRIwC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 04:52:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,885,1400050800"; 
   d="scan'208";a="559928771"
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: luto@amacapital.net, peterz@infradead.org, daniel.lezcano@linaro.org,
        rjw@rjwysocki.net, mingo@redhat.com
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        changcheng.liu@intel.com, xiaoming.wang@intel.com,
        souvik.k.chakravarty@intel.com, chuansheng.liu@intel.com
Subject: [PATCH 3/3] cpuidle: Using the wake_up_all_cpus() to wake up all idle cpus
Date: Mon, 18 Aug 2014 16:37:32 +0800
Message-Id: <1408351052-25075-3-git-send-email-chuansheng.liu@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1408351052-25075-1-git-send-email-chuansheng.liu@intel.com>
References: <1408351052-25075-1-git-send-email-chuansheng.liu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently kick_all_cpus_sync() or smp_call_function() can not
break the polling idle cpu immediately.

Here using wake_up_all_cpus() which can wake up the polling idle
cpu quickly is much helpful for power.

Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
---
 drivers/cpuidle/cpuidle.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index ee9df5e..56d5c4d 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -223,7 +223,7 @@ void cpuidle_uninstall_idle_handler(void)
 {
 	if (enabled_devices) {
 		initialized = 0;
-		kick_all_cpus_sync();
+		wake_up_all_cpus();
 	}
 }
 
@@ -530,11 +530,6 @@ EXPORT_SYMBOL_GPL(cpuidle_register);
 
 #ifdef CONFIG_SMP
 
-static void smp_callback(void *v)
-{
-	/* we already woke the CPU up, nothing more to do */
-}
-
 /*
  * This function gets called when a part of the kernel has a new latency
  * requirement.  This means we need to get all processors out of their C-state,
@@ -544,7 +539,7 @@ static void smp_callback(void *v)
 static int cpuidle_latency_notify(struct notifier_block *b,
 		unsigned long l, void *v)
 {
-	smp_call_function(smp_callback, NULL, 1);
+	wake_up_all_cpus();
 	return NOTIFY_OK;
 }
 
-- 
1.7.9.5

