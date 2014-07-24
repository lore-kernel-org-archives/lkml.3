Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758961AbaGXNAo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 09:00:44 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:52111 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758768AbaGXNAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 09:00:41 -0400
From: Hanjun Guo <hanjun.guo@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>
Cc: Graeme Gregory <graeme.gregory@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Will Deacon <will.deacon@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@linaro.org>, Robert Richter <rric@kernel.org>,
        Lv Zheng <lv.zheng@intel.com>, Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>, Charles.Garcia-Tobin@arm.com,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-acpi-private@linaro.org,
        Hanjun Guo <hanjun.guo@linaro.org>
Subject: [PATCH 00/19] Introduce ACPI for ARM64 based on ACPI 5.1
Date: Thu, 24 Jul 2014 21:00:06 +0800
Message-Id: <1406206825-15590-1-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACPI 5.1 was released [1] and it fixed some major gaps to run ACPI
on ARM, this patch just follow the ACPI 5.1 spec and prepare the
code to run ACPI on ARM64.

ACPI 5.1 has some major changes for the following tables and
method which are essential for ARM platforms:

1) MADT table updates.
New fields were introduced to cover MPIDR and virtualization in
GICC, and introduce GICR and GIC MSI frame structure to cover
GICv3 and GICv2m (this patch set only cover GICv2).

2) FADT updates for PSCI
New fields were introduced to cover PSCI and ACPI can use psci
to boot SMP and other PSCI related functions.

3) GTDT
GTDT was updated to support arch timer, memory-mapped tiemr,
SBSA watchdog timer, in this patch, only arch timer tested on
Juno board, so only arch timer init is available.

4) _DSD
_DSD (Device Specific Data) will provide some key values which
presented by FDT before, it makes possible that some devices can
be emumerated in ACPI way, please refer to the document provided
in this patch set for detail.

This patch set is the ARM64 ACPI core patches covered MADT, FADT
and GTDT, _DSD is not covered in this patch set. We first introduce
acpi.c and its related head file which are needed by ACPI core, and
then get RSDP to extract all the ACPI boot-time tables.

When all the boot-time tables (FADT, MADT, GTDT) are ready, then
parse them to init the sytem when booted. Specifically, 
a) we use FADT to init PSCI and use PSCI to boot SMP;
b) Use MADT for GIC init and SMP init;
c) GTDT for arch timer init.

This patch set is based on the former ACPICA patches I sent, and I
already compiled it OK with:
a) each patch applied on ARM64 with CONFIG_ACPI=y;
b) CONFIG_ACPI=n on ARM64;
c) CONFIG_ACPI=y on x86.

Also this patch set was tested by Graeme on ARM64 Juno platform, it
boot successfully with ACPI only (no device tree).

[1]
You can download ACPI 5.1 from http://www.uefi.org/specifications

Al Stone (3):
  ARM64 / ACPI: Get RSDP and ACPI boot-time tables
  ARM64 / ACPI: Introduce early_param for "acpi"
  ARM64 / ACPI: Select ACPI_REDUCED_HARDWARE_ONLY if ACPI is enabled on
    ARM64

Ashwin Chaugule (1):
  ACPI / table: Add new function to get table entries

Graeme Gregory (4):
  ARM64 / ACPI: Introduce lowlevel suspend function
  ARM64 / ACPI: If we chose to boot from acpi then disable FDT
  ARM64 / ACPI: Enable ARM64 in Kconfig
  Documentation: ACPI for ARM64

Hanjun Guo (10):
  ARM64 / ACPI: Introduce arch_fix_phys_package_id() for cpu topology
  ARM64 / ACPI: Make PCI optional for ACPI on ARM64
  ARM64 / ACPI: Parse FADT table to get PSCI flags for PSCI init
  ARM64 / ACPI: Parse MADT to map logical cpu to MPIDR and get
    cpu_possible/present_map
  ACPI / table: Print GIC information when MADT is parsed
  ARM64 / ACPI: Move the initialization of cpu_logical_map(0) before
    acpi_boot_init()
  ARM64 / ACPI: Get the enable method for SMP initialization in ACPI
    way
  ACPI / processor: Make it possible to get CPU hardware ID via GICC
  ARM64 / ACPI: Introduce ACPI_IRQ_MODEL_GIC and register device's gsi
  ARM64 / ACPI: Parse GTDT to initialize arch timer

Tomasz Nowicki (1):
  ARM64 / ACPI: Add GICv2 specific ACPI boot support

 Documentation/arm64/arm-acpi.txt     |  240 ++++++++++++++++++++
 Documentation/kernel-parameters.txt  |    3 +-
 arch/arm64/Kconfig                   |    3 +
 arch/arm64/include/asm/acenv.h       |   18 ++
 arch/arm64/include/asm/acpi.h        |   90 ++++++++
 arch/arm64/include/asm/cpu.h         |   11 +
 arch/arm64/include/asm/cpu_ops.h     |    9 +-
 arch/arm64/include/asm/pci.h         |   11 +
 arch/arm64/include/asm/smp.h         |    2 +-
 arch/arm64/include/asm/topology.h    |    2 +
 arch/arm64/kernel/Makefile           |    1 +
 arch/arm64/kernel/acpi.c             |  403 ++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/cpu_ops.c          |   52 ++++-
 arch/arm64/kernel/irq.c              |    5 +
 arch/arm64/kernel/psci.c             |   95 +++++---
 arch/arm64/kernel/setup.c            |   11 +-
 arch/arm64/kernel/smp.c              |   39 +++-
 arch/arm64/kernel/time.c             |    7 +
 arch/arm64/kernel/topology.c         |   14 ++
 drivers/acpi/Kconfig                 |    6 +-
 drivers/acpi/Makefile                |    2 +-
 drivers/acpi/bus.c                   |    3 +
 drivers/acpi/internal.h              |    5 +
 drivers/acpi/processor_core.c        |   36 +++
 drivers/acpi/tables.c                |  109 +++++++--
 drivers/clocksource/arm_arch_timer.c |  117 ++++++++--
 drivers/irqchip/irq-gic.c            |  114 ++++++++++
 include/linux/acpi.h                 |    5 +
 include/linux/clocksource.h          |    6 +
 include/linux/irqchip/arm-gic-acpi.h |   36 +++
 include/linux/pci.h                  |   37 +++-
 31 files changed, 1397 insertions(+), 95 deletions(-)
 create mode 100644 Documentation/arm64/arm-acpi.txt
 create mode 100644 arch/arm64/include/asm/acenv.h
 create mode 100644 arch/arm64/include/asm/acpi.h
 create mode 100644 arch/arm64/include/asm/cpu.h
 create mode 100644 arch/arm64/include/asm/pci.h
 create mode 100644 arch/arm64/kernel/acpi.c
 create mode 100644 include/linux/irqchip/arm-gic-acpi.h

-- 
1.7.9.5

