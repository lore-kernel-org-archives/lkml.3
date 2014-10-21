Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023AbaJUENO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 00:13:14 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:33479 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbaJUENK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 00:13:10 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Alexander Graf <agraf@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Heiko Stuebner <heiko@sntech.de>, Lee Jones <lee.jones@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH v2 00/47] kernel: Add support for poweroff handler call chain
Date: Mon, 20 Oct 2014 21:12:16 -0700
Message-Id: <1413864783-3271-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020209.5445DD55.00F5,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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
being unloaded when pm_power_off is called.  If there are multiple poweroff
handlers in the system, removing a module with such a handler may
inadvertently reset the pointer to pm_power_off to NULL, leaving the system
with no means to remove power.

Introduce a system poweroff handler call chain to solve the described
problems.  This call chain is expected to be executed from the architecture
specific machine_power_off() function.  Drivers providing system poweroff
functionality are expected to register with this call chain.  By using the
priority field in the notifier block, callers can control poweroff handler
execution sequence and thus ensure that the poweroff handler with the
optimal capabilities to remove power for a given system is called first.

Patch 01/47 implements the poweroff handler API.

Patches 02/47 to 04/47 are cleanup patches to prepare for the move of
pm_power_off to a common location.

Patches 05/47 to 07/47 remove references to pm_power_off from devicetree
bindings descriptions.

Patch 08/47 moves the pm_power_off variable from architecture code to
kernel/reboot.c. 

Patches 09/47 to 34/47 convert various drivers to register with the kernel
poweroff handler instead of setting pm_power_off directly.

Patches 35/47 to 46/47 do the same for architecture code.

Patch 47/47 finally removes pm_power_off.

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
It is based on 3.18-rc1.

A note on Cc: In the initial submission I had way too many Cc:, causing the
patchset to be treated as spam by many mailers and mailing list handlers,
which of course defeated the purpose. This time around I am cutting down
the distribution list down significantly. My apologies to anyone I may have
failed to copy this time around.

Important changes since v1:
- Rebased series to v3.18-rc1.
- Use raw notifier with spinlock protection instead of atomic notifiers,
  since some poweroff handlers need to have interrupts enabled.
- Renamed API functions from _poweroff to _power_off.
- Added various Acks.
- Build tested all configurations for arm, powerpc, and mips architectures.
- Fixed two compile errors in mips patch.
- Replaced dev_err and pr_err with dev_warn and pr_warn if an error is not
  fatal.
- Provide managed resources API and use where appropriate.
- Provide and use definitions for standard priorities.
- Added patches to convert newly introduced poweroff handlers.
- Various minor changes.

Important changes since RFC:
- Move API to new file kernel/power/power_off_handler.c.
- Move pm_power_off pointer to kernel/power/power_off_handler.c. Call
  pm_power_off from do_kernel_power_off, and only call do_kernel_power_off
  from architecture code instead of calling both pm_power_off and
  do_kernel_power_off.
- Provide additional API function register_power_off_handler_simple
  to simplify conversion of architecture code.
- Provide additional API function have_kernel_power_off to check if
  a poweroff handler was installed.
- Convert all drivers and architecture code to use the new API.
- Remove pm_power_off as last patch of the series.

Cc: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Cc: Alexander Graf <agraf@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Heiko Stuebner <heiko@sntech.de>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Len Brown <len.brown@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Romain Perier <romain.perier@gmail.com>

