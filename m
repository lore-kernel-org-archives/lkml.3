Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895AbaDAUoB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 16:44:01 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:51766 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbaDAUn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 16:43:57 -0400
MIME-Version: 1.0
Date: Tue, 1 Apr 2014 22:43:54 +0200
X-Google-Sender-Auth: EaojNNHjpLPdBJMjyLzBxmv_XjI
Message-ID: <CAJZ5v0jh5=K4F2hkVXSkGQzf3-v1T8cGKBT3Kz48Bswh7donOQ@mail.gmail.com>
Subject: [GIT PULL][Update] ACPI and power management updates for v3.15-rc1
From: "Rafael J. Wysocki" <rafael@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

There is a number of additional commits that were not quite ready when I sent
the original pull request for 3.15-rc1 several days ago, but they have spent
some time in linux-next since then and appear to be good to go, so here's
an update.

Please pull from

 git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git \
 pm+acpi-3.15-rc1

to receive ACPI and power management updates for v3.15-rc1 with
top-most commit 7b5c39389c86063e86fe8f2e0093c7197ddfa60a

 Merge branch 'pm-runtime'

on top of commit dcb99fd9b08cfe1afe426af4d8d3cbc429190f15

 Linux 3.14-rc7

All of this material has been in linux-next for some time (for several
weeks even in some cases).

ACPI took the lead this time, both in terms of the number of commits and the
number of modified lines of code, cpufreq follows and there are a few changes
in the PM core and in cpuidle too.

A new feature that already got some LWN.net's attention is the device PM QoS
extension allowing latency tolerance requirements to be propagated from leaf
devices to their ancestors with hardware interfaces for specifying latency
tolerance.  That should help systems with hardware-driven power management
to avoid going too far with it in cases when there are latency tolerance
constraints.

There also are some significant changes in the ACPI core related to the way
in which hotplug notifications are handled.  They affect PCI hotplug (ACPIPHP)
and the ACPI dock station code too.  The bottom line is that all those
notification now go through the root notify handler and are propagated to
the interested subsystems by means of callbacks instead of having to install
a notify handler for each device object that we can potentially get hotplug
notifications for.

