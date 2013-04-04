Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761118Ab3DDM5h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 08:57:37 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:59271 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761085Ab3DDM5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 08:57:32 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Olof Johansson <olof@lixom.net>,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 17/18] cpufreq: powerpc: move cpufreq driver to drivers/cpufreq
Date: Thu,  4 Apr 2013 18:24:25 +0530
Message-Id: <027e8f1d4ac8de6351115f15a408431558510abb.1365079581.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1365079581.git.viresh.kumar@linaro.org>
References: <cover.1365079581.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1365079581.git.viresh.kumar@linaro.org>
References: <cover.1365079581.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves cpufreq driver of powerpc platform to drivers/cpufreq.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Olof Johansson <olof@lixom.net>
Cc: linuxppc-dev@lists.ozlabs.org
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
Compile Tested only.

 arch/powerpc/platforms/Kconfig                     | 31 ----------------------
 arch/powerpc/platforms/pasemi/Makefile             |  1 -
 arch/powerpc/platforms/powermac/Makefile           |  2 --
 drivers/cpufreq/Kconfig.powerpc                    | 26 ++++++++++++++++++
 drivers/cpufreq/Makefile                           |  3 +++
 .../cpufreq.c => drivers/cpufreq/pasemi-cpufreq.c  |  0
 .../cpufreq/pmac32-cpufreq.c                       |  0
 .../cpufreq/pmac64-cpufreq.c                       |  0
 8 files changed, 29 insertions(+), 34 deletions(-)
 rename arch/powerpc/platforms/pasemi/cpufreq.c => drivers/cpufreq/pasemi-cpufreq.c (100%)
 rename arch/powerpc/platforms/powermac/cpufreq_32.c => drivers/cpufreq/pmac32-cpufreq.c (100%)
 rename arch/powerpc/platforms/powermac/cpufreq_64.c => drivers/cpufreq/pmac64-cpufreq.c (100%)

diff --git a/arch/powerpc/platforms/Kconfig b/arch/powerpc/platforms/Kconfig
index 52de8bc..46a223f 100644
--- a/arch/powerpc/platforms/Kconfig
+++ b/arch/powerpc/platforms/Kconfig
@@ -194,37 +194,6 @@ config PPC_IO_WORKAROUNDS
 
 source "drivers/cpufreq/Kconfig"
 
-menu "CPU Frequency drivers"
-	depends on CPU_FREQ
-
-config CPU_FREQ_PMAC
-	bool "Support for Apple PowerBooks"
-	depends on ADB_PMU && PPC32
-	select CPU_FREQ_TABLE
-	help
-	  This adds support for frequency switching on Apple PowerBooks,
-	  this currently includes some models of iBook & Titanium
-	  PowerBook.
-
-config CPU_FREQ_PMAC64
-	bool "Support for some Apple G5s"
-	depends on PPC_PMAC && PPC64
-	select CPU_FREQ_TABLE
-	help
-	  This adds support for frequency switching on Apple iMac G5,
-	  and some of the more recent desktop G5 machines as well.
-
-config PPC_PASEMI_CPUFREQ
-	bool "Support for PA Semi PWRficient"
-	depends on PPC_PASEMI
-	default y
-	select CPU_FREQ_TABLE
-	help
-	  This adds the support for frequency switching on PA Semi
-	  PWRficient processors.
-
-endmenu
-
 menu "CPUIdle driver"
 
 source "drivers/cpuidle/Kconfig"
diff --git a/arch/powerpc/platforms/pasemi/Makefile b/arch/powerpc/platforms/pasemi/Makefile
index ce6d789..8e8d4ca 100644
--- a/arch/powerpc/platforms/pasemi/Makefile
+++ b/arch/powerpc/platforms/pasemi/Makefile
@@ -1,3 +1,2 @@
 obj-y	+= setup.o pci.o time.o idle.o powersave.o iommu.o dma_lib.o misc.o
 obj-$(CONFIG_PPC_PASEMI_MDIO)	+= gpio_mdio.o
