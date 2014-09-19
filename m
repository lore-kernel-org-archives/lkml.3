Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756354AbaISLpM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 07:45:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56052 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755898AbaISLpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 07:45:09 -0400
Date: Fri, 19 Sep 2014 04:44:13 -0700
From: tip-bot for Chuansheng Liu <tipbot@zytor.com>
Message-ID: <tip-2ed903c5485bad0eafdd3d59ff993598736e4f31@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de, rjw@rjwysocki.net, daniel.lezcano@linaro.org,
        chuansheng.liu@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de, rjw@rjwysocki.net, daniel.lezcano@linaro.org,
        chuansheng.liu@intel.com
In-Reply-To: <1409815075-4180-3-git-send-email-chuansheng.liu@intel.com>
References: <1409815075-4180-3-git-send-email-chuansheng.liu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] cpuidle: Use wake_up_all_idle_cpus()
  to wake up all idle cpus
Git-Commit-ID: 2ed903c5485bad0eafdd3d59ff993598736e4f31
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2ed903c5485bad0eafdd3d59ff993598736e4f31
Gitweb:     http://git.kernel.org/tip/2ed903c5485bad0eafdd3d59ff993598736e4f31
Author:     Chuansheng Liu <chuansheng.liu@intel.com>
AuthorDate: Thu, 4 Sep 2014 15:17:55 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 19 Sep 2014 12:35:16 +0200

cpuidle: Use wake_up_all_idle_cpus() to wake up all idle cpus

Currently kick_all_cpus_sync() or smp_call_function() can not
break the polling idle cpu immediately.

Instead using wake_up_all_idle_cpus() which can wake up the polling idle
cpu quickly is much more helpful for power.

Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: linux-pm@vger.kernel.org
Cc: changcheng.liu@intel.com
Cc: xiaoming.wang@intel.com
Cc: souvik.k.chakravarty@intel.com
Cc: luto@amacapital.net
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: linux-pm@vger.kernel.org
Link: http://lkml.kernel.org/r/1409815075-4180-3-git-send-email-chuansheng.liu@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 drivers/cpuidle/cpuidle.c | 9 ++-------
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
 
