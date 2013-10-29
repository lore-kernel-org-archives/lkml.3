Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab3J2LCV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 07:02:21 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:55222 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455Ab3J2LCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 07:02:18 -0400
Subject: [PATCH V7 6/7] POWER/cpuidle: Enable powernv cpuidle support.
To: benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Cc: daniel.lezcano@linaro.org, michael@ellerman.id.au, scottwood@freescale.com,
        srivatsa.bhat@linux.vnet.ibm.com, preeti@linux.vnet.ibm.com,
        linux-pm@lists.linux-foundation.org, svaidy@linux.vnet.ibm.com
Date: Tue, 29 Oct 2013 16:31:56 +0530
Message-ID: <20131029110154.31547.94129.stgit@deepthi.in.ibm.com>
In-Reply-To: <20131029110052.31547.82682.stgit@deepthi.in.ibm.com>
References: <20131029110052.31547.82682.stgit@deepthi.in.ibm.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102911-5816-0000-0000-00000AA10F06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch extends the current power backend
idle driver to the powernv platform.

Signed-off-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
---
 drivers/cpuidle/cpuidle-ibm-power.c |   39 ++++++++++++++++++++++++++++++++---
 1 file changed, 36 insertions(+), 3 deletions(-)

diff --git a/drivers/cpuidle/cpuidle-ibm-power.c b/drivers/cpuidle/cpuidle-ibm-power.c
index 5b92242..f790ea2 100644
--- a/drivers/cpuidle/cpuidle-ibm-power.c
+++ b/drivers/cpuidle/cpuidle-ibm-power.c
@@ -52,9 +52,10 @@ static int snooze_loop(struct cpuidle_device *dev,
 			struct cpuidle_driver *drv,
 			int index)
 {
-	unsigned long in_purr;
+	unsigned long in_purr = 0;
 
-	idle_loop_prolog(&in_purr);
+	if (firmware_has_feature(FW_FEATURE_SPLPAR))
+		idle_loop_prolog(&in_purr);
 	local_irq_enable();
 	set_thread_flag(TIF_POLLING_NRFLAG);
 
@@ -68,7 +69,8 @@ static int snooze_loop(struct cpuidle_device *dev,
 	clear_thread_flag(TIF_POLLING_NRFLAG);
 	smp_mb();
 
-	idle_loop_epilog(in_purr);
+	if (firmware_has_feature(FW_FEATURE_SPLPAR))
+		idle_loop_epilog(in_purr);
 
 	return index;
 }
@@ -132,6 +134,15 @@ static int shared_cede_loop(struct cpuidle_device *dev,
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
@@ -165,6 +176,23 @@ static struct cpuidle_state shared_states[] = {
 		.enter = &shared_cede_loop },
 };
 
+static struct cpuidle_state powernv_states[] = {
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
@@ -258,6 +286,11 @@ static int power_idle_probe(void)
 			cpuidle_state_table = dedicated_states;
 			max_idle_state = ARRAY_SIZE(dedicated_states);
 		}
+
+	} else if (firmware_has_feature(FW_FEATURE_OPALv3)) {
+		cpuidle_state_table = powernv_states;
+		max_idle_state = ARRAY_SIZE(powernv_states);
+
 	} else
 		return -ENODEV;
 

