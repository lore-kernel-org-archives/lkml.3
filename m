Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757024Ab3GKWT3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 18:19:29 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:34990 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757004Ab3GKWT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 18:19:27 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 2/8] cpufreq: Fix misplaced call to cpufreq_update_policy()
To: rjw@sisk.pl, viresh.kumar@linaro.org, toralf.foerster@gmx.de,
        robert.jarzmik@intel.com, durgadoss.r@intel.com, tianyu.lan@intel.com,
        lantianyu1986@gmail.com, dirk.brandewie@gmail.com
Cc: stern@rowland.harvard.edu,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 12 Jul 2013 03:45:56 +0530
Message-ID: <20130711221553.547.56787.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130711221419.547.69781.stgit@srivatsabhat.in.ibm.com>
References: <20130711221419.547.69781.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071122-5490-0000-0000-000003CD7EA3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The call to cpufreq_update_policy() is placed in the CPU hotplug callback
of cpufreq_stats, which has a higher priority than the CPU hotplug callback
of cpufreq-core. As a result, during CPU_ONLINE/CPU_ONLINE_FROZEN, we end up
calling cpufreq_update_policy() *before* calling cpufreq_add_dev() !
And for uninitialized CPUs, it just returns silently, not doing anything.

To add to it, cpufreq_stats is not even the right place to call
cpufreq_update_policy() to begin with. The cpufreq core ought to handle
this in its own callback, from an elegance/relevance perspective.

So move the invocation of cpufreq_update_policy() to cpufreq_cpu_callback,
and place it *after* cpufreq_add_dev().

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 drivers/cpufreq/cpufreq.c       |    1 +
 drivers/cpufreq/cpufreq_stats.c |    6 ------
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index ccc6eab..f8c3100 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1943,6 +1943,7 @@ static int __cpuinit cpufreq_cpu_callback(struct notifier_block *nfb,
 		case CPU_ONLINE:
 		case CPU_ONLINE_FROZEN:
 			cpufreq_add_dev(dev, NULL);
+			cpufreq_update_policy(cpu);
 			break;
 		case CPU_DOWN_PREPARE:
 		case CPU_DOWN_PREPARE_FROZEN:
diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index 12225d1..a3e7475 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -348,10 +348,6 @@ static int __cpuinit cpufreq_stat_cpu_callback(struct notifier_block *nfb,
 	unsigned int cpu = (unsigned long)hcpu;
 
 	switch (action) {
-	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
-		cpufreq_update_policy(cpu);
-		break;
 	case CPU_DOWN_PREPARE:
 	case CPU_DOWN_PREPARE_FROZEN:
 		cpufreq_stats_free_sysfs(cpu);
@@ -390,8 +386,6 @@ static int __init cpufreq_stats_init(void)
 		return ret;
 
 	register_hotcpu_notifier(&cpufreq_stat_cpu_notifier);
-	for_each_online_cpu(cpu)
-		cpufreq_update_policy(cpu);
 
 	ret = cpufreq_register_notifier(&notifier_trans_block,
 				CPUFREQ_TRANSITION_NOTIFIER);

