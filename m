Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887AbaLIAVL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 19:21:11 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:50588 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755206AbaLIAVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 19:21:04 -0500
MIME-Version: 1.0
Date: Tue, 9 Dec 2014 01:21:03 +0100
X-Google-Sender-Auth: wVoi97hs-Xj0Hqxmc0q4En8YFQQ
Message-ID: <CAJZ5v0i3UhvaAu9JV_BuB0fPFmHAa_NdX+eXYBnAHcsiaVOw9g@mail.gmail.com>
Subject: [GIT PULL] ACPI and power management updates for 3.19-rc1
From: "Rafael J. Wysocki" <rafael@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

 git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git \
 pm+acpi-3.19-rc1

to receive ACPI and power management updates for v3.19-rc1 with
top-most commit e3d857e1ae787a5e268bc89425aadae09c8e95a4

 Merge branch 'pm-runtime'

on top of commit b2776bf7149bddd1f4161f14f79520f17fc1d71d

 Linux 3.18

This time we have some more new material than we used to have during
the last couple of development cycles.

The most important part of it to me is the introduction of a unified
interface for accessing device properties provided by platform
firmware.  It works with Device Trees and ACPI in a uniform way and
drivers using it need not worry about where the properties come
from as long as the platform firmware (either DT or ACPI) makes
them available.  It covers both devices and "bare" device node
objects without struct device representation as that turns out to
be necessary in some cases.  This has been in the works for quite
a few months (and development cycles) and has been approved by
all of the relevant maintainers.

On top of that, some drivers are switched over to the new interface
(at25, leds-gpio, gpio_keys_polled) and some additional changes are
made to the core GPIO subsystem to allow device drivers to manipulate
GPIOs in the "canonical" way on platforms that provide GPIO information
in their ACPI tables, but don't assign names to GPIO lines (in which
case the driver needs to do that on the basis of what it knows about
the device in question).  That also has been approved by the GPIO
core maintainers and the rfkill driver is now going to use it.

Second is support for hardware P-states in the intel_pstate driver.
It uses CPUID to detect whether or not the feature is supported by
the processor in which case it will be enabled by default.  However,
it can be disabled entirely from the kernel command line if necessary.

Next is support for a platform firmware interface based on ACPI
operation regions used by the PMIC (Power Management Integrated
Circuit) chips on the Intel Baytrail-T and Baytrail-T-CR platforms.
That interface is used for manipulating power resources and for
thermal management: sensor temperature reporting, trip point setting
and so on.

Also the ACPI core is now going to support the _DEP configuration
information in a limited way.  Basically, _DEP it supposed to reflect
off-the-hierarchy dependencies between devices which may be very
indirect, like when AML for one device accesses locations in an
operation region handled by another device's driver (usually, the
device depended on this way is a serial bus or GPIO controller).
The support added this time is sufficient to make the ACPI battery
driver work on Asus T100A, but it is general enough to be able to
cover some other use cases in the future.

Finally, we have a new cpufreq driver for the Loongson1B processor.

In addition to the above, there are fixes and cleanups all over the
place as usual and a traditional ACPICA update to a recent upstream
release.

As far as the fixes go, the ACPI LPSS (Low-power Subsystem) driver
for Intel platforms should be able to handle power management of
the DMA engine correctly, the cpufreq-dt driver should interact
with the thermal subsystem in a better way and the ACPI backlight
driver should handle some more corner cases, among other things.

On top of the ACPICA update there are fixes for race conditions
in the ACPICA's interrupt handling code which might lead to some
random and strange looking failures on some systems.

In the cleanups department the most visible part is the series
of commits targeted at getting rid of the CONFIG_PM_RUNTIME
configuration option.  That was triggered by a discussion
regarding the generic power domains code during which we realized
that trying to support certain combinations of PM config options
was painful and not really worth it, because nobody would use them
in production anyway.  For this reason, we decided to make
CONFIG_PM_SLEEP select CONFIG_PM_RUNTIME and that lead to the
conclusion that the latter became redundant and CONFIG_PM could
be used instead of it.  The material here makes that replacement
in a major part of the tree, but there will be at least one more
batch of that in the second part of the merge window.

