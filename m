Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754AbaFDM1F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 08:27:05 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:40988 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbaFDM06 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 08:26:58 -0400
MIME-Version: 1.0
Date: Wed, 4 Jun 2014 14:26:57 +0200
X-Google-Sender-Auth: TlcTQFC13qjdhlzGeR2T8PgHf20
Message-ID: <CAJZ5v0gE_nMaEQiZ2Mo3r0B=KqpWDuxcRmgUYHNk9SrcGxY2Vg@mail.gmail.com>
Subject: [GIT PULL] ACPI and power management updates for v3.16-rc1
From: "Rafael J. Wysocki" <rafael@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

 git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git \
 pm+acpi-3.16-rc1

to receive ACPI and power management updates for v3.16-rc1 with
top-most commit 2e30baad228624e3868714af6ecab967c4445d4a

 Merge branches 'acpi-tools' and 'pm-tools'

on top of commit fad01e866afdbe01a1f3ec06a39c3a8b9e197014

 Linux 3.15-rc8

This already includes the material I sent you the final 3.15 pull
request for a while ago.

ACPICA is the leader this time (63 commits), followed by cpufreq
(28 commits), devfreq (15 commits), system suspend/hibernation (12
commits), ACPI video and ACPI device enumeration (10 commits each).

We have no major new features this time, but there are a few
significant changes of how things work.  The most visible one
will probably be that we are now going to create platform devices
rather than PNP devices by default for ACPI device objects with
_HID.  That was long overdue and will be really necessary to be able
to use the same drivers for the same hardware blocks on ACPI and
DT-based systems going forward.  We're not expecting fallout from
this one (as usual), but it's something to watch nevertheless.

The second change having a chance to be visible is that ACPI video
will now default to using native backlight rather than the ACPI
backlight interface which should generally help systems with
broken Win8 BIOSes.  We're hoping that all problems with the
native backlight handling that we had previously have been
addressed and we are in a good enough shape to flip the default,
but this change should be easy enough to revert if need be.

In addition to that, the system suspend core has a new mechanism
to allow runtime-suspended devices to stay suspended throughout
system suspend/resume transitions if some extra conditions are
met (generally, they are related to coordination within device
hierarchy).  However, enabling this feature requires cooperation
from the bus type layer and for now it has only been implemented
for the ACPI PM domain (used by ACPI-enumerated platform devices
mostly today).

Also, the acpidump utility that was previously shipped as a separate
tool will now be provided by the upstream ACPICA along with the
rest of ACPICA code, which will allow it to be more up to date
and better supported, and we have one new cpuidle driver (ARM
clps711x).

The rest is improvements related to certain specific use cases,
cleanups and fixes all over the place.

