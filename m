Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758933Ab3GaC7v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 22:59:51 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:34206 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611Ab3GaC7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 22:59:49 -0400
Subject: [PATCH V2 1/6] cpuidle/pseries: Fix kernel command line parameter
 smt-snooze-delay
To: benh@kernel.crashing.org, daniel.lezcano@linaro.org,
        linux-kernel@vger.kernel.org, michael@ellerman.id.au,
        srivatsa.bhat@linux.vnet.ibm.com, preeti@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Cc: rjw@sisk.pl, dongsheng.wang@freescale.com, linux-pm@vger.kernel.org
Date: Wed, 31 Jul 2013 08:28:57 +0530
Message-ID: <20130731025853.19448.75341.stgit@deepthi>
In-Reply-To: <20130731025840.19448.24468.stgit@deepthi>
References: <20130731025840.19448.24468.stgit@deepthi>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13073102-8878-0000-0000-0000082DC515
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

smt-snooze-delay is tunable provided currently on powerpc to delay the
entry of an idle cpu to NAP state. By default, the value is 100us,
which is entry criteria for NAP state i.e only if the idle period is
above 100us it would enter NAP. Value of -1 disables entry into NAP.
This value can be set either through sysfs, ppc64_cpu util or by
passing it via kernel command line. Currently this feature is broken
when the value is passed via the kernel command line.

This patch aims to fix this, by taking the appropritate action
based on the value after the pseries driver is registered.
This check is carried on in the backend driver rather in
setup_smt_snooze_delay() as one is not sure if the cpuidle driver
is even registered when setup routine is executed.
Also, this fixes re-enabling of NAP states by setting appropriate
value without having to reboot.

Also, to note is, smt-snooze-delay is per-cpu variable.
This can be used to enable/disable NAP on per-cpu
basis using sysfs but when this variable is passed
via kernel command line or using the smt-snooze-delay
it applies to all the cpus. Per-cpu tuning can
only be done via sysfs.

Signed-off-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
---
 arch/powerpc/platforms/pseries/processor_idle.c |   35 ++++++++++++++++++-----
 1 file changed, 28 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/processor_idle.c b/arch/powerpc/platforms/pseries/processor_idle.c
index 4644efa0..d6a1caa 100644
--- a/arch/powerpc/platforms/pseries/processor_idle.c
+++ b/arch/powerpc/platforms/pseries/processor_idle.c
@@ -170,18 +170,37 @@ static struct cpuidle_state shared_states[MAX_IDLE_STATE_COUNT] = {
 void update_smt_snooze_delay(int cpu, int residency)
 {
 	struct cpuidle_driver *drv = cpuidle_get_driver();
-	struct cpuidle_device *dev = per_cpu(cpuidle_devices, cpu);
+	struct cpuidle_device *dev;
 
 	if (cpuidle_state_table != dedicated_states)
 		return;
 
-	if (residency < 0) {
-		/* Disable the Nap state on that cpu */
-		if (dev)
-			dev->states_usage[1].disable = 1;
-	} else
-		if (drv)
+	if (!drv)
+		return;
+
+	if (cpu == -1) {
+		if (residency < 0) {
+			/* Disable NAP on all cpus */
+			drv->states[1].disabled = true;
+			return;
+		} else {
 			drv->states[1].target_residency = residency;
+			drv->states[1].disabled = false;
+			return;
+		}
+	}
+
+	dev = per_cpu(cpuidle_devices, cpu);
+	if (!dev)
+		return;
+
+	if (residency < 0)
+		dev->states_usage[1].disable = 1;
+	else {
+		drv->states[1].target_residency = residency;
+		drv->states[1].disabled = false;
+		dev->states_usage[1].disable = 0;
+	}
 }
 
 static int pseries_cpuidle_add_cpu_notifier(struct notifier_block *n,
@@ -331,6 +350,8 @@ static int __init pseries_processor_idle_init(void)
 		return retval;
 	}
 
+	update_smt_snooze_delay(-1, per_cpu(smt_snooze_delay, 0));
+
 	retval = pseries_idle_devices_init();
 	if (retval) {
 		pseries_idle_devices_uninit();

