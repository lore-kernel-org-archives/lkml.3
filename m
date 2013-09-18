Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737Ab3IRN0H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 09:26:07 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:49952 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424Ab3IRN0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 09:26:04 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
        linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 00/10] of/irq: Defer interrupt reference resolution
Date: Wed, 18 Sep 2013 15:24:42 +0200
Message-Id: <1379510692-32435-1-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This small series allows interrupt references from the device tree to be
resolved at driver probe time, rather than at device creation time. The
current implementation resolves such references while devices are added
during the call to of_platform_populate(), which happens very early in
the boot process. This causes probe ordering issues, because all devices
that are an interrupt parent for other devices need to have been probed
by that time. This is worked around for primary interrupt controllers by
initializing them using a device tree specific way (of_irq_init()), but
it doesn't work for something like a GPIO controller that is itself a
platform device and an interrupt parent for other devices at the same
time.

Currently such drivers use explicit initcall ordering to force these
chips to be probed earlier than other devices, but that only fixes a
subset of the problematic cases. It doesn't work if the interrupt user
is itself a platform device on the same bus. There are possibly other
cases where it doesn't work either.

This patch series attempts to fix this by not resolving the interrupt
references at device creation time. Instead, some functionality is added
to the driver core to resolve them for each device immediately before it
is probed. Often this is a lot later than the point at which the device
was created, which gives interrupt parents more time and therefore a
better chance of being probed. More importantly, however, it allows the
driver core to detect when an interrupt parent isn't there yet and cause
the device to be queued for deferred probing. After all, resolving probe
ordering issues is one of the primary reason for the introduction of
deferred probing.

Unfortunately the interrupt core code isn't prepared to handle this very
well, so some preparatory work is required.

Patches 1 and 2 are cleanup. Patch 1 modifies of_irq_count() to not use
the heavyweight of_irq_to_resource(), which will actually try to create
a mapping. While not usually harmful, it causes a warning during boot if
the interrupt parent hasn't registered an IRQ domain yet. Furthermore it
is much more than the stated intention of the function, which is to
return the number of interrupts that a device node uses. Various uses of
the of_irq_to_resource() function are replaced by more simpler versions
using irq_of_parse_and_map() in patch 2.

Patches 3 introduces the __irq_create_mapping() function, equivalent to
its non-__ counterpart except that it returns a negative error code on
failure and therefore allows propagation of a precise error code instead
of 0 for all errors. This is an important prerequisite for subsequent
patches. I would've preferred not to introduce an underscore-prefixed
variant but there are about 114 callers and updating them all would've
been rather messy.

Patch 4 updates irq_create_of_mapping() to return a negative error code
on failure instead of 0. The number of the mapped interrupt is returned
in an output parameter. All callers of this function are updated.

Patch 5 adds an __-prefixed variant of irq_of_parse_and_map() which
returns a negative error code on failure instead of 0. The number of
the mapped interrupt is returned in an output parameter.

Patch 6 modifies of_irq_to_resource() to return a negative error code on
failure (so that error can be propagated) and updates all callers.

Patch 7 propagates errors from of_irq_to_resource() to users of the
of_irq_to_resource_table() function.

Patch 8 adds functionality to the platform driver code to resolve
interrupt references at probe time. It uses the negative error code of
the of_irq_to_resource_table() function to trigger deferred probing.

Patch 9 implements similar functionality for I2C devices.

Patch 10 serves as an example of the kind of cleanup that can be done
after this series. Obviously this will require quite a bit of retesting
of working setups, but I think that in the long run we're better off
without the kind of explicit probe ordering employed by the gpio-tegra
driver and many others.

Note that I've only implemented this for platform and I2C devices, but
the same can be done for SPI and possibly other subsystems as well.

There is another use-case that I'm aware of for which a similar solution
could be implemented. IOMMUs on SoCs generally need to hook themselves
up to new platform devices. This causes a similar issues as interrupt
resolution and should be fixable by extending the of_platform_probe()
function introduced in patch 7 of this series.

