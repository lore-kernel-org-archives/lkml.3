Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830AbaKJBnP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 20:43:15 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:38832 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbaKJBnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 20:43:13 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Alexander Graf <agraf@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Heiko Stuebner <heiko@sntech.de>, Lee Jones <lee.jones@linaro.org>,
        Len Brown <len.brown@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH v6 00/48] kernel: Add support for power-off handler call chain
Date: Sun,  9 Nov 2014 17:42:17 -0800
Message-Id: <1415583785-6980-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020202.54601830.0129,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 1
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Various drivers implement architecture and/or device specific means to
remove power from the system.  For the most part, those drivers set the
global variable pm_power_off to point to a function within the driver.

This mechanism has a number of drawbacks.  Typically only one means
to remove power is supported (at least if pm_power_off is used).
At least in theory there can be multiple means to remove power, some of
which may be less desirable.  For example, one mechanism might power off the
entire system through an I/O port or gpio pin, while another might power off
a board by disabling its power controller. Other mechanisms may really just
execute a restart sequence or drop into the ROM monitor, or put the CPU into
sleep mode.  Using pm_power_off can also be racy if the function pointer is
set from a driver built as module, as the driver may be in the process of
being unloaded when pm_power_off is called.  If there are multiple power-off
handlers in the system, removing a module with such a handler may
inadvertently reset the pointer to pm_power_off to NULL, leaving the system
with no means to remove power.

Introduce a system power-off handler call chain to solve the described
problems.  This call chain is expected to be executed from the architecture
specific machine_power_off() function.  Drivers providing system power-off
functionality are expected to register with this call chain.  By using the
priority field in the notifier block, callers can control power-off handler
execution sequence and thus ensure that the power-off handler with the
optimal capabilities to remove power for a given system is called first.
A call chain instead of a single call to the highest priority handler is
used to provide fallback: If multiple power-off handlers are installed,
all handlers will be called until one actually succeeds to power off the
system.

Patch 01/48 implements the power-off handler API.

Patches 02/48 to 04/48 are cleanup patches to prepare for the move of
pm_power_off to a common location.

Patches 05/48 to 07/48 remove references to pm_power_off from devicetree
bindings descriptions.

Patch 08/48 moves the pm_power_off variable from architecture code to
kernel/reboot.c. 

Patches 09/48 to 34/48 convert various drivers to register with the kernel
power-off handler instead of setting pm_power_off directly.

Patches 35/48 to 47/48 do the same for architecture code.

Patch 48/48 finally removes pm_power_off.

For the most part, the individual patches include explanations why specific
priorities were chosen, at least if the selected priority is not the default
priority. Subsystem and architecture maintainers are encouraged to have a look
at the selected priorities and suggest improvements.

I ran the final code through my normal build and qemu tests. Results are
available at http://server.roeck-us.net:8010/builders in the 'poweroff-handler'
column. I also built all available configurations for arm, mips, powerpc,
m68k, and sh architectures.

The series is available in branch poweroff-handler of my repository at
git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git.
It is based on 3.18-rc3 plus the power-off tracking branch from
git://git.kernel.org/pub/scm/linux/kernel/git/mpe/linux.git (to merge
powerpc related power-off changes).

A note on Cc: In the initial submission I had way too many Cc:, causing the
patchset to be treated as spam by many mailers and mailing list handlers,
which of course defeated the purpose. Starting with v3, the distribution
list has been cut down significantly. Copied mailing lists and individuals are
for the most part generated from the output of get_maintainer.pl for each
individual patch.  My apologies to anyone I may have failed to copy; if you
believe that some additional individuals or mailing lists should be copied
on the entire series or on individual patches, please let me know.

Merge plan is to send the entire series directly to Linus during the next commit
window, except for the last patch. The last patch would then be part of another
pull request after -rc1, which would include any changes necessary due to newly
merged power-off handling code.

v6:
- Replaced priority defines with enum.
v5:
- Rebased series to v3.18-rc3
- Merge remote-tracking branch 'power/topic/pm-power-off'
  from git://git.kernel.org/pub/scm/linux/kernel/git/mpe/linux.git
  and implement powerpc conversion (patch 41/48).
v4:
- Do not use notifiers but internal functions and data structures to manage
  the list of power-off handlers. Drop unused parameters from callbacks, and
  make the power-off function type void.
  Code to manage and walk the list of callbacks was derived from notifier.c.
  Note that only patch 01/47 was sent for review of this version.
