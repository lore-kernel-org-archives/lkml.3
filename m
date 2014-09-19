Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503AbaISLpV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 07:45:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56060 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756372AbaISLpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 07:45:16 -0400
Date: Fri, 19 Sep 2014 04:44:00 -0700
From: tip-bot for Chuansheng Liu <tipbot@zytor.com>
Message-ID: <tip-c6f4459fc3ba532e896cb678e29b45cb985f82bf@git.kernel.org>
Cc: mingo@kernel.org, torvalds@linux-foundation.org, jack@suse.cz,
        geert+renesas@glider.be, peterz@infradead.org, fweisbec@gmail.com,
        akpm@linux-foundation.org, axboe@fb.com, tglx@linutronix.de,
        klamm@yandex-team.ru, chuansheng.liu@intel.com,
        linux-kernel@vger.kernel.org, hpa@zytor.com, axboe@kernel.dk,
        srivatsa.bhat@linux.vnet.ibm.com, hch@infradead.org, mhocko@suse.cz,
        paul.gortmaker@windriver.com
Reply-To: mingo@kernel.org, jack@suse.cz, torvalds@linux-foundation.org,
        peterz@infradead.org, geert+renesas@glider.be, fweisbec@gmail.com,
        akpm@linux-foundation.org, tglx@linutronix.de, axboe@fb.com,
        klamm@yandex-team.ru, chuansheng.liu@intel.com,
        linux-kernel@vger.kernel.org, hpa@zytor.com, axboe@kernel.dk,
        srivatsa.bhat@linux.vnet.ibm.com, hch@infradead.org, mhocko@suse.cz,
        paul.gortmaker@windriver.com
In-Reply-To: <1409815075-4180-2-git-send-email-chuansheng.liu@intel.com>
References: <1409815075-4180-2-git-send-email-chuansheng.liu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] smp: Add new wake_up_all_idle_cpus() function
Git-Commit-ID: c6f4459fc3ba532e896cb678e29b45cb985f82bf
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

Commit-ID:  c6f4459fc3ba532e896cb678e29b45cb985f82bf
Gitweb:     http://git.kernel.org/tip/c6f4459fc3ba532e896cb678e29b45cb985f82bf
Author:     Chuansheng Liu <chuansheng.liu@intel.com>
AuthorDate: Thu, 4 Sep 2014 15:17:54 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 19 Sep 2014 12:35:15 +0200

smp: Add new wake_up_all_idle_cpus() function

Currently kick_all_cpus_sync() can break non-polling idle cpus
thru IPI interrupts.

But sometimes we need to break the polling idle cpus immediately
to reselect the suitable c-state, also for non-idle cpus, we need
to do nothing if we try to wake up them.

Here adding one new function wake_up_all_idle_cpus() to let all cpus
out of idle based on function wake_up_if_idle().

Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: daniel.lezcano@linaro.org
Cc: rjw@rjwysocki.net
Cc: linux-pm@vger.kernel.org
Cc: changcheng.liu@intel.com
Cc: xiaoming.wang@intel.com
Cc: souvik.k.chakravarty@intel.com
Cc: luto@amacapital.net
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@fb.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Roman Gushchin <klamm@yandex-team.ru>
Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1409815075-4180-2-git-send-email-chuansheng.liu@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/smp.h |  2 ++
 kernel/smp.c        | 22 ++++++++++++++++++++++
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
