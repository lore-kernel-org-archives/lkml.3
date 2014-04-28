Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932823AbaD1T0D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:26:03 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:34261 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932769AbaD1T0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:26:00 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v2 4/5] cpufreq, powernow-k7: Fix double invocation of
 cpufreq_freq_transition_begin/end
To: rjw@rjwysocki.net, mroos@linux.ee, viresh.kumar@linaro.org
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com
Date: Tue, 29 Apr 2014 00:24:58 +0530
Message-ID: <20140428185451.28755.11924.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20140428185331.28755.899.stgit@srivatsabhat.in.ibm.com>
References: <20140428185331.28755.899.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042818-1396-0000-0000-000004C0BC5A
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
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
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
 

