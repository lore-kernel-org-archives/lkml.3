Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051AbaIKN3w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:29:52 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:47780 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbaIKN3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 09:29:51 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v3 00/17] Introduce ACPI for ARM64 based on ACPI 5.1
To: Hanjun Guo <hanjun.guo@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>, Olof Johansson <olof@lixom.net>
Cc: Graeme Gregory <graeme.gregory@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Will Deacon <will.deacon@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>, Charles.Garcia-Tobin@arm.com,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org,
        Hanjun Guo <hanjun.guo@linaro.org>
In-Reply-To: <1409583475-6978-1-git-send-email-hanjun.guo@linaro.org>
References: <1409583475-6978-1-git-send-email-hanjun.guo@linaro.org>
Date: Thu, 11 Sep 2014 14:29:34 +0100
Message-Id: <20140911132935.068DCC408F6@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  1 Sep 2014 22:57:38 +0800, Hanjun Guo <hanjun.guo@linaro.org> wrote:
> ACPI 5.1 has been released and now be freely available for
> download [1]. It fixed some major gaps to run ACPI on ARM,
> this patch just follow the ACPI 5.1 spec and prepare the
> code to run ACPI on ARM64.
> 
> ACPI 5.1 has some major changes for the following tables and
> method which are essential for ARM platforms:
> 1) MADT table updates.
> 2) FADT updates for PSCI
> 3) GTDT
> 
> This patch set is the ARM64 ACPI core patches covered MADT, FADT
> and GTDT, platform board specific drivers are not covered by this
> patch set, but we provide drivers for Juno to boot with ACPI only
> in the follwing patch set for review purpose.
> 
> We first introduce acpi.c and its related head file which are needed
> by ACPI core, and then get RSDP to extract all the ACPI boot-time tables.
> When all the boot-time tables (FADT, MADT, GTDT) are ready, then
> parse them to init the sytem when booted. Specifically, 
> a) we use FADT to init PSCI and use PSCI to boot SMP;
> b) Use MADT for GIC init and SMP init;
> c) GTDT for arch timer init.
> 
> This patch set is based on 3.17-rc2 and was tested by Graeme on Juno
> and FVP base model boot with ACPI only OK, if you want to test them,
> you can pull from acpi-5.1-v3 branch in leg/acpi repo:
> git://git.linaro.org/leg/acpi/acpi.git
> 
> Updates since v2:
>  - Refactor the code to make SMP/PSCI init with less sperated init
>    path by Tomasz
>  - make ACPI depend on EXPERT
>  - Address lots of comments from Catalin, Sudeep, Geoff
>  - Add Juno device ACPI driver patches for review
> 
> Updates since v1:
>  - Set ACPI default off on ARM64 suggested by Olof;
>  - Rebase the patch set on top of linux-next branch/linux-pm tree which
>    includes the ACPICA for full ACPI 5.1 support.
>  - Update the document as suggested;
>  - Adress lots of comments from Mark, Sudeep, Randy, Naresh, Olof, Geoff
>    and more...
> 
> [1]: http://www.uefi.org/sites/default/files/resources/ACPI_5_1release.pdf

I've read through this entire series now. In my mind, aside from a few
comments that I know you're addressing, this is ready.  The hooks into
arm64 core code are not terribly invasive, it is nicely organized and
manageable. Get the next version out ASAP, but I would also like to see
the diffs from this version to the next so I don't need to review the
entire series again.

Regarding the requests to refactor ACPICA to work better for ARM. I
completely agree that it should be done, but I do not think it should be
a prerequisite to getting this core support merged. That kind of
refactoring is far easier to justify when it has immediate improvement
on the mainline codebase, and it gives us a working baseline to test
against. Doing it the other way around just makes things harder.

I would really like to see the next version of this series go into
linux-next. I think this is ready for some wider exposure. Have you got
a branch being pulled into Fengguang's autobuilder yet?

g.

