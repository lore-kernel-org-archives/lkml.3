Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851AbbASLdE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 06:33:04 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:56189 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbbASLdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 06:33:02 -0500
Subject: [PATCH] cpuidle/powernv: Read target_residency value of idle states
 from DT if available
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
To: rafael.j.wysocki@intel.com
Cc: linux-pm@vger.kernel.org, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org, mpe@ellerman.id.au,
        svaidy@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org
Date: Mon, 19 Jan 2015 17:02:51 +0530
Message-ID: <20150119113251.23984.16931.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15011911-0005-0000-0000-00000824D594
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device tree now exposes the residency values for different idle states. Read
these values instead of calculating residency from the latency values. The values
exposed in the DT are validated for optimal power efficiency. However to maintain
compatibility with the older firmware code which does not expose residency
values, use default values as a fallback mechanism. While at it, clump
the common parts of device tree parsing into one chunk.

Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---

 drivers/cpuidle/cpuidle-powernv.c |   39 ++++++++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 14 deletions(-)

diff --git a/drivers/cpuidle/cpuidle-powernv.c b/drivers/cpuidle/cpuidle-powernv.c
index 2726663..9e732e1 100644
--- a/drivers/cpuidle/cpuidle-powernv.c
+++ b/drivers/cpuidle/cpuidle-powernv.c
@@ -162,7 +162,8 @@ static int powernv_add_idle_states(void)
 	int dt_idle_states;
 	const __be32 *idle_state_flags;
 	const __be32 *idle_state_latency;
-	u32 len_flags, flags, latency_ns;
+	const __be32 *idle_state_residency;
+	u32 len_flags, flags, latency_ns, residency_ns;
 	int i;
 
 	/* Currently we have snooze statically defined */
@@ -186,14 +187,21 @@ static int powernv_add_idle_states(void)
 		return nr_idle_states;
 	}
 
+	idle_state_residency = of_get_property(power_mgt,
+			"ibm,cpu-idle-state-residency-ns", NULL);
+	if (!idle_state_residency) {
+		pr_warn("DT-PowerMgmt: missing ibm,cpu-idle-state-residency-ns\n");
+		pr_warn("Falling back to default values\n");
+	}
+
 	dt_idle_states = len_flags / sizeof(u32);
 
 	for (i = 0; i < dt_idle_states; i++) {
 
 		flags = be32_to_cpu(idle_state_flags[i]);
-
-		/* Cpuidle accepts exit_latency in us and we estimate
-		 * target residency to be 10x exit_latency
+		/*
+		 * Cpuidle accepts exit_latency and target_residency in us.
+		 * Use default target_residency values if f/w does not expose it.
 		 */
 		latency_ns = be32_to_cpu(idle_state_latency[i]);
 		if (flags & OPAL_PM_NAP_ENABLED) {
@@ -201,12 +209,8 @@ static int powernv_add_idle_states(void)
 			strcpy(powernv_states[nr_idle_states].name, "Nap");
 			strcpy(powernv_states[nr_idle_states].desc, "Nap");
 			powernv_states[nr_idle_states].flags = 0;
-			powernv_states[nr_idle_states].exit_latency =
-					((unsigned int)latency_ns) / 1000;
-			powernv_states[nr_idle_states].target_residency =
-					((unsigned int)latency_ns / 100);
+			powernv_states[nr_idle_states].target_residency = 100;
 			powernv_states[nr_idle_states].enter = &nap_loop;
-			nr_idle_states++;
 		}
 
 		if (flags & OPAL_PM_SLEEP_ENABLED ||
@@ -215,13 +219,20 @@ static int powernv_add_idle_states(void)
 			strcpy(powernv_states[nr_idle_states].name, "FastSleep");
 			strcpy(powernv_states[nr_idle_states].desc, "FastSleep");
 			powernv_states[nr_idle_states].flags = CPUIDLE_FLAG_TIMER_STOP;
-			powernv_states[nr_idle_states].exit_latency =
-					((unsigned int)latency_ns) / 1000;
-			powernv_states[nr_idle_states].target_residency =
-					((unsigned int)latency_ns / 100);
+			powernv_states[nr_idle_states].target_residency = 300000;
 			powernv_states[nr_idle_states].enter = &fastsleep_loop;
-			nr_idle_states++;
 		}
+
+		powernv_states[nr_idle_states].exit_latency =
+				((unsigned int)latency_ns) / 1000;
+
+		if (idle_state_residency) {
+			residency_ns = be32_to_cpu(idle_state_residency[i]);
+			powernv_states[nr_idle_states].target_residency =
+				((unsigned int)residency_ns) / 1000;
+		}
+
+		nr_idle_states++;
 	}
 
 	return nr_idle_states;

