Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932402Ab3DWQhw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 12:37:52 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:57728 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757218Ab3DWQbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 12:31:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Stephen Warren <swarren@nvidia.com>, Joseph Lo <josephl@nvidia.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 07/21] ARM: tegra: unify tegra_idle_device definitions
Date: Tue, 23 Apr 2013 18:30:39 +0200
Message-Id: <1366734653-488286-8-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366734653-488286-1-git-send-email-arnd@arndb.de>
References: <1366734653-488286-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:8nhlNs6ppyK1rtbrpLwAEDiIt9OYpb7VlLkxfxs0v2q
 qlHzqs+5dxKuZ5ArxPSxJdau/G6cbjzRZR1330vCog175+4Mni
 BM0YyYl3ejvZk5zfkhipWQOqZXGYnQHpcVl4CI0EK0/4OqwqFs
 RGerbROEyYpc+cri3ASszVDuXgKlinOPmqSBp6YkW0VCv59U1V
 1zf0TjsUH1e5ABUapSK7t5j1nC1LcWKgWTqGP2Ru1ihJokc+4V
 wJ0CYFXVyp/M1Au4yAzVkhGiX0E9Rhcr7q6uhxaFgZU7zOSiZB
 lXnm9v+XKM8Rr3aD5Q1Bc/7NuTbEroy80eQAMoXBrdfWbTTmCW
 LP6ve86yC4Ad1YUkMsNZKSc/BBpVif0whLZC2sE7q
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The three tegra variants (20, 30, 114) each define their own per-cpu
variable for tegra_idle_device, which causes link errors when you
build the kernel for more than one of them:

cpuidle-tegra30.o:(.discard+0x0): multiple definition of `__pcpu_unique_tegra_idle_device'
cpuidle-tegra20.o:(.discard+0x0): first defined here
cpuidle-tegra114.o:(.discard+0x0): multiple definition of `__pcpu_unique_tegra_idle_device'
cpuidle-tegra20.o:(.discard+0x0): first defined here

By moving the variable into the common cpuidle.c file, we save a little
bit of object code size and avoid that warning.
As a bonus, this patch also removes the unused "drv" variables in each
of the three files that caused a warning since 0697598db "ARM: tegra:
cpuidle: remove useless initialization".

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Warren <swarren@nvidia.com>
Cc: Joseph Lo <josephl@nvidia.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 arch/arm/mach-tegra/cpuidle-tegra114.c | 5 ++---
 arch/arm/mach-tegra/cpuidle-tegra20.c  | 4 +---
 arch/arm/mach-tegra/cpuidle-tegra30.c  | 4 +---
 arch/arm/mach-tegra/cpuidle.c          | 2 ++
 arch/arm/mach-tegra/cpuidle.h          | 4 ++++
 5 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-tegra/cpuidle-tegra114.c b/arch/arm/mach-tegra/cpuidle-tegra114.c
index 0f4e8c4..09067a1 100644
--- a/arch/arm/mach-tegra/cpuidle-tegra114.c
+++ b/arch/arm/mach-tegra/cpuidle-tegra114.c
@@ -20,6 +20,8 @@
 
 #include <asm/cpuidle.h>
 
+#include "cpuidle.h"
+
 static struct cpuidle_driver tegra_idle_driver = {
 	.name = "tegra_idle",
 	.owner = THIS_MODULE,
@@ -30,14 +32,11 @@ static struct cpuidle_driver tegra_idle_driver = {
 	},
 };
 
