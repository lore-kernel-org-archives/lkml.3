Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab3GAOeO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 10:34:14 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:56096 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751408Ab3GAOeL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 10:34:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [GIT PULL] ACPI and power management updates for v3.11-rc1
Date: Mon, 01 Jul 2013 16:43:45 +0200
Message-ID: <1512278.ZvHkzrv9pd@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from the git repository at

  git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm+acpi-3.11-rc1

to receive ACPI and power management updates for v3.11 with top-most commit
2c843bd92ec276ecb68504b3b5ffa7066183f032

  Merge branch 'pm-cpufreq'

on top of commit 45e00374db944b1c12987b501bcaa279b3e36d93

  Merge branch 'pm-fixes'

This time the total number of ACPI commits is slightly greater than the
number of cpufreq commits, but Viresh Kumar (who works on cpufreq) remains
the most active patch submitter.

To me, the most significant change is the addition of offline/online
device operations to the driver core (with the Greg's blessing) and the
related modifications of the ACPI core hotplug code.  Next are the
freezer updates from Colin Cross that should make the freezing of
tasks a bit less heavy weight.

We also have a couple of regression fixes, a number of fixes for issues that
have not been identified as regressions, two new drivers and a bunch of
cleanups all over.

Highlights:

 1) Hotplug changes to support graceful hot-removal failures.

    It sometimes is necessary to fail device hot-removal operations
    gracefully if they cannot be carried out completely.  For example,
    if memory from a memory module being hot-removed has been
    allocated for the kernel's own use and cannot be moved elsewhere,
    it's desirable to fail the hot-removal operation in a graceful way
    rather than to crash the kernel, but currenty a success or a
    kernel crash are the only possible outcomes of an attempted memory
    hot-removal.  Needless to say, that is not a very attractive
    alternative and it had to be addressed.

    However, in order to make it work for memory, I first had to make
    it work for CPUs and for this purpose I needed to modify the ACPI
    processor driver.  It's been split into two parts, a resident one
    handling the low-level initialization/cleanup and a modular one
    playing the actual driver's role (but it binds to the CPU system
    device objects rather than to the ACPI device objects representing
    processors).  That's been sort of like a live brain surgery on a
    patient who's riding a bike.

    So this is a little scary, but since we found and fixed a couple
    of regressions it caused to happen during the early linux-next
    testing (a month ago), nobody has complained.

    As a bonus we remove some duplicated ACPI hotplug code, because
    the ACPI-based CPU hotplug is now going to use the common ACPI
    hotplug code.

 2) Lighter weight freezing of tasks.

    These changes from Colin Cross and Mandeep Singh Baines are
    targeted at making the freezing of tasks a bit less heavy weight
    operation.  They reduce the number of tasks woken up every time
    during the freezing, by using the observation that the freezer
    simply doesn't need to wake up some of them and wait for them
    all to call refrigerator().  The time needed for the freezer to
    decide to report a failure is reduced too.

    Also reintroduced is the check causing a lockdep warining to
    trigger when try_to_freeze() is called with locks held (which is
    generally unsafe and shouldn't happen).

 3) cpufreq updates

    First off, a commit from Srivatsa S Bhat fixes a resume regression
    introduced during the 3.10 cycle causing some cpufreq sysfs
    attributes to return wrong values to user space after resume.  The
    fix is kind of fresh, but also it's pretty obvious once Srivatsa
    has identified the root cause.

    Second, we have a new freqdomain_cpus sysfs attribute for the
    acpi-cpufreq driver to provide information previously available
    via related_cpus.  From Lan Tianyu.

    Finally, we fix a number of issues, mostly related to the
    CPUFREQ_POSTCHANGE notifier and cpufreq Kconfig options and clean
    up some code.  The majority of changes from Viresh Kumar with bits
    from Jacob Shin, Heiko Stübner, Xiaoguang Chen, Ezequiel Garcia,
    Arnd Bergmann, and Tang Yuantian.

 4) ACPICA update

    A usual bunch of updates from the ACPICA upstream.

    During the 3.4 cycle we introduced support for ACPI 5 extended
    sleep registers, but they are only supposed to be used if the
    HW-reduced mode bit is set in the FADT flags and the code
    attempted to use them without checking that bit.  That caused
    suspend/resume regressions to happen on some systems.  Fix from
    Lv Zheng causes those registers to be used only if the
    HW-reduced mode bit is set.

    Apart from this some other ACPICA bugs are fixed and code
    cleanups are made by Bob Moore, Tomasz Nowicki, Lv Zheng,
    Chao Guan, and Zhang Rui.

 5) cpuidle updates

    New driver for Xilinx Zynq processors is added by Michal Simek.

    Multidriver support simplification, addition of some missing
    kerneldoc comments and Kconfig-related fixes come from Daniel Lezcano. 

 6) ACPI power management updates

    Changes to make suspend/resume work correctly in Xen guests from
    Konrad Rzeszutek Wilk, sparse warning fix from Fengguang Wu
    and cleanups and fixes of the ACPI device power state selection
    routine.

 7) ACPI documentation updates

    Some previously missing pieces of ACPI documentation are added
    by Lv Zheng and Aaron Lu (hopefully, that will help people to
    uderstand how the ACPI subsystem works) and one outdated doc is
    updated by Hanjun Guo.

 8) Assorted ACPI updates

    We finally nailed down the IA-64 issue that was the reason for
    reverting commit 9f29ab1 (ACPI / scan: do not match drivers
    against objects having scan handlers), so we can fix it and
    move the ACPI scan handler check added to the ACPI video driver
    back to the core.

    A mechanism for adding CMOS RTC address space handlers is
    introduced by Lan Tianyu to allow some EC-related breakage to be
    fixed on some systems.

    A spec-compliant implementation of acpi_os_get_timer() is added
    by Mika Westerberg.

    The evaluation of _STA is added to do_acpi_find_child() to avoid
    situations in which a pointer to a disabled device object is
    returned instead of an enabled one with the same _ADR value.
    From Jeff Wu.

    Intel BayTrail PCH (Platform Controller Hub) support is added to
    the ACPI driver for Intel Low-Power Subsystems (LPSS) and that
    driver is modified to work around a couple of known BIOS issues.
    Changes from Mika Westerberg and Heikki Krogerus.

    The EC driver is fixed by Vasiliy Kulikov to use get_user() and
    put_user() instead of dereferencing user space pointers blindly.

    Code cleanups are made by Bjorn Helgaas, Nicholas Mazzuca and
    Toshi Kani.

 9) Assorted power management updates

    The "runtime idle" helper routine is changed to take the return
    values of the callbacks executed by it into account and to call
    rpm_suspend() if they return 0, which allows us to reduce the
    overall code bloat a bit (by dropping some code that's not
    necessary any more after that modification).

    The runtime PM documentation is updated by Alan Stern (to reflect
    the "runtime idle" behavior change).

    New trace points for PM QoS are added by Sahara
    (<keun-o.park@windriver.com>).

    PM QoS documentation is updated by Lan Tianyu.

    Code cleanups are made and minor issues are addressed by
    Bernie Thompson, Bjorn Helgaas, Julius Werner, and Shuah Khan.

