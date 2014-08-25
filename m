Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933334AbaHYSBy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 14:01:54 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:38052 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933319AbaHYSBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 14:01:51 -0400
From: "Shreyas B. Prabhu" <shreyas@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Preeti U Murthy <preeti@linux.vnet.ibm.com>, linux-pm@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        "Shreyas B. Prabhu" <shreyas@linux.vnet.ibm.com>
Subject: [PATCH 2/9] cpuidle/powernv: Populate cpuidle state details by querying the device-tree
Date: Mon, 25 Aug 2014 23:31:06 +0530
Message-Id: <1408989673-14137-3-git-send-email-shreyas@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1408989673-14137-1-git-send-email-shreyas@linux.vnet.ibm.com>
References: <1408989673-14137-1-git-send-email-shreyas@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082518-9332-0000-0000-000001CB4D99
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Preeti U Murthy <preeti@linux.vnet.ibm.com>

We hard code the metrics relevant for cpuidle states in the kernel today.
Instead pick them up from the device tree so that they remain relevant
and updated for the system that the kernel is running on.

Cc: linux-pm@vger.kernel.org
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: devicetree@vger.kernel.org
Signed-off-by: Preeti U. Murthy <preeti@linux.vnet.ibm.com>
Signed-off-by: Shreyas B. Prabhu <shreyas@linux.vnet.ibm.com>
---
 drivers/cpuidle/cpuidle-powernv.c | 27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/cpuidle/cpuidle-powernv.c b/drivers/cpuidle/cpuidle-powernv.c
index 23d2743..3ceff53 100644
--- a/drivers/cpuidle/cpuidle-powernv.c
+++ b/drivers/cpuidle/cpuidle-powernv.c
@@ -162,7 +162,8 @@ static int powernv_add_idle_states(void)
 	int nr_idle_states = 1; /* Snooze */
 	int dt_idle_states;
 	const __be32 *idle_state_flags;
-	u32 len_flags, flags;
+	const __be32 *idle_state_latency;
+	u32 len_flags, flags, latency_ns;
 	int i;
 
 	/* Currently we have snooze statically defined */
@@ -178,19 +179,33 @@ static int powernv_add_idle_states(void)
 		pr_warn("DT-PowerMgmt: missing ibm,cpu-idle-state-flags\n");
 		return nr_idle_states;
 	}
+	idle_state_latency = of_get_property(power_mgt,
+			"ibm,cpu-idle-state-latencies-ns", NULL);
+	if (!idle_state_latency) {
+		pr_warn("DT-PowerMgmt: missing ibm,cpu-idle-state-latencies-ns\n");
+		return nr_idle_states;
+	}
 
 	dt_idle_states = len_flags / sizeof(u32);
 
 	for (i = 0; i < dt_idle_states; i++) {
 
 		flags = be32_to_cpu(idle_state_flags[i]);
+
+		/* Cpuidle accepts exit_latency in us and we estimate best case
+		 * target residency to be 10x exit_latency
+		 */
+		latency_ns = be32_to_cpu(idle_state_latency[i]);
+
 		if (flags & IDLE_INST_NAP) {
 			/* Add NAP state */
 			strcpy(powernv_states[nr_idle_states].name, "Nap");
 			strcpy(powernv_states[nr_idle_states].desc, "Nap");
 			powernv_states[nr_idle_states].flags = CPUIDLE_FLAG_TIME_VALID;
-			powernv_states[nr_idle_states].exit_latency = 10;
-			powernv_states[nr_idle_states].target_residency = 100;
+			powernv_states[nr_idle_states].exit_latency =
+					((unsigned int)latency_ns) / 1000;
+			powernv_states[nr_idle_states].target_residency =
+					((unsigned int)latency_ns / 100);
 			powernv_states[nr_idle_states].enter = &nap_loop;
 			nr_idle_states++;
 		}
@@ -201,8 +216,10 @@ static int powernv_add_idle_states(void)
 			strcpy(powernv_states[nr_idle_states].desc, "FastSleep");
 			powernv_states[nr_idle_states].flags =
 				CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TIMER_STOP;
-			powernv_states[nr_idle_states].exit_latency = 300;
-			powernv_states[nr_idle_states].target_residency = 1000000;
+			powernv_states[nr_idle_states].exit_latency =
+					((unsigned int)latency_ns) / 1000;
+			powernv_states[nr_idle_states].target_residency =
+					((unsigned int)latency_ns / 100);
 			powernv_states[nr_idle_states].enter = &fastsleep_loop;
 			nr_idle_states++;
 		}
-- 
1.9.0