Specifics:

 - Support for retrieving device properties information from ACPI
   _DSD device configuration objects and a unified device properties
   interface for device drivers (and subsystems) on top of that.
   As stated above, this works with Device Trees and ACPI and allows
   device drivers to be written in a platform firmware (DT or ACPI)
   agnostic way.  The at25, leds-gpio and gpio_keys_polled drivers
   are now going to use this new interface and the GPIO subsystem
   is additionally modified to allow device drivers to assign names
   to GPIO resources returned by ACPI _CRS objects (in case _DSD is
   not present or does not provide the expected data).  The changes
   in this set are mostly from Mika Westerberg, Rafael J Wysocki,
   Aaron Lu, and Darren Hart with some fixes from others (Fabio Estevam,
   Geert Uytterhoeven).

 - Support for Hardware Managed Performance States (HWP) as described
   in Volume 3, section 14.4, of the Intel SDM in the intel_pstate
   driver.  CPUID is used to detect whether or not the feature is
   supported by the processor.  If supported, it will be enabled
   automatically unless the intel_pstate=no_hwp switch is present in
   the kernel command line.  From Dirk Brandewie.

 - New Intel Broadwell-H ID for intel_pstate (Dirk Brandewie).

 - Support for firmware interface based on ACPI operation regions
   used by the PMIC chips on the Intel Baytrail-T and Baytrail-T-CR
   platforms for power resource control and thermal management
   (Aaron Lu).

 - Limited support for retrieving off-the-hierarchy dependencies
   between devices from ACPI _DEP device configuration objects
   and deferred probing support for the ACPI battery driver based
   on the _DEP information to make that driver work on Asus T100A
   (Lan Tianyu).

 - New cpufreq driver for the Loongson1B processor (Kelvin Cheung).

 - ACPICA update to upstream revision 20141107 which only affects
   tools (Bob Moore).

 - Fixes for race conditions in the ACPICA's interrupt handling
   code and in the ACPI code related to system suspend and resume
   (Lv Zheng and Rafael J Wysocki).

 - ACPI core fix for an RCU-related issue in the ioremap() regions
   management code that slowed down significantly after CPUs had
   been allowed to enter idle states even if they'd had RCU callbakcs
   queued and triggered some problems in certain proprietary graphics
   driver (and elsewhere).  The fix replaces synchronize_rcu() in
   that code with synchronize_rcu_expedited() which makes the issue
   go away.  From Konstantin Khlebnikov.

 - ACPI LPSS (Low-Power Subsystem) driver fix to handle power
   management of the DMA engine included into the LPSS correctly.
   The problem is that the DMA engine doesn't have ACPI PM support
   of its own and it simply is turned off when the last LPSS device
   having ACPI PM support goes into D3cold.  To work around that,
   the PM domain used by the ACPI LPSS driver is redesigned so at
   least one device with ACPI PM support will be on as long as the
   DMA engine is in use.  From Andy Shevchenko.

 - ACPI backlight driver fix to avoid using it on "Win8-compatible"
   systems where it doesn't work and where it was used by default by
   mistake (Aaron Lu).

 - Assorted minor ACPI core fixes and cleanups from Tomasz Nowicki,
   Sudeep Holla, Huang Rui, Hanjun Guo, Fabian Frederick, and
   Ashwin Chaugule (mostly related to the upcoming ARM64 support).

 - Intel RAPL (Running Average Power Limit) power capping driver
   fixes and improvements including new processor IDs (Jacob Pan).

 - Generic power domains modification to power up domains after
   attaching devices to them to meet the expectations of device
   drivers and bus types assuming devices to be accessible at
   probe time (Ulf Hansson).

 - Preliminary support for controlling device clocks from the
   generic power domains core code and modifications of the
   ARM/shmobile platform to use that feature (Ulf Hansson).

 - Assorted minor fixes and cleanups of the generic power
   domains core code (Ulf Hansson, Geert Uytterhoeven).

 - Assorted minor fixes and cleanups of the device clocks control
   code in the PM core (Geert Uytterhoeven, Grygorii Strashko).

 - Consolidation of device power management Kconfig options by making
   CONFIG_PM_SLEEP select CONFIG_PM_RUNTIME and removing the latter
   which is now redundant (Rafael J Wysocki and Kevin Hilman).  That
   is the first batch of the changes needed for this purpose.

 - Core device runtime power management support code cleanup related
   to the execution of callbacks (Andrzej Hajda).

 - cpuidle ARM support improvements (Lorenzo Pieralisi).

 - cpuidle cleanup related to the CPUIDLE_FLAG_TIME_VALID flag and
   a new MAINTAINERS entry for ARM Exynos cpuidle (Daniel Lezcano and
   Bartlomiej Zolnierkiewicz).

 - New cpufreq driver callback (->ready) to be executed when the
   cpufreq core is ready to use a given policy object and cpufreq-dt
   driver modification to use that callback for cooling device
   registration (Viresh Kumar).

 - cpufreq core fixes and cleanups (Viresh Kumar, Vince Hsu,
   James Geboski, Tomeu Vizoso).

 - Assorted fixes and cleanups in the cpufreq-pcc, intel_pstate,
   cpufreq-dt, pxa2xx cpufreq drivers (Lenny Szubowicz, Ethan Zhao,
   Stefan Wahren, Petr Cvek).

 - OPP (Operating Performance Points) framework modification to
   allow OPPs to be removed too and update of a few cpufreq drivers
   (cpufreq-dt, exynos5440, imx6q, cpufreq) to remove OPPs (added
   during initialization) on driver removal (Viresh Kumar).

 - Hibernation core fixes and cleanups (Tina Ruchandani and
   Markus Elfring).

 - PM Kconfig fix related to CPU power management (Pankaj Dubey).

 - cpupower tool fix (Prarit Bhargava).