Specifics:

 - ACPICA update to upstream version 20140424.  That includes a
   number of fixes and improvements related to things like GPE
   handling, table loading, headers, memory mapping and unmapping,
   DSDT/SSDT overriding, and the Unload() operator.  The acpidump
   utility from upstream ACPICA is included too.  From Bob Moore,
   Lv Zheng, David Box, David Binderman, and Colin Ian King.

 - Fixes and cleanups related to ACPI video and backlight interfaces
   from Hans de Goede.  That includes blacklist entries for some new
   machines and using native backlight by default.

 - ACPI device enumeration changes to create platform devices
   rather than PNP devices for ACPI device objects with _HID by
   default.  PNP devices will still be created for the ACPI device
   object with device IDs corresponding to real PNP devices, so
   that change should not break things left and right, and we're
   expecting to see more and more ACPI-enumerated platform devices
   in the future.  From Zhang Rui and Rafael J Wysocki.

 - Updates for the ACPI LPSS (Low-Power Subsystem) driver allowing
   it to handle system suspend/resume on Asus T100 correctly.
   From Heikki Krogerus and Rafael J Wysocki.

 - PM core update introducing a mechanism to allow runtime-suspended
   devices to stay suspended over system suspend/resume transitions
   if certain additional conditions related to coordination within
   device hierarchy are met.  Related PM documentation update and
   ACPI PM domain support for the new feature.  From Rafael J Wysocki.

 - Fixes and improvements related to the "freeze" sleep state. They
   affect several places including cpuidle, PM core, ACPI core, and
   the ACPI battery driver.  From Rafael J Wysocki and Zhang Rui.

 - Miscellaneous fixes and updates of the ACPI core from Aaron Lu,
   Bjørn Mork, Hanjun Guo, Lan Tianyu, and Rafael J Wysocki.

 - Fixes and cleanups for the ACPI processor and ACPI PAD (Processor
   Aggregator Device) drivers from Baoquan He, Manuel Schölling,
   Tony Camuso, and Toshi Kani.

 - System suspend/resume optimization in the ACPI battery driver from
   Lan Tianyu.

 - OPP (Operating Performance Points) subsystem updates from
   Chander Kashyap, Mark Brown, and Nishanth Menon.

 - cpufreq core fixes, updates and cleanups from Srivatsa S Bhat,
   Stratos Karafotis, and Viresh Kumar.

 - Updates, fixes and cleanups for the Tegra, powernow-k8, imx6q,
   s5pv210, nforce2, and powernv cpufreq drivers from Brian Norris,
   Jingoo Han, Paul Bolle, Philipp Zabel, Stratos Karafotis, and
   Viresh Kumar.

 - intel_pstate driver fixes and cleanups from Dirk Brandewie,
   Doug Smythies, and Stratos Karafotis.

 - Enabling the big.LITTLE cpufreq driver on arm64 from Mark Brown.

 - Fix for the cpuidle menu governor from Chander Kashyap.

 - New ARM clps711x cpuidle driver from Alexander Shiyan.

 - Hibernate core fixes and cleanups from Chen Gang, Dan Carpenter,
   Fabian Frederick, Pali Rohár, and Sebastian Capella.

 - Intel RAPL (Running Average Power Limit) driver updates from
   Jacob Pan.

 - PNP subsystem updates from Bjorn Helgaas and Fabian Frederick.

 - devfreq core updates from Chanwoo Choi and Paul Bolle.

 - devfreq updates for exynos4 and exynos5 from Chanwoo Choi and
   Bartlomiej Zolnierkiewicz.

 - turbostat tool fix from Jean Delvare.

 - cpupower tool updates from Prarit Bhargava, Ramkumar Ramachandra
   and Thomas Renninger.

 - New ACPI ec_access.c tool for poking at the EC in a safe way
   from Thomas Renninger.

Thanks!


---------------

Aaron Lu (1):
      ACPI / scan: do not scan fixed hardware on HW-reduced platform

Alexander Shiyan (1):
      ARM: clps711x: Add cpuidle driver

Baoquan He (2):
      ACPI / ia64: introduce variable acpi_lapic into ia64
      ACPI / processor: Check if LAPIC is present during initialization

Bartlomiej Zolnierkiewicz (3):
      PM / devfreq: exynos4: introduce struct busfreq_ppmu_data
      PM / devfreq: exynos5: introduce struct busfreq_ppmu_data
      PM / devfreq: exynos: make more PPMU code common

Bjorn Helgaas (1):
      MAINTAINERS: Remove Bjorn Helgaas as PNP maintainer

Bjørn Mork (1):
      ACPI: add dynamic_debug support

Bob Moore (20):
      ACPICA: Add EXPORT_SYMBOL macros for install/remove SCI handler
interfaces.
      ACPICA: Update comments for ACPICA name - no functional change.
      ACPICA: gcc-specific: Fix possible issue with the strchr function.
      ACPICA: Unload operator: Emit a warning if and when it is ever used.
      ACPICA: Disassembler: Add support to decode _HID and _CID values.
      ACPICA: Disassembler: Add decoding of Notify() values.
      ACPICA: Add a missing field for debug dump of mutex objects.
      ACPICA: Table Manager: Misc cleanup and renames, no functional change.
      ACPICA: Table Manager: Split tbinstal.c into two files.
      ACPICA: Update version to 20140325.
      ACPICA: Update acpi_buffer_to_resource interface.
      ACPICA: Add support for LPIT table.
      ACPICA: Add support for _LPD and _PRP methods.
      ACPICA: Comment updates - no functional change.
      ACPICA: Back port of _PRP update.
      ACPICA: Back port of improvements on exception code.
      ACPICA: Remove extraneous error message for large number of GPEs.
      ACPICA: Events: Update GPE handling and initialization code.
      ACPICA: Comment/format update, no functional change.
      ACPICA: Update version to 20140424.