10) devfreq updates

    New driver for the Exynos5-bus device from Abhilash Kesavan.

    Minor cleanups, fixes and MAINTAINERS update from MyungJoo Ham,
    Abhilash Kesavan, Paul Bolle, Rajagopal Venkat, and Wei Yongjun.

11) OMAP power management updates

    Adaptive Voltage Scaling (AVS) SmartReflex voltage control driver
    updates from Andrii Tseglytskyi and Nishanth Menon.

Thanks!


---------------

Aaron Lu (3):
      ACPI / video: add description for brightness_switch_enabled
      ACPI / video: move video_extension.txt to Documentation/acpi
      ACPI / video: update video_extension.txt for backlight control

Abhilash Kesavan (2):
      PM / devfreq: Move exynos4 devfreq driver into a new sub-directory
      PM / devfreq: Add Exynos5-bus devfreq driver for Exynos5250

Alan Stern (1):
      PM / Runtime: Update .runtime_idle() callback documentation

Andrii Tseglytskyi (6):
      PM / AVS: SmartReflex: disable runtime PM on driver remove
      PM / AVS: SmartReflex: fix driver name
      PM / AVS: SmartReflex: use omap_sr * for errgen interfaces
      PM / AVS: SmartReflex: use omap_sr * for minmax interfaces
      PM / AVS: SmartReflex: use omap_sr * for enable/disable interface
      PM / AVS: SmartReflex: use devm_* API to initialize SmartReflex

Arnd Bergmann (2):
      cpufreq: SPEAr needs cpufreq table
      cpufreq: big.LITTLE needs cpufreq table

Bernie Thompson (1):
      PM / wakeup: Adjust messaging for wake events during suspend

Bjorn Helgaas (2):
      PM / Hibernate: print physical addresses consistently with other parts of kernel
      ACPI: Remove useless initializers

Bob Moore (10):
      ACPICA: Change an exception code for the ASL UnLoad() operator
      ACPICA: Add BIOS error interface for predefined name validation support
      ACPICA: Add argument typechecking for all predefined ACPI names
      ACPICA: Predefined name support: Remove unused local variable
      ACPICA: Update version to 20130418
      ACPICA: Split buffer dump routines into separate file
      ACPICA: Split internal error msg routines to a separate file
      ACPICA: Split table print utilities to a new a separate file
      ACPICA: Update interface to acpi_ut_valid_acpi_name()
      ACPICA: Update version to 20130517

Chao Guan (1):
      ACPICA: Standardize all switch() blocks

