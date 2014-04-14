Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922AbaDNPQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 11:16:17 -0400
Received: from top.free-electrons.com ([176.31.233.9]:60747 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754189AbaDNPKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 11:10:32 -0400
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
Subject: [PATCH v7 09/11] ARM: mvebu: Register notifier callback for the cpuidle transition
Date: Mon, 14 Apr 2014 17:10:12 +0200
Message-Id: <1397488214-20685-10-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1397488214-20685-1-git-send-email-gregory.clement@free-electrons.com>
References: <1397488214-20685-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to have well encapsulated code, we use notifier callbacks for
CPU_PM_ENTER and CPU_PM_EXIT inside the mvebu power management code.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 arch/arm/mach-mvebu/pmsu.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm/mach-mvebu/pmsu.c b/arch/arm/mach-mvebu/pmsu.c
index 968c8c02c126..9ea2bb44d573 100644
--- a/arch/arm/mach-mvebu/pmsu.c
+++ b/arch/arm/mach-mvebu/pmsu.c
@@ -18,6 +18,7 @@
 
 #define pr_fmt(fmt) "mvebu-pmsu: " fmt
 
+#include <linux/cpu_pm.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/of_address.h>
@@ -263,4 +264,21 @@ static noinline void armada_370_xp_pmsu_idle_restore(void)
 	writel(reg, pmsu_mp_base + PMSU_STATUS_AND_MASK(hw_cpu));
 }
 
+static int armada_370_xp_cpu_pm_notify(struct notifier_block *self,
+				    unsigned long action, void *hcpu)
+{
+	if (action == CPU_PM_ENTER) {
+		unsigned int hw_cpu = cpu_logical_map(smp_processor_id());
+		mvebu_pmsu_set_cpu_boot_addr(hw_cpu, armada_370_xp_cpu_resume);
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