Brian Norris (1):
      cpufreq: powernv: make local function static

Chander Kashyap (3):
      cpuidle / menu: move repeated correction factor check to init
      PM / OPP: fix incorrect OPP count handling in of_init_opp_table
      PM / OPP: discard duplicate OPPs

Chanwoo Choi (12):
      cpufreq: exynos: Use dev_err/info function instead of pr_err/info
      PM / devfreq: exynos4: Fix bug of resource leak and code clean on probe()
      PM / devfreq: exynos4: Use SIMPLE_DEV_PM_OPS macro
      PM / devfreq: exynos4: Add CONFIG_PM_OPP dependency to fix probe fail
      PM / devfreq: exynos5: Use SIMPLE_DEV_PM_OPS macro
      PM / devfreq: exynos5: Add CONFIG_PM_OPP dependency to fix probe fail
      PM / devfreq: exynos4: use common PPMU code
      PM / devfreq: Fix devfreq_remove_device() to improve the
sequence of resource free
      PM / devfreq: Add resource-managed function for devfreq device
      PM / devfreq: Add devm_devfreq_{register,unregister}_opp_notfier function
      PM / devfreq: exynos4: Use devm_devfreq_* function using device
resource management
      PM / devfreq: exynos5: Use devm_devfreq_* function using device
resource management

Chen Gang (1):
      PM / hibernate: use unsigned local variables in swsusp_show_speed()

Colin Ian King (1):
      ACPICA: Linux-specific header: Add support for PPC64 compilation.

Dan Carpenter (1):
      PM / hibernate: Fix memory corruption in resumedelay_setup()

David Binderman (1):
      ACPICA: utstring: Check array index bound before use.

David E. Box (1):
      ACPICA: Update handling of PCI ID lists.

Dirk Brandewie (4):
      intel_pstate: Add CPU IDs for Broadwell processors
      intel_pstate: Remove C0 tracking
      intel_pstate: Correct rounding in busy calculation
      intel_pstate: add sample time scaling

Doug Smythies (1):
      intel_pstate: Improve initial busy calculation

Fabian Frederick (2):
      PM / hibernate: convert simple_strtoul to kstrtoul
      PNP / resources: remove positive test on unsigned values

Hanjun Guo (1):
      ACPI / PCI: Stub out pci_acpi_crs_quirks() and make it x86 specific

Hans de Goede (10):
      ACPI / video: change acpi-video brightness_switch_enabled default to 0
      ACPI / video: Don't register acpi_video_resume notifier without
backlight devices
      ACPI / video: Add an acpi_video_unregister_backlight function
      acer-wmi: Switch to acpi_video_unregister_backlight
      acer-wmi: Add Aspire 5741 to video_vendor_dmi_table
      nouveau: Don't check acpi_video_backlight_support() before
registering backlight
      backlight: Add backlight device (un)registration notification
      ACPI / video: Unregister the backlight device if a raw one shows up later
      ACPI / video: Add use native backlight quirk for the ThinkPad W530
      ACPI / video: Add 4 new models to the use_native_backlight DMI list

Heikki Krogerus (5):
      ACPI / platform: add IDs for Broadcom Bluetooth and GPS chips
      ACPI / PM: Export rest of the subsys PM callbacks
      clk: new basic clk type for fractional divider
      ACPI / LPSS: custom power domain for LPSS
      ACPI / LPSS: support for fractional divider clock

Jacob Pan (2):
      powercap / RAPL: further relax energy counter checks
      powercap / RAPL: add new CPU IDs

Jean Delvare (1):
      tools / power: turbostat: Drop temperature checks

Jingoo Han (1):
      cpufreq: nforce2: remove DEFINE_PCI_DEVICE_TABLE macro

Lan Tianyu (3):
      ACPI / battery: Accelerate battery resume callback
      ACPI: Add acpi_bus_attach_private_data() to attach data to ACPI handle
      ACPI / thermal: Use acpi_bus_attach_private_data() to attach private data