----------------------------------------------------------------
Guenter Roeck (47):
      kernel: Add support for poweroff handler call chain
      memory: emif: Use API function to determine poweroff capability
      hibernate: Call have_kernel_power_off instead of checking pm_power_off
      m68k: Replace mach_power_off with pm_power_off
      mfd: as3722: Drop reference to pm_power_off from devicetree bindings
      gpio-poweroff: Drop reference to pm_power_off from devicetree bindings
      qnap-poweroff: Drop reference to pm_power_off from devicetree bindings
      kernel: Move pm_power_off to common code
      mfd: palmas: Register with kernel poweroff handler
      mfd: axp20x: Register with kernel poweroff handler
      mfd: retu: Register with kernel poweroff handler
      mfd: ab8500-sysctrl: Register with kernel poweroff handler
      mfd: max8907: Register with kernel poweroff handler
      mfd: tps80031: Register with kernel poweroff handler
      mfd: dm355evm_msp: Register with kernel poweroff handler
      mfd: tps6586x: Register with kernel poweroff handler
      mfd: tps65910: Register with kernel poweroff handler
      mfd: twl4030-power: Register with kernel poweroff handler
      mfd: rk808: Register poweroff handler with kernel poweroff handler
      mfd: rn5t618: Register poweroff handler with kernel poweroff handler
      ipmi: Register with kernel poweroff handler
      power/reset: restart-poweroff: Register with kernel poweroff handler
      power/reset: gpio-poweroff: Register with kernel poweroff handler
      power/reset: as3722-poweroff: Register with kernel poweroff handler
      power/reset: qnap-poweroff: Register with kernel poweroff handler
      power/reset: msm-poweroff: Register with kernel poweroff handler
      power/reset: vexpress-poweroff: Register with kernel poweroff handler
      power/reset: at91-poweroff: Register with kernel poweroff handler
      power/reset: ltc2952-poweroff: Register with kernel poweroff handler
      x86: iris: Register with kernel poweroff handler
      x86: apm: Register with kernel poweroff handler
      x86: olpc: Register xo1 poweroff handler with kernel poweroff handler
      staging: nvec: Register with kernel poweroff handler
      acpi: Register poweroff handler with kernel poweroff handler
      arm: Register with kernel poweroff handler
      arm64: psci: Register with kernel poweroff handler
      avr32: atngw100: Register with kernel poweroff handler
      ia64: Register with kernel poweroff handler
      m68k: Register with kernel poweroff handler
      mips: Register with kernel poweroff handler
      sh: Register with kernel poweroff handler
      x86: lguest: Register with kernel poweroff handler
      x86: ce4100: Register with kernel poweroff handler
      x86: intel-mid: Drop registration of dummy poweroff handlers
      x86: pmc_atom: Register poweroff handler with kernel poweroff handler
      efi: Register poweroff handler with kernel poweroff handler
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
 arch/mips/alchemy/devboards/platform.c             |  17 +-
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
 arch/x86/kernel/apm_32.c                           |  20 +-
 arch/x86/kernel/pmc_atom.c                         |  20 +-
 arch/x86/kernel/reboot.c                           |  11 +-
 arch/x86/lguest/boot.c                             |   3 +-
 arch/x86/platform/ce4100/ce4100.c                  |   3 +-
 arch/x86/platform/intel-mid/intel-mid.c            |   5 -
 arch/x86/platform/intel-mid/mfld.c                 |   5 -
 arch/x86/platform/iris/iris.c                      |  24 +-
 arch/x86/platform/olpc/olpc-xo1-pm.c               |  20 +-
 arch/x86/xen/enlighten.c                           |   3 +-
 arch/xtensa/kernel/process.c                       |   4 -
 drivers/acpi/sleep.c                               |  15 +-
 drivers/char/ipmi/ipmi_poweroff.c                  |  29 ++-
 drivers/firmware/efi/reboot.c                      |  23 +-
 drivers/memory/emif.c                              |   4 +-
 drivers/mfd/ab8500-sysctrl.c                       |  22 +-
 drivers/mfd/axp20x.c                               |  30 +--
 drivers/mfd/dm355evm_msp.c                         |  18 +-
 drivers/mfd/max8907.c                              |  24 +-
 drivers/mfd/palmas.c                               |  31 +--
 drivers/mfd/retu-mfd.c                             |  33 +--
 drivers/mfd/rk808.c                                |  30 +--
 drivers/mfd/rn5t618.c                              |  32 +--
 drivers/mfd/tps6586x.c                             |  31 ++-
 drivers/mfd/tps65910.c                             |  27 ++-
 drivers/mfd/tps80031.c                             |  30 ++-
 drivers/mfd/twl4030-power.c                        |  29 ++-
 drivers/parisc/power.c                             |   3 +-
 drivers/power/reset/as3722-poweroff.c              |  39 ++--
 drivers/power/reset/at91-poweroff.c                |  16 +-
 drivers/power/reset/gpio-poweroff.c                |  40 ++--
 drivers/power/reset/ltc2952-poweroff.c             |  27 ++-
 drivers/power/reset/msm-poweroff.c                 |  13 +-
 drivers/power/reset/qnap-poweroff.c                |  32 +--
 drivers/power/reset/restart-poweroff.c             |  33 ++-
 drivers/power/reset/vexpress-poweroff.c            |  19 +-
 drivers/staging/nvec/nvec.c                        |  24 +-
 drivers/staging/nvec/nvec.h                        |   2 +
 include/linux/i2c/twl.h                            |   1 -
 include/linux/mfd/axp20x.h                         |   1 +
 include/linux/mfd/max8907.h                        |   2 +
 include/linux/mfd/palmas.h                         |   3 +
 include/linux/mfd/rk808.h                          |   2 +
 include/linux/mfd/rn5t618.h                        |   2 +
 include/linux/mfd/tps65910.h                       |   3 +
 include/linux/mfd/tps80031.h                       |   2 +
 include/linux/pm.h                                 |  23 +-
 kernel/power/Makefile                              |   1 +
 kernel/power/hibernate.c                           |   2 +-
 kernel/power/poweroff_handler.c                    | 252 +++++++++++++++++++++
 kernel/reboot.c                                    |   4 +-
 173 files changed, 1017 insertions(+), 546 deletions(-)
 create mode 100644 kernel/power/poweroff_handler.c