Thanks!


---------------

Aaron Lu (7):
      ACPI / video: Run _BCL before deciding registering backlight
      input: gpio_keys_polled: Add support for GPIO descriptors
      input: gpio_keys_polled: Make use of device property API
      iio: adc: Add module device table for autoloading
      ACPI / PMIC: support PMIC operation region for CrystalCove
      ACPI / PMIC: support PMIC operation region for XPower AXP288
      ACPI / PMIC: AXP288: support virtual GPIO in ACPI table

Andrzej Hajda (1):
      PM / Runtime: Rework RPM get callback routines

Andy Shevchenko (4):
      ACPI / LPSS: add all LPSS devices to the specific power domain
      ACPI / LPSS: allow to use specific PM domain during ->probe()
      ACPI / LPSS: introduce a 'proxy' device to power on LPSS for DMA
      dmaengine: dw: enable runtime PM

Ashwin Chaugule (1):
      ACPI / table: Add new function to get table entries

Bartlomiej Zolnierkiewicz (1):
      cpuidle: add MAINTAINERS entry for ARM Exynos cpuidle driver

Bob Moore (6):
      ACPICA: iASL: Add support for to_PLD macro.
      ACPICA: acpiexec: Add option to specify an object initialization file.
      ACPICA: Disassembler: Add support for C-style operators and expressions.
      ACPICA: Disassembler: Update for C-style expressions.
      ACPICA: Disassembler: Emit correct string for 0 stop bits.
      ACPICA: Update version to 20141107.

Daniel Lezcano (1):
      cpuidle: Invert CPUIDLE_FLAG_TIME_VALID logic

Dirk Brandewie (3):
      x86: Add support for Intel HWP feature detection.
      intel_pstate: Add support for HWP
      intel_pstate: Add CPUID for BDW-H CPU

Fabian Frederick (1):
      ACPI: remove unnecessary sizeof(u8)

Fabio Estevam (1):
      leds: leds-gpio: Fix multiple instances registration without
'label' property

Geert Uytterhoeven (4):
      leds: leds-gpio: Fix legacy GPIO number case
      PM / clock_ops: Add pm_clk_add_clk()
      PM / Domains: Make genpd parameter of pm_genpd_present() const
      PM / Domains: Extract code to power off/on a PM domain

Hanjun Guo (2):
      ACPI / processor: Update the comments in processor.h
      ACPI / Kconfig: Remove redundant depends on ACPI

Huang Rui (1):
      ACPI / PM: Fixed a typo in a comment

Jacob Pan (8):
      mfd: axp20x: Extend axp20x to support axp288 pmic
      iio: adc: Add support for axp288 adc
      powercap / RAPL: abstract per cpu type functions
      powercap / RAPL: handle atom and core differences
      powercap / RAPL: add new model ids
      powercap / RAPL: fix build dependency on iosf_mbi
      mfd/axp20x: avoid irq numbering collision
      iio/axp288_adc: remove THIS_MODULE owner

