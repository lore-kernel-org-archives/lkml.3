Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835Ab3HZLjn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 07:39:43 -0400
Received: from na3sys009aog135.obsmtp.com ([74.125.149.84]:37267 "EHLO
	na3sys009aog135.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756705Ab3HZLjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 07:39:41 -0400
From: Jisheng Zhang <jszhang@marvell.com>
To: <jszhang@marvell.com>, <jason@lakedaemon.net>, <andrew@lunn.ch>,
        <gregory.clement@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>,
        <ezequiel.garcia@free-electrons.com>, <mturquette@linaro.org>,
        <sebastian.hesselbarth@gmail.com>, <linus.walleij@linaro.org>
CC: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 1/3] arm: mvebu: add missing of_node_put() to fix reference leak
Date: Mon, 26 Aug 2013 19:36:56 +0800
Message-ID: <1377517018-7716-2-git-send-email-jszhang@marvell.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1377517018-7716-1-git-send-email-jszhang@marvell.com>
References: <1377517018-7716-1-git-send-email-jszhang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add of_node_put to properly decrement the refcount when we are
done using a given node.

Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
Reviewed-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
---
 arch/arm/mach-mvebu/coherency.c         | 8 +++++++-
 arch/arm/mach-mvebu/platsmp.c           | 1 +
 arch/arm/mach-mvebu/pmsu.c              | 1 +
 arch/arm/mach-mvebu/system-controller.c | 1 +
 4 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-mvebu/coherency.c b/arch/arm/mach-mvebu/coherency.c
index 4c24303..58adf2f 100644
--- a/arch/arm/mach-mvebu/coherency.c
+++ b/arch/arm/mach-mvebu/coherency.c
@@ -140,6 +140,7 @@ int __init coherency_init(void)
 		coherency_base = of_iomap(np, 0);
 		coherency_cpu_base = of_iomap(np, 1);
 		set_cpu_coherent(cpu_logical_map(smp_processor_id()), 0);
+		of_node_put(np);
 	}
 
 	return 0;
@@ -147,9 +148,14 @@ int __init coherency_init(void)
 
 static int __init coherency_late_init(void)
 {
-	if (of_find_matching_node(NULL, of_coherency_table))
+	struct device_node *np;
+
+	np = of_find_matching_node(NULL, of_coherency_table);
+	if (np) {
 		bus_register_notifier(&platform_bus_type,
 				      &mvebu_hwcc_platform_nb);
+		of_node_put(np);
+	}
 	return 0;
 }
 
diff --git a/arch/arm/mach-mvebu/platsmp.c b/arch/arm/mach-mvebu/platsmp.c
index 4f960f0..5624a8f 100644
--- a/arch/arm/mach-mvebu/platsmp.c
+++ b/arch/arm/mach-mvebu/platsmp.c
@@ -118,6 +118,7 @@ void __init armada_xp_smp_prepare_cpus(unsigned int max_cpus)
 		panic("Cannot find 'marvell,bootrom' compatible node");
 
 	err = of_address_to_resource(node, 0, &res);
+	of_node_put(node);
 	if (err < 0)
 		panic("Cannot get 'bootrom' node address");
 
diff --git a/arch/arm/mach-mvebu/pmsu.c b/arch/arm/mach-mvebu/pmsu.c
index 3cc4bef..27fc4f0 100644
--- a/arch/arm/mach-mvebu/pmsu.c
+++ b/arch/arm/mach-mvebu/pmsu.c
@@ -67,6 +67,7 @@ int __init armada_370_xp_pmsu_init(void)
 		pr_info("Initializing Power Management Service Unit\n");
 		pmsu_mp_base = of_iomap(np, 0);
 		pmsu_reset_base = of_iomap(np, 1);
+		of_node_put(np);
 	}
 
 	return 0;
diff --git a/arch/arm/mach-mvebu/system-controller.c b/arch/arm/mach-mvebu/system-controller.c
index f875124..5175083c 100644
--- a/arch/arm/mach-mvebu/system-controller.c
+++ b/arch/arm/mach-mvebu/system-controller.c
@@ -98,6 +98,7 @@ static int __init mvebu_system_controller_init(void)
 		BUG_ON(!match);
 		system_controller_base = of_iomap(np, 0);
 		mvebu_sc = (struct mvebu_system_controller *)match->data;
+		of_node_put(np);
 	}
 
 	return 0;
-- 
1.8.4.rc3

