Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567AbaLQPwk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 10:52:40 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:44465 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbaLQPvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 10:51:40 -0500
From: Nishanth Menon <nm@ti.com>
To: Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH] cpufreq: Stop BUGing the system
Date: Wed, 17 Dec 2014 09:51:35 -0600
Message-ID: <1418831495-26958-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CPUFRreq subsystem is not a system catastrophic failure point.
Failures in these cases DONOT need complete system shutdown with BUG.
just refuse to let cpufreq function should be good enough.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 drivers/cpufreq/cpufreq.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index a09a29c..a5aa2fa 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -281,7 +281,10 @@ static inline void adjust_jiffies(unsigned long val, struct cpufreq_freqs *ci)
 static void __cpufreq_notify_transition(struct cpufreq_policy *policy,
 		struct cpufreq_freqs *freqs, unsigned int state)
 {
-	BUG_ON(irqs_disabled());
+	if (irqs_disabled()) {
+		WARN(1, "IRQs disabled!\n");
+		return;
+	}
 
 	if (cpufreq_disabled())
 		return;
@@ -1253,9 +1256,12 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 			/*
 			 * Reaching here after boot in a few seconds may not
 			 * mean that system will remain stable at "unknown"
-			 * frequency for longer duration. Hence, a BUG_ON().
+			 * frequency for longer duration. Hence, a WARN().
 			 */
-			BUG_ON(ret);
+			if (ret) {
+				WARN(1, "SYSTEM operating at invalid freq %u", policy->cur);
+				goto err_out_unregister;
+			}
 			pr_warn("%s: CPU%d: Unlisted initial frequency changed to: %u KHz\n",
 				__func__, policy->cpu, policy->cur);
 		}
@@ -2556,7 +2562,10 @@ static int __init cpufreq_core_init(void)
 		return -ENODEV;
 
 	cpufreq_global_kobject = kobject_create();
-	BUG_ON(!cpufreq_global_kobject);
+	if (!cpufreq_global_kobject) {
+		WARN(1, "No memory for cpufreq_global_kobject\n");
+		return -ENOMEM;
+	}
 
 	return 0;
 }
-- 
1.7.9.5

