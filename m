Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058Ab3HPC2l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 22:28:41 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:37071 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755018Ab3HPC2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 22:28:36 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 22/34] cpufreq: pasemi: remove calls to cpufreq_notify_transition()
Date: Fri, 16 Aug 2013 07:55:19 +0530
Message-Id: <dfbad8b084e7b64ab383fcd50ee458bbe717c5c5.1376619363.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1376619363.git.viresh.kumar@linaro.org>
References: <cover.1376619363.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1376619363.git.viresh.kumar@linaro.org>
References: <cover.1376619363.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the drivers do following in their ->target_index() routines:

	struct cpufreq_freqs freqs;
	freqs.old = old freq...
	freqs.new = new freq...

	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);

	/* Change rate here */

	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);

This is replicated over all cpufreq drivers today and there doesn't exists a
good enough reason why this shouldn't be moved to cpufreq core instead.

Earlier patches have added support in cpufreq core to do cpufreq notification on
frequency change, this one removes it from this driver.

Some related minor cleanups are also done along with it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/pasemi-cpufreq.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/cpufreq/pasemi-cpufreq.c b/drivers/cpufreq/pasemi-cpufreq.c
index aaee5fa..4d69958 100644
--- a/drivers/cpufreq/pasemi-cpufreq.c
+++ b/drivers/cpufreq/pasemi-cpufreq.c
@@ -51,8 +51,6 @@
 static void __iomem *sdcpwr_mapbase;
 static void __iomem *sdcasr_mapbase;
 
-static DEFINE_MUTEX(pas_switch_mutex);
-
 /* Current astate, is used when waking up from power savings on
  * one core, in case the other core has switched states during
  * the idle time.
@@ -249,15 +247,8 @@ static int pas_cpufreq_cpu_exit(struct cpufreq_policy *policy)
 static int pas_cpufreq_target(struct cpufreq_policy *policy,
 			      unsigned int pas_astate_new)
 {
-	struct cpufreq_freqs freqs;
 	int i;
 
-	freqs.old = policy->cur;
-	freqs.new = pas_freqs[pas_astate_new].frequency;
-
-	mutex_lock(&pas_switch_mutex);
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-
 	pr_debug("setting frequency for cpu %d to %d kHz, 1/%d of max frequency\n",
 		 policy->cpu,
 		 pas_freqs[pas_astate_new].frequency,
@@ -268,10 +259,7 @@ static int pas_cpufreq_target(struct cpufreq_policy *policy,
 	for_each_online_cpu(i)
 		set_astate(i, pas_astate_new);
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-	mutex_unlock(&pas_switch_mutex);
-
-	ppc_proc_freq = freqs.new * 1000ul;
+	ppc_proc_freq = pas_freqs[pas_astate_new].frequency * 1000ul;
 	return 0;
 }
 
-- 
1.7.12.rc2.18.g61b472e

