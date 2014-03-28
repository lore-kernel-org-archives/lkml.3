Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138AbaC1UL4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 16:11:56 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:38132 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101AbaC1ULv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 16:11:51 -0400
From: "Gautham R. Shenoy" <ego@linux.vnet.ibm.com>
To: Viresh Kumar <viresh.kumar@linaro.org>, rjw@rjwysocki.net,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev@ozlabs.org, Linux PM list <linux-pm@vger.kernel.org>,
        svaidy@linux.vnet.ibm.com, srivatsa.bhat@linux.vnet.ibm.com,
        Anton Blanchard <anton@samba.org>, cpufreq@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gautham R. Shenoy" <ego@linux.vnet.ibm.com>
Subject: [PATCH v5 3/3] powernv,cpufreq: Use cpufreq_frequency_table.driver_data to store pstate ids
Date: Sat, 29 Mar 2014 01:41:24 +0530
Message-Id: <1396037484-23907-4-git-send-email-ego@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1396037484-23907-1-git-send-email-ego@linux.vnet.ibm.com>
References: <1396037484-23907-1-git-send-email-ego@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032820-2674-0000-0000-00000D61C372
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Gautham R. Shenoy" <ego@linux.vnet.ibm.com>

The .driver_data field in the cpufreq_frequency_table was supposed to
be private to the drivers. However at some later point, it was being
used to indicate if the particular frequency in the table is the
BOOST_FREQUENCY. After patches [1] and [2], the .driver_data is once
again private to the driver. Thus we can safely use
cpufreq_frequency_table.driver_data to store pstate_ids instead of
having to maintain a separate array powernv_pstate_ids[] for this
purpose.

[1]:
  Subject: cpufreq: don't print value of .driver_data from core
  From   : Viresh Kumar <viresh.kumar@ linaro.org>
  url    : http://marc.info/?l=linux-pm&m=139601421504709&w=2

[2]:
  Subject: cpufreq: create another field .flags in cpufreq_frequency_table
  From   : Viresh Kumar <viresh.kumar@linaro.org>
  url    : http://marc.info/?l=linux-pm&m=139601416804702&w=2

Signed-off-by: Gautham R. Shenoy <ego@linux.vnet.ibm.com>
---
 drivers/cpufreq/powernv-cpufreq.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/cpufreq/powernv-cpufreq.c b/drivers/cpufreq/powernv-cpufreq.c
index e1e5197..9edccc6 100644
--- a/drivers/cpufreq/powernv-cpufreq.c
+++ b/drivers/cpufreq/powernv-cpufreq.c
@@ -33,7 +33,6 @@
 #define POWERNV_MAX_PSTATES	256
 
 static struct cpufreq_frequency_table powernv_freqs[POWERNV_MAX_PSTATES+1];
-static int powernv_pstate_ids[POWERNV_MAX_PSTATES+1];
 
 /*
  * Note: The set of pstates consists of contiguous integers, the
@@ -112,7 +111,7 @@ static int init_powernv_pstates(void)
 
 		pr_debug("PState id %d freq %d MHz\n", id, freq);
 		powernv_freqs[i].frequency = freq * 1000; /* kHz */
-		powernv_pstate_ids[i] = id;
+		powernv_freqs[i].driver_data = id;
 	}
 	/* End of list marker entry */
 	powernv_freqs[i].frequency = CPUFREQ_TABLE_END;
@@ -283,7 +282,7 @@ static int powernv_cpufreq_target_index(struct cpufreq_policy *policy,
 {
 	struct powernv_smp_call_data freq_data;
 
-	freq_data.pstate_id = powernv_pstate_ids[new_index];
+	freq_data.pstate_id = powernv_freqs[new_index].driver_data;
 
 	/*
 	 * Use smp_call_function to send IPI and execute the
-- 
1.8.3.1

