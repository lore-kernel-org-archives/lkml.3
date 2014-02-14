Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238AbaBNLBG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 06:01:06 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:64344 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbaBNLA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 06:00:59 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pierre-list@ossman.eu, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 2/2] cpufreq: don't call cpufreq_update_policy() on CPU addition
Date: Fri, 14 Feb 2014 16:30:41 +0530
Message-Id: <8f2fc4d6240b567fdb69a0b47f073d174b7ef9b2.1392375504.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <15ccc0609cb9ee3db0ad3a95b29bf69d11ea197c.1392375504.git.viresh.kumar@linaro.org>
References: <15ccc0609cb9ee3db0ad3a95b29bf69d11ea197c.1392375504.git.viresh.kumar@linaro.org>
In-Reply-To: <15ccc0609cb9ee3db0ad3a95b29bf69d11ea197c.1392375504.git.viresh.kumar@linaro.org>
References: <15ccc0609cb9ee3db0ad3a95b29bf69d11ea197c.1392375504.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpufreq_update_policy() is called from two places currently. From a workqueue
handled queued from cpufreq_bp_resume() for boot CPU and from
cpufreq_cpu_callback() whenever a CPU is added.

The first one makes sure that boot CPU is running on the frequency present in
policy->cpu. But we don't really need a call from cpufreq_cpu_callback(),
because we always call cpufreq_driver->init() (which will set policy->cur
correctly) whenever first CPU of any policy is added back. And so every policy
structure is guaranteed to have the right frequency in policy->cur.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 383362b..b6eb4ed 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -2194,7 +2194,6 @@ static int cpufreq_cpu_callback(struct notifier_block *nfb,
 		switch (action & ~CPU_TASKS_FROZEN) {
 		case CPU_ONLINE:
 			__cpufreq_add_dev(dev, NULL, frozen);
-			cpufreq_update_policy(cpu);
 			break;
 
 		case CPU_DOWN_PREPARE:
-- 
1.7.12.rc2.18.g61b472e

