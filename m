Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932510AbaIDHeH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 03:34:07 -0400
Received: from mga14.intel.com ([192.55.52.115]:34371 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932252AbaIDHeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 03:34:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="381246371"
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: peterz@infradead.org, luto@amacapital.net, daniel.lezcano@linaro.org,
        rjw@rjwysocki.net, mingo@redhat.com
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        changcheng.liu@intel.com, xiaoming.wang@intel.com,
        souvik.k.chakravarty@intel.com, chuansheng.liu@intel.com
Subject: [PATCH 3/3] cpuidle: Using the wake_up_all_idle_cpus() to wake up all idle cpus
Date: Thu,  4 Sep 2014 15:17:55 +0800
Message-Id: <1409815075-4180-3-git-send-email-chuansheng.liu@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1409815075-4180-1-git-send-email-chuansheng.liu@intel.com>
References: <1409815075-4180-1-git-send-email-chuansheng.liu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently kick_all_cpus_sync() or smp_call_function() can not
break the polling idle cpu immediately.

Here using wake_up_all_idle_cpus() which can wake up the polling idle
cpu quickly is much helpful for power.

Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
---
 drivers/cpuidle/cpuidle.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index ee9df5e..d31e04c 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -223,7 +223,7 @@ void cpuidle_uninstall_idle_handler(void)
 {
 	if (enabled_devices) {
 		initialized = 0;
-		kick_all_cpus_sync();
+		wake_up_all_idle_cpus();
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
+	wake_up_all_idle_cpus();
 	return NOTIFY_OK;
 }
 
-- 
1.7.9.5

