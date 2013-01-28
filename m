Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757775Ab3A1SP6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 13:15:58 -0500
Received: from mail-vc0-f182.google.com ([209.85.220.182]:65325 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757565Ab3A1SPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 13:15:55 -0500
MIME-Version: 1.0
In-Reply-To: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 28 Jan 2013 11:15:34 -0700
Message-ID: <CAErSpo7qk9mnY8x=WXeWAWf6NT-Ky=0eTprupAfZ48F7yjDBng@mail.gmail.com>
Subject: Re: [PATCH 00/14] Rewrite Tegra PCIe driver
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-tegra@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Andrew Murray <andrew.murray@arm.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 9, 2013 at 1:43 PM, Thierry Reding
<thierry.reding@avionic-design.de> wrote:
> This patch series contains an almost complete rewrite of the Tegra PCIe
> driver. The code is moved to the drivers/pci/host directory and turned
> into a proper platform driver, adding MSI and DT support while at it.
> Other PCI host controller drivers can be added to that directory in an
> attempt to make it easier to factor out common code.
>
> Patches 1 to 4 add generic OF helpers to parse a PCI node's ranges
> property as well as obtain the bus, device and function numbers from a
> node's reg property.
>
> Patch 5 provides an implementation of a cache for I/O mappings. This can
> be used in situations where a large physical memory region needs to be
> ioremap()'ed. On Tegra, the PCIe standard and extended configuration
> spaces can be accessed through a 256 MiB window. Mapping that in one
> chunk is wasteful and may not always work because the vmalloc area may
> not be large enough. The implementation in this patch uses an LRU based
> approach to map a limited amount of pages on an as-needed basis.
>
> Patches 6 and 7 prepare the ARM PCI code to enable PCI host controller
> drivers to load after the init stage, which can happen due to deferred
> probing, and to allow private data to be passed for each controller.
>
> Patches 8 and 9 move some of the Tegra specific code around to allow it
> to be used from outside the arch/arm/mach-tegra directory.
>
> Patch 10 moves the Tegra PCIe controller driver to the drivers/pci/host
> directory and turns it into a proper platform driver. It also adds MSI
> (based on patches by NVIDIA) and DT support.
>
> Patches 11 to 14 add device tree based probing for the TEC, Harmony and
> TrimSlice boards.
>
> Thierry
>
> Andrew Murray (1):
>   of/pci: Provide support for parsing PCI DT ranges property
>
> Thierry Reding (13):
>   of/pci: Add of_pci_get_devfn() function
>   of/pci: Add of_pci_get_bus() function
>   of/pci: Add of_pci_parse_bus_range() function
>   lib: Add I/O map cache implementation
>   ARM: pci: Keep pci_common_init() around after init
>   ARM: pci: Allow passing per-controller private data
>   ARM: tegra: Move tegra_pcie_xclk_clamp() to PMC
>   ARM: tegra: Move pmc.h to include/mach
>   PCI: tegra: Move PCIe driver to drivers/pci/host
>   ARM: tegra: tamonten: Add PCIe support
>   ARM: tegra: tec: Add PCIe support
>   ARM: tegra: harmony: Initialize PCIe from DT
>   ARM: tegra: trimslice: Initialize PCIe from DT
>
>  .../bindings/pci/nvidia,tegra20-pcie.txt           |  115 ++
>  arch/arm/Kconfig                                   |    2 +
>  arch/arm/boot/dts/tegra20-harmony.dts              |   20 +-
>  arch/arm/boot/dts/tegra20-tamonten.dtsi            |    2 +-
>  arch/arm/boot/dts/tegra20-tec.dts                  |  198 +++
>  arch/arm/boot/dts/tegra20-trimslice.dts            |   12 +
>  arch/arm/boot/dts/tegra20.dtsi                     |   45 +
>  arch/arm/include/asm/mach/pci.h                    |    1 +
>  arch/arm/kernel/bios32.c                           |    9 +-
>  arch/arm/mach-tegra/Kconfig                        |    5 -
>  arch/arm/mach-tegra/Makefile                       |    3 -
>  arch/arm/mach-tegra/board-dt-tegra20.c             |   24 -
>  arch/arm/mach-tegra/board-harmony-pcie.c           |   84 --
>  arch/arm/mach-tegra/board.h                        |    4 +-
>  arch/arm/mach-tegra/common.c                       |    2 +-
>  arch/arm/mach-tegra/include/mach/pmc.h             |   24 +
>  arch/arm/mach-tegra/iomap.h                        |    3 -
>  arch/arm/mach-tegra/pcie.c                         |  887 -------------
>  arch/arm/mach-tegra/pmc.c                          |   16 +
>  arch/arm/mach-tegra/pmc.h                          |   23 -
>  drivers/of/address.c                               |   63 +
>  drivers/of/of_pci.c                                |   78 +-
>  drivers/pci/Kconfig                                |    2 +
>  drivers/pci/Makefile                               |    3 +
>  drivers/pci/host/Kconfig                           |    8 +
>  drivers/pci/host/Makefile                          |    1 +
>  drivers/pci/host/pci-tegra.c                       | 1322 ++++++++++++++++++++
>  include/linux/io.h                                 |   12 +
>  include/linux/of_address.h                         |    9 +
>  include/linux/of_pci.h                             |    3 +
>  lib/ioremap.c                                      |  266 ++++
>  31 files changed, 2203 insertions(+), 1043 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/pci/nvidia,tegra20-pcie.txt
>  delete mode 100644 arch/arm/mach-tegra/board-harmony-pcie.c
>  create mode 100644 arch/arm/mach-tegra/include/mach/pmc.h
>  delete mode 100644 arch/arm/mach-tegra/pcie.c
>  delete mode 100644 arch/arm/mach-tegra/pmc.h
>  create mode 100644 drivers/pci/host/Kconfig
>  create mode 100644 drivers/pci/host/Makefile
>  create mode 100644 drivers/pci/host/pci-tegra.c

Hi Thierry,

Since the bulk of this series affects ARM, I'm assuming this will be
merged via the ARM tree or at least some non-PCI route.  It looks like
[10/14] is the only one that touches drivers/pci, and since it's only
adding new stuff (the rewrite of the Tegra PCIe driver, if I
understand correctly), that's fine with me.

There have been enough comments that I assume you'll be posting an
updated series soon.  I'll watch for it and review and ack the
drivers/pci parts.  Let me know if you want me to do anything else.

Bjorn
