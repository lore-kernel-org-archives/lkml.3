Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847AbaAVHN3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 02:13:29 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:36607 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754499AbaAVHNX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 02:13:23 -0500
Subject: [RESEND PATCH V5 8/8] cpuidle/powernv: Parse device tree to setup
 idle states
To: peterz@infradead.org, fweisbec@gmail.com, paul.gortmaker@windriver.com,
        paulus@samba.org, mingo@kernel.org, mikey@neuling.org,
        shangw@linux.vnet.ibm.com, rafael.j.wysocki@intel.com,
        galak@kernel.crashing.org, =daniel.lezcano@linaro.org,
        benh@kernel.crashing.org, paulmck@linux.vnet.ibm.com,
        --to=agraf@suse.de, arnd@arndb.de, linux-pm@vger.kernel.org,
        rostedt@goodmis.org, michael@ellerman.id.au, john.stultz@linaro.org,
        anton@samba.org, tglx@linutronix.de, chenhui.zhao@freescale.com,
        deepthi@linux.vnet.ibm.com, r58472@freescale.com, geoff@infradead.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, svaidy@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Date: Wed, 22 Jan 2014 12:39:47 +0530
Message-ID: <20140122070946.30650.64517.stgit@preeti.in.ibm.com>
In-Reply-To: <20140122065918.30650.22437.stgit@preeti.in.ibm.com>
References: <20140122065918.30650.22437.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14012207-5806-0000-0000-000023EF1509
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add deep idle states such as nap and fast sleep to the cpuidle state table
only if they are discovered from the device tree during cpuidle initialization.

Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---

 drivers/cpuidle/cpuidle-powernv.c |   81 +++++++++++++++++++++++++++++--------
 1 file changed, 64 insertions(+), 17 deletions(-)

diff --git a/drivers/cpuidle/cpuidle-powernv.c b/drivers/cpuidle/cpuidle-powernv.c
index 90f0c2b..b3face5 100644
--- a/drivers/cpuidle/cpuidle-powernv.c
+++ b/drivers/cpuidle/cpuidle-powernv.c
@@ -12,10 +12,17 @@
 #include <linux/cpu.h>
 #include <linux/notifier.h>
 #include <linux/clockchips.h>
+#include <linux/of.h>
 
 #include <asm/machdep.h>
 #include <asm/firmware.h>
 
+/* Flags and constants used in PowerNV platform */
+
+#define MAX_POWERNV_IDLE_STATES	8
+#define IDLE_USE_INST_NAP	0x00010000 /* Use nap instruction */
+#define IDLE_USE_INST_SLEEP	0x00020000 /* Use sleep instruction */
+
 struct cpuidle_driver powernv_idle_driver = {
 	.name             = "powernv_idle",
 	.owner            = THIS_MODULE,
@@ -87,7 +94,7 @@ static int fastsleep_loop(struct cpuidle_device *dev,
 /*
  * States for dedicated partition case.
  */
-static struct cpuidle_state powernv_states[] = {
+static struct cpuidle_state powernv_states[MAX_POWERNV_IDLE_STATES] = {
 	{ /* Snooze */
 		.name = "snooze",
 		.desc = "snooze",
@@ -95,20 +102,6 @@ static struct cpuidle_state powernv_states[] = {
 		.exit_latency = 0,
 		.target_residency = 0,
 		.enter = &snooze_loop },
-	{ /* NAP */
-		.name = "NAP",
-		.desc = "NAP",
-		.flags = CPUIDLE_FLAG_TIME_VALID,
-		.exit_latency = 10,
-		.target_residency = 100,
-		.enter = &nap_loop },
-	 { /* Fastsleep */
-		.name = "fastsleep",
-		.desc = "fastsleep",
-		.flags = CPUIDLE_FLAG_TIME_VALID,
-		.exit_latency = 10,
-		.target_residency = 100,
-		.enter = &fastsleep_loop },
 };
 
 static int powernv_cpuidle_add_cpu_notifier(struct notifier_block *n,
@@ -169,19 +162,73 @@ static int powernv_cpuidle_driver_init(void)
 	return 0;
 }
 
+static int powernv_add_idle_states(void)
+{
+	struct device_node *power_mgt;
+	struct property *prop;
+	int nr_idle_states = 1; /* Snooze */
+	int dt_idle_states;
+	u32 *flags;
+	int i;
+
+	/* Currently we have snooze statically defined */
+
+	power_mgt = of_find_node_by_path("/ibm,opal/power-mgt");
+	if (!power_mgt) {
+		pr_warn("opal: PowerMgmt Node not found\n");
+		return nr_idle_states;
+	}
+
+	prop = of_find_property(power_mgt, "ibm,cpu-idle-state-flags", NULL);
+	if (!prop) {
+		pr_warn("DT-PowerMgmt: missing ibm,cpu-idle-state-flags\n");
+		return nr_idle_states;
+	}
+
+	dt_idle_states = prop->length / sizeof(u32);
+	flags = (u32 *) prop->value;
+
+	for (i = 0; i < dt_idle_states; i++) {
+
+		if (flags[i] & IDLE_USE_INST_NAP) {
+			/* Add NAP state */
+			strcpy(powernv_states[nr_idle_states].name, "Nap");
+			strcpy(powernv_states[nr_idle_states].desc, "Nap");
+			powernv_states[nr_idle_states].flags = CPUIDLE_FLAG_TIME_VALID;
+			powernv_states[nr_idle_states].exit_latency = 10;
+			powernv_states[nr_idle_states].target_residency = 100;
+			powernv_states[nr_idle_states].enter = &nap_loop;
+			nr_idle_states++;
+		}
+
+		if (flags[i] & IDLE_USE_INST_SLEEP) {
+			/* Add FASTSLEEP state */
+			strcpy(powernv_states[nr_idle_states].name, "FastSleep");
+			strcpy(powernv_states[nr_idle_states].desc, "FastSleep");
+			powernv_states[nr_idle_states].flags = CPUIDLE_FLAG_TIME_VALID;
+			powernv_states[nr_idle_states].exit_latency = 300;
+			powernv_states[nr_idle_states].target_residency = 1000000;
+			powernv_states[nr_idle_states].enter = &fastsleep_loop;
+			nr_idle_states++;
+		}
+	}
+
+	return nr_idle_states;
+}
+
 /*
  * powernv_idle_probe()
  * Choose state table for shared versus dedicated partition
  */
 static int powernv_idle_probe(void)
 {
-
 	if (cpuidle_disable != IDLE_NO_OVERRIDE)
 		return -ENODEV;
 
 	if (firmware_has_feature(FW_FEATURE_OPALv3)) {
 		cpuidle_state_table = powernv_states;
-		max_idle_state = ARRAY_SIZE(powernv_states);
+		/* Device tree can indicate more idle states */
+		max_idle_state = powernv_add_idle_states();
  	} else
  		return -ENODEV;
 

