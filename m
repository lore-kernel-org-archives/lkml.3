Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149Ab3IKURp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 16:17:45 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:58605 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757217Ab3IKURn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 16:17:43 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 3/3] cpufreq: Prevent problems in update_policy_cpu() if
 last_cpu == new_cpu
To: rjw@sisk.pl, swarren@wwwdotorg.org, viresh.kumar@linaro.org
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Thu, 12 Sep 2013 01:43:42 +0530
Message-ID: <20130911201334.7832.49714.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130911201239.7832.72612.stgit@srivatsabhat.in.ibm.com>
References: <20130911201239.7832.72612.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091120-1344-0000-0000-0000019761E7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If update_policy_cpu() is invoked with the existing policy->cpu itself
as the new-cpu parameter, then a lot of things can go terribly wrong.

In its present form, update_policy_cpu() always assumes that the new-cpu
is different from policy->cpu and invokes other functions to perform their
respective updates. And those functions implement the actual update like
this:

per_cpu(..., new_cpu) = per_cpu(..., last_cpu);
per_cpu(..., last_cpu) = NULL;

Thus, when new_cpu == last_cpu, the final NULL assignment makes the per-cpu
references vanish into thin air! (memory leak). From there, it leads to more
problems: cpufreq_stats_create_table() now doesn't find the per-cpu reference
and hence tries to create a new sysfs-group; but sysfs already had created
the group earlier, so it complains that it cannot create a duplicate filename.
In short, the repercussions of a rather innocuous invocation of
update_policy_cpu() can turn out to be pretty nasty.

Ideally update_policy_cpu() should handle this situation (new == last)
gracefully, and not lead to such severe problems. So fix it by adding an
appropriate check.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Tested-by: Stephen Warren <swarren@nvidia.com>
---

 drivers/cpufreq/cpufreq.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 247842b..d32040c 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -949,6 +949,9 @@ static void cpufreq_policy_free(struct cpufreq_policy *policy)
 
 static void update_policy_cpu(struct cpufreq_policy *policy, unsigned int cpu)
 {
+	if (cpu == policy->cpu)
+		return;
+
 	policy->last_cpu = policy->cpu;
 	policy->cpu = cpu;
 

