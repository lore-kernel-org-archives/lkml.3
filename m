Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071AbaCYWuC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 18:50:02 -0400
Received: from top.free-electrons.com ([176.31.233.9]:49880 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756005AbaCYWtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 18:49:02 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 12/14] ARM: mvebu: Register notifier callback for the cpuidle transition
Date: Tue, 25 Mar 2014 23:48:23 +0100
Message-Id: <1395787705-31061-13-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1395787705-31061-1-git-send-email-gregory.clement@free-electrons.com>
References: <1395787705-31061-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to have well encapsulated code, we use notifier callbacks for
CPU_PM_ENTER and CPU_PM_EXIT inside the mvebu power management code.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 arch/arm/mach-mvebu/pmsu.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/arm/mach-mvebu/pmsu.c b/arch/arm/mach-mvebu/pmsu.c
index 3fc25d94e893..5812ff4a9b63 100644
--- a/arch/arm/mach-mvebu/pmsu.c
+++ b/arch/arm/mach-mvebu/pmsu.c
@@ -16,6 +16,7 @@
  * other SOC units
  */
 
+#include <linux/cpu_pm.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/of_address.h>
@@ -266,4 +267,22 @@ static noinline void armada_370_xp_pmsu_idle_restore(void)
 	writel(reg, pmsu_mp_base + PMSU_STATUS_AND_MASK(hw_cpu));
 }
 
+static int armada_370_xp_cpu_pm_notify(struct notifier_block *self,
+				    unsigned long action, void *hcpu)
+{
+	if (action == CPU_PM_ENTER) {
+		unsigned int hw_cpu = cpu_logical_map(smp_processor_id());
+		armada_370_xp_pmsu_set_start_addr(armada_370_xp_cpu_resume,
+						hw_cpu);
+	} else if (action == CPU_PM_EXIT) {
+		armada_370_xp_pmsu_idle_restore();
+	}
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block armada_370_xp_cpu_pm_notifier = {
+	.notifier_call = armada_370_xp_cpu_pm_notify,
+};
+
 early_initcall(armada_370_xp_pmsu_init);
-- 
1.8.1.2

