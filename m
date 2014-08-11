Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830AbaHKLcu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 07:32:50 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:42662 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbaHKLcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 07:32:48 -0400
Subject: [RFC PATCH V2 01/19] sched/power: Remove cpu idle state selection
 and cpu frequency tuning
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
To: alex.shi@intel.com, vincent.guittot@linaro.org, peterz@infradead.org,
        pjt@google.com, efault@gmx.de, rjw@rjwysocki.net,
        morten.rasmussen@arm.com, svaidy@linux.vnet.ibm.com,
        arjan@linux.intel.com, mingo@kernel.org
Cc: nicolas.pitre@linaro.org, len.brown@intel.com, yuyang.du@intel.com,
        linaro-kernel@lists.linaro.org, daniel.lezcano@linaro.org,
        corbet@lwn.net, catalin.marinas@arm.com, markgross@thegnar.org,
        sundar.iyer@intel.com, linux-kernel@vger.kernel.org,
        dietmar.eggemann@arm.com, Lorenzo.Pieralisi@arm.com,
        mike.turquette@linaro.org, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de
Date: Mon, 11 Aug 2014 17:02:25 +0530
Message-ID: <20140811113145.31956.32224.stgit@preeti.in.ibm.com>
In-Reply-To: <20140811113000.31956.52857.stgit@preeti.in.ibm.com>
References: <20140811113000.31956.52857.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081111-7164-0000-0000-000003BAA163
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a first step towards improving the power awareness of the scheduler,
this patch enables a "dumb" state where all power management is turned off.
Whatever additionally we put into the kernel for cpu power management must
do better than this in terms of performance as well as powersavings.
This will enable us to benchmark and optimize the power aware scheduler
from scratch.If we are to benchmark it against the performance of the
existing design, we will get sufficiently distracted by the performance
numbers and get steered away from a sane design.

Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---

 arch/powerpc/Kconfig                   |    1 +
 arch/powerpc/platforms/powernv/Kconfig |   12 ++++++------
 drivers/cpufreq/Kconfig                |    2 ++
 drivers/cpuidle/Kconfig                |    2 ++
 kernel/Kconfig.sched                   |   11 +++++++++++
 5 files changed, 22 insertions(+), 6 deletions(-)
 create mode 100644 kernel/Kconfig.sched

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 80b94b0..b7fe36a 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -301,6 +301,7 @@ config HIGHMEM
 
 source kernel/Kconfig.hz
 source kernel/Kconfig.preempt
+source kernel/Kconfig.sched
 source "fs/Kconfig.binfmt"
 
 config HUGETLB_PAGE_SIZE_VARIABLE
diff --git a/arch/powerpc/platforms/powernv/Kconfig b/arch/powerpc/platforms/powernv/Kconfig
index 45a8ed0..b0ef8b1 100644
--- a/arch/powerpc/platforms/powernv/Kconfig
+++ b/arch/powerpc/platforms/powernv/Kconfig
@@ -11,12 +11,12 @@ config PPC_POWERNV
 	select PPC_UDBG_16550
 	select PPC_SCOM
 	select ARCH_RANDOM
-	select CPU_FREQ
-	select CPU_FREQ_GOV_PERFORMANCE
-	select CPU_FREQ_GOV_POWERSAVE
-	select CPU_FREQ_GOV_USERSPACE
-	select CPU_FREQ_GOV_ONDEMAND
-	select CPU_FREQ_GOV_CONSERVATIVE
+	select CPU_FREQ if !SCHED_POWER
+	select CPU_FREQ_GOV_PERFORMANCE if CPU_FREQ
+	select CPU_FREQ_GOV_POWERSAVE if CPU_FREQ
+	select CPU_FREQ_GOV_USERSPACE if CPU_FREQ
+	select CPU_FREQ_GOV_ONDEMAND if CPU_FREQ
+	select CPU_FREQ_GOV_CONSERVATIVE if CPU_FREQ
 	select PPC_DOORBELL
 	default y
 
diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
index ffe350f..8976fd6 100644
--- a/drivers/cpufreq/Kconfig
+++ b/drivers/cpufreq/Kconfig
@@ -2,6 +2,7 @@ menu "CPU Frequency scaling"
 
 config CPU_FREQ
 	bool "CPU Frequency scaling"
+	depends on !SCHED_POWER
 	help
 	  CPU Frequency scaling allows you to change the clock speed of 
 	  CPUs on the fly. This is a nice method to save power, because 
@@ -12,6 +13,7 @@ config CPU_FREQ
 	  (see below) after boot, or use a userspace tool.
 
 	  For details, take a look at <file:Documentation/cpu-freq>.
+	  This feature will turn off if power aware scheduling is enabled.
 
 	  If in doubt, say N.
 
diff --git a/drivers/cpuidle/Kconfig b/drivers/cpuidle/Kconfig
index 32748c3..2c4ac79 100644
--- a/drivers/cpuidle/Kconfig
+++ b/drivers/cpuidle/Kconfig
@@ -3,6 +3,7 @@ menu "CPU Idle"
 config CPU_IDLE
 	bool "CPU idle PM support"
 	default y if ACPI || PPC_PSERIES
+	depends on !SCHED_POWER
 	select CPU_IDLE_GOV_LADDER if (!NO_HZ && !NO_HZ_IDLE)
 	select CPU_IDLE_GOV_MENU if (NO_HZ || NO_HZ_IDLE)
 	help
@@ -11,6 +12,7 @@ config CPU_IDLE
 	  governors that can be swapped during runtime.
 
 	  If you're using an ACPI-enabled platform, you should say Y here.
+	  This feature will turn off if power aware scheduling is enabled.
 
 if CPU_IDLE
 
diff --git a/kernel/Kconfig.sched b/kernel/Kconfig.sched
new file mode 100644
index 0000000..374454c
--- /dev/null
+++ b/kernel/Kconfig.sched
@@ -0,0 +1,11 @@
+menu "Power Aware Scheduling"
+
+config SCHED_POWER
+        bool "Power Aware Scheduler"
+        default n
+        help
+           Select this to enable the new power aware scheduler.
+endmenu
+
+
+