> 
> Al Stone (3):
>   ARM64 / ACPI: Get RSDP and ACPI boot-time tables
>   ARM64 / ACPI: Introduce early_param for "acpi"
>   ARM64 / ACPI: Select ACPI_REDUCED_HARDWARE_ONLY if ACPI is enabled on
>     ARM64
> 
> Ashwin Chaugule (1):
>   ACPI / table: Add new function to get table entries
> 
> Graeme Gregory (4):
>   ARM64 / ACPI: Introduce lowlevel suspend function
>   ARM64 / ACPI: If we chose to boot from acpi then disable FDT
>   ARM64 / ACPI: Enable ARM64 in Kconfig
>   Documentation: ACPI for ARM64
> 
> Hanjun Guo (8):
>   ARM64: Move the init of cpu_logical_map(0) before
>     unflatten_device_tree()
>   ARM64 / ACPI: Make PCI optional for ACPI on ARM64
>   ARM64 / ACPI: Parse FADT table to get PSCI flags for PSCI init
>   ACPI / table: Print GIC information when MADT is parsed
>   ARM64 / ACPI: Parse MADT for SMP initialization
>   ACPI / processor: Make it possible to get CPU hardware ID via GICC
>   ARM64 / ACPI: Introduce ACPI_IRQ_MODEL_GIC and register device's gsi
>   ARM64 / ACPI: Parse GTDT to initialize arch timer
> 
> Tomasz Nowicki (1):
>   ARM64 / ACPI: Add GICv2 specific ACPI boot support
> 
>  Documentation/arm64/arm-acpi.txt     |  218 +++++++++++++++++++++
>  Documentation/kernel-parameters.txt  |    3 +-
>  arch/arm64/Kconfig                   |    3 +
>  arch/arm64/include/asm/acenv.h       |   18 ++
>  arch/arm64/include/asm/acpi.h        |  108 ++++++++++
>  arch/arm64/include/asm/cpu_ops.h     |    1 +
>  arch/arm64/include/asm/pci.h         |   11 ++
>  arch/arm64/include/asm/psci.h        |    3 +-
>  arch/arm64/include/asm/smp.h         |    5 +-
>  arch/arm64/kernel/Makefile           |    1 +
>  arch/arm64/kernel/acpi.c             |  359 ++++++++++++++++++++++++++++++++++
>  arch/arm64/kernel/cpu_ops.c          |    4 +-
>  arch/arm64/kernel/irq.c              |    5 +
>  arch/arm64/kernel/psci.c             |   78 +++++---
>  arch/arm64/kernel/setup.c            |   23 ++-
>  arch/arm64/kernel/smp.c              |    2 +-
>  arch/arm64/kernel/time.c             |    7 +
>  drivers/acpi/Kconfig                 |    6 +-
>  drivers/acpi/Makefile                |    2 +-
>  drivers/acpi/bus.c                   |    3 +
>  drivers/acpi/internal.h              |    5 +
>  drivers/acpi/processor_core.c        |   37 ++++
>  drivers/acpi/tables.c                |  113 +++++++++--
>  drivers/clocksource/arm_arch_timer.c |  117 +++++++++--
>  drivers/irqchip/irq-gic.c            |  114 +++++++++++
>  include/linux/acpi.h                 |    5 +
>  include/linux/clocksource.h          |    6 +
>  include/linux/irqchip/arm-gic-acpi.h |   33 ++++
>  include/linux/pci.h                  |   37 +++-
>  29 files changed, 1237 insertions(+), 90 deletions(-)
>  create mode 100644 Documentation/arm64/arm-acpi.txt
>  create mode 100644 arch/arm64/include/asm/acenv.h
>  create mode 100644 arch/arm64/include/asm/acpi.h
>  create mode 100644 arch/arm64/include/asm/pci.h
>  create mode 100644 arch/arm64/kernel/acpi.c
>  create mode 100644 include/linux/irqchip/arm-gic-acpi.h
> 
> -- 
> 1.7.9.5
> 