James Geboski (1):
      cpufreq: allow powersave governor as the default without expert mode

Kelvin Cheung (1):
      cpufreq: Loongson1: Add cpufreq driver for Loongson1B

Kevin Hilman (1):
      PM / Runtime: Kconfig: move ia64 dependency to arch/ia64/Kconfig

Konstantin Khlebnikov (1):
      ACPI / osl: speedup grace period in acpi_os_map_cleanup

Lan Tianyu (1):
      ACPI: Add _DEP support to fix battery issue on Asus T100TA

Lenny Szubowicz (1):
      cpufreq: pcc: Enable autoload of pcc-cpufreq for ACPI processors

Lorenzo Pieralisi (3):
      drivers: cpuidle: Add status property to ARM idle states
      drivers: cpuidle: Add idle-state-name description to ARM idle states
      drivers: cpuidle: Remove cpuidle-arm64 duplicate error messages

Lv Zheng (2):
      ACPI / OSL: Add IRQ handler flushing support in the OSL.
      ACPICA: Events: Always modify GPE registers under the GPE lock

Markus Elfring (1):
      PM / hibernate: Deletion of an unnecessary check before the
function call "vfree"

Mika Westerberg (9):
      ACPI: Add support for device specific properties
      ACPI: Allow drivers to match using Device Tree compatible property
      misc: at25: Make use of device property API
      gpio / ACPI: Add support for _DSD device properties
      gpio: sch: Consolidate core and resume banks
      leds: leds-gpio: Add support for GPIO descriptors
      gpio: Support for unified device properties interface
      net: rfkill: gpio: Add default GPIO driver mappings for ACPI
      leds: leds-gpio: Convert gpio_blink_set() to use GPIO descriptors

Pankaj Dubey (1):
      PM: Kconfig: fix unmet dependency for CPU_PM

Petr Cvek (1):
      cpufreq: pxa2xx: Add Kconfig entry

Prarit Bhargava (1):
      tools: cpupower: fix return checks for sysfs_get_idlestate_count()

Rafael J. Wysocki (31):
      Driver core: Unified device properties interface for platform firmware
      Driver core: Unified interface for firmware node properties
      leds: leds-gpio: Make use of device property API
      ACPI / GPIO: Driver GPIO mappings for ACPI GPIOs
      ACPI / GPIO: Document ACPI GPIO mappings API
      ACPI / property: Drop size_prop from acpi_dev_get_property_reference()
      PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is selected
      ACPICA: Save current masks of enabled GPEs after enable register writes
      ACPI / sleep: Drain outstanding events after disabling multiple GPEs
      PM: Drop CONFIG_PM_RUNTIME from the driver core
      ACPI / PM: Drop CONFIG_PM_RUNTIME from the ACPI core
      PCI / PM: Drop CONFIG_PM_RUNTIME from the PCI core
      PM / Kconfig: Do not select PM directly from Kconfig files
      PM: Merge the SET*_RUNTIME_PM_OPS() macros
      USB / PM: Drop CONFIG_PM_RUNTIME from the USB core
      block / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
      hwrandom / exynos / PM: Use CONFIG_PM in #ifdef
      gpio / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
      drm / exynos / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
      i2c-hid / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
      hsi / OMAP / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
      iio / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
      input / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
      media / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
      misc / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
      MFD / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
      MMC / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
      e1000e / igb / PM: Eliminate CONFIG_PM_RUNTIME
      drivers: sh / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
      dmaengine / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
      i2c-omap / PM: Drop CONFIG_PM_RUNTIME from i2c-omap.c

Stefan Wahren (2):
      cpufreq: cpufreq-dt: Improve debug about matching OPP
      cpufreq: cpufreq-dt: Handle regulator_get_voltage() failure

Strashko, Grygorii (1):
      PM / clock_ops: make __pm_clk_enable more generic

Sudeep Holla (2):
      ACPI / processor: remove unused variabled from
acpi_processor_power structure
      ACPI / cpuidle: avoid assigning signed errno to acpi_status