Lv Zheng (41):
      ACPICA: Update use of acpi_os_wait_events_complete interface.
      ACPICA: Clean up comment divergences in aclinux.h
      ACPICA: Remove indent divergences to reduce maintenance overhead.
      ACPICA: Tables: Fix the issues in handling virtual addressed tables.
      ACPICA: Tables: Fix multiple ACPI_FREE()s around acpi_tb_add_table().
      ACPICA: Tables: Clean up split INSTALLED/VALIDATED table state logics.
      ACPICA: Tables: Fix unbalanced table validations.
      ACPICA: Tables: Fix table checksums verification before installation.
      ACPICA: Tables: Cleanup ACPI_TABLE_ORIGIN_xxx flags.
      ACPICA: Tables: Avoid SSDT installation with
acpi_gbl_disable_ssdt_table_load.
      ACPICA: Tables: Add acpi_install_table() API for early table installation.
      ACPICA: acpidump: Add support to generate acpidump release.
      ACPICA: acpidump: Update new structures and add missing file.
      ACPICA: acpidump: Update Makefile to build acpidump from ACPICA.
      ACPICA: acpidump: Remove old acpidump source.
      ACPICA: acpidump: Update man page.
      ACPICA: Utilities: Cleanup obsoleted global variables.
      ACPICA: Utilities: Deploy ACPI_DEBUGGER_EXEC for ACPI_DEBUGGER
enabled code in utglobal.c.
      ACPICA: acpidump: Fix code issue in invoking fread in the loop.
      ACPICA: Update global variable definitions. No functional change.
      ACPICA: OSL: Move external globals from utglobal.c to acpixf.h
using ACPI_INIT_GLOBAL/ACPI_GLOBAL.
      ACPICA: OSL: Add configurability for memory allocation macros.
      ACPICA: OSL: Add configurability for error message functions.
      ACPICA: OSL: Add configurability for debug output functions.
      ACPICA: OSL: Add section to collect the divergence in acpixf.h.
      ACPICA: OSL: Add configurability for generic external functions.
      ACPICA: Linux header: Add support for stubbed externals.
      ACPICA: acpidump: Fix truncated RSDP signature validation.
      ACPICA: acpidump: Add support to force using RSDT.
      ACPICA: Tables: Add new mechanism to skip NULL entries in RSDT and XSDT.
      ACPICA: Tables: Remove old mechanism to validate if XSDT
contains NULL entries.
      ACPI: Fix conflict between customized DSDT and DSDT local copy
      ACPICA: Linux headers: Remove ACPI_PREEMPTION_POINT() due to no usages.
      ACPICA: Linux headers: Add <acpi/platform/aclinuxex.h>
      ACPICA: Linux headers: Add <asm/acenv.h> to remove mis-ordered
inclusion of <asm/acpi.h>
      ACPICA: Clean up redudant definitions already defined elsewhere
      ACPI: Clean up acpi_os_map/unmap_memory() to eliminate __iomem.
      ACPICA: acpidump: Fix repetitive table dump in -n mode.
      ACPICA: Tables: Add mechanism to control early table checksum
verification.
      ACPI: Fix x86 regression related to early mapping size limitation
      ACPICA: Namespace: Remove _PRP method support.

Manuel Schölling (1):
      ACPI / PAD: Use time_before() for time comparison

Mark Brown (2):
      cpufreq: Enable big.LITTLE cpufreq driver on arm64
      PM / OPP: Make OPP invisible to users in Kconfig

Nishanth Menon (2):
      PM / OPP: Remove cpufreq wrapper dependency on internal data organization
      PM / OPP: Move cpufreq specific OPP functions out of generic OPP library

Niv Yehezkel (1):
      PM / hibernate: fixed typo in comment

Pali Rohár (1):
      PM / hibernate: Documentation: Fix script for unswapping

Paul Bolle (2):
      PM / devfreq: remove checks for CONFIG_EXYNOS_ASV
      cpufreq: s5pv210: drop check for CONFIG_PM_VERBOSE

Philipp Zabel (2):
      cpufreq: imx6q: Drop devm_clk/regulator_get usage
      cpufreq: imx6q: Remove unused include

Prarit Bhargava (1):
      PM / tools: cpupower: add option to display values without round offs

Rafael J. Wysocki (20):
      cpuidle: Combine cpuidle_enabled() with cpuidle_select()
      cpuidle / menu: Return (-1) if there are no suitable states
      ACPI / notify: Clean up handling of hotplug events
      PM / suspend: Always use deepest C-state in the "freeze" sleep state
      ACPI / PM: Export acpi_target_system_state() to modules
      ACPI / PM: Hold ACPI scan lock over the "freeze" sleep state
      PM / runtime: Update documentation to reflect the current code flow
      PM / sleep: Mechanism to avoid resuming runtime-suspended
