Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669Ab3GWJEA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 05:04:00 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:48215 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab3GWJD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 05:03:58 -0400
Subject: [PATCH 3/3] cpuidle/powernv: Support smt-snooze-delay parameter in
 powernv idle.
To: linuxppc-dev@lists.ozlabs.org
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Cc: benh@kernel.crashing.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Date: Tue, 23 Jul 2013 14:32:44 +0530
Message-ID: <20130723090239.7291.59177.stgit@deepthi.in.ibm.com>
In-Reply-To: <20130723090111.7291.99479.stgit@deepthi.in.ibm.com>
References: <20130723090111.7291.99479.stgit@deepthi.in.ibm.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072308-5564-0000-0000-000008EB91FD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

smt-snooze-delay is a tunable that is supported on
powerpc platform to delay the entry to nap state.
This can be set either via sysfs, kernel commandline
or pp64_cpu util.

Signed-off-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/processor.h            |    2 +
 arch/powerpc/platforms/powernv/powernv.h        |    3 ++
 arch/powerpc/platforms/powernv/processor_idle.c |   36 +++++++++++++++++++++++
 3 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/processor.h b/arch/powerpc/include/asm/processor.h
index 47a35b0..5700c3c 100644
--- a/arch/powerpc/include/asm/processor.h
+++ b/arch/powerpc/include/asm/processor.h
@@ -426,7 +426,7 @@ enum idle_boot_override {IDLE_NO_OVERRIDE = 0, IDLE_POWERSAVE_OFF};
 extern int powersave_nap;	/* set if nap mode can be used in idle loop */
 extern void power7_nap(void);
 
-#ifdef CONFIG_PSERIES_IDLE
+#if defined(CONFIG_PSERIES_IDLE) || defined(CONFIG_POWERNV_IDLE)
 extern void update_smt_snooze_delay(int cpu, int residency);
 #else
 static inline void update_smt_snooze_delay(int cpu, int residency) {}
diff --git a/arch/powerpc/platforms/powernv/powernv.h b/arch/powerpc/platforms/powernv/powernv.h
index a1c6f83..558ee69 100644
--- a/arch/powerpc/platforms/powernv/powernv.h
+++ b/arch/powerpc/platforms/powernv/powernv.h
@@ -15,4 +15,7 @@ static inline void pnv_pci_init(void) { }
 static inline void pnv_pci_shutdown(void) { }
 #endif
 
+/* Idle variable */
+DECLARE_PER_CPU(long, smt_snooze_delay);
+
 #endif /* _POWERNV_H */
diff --git a/arch/powerpc/platforms/powernv/processor_idle.c b/arch/powerpc/platforms/powernv/processor_idle.c
index f43ad91a..505fea4 100644
--- a/arch/powerpc/platforms/powernv/processor_idle.c
+++ b/arch/powerpc/platforms/powernv/processor_idle.c
@@ -13,6 +13,8 @@
 #include <asm/machdep.h>
 #include <asm/runlatch.h>
 
+#include "powernv.h"
+
 struct cpuidle_driver powernv_idle_driver = {
 	.name =		"powernv_idle",
 	.owner =	THIS_MODULE,
@@ -193,6 +195,38 @@ static int powernv_idle_probe(void)
 	return 0;
 }
 
+void update_smt_snooze_delay(int cpu, int residency)
+{
+	struct cpuidle_driver *drv = cpuidle_get_driver();
+	struct cpuidle_device *dev;
+
+	if (!drv)
+		return;
+
+	if (cpu == -1) {
+		if (residency < 0) {
+			/* Disable NAP on all cpus */
+			drv->states[1].disabled = true;
+		} else {
+			drv->states[1].target_residency = residency;
+			drv->states[1].disabled = false;
+		}
+		return;
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
+}
+
 static int __init powernv_processor_idle_init(void)
 {
 	int retval;
@@ -208,6 +242,8 @@ static int __init powernv_processor_idle_init(void)
 		return retval;
 	}
 
+	update_smt_snooze_delay(-1, per_cpu(smt_snooze_delay, 0));
+
 	retval = powernv_idle_devices_init();
 	if (retval) {
 		powernv_idle_devices_uninit();

