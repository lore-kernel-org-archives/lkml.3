Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751394AbaJAHqD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 03:46:03 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:43354 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbaJAHqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 03:46:00 -0400
From: "Shreyas B. Prabhu" <shreyas@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Preeti U Murthy <preeti@linux.vnet.ibm.com>, linux-pm@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Michael Ellerman <mpe@ellerman.id.au>,
        "Shreyas B. Prabhu" <shreyas@linux.vnet.ibm.com>
Subject: [PATCH v2] cpuidle/powernv: Populate cpuidle state details by querying the device-tree
Date: Wed,  1 Oct 2014 13:15:02 +0530
Message-Id: <1412149502-2729-1-git-send-email-shreyas@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.3
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14100107-1344-0000-0000-0000049A5114
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
Cc: linuxppc-dev@lists.ozlabs.org
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Preeti U. Murthy <preeti@linux.vnet.ibm.com>
Signed-off-by: Shreyas B. Prabhu <shreyas@linux.vnet.ibm.com>
---
v2:
Rebased on 3.17-rc7
Separated from 'powerpc/powernv: Support for fastsleep and winkle'

v1:
Initial post
https://lkml.org/lkml/2014/8/25/456

diff --git a/drivers/cpuidle/cpuidle-powernv.c b/drivers/cpuidle/cpuidle-powernv.c
index a64be57..2426a4b 100644
--- a/drivers/cpuidle/cpuidle-powernv.c
+++ b/drivers/cpuidle/cpuidle-powernv.c
@@ -163,7 +163,8 @@ static int powernv_add_idle_states(void)
 	int nr_idle_states = 1; /* Snooze */
 	int dt_idle_states;
 	const __be32 *idle_state_flags;
-	u32 len_flags, flags;
+	const __be32 *idle_state_latency;
+	u32 len_flags, flags, latency_ns;
 	int i;
 
 	/* Currently we have snooze statically defined */
@@ -180,18 +181,32 @@ static int powernv_add_idle_states(void)
 		return nr_idle_states;
 	}
 
+	idle_state_latency = of_get_property(power_mgt,
+			"ibm,cpu-idle-state-latencies-ns", NULL);
+	if (!idle_state_latency) {
+		pr_warn("DT-PowerMgmt: missing ibm,cpu-idle-state-latencies-ns\n");
+		return nr_idle_states;
+	}
+
 	dt_idle_states = len_flags / sizeof(u32);
 
 	for (i = 0; i < dt_idle_states; i++) {
 
 		flags = be32_to_cpu(idle_state_flags[i]);
+
+		/* Cpuidle accepts exit_latency in us and we estimate best case
+		 * target residency to be 10x exit_latency
+		 */
+		latency_ns = be32_to_cpu(idle_state_latency[i]);
 		if (flags & IDLE_USE_INST_NAP) {
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
@@ -202,8 +217,10 @@ static int powernv_add_idle_states(void)
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

