Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790AbaF3RAa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 13:00:30 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:53449 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754756AbaF3Q7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 12:59:48 -0400
From: Stratos Karafotis <stratosk@semaphore.gr>
To: rjw@rjwysocki.net, viresh.kumar@linaro.org
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] cpufreq: ondemand: Eliminate the deadband effect
Date: Mon, 30 Jun 2014 19:59:34 +0300
Message-Id: <1404147574-17422-3-git-send-email-stratosk@semaphore.gr>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1404147574-17422-1-git-send-email-stratosk@semaphore.gr>
References: <1404147574-17422-1-git-send-email-stratosk@semaphore.gr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, ondemand calculates the target frequency proportional to load
using the formula:
	Target frequency = C * load
	where C = policy->cpuinfo.max_freq / 100

Though, in many cases, the minimum available frequency is pretty high and
the above calculation introduces a dead band from load 0 to
100 * policy->cpuinfo.min_freq / policy->cpuinfo.max_freq where the target
frequency is always calculated to less than policy->cpuinfo.min_freq and
the minimum frequency is selected.

For example: on Intel i7-3770 @ 3.4GHz the policy->cpuinfo.min_freq = 1600000
and the policy->cpuinfo.max_freq = 3400000 (without turbo). Thus, the CPU
starts to scale up at a load above 47.
On quad core 1500MHz Krait the policy->cpuinfo.min_freq = 384000
and the policy->cpuinfo.max_freq = 1512000. Thus, the CPU starts to scale
at load above 25.

Change the calculation of target frequency to eliminate the above effect using
the formula:

	Target frequency = A + B * load
	where A = policy->cpuinfo.min_freq and
	      B = (policy->cpuinfo.max_freq - policy->cpuinfo->min_freq) / 100

This will map load values 0 to 100 linearly to cpuinfo.min_freq to
cpuinfo.max_freq.

Also, use the CPUFREQ_RELATION_C in __cpufreq_driver_target to select the
closest frequency in frequency_table. This is necessary to avoid selection
of minimum frequency only when load equals to 0. It will also help for selection
of frequencies using a more 'fair' criterion.

Tables below show the difference in selected frequency for specific values
of load without and with this patch. On Intel i7-3770 @ 3.40GHz:
	Without			With
Load	Target	Selected	Target	Selected
0	0	1600000		1600000	1600000
5	170050	1600000		1690050	1700000
10	340100	1600000		1780100	1700000
15	510150	1600000		1870150	1900000
20	680200	1600000		1960200	2000000
25	850250	1600000		2050250	2100000
30	1020300	1600000		2140300	2100000
35	1190350	1600000		2230350	2200000
40	1360400	1600000		2320400	2400000
45	1530450	1600000		2410450	2400000
50	1700500	1900000		2500500	2500000
55	1870550	1900000		2590550	2600000
60	2040600	2100000		2680600	2600000
65	2210650	2400000		2770650	2800000
70	2380700	2400000		2860700	2800000
75	2550750	2600000		2950750	3000000
80	2720800	2800000		3040800	3000000
85	2890850	2900000		3130850	3100000
90	3060900	3100000		3220900	3300000
95	3230950	3300000		3310950	3300000
100	3401000	3401000		3401000	3401000

On ARM quad core 1500MHz Krait:
	Without			With
Load	Target	Selected	Target	Selected
0	0	384000		384000	384000
5	75600	384000		440400	486000
10	151200	384000		496800	486000
15	226800	384000		553200	594000
20	302400	384000		609600	594000
25	378000	384000		666000	702000
30	453600	486000		722400	702000
35	529200	594000		778800	810000
40	604800	702000		835200	810000
45	680400	702000		891600	918000
50	756000	810000		948000	918000
55	831600	918000		1004400	1026000
60	907200	918000		1060800	1026000
65	982800	1026000		1117200	1134000
70	1058400	1134000		1173600	1134000
75	1134000	1134000		1230000	1242000
80	1209600	1242000		1286400	1242000
85	1285200	1350000		1342800	1350000
90	1360800	1458000		1399200	1350000
95	1436400	1458000		1455600	1458000
100	1512000	1512000		1512000	1512000

Tested on Intel i7-3770 CPU @ 3.40GHz and on ARM quad core 1500MHz Krait
(Android smartphone).
Benchmarks on Intel i7 shows a performance improvement on low and medium
work loads with lower power consumption. Specifics:

Phoronix Linux Kernel Compilation 3.1:
Time: -0.40%, energy: -0.07%
Phoronix Apache:
Time: -4.98%, energy: -2.35%
Phoronix FFMPEG:
Time: -6.29%, energy: -4.02%

Also, running mp3 decoding (very low load) shows no differences with and
without this patch.

Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
---
 drivers/cpufreq/cpufreq_ondemand.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index 18d4091..ad3f38f 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -170,21 +170,24 @@ static void od_check_cpu(int cpu, unsigned int load)
 		dbs_freq_increase(policy, policy->max);
 	} else {
 		/* Calculate the next frequency proportional to load */
-		unsigned int freq_next;
-		freq_next = load * policy->cpuinfo.max_freq / 100;
+		unsigned int freq_next, min_f, max_f;
+
+		min_f = policy->cpuinfo.min_freq;
+		max_f = policy->cpuinfo.max_freq;
+		freq_next = min_f + load * (max_f - min_f) / 100;
 
 		/* No longer fully busy, reset rate_mult */
 		dbs_info->rate_mult = 1;
 
 		if (!od_tuners->powersave_bias) {
 			__cpufreq_driver_target(policy, freq_next,
-					CPUFREQ_RELATION_L);
+					CPUFREQ_RELATION_C);
 			return;
 		}
 
 		freq_next = od_ops.powersave_bias_target(policy, freq_next,
 					CPUFREQ_RELATION_L);
-		__cpufreq_driver_target(policy, freq_next, CPUFREQ_RELATION_L);
+		__cpufreq_driver_target(policy, freq_next, CPUFREQ_RELATION_C);
 	}
 }
 
-- 
1.9.3

