Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996AbaFDQsz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 12:48:55 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:41341 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaFDQsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 12:48:51 -0400
MIME-Version: 1.0
Date: Wed, 4 Jun 2014 11:48:50 -0500
Message-ID: <CAL_JsqKPJzzR-Thvnd7Fw5aTymxvQBp+bf8sdmGfL-xHM+iJ-Q@mail.gmail.com>
Subject: [GIT PULL] DeviceTree updates for 3.16
From: Rob Herring <robherring2@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Grant Likely <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull DT updates for 3.16. This cycle is a bit bigger than
normal with a bunch of FDT clean-ups and the addition of early console
initialization from DT. The earlycon support has a dependency on the
tty tree which is already in your tree.

There's one trivial conflict with your tree in
arch/arm/mach-vexpress/platsmp.c and the hunk should be removed. In my
merge, the auto conflict resolution got the merge in
of_update_property wrong incorrectly applying both hunks. The
incorrect merge commit looks like this:

diff --cc drivers/of/base.c
index 32e969d,567e6e1..779faaa
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@@ -1828,15 -1900,16 +1900,20 @@@ int of_update_property(struct device_no
                next = &(*next)->next;
        }
        raw_spin_unlock_irqrestore(&devtree_lock, flags);
-       if (!found)
-               return -ENODEV;
+       if (rc)
+               return rc;
+
+       /* At early boot, bail out and defer setup to of_init() */
+       if (!of_kset)
+               return 0;

 +      /* At early boot, bail out and defer setup to of_init() */
 +      if (!of_kset)
 +              return found ? 0 : -ENODEV;
 +
        /* Update the sysfs attribute */
-       sysfs_remove_bin_file(&np->kobj, &oldprop->attr);
+       if (oldprop)
+               sysfs_remove_bin_file(&np->kobj, &oldprop->attr);
        __of_add_property_sysfs(np, newprop);

        return 0;

The correct resolution is keeping the first "if (!of_kset)" and
dropping the 2nd one as found is no longer present. I'm not sure why,
but this error doesn't show up in linux-next.

Rob


