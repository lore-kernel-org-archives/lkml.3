Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756998Ab3GKWTS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 18:19:18 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:41766 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756887Ab3GKWTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 18:19:16 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 1/8] cpufreq: Revert commit a66b2e to fix cpufreq regression
 during suspend/resume
To: rjw@sisk.pl, viresh.kumar@linaro.org, toralf.foerster@gmx.de,
        robert.jarzmik@intel.com, durgadoss.r@intel.com, tianyu.lan@intel.com,
        lantianyu1986@gmail.com, dirk.brandewie@gmail.com
Cc: stern@rowland.harvard.edu,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 12 Jul 2013 03:45:37 +0530
Message-ID: <20130711221527.547.46447.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130711221419.547.69781.stgit@srivatsabhat.in.ibm.com>
References: <20130711221419.547.69781.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071122-0260-0000-0000-0000034C43C9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit a66b2e (cpufreq: Preserve sysfs files across suspend/resume) has
unfortunately caused several things in the cpufreq subsystem to break subtly
after a suspend/resume cycle.

The intention of that patch was to retain the file permissions of the
cpufreq related sysfs files across suspend/resume. To achieve that, the commit
completely removed the calls to cpufreq_add_dev() and __cpufreq_remove_dev()
during suspend/resume transitions. But the problem is that those functions
do 2 kinds of things:
  1. Low-level initialization/tear-down that are critical to the correct
     functioning of cpufreq-core.
  2. Kobject and sysfs related initialization/teardown.

Ideally we should have reorganized the code to cleanly separate these two
responsibilities, and skipped only the sysfs related parts during
suspend/resume. Since we skipped the entire callbacks instead (which also
included some CPU and cpufreq-specific critical components), cpufreq
subsystem started behaving erratically after suspend/resume.

So revert the commit to fix the regression. We'll revisit and address the
original goal of that commit separately, since it involves quite a bit of
careful code reorganization and appears to be non-trivial.

(While reverting the commit, note that another commit f51e1eb "cpufreq:
Fix cpufreq regression after suspend/resume" already reverted part of the
original set of changes. So revert only the remaining ones).

Cc: stable@vger.kernel.org
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 drivers/cpufreq/cpufreq.c       |    4 +++-
 drivers/cpufreq/cpufreq_stats.c |    6 ++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 6a015ad..ccc6eab 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1941,13 +1941,15 @@ static int __cpuinit cpufreq_cpu_callback(struct notifier_block *nfb,
 	if (dev) {
 		switch (action) {
 		case CPU_ONLINE:
+		case CPU_ONLINE_FROZEN:
 			cpufreq_add_dev(dev, NULL);
 			break;
 		case CPU_DOWN_PREPARE:
-		case CPU_UP_CANCELED_FROZEN:
+		case CPU_DOWN_PREPARE_FROZEN:
 			__cpufreq_remove_dev(dev, NULL);
 			break;
 		case CPU_DOWN_FAILED:
+		case CPU_DOWN_FAILED_FROZEN:
 			cpufreq_add_dev(dev, NULL);
 			break;
 		}
diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index cd9e817..12225d1 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -353,13 +353,11 @@ static int __cpuinit cpufreq_stat_cpu_callback(struct notifier_block *nfb,
 		cpufreq_update_policy(cpu);
 		break;
 	case CPU_DOWN_PREPARE:
+	case CPU_DOWN_PREPARE_FROZEN:
 		cpufreq_stats_free_sysfs(cpu);
 		break;
 	case CPU_DEAD:
-		cpufreq_stats_free_table(cpu);
-		break;
-	case CPU_UP_CANCELED_FROZEN:
-		cpufreq_stats_free_sysfs(cpu);
+	case CPU_DEAD_FROZEN:
 		cpufreq_stats_free_table(cpu);
 		break;
 	}

