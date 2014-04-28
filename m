Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932854AbaD1T0F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:26:05 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:35902 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932670AbaD1T0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:26:00 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v2 3/5] cpufreq, powernow-k6: Fix double invocation of
 cpufreq_freq_transition_begin/end
To: rjw@rjwysocki.net, mroos@linux.ee, viresh.kumar@linaro.org
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com
Date: Tue, 29 Apr 2014 00:24:42 +0530
Message-ID: <20140428185434.28755.49098.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20140428185331.28755.899.stgit@srivatsabhat.in.ibm.com>
References: <20140428185331.28755.899.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042818-5490-0000-0000-0000058578A7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During frequency transitions, the cpufreq core takes the responsibility of
invoking cpufreq_freq_transition_begin() and cpufreq_freq_transition_end()
for those cpufreq drivers that define the ->target_index callback but don't
set the ASYNC_NOTIFICATION flag.

The powernow-k6 cpufreq driver falls under this category, but this driver was
invoking the _begin() and _end() APIs itself around frequency transitions,
which led to double invocation of the _begin() API. The _begin API makes
contending callers wait until the previous invocation is complete. Hence,
the powernow-k6 driver ended up waiting on itself, leading to system hangs
during boot.

Fix this by removing the calls to the _begin() and _end() APIs from the
powernow-k6 driver, since they rightly belong to the cpufreq core.

(Note that during ->exit(), the powernow-k6 driver sets the frequency
 without any help from the cpufreq core. So add explicit calls to the
 _begin() and _end() APIs around that frequency transition alone, to take
 care of that special case. Also, add a missing 'break' statement there.)

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
---

 drivers/cpufreq/powernow-k6.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/cpufreq/powernow-k6.c b/drivers/cpufreq/powernow-k6.c
index 695a68c..78904e6 100644
--- a/drivers/cpufreq/powernow-k6.c
+++ b/drivers/cpufreq/powernow-k6.c
@@ -138,22 +138,14 @@ static void powernow_k6_set_cpu_multiplier(unsigned int best_i)
 static int powernow_k6_target(struct cpufreq_policy *policy,
 		unsigned int best_i)
 {
-	struct cpufreq_freqs freqs;
 
 	if (clock_ratio[best_i].driver_data > max_multiplier) {
 		printk(KERN_ERR PFX "invalid target frequency\n");
 		return -EINVAL;
 	}
 
-	freqs.old = busfreq * powernow_k6_get_cpu_multiplier();
-	freqs.new = busfreq * clock_ratio[best_i].driver_data;
-
-	cpufreq_freq_transition_begin(policy, &freqs);
-
 	powernow_k6_set_cpu_multiplier(best_i);
 
-	cpufreq_freq_transition_end(policy, &freqs, 0);
-
 	return 0;
 }
 
@@ -229,8 +221,18 @@ static int powernow_k6_cpu_exit(struct cpufreq_policy *policy)
 	unsigned int i;
 
 	for (i = 0; (clock_ratio[i].frequency != CPUFREQ_TABLE_END); i++) {
-		if (clock_ratio[i].driver_data == max_multiplier)
+		if (clock_ratio[i].driver_data == max_multiplier) {
+			struct cpufreq_freqs freqs;
+
+			freqs.old = policy->cur;
+			freqs.new = clock_ratio[i].frequency;
+			freqs.flags = 0;
+
+			cpufreq_freq_transition_begin(policy, &freqs);
 			powernow_k6_target(policy, i);
+			cpufreq_freq_transition_end(policy, &freqs, 0);
+			break;
+		}
 	}
 	return 0;
 }

