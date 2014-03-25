Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182AbaCYWxH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 18:53:07 -0400
Received: from top.free-electrons.com ([176.31.233.9]:49806 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755830AbaCYWsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 18:48:51 -0400
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
Subject: [PATCH v5 03/14] ARM: mvebu: ll_set_cpu_coherent always uses the current CPU
Date: Tue, 25 Mar 2014 23:48:14 +0100
Message-Id: <1395787705-31061-4-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1395787705-31061-1-git-send-email-gregory.clement@free-electrons.com>
References: <1395787705-31061-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ll_set_cpu_coherent is always used on the current CPU, so instead of
passing the CPU id as argument, ll_set_cpu_coherent() can find it by
itself.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Acked-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
---
 arch/arm/mach-mvebu/coherency.c    | 10 +++++-----
 arch/arm/mach-mvebu/coherency.h    |  2 +-
 arch/arm/mach-mvebu/coherency_ll.S | 12 ++++++------
 arch/arm/mach-mvebu/headsmp.S      |  4 ----
 arch/arm/mach-mvebu/platsmp.c      |  2 +-
 5 files changed, 13 insertions(+), 17 deletions(-)

diff --git a/arch/arm/mach-mvebu/coherency.c b/arch/arm/mach-mvebu/coherency.c
index 88dd507221fc..51010dbbf7e4 100644
--- a/arch/arm/mach-mvebu/coherency.c
+++ b/arch/arm/mach-mvebu/coherency.c
@@ -44,17 +44,17 @@ static struct of_device_id of_coherency_table[] = {
 };
 
 /* Function defined in coherency_ll.S */
-int ll_set_cpu_coherent(unsigned int hw_cpu_id);
+int ll_set_cpu_coherent(void);
 
-int set_cpu_coherent(unsigned int hw_cpu_id, int smp_group_id)
+int set_cpu_coherent(int smp_group_id)
 {
 	if (!coherency_base) {
-		pr_warn("Can't make CPU %d cache coherent.\n", hw_cpu_id);
+		pr_warn("Can't make current CPU cache coherent.\n");
 		pr_warn("Coherency fabric is not initialized\n");
 		return 1;
 	}
 
-	return ll_set_cpu_coherent(hw_cpu_id);
+	return ll_set_cpu_coherent();
 }
 
 static inline void mvebu_hwcc_sync_io_barrier(void)
@@ -140,7 +140,7 @@ int __init coherency_init(void)
 		sync_cache_w(&coherency_phys_base);
 		coherency_base = of_iomap(np, 0);
 		coherency_cpu_base = of_iomap(np, 1);
-		set_cpu_coherent(cpu_logical_map(smp_processor_id()), 0);
+		set_cpu_coherent(0);
 		of_node_put(np);
 	}
 
diff --git a/arch/arm/mach-mvebu/coherency.h b/arch/arm/mach-mvebu/coherency.h
index 760226c41353..c7e5df368d98 100644
--- a/arch/arm/mach-mvebu/coherency.h
+++ b/arch/arm/mach-mvebu/coherency.h
@@ -16,7 +16,7 @@
 
 extern unsigned long coherency_phys_base;
 
-int set_cpu_coherent(unsigned int cpu_id, int smp_group_id);
+int set_cpu_coherent(int smp_group_id);
 int coherency_init(void);
 
 #endif	/* __MACH_370_XP_COHERENCY_H */
diff --git a/arch/arm/mach-mvebu/coherency_ll.S b/arch/arm/mach-mvebu/coherency_ll.S
index 1f2bcd4b5424..6cb26b919787 100644
--- a/arch/arm/mach-mvebu/coherency_ll.S
+++ b/arch/arm/mach-mvebu/coherency_ll.S
@@ -24,9 +24,7 @@
 #include <asm/cp15.h>
 
 	.text
-/*
- * r0: HW CPU id
- */
+
 ENTRY(ll_set_cpu_coherent)
 	mrc	p15, 0, r1, c1, c0, 0
 	tst	r1, #CR_M @ Check MMU bit enabled
@@ -43,9 +41,11 @@ ENTRY(ll_set_cpu_coherent)
 	ldr	r0, [r0]
 2:
 	/* Create bit by cpu index */
-	mov	r3, #(1 << 24)
-	lsl	r1, r3, r1
-ARM_BE8(rev	r1, r1)
+	mrc	15, 0, r1, cr0, cr0, 5
+	and	r1, r1, #15
+	mov	r2, #(1 << 24)
+	lsl	r1, r2, r1
+	ARM_BE8(rev	r1, r1)
 
 	/* Add CPU to SMP group - Atomic */
 	add	r3, r0, #ARMADA_XP_CFB_CTL_REG_OFFSET
diff --git a/arch/arm/mach-mvebu/headsmp.S b/arch/arm/mach-mvebu/headsmp.S
index f30bc8d78871..cf7abe6554f7 100644
--- a/arch/arm/mach-mvebu/headsmp.S
+++ b/arch/arm/mach-mvebu/headsmp.S
@@ -31,10 +31,6 @@
 ENTRY(armada_xp_secondary_startup)
  ARM_BE8(setend	be )			@ go BE8 if entered LE
 
-	/* Read CPU id */
-	mrc     p15, 0, r1, c0, c0, 5
-	and     r1, r1, #0xF
-
 	/* Add CPU to coherency fabric */
 	bl	ll_set_cpu_coherent
 	b	secondary_startup
diff --git a/arch/arm/mach-mvebu/platsmp.c b/arch/arm/mach-mvebu/platsmp.c
index a6da03f5b24e..a99d71a747f0 100644
--- a/arch/arm/mach-mvebu/platsmp.c
+++ b/arch/arm/mach-mvebu/platsmp.c
@@ -102,7 +102,7 @@ static void __init armada_xp_smp_prepare_cpus(unsigned int max_cpus)
 
 	set_secondary_cpus_clock();
 	flush_cache_all();
-	set_cpu_coherent(cpu_logical_map(smp_processor_id()), 0);
+	set_cpu_coherent(0);
 
 	/*
 	 * In order to boot the secondary CPUs we need to ensure
-- 
1.8.1.2