v3:
- Rebased series to v3.18-rc2.
- Do not hold any locks while executing the power-off call chain.
  This ensures that power-off handlers are executed in the state
  selected by the machine_power_off function for a given architecture,
  ie without changing the current semantics of power-off callbacks and
  machine_power_off functions.
  Power-off handler registration and de-registration is handled in atomic
  context with interrupts disabled to ensure that those functions are not
  interrupted by code which powers off the system.
- Use [xxx_]power_off[_xxx] instead of [xxx_]poweroff[_xxx] for newly
  introduced function and variable names.
- Use power-off instead of poweroff in descriptive text and comments.
- Replace POWEROFF_PRIORITY_xxx with POWER_OFF_PRIORITY_xxx
- Use ACPI: instead of acpi: for messages in acpi code.
v2:
- Rebased series to v3.18-rc1.
- Use raw notifier with spinlock protection instead of atomic notifiers,
  since some power-off handlers need to have interrupts enabled.
- Renamed API functions from _poweroff to _power_off.
- Added various Acks.
- Build tested all configurations for arm, powerpc, and mips architectures.
- Fixed two compile errors in mips patch.
- Replaced dev_err and pr_err with dev_warn and pr_warn if an error is not
  fatal.
- Provide managed resources API and use where appropriate.
- Provide and use definitions for standard priorities.
- Added patches to convert newly introduced power-off handlers.
- Various minor changes.
v1 (from RFC):
- Move API to new file kernel/power/power_off_handler.c.
- Move pm_power_off pointer to kernel/power/power_off_handler.c. Call
  pm_power_off from do_kernel_power_off, and only call do_kernel_power_off
  from architecture code instead of calling both pm_power_off and
  do_kernel_power_off.
- Provide additional API function register_power_off_handler_simple
  to simplify conversion of architecture code.
- Provide additional API function have_kernel_power_off to check if
  a power-off handler was installed.
- Convert all drivers and architecture code to use the new API.
- Remove pm_power_off as last patch of the series.

Cc: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Cc: Alexander Graf <agraf@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Heiko Stuebner <heiko@sntech.de>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Len Brown <len.brown@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Romain Perier <romain.perier@gmail.com>