Colin Cross (15):
      freezer: add unsafe versions of freezable helpers for NFS
      freezer: add unsafe versions of freezable helpers for CIFS
      lockdep: remove task argument from debug_check_no_locks_held
      freezer: shorten freezer sleep time using exponential backoff
      freezer: skip waking up tasks with PF_FREEZER_SKIP set
      freezer: convert freezable helpers to freezer_do_not_count()
      freezer: convert freezable helpers to static inline where possible
      freezer: add new freezable helpers using freezer_do_not_count()
      binder: use freezable blocking calls
      epoll: use freezable blocking call
      select: use freezable blocking call
      futex: use freezable blocking call
      nanosleep: use freezable blocking call
      sigtimedwait: use freezable blocking call
      af_unix: use freezable blocking calls in read

Daniel Lezcano (4):
      cpuidle: improve governor Kconfig options
      cpuidle: simplify multiple driver support
      cpuidle: Comment the driver's framework code
      cpuidle: Fix ARCH_NEEDS_CPU_IDLE_COUPLED dependency warning

David Flater (1):
      pnp: restore automatic resolution of DMA conflicts

Ezequiel Garcia (1):
      cpufreq: kirkwood: Select CPU_FREQ_TABLE option

Fengguang Wu (1):
      ACPI / PM: acpi_processor_suspend() can be static

Hanjun Guo (3):
      ACPI / processor: Fix potential NULL pointer dereference in acpi_processor_add()
      Documentation / CPU hotplug: Rephrase the outdated description for MADT entries
      ACPI / processor: Remove unused macros in processor_driver.c

Heikki Krogerus (1):
      ACPI / LPSS: mask the UART TX completion interrupt

Heiko Stübner (1):
      cpufreq: s3c2416: fix forgotten driver_data conversions

Jacob Shin (1):
      cpufreq: don't leave stale policy pointer in cdbs->cur_policy

Jeff Wu (1):
      ACPI: add _STA evaluation at do_acpi_find_child()

Julius Werner (1):
      PM / Sleep: Print last wakeup source on failed wakeup_count write

Konrad Rzeszutek Wilk (2):
      x86 / ACPI / sleep: Provide registration for acpi_suspend_lowlevel.
      xen / ACPI / sleep: Register an acpi_suspend_lowlevel callback.

Lan Tianyu (5):
      ACPI / processor: Drop unused variable from processor_perflib.c
      ACPI: Add CMOS RTC Operation Region handler support
      ACPI / EC: Add HP Folio 13 to ec_dmi_table in order to skip DSDT scan
      acpi-cpufreq: Add new sysfs attribute freqdomain_cpus
      PM / QoS: Update Documentation/power/pm_qos_interface.txt

Lv Zheng (9):
      ACPICA: Remove unused macros, no functional change
      ACPICA: Add option to disable loading of SSDTs from the RSDT/XSDT
      ACPICA: Do not use extended sleep registers unless HW-reduced bit is set
      ACPICA: Move _PRT repair into the standard complex repair module
      ACPICA: Add several repairs for _CST predefined name
      ACPICA: _CST repair: Handle null package entries
      ACPI: Update MAINTAINERS file to include Documentation/acpi
      ACPI: Add sysfs ABI documentation
      ACPI: Add ACPI namespace documentation

Mandeep Singh Baines (1):
      lockdep: check that no locks held at freeze time

Michal Simek (1):
      ARM: zynq: Add cpuidle support

Mika Westerberg (3):
      ACPI / LPSS: add support for Intel BayTrail
      ACPI / LPSS: override SDIO private register space size from ACPI tables
      ACPI: implement acpi_os_get_timer() according the spec

MyungJoo Ham (2):
      PM / devfreq: add comments and Documentation
      MAINTAINERS: update mailing list for devfreq(DVFS).

Nicholas Mazzuca (1):
      ACPI / battery: Make sure all spaces are in correct places

Nishanth Menon (1):
      PM / AVS: SmartReflex: disable errgen before vpbound disable

Paul Bolle (1):
      PM / devfreq: fix typo "CPU_EXYNOS4.12" twice

Rafael J. Wysocki (23):
      Driver core: Add offline/online device operations
      Driver core: Use generic offline/online for CPU offline/online
      ACPI / hotplug: Use device offline/online for graceful hot-removal
      ACPI / processor: Use common hotplug infrastructure
      ACPI / memhotplug: Bind removable memory blocks to ACPI device nodes
      Driver core: Introduce offline/online callbacks for memory blocks
      ACPI / processor: Initialize per_cpu(processors, pr->id) properly
      Driver core / memory: Simplify __memory_block_change_state()
      ACPI: Drop removal_type field from struct acpi_device
      ACPI / processor: Pass processor object handle to acpi_bind_one()
      Driver core / MM: Drop offline_memory_block()
      ACPI / scan: Add second pass of companion offlining to hot-remove code
      Memory hotplug / ACPI: Simplify memory removal
      Memory hotplug: Move alternative function definitions to header
      PM / Runtime: Rework the "runtime idle" helper routine
      ACPI / cpufreq: Add ACPI processor device IDs to acpi-cpufreq
      ACPI / scan: Simplify ACPI driver probing
      ACPI / PM: Rename function acpi_device_power_state() and make it static
      ACPI / PM: Replace ACPI_STATE_D3 with ACPI_STATE_D3_COLD in device_pm.c
      ACPI / PM: Rework and clean up acpi_dev_pm_get_state()
      ACPI / ia64 / sba_iommu: Use ACPI scan handler for device discovery
      ACPI / scan: Do not bind ACPI drivers to objects with scan handlers
      ACPI / PM: Fix possible NULL pointer deref in acpi_pm_device_sleep_state()

