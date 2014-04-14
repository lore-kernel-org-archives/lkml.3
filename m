Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606AbaDNPK0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 11:10:26 -0400
Received: from top.free-electrons.com ([176.31.233.9]:60677 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750983AbaDNPKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 11:10:22 -0400
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
Subject: [PATCH v7 00/11]  CPU idle for Armada XP
Date: Mon, 14 Apr 2014 17:10:03 +0200
Message-Id: <1397488214-20685-1-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds the CPU idle support for Armada XP and prepares
the support for Armada 370. This was based on the work of Nadav
Haklai.

The main change in this new version is a rebasing onto the v3.15-rc1
and the last PMSU reworked series sent by Thomas Petazzoni:
http://www.spinics.net/lists/arm-kernel/msg322113.html

The first patch should go through ARM subsystem and should be taken by
Russell King. It was alreadu submitted to Russell's patch system.

All the other patches can go to mvebu subsystem (and then arm-soc), as
the PM related patches have received the acked-by from Daniel
Lezcano. From my point of view this series is ready to be pulled.

The whole series (and the pmsu patches needed) is also available in
the branch CPU-idle-ArmadaXP-v7 at
https://github.com/MISL-EBU-System-SW/mainline-public.git

Thanks,

Changelog:

v6 -> v7:

 * Rebased onto v3.15-rc1

 * Added the acked-by from Daniel Lezcano

 * Fix the copyright year in cpuidle-armada-370-xp.c

v5 -> v6:

 * rebased onto the pmsu reworked patch set

 * fixed the wrong indent for ARM_BE8 in coherency_ll.S

 * Improved the tests done in armada_370_xp_cpu_pm_init as suggested
   by Thomas Petazzoni. Each condition is tested separately then it
   will be more readable.

v4 -> v5:

* Call v7 version of suspend and resume from the pj4b callback instead
  of copying the code, following Lorenzo advice.

* Split the low level functions to manipulate HW coherency

* Reorder the included headers in cpuidle-armada-370-xp.c

* Added comment in the inline asm part of armada_370_xp_cpu_suspend
  function where the CR_C is restored.

* Added comment about the fact that Armada XP can us ldrex/strex
  without MMU enabled

* Fixed commit logs

* Added the acked-by from Thomas Petazzoni

* Extend the pmsu registers instead of adding a new set of register

* Move the pm initialization outside of the board file in a
  arch_initcall

* Move most of the architecture specific code in arch/arm/mach-mvebu
  and use platform device data file to pass the callback as suggested
  by Daniel.

* Added the tlb flush if the wfi failed.

* Check the cpu_suspend return value

* rebased on mvebu/for-next to be in sync all the change made in mach-mvebu

v3 -> v4:

* factorized the code in coherency_ll.S and make it autodetect as mush
  as possible

* reordered the introduction of the device tree binding

* removed all the EXPORT_SYMBOL_GPL as the driver can only be built
  into the kernel and never be built as a module.

* moved the armada_370_xp_pmsu_enable_l2_powerdown_onidle function in
  armada_370_cp.c file during the initialization of the platform.

* fixed various coding style issue and typos pointed by Thomas

* fixed all the coding issue style, made the comments more coherent
  and add more comment in the suspend-armada-370-xp.S file.

* moved all the device tree related check from
  armada_370_xp_cpuidle_probe to armada_370_xp_dt_init.

* used cpu_pm_enter() instead of directly calling platform code in
  Armada_370_xp_enter_idle.

* convert the sequence to disable the coherency to the one used in
  TC2.

* Rebased on v3.14-rc1

v2 -> v3:

* Converted the driver to use module_platform_driver. This lead to the
  introduction of a new patch (PATCH 11). Pointed by Daniel Lezcano.

* Used PUIDLE_DRIVER_FLAGS_MASK to store the deep idle information,
  suggested by Daniel Lezcano.

* Removed cpu_init call from armada_370_xp_enter_idle
  function. Pointed by Lorenzo Pieralisi.

* Rebased on v3.12-rc5


v1 -> v2:

* Removed the pm_level kernel parameter. As Kevin Hilman pointed, its
  usage can be replaced by using
  /sys/devices/system/cpu/cpu*/cpuidle/state*/disable or the kernel
  parameter cpuidle.off.

* Used BIT() macro (reported by Ezequiel)

* Made the function more readable the
  armada_370_xp_pmsu_idle_prepare() function (reported by Thomas)

* Moved the config entry in Kconfig.arm, and rename the config symbol
  according the pattern used by other arm cpu: ARM_"soc name"_CPUIDLE

* Moved the build rule under the new ARM SoC section in the Makefile

* Rebased on Linus Torvalds master branch of Thursday September 12

Gregory CLEMENT (11):
  ARM: PJ4B: Add cpu_suspend/cpu_resume hooks for PJ4B
  ARM: mvebu: remove the address parameter for ll_set_cpu_coherent
  ARM: mvebu: ll_set_cpu_coherent always uses the current CPU
  ARM: mvebu: Remove the unused argument of set_cpu_coherent()
  ARM: mvebu: Split low level functions to manipulate HW coherency
  ARM: mvebu: Low level function to disable HW coherency support
  ARM: mvebu: Allow to power down L2 cache controller in idle mode
  ARM: mvebu: Add the PMSU related part of the cpu idle functions
  ARM: mvebu: Register notifier callback for the cpuidle transition
  cpuidle: mvebu: Add initial CPU idle support for Armada 370/XP SoC
  ARM: mvebu: register the cpuidle driver for the Armada XP SoCs

 arch/arm/mach-mvebu/coherency.c         |  16 +--
 arch/arm/mach-mvebu/coherency.h         |   2 +-
 arch/arm/mach-mvebu/coherency_ll.S      | 122 +++++++++++++++----
 arch/arm/mach-mvebu/headsmp.S           |  15 +--
 arch/arm/mach-mvebu/platsmp.c           |   2 +-
 arch/arm/mach-mvebu/pmsu.c              | 207 +++++++++++++++++++++++++++++++-
 arch/arm/mm/proc-v7.S                   |  28 ++++-
 drivers/cpuidle/Kconfig.arm             |   5 +
 drivers/cpuidle/Makefile                |   1 +
 drivers/cpuidle/cpuidle-armada-370-xp.c |  93 ++++++++++++++
 10 files changed, 438 insertions(+), 53 deletions(-)
 create mode 100644 drivers/cpuidle/cpuidle-armada-370-xp.c

-- 
1.8.1.2