Tina Ruchandani (1):
      PM / Hibernate: Migrate to ktime_t

Tomasz Nowicki (1):
      ACPI / table: Always count matched and successfully parsed entries

Tomeu Vizoso (1):
      cpufreq: Ref the policy object sooner

Ulf Hansson (5):
      PM / Domains: Move struct pm_domain_data to pm_domain.h
      PM / Domains: Power on the PM domain right after attach completes
      PM / Domains: Initial PM clock support for genpd
      ARM: shmobile: Convert to genpd flags for PM clocks for r8a7779
      ARM: shmobile: Convert to genpd flags for PM clocks for R-mobile

Vince Hsu (1):
      cpufreq: respect the min/max settings from user space

Viresh Kumar (14):
      cpufreq: Kconfig: Remove architecture specific menu entries
      cpufreq: Fix formatting issues in 'struct cpufreq_driver'
      cpufreq-dt: pass 'policy->related_cpus' to of_cpufreq_cooling_register()
      cpufreq: Introduce ->ready() callback for cpufreq drivers
      cpufreq-dt: register cooling device from ->ready() callback
      PM / OPP rename 'head' as 'rcu_head' or 'srcu_head' based on its type
      PM / OPP don't match for existing OPPs when list is empty
      PM / OPP mark OPPs as 'static' or 'dynamic'
      PM / OPP Introduce APIs to remove OPPs
      PM / OPP replace kfree_rcu() with call_srcu() in opp_set_availability()
      cpufreq-dt: free OPP table created during ->init()
      exynos5440: free OPP table created during ->init()
      imx6q: free OPP table created during ->init()
      cpufreq: arm_big_little: free OPP table created during ->init()

Ethan Zhao (1):
      intel_pstate: skip this driver if Sun server has _PPC method

