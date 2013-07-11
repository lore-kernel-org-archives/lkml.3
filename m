Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293Ab3GKWVi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 18:21:38 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:40038 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757261Ab3GKWUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 18:20:49 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 8/8] cpufreq: Perform light-weight init/teardown during
 suspend/resume
To: rjw@sisk.pl, viresh.kumar@linaro.org, toralf.foerster@gmx.de,
        robert.jarzmik@intel.com, durgadoss.r@intel.com, tianyu.lan@intel.com,
        lantianyu1986@gmail.com, dirk.brandewie@gmail.com
Cc: stern@rowland.harvard.edu,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 12 Jul 2013 03:47:19 +0530
Message-ID: <20130711221717.547.54461.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130711221419.547.69781.stgit@srivatsabhat.in.ibm.com>
References: <20130711221419.547.69781.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071122-1618-0000-0000-0000043FF8A9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have the infrastructure to perform a light-weight init/tear-down,
use that in the cpufreq CPU hotplug notifier when invoked from the
suspend/resume path.

This also ensures that the file permissions of the cpufreq sysfs files are
preserved across suspend/resume, something which commit a66b2e (cpufreq:
Preserve sysfs files across suspend/resume) originally intended to do, but
had to be reverted due to other problems.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 drivers/cpufreq/cpufreq.c       |   18 +++++++++++-------
 drivers/cpufreq/cpufreq_stats.c |    2 --
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 15ced5f..c7f59e8 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -2030,22 +2030,26 @@ static int __cpuinit cpufreq_cpu_callback(struct notifier_block *nfb,
 {
 	unsigned int cpu = (unsigned long)hcpu;
 	struct device *dev;
+	bool frozen = false;
 
 	dev = get_cpu_device(cpu);
 	if (dev) {
-		switch (action) {
+
+		if (action & CPU_TASKS_FROZEN)
+			frozen = true;
+
+		switch (action & ~CPU_TASKS_FROZEN) {
 		case CPU_ONLINE:
-		case CPU_ONLINE_FROZEN:
-			cpufreq_add_dev(dev, NULL);
+			__cpufreq_add_dev(dev, NULL, frozen);
 			cpufreq_update_policy(cpu);
 			break;
+
 		case CPU_DOWN_PREPARE:
-		case CPU_DOWN_PREPARE_FROZEN:
-			__cpufreq_remove_dev(dev, NULL, false);
+			__cpufreq_remove_dev(dev, NULL, frozen);
 			break;
+
 		case CPU_DOWN_FAILED:
-		case CPU_DOWN_FAILED_FROZEN:
-			cpufreq_add_dev(dev, NULL);
+			__cpufreq_add_dev(dev, NULL, frozen);
 			break;
 		}
 	}
diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index a3e7475..4e1eb3f 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -349,11 +349,9 @@ static int __cpuinit cpufreq_stat_cpu_callback(struct notifier_block *nfb,
 
 	switch (action) {
 	case CPU_DOWN_PREPARE:
-	case CPU_DOWN_PREPARE_FROZEN:
 		cpufreq_stats_free_sysfs(cpu);
 		break;
 	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
 		cpufreq_stats_free_table(cpu);
 		break;
 	}

