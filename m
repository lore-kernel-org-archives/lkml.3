Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408Ab3HPCd4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 22:33:56 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:36126 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754377Ab3HPC1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 22:27:05 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 10/34] cpufreq: e_powersaver: remove calls to cpufreq_notify_transition()
Date: Fri, 16 Aug 2013 07:55:07 +0530
Message-Id: <ae5da4075c10279e33559999bed0fcf9b922c72c.1376619363.git.viresh.kumar@linaro.org>
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
 drivers/cpufreq/e_powersaver.c | 23 +++--------------------
 1 file changed, 3 insertions(+), 20 deletions(-)

diff --git a/drivers/cpufreq/e_powersaver.c b/drivers/cpufreq/e_powersaver.c
index b39c4ef..9012b8b 100644
--- a/drivers/cpufreq/e_powersaver.c
+++ b/drivers/cpufreq/e_powersaver.c
@@ -107,15 +107,9 @@ static int eps_set_state(struct eps_cpu_data *centaur,
 			 struct cpufreq_policy *policy,
 			 u32 dest_state)
 {
-	struct cpufreq_freqs freqs;
 	u32 lo, hi;
-	int err = 0;
 	int i;
 
-	freqs.old = eps_get(policy->cpu);
-	freqs.new = centaur->fsb * ((dest_state >> 8) & 0xff);
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-
 	/* Wait while CPU is busy */
 	rdmsr(MSR_IA32_PERF_STATUS, lo, hi);
 	i = 0;
@@ -124,8 +118,7 @@ static int eps_set_state(struct eps_cpu_data *centaur,
 		rdmsr(MSR_IA32_PERF_STATUS, lo, hi);
 		i++;
 		if (unlikely(i > 64)) {
-			err = -ENODEV;
-			goto postchange;
+			return -ENODEV;
 		}
 	}
 	/* Set new multiplier and voltage */
@@ -137,16 +130,10 @@ static int eps_set_state(struct eps_cpu_data *centaur,
 		rdmsr(MSR_IA32_PERF_STATUS, lo, hi);
 		i++;
 		if (unlikely(i > 64)) {
-			err = -ENODEV;
-			goto postchange;
+			return -ENODEV;
 		}
 	} while (lo & ((1 << 16) | (1 << 17)));
 
-	/* Return current frequency */
-postchange:
-	rdmsr(MSR_IA32_PERF_STATUS, lo, hi);
-	freqs.new = centaur->fsb * ((lo >> 8) & 0xff);
-
 #ifdef DEBUG
 	{
 	u8 current_multiplier, current_voltage;
@@ -161,11 +148,7 @@ postchange:
 		current_multiplier);
 	}
 #endif
-	if (err)
-		freqs.new = freqs.old;
-
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-	return err;
+	return 0;
 }
 
 static int eps_target(struct cpufreq_policy *policy, unsigned int index)
-- 
1.7.12.rc2.18.g61b472e

