Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473AbaAQM0u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 07:26:50 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:64657 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbaAQM0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 07:26:48 -0500
From: Hanjun Guo <hanjun.guo@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Olof Johansson <olof@lixom.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        patches@linaro.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, linaro-acpi@lists.linaro.org,
        Charles.Garcia-Tobin@arm.com, Hanjun Guo <hanjun.guo@linaro.org>
Subject: [PATCH 00/20] Make ACPI core running on ARM64
Date: Fri, 17 Jan 2014 20:24:54 +0800
Message-Id: <1389961514-13562-1-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set trys to make ACPI core running on ARM64.

1. Why ACPI is needed ?
ACPI provides standard interfaces for power managment, themal
control, device enumeration and configuration and etc. So ACPI
can make OS and hardware decoupling and make people upgrade
software or hardware more easily.

ACPI is more than that. It can provide standard error report
interface called ACPI Platform Error Interface (APEI) for
RAS features, and provide standard interface for dynamic
system device reconfigurations such as CPU/memory/computer
node hot-add and hot-remove, this is especially useful
for servers.

2. Does ACPI run propably on ARM64 ?
ACPI spec 5.0 introduces hardware reduced mode, GICC/GICD,
GTDT for arch timer and etc for Socs.

This makes it possible to run ACPI on ARM/ARM64. Some
company already did that (UEFI+ACPI) on ARM platforms.
ACPI spec for ARM/ARM64 is still need to be improved and
people are working on that, but for now, we can run ACPI
propably except for some new features such as PSCI and
GICv3.

3. What we did in this patch set
patch 1-8(Hanjun Guo) will make ACPI core running on ARM64 and
make the compilation is ok on ARM64.

patch 9-12 will enumeration cpus presented by MADT table.
since PSCI is not available for ACPI 5.0, we use spin-table
method for SMP initialization.

patch 13-16 will initialize GIC in the system. ACPI only
support one GIC and only report information about GICC and
GICD, so there will some limitations for GICv3 and GICH
for GICv2 for virtualization.

patch 17-19 and patch from Amit will finish the arch timer
initialization. We get informatiom from GTDT
(Generic Timer Description Table) to initialize arch timer
and introduce a macro CLOCKSOURCE_ACPI_DECLARE to do the
same job as CLOCKSOURCE_OF_DECLARE to make it scalable for
other timers.

All the ACPI tables are available with BSD license at:
git://git.linaro.org/arm/acpi/acpi-asl.git

Changs since last RFC version:
1) Introduce some PCI functions when PCI is enabled
2) Select ACPI_REDUCED_HARDWARE_ONLY if ACPI is enabled
3) Remove ACPI based CPU hotplug code
4) Use spin-table method for SMP initialization
5) Add macro CLOCKSOURCE_ACPI_DECLARE for ACPI timer init
6) Address lots of comments and suggestions in last RFC version
7) Remove RFC tag and make all the patches seperated as two
   parts, one is "ACPI: Some patches to prepare for running ACPI
   on !x86 and !ia64", and another is this one.
8) Rebased on 3.13-rc8.

Amit Daniel Kachhap (1):
  clocksource / acpi: Add macro CLOCKSOURCE_ACPI_DECLARE

Hanjun Guo (19):
  ARM64 / ACPI: Make PCI optional for ACPI on ARM64
  ARM64 : Add dummy asm/cpu.h
  ARM64 / ACPI: Introduce the skeleton of _PDC related for ARM64
  ARM64 / ACPI: Introduce arm_core.c and its related head file
  ARM64 / ACPI: Introduce lowlevel suspend function
  ARM64 / ACPI: Introduce some PCI functions when PCI is enabled
  ARM64 / ACPI: Enable ARM64 in Kconfig
  ARM64 / ACPI: Select ACPI_REDUCED_HARDWARE_ONLY if ACPI is enabled on
    ARM64
  ARM64 / ACPI: Implement core functions for parsing MADT table
  ARM64 / ACPI: Enumerate possible/present CPU set and map logical cpu
    id to APIC id
  ARM64 / ACPI: Get the enable method for SMP initialization
  ARM64 / ACPI: Use Parked Address in GIC structure for spin table SMP
    initialisation
  ARM64 / ACPI: Define ACPI_IRQ_MODEL_GIC needed for arm
  Irqchip / gic: Set as default domain so we can access from ACPI
  ACPI / ARM64: Update acpi_register_gsi to register with the core IRQ
    subsystem
  ACPI / GIC: Initialize GIC using the information in MADT
  clocksource / arch_timer: Use ACPI GTDT table to initialize arch
    timer
  clocksource / ACPI: Introduce clocksource_acpi_init() using
    CLOCKSOURCE_ACPI_DECLARE
  ARM64 / clocksource: Use clocksource_acpi_init()

 arch/arm64/Kconfig                   |    3 +
 arch/arm64/Makefile                  |    1 +
 arch/arm64/include/asm/acpi.h        |  112 +++++++
 arch/arm64/include/asm/cpu.h         |   25 ++
 arch/arm64/include/asm/cpu_ops.h     |    1 +
 arch/arm64/include/asm/pci.h         |   20 ++
 arch/arm64/include/asm/processor.h   |    2 +
 arch/arm64/include/asm/smp.h         |    2 +-
 arch/arm64/kernel/cpu_ops.c          |    2 +-
 arch/arm64/kernel/irq.c              |    6 +
 arch/arm64/kernel/process.c          |    3 +
 arch/arm64/kernel/setup.c            |    6 +
 arch/arm64/kernel/smp.c              |   42 ++-
 arch/arm64/kernel/smp_spin_table.c   |   12 +-
 arch/arm64/kernel/time.c             |    6 +
 arch/arm64/pci/Makefile              |    1 +
 arch/arm64/pci/pci.c                 |   33 ++
 drivers/acpi/Kconfig                 |   11 +-
 drivers/acpi/Makefile                |    4 +-
 drivers/acpi/bus.c                   |    3 +
 drivers/acpi/internal.h              |    7 +
 drivers/acpi/osl.c                   |    3 +-
 drivers/acpi/plat/Makefile           |    1 +
 drivers/acpi/plat/arm-core.c         |  599 ++++++++++++++++++++++++++++++++++
 drivers/acpi/tables.c                |   21 ++
 drivers/clocksource/Makefile         |    1 +
 drivers/clocksource/arm_arch_timer.c |  101 +++++-
 drivers/clocksource/clksrc-acpi.c    |   36 ++
 drivers/irqchip/irq-gic.c            |    7 +
 include/asm-generic/vmlinux.lds.h    |   10 +
 include/linux/acpi.h                 |    7 +
 include/linux/clocksource.h          |   15 +
 include/linux/pci.h                  |   33 +-
 33 files changed, 1099 insertions(+), 37 deletions(-)
 create mode 100644 arch/arm64/include/asm/acpi.h
 create mode 100644 arch/arm64/include/asm/cpu.h
 create mode 100644 arch/arm64/include/asm/pci.h
 create mode 100644 arch/arm64/pci/Makefile
 create mode 100644 arch/arm64/pci/pci.c
 create mode 100644 drivers/acpi/plat/Makefile
 create mode 100644 drivers/acpi/plat/arm-core.c
 create mode 100644 drivers/clocksource/clksrc-acpi.c

-- 
1.7.9.5

