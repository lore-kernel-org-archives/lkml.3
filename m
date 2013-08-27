Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856Ab3H0Scr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 14:32:47 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:44481 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286Ab3H0Scp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 14:32:45 -0400
Subject: [PATCH V6 6/7] POWER/cpuidle: Enable powernv cpuidle support.
To: linux-pm@lists.linux-foundation.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Cc: b.zolnierkie@samsung.com, benh@kernel.crashing.org,
        daniel.lezcano@linaro.org, dongsheng.wang@freescale.com,
        michael@ellerman.id.au, scottwood@freescale.com,
        srivatsa.bhat@linux.vnet.ibm.com, preeti@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com
Date: Wed, 28 Aug 2013 00:01:47 +0530
Message-ID: <20130827183145.18579.9940.stgit@deepthi.in.ibm.com>
In-Reply-To: <20130827183016.18579.16595.stgit@deepthi.in.ibm.com>
References: <20130827183016.18579.16595.stgit@deepthi.in.ibm.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082718-5140-0000-0000-000003BC254F
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
index 162deda..f8905c3 100644
--- a/drivers/cpuidle/cpuidle-ibm-power.c
+++ b/drivers/cpuidle/cpuidle-ibm-power.c
@@ -48,9 +48,10 @@ static int snooze_loop(struct cpuidle_device *dev,
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
 
@@ -64,7 +65,8 @@ static int snooze_loop(struct cpuidle_device *dev,
 	clear_thread_flag(TIF_POLLING_NRFLAG);
 	smp_mb();
 
-	idle_loop_epilog(in_purr);
+	if (firmware_has_feature(FW_FEATURE_SPLPAR))
+		idle_loop_epilog(in_purr);
 
 	return index;
 }
@@ -128,6 +130,15 @@ static int shared_cede_loop(struct cpuidle_device *dev,
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
@@ -161,6 +172,23 @@ static struct cpuidle_state shared_states[] = {
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
@@ -254,6 +282,11 @@ static int power_idle_probe(void)
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
 

