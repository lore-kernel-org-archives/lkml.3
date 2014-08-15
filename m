Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795AbaHOHTV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 03:19:21 -0400
Received: from mga03.intel.com ([143.182.124.21]:36866 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182AbaHOHTT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 03:19:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,868,1400050800"; 
   d="scan'208";a="469012697"
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: peterz@infradead.org, luto@amacapital.net, daniel.lezcano@linaro.org,
        rjw@rjwysocki.net, mingo@redhat.com
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        changcheng.liu@intel.com, xiaoming.wang@intel.com,
        souvik.k.chakravarty@intel.com,
        Chuansheng Liu <chuansheng.liu@intel.com>
Subject: [PATCH 2/3] smp: re-implement the kick_all_cpus_sync() with wake_up_if_idle()
Date: Fri, 15 Aug 2014 15:01:24 +0800
Message-Id: <1408086085-16691-2-git-send-email-chuansheng.liu@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1408086085-16691-1-git-send-email-chuansheng.liu@intel.com>
References: <1408086085-16691-1-git-send-email-chuansheng.liu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently using smp_call_function() just woke up the corresponding
cpu, but can not break the polling idle loop.

Here using the new sched API wake_up_if_idle() to implement it.

Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
---
 kernel/smp.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index aff8aa1..0b647c3 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -13,6 +13,7 @@
 #include <linux/gfp.h>
 #include <linux/smp.h>
 #include <linux/cpu.h>
+#include <linux/sched.h>
 
 #include "smpboot.h"
 
@@ -677,10 +678,6 @@ void on_each_cpu_cond(bool (*cond_func)(int cpu, void *info),
 }
 EXPORT_SYMBOL(on_each_cpu_cond);
 
-static void do_nothing(void *unused)
-{
-}
-
 /**
  * kick_all_cpus_sync - Force all cpus out of idle
  *
@@ -694,8 +691,15 @@ static void do_nothing(void *unused)
  */
 void kick_all_cpus_sync(void)
 {
-	/* Make sure the change is visible before we kick the cpus */
-	smp_mb();
-	smp_call_function(do_nothing, NULL, 1);
+	int cpu;
+
+	preempt_disable();
+	for_each_online_cpu(cpu) {
+		if (cpu == smp_processor_id())
+			continue;
+
+		wake_up_if_idle(cpu);
+	}
+	preempt_enable();
 }
 EXPORT_SYMBOL_GPL(kick_all_cpus_sync);
-- 
1.7.9.5

