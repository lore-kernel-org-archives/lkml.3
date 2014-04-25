Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbaDYITr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 04:19:47 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:37053 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbaDYITV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 04:19:21 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 3/3] cpufreq, powernow-k7: Fix double invocation of
 cpufreq_freq_transition_begin/end
To: rjw@rjwysocki.net, mroos@linux.ee, viresh.kumar@linaro.org
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com
Date: Fri, 25 Apr 2014 13:48:35 +0530
Message-ID: <20140425081830.10258.10979.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20140425081728.10258.63980.stgit@srivatsabhat.in.ibm.com>
References: <20140425081728.10258.63980.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042508-2674-0000-0000-00000DF56D28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During frequency transitions, the cpufreq core takes the responsibility of
invoking cpufreq_freq_transition_begin() and cpufreq_freq_transition_end()
for those cpufreq drivers that define the ->target_index callback but don't
set the ASYNC_NOTIFICATION flag.

The powernow-k7 cpufreq driver falls under this category, but this driver was
invoking the _begin() and _end() APIs itself around frequency transitions,
which led to double invocation of the _begin() API. The _begin API makes
contending callers wait until the previous invocation is complete. Hence,
the powernow-k7 driver ended up waiting on itself, leading to system hangs
during boot.

Fix this by removing the calls to the _begin() and _end() APIs from the
powernow-k7 driver, since they rightly belong to the cpufreq core.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 drivers/cpufreq/powernow-k7.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/cpufreq/powernow-k7.c b/drivers/cpufreq/powernow-k7.c
index f911645..e61e224 100644
--- a/drivers/cpufreq/powernow-k7.c
+++ b/drivers/cpufreq/powernow-k7.c
@@ -269,8 +269,6 @@ static int powernow_target(struct cpufreq_policy *policy, unsigned int index)
 
 	freqs.new = powernow_table[index].frequency;
 
-	cpufreq_freq_transition_begin(policy, &freqs);
-
 	/* Now do the magic poking into the MSRs.  */
 
 	if (have_a0 == 1)	/* A0 errata 5 */
@@ -290,8 +288,6 @@ static int powernow_target(struct cpufreq_policy *policy, unsigned int index)
 	if (have_a0 == 1)
 		local_irq_enable();
 
-	cpufreq_freq_transition_end(policy, &freqs, 0);
-
 	return 0;
 }
 