devices unnecessarily
      PM / sleep: Update device PM documentation to cover direct_complete
      ACPI / PM: Avoid resuming devices in ACPI PM domain during system suspend
      ACPI / platform / LPSS: Enable async suspend/resume of LPSS devices
      PM / sleep: Add state field to pm_states[] entries
      PM / sleep: Use valid_state() for platform-dependent sleep states only
      PM / sleep: Introduce command line argument for sleep state enumeration
      ACPI / scan: .match() callback for ACPI scan handlers
      ACPI / scan: introduce platform_id device PNP type flag
      ACPI / scan: Change the meaning of missing .attach() in scan handlers
      ACPI / scan: always register container scan handler
      ACPI / scan: always register memory hotplug scan handler
      ACPI / scan: always register ACPI LPSS scan handler

Ramkumar Ramachandra (3):
      cpupower: Rename cpufrequtils -> cpupower, and libcpufreq -> libcpupower.
      cpupower: Remove dead link to homepage, and update the targets built.
      cpupower: Remove all manpages on make uninstall

Sebastian Capella (1):
      PM / hibernate: no kernel_power_off when pm_power_off NULL

Srivatsa S. Bhat (1):
      cpufreq: Catch double invocations of cpufreq_freq_transition_begin/end

Stratos Karafotis (14):
      cpufreq: Introduce macros for cpufreq_frequency_table iteration
      cpufreq: Use cpufreq_for_each_* macros for frequency table iteration
      ARM: davinci: da850: Use cpufreq_for_each_entry macro for iteration
      mfd: db8500-prcmu: Use cpufreq_for_each_entry macro for iteration
      mips: lemote 2f: Use cpufreq_for_each_entry macro for iteration
      thermal: cpu_cooling: Use cpufreq_for_each_valid_entry macro for iteration
      irda: sh_sir: Use cpufreq_for_each_valid_entry macro for iteration
      sh: clk: Use cpufreq_for_each_valid_entry macro for iteration
      cpufreq: Kconfig: Fix spelling errors
      intel_pstate: Remove sample parameter in intel_pstate_calc_busy
      cpufreq: Fix build error on some platforms that use cpufreq_for_each_*
      cpufreq: powernow-k8: Suppress checkpatch warnings
      cpufreq: Break out early when frequency equals target_freq
      cpufreq: intel_pstate: Remove unused member name of cpudata

Thomas Renninger (6):
      ACPI / tools: Introduce ec_access.c - tool to access the EC
      cpupower: Introduce idle state disable-by-latency and enable-all
      cpupower: Install recently added cpupower-idle-{set, info} manpages
      cpupower: If root, try to load msr driver on x86 if
/dev/cpu/0/msr is not available
      cpupower: cpupower info -b should return 0 on success, not the
perf bias value
      cpupower: Remove mc and smt power aware scheduler info/settings

Tony Camuso (1):
      ACPI / PAD: call schedule() when need_resched() is true

Toshi Kani (1):
      ACPI / processor: Fix STARTING/DYING action in acpi_cpu_soft_notify()

Viresh Kumar (3):
      cpufreq: Make linux-pm@vger.kernel.org official mailing list
      cpufreq: Tegra: drop wrapper around tegra_update_cpu_speed()
      cpufreq: handle calls to ->target_index() in separate routine

Zhang Rui (8):
      PM / sleep: unregister wakeup source when disabling device wakeup
      ACPI / battery: introduce support for POWER_SUPPLY_PROP_CAPACITY_LEVEL
      power_supply: allow power supply devices registered w/o wakeup source
      ACPI / battery: wakeup the system only when necessary
      ACPI / PNP: use device ID list for PNPACPI device enumeration
      ACPI / scan: drop IDs that do not comply with the ACPI PNP ID rule
      ACPI / scan: drop unsupported serial IDs from PNP ACPI scan
handler ID list
      ACPI / scan: use platform bus type by default for _HID enumeration

