Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150AbaDYHw3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 03:52:29 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:53578 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbaDYHw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 03:52:26 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net, mroos@linux.ee
Cc: linaro-kernel@lists.linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] cpufreq: Set CPUFREQ_ASYNC_NOTIFICATION for drivers handling notification
Date: Fri, 25 Apr 2014 13:22:04 +0530
Message-Id: <c6c53fee017018869c7524a487688edf902c1413.1398412138.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CPUFREQ_ASYNC_NOTIFICATION was initially designed for drivers which don't want
core to send notifications for them as they wouldn't finish frequency
transitions in ->target_index().

But there were other kinds of drivers as well who don't have straight forward
implementations of ->target_index() routines and wanted to handle notifications
themselves.

Patch: 7dbf694 (cpufreq: distinguish drivers that do asynchronous notifications)
missed addressing these drivers and that caused these drivers to send double
notifications. Initially cpufreq core sends a notification for these and then
the drivers themselves.

It might not cause a big problem for kernels (3.13/3.14) which doesn't have this
patch in: 12478cf (cpufreq: Make sure frequency transitions are serialized), as
this came in v3.15-rc1. Reason being, we are sending an extra notification for
the same frequency, and so other kernel code that depends on it shouldn't behave
badly.

Above patch broke things as it forces serialization of notifications, so that we
aren't configuring same hardware registers simultaneously.

Reported-by: Meelis Roos <mroos@linux.ee>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
Hi Rafael,

This one is for rc3 surely :)

Also, as I mentioned above it might not create any problems for 3.13 and 3.14.
And so I havne't cc'd stable for those kernels. Please add them in case you feel
its still better to get it fixed.

 drivers/cpufreq/longhaul.c    | 1 +
 drivers/cpufreq/powernow-k6.c | 1 +
 drivers/cpufreq/powernow-k7.c | 1 +
 3 files changed, 3 insertions(+)

diff --git a/drivers/cpufreq/longhaul.c b/drivers/cpufreq/longhaul.c
index d00e5d1..41f3d28 100644
--- a/drivers/cpufreq/longhaul.c
+++ b/drivers/cpufreq/longhaul.c
@@ -909,6 +909,7 @@ static int longhaul_cpu_init(struct cpufreq_policy *policy)
 }
 
 static struct cpufreq_driver longhaul_driver = {
+	.flags	= CPUFREQ_ASYNC_NOTIFICATION,
 	.verify	= cpufreq_generic_frequency_table_verify,
 	.target_index = longhaul_target,
 	.get	= longhaul_get,
diff --git a/drivers/cpufreq/powernow-k6.c b/drivers/cpufreq/powernow-k6.c
index 49f120e..080bbb9 100644
--- a/drivers/cpufreq/powernow-k6.c
+++ b/drivers/cpufreq/powernow-k6.c
@@ -242,6 +242,7 @@ static unsigned int powernow_k6_get(unsigned int cpu)
 }
 
 static struct cpufreq_driver powernow_k6_driver = {
+	.flags		= CPUFREQ_ASYNC_NOTIFICATION,
 	.verify		= cpufreq_generic_frequency_table_verify,
 	.target_index	= powernow_k6_target,
 	.init		= powernow_k6_cpu_init,
diff --git a/drivers/cpufreq/powernow-k7.c b/drivers/cpufreq/powernow-k7.c
index f911645..fccfc25 100644
--- a/drivers/cpufreq/powernow-k7.c
+++ b/drivers/cpufreq/powernow-k7.c
@@ -677,6 +677,7 @@ static int powernow_cpu_exit(struct cpufreq_policy *policy)
 }
 
 static struct cpufreq_driver powernow_driver = {
+	.flags		= CPUFREQ_ASYNC_NOTIFICATION,
 	.verify		= cpufreq_generic_frequency_table_verify,
 	.target_index	= powernow_target,
 	.get		= powernow_get,
-- 
1.7.12.rc2.18.g61b472e