Changes in v2:
- use more consistent naming and calling conventions
- use less wrappers, update more callers
- make of_platform_probe() idempotent

The initial version of this patch series can be found here:

	https://lkml.org/lkml/2013/9/16/111

Thierry

Thierry Reding (10):
  of/irq: Rework of_irq_count()
  of/irq: Use irq_of_parse_and_map()
  irqdomain: Introduce __irq_create_mapping()
  irqdomain: Return errors from irq_create_of_mapping()
  of/irq: Introduce __irq_of_parse_and_map()
  of/irq: Return errors from of_irq_to_resource()
  of/irq: Propagate errors in of_irq_to_resource_table()
  of/platform: Resolve interrupt references at probe time
  of/i2c: Resolve interrupt references at probe time
  gpio: tegra: Use module_platform_driver()

 arch/arm/mach-integrator/pci_v3.c                |   8 +-
 arch/arm/mach-u300/timer.c                       |   9 +-
 arch/microblaze/pci/pci-common.c                 |   6 +-
 arch/mips/lantiq/irq.c                           |   2 +-
 arch/mips/lantiq/xway/gptu.c                     |   6 +-
 arch/mips/pci/fixup-lantiq.c                     |  12 ++-
 arch/mips/pci/pci-rt3883.c                       |   9 +-
 arch/powerpc/kernel/pci-common.c                 |   7 +-
 arch/powerpc/platforms/83xx/mpc832x_rdb.c        |   2 +-
 arch/powerpc/platforms/cell/celleb_scc_pciex.c   |   8 +-
 arch/powerpc/platforms/cell/celleb_scc_sio.c     |   8 +-
 arch/powerpc/platforms/cell/spider-pic.c         |   7 +-
 arch/powerpc/platforms/cell/spu_manage.c         |   6 +-
 arch/powerpc/platforms/fsl_uli1575.c             |   7 +-
 arch/powerpc/platforms/pseries/event_sources.c   |  12 +--
 arch/powerpc/sysdev/fsl_gtm.c                    |   9 +-
 arch/powerpc/sysdev/mpic_msgr.c                  |   6 +-
 arch/sparc/kernel/of_device_common.c             |  12 ++-
 arch/x86/kernel/devicetree.c                     |  11 ++-
 drivers/base/platform.c                          |   4 +
 drivers/crypto/caam/ctrl.c                       |   2 +-
 drivers/crypto/caam/jr.c                         |   2 +-
 drivers/crypto/omap-sham.c                       |   2 +-
 drivers/gpio/gpio-tegra.c                        |   7 +-
 drivers/i2c/busses/i2c-cpm.c                     |   2 +-
 drivers/i2c/i2c-core.c                           |  24 ++++-
 drivers/input/serio/xilinx_ps2.c                 |   7 +-
 drivers/net/ethernet/arc/emac_main.c             |  10 +--
 drivers/net/ethernet/freescale/fs_enet/mac-fcc.c |   2 +-
 drivers/net/ethernet/freescale/fs_enet/mac-fec.c |   2 +-
 drivers/net/ethernet/freescale/fs_enet/mac-scc.c |   2 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c       |   5 +-
 drivers/of/irq.c                                 |  49 +++++++----
 drivers/of/platform.c                            | 107 +++++++++++++++++++++--
 drivers/pci/host/pci-mvebu.c                     |   9 +-
 drivers/spi/spi-fsl-espi.c                       |   6 +-
 drivers/tty/serial/cpm_uart/cpm_uart_core.c      |   2 +-
 drivers/tty/serial/lantiq.c                      |   2 +-
 include/linux/of_irq.h                           |  27 ++++--
 include/linux/of_platform.h                      |   7 ++
 kernel/irq/irqdomain.c                           |  87 +++++++++++-------
 41 files changed, 353 insertions(+), 161 deletions(-)

-- 
1.8.4