-static DEFINE_PER_CPU(struct cpuidle_device, tegra_idle_device);
-
 int __init tegra114_cpuidle_init(void)
 {
 	int ret;
 	unsigned int cpu;
 	struct cpuidle_device *dev;
-	struct cpuidle_driver *drv = &tegra_idle_driver;
 
 	ret = cpuidle_register_driver(&tegra_idle_driver);
 	if (ret) {
diff --git a/arch/arm/mach-tegra/cpuidle-tegra20.c b/arch/arm/mach-tegra/cpuidle-tegra20.c
index 825ced4..c811328 100644
--- a/arch/arm/mach-tegra/cpuidle-tegra20.c
+++ b/arch/arm/mach-tegra/cpuidle-tegra20.c
@@ -36,6 +36,7 @@
 #include "iomap.h"
 #include "irq.h"
 #include "flowctrl.h"
+#include "cpuidle.h"
 
 #ifdef CONFIG_PM_SLEEP
 static bool abort_flag;
@@ -67,8 +68,6 @@ static struct cpuidle_driver tegra_idle_driver = {
 	.en_core_tk_irqen = 1,
 };
 
-static DEFINE_PER_CPU(struct cpuidle_device, tegra_idle_device);
-
 #ifdef CONFIG_PM_SLEEP
 #ifdef CONFIG_SMP
 static void __iomem *pmc = IO_ADDRESS(TEGRA_PMC_BASE);
@@ -220,7 +219,6 @@ int __init tegra20_cpuidle_init(void)
 	int ret;
 	unsigned int cpu;
 	struct cpuidle_device *dev;
-	struct cpuidle_driver *drv = &tegra_idle_driver;
 
 #ifdef CONFIG_PM_SLEEP
 	tegra_tear_down_cpu = tegra20_tear_down_cpu;
diff --git a/arch/arm/mach-tegra/cpuidle-tegra30.c b/arch/arm/mach-tegra/cpuidle-tegra30.c
index 8b50cf4..6187478 100644
--- a/arch/arm/mach-tegra/cpuidle-tegra30.c
+++ b/arch/arm/mach-tegra/cpuidle-tegra30.c
@@ -33,6 +33,7 @@
 
 #include "pm.h"
 #include "sleep.h"
+#include "cpuidle.h"
 
 #ifdef CONFIG_PM_SLEEP
 static int tegra30_idle_lp2(struct cpuidle_device *dev,
@@ -65,8 +66,6 @@ static struct cpuidle_driver tegra_idle_driver = {
 	},
 };
 
-static DEFINE_PER_CPU(struct cpuidle_device, tegra_idle_device);
-
 #ifdef CONFIG_PM_SLEEP
 static bool tegra30_cpu_cluster_power_down(struct cpuidle_device *dev,
 					   struct cpuidle_driver *drv,
@@ -160,7 +159,6 @@ int __init tegra30_cpuidle_init(void)
 	int ret;
 	unsigned int cpu;
 	struct cpuidle_device *dev;
-	struct cpuidle_driver *drv = &tegra_idle_driver;
 
 #ifdef CONFIG_PM_SLEEP
 	tegra_tear_down_cpu = tegra30_tear_down_cpu;
diff --git a/arch/arm/mach-tegra/cpuidle.c b/arch/arm/mach-tegra/cpuidle.c
index 4b744c4..1bac560 100644
--- a/arch/arm/mach-tegra/cpuidle.c
+++ b/arch/arm/mach-tegra/cpuidle.c
@@ -27,6 +27,8 @@
 #include "fuse.h"
 #include "cpuidle.h"
 
+DEFINE_PER_CPU(struct cpuidle_device, tegra_idle_device);
+
 static int __init tegra_cpuidle_init(void)
 {
 	int ret;
diff --git a/arch/arm/mach-tegra/cpuidle.h b/arch/arm/mach-tegra/cpuidle.h
index d733f75..a4c5f17 100644
--- a/arch/arm/mach-tegra/cpuidle.h
+++ b/arch/arm/mach-tegra/cpuidle.h
@@ -17,6 +17,10 @@
 #ifndef __MACH_TEGRA_CPUIDLE_H
 #define __MACH_TEGRA_CPUIDLE_H
 
+#include <linux/cpuidle.h>
+
+DECLARE_PER_CPU(struct cpuidle_device, tegra_idle_device);
+
 #ifdef CONFIG_ARCH_TEGRA_2x_SOC
 int tegra20_cpuidle_init(void);
 #else
-- 
1.8.1.2

