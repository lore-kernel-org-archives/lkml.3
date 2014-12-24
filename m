Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751587AbaLXGKa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 01:10:30 -0500
Received: from mail-ig0-f173.google.com ([209.85.213.173]:48635 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbaLXGK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 01:10:28 -0500
From: Doug Anderson <dianders@chromium.org>
To: rjw@rjwysocki.net, viresh.kumar@linaro.org
Cc: Heiko Stuebner <heiko@sntech.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Chris Zhong <zyw@rock-chips.com>, linux-arm-kernel@lists.infradead.org,
        Sonny Rao <sonnyrao@chromium.org>, Dylan Reid <dgreid@chromium.org>,
        Doug Anderson <dianders@chromium.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] cpufreq: suspend cpufreq governors on shutdown
Date: Tue, 23 Dec 2014 22:09:48 -0800
Message-Id: <1419401388-20171-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should stop cpufreq governors when we shut down the system.  If we
don't do this, we can end up with this deadlock:

1. cpufreq governor may be running on a CPU other than CPU0.
2. In machine_restart() we call smp_send_stop() which stops CPUs.
   If one of these CPUs was actively running a cpufreq governor
   then it may have the mutex / spinlock needed to access the main
   PMIC in the system (perhaps over I2C)
3. If a machine needs access to the main PMIC in order to shutdown
   then it will never get it since the mutex was lost when the other
   CPU stopped.
4. We'll hang (possibly eventually hitting the hard lockup detector).

Let's avoid the problem by stopping the cpufreq governor at shutdown,
which is a sensible thing to do anyway.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
Changes in v2:
- Add a comment about why we register
- Don't create cpufreq_shutdown() wrapper function

 drivers/cpufreq/cpufreq.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index a09a29c..33f3d65 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -27,6 +27,7 @@
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/suspend.h>
+#include <linux/syscore_ops.h>
 #include <linux/tick.h>
 #include <trace/events/power.h>
 
@@ -2550,6 +2551,14 @@ int cpufreq_unregister_driver(struct cpufreq_driver *driver)
 }
 EXPORT_SYMBOL_GPL(cpufreq_unregister_driver);
 
+/*
+ * Stop cpufreq at shutdown to make sure it isn't holding any locks
+ * or mutexes when secondary CPUs are halted.
+ */
+static struct syscore_ops cpufreq_syscore_ops = {
+	.shutdown = cpufreq_suspend,
+};
+
 static int __init cpufreq_core_init(void)
 {
 	if (cpufreq_disabled())
@@ -2558,6 +2567,8 @@ static int __init cpufreq_core_init(void)
 	cpufreq_global_kobject = kobject_create();
 	BUG_ON(!cpufreq_global_kobject);
 
+	register_syscore_ops(&cpufreq_syscore_ops);
+
 	return 0;
 }
 core_initcall(cpufreq_core_init);
-- 
2.2.0.rc0.207.ga3a616c

