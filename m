Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932432AbaIDHdw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 03:33:52 -0400
Received: from mga14.intel.com ([192.55.52.115]:54051 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932252AbaIDHdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 03:33:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="381246287"
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: peterz@infradead.org, luto@amacapital.net, daniel.lezcano@linaro.org,
        rjw@rjwysocki.net, mingo@redhat.com
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        changcheng.liu@intel.com, xiaoming.wang@intel.com,
        souvik.k.chakravarty@intel.com, chuansheng.liu@intel.com
Subject: [PATCH 2/3] smp: Adding new function wake_up_all_idle_cpus()
Date: Thu,  4 Sep 2014 15:17:54 +0800
Message-Id: <1409815075-4180-2-git-send-email-chuansheng.liu@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1409815075-4180-1-git-send-email-chuansheng.liu@intel.com>
References: <1409815075-4180-1-git-send-email-chuansheng.liu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently kick_all_cpus_sync() can break non-polling idle cpus
thru IPI interrupts.

But sometimes we need to break the polling idle cpus immediately
to reselect the suitable c-state, also for non-idle cpus, we need
to do nothing if we try to wake up them.

Here adding one new function wake_up_all_idle_cpus() to let all cpus
out of idle based on function wake_up_if_idle().

Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
---
 include/linux/smp.h |    2 ++
 kernel/smp.c        |   22 ++++++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/include/linux/smp.h b/include/linux/smp.h
index 34347f2..93dff5f 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -100,6 +100,7 @@ int smp_call_function_any(const struct cpumask *mask,
 			  smp_call_func_t func, void *info, int wait);
 
 void kick_all_cpus_sync(void);
+void wake_up_all_idle_cpus(void);
 
 /*
  * Generic and arch helpers
@@ -148,6 +149,7 @@ smp_call_function_any(const struct cpumask *mask, smp_call_func_t func,
 }
 
 static inline void kick_all_cpus_sync(void) {  }
+static inline void wake_up_all_idle_cpus(void) {  }
 
 #endif /* !SMP */
 
diff --git a/kernel/smp.c b/kernel/smp.c
index aff8aa1..9e0d0b2 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -13,6 +13,7 @@
 #include <linux/gfp.h>
 #include <linux/smp.h>
 #include <linux/cpu.h>
+#include <linux/sched.h>
 
 #include "smpboot.h"
 
@@ -699,3 +700,24 @@ void kick_all_cpus_sync(void)
 	smp_call_function(do_nothing, NULL, 1);
 }
 EXPORT_SYMBOL_GPL(kick_all_cpus_sync);
+
+/**
+ * wake_up_all_idle_cpus - break all cpus out of idle
+ * wake_up_all_idle_cpus try to break all cpus which is in idle state even
+ * including idle polling cpus, for non-idle cpus, we will do nothing
+ * for them.
+ */
+void wake_up_all_idle_cpus(void)
+{
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
+}
+EXPORT_SYMBOL_GPL(wake_up_all_idle_cpus);
-- 
1.7.9.5

