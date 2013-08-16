Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914Ab3HPC2S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 22:28:18 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:48095 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754905Ab3HPC2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 22:28:12 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Subject: [PATCH 19/34] cpufreq: maple: remove calls to cpufreq_notify_transition()
Date: Fri, 16 Aug 2013 07:55:16 +0530
Message-Id: <f25256fa5fc04dd5ddf585d1fea4d2ce7e196b56.1376619363.git.viresh.kumar@linaro.org>
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

Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/maple-cpufreq.c | 18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff --git a/drivers/cpufreq/maple-cpufreq.c b/drivers/cpufreq/maple-cpufreq.c
index b508147..45db7a2 100644
--- a/drivers/cpufreq/maple-cpufreq.c
+++ b/drivers/cpufreq/maple-cpufreq.c
@@ -69,8 +69,6 @@ static struct cpufreq_frequency_table maple_cpu_freqs[] = {
  */
 static int maple_pmode_cur;
 
-static DEFINE_MUTEX(maple_switch_mutex);
-
 static const u32 *maple_pmode_data;
 static int maple_pmode_max;
 
@@ -133,21 +131,7 @@ static int maple_scom_query_freq(void)
 static int maple_cpufreq_target(struct cpufreq_policy *policy,
 	unsigned int index)
 {
-	struct cpufreq_freqs freqs;
-	int rc;
-
-	mutex_lock(&maple_switch_mutex);
-
-	freqs.old = maple_cpu_freqs[maple_pmode_cur].frequency;
-	freqs.new = maple_cpu_freqs[index].frequency;
-
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-	rc = maple_scom_switch_freq(index);
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-
-	mutex_unlock(&maple_switch_mutex);
-
-	return rc;
+	return maple_scom_switch_freq(index);
 }
 
 static unsigned int maple_cpufreq_get_speed(unsigned int cpu)
-- 
1.7.12.rc2.18.g61b472e