Rajagopal Venkat (1):
      PM / devfreq: account suspend/resume for stats

Sahara (5):
      PM / QoS: correct the valid range of pm_qos_class
      PM / QoS: Add pm_qos_update_target/flags tracepoints
      PM / QoS: Add pm_qos_request tracepoints
      PM / QoS: Add dev_pm_qos_request tracepoints
      PM / QoS: Add pm_qos and dev_pm_qos to events-power.txt

Shuah Khan (1):
      PM / Sleep: Warn about system time after resume with pm_trace

Srivatsa S. Bhat (1):
      cpufreq: Fix cpufreq regression after suspend/resume

Tang Yuantian (1):
      cpufreq: powerpc: Add cpufreq driver for Freescale e500mc SoCs

Tomasz Nowicki (3):
      ACPICA: ACPICA Termination: Delete global lock pending lock
      ACPICA: Fix possible memory leak in GPE init error path
      ACPICA: Clear events initialized flag upon event component termination

Toshi Kani (3):
      CPU: Fix sysfs cpu/online of offlined CPUs
      ACPI: Do not use CONFIG_ACPI_HOTPLUG_MEMORY_MODULE
      ACPI: Remove unused flags in acpi_device_flags

Vasiliy Kulikov (1):
      ACPI / EC: access user space with get_user()/put_user()

Viresh Kumar (36):
      cpufreq: tegra: Don't initialize .index field of cpufreq_frequency_table
      cpufreq: Add EXPORT_SYMBOL_GPL for have_governor_per_policy
      cpufreq: governors: Move get_governor_parent_kobj() to cpufreq.c
      cpufreq: Move get_cpu_idle_time() to cpufreq.c
      cpufreq: Don't create empty /sys/devices/system/cpu/cpufreq directory
      cpufreq: rename index as driver_data in cpufreq_frequency_table
      cpufreq: MAINTAINERS: Add git tree path for ARM specific updates
      cpufreq: remove unnecessary cpufreq_cpu_{get|put}() calls
      cpufreq: powerpc: move cpufreq driver to drivers/cpufreq
      cpufreq: blackfin: enable driver for CONFIG_BFIN_CPU_FREQ
      cpufreq: cris: select CPU_FREQ_TABLE
      cpufreq: davinci: select CPU_FREQ_TABLE
      cpufreq: exynos: select CPU_FREQ_TABLE
      cpufreq: highbank: remove select CPU_FREQ_TABLE
      cpufreq: imx: select CPU_FREQ_TABLE
      cpufreq: powerpc: CBE_RAS: select CPU_FREQ_TABLE
      cpufreq: pxa: select CPU_FREQ_TABLE
      cpufreq: S3C2416/S3C64XX: select CPU_FREQ_TABLE
      cpufreq: tegra: create CONFIG_ARM_TEGRA_CPUFREQ
      cpufreq: X86_AMD_FREQ_SENSITIVITY: select CPU_FREQ_TABLE
      cpufreq: Simplify userspace governor
      cpufreq: Fix minor formatting issues
      cpufreq: make __cpufreq_notify_transition() static
      cpufreq: ACPI: call CPUFREQ_POSTCHANGE notfier in error cases
      cpufreq: e_powersaver: call CPUFREQ_POSTCHANGE notfier in error cases
      cpufreq: pcc: call CPUFREQ_POSTCHANGE notfier in error cases
      cpufreq: powernow-k8: call CPUFREQ_POSTCHANGE notfier in error cases
      cpufreq: arm-big-little: call CPUFREQ_POSTCHANGE notfier in error cases
      cpufreq: davinci: call CPUFREQ_POSTCHANGE notfier in error cases
      cpufreq: dbx500: call CPUFREQ_POSTCHANGE notfier in error cases
      cpufreq: exynos: call CPUFREQ_POSTCHANGE notfier in error cases
      cpufreq: imx6q: call CPUFREQ_POSTCHANGE notfier in error cases
      cpufreq: omap: call CPUFREQ_POSTCHANGE notfier in error cases
      cpufreq: s3c64xx: call CPUFREQ_POSTCHANGE notfier in error cases
      cpufreq: tegra: call CPUFREQ_POSTCHANGE notfier in error cases
      cpufreq: make sure frequency transitions are serialized