The following changes since commit d6d211db37e75de2ddc3a4f979038c40df7cc79c:

  Linux 3.15-rc5 (2014-05-09 13:10:52 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/robh/linux.git
tags/devicetree-for-3.16

for you to fetch changes up to 43cb43678705e39b175b325f17938295996aefc7:

  of: handle NULL node in next_child iterators (2014-06-04 04:46:01 -0500)

----------------------------------------------------------------
DeviceTree for 3.16:
- Another round of clean-up of FDT related code in architecture code.
  This removes knowledge of internal FDT details from most architectures
  except powerpc.
- Conversion of kernel's custom FDT parsing code to use libfdt.
- DT based initialization for generic serial earlycon. The introduction
  of generic serial earlycon support went in thru tty tree.
- Improve the platform device naming for DT probed devices to ensure
  unique naming and use parent names instead of a global index.
- Fix a race condition in of_update_property.
- Unify the various linker section OF match tables and fix several
  function prototype errors.
- Update platform_get_irq_byname to work in deferred probe cases.
- 2 binding doc updates

----------------------------------------------------------------
Arnd Bergmann (1):
      of/irq: provide more wrappers for !CONFIG_OF

Florian Fainelli (1):
      of: handle NULL node in next_child iterators

Grant Likely (6):
      of: Ensure unique names without sacrificing determinism
      of: Stop naming platform_device using dcr address
      lib: add glibc style strchrnul() variant
      of: Create unlocked version of for_each_child_of_node()
      of: Make of_find_node_by_path() handle /aliases
      of: Add a testcase for of_find_node_by_path()

Grygorii Strashko (1):
      of/irq: do irq resolution in platform_get_irq_byname()

Ian Molton (1):
      pci/of: Remove dead code

Leif Lindholm (1):
      of: Handle memory@0 node on PPC32 only

Matt Porter (1):
      dt: bindings: dwc2: fix required value for the phy-names property

Rob Herring (46):
      mips: octeon: convert to use unflatten_and_copy_device_tree
      mips: lantiq: copy built-in DTB out of init section
      mips: xlp: copy built-in DTB out of init section
      mips: ralink: convert to use unflatten_and_copy_device_tree
      powerpc: fix skipping call to early_init_fdt_scan_reserved_mem
      ARM: dt: use default early_init_dt_alloc_memory_arch
      c6x: convert fdt pointers to opaque pointers
      mips: convert fdt pointers to opaque pointers
      of/fdt: consolidate built-in dtb section variables
      of/fdt: remove some unneeded includes
      of/fdt: remove unused of_scan_flat_dt_by_path
      of/fdt: update of_get_flat_dt_prop in prep for libfdt
      of/fdt: Convert FDT functions to use libfdt
      of/fdt: use libfdt accessors for header data
      of/fdt: create common debugfs
      of/fdt: move memreserve and dtb memory reservations into core
      of/fdt: fix phys_addr_t related print size warnings
      of/fdt: introduce of_get_flat_dt_size
      powerpc: use libfdt accessors for header data
      x86: use FDT accessors for FDT blob header data
      of/fdt: convert initial_boot_params to opaque pointer
      of: push struct boot_param_header and defines into powerpc
      of/platform: fix device naming for non-translatable addresses
      of: kill off of_can_translate_address
      of/selftest: clean-up of_selftest_platform_populate pass/fail handling
      of/selftest: add testcase for nodes with same name and address
      Merge branch 'dt-bus-name' into for-next
      Merge branch 'tty-next' of git://git.kernel.org/.../gregkh/tty
into for-next
      irqchip: align irqchip OF match table section naming
      ARM: align cpu_method_of_table naming
      vmlinuz.lds: define OF table sections with macros
      of: align RESERVEDMEM_OF_DECLARE function callbacks to other callbacks
      ARM: imx: fix function type for CLK_OF_DECLARE
      clk: rockchip: fix function type for CLK_OF_DECLARE
      clk: sunxi: avoid double DT matching
      clk: sunxi: fix function type for CLK_OF_DECLARE
      irqchip: s3c24xx: Fix function type for IRQCHIP_OF_DECLARE
      irqchip: mxs: Fix function type for IRQCHIP_OF_DECLARE
      clk: ti: add missing semi-colon on CLK_OF_DECLARE
      of: consolidate linker section OF match table declarations
      serial: earlycon: add DT support
      of/fdt: add FDT address translation support
      of/fdt: add FDT serial scanning for earlycon
      tty/serial: pl011: add DT based earlycon support
      Merge tag 'dt-for-robh' of git://git.secretlab.ca/git/linux into for-next
      Merge branch 'earlycon-dt' into for-next

Sergei Shtylyov (1):
      of_pci_irq: kill useless variable in of_irq_parse_pci()

Stephen Boyd (1):
      devicetree: bindings: Document micrel vendor prefix

Thierry Reding (1):
      of: Use NULL for pointers

Xiubo Li (1):
      of: fix race between search and remove in of_update_property()

 .../devicetree/bindings/serial/nxp,sc16is7xx.txt   |   33 +
 Documentation/devicetree/bindings/usb/dwc2.txt     |    2 +-
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 Documentation/kernel-parameters.txt                |    9 +
 arch/arc/include/asm/sections.h                    |    1 -
 arch/arc/kernel/devtree.c                          |    2 +-
 arch/arm/include/asm/prom.h                        |    2 -
 arch/arm/kernel/devtree.c                          |   43 +-
 arch/arm/mach-exynos/exynos.c                      |    2 +-
 arch/arm/mach-imx/clk-imx35.c                      |    4 +-
 arch/arm/mach-vexpress/platsmp.c                   |    2 +-
 arch/arm/mm/init.c                                 |    1 -
 arch/arm/plat-samsung/s5p-dev-mfc.c                |    4 +-
 arch/arm64/Kconfig                                 |    3 +
 arch/arm64/Kconfig.debug                           |    9 -
 arch/arm64/kernel/Makefile                         |    1 -
 arch/arm64/kernel/early_printk.c                   |  156 ---
 arch/arm64/mm/init.c                               |   21 -
 arch/c6x/kernel/setup.c                            |    4 +-
 arch/metag/kernel/setup.c                          |    4 -
 arch/microblaze/kernel/prom.c                      |   39 +-
 arch/mips/cavium-octeon/setup.c                    |   20 +-
 arch/mips/include/asm/mips-boards/generic.h        |    4 -
 arch/mips/include/asm/prom.h                       |    6 +-
 arch/mips/kernel/prom.c                            |    2 +-
 arch/mips/lantiq/prom.c                            |   15 +-
 arch/mips/lantiq/prom.h                            |    2 -
 arch/mips/mti-sead3/sead3-setup.c                  |    8 +-
 arch/mips/netlogic/xlp/dt.c                        |   19 +-
 arch/mips/ralink/of.c                              |   29 +-
 arch/openrisc/kernel/vmlinux.h                     |    2 -
 arch/powerpc/include/asm/dcr-mmio.h                |    4 -
 arch/powerpc/include/asm/prom.h                    |   39 +
 arch/powerpc/kernel/Makefile                       |    1 +
 arch/powerpc/kernel/epapr_paravirt.c               |    2 +-
 arch/powerpc/kernel/fadump.c                       |    4 +-
 arch/powerpc/kernel/prom.c                         |   82 +-
 arch/powerpc/kernel/rtas.c                         |    2 +-
 arch/powerpc/mm/hash_utils_64.c                    |   22 +-
 arch/powerpc/platforms/52xx/efika.c                |    4 +-
 arch/powerpc/platforms/chrp/setup.c                |    4 +-
 arch/powerpc/platforms/powernv/opal.c              |   12 +-
 arch/powerpc/platforms/pseries/setup.c             |    4 +-
 arch/powerpc/sysdev/dcr.c                          |    6 +-
 arch/x86/Kconfig                                   |    3 +
 arch/x86/kernel/devicetree.c                       |   12 +-
 arch/xtensa/kernel/setup.c                         |    3 +-
 drivers/base/platform.c                            |    7 +-
 drivers/bluetooth/hci_ldisc.c                      |   24 +-
 drivers/bluetooth/hci_uart.h                       |    1 +
 drivers/clk/rockchip/clk-rockchip.c                |    3 +-
 drivers/clk/sunxi/clk-sunxi.c                      |    5 +-
 drivers/clk/ti/gate.c                              |    2 +-
 drivers/clocksource/clksrc-of.c                    |    2 +-
 drivers/irqchip/irq-mxs.c                          |    4 +-
 drivers/irqchip/irq-s3c24xx.c                      |    6 +-
 drivers/irqchip/irqchip.c                          |    6 +-
 drivers/irqchip/irqchip.h                          |    7 +-
 drivers/of/Kconfig                                 |    1 +
 drivers/of/Makefile                                |    4 +
 drivers/of/address.c                               |   22 +-
 drivers/of/base.c                                  |  121 +-
 drivers/of/fdt.c                                   |  458 +++----
 drivers/of/fdt_address.c                           |  241 ++++
 drivers/of/irq.c                                   |   22 +
 drivers/of/of_pci_irq.c                            |    8 +-
 drivers/of/of_reserved_mem.c                       |    6 +-
 drivers/of/platform.c                              |   76 +-
 drivers/of/selftest.c                              |   80 +-
 drivers/of/testcase-data/testcases.dtsi            |    1 +
 drivers/of/testcase-data/tests-phandle.dtsi        |    6 +-
 drivers/of/testcase-data/tests-platform.dtsi       |   35 +
 drivers/tty/serial/8250/8250_core.c                |    5 -
 drivers/tty/serial/8250/8250_dw.c                  |   81 +-
 drivers/tty/serial/8250/8250_early.c               |  138 +--
 drivers/tty/serial/8250/Kconfig                    |    6 +-
 drivers/tty/serial/Kconfig                         |   47 +-
 drivers/tty/serial/Makefile                        |    5 +
 drivers/tty/serial/amba-pl011.c                    |   31 +-
 drivers/tty/serial/earlycon-arm-semihost.c         |   61 +
 drivers/tty/serial/earlycon.c                      |  172 +++
 drivers/tty/serial/men_z135_uart.c                 |  866 +++++++++++++
 drivers/tty/serial/mux.c                           |    4 +-
 drivers/tty/serial/omap-serial.c                   |   94 +-
 drivers/tty/serial/pch_uart.c                      |   13 +-
 drivers/tty/serial/pxa.c                           |    5 -
 drivers/tty/serial/sc16is7xx.c                     | 1280 ++++++++++++++++++++
 drivers/tty/serial/serial_core.c                   |    3 +
 drivers/tty/serial/serial_txx9.c                   |    5 -
 drivers/tty/serial/xilinx_uartps.c                 | 1129 +++++++++--------
 include/asm-generic/vmlinux.lds.h                  |   60 +-
 include/linux/clk-provider.h                       |    5 +-
 include/linux/clocksource.h                        |   16 +-
 include/linux/of.h                                 |   22 +
 include/linux/of_address.h                         |    1 -
 include/linux/of_fdt.h                             |   64 +-
 include/linux/of_irq.h                             |    5 +
 include/linux/of_pci.h                             |   36 +-
 include/linux/of_reserved_mem.h                    |   22 +-
 include/linux/serial_core.h                        |   22 +
 include/linux/string.h                             |    3 +
 include/linux/tty_ldisc.h                          |    5 +-
 include/uapi/linux/serial_core.h                   |    8 +-
 include/uapi/linux/serial_reg.h                    |    2 +-
 lib/string.c                                       |   18 +
 105 files changed, 4205 insertions(+), 1831 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/serial/nxp,sc16is7xx.txt
 delete mode 100644 arch/arm64/kernel/early_printk.c
 create mode 100644 drivers/of/fdt_address.c
 create mode 100644 drivers/of/testcase-data/tests-platform.dtsi
 create mode 100644 drivers/tty/serial/earlycon-arm-semihost.c
 create mode 100644 drivers/tty/serial/earlycon.c
 create mode 100644 drivers/tty/serial/men_z135_uart.c
 create mode 100644 drivers/tty/serial/sc16is7xx.c