In addition to that ACPICA will now advertise "Windows 2013" compatibility
for _OSI, because some systems out there don't work correctly if that is not
done (some of them don't even boot).  It also has a new feature supposed to
harden in against broken AML by serializing the execution of certain methods
automatically to avoid concurrency problems.

On the system suspend side of things, all of the device suspend and resume
callbacks, except for ->prepare() and ->complete(), are now going to be
executed asynchronously as that turns out to speed up system suspend and
resume on some platforms quite significantly and we have a few more
optimizations in that area.

Apart from that, there are some new device IDs and fixes and cleanups all
over.  In particular, the system suspend and resume handling by cpufreq
should be improved and the cpuidle menu governor should be a bit more
robust now.

Specifics:

 - Device PM QoS support for latency tolerance constraints on systems with
   hardware interfaces allowing such constraints to be specified.  That is
   necessary to prevent hardware-driven power management from becoming
   overly aggressive on some systems and to prevent power management
   features leading to excessive latencies from being used in some cases.

 - Consolidation of the handling of ACPI hotplug notifications for device
   objects.  This causes all device hotplug notifications to go through
   the root notify handler (that was executed for all of them anyway
   before) that propagates them to individual subsystems, if necessary,
   by executing callbacks provided by those subsystems (those callbacks
   are associated with struct acpi_device objects during device
   enumeration).  As a result, the code in question becomes both smaller
   in size and more straightforward and all of those changes should not
   affect users.

 - ACPICA update to upstream version 20140214, including fixes related
   to the handling of _PRT in cases when it is broken, the addition of
   "Windows 2013" to the list of supported "features" for _OSI (which is
   necessary to support systems that work incorrectly or don't even boot
   without it), and new code to automatically serialize the execution of
   methods creating any named objects which really cannot be executed in
   parallel with each other anyway (ACPICA attempted to address that by
   aborting methods upon conflict detection, but that wasn't reliable
   enough and led to other issues).  Changes from Bob Moore and Lv Zheng.

 - Consolidation of ACPI _OST handling from Jiang Liu.

 - ACPI battery and AC fixes allowing unusual system configurations to
   be handled by that code from Alexander Mezin.

 - New device IDs for the ACPI LPSS driver from Chiau Ee Chew.

 - ACPI fan and thermal optimizations related to system suspend and resume
   from Aaron Lu.

 - Cleanups related to ACPI video from Jean Delvare.

 - Assorted ACPI fixes and cleanups from Al Stone, Hanjun Guo, Lan Tianyu,
   Paul Bolle, Tomasz Nowicki.

 - Intel RAPL (Running Average Power Limits) driver cleanups from Jacob Pan.

 - intel_pstate fixes and cleanups from Dirk Brandewie.

 - cpufreq fixes related to system suspend/resume handling from Viresh Kumar.

 - cpufreq core fixes and cleanups from Viresh Kumar, Stratos Karafotis,
   Saravana Kannan, Rashika Kheria, Joe Perches.

 - cpufreq drivers updates from Viresh Kumar, Zhuoyu Zhang, Rob Herring.

 - cpuidle fixes related to the menu governor from Tuukka Tikkanen.

 - cpuidle fix related to the handling of coupled CPUs from Paul Burton.

 - Asynchronous execution of all device suspend and resume callbacks,
   except for ->prepare and ->complete, during system suspend and resume
   from Chuansheng Liu.

 - Delayed resuming of runtime-suspended devices during system suspend for
   the PCI bus type and ACPI PM domain.

 - New set of PM helper routines to allow device runtime PM callbacks to
   be used during system suspend and resume more easily from Ulf Hansson.

 - Assorted fixes and cleanups in the PM core from Geert Uytterhoeven,
   Prabhakar Lad, Philipp Zabel, Rashika Kheria, Sebastian Capella.

 - devfreq fix from Saravana Kannan.

 - PNP core cleanup from Michael Opdenacker.

Thanks!


---------------

Aaron Lu (2):
      ACPI / fan: do nothing in suspend and poweroff callback
      ACPI / thermal: make acpi_thermal_check asynchronous on resume

Al Stone (1):
      ACPI: introduce CONFIG_ACPI_REDUCED_HARDWARE_ONLY

Alexander Mezin (3):
      ACPI / battery: move some ACPI_BATTERY_* definitions to header
      ACPI / battery: call ACPI notifier chain in acpi_battery_notify
      ACPI / AC: recheck adapter status upon battery status changes

Bob Moore (22):
      ACPICA: Improve support for 32/64 bit physical addresses in printf().
      ACPICA: Deploy new 32/64 printf support for table override mechanism.
      ACPICA: Utilities: Load of local test tables is now optional.
      ACPICA: Improve parameter validation for acpi_install_gpe_block.
      ACPICA: Update ACPICA copyrights to 2014.
      ACPICA: Correctly support references in the union acpi_object.
      ACPICA: Debugger: Add new command to read/write/compare all
namespace objects.
      ACPICA: Update version to 20140114.
      ACPICA: Add "Windows 2013" string to _OSI support.
      ACPICA: Headers: Deploy #pragma pack (push) and (pop).
      ACPICA: Predefined names: Add support for the _PRP method.
      ACPICA: Harden _PRT repair code; check for minimum package length.
      ACPICA: Do not abort _PRT repair on a single subpackage failure.
      ACPICA: Comment update - no functional change.
      ACPICA: Update for _PRP predefined name.
      ACPICA: Add text: ACPICA policy for new _OSI strings. No
functional change.
      ACPICA: Debugger: Add missing objects; Traverse linked lists
      ACPICA: Prevent infinite loops when traversing corrupted lists.
      ACPICA: Update version to 20140214.
      ACPICA: Add auto-serialization support for ill-behaved control methods.
      ACPICA: Ignore sync_level for methods that have been auto-serialized.
      ACPICA: Revert "Headers: Deploy #pragma pack (push) and (pop)."

Chew, Chiau Ee (1):
      ACPI / LPSS: Add Intel BayTrail ACPI mode PWM

Dirk Brandewie (5):
      intel_pstate: remove unneeded sample buffers
      intel_pstate: fix pid_reset to use fixed point values
      cpufreq: Add stop CPU callback to cpufreq_driver interface
      intel_pstate: Set core to min P state during core offline
      intel_pstate: Use del_timer_sync in intel_pstate_cpu_stop

Geert Uytterhoeven (11):
      PM / Runtime: Add missing "it" in comment
      PM / Hibernate: Spelling s/anonymouns/anonymous/
      PM: Add missing "freeze" state
      PM / Runtime: Update runtime_idle() documentation for return value meaning
      PM / sleep: Correct whitespace errors in <linux/pm.h>
      PM / Runtime: dev_pm_info.runtime_error is signed
      PM / Runtime: Split line longer than 80 characters
      PM / Runtime: Correct documented return values for generic PM callbacks
      PM / Runtime: GENERIC_SUBSYS_PM_OPS is gone
      PM / Runtime: s/foo_process_requests/foo_process_next_request/
      PM / Runtime: Spelling s/competing/completing/

Hanjun Guo (8):
      ACPI / processor: Fix acpi_processor_eval_pdc() return value type
      ACPI / processor: Use ACPI_PROCESSOR_DEVICE_HID instead of "ACPI0007"
      ACPI / processor: Build idle_boot_override on x86 and ia64
      ACPI / processor: Make it possible to get APIC ID via GIC
      ACPI: Move BAD_MADT_ENTRY() to linux/acpi.h
      ACPI / tables: Replace printk with pr_*
      ACPI: Remove duplicate definitions of PREFIX
      Revert "ACPI / processor: Make it possible to get APIC ID via GIC"

Jacob Pan (2):
      powercap / intel_rapl: relax sanity check on energy counters
      powercap / intel_rapl: spell out SoC names

Jean Delvare (5):
      ACPI / video: fix ACPI_VIDEO dependencies
      ACPI / gpu / drm: Stop selecting VIDEO_OUTPUT_CONTROL
      acer-wmi: Stop selecting VIDEO_OUTPUT_CONTROL
      fujitsu-laptop: Drop unneeded include
      video / output: Drop display output class support

Jiang Liu (5):
      ACPI: rename acpi_evaluate_hotplug_ost() to acpi_evaluate_ost()
      ACPI / PAD: use acpi_evaluate_ost() to replace open-coded version
      ACPI / PAD / xen: use acpi_evaluate_ost() to replace open-coded version
      ACPI / processor: use acpi_evaluate_ost() to replace open-coded version
      ACPI: use device name LNXSYBUS.xx for ACPI \_SB and \_TZ objects

Joe Perches (1):
      cpufreq: Reformat printk() statements

Lad, Prabhakar (1):
      PM: fix typo in comment

Lan Tianyu (1):
      ACPI / button: Add ACPI Button event via netlink routine

Liu, Chuansheng (5):
      PM / sleep: Two flags for async suspend_noirq and suspend_late
      PM / sleep: Asynchronous threads for resume_noirq
      PM / sleep: Asynchronous threads for resume_early
      PM / sleep: Asynchronous threads for suspend_noirq
      PM / sleep: Asynchronous threads for suspend_late

Lv Zheng (12):
      ACPICA: Update the conditions to enable the utility resource dump strings.
      ACPICA: Add support for extra, optional OS-specific header file.
      ACPICA: acpidump: Add sparse declarators support.
      ACPICA: acpidump: Remove integer types translation protection.
      ACPICA: Add boot option to disable auto return object repair
      ACPICA: Update conditional compilation flags for resource dump functions.
      ACPICA: Properly handle NULL entries in _PRT return packages.
      ACPICA: Restore code that repairs NULL package elements in return values.
      ACPICA: Cleanup/improve global variable declarations.
      ACPICA: Remove global option to serialize all control methods.
      ACPICA: Add additional named objects for the auto-serialize method scan.
      ACPICA: Enable auto-serialization as a default kernel behavior.

Michael Opdenacker (1):
      PNP: remove deprecated IRQF_DISABLED

Paul Bolle (1):
      ACPI: Remove Kconfig symbol ACPI_PROCFS

Paul Burton (1):
      cpuidle: delay enabling interrupts until all coupled CPUs leave idle

Philipp Zabel (1):
      PM / domains: Turn latency warning into debug message

Rafael J. Wysocki (48):
      ACPI / hotplug / PCI: Simplify disable_slot()
      ACPI / hotplug / PCI: Proper kerneldoc comments for enumeration/removal
      ACPI / hotplug / PCI: Simplify register_slot()
      ACPI / hotplug / PCI: Drop acpiphp_bus_trim()
      ACPI / hotplug / PCI: Rework acpiphp_no_hotplug()
      ACPI / hotplug / PCI: Store acpi_device pointer in acpiphp_context
      ACPI / hotplug / PCI: Drop acpiphp_bus_add()
      ACPI / hotplug / PCI: Drop crit_sect locking
      ACPI / hotplug / PCI: Simplify hotplug_event()
      ACPI / hotplug / PCI: Use acpi_handle_debug() in hotplug_event()
      ACPI / hotplug / PCI: Do not pass ACPI handle to hotplug_event()
      ACPICA: Introduce acpi_get_data_full() and rework acpi_get_data()
      ACPI / hotplug: Fix potential race in acpi_bus_notify()
      ACPI / hotplug / PCI: Define hotplug context lock in the core
      ACPI / hotplug / PCI: Consolidate ACPIPHP with ACPI core hotplug
      ACPI / hotplug / PCI: Rework the handling of eject requests
      ACPI / hotplug / PCI: Simplify acpi_install_hotplug_notify_handler()
      ACPI / hotplug / PCI: Hotplug notifications from acpi_bus_notify()
      ACPI / hotplug / PCI: Rework acpiphp_check_host_bridge()
      ACPI / hotplug / PCI: Execute _EJ0 under the ACPI scan lock
      PM / QoS: Rename device resume latency QoS items
      PM / QoS: Add no_constraints_value field to struct pm_qos_constraints
      PM / QoS: Introcuce latency tolerance device PM QoS type
      ACPI / scan: Add bind/unbind callbacks to struct acpi_scan_handler
      ACPI / LPSS: Support for device latency tolerance PM QoS
      PM / QoS: Add type to dev_pm_qos_add_ancestor_request() arguments
      ACPI / hotplug / PCI: Rename register_slot() to acpiphp_add_context()
      ACPI / hotplug / PCI: Add ACPIPHP contexts to devices handled by PCIeHP
      ACPI / dock: Dispatch dock notifications from the global notify handler
      ACPI / dock: Pass ACPI device pointer to acpi_device_is_battery()
      ACPI / dock: Associate dock platform devices with ACPI device objects
      ACPI / hotplug / PCI: Do not clear event callback pointer for docks
      ACPI / hotplug: Add .fixup() callback to struct acpi_hotplug_context
      ACPI / dock: Use ACPI device object pointers instead of ACPI handles
      ACPI / dock: Use callback pointers from devices' ACPI hotplug contexts
      ACPI / dock: Add .uevent() callback to struct acpi_hotplug_context
      ACPI / ATA: Add hotplug contexts to ACPI companions of SATA devices
      ACPI / dock: Drop struct acpi_dock_ops and all code related to it
      ACPI / dock: Drop remove_dock_dependent_devices()
      ACPI / dock: Update copyright notice
      ACPI: Drop acpi_evaluate_hotplug_ost() and ACPI_HOTPLUG_OST
      cpufreq: Refactor cpufreq_set_policy()
      ACPI / PM: Resume runtime-suspended devices later during system suspend
      PCI / PM: Resume runtime-suspended devices later during system suspend
      ACPI / hotplug: Rework deferred execution of acpi_device_hotplug()
      ACPI / hotplug / PCI: Use pci_device_is_present()
      cpufreq: Do not allow ->setpolicy drivers to provide ->target
      MAINTAINERS: Reorder maintainer addresses for PM and ACPI

Rashika Kheria (3):
      cpufreq: Mark function as static in cpufreq.c
      PM / sleep: Move prototype declaration to header file kernel/power/power.h
      PM / wakeup: Include appropriate header file in kernel/power/wakelock.c

Rob Herring (1):
      cpufreq: enable ARM drivers on arm64

Saravana Kannan (4):
      cpufreq: stats: Remove redundant cpufreq_cpu_get() call
      cpufreq: stats: Fix error handling in __cpufreq_stats_create_table()
      cpufreq: stats: Refactor common code into __cpufreq_stats_create_table()
      PM / devfreq: Rewrite devfreq_update_status() to fix multiple bugs

Sebastian Capella (1):
      PM / hibernate: use name_to_dev_t to parse resume

Srivatsa S. Bhat (1):
      cpufreq: Make sure frequency transitions are serialized

Stratos Karafotis (2):
      cpufreq: Fix checkpatch errors and warnings
      cpufreq: Remove unnecessary braces

Tomasz Nowicki (2):
      ACPI / APEI: Remove X86 redundant dependency for APEI GHES.
      ACPI / PCI: Do not call ISA-specific code if ISA is not supported

Tuukka Tikkanen (6):
      cpuidle: rename expected_us to next_timer_us in menu governor
      cpuidle: Use actual state latency in menu governor
      cpuidle: Ensure menu coefficients stay within domain
      cpuidle: Do not substract exit latency from assumed sleep length
      cpuidle: Move perf multiplier calculation out of the selection loop
      cpuidle: poll state can measure residency

Ulf Hansson (3):
      PM / sleep: Set pm_generic functions to NULL for !CONFIG_PM_SLEEP
      PM / runtime: Fetch runtime PM callbacks using a macro
      PM: Add pm_runtime_suspend|resume_force functions

Viresh Kumar (19):
      cpufreq: don't call cpufreq_update_policy() on CPU addition
      cpufreq: Return error if ->get() failed in cpufreq_update_policy()
      cpufreq: suspend governors on system suspend/hibernate
      cpufreq: Implement cpufreq_generic_suspend()
      cpufreq: exynos: Use cpufreq_generic_suspend()
      cpufreq: s5pv210: Use cpufreq_generic_suspend()
      cpufreq: Tegra: Use cpufreq_generic_suspend()
      PM / suspend: Remove unnecessary !!
      cpufreq: add 'freq_table' in struct cpufreq_policy
      cpufreq: Remove cpufreq_generic_exit()
      cpufreq: Remove unnecessary variable/parameter 'frozen'
      cpufreq: SPEAr: Instantiate as platform_driver
      cpufreq: remove unused notifier: CPUFREQ_{SUSPENDCHANGE|RESUMECHANGE}
      cpufreq: resume drivers before enabling governors
      cpufreq: Convert existing drivers to use
cpufreq_freq_transition_{begin|end}
      cpufreq: Make cpufreq_notify_transition &
cpufreq_notify_post_transition static
      cpufreq: move call to __find_governor() to cpufreq_init_policy()
      cpufreq: arm_big_little: make vexpress driver depend on bL core driver
      cpufreq: arm_big_little: set 'physical_cluster' for each CPU

Zhuoyu Zhang (1):
      cpufreq: powerpc: add cpufreq transition latency for FSL e500mc SoCs

---------------

 Documentation/ABI/testing/sysfs-devices-power |  27 +-
 Documentation/ABI/testing/sysfs-power         |   5 +-
 Documentation/cpu-freq/core.txt               |   4 -
 Documentation/cpu-freq/cpu-drivers.txt        |   8 +-
 Documentation/kernel-parameters.txt           |  18 +-
 Documentation/power/pm_qos_interface.txt      |  82 ++--
 Documentation/power/runtime_pm.txt            |  29 +-
 Documentation/trace/events-power.txt          |   2 +-
 MAINTAINERS                                   |   8 +-
 arch/arm/kernel/smp.c                         |   3 +-
 arch/arm/kernel/smp_twd.c                     |   2 +-
 arch/arm/mach-pxa/viper.c                     |   3 -
 arch/arm/mach-spear/spear1310.c               |   1 +
 arch/arm/mach-spear/spear1340.c               |   1 +
 arch/arm64/Kconfig                            |   8 +
 arch/ia64/configs/generic_defconfig           |   1 -
 arch/ia64/configs/tiger_defconfig             |   1 -
 arch/ia64/configs/zx1_defconfig               |   1 -
 arch/ia64/kernel/acpi.c                       |   4 -
 arch/powerpc/oprofile/op_model_cell.c         |   3 +-
 arch/sparc/kernel/time_64.c                   |   3 +-
 arch/x86/configs/i386_defconfig               |   1 -
 arch/x86/configs/x86_64_defconfig             |   1 -
 arch/x86/kernel/acpi/boot.c                   |   4 -
 arch/x86/kernel/tsc.c                         |   3 +-
 drivers/acpi/Kconfig                          |  28 +-
 drivers/acpi/ac.c                             |  25 ++
 drivers/acpi/acpi_cmos_rtc.c                  |   2 -
 drivers/acpi/acpi_lpss.c                      |  82 +++-
 drivers/acpi/acpi_pad.c                       |  24 +-
 drivers/acpi/acpica/Makefile                  |   4 +-
 drivers/acpi/acpica/accommon.h                |   2 +-
 drivers/acpi/acpica/acdebug.h                 |   4 +-
 drivers/acpi/acpica/acdispat.h                |  15 +-
 drivers/acpi/acpica/acevents.h                |   2 +-
 drivers/acpi/acpica/acglobal.h                | 364 +++++++++---------
 drivers/acpi/acpica/achware.h                 |   2 +-
 drivers/acpi/acpica/acinterp.h                |  10 +-
 drivers/acpi/acpica/aclocal.h                 |   2 +-
 drivers/acpi/acpica/acmacros.h                |  16 +-
 drivers/acpi/acpica/acnamesp.h                |   2 +-
 drivers/acpi/acpica/acobject.h                |   5 +-
 drivers/acpi/acpica/acopcode.h                |   2 +-
 drivers/acpi/acpica/acparser.h                |   2 +-
 drivers/acpi/acpica/acpredef.h                |  16 +-
 drivers/acpi/acpica/acresrc.h                 |   2 +-
 drivers/acpi/acpica/acstruct.h                |   5 +-
 drivers/acpi/acpica/actables.h                |   2 +-
 drivers/acpi/acpica/acutils.h                 |   4 +-
 drivers/acpi/acpica/amlcode.h                 |   2 +-
 drivers/acpi/acpica/amlresrc.h                |   2 +-
 drivers/acpi/acpica/dsargs.c                  |   2 +-
 drivers/acpi/acpica/dscontrol.c               |   2 +-
 drivers/acpi/acpica/dsfield.c                 |   2 +-
 drivers/acpi/acpica/dsinit.c                  |  61 ++-
 drivers/acpi/acpica/dsmethod.c                | 158 +++++++-
 drivers/acpi/acpica/dsmthdat.c                |   2 +-
 drivers/acpi/acpica/dsobject.c                |   2 +-
 drivers/acpi/acpica/dsopcode.c                |   2 +-
 drivers/acpi/acpica/dsutils.c                 |   2 +-
 drivers/acpi/acpica/dswexec.c                 |   2 +-
 drivers/acpi/acpica/dswload.c                 |  18 +-
 drivers/acpi/acpica/dswload2.c                |   2 +-
 drivers/acpi/acpica/dswscope.c                |   2 +-
 drivers/acpi/acpica/dswstate.c                |   2 +-
 drivers/acpi/acpica/evevent.c                 |   2 +-
 drivers/acpi/acpica/evglock.c                 |   2 +-
 drivers/acpi/acpica/evgpe.c                   |   2 +-
 drivers/acpi/acpica/evgpeblk.c                |   2 +-
 drivers/acpi/acpica/evgpeinit.c               |   2 +-
 drivers/acpi/acpica/evgpeutil.c               |   2 +-
 drivers/acpi/acpica/evhandler.c               |   2 +-
 drivers/acpi/acpica/evmisc.c                  |   2 +-
 drivers/acpi/acpica/evregion.c                |  13 +-
 drivers/acpi/acpica/evrgnini.c                |   2 +-
 drivers/acpi/acpica/evsci.c                   |   2 +-
 drivers/acpi/acpica/evxface.c                 |   2 +-
 drivers/acpi/acpica/evxfevnt.c                |   2 +-
 drivers/acpi/acpica/evxfgpe.c                 |  21 +-
 drivers/acpi/acpica/evxfregn.c                |   2 +-
 drivers/acpi/acpica/exconfig.c                |   2 +-
 drivers/acpi/acpica/exconvrt.c                |   2 +-
 drivers/acpi/acpica/excreate.c                |   2 +-
 drivers/acpi/acpica/exdebug.c                 |   2 +-
 drivers/acpi/acpica/exdump.c                  | 231 ++++++++++--
 drivers/acpi/acpica/exfield.c                 |   2 +-
 drivers/acpi/acpica/exfldio.c                 |   2 +-
 drivers/acpi/acpica/exmisc.c                  |   2 +-
 drivers/acpi/acpica/exmutex.c                 |   2 +-
 drivers/acpi/acpica/exnames.c                 |   2 +-
 drivers/acpi/acpica/exoparg1.c                |   2 +-
 drivers/acpi/acpica/exoparg2.c                |   2 +-
 drivers/acpi/acpica/exoparg3.c                |   2 +-
 drivers/acpi/acpica/exoparg6.c                |   2 +-
 drivers/acpi/acpica/exprep.c                  |   2 +-
 drivers/acpi/acpica/exregion.c                |   2 +-
 drivers/acpi/acpica/exresnte.c                |   2 +-
 drivers/acpi/acpica/exresolv.c                |   2 +-
 drivers/acpi/acpica/exresop.c                 |   2 +-
 drivers/acpi/acpica/exstore.c                 |   2 +-
 drivers/acpi/acpica/exstoren.c                |   2 +-
 drivers/acpi/acpica/exstorob.c                |   2 +-
 drivers/acpi/acpica/exsystem.c                |  14 +-
 drivers/acpi/acpica/exutils.c                 |  82 +---
 drivers/acpi/acpica/hwacpi.c                  |   2 +-
 drivers/acpi/acpica/hwesleep.c                |   2 +-
 drivers/acpi/acpica/hwgpe.c                   |   2 +-
 drivers/acpi/acpica/hwpci.c                   |   2 +-
 drivers/acpi/acpica/hwregs.c                  |   2 +-
 drivers/acpi/acpica/hwsleep.c                 |   2 +-
 drivers/acpi/acpica/hwtimer.c                 |   2 +-
 drivers/acpi/acpica/hwvalid.c                 |   2 +-
 drivers/acpi/acpica/hwxface.c                 |   2 +-
 drivers/acpi/acpica/hwxfsleep.c               |   2 +-
 drivers/acpi/acpica/nsaccess.c                |   2 +-
 drivers/acpi/acpica/nsalloc.c                 |   2 +-
 drivers/acpi/acpica/nsarguments.c             |   2 +-
 drivers/acpi/acpica/nsconvert.c               |   2 +-
 drivers/acpi/acpica/nsdump.c                  |   2 +-
 drivers/acpi/acpica/nsdumpdv.c                |   2 +-
 drivers/acpi/acpica/nseval.c                  |   2 +-
 drivers/acpi/acpica/nsinit.c                  |   7 +-
 drivers/acpi/acpica/nsload.c                  |   6 +-
 drivers/acpi/acpica/nsnames.c                 |   2 +-
 drivers/acpi/acpica/nsobject.c                |  12 +-
 drivers/acpi/acpica/nsparse.c                 |   2 +-
 drivers/acpi/acpica/nspredef.c                |   2 +-
 drivers/acpi/acpica/nsprepkg.c                |  42 +--
 drivers/acpi/acpica/nsrepair.c                |  31 +-
 drivers/acpi/acpica/nsrepair2.c               |  39 +-
 drivers/acpi/acpica/nssearch.c                |   2 +-
 drivers/acpi/acpica/nsutils.c                 |   2 +-
 drivers/acpi/acpica/nswalk.c                  |   2 +-
 drivers/acpi/acpica/nsxfeval.c                |  35 +-
 drivers/acpi/acpica/nsxfname.c                |   2 +-
 drivers/acpi/acpica/nsxfobj.c                 |   2 +-
 drivers/acpi/acpica/psargs.c                  |   2 +-
 drivers/acpi/acpica/psloop.c                  |   6 +-
 drivers/acpi/acpica/psobject.c                |   9 +-
 drivers/acpi/acpica/psopcode.c                |   2 +-
 drivers/acpi/acpica/psopinfo.c                |   2 +-
 drivers/acpi/acpica/psparse.c                 |   2 +-
 drivers/acpi/acpica/psscope.c                 |   2 +-
 drivers/acpi/acpica/pstree.c                  |   2 +-
 drivers/acpi/acpica/psutils.c                 |   2 +-
 drivers/acpi/acpica/pswalk.c                  |   2 +-
 drivers/acpi/acpica/psxface.c                 |   2 +-
 drivers/acpi/acpica/rsaddr.c                  |   2 +-
 drivers/acpi/acpica/rscalc.c                  |   4 +-
 drivers/acpi/acpica/rscreate.c                |  12 +-
 drivers/acpi/acpica/rsdump.c                  |   5 +-
 drivers/acpi/acpica/rsdumpinfo.c              |   4 +-
 drivers/acpi/acpica/rsinfo.c                  |   6 +-
 drivers/acpi/acpica/rsio.c                    |   2 +-
 drivers/acpi/acpica/rsirq.c                   |   2 +-
 drivers/acpi/acpica/rslist.c                  |   2 +-
 drivers/acpi/acpica/rsmemory.c                |   2 +-
 drivers/acpi/acpica/rsmisc.c                  |   2 +-
 drivers/acpi/acpica/rsserial.c                |   2 +-
 drivers/acpi/acpica/rsutils.c                 |   2 +-
 drivers/acpi/acpica/rsxface.c                 |   2 +-
 drivers/acpi/acpica/tbfadt.c                  |   2 +-
 drivers/acpi/acpica/tbfind.c                  |   2 +-
 drivers/acpi/acpica/tbinstal.c                |  17 +-
 drivers/acpi/acpica/tbprint.c                 |  22 +-
 drivers/acpi/acpica/tbutils.c                 |   2 +-
 drivers/acpi/acpica/tbxface.c                 |   2 +-
 drivers/acpi/acpica/tbxfload.c                |   2 +-
 drivers/acpi/acpica/tbxfroot.c                |   2 +-
 drivers/acpi/acpica/utaddress.c               |   2 +-
 drivers/acpi/acpica/utalloc.c                 |   2 +-
 drivers/acpi/acpica/utbuffer.c                |   2 +-
 drivers/acpi/acpica/utcache.c                 |   2 +-
 drivers/acpi/acpica/utcopy.c                  |   8 +-
 drivers/acpi/acpica/utdebug.c                 |   2 +-
 drivers/acpi/acpica/utdecode.c                |   2 +-
 drivers/acpi/acpica/utdelete.c                |  17 +-
 drivers/acpi/acpica/uterror.c                 |   2 +-
 drivers/acpi/acpica/uteval.c                  |   2 +-
 drivers/acpi/acpica/utexcep.c                 |   2 +-
 drivers/acpi/acpica/utglobal.c                |  39 +-
 drivers/acpi/acpica/utids.c                   |   2 +-
 drivers/acpi/acpica/utinit.c                  |   2 +-
 drivers/acpi/acpica/utlock.c                  |   2 +-
 drivers/acpi/acpica/utmath.c                  |   2 +-
 drivers/acpi/acpica/utmisc.c                  |   2 +-
 drivers/acpi/acpica/utmutex.c                 |   2 +-
 drivers/acpi/acpica/utobject.c                |   2 +-
 drivers/acpi/acpica/utosi.c                   |  28 +-
 drivers/acpi/acpica/utownerid.c               |   2 +-
 drivers/acpi/acpica/utpredef.c                |   2 +-
 drivers/acpi/acpica/utresrc.c                 |   5 +-
 drivers/acpi/acpica/utstate.c                 |   2 +-
 drivers/acpi/acpica/utstring.c                |   2 +-
 drivers/acpi/acpica/uttrack.c                 |   5 +-
 drivers/acpi/acpica/utxface.c                 |   2 +-
 drivers/acpi/acpica/utxferror.c               |   2 +-
 drivers/acpi/acpica/utxfinit.c                |   2 +-
 drivers/acpi/acpica/utxfmutex.c               |   2 +-
 drivers/acpi/apei/Kconfig                     |   2 +-
 drivers/acpi/battery.c                        |   7 +-
 drivers/acpi/battery.h                        |  10 +
 drivers/acpi/bus.c                            |  63 ++--
 drivers/acpi/button.c                         |   4 +
 drivers/acpi/container.c                      |   5 +-
 drivers/acpi/device_pm.c                      |  41 +-
 drivers/acpi/dock.c                           | 454 ++++++----------------
 drivers/acpi/fan.c                            |  13 +-
 drivers/acpi/glue.c                           |  12 +
 drivers/acpi/internal.h                       |  13 +-
 drivers/acpi/osl.c                            |  43 ++-
 drivers/acpi/pci_irq.c                        |  36 +-
 drivers/acpi/pci_link.c                       |   2 -
 drivers/acpi/pci_root.c                       |   4 +-
 drivers/acpi/power.c                          |   2 -
 drivers/acpi/processor_core.c                 |  52 +--
 drivers/acpi/processor_driver.c               |   2 -
 drivers/acpi/processor_perflib.c              |  14 +-
 drivers/acpi/sbs.c                            |   2 +-
 drivers/acpi/scan.c                           | 261 ++++++++-----
 drivers/acpi/sysfs.c                          |   2 -
 drivers/acpi/tables.c                         | 128 +++----
 drivers/acpi/thermal.c                        |  37 +-
 drivers/acpi/utils.c                          |  16 +-
 drivers/acpi/video.c                          |   2 -
 drivers/acpi/video_detect.c                   |   2 -
 drivers/ata/libata-acpi.c                     |  72 ++--
 drivers/base/power/Makefile                   |   3 +-
 drivers/base/power/domain.c                   |   2 +-
 drivers/base/power/generic_ops.c              |   2 +-
 drivers/base/power/main.c                     | 280 +++++++++++---
 drivers/base/power/power.h                    |   4 +-
 drivers/base/power/qos.c                      | 220 ++++++++---
 drivers/base/power/runtime.c                  | 164 ++++++--
 drivers/base/power/sysfs.c                    |  97 +++--
 drivers/cpufreq/Kconfig                       |   2 +-
 drivers/cpufreq/Kconfig.arm                   |  17 +-
 drivers/cpufreq/acpi-cpufreq.c                |   1 -
 drivers/cpufreq/arm_big_little.c              |   6 +-
 drivers/cpufreq/blackfin-cpufreq.c            |   1 -
 drivers/cpufreq/cpufreq-cpu0.c                |   1 -
 drivers/cpufreq/cpufreq-nforce2.c             |   4 +-
 drivers/cpufreq/cpufreq.c                     | 497 +++++++++++++-----------
 drivers/cpufreq/cpufreq_stats.c               |  38 +-
 drivers/cpufreq/cris-artpec3-cpufreq.c        |   1 -
 drivers/cpufreq/cris-etraxfs-cpufreq.c        |   1 -
 drivers/cpufreq/davinci-cpufreq.c             |   1 -
 drivers/cpufreq/e_powersaver.c                |   1 -
 drivers/cpufreq/elanfreq.c                    |   1 -
 drivers/cpufreq/exynos-cpufreq.c              |  97 +----
 drivers/cpufreq/exynos5440-cpufreq.c          |   5 +-
 drivers/cpufreq/freq_table.c                  |  46 +--
 drivers/cpufreq/gx-suspmod.c                  |   4 +-
 drivers/cpufreq/ia64-acpi-cpufreq.c           |   1 -
 drivers/cpufreq/imx6q-cpufreq.c               |   1 -
 drivers/cpufreq/integrator-cpufreq.c          |   4 +-
 drivers/cpufreq/intel_pstate.c                |  45 +--
 drivers/cpufreq/kirkwood-cpufreq.c            |   1 -
 drivers/cpufreq/longhaul.c                    |   5 +-
 drivers/cpufreq/loongson2_cpufreq.c           |   1 -
 drivers/cpufreq/omap-cpufreq.c                |   1 -
 drivers/cpufreq/p4-clockmod.c                 |   1 -
 drivers/cpufreq/pasemi-cpufreq.c              |   1 -
 drivers/cpufreq/pcc-cpufreq.c                 |   4 +-
 drivers/cpufreq/powernow-k6.c                 |   5 +-
 drivers/cpufreq/powernow-k7.c                 |   6 +-
 drivers/cpufreq/powernow-k8.c                 |   6 +-
 drivers/cpufreq/ppc-corenet-cpufreq.c         |   5 +-
 drivers/cpufreq/ppc_cbe_cpufreq.c             |   1 -
 drivers/cpufreq/pxa2xx-cpufreq.c              |   1 -
 drivers/cpufreq/pxa3xx-cpufreq.c              |   1 -
 drivers/cpufreq/s3c24xx-cpufreq.c             |   4 +-
 drivers/cpufreq/s5pv210-cpufreq.c             |  49 +--
 drivers/cpufreq/sc520_freq.c                  |   1 -
 drivers/cpufreq/sh-cpufreq.c                  |   5 +-
 drivers/cpufreq/sparc-us2e-cpufreq.c          |   4 +-
 drivers/cpufreq/sparc-us3-cpufreq.c           |   4 +-
 drivers/cpufreq/spear-cpufreq.c               |  14 +-
 drivers/cpufreq/speedstep-centrino.c          |   2 -
 drivers/cpufreq/speedstep-ich.c               |   1 -
 drivers/cpufreq/speedstep-smi.c               |   1 -
 drivers/cpufreq/tegra-cpufreq.c               |  47 +--
 drivers/cpufreq/unicore2-cpufreq.c            |   4 +-
 drivers/cpuidle/cpuidle.c                     |   3 +-
 drivers/cpuidle/driver.c                      |   2 +-
 drivers/cpuidle/governors/menu.c              |  75 ++--
 drivers/devfreq/devfreq.c                     |  31 +-
 drivers/gpu/drm/gma500/Kconfig                |   1 -
 drivers/gpu/drm/i915/Kconfig                  |   1 -
 drivers/gpu/drm/nouveau/Kconfig               |   3 +-
 drivers/input/touchscreen/st1232.c            |   3 +-
 drivers/mtd/nand/sh_flctl.c                   |   2 +-
 drivers/pci/hotplug/acpiphp.h                 |  16 +-
 drivers/pci/hotplug/acpiphp_glue.c            | 523 +++++++++-----------------
 drivers/pci/pci-driver.c                      |  33 +-
 drivers/pcmcia/sa11xx_base.c                  |   3 -
 drivers/platform/x86/Kconfig                  |   2 -
 drivers/platform/x86/fujitsu-laptop.c         |   1 -
 drivers/pnp/resource.c                        |   2 +-
 drivers/powercap/intel_rapl.c                 |  17 +-
 drivers/tty/serial/sh-sci.c                   |   3 +-
 drivers/video/Kconfig                         |   6 -
 drivers/video/Makefile                        |   2 -
 drivers/video/output.c                        | 133 -------
 drivers/xen/xen-acpi-cpuhotplug.c             |   2 +-
 drivers/xen/xen-acpi-memhotplug.c             |   2 +-
 drivers/xen/xen-acpi-pad.c                    |  26 +-
 include/acpi/acbuffer.h                       |   2 +-
 include/acpi/acconfig.h                       |   2 +-
 include/acpi/acexcep.h                        |   2 +-
 include/acpi/acnames.h                        |   2 +-
 include/acpi/acoutput.h                       |   2 +-
 include/acpi/acpi.h                           |   5 +-
 include/acpi/acpi_bus.h                       |  49 ++-
 include/acpi/acpi_drivers.h                   |  26 +-
 include/acpi/acpiosxf.h                       |   2 +-
 include/acpi/acpixf.h                         |  10 +-
 include/acpi/acrestyp.h                       |   2 +-
 include/acpi/actbl.h                          |   2 +-
 include/acpi/actbl1.h                         |   2 +-
 include/acpi/actbl2.h                         |   2 +-
 include/acpi/actbl3.h                         |   2 +-
 include/acpi/actypes.h                        |  66 ++--
 include/acpi/platform/acenv.h                 |   2 +-
 include/acpi/platform/acgcc.h                 |   2 +-
 include/acpi/platform/aclinux.h               |  20 +-
 include/linux/acpi.h                          |   4 +
 include/linux/cpufreq.h                       |  37 +-
 include/linux/pci-acpi.h                      |   4 +-
 include/linux/pm.h                            |  71 ++--
 include/linux/pm_qos.h                        |  34 +-
 include/linux/pm_runtime.h                    |   4 +
 include/linux/video_output.h                  |  57 ---
 include/trace/events/power.h                  |   4 +-
 kernel/power/hibernate.c                      |  22 +-
 kernel/power/main.c                           |   4 +-
 kernel/power/power.h                          |   2 +
 kernel/power/qos.c                            |  18 +-
 kernel/power/snapshot.c                       |   2 +-
 kernel/power/suspend.c                        |   2 +-
 kernel/power/wakelock.c                       |   2 +
 341 files changed, 3484 insertions(+), 2942 deletions(-)
