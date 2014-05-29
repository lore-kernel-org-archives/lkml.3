Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933483AbaE2IQG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 04:16:06 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:44299 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932560AbaE2IP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 04:15:58 -0400
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org
Cc: Zhang Rui <rui.zhang@intel.com>, linux-kernel@vger.kernel.org,
        amit.kachhap@gmail.com, edubezval@gmail.com, rjw@rjwysocki.net,
        linux-arm-kernel@lists.infradead.org, lenb@kernel.org
Subject: [PATCH v1 1/6] thermal: cpu_cooling: Fix the notification mechanism by using per cpu structure
Date: Thu, 29 May 2014 13:45:29 +0530
Message-Id: <1401351334-11210-2-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1401351334-11210-1-git-send-email-amit.daniel@samsung.com>
References: <1401351334-11210-1-git-send-email-amit.daniel@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the notification data is supplied to the thermal notifiers using
a single global pointer. This method will have race condition if cpu cooling
interfaces are used by more than 1 clients (more than 1 cdev) to cause cpufreq
clipping. Also the notifier data is presented as per cpu cpufreq policy
structure. This was needed as same cpu is used later in thermal cpufreq handler
function.

Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 drivers/thermal/cpu_cooling.c |   38 +++++++++++++++-----------------------
 1 files changed, 15 insertions(+), 23 deletions(-)

diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
index 4246262..16388b0 100644
--- a/drivers/thermal/cpu_cooling.c
+++ b/drivers/thermal/cpu_cooling.c
@@ -58,7 +58,7 @@ static unsigned int cpufreq_dev_count;
 
 /* notify_table passes value to the CPUFREQ_ADJUST callback function. */
 #define NOTIFY_INVALID NULL
-static struct cpufreq_cooling_device *notify_device;
+static DEFINE_PER_CPU(struct cpufreq_cooling_device *, notify_device);
 
 /**
  * get_idr - function to get a unique id.
@@ -98,23 +98,6 @@ static void release_idr(struct idr *idr, int id)
 
 /* Below code defines functions to be used for cpufreq as cooling device */
 
-/**
- * is_cpufreq_valid - function to check frequency transitioning capability.
- * @cpu: cpu for which check is needed.
- *
- * This function will check the current state of the system if
- * it is capable of changing the frequency for a given @cpu.
- *
- * Return: 0 if the system is not currently capable of changing
- * the frequency of given cpu. !0 in case the frequency is changeable.
- */
-static int is_cpufreq_valid(int cpu)
-{
-	struct cpufreq_policy policy;
-
-	return !cpufreq_get_policy(&policy, cpu);
-}
-
 enum cpufreq_cooling_property {
 	GET_LEVEL,
 	GET_FREQ,
@@ -294,11 +277,18 @@ static int cpufreq_apply_cooling(struct cpufreq_cooling_device *cpufreq_device,
 
 	cpufreq_device->cpufreq_state = cooling_state;
 	cpufreq_device->cpufreq_val = clip_freq;
-	notify_device = cpufreq_device;
 
 	for_each_cpu(cpuid, mask) {
-		if (is_cpufreq_valid(cpuid))
+		if (cpufreq_get_policy(&policy, cpu) == 0) {
+			/*
+			 * Store the notification data in the cpu pointed by
+			 * cpufreq policy structure. This is needed as this cpu
+			 * will be used later to fetch correct data pointer.
+			 */
+			per_cpu(notify_device, policy.cpu) = cpufreq_device;
 			cpufreq_update_policy(cpuid);
+			per_cpu(notify_device, policy.cpu) = NOTIFY_INVALID;
+		}
 	}
 
 	notify_device = NOTIFY_INVALID;
@@ -323,12 +313,14 @@ static int cpufreq_thermal_notifier(struct notifier_block *nb,
 {
 	struct cpufreq_policy *policy = data;
 	unsigned long max_freq = 0;
+	struct cpufreq_cooling_device *cpufreq_device
+				= per_cpu(notify_device, policy->cpu);
 
-	if (event != CPUFREQ_ADJUST || notify_device == NOTIFY_INVALID)
+	if (event != CPUFREQ_ADJUST || cpufreq_device == NOTIFY_INVALID)
 		return 0;
 
-	if (cpumask_test_cpu(policy->cpu, &notify_device->allowed_cpus))
-		max_freq = notify_device->cpufreq_val;
+	if (cpumask_test_cpu(policy->cpu, &cpufreq_device->allowed_cpus))
+		max_freq = cpufreq_device->cpufreq_val;
 	else
 		return 0;
 
-- 
1.7.1

