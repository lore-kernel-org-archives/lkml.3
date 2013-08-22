Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257Ab3HVJzI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 05:55:08 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:37185 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428Ab3HVJzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 05:55:04 -0400
Subject: [PATCH V5 4/5] POWER/cpuidle: Enable powernv cpuidle support.
To: benh@kernel.crashing.org, daniel.lezcano@linaro.org,
        linux-kernel@vger.kernel.org, scottwood@freescale.com,
        linux-pm@lists.linux-foundation.org, linuxppc-dev@lists.ozlabs.org
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Cc: michael@ellerman.id.au, preeti@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com, dongsheng.wang@freescale.com
Date: Thu, 22 Aug 2013 15:24:25 +0530
Message-ID: <20130822095422.27416.94236.stgit@deepthi.in.ibm.com>
In-Reply-To: <20130822095323.27416.79369.stgit@deepthi.in.ibm.com>
References: <20130822095323.27416.79369.stgit@deepthi.in.ibm.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082209-8878-0000-0000-0000087FD035
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch extends the current power backend
idle driver to the powernv platform.

Signed-off-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
---
 drivers/cpuidle/cpuidle-ibm-power.c |   37 ++++++++++++++++++++++++++++++++---
 1 file changed, 34 insertions(+), 3 deletions(-)

diff --git a/drivers/cpuidle/cpuidle-ibm-power.c b/drivers/cpuidle/cpuidle-ibm-power.c
index 4ee5a94..de5e837 100644
--- a/drivers/cpuidle/cpuidle-ibm-power.c
+++ b/drivers/cpuidle/cpuidle-ibm-power.c
@@ -50,9 +50,11 @@ static int snooze_loop(struct cpuidle_device *dev,
 			struct cpuidle_driver *drv,
 			int index)
 {
-	unsigned long in_purr;
+	unsigned long in_purr = 0;
+
+	if (firmware_has_feature(FW_FEATURE_SPLPAR))
+		idle_loop_prolog(&in_purr);
 
-	idle_loop_prolog(&in_purr);
 	local_irq_enable();
 	set_thread_flag(TIF_POLLING_NRFLAG);
 
@@ -66,7 +68,8 @@ static int snooze_loop(struct cpuidle_device *dev,
 	clear_thread_flag(TIF_POLLING_NRFLAG);
 	smp_mb();
 
-	idle_loop_epilog(in_purr);
+	if (firmware_has_feature(FW_FEATURE_SPLPAR))
+		idle_loop_epilog(in_purr);
 
 	return index;
 }
@@ -129,6 +132,15 @@ static int shared_cede_loop(struct cpuidle_device *dev,
 	return index;
 }
 
+static int nap_loop(struct cpuidle_device *dev,
+			struct cpuidle_driver *drv,
+			int index)
+{
+	ppc64_runlatch_off();
+	power7_idle();
+	return index;
+}
+
 /*
  * States for dedicated partition case.
  */
@@ -162,6 +174,23 @@ static struct cpuidle_state shared_states[MAX_IDLE_STATE_COUNT] = {
 		.enter = &shared_cede_loop },
 };
 
+static struct cpuidle_state powernv_states[MAX_IDLE_STATE_COUNT] = {
+	{ /* Snooze */
+		.name = "snooze",
+		.desc = "snooze",
+		.flags = CPUIDLE_FLAG_TIME_VALID,
+		.exit_latency = 0,
+		.target_residency = 0,
+		.enter = &snooze_loop },
+	{ /* NAP */
+		.name = "NAP",
+		.desc = "NAP",
+		.flags = CPUIDLE_FLAG_TIME_VALID,
+		.exit_latency = 10,
+		.target_residency = 100,
+		.enter = &nap_loop },
+};
+
 void update_smt_snooze_delay(int cpu, int residency)
 {
 	struct cpuidle_driver *drv = cpuidle_get_driver();
@@ -261,6 +290,8 @@ static int power_idle_probe(void)
 			cpuidle_state_table = shared_states;
 		else
 			cpuidle_state_table = dedicated_states;
+	} else if (firmware_has_feature(FW_FEATURE_OPALv3)) {
+		cpuidle_state_table = powernv_states;
 	} else
 		return -ENODEV;
 