-obj-$(CONFIG_PPC_PASEMI_CPUFREQ) += cpufreq.o
diff --git a/arch/powerpc/platforms/powermac/Makefile b/arch/powerpc/platforms/powermac/Makefile
index ea47df6..52c6ce1 100644
--- a/arch/powerpc/platforms/powermac/Makefile
+++ b/arch/powerpc/platforms/powermac/Makefile
@@ -9,8 +9,6 @@ obj-y				+= pic.o setup.o time.o feature.o pci.o \
 				   sleep.o low_i2c.o cache.o pfunc_core.o \
 				   pfunc_base.o udbg_scc.o udbg_adb.o
 obj-$(CONFIG_PMAC_BACKLIGHT)	+= backlight.o
-obj-$(CONFIG_CPU_FREQ_PMAC)	+= cpufreq_32.o
-obj-$(CONFIG_CPU_FREQ_PMAC64)	+= cpufreq_64.o
 # CONFIG_NVRAM is an arch. independent tristate symbol, for pmac32 we really
 # need this to be a bool.  Cheat here and pretend CONFIG_NVRAM=m is really
 # CONFIG_NVRAM=y
diff --git a/drivers/cpufreq/Kconfig.powerpc b/drivers/cpufreq/Kconfig.powerpc
index e76992f..2e5a007 100644
--- a/drivers/cpufreq/Kconfig.powerpc
+++ b/drivers/cpufreq/Kconfig.powerpc
@@ -5,3 +5,29 @@ config CPU_FREQ_MAPLE
 	help
 	  This adds support for frequency switching on Maple 970FX
 	  Evaluation Board and compatible boards (IBM JS2x blades).
+
+config CPU_FREQ_PMAC
+	bool "Support for Apple PowerBooks"
+	depends on ADB_PMU && PPC32
+	select CPU_FREQ_TABLE
+	help
+	  This adds support for frequency switching on Apple PowerBooks,
+	  this currently includes some models of iBook & Titanium
+	  PowerBook.
+
+config CPU_FREQ_PMAC64
+	bool "Support for some Apple G5s"
+	depends on PPC_PMAC && PPC64
+	select CPU_FREQ_TABLE
+	help
+	  This adds support for frequency switching on Apple iMac G5,
+	  and some of the more recent desktop G5 machines as well.
+
+config PPC_PASEMI_CPUFREQ
+	bool "Support for PA Semi PWRficient"
+	depends on PPC_PASEMI
+	select CPU_FREQ_TABLE
+	default y
+	help
+	  This adds the support for frequency switching on PA Semi
+	  PWRficient processors.
diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
index db96d74..7b16092f 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -79,6 +79,9 @@ obj-$(CONFIG_ARCH_TEGRA)		+= tegra-cpufreq.o
 ##################################################################################
 # PowerPC platform drivers
 obj-$(CONFIG_CPU_FREQ_MAPLE)		+= maple-cpufreq.o
+obj-$(CONFIG_CPU_FREQ_PMAC)		+= pmac32-cpufreq.o
+obj-$(CONFIG_CPU_FREQ_PMAC64)		+= pmac64-cpufreq.o
+obj-$(CONFIG_PPC_PASEMI_CPUFREQ)	+= pasemi-cpufreq.o
 
 ##################################################################################
 # Other platform drivers
diff --git a/arch/powerpc/platforms/pasemi/cpufreq.c b/drivers/cpufreq/pasemi-cpufreq.c
similarity index 100%
rename from arch/powerpc/platforms/pasemi/cpufreq.c
rename to drivers/cpufreq/pasemi-cpufreq.c
diff --git a/arch/powerpc/platforms/powermac/cpufreq_32.c b/drivers/cpufreq/pmac32-cpufreq.c
similarity index 100%
rename from arch/powerpc/platforms/powermac/cpufreq_32.c
rename to drivers/cpufreq/pmac32-cpufreq.c
diff --git a/arch/powerpc/platforms/powermac/cpufreq_64.c b/drivers/cpufreq/pmac64-cpufreq.c
similarity index 100%
rename from arch/powerpc/platforms/powermac/cpufreq_64.c
rename to drivers/cpufreq/pmac64-cpufreq.c
-- 
1.7.12.rc2.18.g61b472e