Wei Yongjun (1):
      PM / devfreq: fix missing unlock on error in exynos4_busfreq_pm_notifier_event()

Xiaoguang Chen (1):
      cpufreq: Fix governor start/stop race condition

Zhang Rui (1):
      ACPICA: Update for "orphan" embedded controller _REG method support

---------------

 Documentation/ABI/testing/sysfs-bus-acpi                |   58 ++
 Documentation/ABI/testing/sysfs-class-devfreq           |   20 +
 Documentation/ABI/testing/sysfs-devices-online          |   20 +
 Documentation/ABI/testing/sysfs-devices-sun             |    2 +-
 Documentation/ABI/testing/sysfs-devices-system-cpu      |   15 +
 Documentation/ABI/testing/sysfs-firmware-acpi           |   10 +
 Documentation/acpi/namespace.txt                        |  395 +++++++++++
 Documentation/acpi/video_extension.txt                  |  106 +++
 Documentation/cpu-freq/cpu-drivers.txt                  |   10 +-
 Documentation/cpu-hotplug.txt                           |    6 +-
 Documentation/kernel-parameters.txt                     |    9 +
 Documentation/power/pm_qos_interface.txt                |   50 +-
 Documentation/power/runtime_pm.txt                      |   20 +-
 Documentation/power/video_extension.txt                 |   37 -
 Documentation/trace/events-power.txt                    |   31 +
 MAINTAINERS                                             |    8 +-
 arch/arm/mach-davinci/Kconfig                           |    1 +
 arch/arm/mach-davinci/da850.c                           |    8 +-
 arch/arm/mach-omap2/omap_device.c                       |    7 +-
 arch/arm/mach-omap2/smartreflex-class3.c                |    8 +-
 arch/arm/mach-pxa/Kconfig                               |    3 +
 arch/arm/mach-s3c24xx/cpufreq-utils.c                   |    2 +-
 arch/arm/mach-s3c24xx/cpufreq.c                         |    4 +-
 arch/arm/mach-s3c24xx/pll-s3c2410.c                     |   54 +-
 arch/arm/mach-s3c24xx/pll-s3c2440-12000000.c            |   54 +-
 arch/arm/mach-s3c24xx/pll-s3c2440-16934400.c            |  110 +--
 arch/arm/mach-shmobile/clock-sh7372.c                   |    6 +-
 arch/arm/mach-tegra/Kconfig                             |    3 -
 arch/arm/plat-samsung/include/plat/cpu-freq-core.h      |    2 +-
 arch/cris/Kconfig                                       |    2 +
 arch/ia64/hp/common/sba_iommu.c                         |   24 +-
 arch/mips/loongson/lemote-2f/clock.c                    |    3 +-
 arch/powerpc/platforms/Kconfig                          |   31 -
 arch/powerpc/platforms/pasemi/Makefile                  |    1 -
 arch/powerpc/platforms/powermac/Makefile                |    2 -
 arch/x86/include/asm/acpi.h                             |    2 +-
 arch/x86/kernel/acpi/boot.c                             |    7 +
 arch/x86/kernel/acpi/sleep.c                            |    4 +-
 arch/x86/kernel/acpi/sleep.h                            |    2 +
 drivers/acpi/Makefile                                   |    2 +
 drivers/acpi/acpi_cmos_rtc.c                            |   92 +++
 drivers/acpi/acpi_lpss.c                                |  125 +++-
 drivers/acpi/acpi_memhotplug.c                          |   62 +-
 drivers/acpi/acpi_processor.c                           |  494 ++++++++++++++
 drivers/acpi/acpica/Makefile                            |    4 +
 drivers/acpi/acpica/acglobal.h                          |    6 +
 drivers/acpi/acpica/aclocal.h                           |   17 -
 drivers/acpi/acpica/acmacros.h                          |   10 +-
 drivers/acpi/acpica/acnamesp.h                          |   43 +-
 drivers/acpi/acpica/acpredef.h                          |    4 +-
 drivers/acpi/acpica/acstruct.h                          |   40 +-
 drivers/acpi/acpica/acutils.h                           |   50 +-
 drivers/acpi/acpica/dscontrol.c                         |    4 +-
 drivers/acpi/acpica/dsfield.c                           |    4 +
 drivers/acpi/acpica/dsinit.c                            |    1 +
 drivers/acpi/acpica/dsmthdat.c                          |    2 +-
 drivers/acpi/acpica/dsobject.c                          |    3 +-
 drivers/acpi/acpica/dsopcode.c                          |    1 +
 drivers/acpi/acpica/dsutils.c                           |    5 +-
 drivers/acpi/acpica/dswexec.c                           |    3 +-
 drivers/acpi/acpica/dswload.c                           |    7 +-
 drivers/acpi/acpica/dswload2.c                          |    4 +
 drivers/acpi/acpica/evglock.c                           |    1 +
 drivers/acpi/acpica/evgpe.c                             |    7 +-
 drivers/acpi/acpica/evgpeblk.c                          |    2 +
 drivers/acpi/acpica/evgpeinit.c                         |    3 +
 drivers/acpi/acpica/evhandler.c                         |    7 +
 drivers/acpi/acpica/evmisc.c                            |    3 +
 drivers/acpi/acpica/evregion.c                          |   63 +-
 drivers/acpi/acpica/evrgnini.c                          |    2 +
 drivers/acpi/acpica/evxfgpe.c                           |    3 +
 drivers/acpi/acpica/evxfregn.c                          |    1 +
 drivers/acpi/acpica/exconfig.c                          |    3 +-
 drivers/acpi/acpica/exconvrt.c                          |   13 +-
 drivers/acpi/acpica/excreate.c                          |    3 -
 drivers/acpi/acpica/exdebug.c                           |    2 +
 drivers/acpi/acpica/exdump.c                            |    2 +
 drivers/acpi/acpica/exfield.c                           |    4 +
 drivers/acpi/acpica/exfldio.c                           |    2 -
 drivers/acpi/acpica/exmisc.c                            |   12 +-
 drivers/acpi/acpica/exoparg1.c                          |   16 +-
 drivers/acpi/acpica/exoparg2.c                          |    1 -
 drivers/acpi/acpica/exoparg3.c                          |    1 -
 drivers/acpi/acpica/exoparg6.c                          |    5 -
 drivers/acpi/acpica/exprep.c                            |    7 +
 drivers/acpi/acpica/exregion.c                          |   27 +-
 drivers/acpi/acpica/exresnte.c                          |    1 +
 drivers/acpi/acpica/exresolv.c                          |    6 +-
 drivers/acpi/acpica/exresop.c                           |    9 +-
 drivers/acpi/acpica/exstore.c                           |    4 +-
 drivers/acpi/acpica/exstoren.c                          |    4 -
 drivers/acpi/acpica/hwacpi.c                            |    2 +-
 drivers/acpi/acpica/hwgpe.c                             |    3 +
 drivers/acpi/acpica/hwregs.c                            |    4 +-
 drivers/acpi/acpica/hwxface.c                           |    9 +-
 drivers/acpi/acpica/hwxfsleep.c                         |   12 +-
 drivers/acpi/acpica/nsaccess.c                          |    1 +
 drivers/acpi/acpica/nsarguments.c                       |  294 ++++++++
 drivers/acpi/acpica/nsconvert.c                         |    3 +
 drivers/acpi/acpica/nsdump.c                            |   10 +
 drivers/acpi/acpica/nseval.c                            |  247 ++++---
 drivers/acpi/acpica/nsinit.c                            |   16 +-
 drivers/acpi/acpica/nspredef.c                          |  216 ++----
 drivers/acpi/acpica/nsprepkg.c                          |   81 ++-
 drivers/acpi/acpica/nsrepair.c                          |   51 +-
 drivers/acpi/acpica/nsrepair2.c                         |  358 ++++++++--
 drivers/acpi/acpica/nsutils.c                           |    3 +
 drivers/acpi/acpica/nsxfeval.c                          |  163 ++++-
 drivers/acpi/acpica/psargs.c                            |    4 +
 drivers/acpi/acpica/psloop.c                            |    2 +-
 drivers/acpi/acpica/psobject.c                          |    1 +
 drivers/acpi/acpica/psparse.c                           |    3 +-
 drivers/acpi/acpica/pstree.c                            |    2 +
 drivers/acpi/acpica/psxface.c                           |   14 +-
 drivers/acpi/acpica/rscalc.c                            |    7 +-
 drivers/acpi/acpica/rscreate.c                          |   27 -
 drivers/acpi/acpica/rsdump.c                            |   10 +
 drivers/acpi/acpica/rsmisc.c                            |    3 +-
 drivers/acpi/acpica/rsutils.c                           |    7 +-
 drivers/acpi/acpica/rsxface.c                           |    1 +
 drivers/acpi/acpica/tbinstal.c                          |    7 +-
 drivers/acpi/acpica/tbprint.c                           |  237 +++++++
 drivers/acpi/acpica/tbutils.c                           |  191 +-----
 drivers/acpi/acpica/tbxfload.c                          |   25 +-
 drivers/acpi/acpica/utbuffer.c                          |  201 ++++++
 drivers/acpi/acpica/utcopy.c                            |   11 +-
 drivers/acpi/acpica/utdebug.c                           |  148 +---
 drivers/acpi/acpica/utdelete.c                          |    3 +-
 drivers/acpi/acpica/uterror.c                           |  289 ++++++++
 drivers/acpi/acpica/uteval.c                            |    9 +-
 drivers/acpi/acpica/utexcep.c                           |    1 +
 drivers/acpi/acpica/utids.c                             |    3 +
 drivers/acpi/acpica/utmisc.c                            |    2 +
 drivers/acpi/acpica/utobject.c                          |    5 +-
 drivers/acpi/acpica/utpredef.c                          |   16 +-
 drivers/acpi/acpica/utstring.c                          |   19 +-
 drivers/acpi/acpica/uttrack.c                           |    8 +
 drivers/acpi/acpica/utxferror.c                         |  234 -------
 drivers/acpi/battery.c                                  |   18 +-
 drivers/acpi/bus.c                                      |   17 +-
 drivers/acpi/device_pm.c                                |  170 +++--
 drivers/acpi/ec.c                                       |    4 +
 drivers/acpi/ec_sys.c                                   |   18 +-
 drivers/acpi/glue.c                                     |   12 +-
 drivers/acpi/internal.h                                 |   10 +
 drivers/acpi/osl.c                                      |   27 +-
 drivers/acpi/processor_driver.c                         |  818 +++--------------------
 drivers/acpi/processor_idle.c                           |    4 +-
 drivers/acpi/processor_perflib.c                        |    4 +-
 drivers/acpi/scan.c                                     |  205 ++++--
 drivers/acpi/sleep.c                                    |    2 +
 drivers/acpi/sysfs.c                                    |   31 +
 drivers/acpi/video.c                                    |    3 -
 drivers/amba/bus.c                                      |    2 +-
 drivers/ata/libata-core.c                               |    2 +-
 drivers/base/core.c                                     |  130 ++++
 drivers/base/cpu.c                                      |  101 ++-
 drivers/base/memory.c                                   |  114 ++--
 drivers/base/platform.c                                 |    1 -
 drivers/base/power/domain.c                             |    1 -
 drivers/base/power/generic_ops.c                        |   23 -
 drivers/base/power/opp.c                                |    4 +-
 drivers/base/power/qos.c                                |    6 +
 drivers/base/power/runtime.c                            |   12 +-
 drivers/base/power/wakeup.c                             |    9 +-
 drivers/clk/x86/clk-lpt.c                               |    4 +-
 drivers/cpufreq/Kconfig.arm                             |   17 +-
 drivers/cpufreq/Kconfig.powerpc                         |   37 +
 drivers/cpufreq/Kconfig.x86                             |    1 +
 drivers/cpufreq/Makefile                                |    8 +-
 drivers/cpufreq/acpi-cpufreq.c                          |   46 +-
 drivers/cpufreq/arm_big_little.c                        |    4 +-
 drivers/cpufreq/blackfin-cpufreq.c                      |   10 +-
 drivers/cpufreq/cpufreq.c                               |  223 ++++--
 drivers/cpufreq/cpufreq_governor.c                      |   51 +-
 drivers/cpufreq/cpufreq_governor.h                      |    5 +-
 drivers/cpufreq/cpufreq_performance.c                   |    4 -
 drivers/cpufreq/cpufreq_powersave.c                     |    6 +-
 drivers/cpufreq/cpufreq_stats.c                         |    5 +-
 drivers/cpufreq/cpufreq_userspace.c                     |  112 +---
 drivers/cpufreq/davinci-cpufreq.c                       |    3 +
 drivers/cpufreq/dbx500-cpufreq.c                        |    4 +-
 drivers/cpufreq/e_powersaver.c                          |   11 +-
 drivers/cpufreq/exynos-cpufreq.c                        |   10 +-
 drivers/cpufreq/freq_table.c                            |   26 +-
 drivers/cpufreq/ia64-acpi-cpufreq.c                     |    2 +-
 drivers/cpufreq/imx6q-cpufreq.c                         |   17 +-
 drivers/cpufreq/kirkwood-cpufreq.c                      |    2 +-
 drivers/cpufreq/longhaul.c                              |   16 +-
 drivers/cpufreq/loongson2_cpufreq.c                     |    2 +-
 drivers/cpufreq/omap-cpufreq.c                          |    6 +-
 drivers/cpufreq/p4-clockmod.c                           |    4 +-
 .../cpufreq.c => drivers/cpufreq/pasemi-cpufreq.c       |    5 +-
 drivers/cpufreq/pcc-cpufreq.c                           |    2 +
 .../cpufreq_32.c => drivers/cpufreq/pmac32-cpufreq.c    |    0
 .../cpufreq_64.c => drivers/cpufreq/pmac64-cpufreq.c    |    0
 drivers/cpufreq/powernow-k6.c                           |    8 +-
 drivers/cpufreq/powernow-k7.c                           |   16 +-
 drivers/cpufreq/powernow-k8.c                           |   24 +-
 drivers/cpufreq/ppc-corenet-cpufreq.c                   |  380 +++++++++++
 drivers/cpufreq/ppc_cbe_cpufreq.c                       |    4 +-
 drivers/cpufreq/pxa2xx-cpufreq.c                        |    8 +-
 drivers/cpufreq/pxa3xx-cpufreq.c                        |    4 +-
 drivers/cpufreq/s3c2416-cpufreq.c                       |    6 +-
 drivers/cpufreq/s3c64xx-cpufreq.c                       |   10 +-
 drivers/cpufreq/sc520_freq.c                            |    2 +-
 drivers/cpufreq/sparc-us2e-cpufreq.c                    |   12 +-
 drivers/cpufreq/sparc-us3-cpufreq.c                     |    8 +-
 drivers/cpufreq/spear-cpufreq.c                         |    4 +-
 drivers/cpufreq/speedstep-centrino.c                    |    8 +-
 drivers/cpufreq/tegra-cpufreq.c                         |   23 +-
 drivers/cpuidle/Kconfig                                 |   27 +-
 drivers/cpuidle/Makefile                                |    1 +
 drivers/cpuidle/cpuidle-zynq.c                          |   83 +++
 drivers/cpuidle/cpuidle.c                               |    4 +-
 drivers/cpuidle/driver.c                                |  324 +++++----
 drivers/devfreq/Kconfig                                 |   12 +-
 drivers/devfreq/Makefile                                |    3 +-
 drivers/devfreq/devfreq.c                               |   25 +-
 drivers/devfreq/exynos/Makefile                         |    3 +
 drivers/devfreq/{ => exynos}/exynos4_bus.c              |    1 +
 drivers/devfreq/exynos/exynos5_bus.c                    |  503 ++++++++++++++
 drivers/devfreq/exynos/exynos_ppmu.c                    |   56 ++
 drivers/devfreq/exynos/exynos_ppmu.h                    |   78 +++
 drivers/dma/intel_mid_dma.c                             |    2 +-
 drivers/gpio/gpio-langwell.c                            |    6 +-
 drivers/i2c/i2c-core.c                                  |    2 +-
 drivers/mfd/ab8500-gpadc.c                              |    8 +-
 drivers/mfd/db8500-prcmu.c                              |   10 +-
 drivers/mmc/core/bus.c                                  |    2 +-
 drivers/mmc/core/sdio_bus.c                             |    2 +-
 drivers/pci/pci-driver.c                                |   14 +-
 drivers/pnp/manager.c                                   |   14 +-
 drivers/power/avs/smartreflex.c                         |  154 ++---
 drivers/scsi/scsi_pm.c                                  |   11 +-
 drivers/sh/clk/core.c                                   |    4 +-
 drivers/sh/pm_runtime.c                                 |    2 +-
 drivers/spi/spi.c                                       |    2 +-
 drivers/staging/android/binder.c                        |    5 +-
 drivers/tty/serial/mfd.c                                |    9 +-
 drivers/usb/core/driver.c                               |    3 +-
 drivers/usb/core/port.c                                 |    1 -
 fs/cifs/transport.c                                     |    2 +-
 fs/eventpoll.c                                          |    4 +-
 fs/nfs/inode.c                                          |    2 +-
 fs/nfs/nfs3proc.c                                       |    2 +-
 fs/nfs/nfs4proc.c                                       |    4 +-
 fs/select.c                                             |    4 +-
 include/acpi/acconfig.h                                 |    4 +-
 include/acpi/acoutput.h                                 |    8 +-
 include/acpi/acpi_bus.h                                 |   29 +-
 include/acpi/acpixf.h                                   |    3 +-
 include/acpi/processor.h                                |    5 +
 include/linux/acpi.h                                    |    3 +-
 include/linux/cpufreq.h                                 |   54 +-
 include/linux/cpuidle.h                                 |    6 +-
 include/linux/debug_locks.h                             |    4 +-
 include/linux/devfreq.h                                 |    2 +
 include/linux/device.h                                  |   21 +
 include/linux/freezer.h                                 |  171 ++++-
 include/linux/memory_hotplug.h                          |   14 +-
 include/linux/pm_runtime.h                              |    2 -
 include/linux/power/smartreflex.h                       |   10 +-
 include/linux/suspend.h                                 |    1 +
 include/trace/events/power.h                            |  173 +++++
 include/xen/acpi.h                                      |   16 +-
 kernel/exit.c                                           |    2 +-
 kernel/freezer.c                                        |   12 +
 kernel/futex.c                                          |    3 +-
 kernel/hrtimer.c                                        |    3 +-
 kernel/lockdep.c                                        |   17 +-
 kernel/power/main.c                                     |    6 +
 kernel/power/process.c                                  |   26 +-
 kernel/power/qos.c                                      |   14 +-
 kernel/power/snapshot.c                                 |    5 +-
 kernel/power/suspend.c                                  |    2 +-
 kernel/signal.c                                         |    2 +-
 mm/memory_hotplug.c                                     |   81 +--
 net/sunrpc/sched.c                                      |    2 +-
 net/unix/af_unix.c                                      |    3 +-
 280 files changed, 6878 insertions(+), 3420 deletions(-)

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