---------------

 Documentation/ABI/testing/sysfs-devices-system-cpu |    4 +-
 Documentation/ABI/testing/sysfs-power              |   29 +-
 Documentation/cpu-freq/core.txt                    |   29 +
 Documentation/cpu-freq/cpu-drivers.txt             |   19 +
 Documentation/cpu-freq/index.txt                   |    4 +-
 Documentation/kernel-parameters.txt                |   24 +-
 Documentation/power/devices.txt                    |   34 +-
 Documentation/power/opp.txt                        |   40 +-
 Documentation/power/runtime_pm.txt                 |   37 +-
 Documentation/power/states.txt                     |   87 +-
 Documentation/power/swsusp.txt                     |    5 +-
 MAINTAINERS                                        |    3 -
 arch/arm/mach-davinci/da850.c                      |    9 +-
 arch/ia64/include/asm/acenv.h                      |   56 +
 arch/ia64/include/asm/acpi.h                       |   52 +-
 arch/ia64/kernel/acpi.c                            |    3 +
 arch/mips/loongson/lemote-2f/clock.c               |   17 +-
 arch/x86/include/asm/acenv.h                       |   49 +
 arch/x86/include/asm/acpi.h                        |   45 -
 drivers/acpi/Makefile                              |    7 +-
 drivers/acpi/acpi_cmos_rtc.c                       |    2 +-
 drivers/acpi/acpi_extlog.c                         |   16 +-
 drivers/acpi/acpi_lpss.c                           |  306 ++++-
 drivers/acpi/acpi_memhotplug.c                     |   31 +-
 drivers/acpi/acpi_pad.c                            |   16 +-
 drivers/acpi/acpi_platform.c                       |   51 +-
 drivers/acpi/acpi_pnp.c                            |  395 ++++++
 drivers/acpi/acpi_processor.c                      |    2 +-
 drivers/acpi/acpica/Makefile                       |    1 +
 drivers/acpi/acpica/acapps.h                       |  170 +++
 drivers/acpi/acpica/acevents.h                     |    5 +-
 drivers/acpi/acpica/acglobal.h                     |  142 +--
 drivers/acpi/acpica/aclocal.h                      |   17 +-
 drivers/acpi/acpica/acpredef.h                     |   10 +-
 drivers/acpi/acpica/actables.h                     |   62 +-
 drivers/acpi/acpica/acutils.h                      |   10 +-
 drivers/acpi/acpica/evgpe.c                        |   13 +-
 drivers/acpi/acpica/evgpeblk.c                     |   34 +-
 drivers/acpi/acpica/evgpeinit.c                    |   12 +-
 drivers/acpi/acpica/evmisc.c                       |    3 +-
 drivers/acpi/acpica/evsci.c                        |    2 +-
 drivers/acpi/acpica/evxface.c                      |   61 +-
 drivers/acpi/acpica/evxfgpe.c                      |    7 +-
 drivers/acpi/acpica/exconfig.c                     |   82 +-
 drivers/acpi/acpica/exdump.c                       |    4 +-
 drivers/acpi/acpica/hwpci.c                        |   15 +-
 drivers/acpi/acpica/rscreate.c                     |   13 +-
 drivers/acpi/acpica/tbdata.c                       |  760 +++++++++++
 drivers/acpi/acpica/tbfadt.c                       |   61 +-
 drivers/acpi/acpica/tbfind.c                       |    4 +-
 drivers/acpi/acpica/tbinstal.c                     |  837 +++++-------
 drivers/acpi/acpica/tbutils.c                      |  285 +----
 drivers/acpi/acpica/tbxface.c                      |   18 +-
 drivers/acpi/acpica/tbxfload.c                     |   87 +-
 drivers/acpi/acpica/utdecode.c                     |   74 +-
 drivers/acpi/acpica/utglobal.c                     |   26 +-
 drivers/acpi/acpica/utstring.c                     |    2 +-
 drivers/acpi/acpica/utxferror.c                    |    2 +
 drivers/acpi/apei/einj.c                           |   14 +-
 drivers/acpi/battery.c                             |   77 +-
 drivers/acpi/bus.c                                 |   56 +-
 drivers/acpi/container.c                           |   15 +
 drivers/acpi/device_pm.c                           |   46 +-
 drivers/acpi/internal.h                            |   18 +-
 drivers/acpi/nvs.c                                 |    4 +-
 drivers/acpi/osl.c                                 |   32 +-
 drivers/acpi/processor_driver.c                    |    7 +
 drivers/acpi/scan.c                                |   76 +-
 drivers/acpi/sleep.c                               |   19 +
 drivers/acpi/tables.c                              |   23 +
 drivers/acpi/thermal.c                             |   11 +-
 drivers/acpi/utils.c                               |   64 +-
 drivers/acpi/video.c                               |  252 +++-
 drivers/base/power/main.c                          |   66 +-
 drivers/base/power/opp.c                           |  122 +-
 drivers/base/power/wakeup.c                        |    6 +
 drivers/char/tpm/tpm_acpi.c                        |    4 +-
 drivers/clk/Makefile                               |    1 +
 drivers/clk/clk-fractional-divider.c               |  135 ++
 drivers/cpufreq/Kconfig.arm                        |    7 +-
 drivers/cpufreq/Kconfig.x86                        |    4 +-
 drivers/cpufreq/Makefile                           |    2 +
 drivers/cpufreq/acpi-cpufreq.c                     |    9 +-
 drivers/cpufreq/arm_big_little.c                   |   16 +-
 drivers/cpufreq/cpufreq-nforce2.c                  |    2 +-
 drivers/cpufreq/cpufreq.c                          |   70 +-
 drivers/cpufreq/cpufreq_opp.c                      |  110 ++
 drivers/cpufreq/cpufreq_stats.c                    |   24 +-
 drivers/cpufreq/dbx500-cpufreq.c                   |    8 +-
 drivers/cpufreq/elanfreq.c                         |    9 +-
 drivers/cpufreq/exynos-cpufreq.c                   |   32 +-
 drivers/cpufreq/exynos-cpufreq.h                   |    1 +
 drivers/cpufreq/exynos5440-cpufreq.c               |   30 +-
 drivers/cpufreq/freq_table.c                       |   64 +-
 drivers/cpufreq/imx6q-cpufreq.c                    |   54 +-
 drivers/cpufreq/intel_pstate.c                     |   67 +-
 drivers/cpufreq/longhaul.c                         |   11 +-
 drivers/cpufreq/pasemi-cpufreq.c                   |   10 +-
 drivers/cpufreq/powernow-k6.c                      |   14 +-
 drivers/cpufreq/powernow-k8.c                      |  180 ++-
 drivers/cpufreq/powernow-k8.h                      |    2 +-
 drivers/cpufreq/powernv-cpufreq.c                  |    2 +-
 drivers/cpufreq/ppc_cbe_cpufreq.c                  |    9 +-
 drivers/cpufreq/s3c2416-cpufreq.c                  |   40 +-
 drivers/cpufreq/s3c64xx-cpufreq.c                  |   15 +-
 drivers/cpufreq/s5pv210-cpufreq.c                  |    6 +-
 drivers/cpufreq/speedstep-centrino.c               |    2 +-
 drivers/cpufreq/tegra-cpufreq.c                    |    9 +-
 drivers/cpuidle/Kconfig.arm                        |    6 +
 drivers/cpuidle/Makefile                           |    1 +
 drivers/cpuidle/cpuidle-clps711x.c                 |   64 +
 drivers/cpuidle/cpuidle.c                          |   55 +-
 drivers/cpuidle/governors/menu.c                   |   17 +-
 drivers/devfreq/Kconfig                            |    5 +-
 drivers/devfreq/devfreq.c                          |  125 +-
 drivers/devfreq/exynos/Makefile                    |    2 +-
 drivers/devfreq/exynos/exynos4_bus.c               |  219 +---
 drivers/devfreq/exynos/exynos5_bus.c               |  130 +-
 drivers/devfreq/exynos/exynos_ppmu.c               |   60 +
 drivers/devfreq/exynos/exynos_ppmu.h               |    8 +
 drivers/gpu/drm/nouveau/nouveau_backlight.c        |    9 -
 drivers/mfd/db8500-prcmu.c                         |   19 +-
 drivers/net/irda/sh_sir.c                          |   14 +-
 drivers/platform/x86/acer-wmi.c                    |   10 +-
 drivers/pnp/pnpacpi/core.c                         |   28 +-
 drivers/pnp/resource.c                             |    4 +-
 drivers/power/power_supply_core.c                  |   15 +-
 drivers/powercap/intel_rapl.c                      |   33 +-
 drivers/sh/clk/core.c                              |   20 +-
 drivers/thermal/cpu_cooling.c                      |   33 +-
 drivers/video/backlight/backlight.c                |   40 +
 include/acpi/acpi.h                                |    4 +-
 include/acpi/acpi_bus.h                            |    9 +-
 include/acpi/acpi_drivers.h                        |    5 +
 include/acpi/acpi_io.h                             |    3 +
 include/acpi/acpixf.h                              |  838 ++++++++----
 include/acpi/actbl.h                               |   11 +-
 include/acpi/actbl1.h                              |    4 +-
 include/acpi/actbl2.h                              |   71 +-
 include/acpi/actypes.h                             |   21 +
 include/acpi/platform/acenvex.h                    |   63 +
 include/acpi/platform/acgcc.h                      |   11 +
 include/acpi/platform/aclinux.h                    |  209 +--
 include/acpi/platform/aclinuxex.h                  |  112 ++
 include/acpi/video.h                               |    2 +
 include/linux/acpi.h                               |   30 +-
 include/linux/backlight.h                          |    7 +
 include/linux/clk-provider.h                       |   31 +
 include/linux/cpufreq.h                            |   50 +
 include/linux/cpuidle.h                            |    7 +-
 include/linux/devfreq.h                            |   35 +-
 include/linux/pm.h                                 |   36 +-
 include/linux/pm_opp.h                             |   20 -
 include/linux/pm_runtime.h                         |    6 +
 include/linux/power_supply.h                       |    2 +
 include/linux/suspend.h                            |    7 +
 kernel/power/Kconfig                               |    3 +-
 kernel/power/hibernate.c                           |   27 +-
 kernel/power/main.c                                |   33 +-
 kernel/power/power.h                               |    9 +-
 kernel/power/suspend.c                             |  111 +-
 kernel/power/suspend_test.c                        |   24 +-
 kernel/power/swap.c                                |    2 +-
 kernel/sched/idle.c                                |   20 +-
 tools/power/acpi/Makefile                          |   28 +-
 tools/power/acpi/common/cmfsize.c                  |  101 ++
 tools/power/acpi/common/getopt.c                   |  239 ++++
 tools/power/acpi/man/acpidump.8                    |   85 +-
 .../acpi/os_specific/service_layers/oslinuxtbl.c   | 1329 ++++++++++++++++++++
 .../acpi/os_specific/service_layers/osunixdir.c    |  204 +++
 .../acpi/os_specific/service_layers/osunixmap.c    |  151 +++
 tools/power/acpi/tools/acpidump/acpidump.c         |  559 --------
 tools/power/acpi/tools/acpidump/acpidump.h         |  130 ++
 tools/power/acpi/tools/acpidump/apdump.c           |  451 +++++++
 tools/power/acpi/tools/acpidump/apfiles.c          |  228 ++++
 tools/power/acpi/tools/acpidump/apmain.c           |  351 ++++++
 tools/power/acpi/tools/ec/Makefile                 |   22 +
 tools/power/acpi/tools/ec/ec_access.c              |  238 ++++
 tools/power/cpupower/Makefile                      |   12 +-
 tools/power/cpupower/README                        |   24 +-
 tools/power/cpupower/ToDo                          |    1 -
 .../power/cpupower/debug/kernel/cpufreq-test_tsc.c |    2 +-
 tools/power/cpupower/man/cpupower-frequency-info.1 |    3 +
 tools/power/cpupower/man/cpupower-idle-set.1       |   10 +-
 tools/power/cpupower/man/cpupower-info.1           |    2 +-
 tools/power/cpupower/man/cpupower-set.1            |   31 +-
 tools/power/cpupower/utils/cpufreq-info.c          |  110 +-
 tools/power/cpupower/utils/cpuidle-set.c           |   75 +-
 tools/power/cpupower/utils/cpupower-info.c         |   42 +-
 tools/power/cpupower/utils/cpupower-set.c          |   43 +-
 tools/power/cpupower/utils/cpupower.c              |   14 +
 tools/power/x86/turbostat/turbostat.c              |    4 +-
 192 files changed, 9475 insertions(+), 3802 deletions(-)