----------------------------------------------------------------
Guenter Roeck (48):
      kernel: Add support for power-off handler call chain
      memory: emif: Use API function to determine power-off capability
      hibernate: Call have_kernel_power_off instead of checking pm_power_off
      m68k: Replace mach_power_off with pm_power_off
      mfd: as3722: Drop reference to pm_power_off from devicetree bindings
      gpio-poweroff: Drop reference to pm_power_off from devicetree bindings
      qnap-poweroff: Drop reference to pm_power_off from devicetree bindings
      kernel: Move pm_power_off to common code
      mfd: palmas: Register with kernel power-off handler
      mfd: axp20x: Register with kernel power-off handler
      mfd: retu: Register with kernel power-off handler
      mfd: ab8500-sysctrl: Register with kernel power-off handler
      mfd: max8907: Register with kernel power-off handler
      mfd: tps80031: Register with kernel power-off handler
      mfd: dm355evm_msp: Register with kernel power-off handler
      mfd: tps6586x: Register with kernel power-off handler
      mfd: tps65910: Register with kernel power-off handler
      mfd: twl4030-power: Register with kernel power-off handler
      mfd: rk808: Register power-off handler with kernel power-off handler
      mfd: rn5t618: Register power-off handler with kernel power-off handler
      ipmi: Register with kernel power-off handler
      power/reset: restart-poweroff: Register with kernel power-off handler
      power/reset: gpio-poweroff: Register with kernel power-off handler
      power/reset: as3722-poweroff: Register with kernel power-off handler
      power/reset: qnap-poweroff: Register with kernel power-off handler
      power/reset: msm-poweroff: Register with kernel power-off handler
      power/reset: vexpress-poweroff: Register with kernel power-off handler
      power/reset: at91-poweroff: Register with kernel power-off handler
      power/reset: ltc2952-poweroff: Register with kernel power-off handler
      x86: iris: Register with kernel power-off handler
      x86: apm: Register with kernel power-off handler
      x86: olpc: Register xo1 power-off handler with kernel power-off handler
      staging: nvec: Register with kernel power-off handler
      acpi: Register power-off handler with kernel power-off handler
      arm: Register with kernel power-off handler
      arm64: psci: Register with kernel power-off handler
      avr32: atngw100: Register with kernel power-off handler
      ia64: Register with kernel power-off handler
      m68k: Register with kernel power-off handler
      mips: Register with kernel power-off handler
      powerpc: Register with kernel power-off handler
      sh: Register with kernel power-off handler
      x86: lguest: Register with kernel power-off handler
      x86: ce4100: Register with kernel power-off handler
      x86: intel-mid: Drop registration of dummy power-off handlers
      x86: pmc_atom: Register power-off handler with kernel power-off handler
      efi: Register power-off handler with kernel power-off handler
      kernel: Remove pm_power_off

 .../devicetree/bindings/gpio/gpio-poweroff.txt     |  10 +-
 Documentation/devicetree/bindings/mfd/as3722.txt   |   3 +-
 .../bindings/power_supply/qnap-poweroff.txt        |   3 +-
 arch/alpha/kernel/process.c                        |   9 +-
 arch/arc/kernel/reset.c                            |   5 +-
 arch/arm/kernel/process.c                          |   5 +-
 arch/arm/kernel/psci.c                             |   3 +-
 arch/arm/mach-at91/board-gsia18s.c                 |   3 +-
 arch/arm/mach-bcm/board_bcm2835.c                  |   3 +-
 arch/arm/mach-cns3xxx/cns3420vb.c                  |   3 +-
 arch/arm/mach-cns3xxx/core.c                       |   3 +-
 arch/arm/mach-highbank/highbank.c                  |   3 +-
 arch/arm/mach-imx/mach-mx31moboard.c               |   3 +-
 arch/arm/mach-iop32x/em7210.c                      |   3 +-
 arch/arm/mach-iop32x/glantank.c                    |   3 +-
 arch/arm/mach-iop32x/iq31244.c                     |   3 +-
 arch/arm/mach-iop32x/n2100.c                       |   3 +-
 arch/arm/mach-ixp4xx/dsmg600-setup.c               |   3 +-
 arch/arm/mach-ixp4xx/nas100d-setup.c               |   3 +-
 arch/arm/mach-ixp4xx/nslu2-setup.c                 |   3 +-
 arch/arm/mach-omap2/board-omap3touchbook.c         |   3 +-
 arch/arm/mach-orion5x/board-mss2.c                 |   3 +-
 arch/arm/mach-orion5x/dns323-setup.c               |   9 +-
 arch/arm/mach-orion5x/kurobox_pro-setup.c          |   3 +-
 arch/arm/mach-orion5x/ls-chl-setup.c               |   3 +-
 arch/arm/mach-orion5x/ls_hgl-setup.c               |   3 +-
 arch/arm/mach-orion5x/lsmini-setup.c               |   3 +-
 arch/arm/mach-orion5x/mv2120-setup.c               |   3 +-
 arch/arm/mach-orion5x/net2big-setup.c              |   3 +-
 arch/arm/mach-orion5x/terastation_pro2-setup.c     |   3 +-
 arch/arm/mach-orion5x/ts209-setup.c                |   3 +-
 arch/arm/mach-orion5x/ts409-setup.c                |   3 +-
 arch/arm/mach-pxa/corgi.c                          |   3 +-
 arch/arm/mach-pxa/mioa701.c                        |   3 +-
 arch/arm/mach-pxa/poodle.c                         |   3 +-
 arch/arm/mach-pxa/spitz.c                          |   3 +-
 arch/arm/mach-pxa/tosa.c                           |   3 +-
 arch/arm/mach-pxa/viper.c                          |   3 +-
 arch/arm/mach-pxa/z2.c                             |   7 +-
 arch/arm/mach-pxa/zeus.c                           |   7 +-
 arch/arm/mach-s3c24xx/mach-gta02.c                 |   3 +-
 arch/arm/mach-s3c24xx/mach-jive.c                  |   3 +-
 arch/arm/mach-s3c24xx/mach-vr1000.c                |   3 +-
 arch/arm/mach-s3c64xx/mach-smartq.c                |   3 +-
 arch/arm/mach-sa1100/generic.c                     |   3 +-
 arch/arm/mach-sa1100/simpad.c                      |   3 +-
 arch/arm/mach-u300/regulator.c                     |   3 +-
 arch/arm/mach-vt8500/vt8500.c                      |   3 +-
 arch/arm/xen/enlighten.c                           |   3 +-
 arch/arm64/kernel/process.c                        |   5 +-
 arch/arm64/kernel/psci.c                           |   3 +-
 arch/avr32/boards/atngw100/mrmt.c                  |   3 +-
 arch/avr32/kernel/process.c                        |   6 +-
 arch/blackfin/kernel/process.c                     |   3 -
 arch/blackfin/kernel/reboot.c                      |   2 +
 arch/c6x/kernel/process.c                          |   9 +-
 arch/cris/kernel/process.c                         |   4 +-
 arch/frv/kernel/process.c                          |   5 +-
 arch/hexagon/kernel/reset.c                        |   5 +-
 arch/ia64/kernel/process.c                         |   5 +-
 arch/ia64/sn/kernel/setup.c                        |   5 +-
 arch/m32r/kernel/process.c                         |   8 +-
 arch/m68k/emu/natfeat.c                            |   4 +-
 arch/m68k/include/asm/machdep.h                    |   1 -
 arch/m68k/kernel/process.c                         |   7 +-
 arch/m68k/kernel/setup_mm.c                        |   1 -
 arch/m68k/kernel/setup_no.c                        |   1 -
 arch/m68k/mac/config.c                             |   4 +-
 arch/metag/kernel/process.c                        |   6 +-
 arch/microblaze/kernel/process.c                   |   3 -
 arch/microblaze/kernel/reset.c                     |   1 +
 arch/mips/alchemy/board-gpr.c                      |   3 +-
 arch/mips/alchemy/board-mtx1.c                     |   3 +-
 arch/mips/alchemy/board-xxs1500.c                  |   3 +-
 arch/mips/alchemy/devboards/platform.c             |  14 +-
 arch/mips/ar7/setup.c                              |   3 +-
 arch/mips/ath79/setup.c                            |   3 +-
 arch/mips/bcm47xx/setup.c                          |   3 +-
 arch/mips/bcm63xx/setup.c                          |   3 +-
 arch/mips/cobalt/setup.c                           |   3 +-
 arch/mips/dec/setup.c                              |   3 +-
 arch/mips/emma/markeins/setup.c                    |   3 +-
 arch/mips/jz4740/reset.c                           |   3 +-
 arch/mips/kernel/reset.c                           |   6 +-
 arch/mips/lantiq/falcon/reset.c                    |   3 +-
 arch/mips/lantiq/xway/reset.c                      |   3 +-
 arch/mips/lasat/reset.c                            |   3 +-
 arch/mips/loongson/common/reset.c                  |   3 +-
 arch/mips/loongson1/common/reset.c                 |   3 +-
 arch/mips/mti-malta/malta-reset.c                  |   3 +-
 arch/mips/mti-sead3/sead3-reset.c                  |   3 +-
 arch/mips/netlogic/xlp/setup.c                     |   3 +-
 arch/mips/netlogic/xlr/setup.c                     |   3 +-
 arch/mips/pmcs-msp71xx/msp_setup.c                 |   3 +-
 arch/mips/pnx833x/common/setup.c                   |   3 +-
 arch/mips/ralink/reset.c                           |   3 +-
 arch/mips/rb532/setup.c                            |   3 +-
 arch/mips/sgi-ip22/ip22-reset.c                    |   3 +-
 arch/mips/sgi-ip27/ip27-reset.c                    |   3 +-
 arch/mips/sgi-ip32/ip32-reset.c                    |   3 +-
 arch/mips/sibyte/common/cfe.c                      |   3 +-
 arch/mips/sni/setup.c                              |   3 +-
 arch/mips/txx9/generic/setup.c                     |   3 +-
 arch/mips/vr41xx/common/pmu.c                      |   3 +-
 arch/mn10300/kernel/process.c                      |   8 +-
 arch/openrisc/kernel/process.c                     |   8 +-
 arch/parisc/kernel/process.c                       |   8 +-
 arch/powerpc/kernel/setup-common.c                 |   6 +-
 arch/powerpc/platforms/44x/ppc476.c                |   3 +-
 arch/powerpc/platforms/52xx/efika.c                |   3 +-
 arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c     |  30 +-
 arch/powerpc/platforms/85xx/corenet_generic.c      |   3 +-
 arch/powerpc/platforms/85xx/sgy_cts1000.c          |  16 +-
 arch/powerpc/platforms/cell/celleb_setup.c         |   6 +-
 arch/powerpc/platforms/cell/qpace_setup.c          |   3 +-
 arch/powerpc/platforms/cell/setup.c                |   3 +-
 arch/powerpc/platforms/chrp/setup.c                |   3 +-
 arch/powerpc/platforms/embedded6xx/gamecube.c      |   3 +-
 arch/powerpc/platforms/embedded6xx/linkstation.c   |   3 +-
 arch/powerpc/platforms/embedded6xx/wii.c           |   3 +-
 arch/powerpc/platforms/maple/setup.c               |   6 +-
 arch/powerpc/platforms/powermac/setup.c            |   3 +-
 arch/powerpc/platforms/powernv/setup.c             |   6 +-
 arch/powerpc/platforms/ps3/setup.c                 |   3 +-
 arch/powerpc/platforms/pseries/setup.c             |   3 +-
 arch/powerpc/sysdev/fsl_soc.c                      |   6 +-
 arch/powerpc/xmon/xmon.c                           |   3 +-
 arch/s390/kernel/setup.c                           |   8 +-
 arch/score/kernel/process.c                        |   8 +-
 arch/sh/boards/board-sh7785lcr.c                   |   3 +-
 arch/sh/boards/board-urquell.c                     |   3 +-
 arch/sh/boards/mach-highlander/setup.c             |   3 +-
 arch/sh/boards/mach-landisk/setup.c                |   3 +-
 arch/sh/boards/mach-r2d/setup.c                    |   3 +-
 arch/sh/boards/mach-sdk7786/setup.c                |   3 +-
 arch/sh/kernel/reboot.c                            |   6 +-
 arch/sparc/kernel/process_32.c                     |  10 +-
 arch/sparc/kernel/reboot.c                         |   8 +-
 arch/tile/kernel/reboot.c                          |   7 +-
 arch/um/kernel/reboot.c                            |   2 -
 arch/unicore32/kernel/process.c                    |   9 +-
 arch/x86/kernel/apm_32.c                           |  17 +-
 arch/x86/kernel/pmc_atom.c                         |  16 +-
 arch/x86/kernel/reboot.c                           |  11 +-
 arch/x86/lguest/boot.c                             |   3 +-
 arch/x86/platform/ce4100/ce4100.c                  |   3 +-
 arch/x86/platform/intel-mid/intel-mid.c            |   5 -
 arch/x86/platform/intel-mid/mfld.c                 |   5 -
 arch/x86/platform/iris/iris.c                      |  20 +-
 arch/x86/platform/olpc/olpc-xo1-pm.c               |  16 +-
 arch/x86/xen/enlighten.c                           |   3 +-
 arch/xtensa/kernel/process.c                       |   4 -
 drivers/acpi/sleep.c                               |  11 +-
 drivers/char/ipmi/ipmi_poweroff.c                  |  25 +-
 drivers/firmware/efi/reboot.c                      |  19 +-
 drivers/memory/emif.c                              |   4 +-
 drivers/mfd/ab8500-sysctrl.c                       |  17 +-
 drivers/mfd/axp20x.c                               |  24 +-
 drivers/mfd/dm355evm_msp.c                         |  14 +-
 drivers/mfd/max8907.c                              |  21 +-
 drivers/mfd/palmas.c                               |  28 +-
 drivers/mfd/retu-mfd.c                             |  29 +-
 drivers/mfd/rk808.c                                |  26 +-
 drivers/mfd/rn5t618.c                              |  28 +-
 drivers/mfd/tps6586x.c                             |  25 +-
 drivers/mfd/tps65910.c                             |  21 +-
 drivers/mfd/tps80031.c                             |  27 +-
 drivers/mfd/twl4030-power.c                        |  25 +-
 drivers/parisc/power.c                             |   3 +-
 drivers/power/reset/as3722-poweroff.c              |  35 +--
 drivers/power/reset/at91-poweroff.c                |  12 +-
 drivers/power/reset/gpio-poweroff.c                |  36 +--
 drivers/power/reset/ltc2952-poweroff.c             |  24 +-
 drivers/power/reset/msm-poweroff.c                 |  24 +-
 drivers/power/reset/qnap-poweroff.c                |  28 +-
 drivers/power/reset/restart-poweroff.c             |  29 +-
 drivers/power/reset/vexpress-poweroff.c            |  15 +-
 drivers/staging/nvec/nvec.c                        |  21 +-
 drivers/staging/nvec/nvec.h                        |   2 +
 include/linux/i2c/twl.h                            |   1 -
 include/linux/mfd/axp20x.h                         |   1 +
 include/linux/mfd/max8907.h                        |   1 +
 include/linux/mfd/palmas.h                         |   3 +
 include/linux/mfd/rk808.h                          |   2 +
 include/linux/mfd/rn5t618.h                        |   2 +
 include/linux/mfd/tps65910.h                       |   4 +
 include/linux/mfd/tps80031.h                       |   2 +
 include/linux/pm.h                                 |  28 +-
 kernel/power/Makefile                              |   1 +
 kernel/power/hibernate.c                           |   2 +-
 kernel/power/power_off_handler.c                   | 310 +++++++++++++++++++++
 kernel/reboot.c                                    |   4 +-
 192 files changed, 1054 insertions(+), 580 deletions(-)
 create mode 100644 kernel/power/power_off_handler.c
