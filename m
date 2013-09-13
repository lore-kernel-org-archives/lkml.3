Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758238Ab3IMNid (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:38:33 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:44306 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933602Ab3IMNZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:25:17 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Mikael Starvik <starvik@axis.com>, linux-cris-kernel@axis.com
Subject: [PATCH 187/228] cpufreq: cris: remove calls to cpufreq_notify_transition()
Date: Fri, 13 Sep 2013 18:32:13 +0530
Message-Id: <c8374403df5f41c355e2e3c33de384382e0a746a.1379063063.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
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

Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: linux-cris-kernel@axis.com
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cris-artpec3-cpufreq.c | 8 --------
 drivers/cpufreq/cris-etraxfs-cpufreq.c | 8 --------
 2 files changed, 16 deletions(-)

diff --git a/drivers/cpufreq/cris-artpec3-cpufreq.c b/drivers/cpufreq/cris-artpec3-cpufreq.c
index 841857c..8655904 100644
--- a/drivers/cpufreq/cris-artpec3-cpufreq.c
+++ b/drivers/cpufreq/cris-artpec3-cpufreq.c
@@ -29,15 +29,9 @@ static unsigned int cris_freq_get_cpu_frequency(unsigned int cpu)
 
 static int cris_freq_target(struct cpufreq_policy *policy, unsigned int state)
 {
-	struct cpufreq_freqs freqs;
 	reg_clkgen_rw_clk_ctrl clk_ctrl;
 	clk_ctrl = REG_RD(clkgen, regi_clkgen, rw_clk_ctrl);
 
-	freqs.old = cris_freq_get_cpu_frequency(policy->cpu);
-	freqs.new = cris_freq_table[state].frequency;
-
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-
 	local_irq_disable();
 
 	/* Even though we may be SMP they will share the same clock
@@ -50,8 +44,6 @@ static int cris_freq_target(struct cpufreq_policy *policy, unsigned int state)
 
 	local_irq_enable();
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-
 	return 0;
 }
 
diff --git a/drivers/cpufreq/cris-etraxfs-cpufreq.c b/drivers/cpufreq/cris-etraxfs-cpufreq.c
index c58811a..26d940d 100644
--- a/drivers/cpufreq/cris-etraxfs-cpufreq.c
+++ b/drivers/cpufreq/cris-etraxfs-cpufreq.c
@@ -29,15 +29,9 @@ static unsigned int cris_freq_get_cpu_frequency(unsigned int cpu)
 
 static int cris_freq_target(struct cpufreq_policy *policy, unsigned int state)
 {
-	struct cpufreq_freqs freqs;
 	reg_config_rw_clk_ctrl clk_ctrl;
 	clk_ctrl = REG_RD(config, regi_config, rw_clk_ctrl);
 
-	freqs.old = cris_freq_get_cpu_frequency(policy->cpu);
-	freqs.new = cris_freq_table[state].frequency;
-
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-
 	local_irq_disable();
 
 	/* Even though we may be SMP they will share the same clock
@@ -50,8 +44,6 @@ static int cris_freq_target(struct cpufreq_policy *policy, unsigned int state)
 
 	local_irq_enable();
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-
 	return 0;
 }
 
-- 
1.7.12.rc2.18.g61b472e