---------------

 Documentation/ABI/stable/sysfs-bus-usb             |  14 +-
 Documentation/ABI/testing/sysfs-bus-usb            |  19 +-
 Documentation/acpi/gpio-properties.txt             |  96 ++++
 Documentation/cpu-freq/intel-pstate.txt            |  37 +-
 .../devicetree/bindings/arm/idle-states.txt        |  20 +
 Documentation/gpio/consumer.txt                    |  18 +
 Documentation/kernel-parameters.txt                |   3 +
 Documentation/usb/power-management.txt             |  17 +-
 MAINTAINERS                                        |  10 +
 arch/arm/include/asm/cpuidle.h                     |   1 -
 arch/arm/mach-davinci/cpuidle.c                    |   1 -
 arch/arm/mach-imx/cpuidle-imx5.c                   |   1 -
 arch/arm/mach-imx/cpuidle-imx6q.c                  |   3 +-
 arch/arm/mach-imx/cpuidle-imx6sl.c                 |   3 +-
 arch/arm/mach-omap2/cpuidle34xx.c                  |   7 -
 arch/arm/mach-omap2/cpuidle44xx.c                  |   5 +-
 arch/arm/mach-s3c24xx/h1940-bluetooth.c            |   4 +-
 arch/arm/mach-s3c24xx/h1940.h                      |   4 +-
 arch/arm/mach-s3c24xx/mach-h1940.c                 |   3 +-
 arch/arm/mach-s3c24xx/mach-rx1950.c                |   3 +-
 arch/arm/mach-s3c64xx/cpuidle.c                    |   1 -
 arch/arm/mach-shmobile/pm-r8a7779.c                |   3 +-
 arch/arm/mach-shmobile/pm-rmobile.c                |   3 +-
 arch/arm/mach-shmobile/pm-sh7372.c                 |   4 -
 arch/arm/mach-tegra/cpuidle-tegra114.c             |   1 -
 arch/arm/mach-tegra/cpuidle-tegra20.c              |   3 +-
 arch/arm/mach-tegra/cpuidle-tegra30.c              |   1 -
 arch/arm/plat-orion/gpio.c                         |   3 +-
 arch/arm/plat-orion/include/plat/orion-gpio.h      |   5 +-
 arch/ia64/Kconfig                                  |   2 +-
 arch/mips/include/asm/idle.h                       |   1 -
 arch/sh/Kconfig                                    |   1 -
 arch/sh/kernel/cpu/shmobile/cpuidle.c              |   3 -
 arch/x86/include/asm/cpufeature.h                  |   5 +
 arch/x86/include/uapi/asm/msr-index.h              |  41 ++
 arch/x86/kernel/apm_32.c                           |   1 -
 arch/x86/kernel/cpu/scattered.c                    |   5 +
 block/blk-core.c                                   |   6 +-
 block/elevator.c                                   |   2 +-
 drivers/acpi/Kconfig                               |  36 +-
 drivers/acpi/Makefile                              |   5 +
 drivers/acpi/acpi_lpss.c                           |  98 ++--
 drivers/acpi/acpica/acglobal.h                     |   1 +
 drivers/acpi/acpica/aclocal.h                      |   4 +
 drivers/acpi/acpica/evgpe.c                        |   9 +-
 drivers/acpi/acpica/hwgpe.c                        |  53 +-
 drivers/acpi/acpica/utresrc.c                      |   2 +-
 drivers/acpi/acpica/utxface.c                      |   4 +-
 drivers/acpi/acpica/utxfinit.c                     |  11 +
 drivers/acpi/battery.c                             |   4 +
 drivers/acpi/device_pm.c                           |  10 +-
 drivers/acpi/internal.h                            |   6 +
 drivers/acpi/osl.c                                 |   8 +-
 drivers/acpi/pci_irq.c                             |   2 +-
 drivers/acpi/pmic/intel_pmic.c                     | 354 +++++++++++++
 drivers/acpi/pmic/intel_pmic.h                     |  25 +
 drivers/acpi/pmic/intel_pmic_crc.c                 | 211 ++++++++
 drivers/acpi/pmic/intel_pmic_xpower.c              | 268 ++++++++++
 drivers/acpi/processor_idle.c                      |  20 +-
 drivers/acpi/property.c                            | 551 +++++++++++++++++++++
 drivers/acpi/scan.c                                | 214 +++++++-
 drivers/acpi/sleep.c                               |   2 +
 drivers/acpi/tables.c                              |  68 ++-
 drivers/acpi/utils.c                               |   5 +-
 drivers/acpi/video.c                               |  15 +
 drivers/amba/bus.c                                 |   2 +-
 drivers/base/Makefile                              |   2 +-
 drivers/base/power/clock_ops.c                     | 150 ++----
 drivers/base/power/domain.c                        | 147 +++---
 drivers/base/power/domain_governor.c               |  11 -
 drivers/base/power/opp.c                           | 196 ++++++--
 drivers/base/power/power.h                         |  56 +--
 drivers/base/power/qos.c                           |   5 -
 drivers/base/power/runtime.c                       |  76 ++-
 drivers/base/power/sysfs.c                         |  19 +-
 drivers/base/property.c                            | 431 ++++++++++++++++
 drivers/char/hw_random/exynos-rng.c                |   2 +-
 drivers/cpufreq/Kconfig                            |  57 +--
 drivers/cpufreq/Kconfig.arm                        |   8 +
 drivers/cpufreq/Makefile                           |   4 +-
 drivers/cpufreq/arm_big_little.c                   |   7 +-
 drivers/cpufreq/arm_big_little.h                   |   5 +-
 drivers/cpufreq/arm_big_little_dt.c                |   1 +
 drivers/cpufreq/cpufreq-dt.c                       |  66 ++-
 drivers/cpufreq/cpufreq.c                          |  53 +-
 drivers/cpufreq/exynos5440-cpufreq.c               |   5 +-
 drivers/cpufreq/imx6q-cpufreq.c                    |  11 +-
 drivers/cpufreq/intel_pstate.c                     | 146 +++++-
 drivers/cpufreq/ls1x-cpufreq.c                     | 223 +++++++++
 drivers/cpufreq/pcc-cpufreq.c                      |   7 +
 drivers/cpuidle/cpuidle-arm64.c                    |  14 +-
 drivers/cpuidle/cpuidle-at91.c                     |   1 -
 drivers/cpuidle/cpuidle-big_little.c               |   6 +-
 drivers/cpuidle/cpuidle-calxeda.c                  |   1 -
 drivers/cpuidle/cpuidle-cps.c                      |   7 +-
 drivers/cpuidle/cpuidle-exynos.c                   |   1 -
 drivers/cpuidle/cpuidle-kirkwood.c                 |   1 -
 drivers/cpuidle/cpuidle-mvebu-v7.c                 |   8 +-
 drivers/cpuidle/cpuidle-powernv.c                  |   6 +-
 drivers/cpuidle/cpuidle-pseries.c                  |   3 -
 drivers/cpuidle/cpuidle-ux500.c                    |   3 +-
 drivers/cpuidle/cpuidle-zynq.c                     |   1 -
 drivers/cpuidle/driver.c                           |   1 -
 drivers/cpuidle/dt_idle_states.c                   |  12 +-
 drivers/cpuidle/governors/ladder.c                 |   2 +-
 drivers/cpuidle/governors/menu.c                   |   2 +-
 drivers/dma/dw/core.c                              |  11 +
 drivers/dma/nbpfaxi.c                              |   2 +-
 drivers/dma/ste_dma40.c                            |   2 +-
 drivers/dma/tegra20-apb-dma.c                      |   2 +-
 drivers/gpio/devres.c                              |  32 ++
 drivers/gpio/gpio-omap.c                           |   8 +-
 drivers/gpio/gpio-sch.c                            | 293 +++++------
 drivers/gpio/gpio-zynq.c                           |   2 +-
 drivers/gpio/gpiolib-acpi.c                        | 117 ++++-
 drivers/gpio/gpiolib.c                             |  85 +++-
 drivers/gpio/gpiolib.h                             |   7 +-
 drivers/gpu/drm/exynos/exynos_drm_fimc.c           |   2 +-
 drivers/gpu/drm/exynos/exynos_drm_g2d.c            |   2 +-
 drivers/gpu/drm/exynos/exynos_drm_gsc.c            |   2 +-
 drivers/gpu/drm/exynos/exynos_drm_rotator.c        |   2 +-
 drivers/hid/i2c-hid/i2c-hid.c                      |   2 +-
 drivers/hsi/controllers/omap_ssi.c                 |   2 +-
 drivers/hsi/controllers/omap_ssi_port.c            |   2 +-
 drivers/i2c/busses/i2c-hix5hd2.c                   |   2 +-
 drivers/i2c/busses/i2c-nomadik.c                   |   2 +-
 drivers/i2c/busses/i2c-omap.c                      |   2 -
 drivers/i2c/i2c-core.c                             |   1 +
 drivers/idle/intel_idle.c                          | 108 ++--
 drivers/iio/accel/bmc150-accel.c                   |   4 +-
 drivers/iio/accel/kxcjk-1013.c                     |   4 +-
 drivers/iio/adc/Kconfig                            |   8 +
 drivers/iio/adc/Makefile                           |   1 +
 drivers/iio/adc/axp288_adc.c                       | 261 ++++++++++
 drivers/iio/gyro/bmg160.c                          |   4 +-
 drivers/input/keyboard/gpio_keys_polled.c          | 112 ++---
 drivers/input/keyboard/samsung-keypad.c            |   2 +-
 drivers/input/touchscreen/cyttsp4_core.c           |   2 +-
 drivers/leds/leds-gpio.c                           | 150 +++---
 drivers/media/platform/coda/coda-common.c          |   4 +-
 drivers/media/platform/exynos4-is/fimc-core.c      |   6 +-
 drivers/media/platform/exynos4-is/fimc-is-i2c.c    |   2 +-
 drivers/media/platform/exynos4-is/fimc-lite.c      |   2 +-
 drivers/media/platform/exynos4-is/mipi-csis.c      |   2 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |   4 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |   2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_pm.c        |  10 +-
 drivers/mfd/Kconfig                                |   3 +-
 drivers/mfd/ab8500-gpadc.c                         |   2 +-
 drivers/mfd/arizona-core.c                         |   4 +-
 drivers/mfd/axp20x.c                               | 364 ++++++++++++--
 drivers/mfd/intel_soc_pmic_crc.c                   |   3 +
 drivers/mfd/wm8994-core.c                          |   2 +-
 drivers/misc/apds990x.c                            |   4 +-
 drivers/misc/bh1770glc.c                           |   2 +-
 drivers/misc/eeprom/at25.c                         |  34 +-
 drivers/misc/lis3lv02d/lis3lv02d_i2c.c             |   4 +-
 drivers/misc/mei/mei_dev.h                         |   4 +-
 drivers/misc/mei/pci-me.c                          |   8 +-
 drivers/misc/mei/pci-txe.c                         |   8 +-
 drivers/mmc/core/bus.c                             |   4 +-
 drivers/mmc/host/mmci.c                            |   2 +-
 drivers/mmc/host/sdhci-acpi.c                      |   2 +-
 drivers/mmc/host/sdhci-esdhc-imx.c                 |   4 +-
 drivers/mmc/host/sdhci-pci.c                       |  18 +-
 drivers/mmc/host/sdhci-pxav3.c                     |   2 +-
 drivers/mmc/host/sdhci-s3c.c                       |   6 +-
 drivers/mmc/host/sdhci.c                           |   7 +-
 drivers/mmc/host/sdhci.h                           |   3 -
 drivers/mmc/host/sh_mobile_sdhi.c                  |   2 +-
 drivers/mmc/host/tmio_mmc.c                        |   2 +-
 drivers/net/ethernet/intel/e1000e/netdev.c         |   2 -
 drivers/net/ethernet/intel/igb/igb_main.c          |   6 +-
 drivers/of/base.c                                  |  33 ++
 drivers/pci/pci-driver.c                           |  20 +-
 drivers/pci/pci-sysfs.c                            |   4 +-
 drivers/pci/pcie/Kconfig                           |   2 +-
 drivers/powercap/Kconfig                           |   2 +-
 drivers/powercap/intel_rapl.c                      | 264 ++++++----
 drivers/sh/pm_runtime.c                            |   4 +-
 drivers/spi/spi-pl022.c                            |   2 +-
 drivers/usb/core/driver.c                          |   6 +-
 drivers/usb/core/hcd-pci.c                         |  11 -
 drivers/usb/core/hcd.c                             |  12 +-
 drivers/usb/core/hub.c                             |   6 +-
 drivers/usb/core/port.c                            |   4 +-
 drivers/usb/core/sysfs.c                           |  13 +-
 drivers/usb/core/usb.c                             |   4 +-
 drivers/usb/core/usb.h                             |  23 +-
 drivers/usb/host/ehci-pci.c                        |   2 +-
 drivers/usb/host/sl811-hcd.c                       |   5 +-
 drivers/usb/host/u132-hcd.c                        |   3 +-
 drivers/usb/host/xhci-hub.c                        |   2 +-
 drivers/usb/host/xhci.c                            |  29 +-
 drivers/usb/phy/phy-msm-usb.c                      |   2 +-
 include/acpi/acbuffer.h                            |  14 +-
 include/acpi/acpi_bus.h                            |  35 +-
 include/acpi/acpixf.h                              |   2 +-
 include/acpi/actypes.h                             |   4 +
 include/acpi/processor.h                           |   7 +-
 include/linux/acpi.h                               | 167 ++++++-
 include/linux/blkdev.h                             |   4 +-
 include/linux/cpufreq.h                            |  54 +-
 include/linux/cpuidle.h                            |   4 +-
 include/linux/gpio/consumer.h                      |   7 +
 include/linux/gpio_keys.h                          |   3 +
 include/linux/leds.h                               |   3 +-
 include/linux/mfd/axp20x.h                         |  59 +++
 include/linux/of.h                                 |  34 ++
 include/linux/pm.h                                 |  19 +-
 include/linux/pm_clock.h                           |   8 +
 include/linux/pm_domain.h                          |  17 +-
 include/linux/pm_opp.h                             |  12 +-
 include/linux/pm_qos.h                             |  38 +-
 include/linux/pm_runtime.h                         |  21 +-
 include/linux/property.h                           | 143 ++++++
 include/linux/usb.h                                |   2 +-
 include/linux/usb/hcd.h                            |   7 +-
 kernel/power/Kconfig                               |   7 +-
 kernel/power/hibernate.c                           |  14 +-
 kernel/power/power.h                               |   3 +-
 kernel/power/snapshot.c                            |   9 +-
 kernel/power/swap.c                                |  43 +-
 net/rfkill/rfkill-gpio.c                           |  18 +-
 tools/power/cpupower/utils/cpuidle-info.c          |   8 +-
 225 files changed, 5514 insertions(+), 1582 deletions(-)
