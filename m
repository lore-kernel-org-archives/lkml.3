Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849Ab3IFT5q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 15:57:46 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:55211 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab3IFT5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 15:57:44 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 3/5] cpufreq: Synchronize the cpufreq store_*() routines with
 CPU hotplug
To: rjw@sisk.pl, sboyd@codeaurora.org, viresh.kumar@linaro.org
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sat, 07 Sep 2013 01:23:43 +0530
Message-ID: <20130906195337.26919.1257.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130906195206.26919.20884.stgit@srivatsabhat.in.ibm.com>
References: <20130906195206.26919.20884.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090619-8236-0000-0000-00000180E4A6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The functions that are used to write to cpufreq sysfs files (such as
store_scaling_max_freq()) are not hotplug safe. They can race with CPU
hotplug tasks and lead to problems such as trying to acquire an already
destroyed timer-mutex etc.

Eg:

    __cpufreq_remove_dev()
     __cpufreq_governor(policy, CPUFREQ_GOV_STOP);
       policy->governor->governor(policy, CPUFREQ_GOV_STOP);
        cpufreq_governor_dbs()
         case CPUFREQ_GOV_STOP:
          mutex_destroy(&cpu_cdbs->timer_mutex)
          cpu_cdbs->cur_policy = NULL;
      <PREEMPT>
    store()
     __cpufreq_set_policy()
      __cpufreq_governor(policy, CPUFREQ_GOV_LIMITS);
        policy->governor->governor(policy, CPUFREQ_GOV_LIMITS);
         case CPUFREQ_GOV_LIMITS:
          mutex_lock(&cpu_cdbs->timer_mutex); <-- Warning (destroyed mutex)
           if (policy->max < cpu_cdbs->cur_policy->cur) <- cur_policy == NULL


So use get_online_cpus()/put_online_cpus() in the store_*() functions, to
synchronize with CPU hotplug. However, there is an additional point to note
here: some parts of the CPU teardown in the cpufreq subsystem are done in
the CPU_POST_DEAD stage, with cpu_hotplug.lock *released*. So, using the
get/put_online_cpus() functions alone is insufficient; we should also ensure
that we don't race with those latter steps in the hotplug sequence. We can
easily achieve this by checking if the CPU is online before proceeding with
the store, since the CPU would have been marked offline by the time the
CPU_POST_DEAD notifiers are executed.

Reported-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 drivers/cpufreq/cpufreq.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index a6fe3fd..c2eb413 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -717,8 +717,13 @@ static ssize_t store(struct kobject *kobj, struct attribute *attr,
 	struct freq_attr *fattr = to_attr(attr);
 	ssize_t ret = -EINVAL;
 
+	get_online_cpus();
+
+	if (!cpu_online(policy->cpu))
+		goto unlock;
+
 	if (!down_read_trylock(&cpufreq_rwsem))
-		goto exit;
+		goto unlock;
 
 	if (lock_policy_rwsem_write(policy->cpu) < 0)
 		goto up_read;
@@ -732,7 +737,9 @@ static ssize_t store(struct kobject *kobj, struct attribute *attr,
 
 up_read:
 	up_read(&cpufreq_rwsem);
-exit:
+unlock:
+	put_online_cpus();
+
 	return ret;
 }
 

