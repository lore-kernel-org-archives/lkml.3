Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391AbaJ0FpW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 01:45:22 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:59023 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbaJ0FpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 01:45:20 -0400
From: "pang.xunlei" <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        "pang.xunlei" <pang.xunlei@linaro.org>
Subject: [PATCH RFC 00/12] time: Convert do_settimeofday() to use timespec64
Date: Mon, 27 Oct 2014 13:44:46 +0800
Message-Id: <1414388686-1101-1-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel uses 32-bit signed value(time_t) for seconds since 1970-01-01:00:00:00, so it
will overflow at 2038-01-19 03:14:08 on 32-bit systems. We call this "2038 safety" issue.

This series doesn't involve any functional change, and mainly converts do_settimeofday()
to use timespec64. During the conversion, it needs to convert mktime(), rtc_tm_to_time(),
rtc_time_to_tm() and other functions similarly due to dependencies.

The main processing logic here is:
mktime:
    *Rename mktime() to mktime_unsafe()
    *Add mktime() safe version(using time64_t)

rtc_tm_to_time:
    *Rename rtc_tm_to_time() to rtc_tm_to_time_unsafe()
    *Add rtc_tm_to_time() safe version(using time64_t)
    *Convert rtc_tm_to_time_unsafe() to rtc_tm_to_time() in rtc_hctosys()

rtc_time_to_tm:
    *Rename rtc_time_to_tm() to rtc_time_to_tm_unsafe()
    *Add rtc_time_to_tm() safe version(using time64_t)
    *Convert rtc_time_to_tm_unsafe() to rtc_time_to_tm() in alarm_set_rtc()

do_settimeofday:
    *Convert do_settimeofday() to use timespec64
    *Convert xen_read_wallclock() to use timespec64
    *Convert pvclock_read_wallclock() to use timespec64

Convert xxx_unsafe() to xxx():
    *Convert mktime_unsafe() to mktime() one by one
    *Convert rtc_tm_to_time_unsafe() to rtc_tm_to_time() one by one
    *Convert rtc_time_to_tm_unsafe() to rtc_time_to_tm() one by one
    *Try the best to eliminate TODOs brought by these patches

So the rest of this patch series does tons of work on these conversions.

NOTE: This series actually contains 157 patches in total, but just sent out a small subset
here for feedback to make sure there are no objections with my approach. Please access the
link below to see all the patches:
https://git.linaro.org/people/pang.xunlei/linuxstable.git

pang.xunlei (12):
  time: Rename mktime() to mktime_unsafe()
  time: Add mktime() safe version(using time64_t)
  time: Rename rtc_tm_to_time() to rtc_tm_to_time_unsafe()
  time: Add rtc_tm_to_time() safe version(using time64_t)
  time: Convert rtc_tm_to_time_unsafe() to rtc_tm_to_time() in
    rtc_hctosys()
  time: Fix build warnings for time64_t to __kernel_time_t warning on
    64-bit systems.
  time: Rename rtc_time_to_tm() to rtc_time_to_tm_unsafe()
  time: Add rtc_time_to_tm() safe version(using time64_t)
  time: Convert rtc_time_to_tm_unsafe() to rtc_time_to_tm() in
    alarm_set_rtc()
  time: Convert do_settimeofday() to use timespec64
  time: Convert xen_read_wallclock() to use timespec64
  time: Convert pvclock_read_wallclock() to use timespec64

 arch/avr32/kernel/time.c                     |    2 +-
 arch/frv/kernel/time.c                       |    2 +-
 arch/ia64/kernel/efi.c                       |    2 +-
 arch/m32r/kernel/time.c                      |    2 +-
 arch/m68k/kernel/time.c                      |    2 +-
 arch/m68k/mac/misc.c                         |    2 +-
 arch/mips/dec/time.c                         |    2 +-
 arch/mips/include/asm/mc146818-time.h        |    2 +-
 arch/mips/sibyte/swarm/rtc_m41t81.c          |    4 +--
 arch/mips/sibyte/swarm/rtc_xicor1241.c       |    4 +--
 arch/mips/sibyte/swarm/setup.c               |    2 +-
 arch/mn10300/kernel/rtc.c                    |    4 +--
 arch/parisc/include/asm/rtc.h                |    2 +-
 arch/powerpc/kernel/rtas-proc.c              |    2 +-
 arch/powerpc/kernel/rtas-rtc.c               |    2 +-
 arch/powerpc/kernel/time.c                   |    2 +-
 arch/powerpc/platforms/8xx/m8xx_setup.c      |    2 +-
 arch/powerpc/platforms/cell/beat.c           |    2 +-
 arch/powerpc/platforms/maple/time.c          |    2 +-
 arch/powerpc/platforms/pasemi/time.c         |    2 +-
 arch/powerpc/platforms/powermac/time.c       |    2 +-
 arch/powerpc/platforms/powernv/opal-rtc.c    |    2 +-
 arch/sh/boards/mach-sh03/rtc.c               |    2 +-
 arch/sh/kernel/time.c                        |    6 ++--
 arch/x86/include/asm/pvclock.h               |    2 +-
 arch/x86/kernel/kvmclock.c                   |    7 ++--
 arch/x86/kernel/pvclock.c                    |    8 ++---
 arch/x86/kernel/rtc.c                        |    4 +--
 arch/x86/platform/efi/efi.c                  |    2 +-
 arch/x86/platform/intel-mid/intel_mid_vrtc.c |    4 +--
 arch/x86/xen/time.c                          |   17 ++++++---
 drivers/hv/hv_util.c                         |    4 +--
 drivers/power/charger-manager.c              |   10 +++---
 drivers/rtc/class.c                          |    4 +--
 drivers/rtc/hctosys.c                        |    6 ++--
 drivers/rtc/interface.c                      |   14 ++++----
 drivers/rtc/rtc-88pm80x.c                    |   18 +++++-----
 drivers/rtc/rtc-88pm860x.c                   |   18 +++++-----
 drivers/rtc/rtc-ab3100.c                     |    6 ++--
 drivers/rtc/rtc-ab8500.c                     |   14 ++++----
 drivers/rtc/rtc-at32ap700x.c                 |    8 ++---
 drivers/rtc/rtc-at91sam9.c                   |    8 ++---
 drivers/rtc/rtc-au1xxx.c                     |    4 +--
 drivers/rtc/rtc-bfin.c                       |    6 ++--
 drivers/rtc/rtc-coh901331.c                  |    6 ++--
 drivers/rtc/rtc-da9052.c                     |    4 +--
 drivers/rtc/rtc-da9063.c                     |    4 +--
 drivers/rtc/rtc-davinci.c                    |    6 ++--
 drivers/rtc/rtc-dev.c                        |    6 ++--
 drivers/rtc/rtc-dm355evm.c                   |    4 +--
 drivers/rtc/rtc-ds1305.c                     |    4 +--
 drivers/rtc/rtc-ds1374.c                     |   10 +++---
 drivers/rtc/rtc-ds1511.c                     |    2 +-
 drivers/rtc/rtc-ds1553.c                     |    2 +-
 drivers/rtc/rtc-ds1672.c                     |    2 +-
 drivers/rtc/rtc-ds2404.c                     |    2 +-
 drivers/rtc/rtc-ep93xx.c                     |    2 +-
 drivers/rtc/rtc-imxdi.c                      |    6 ++--
 drivers/rtc/rtc-isl1208.c                    |    4 +--
 drivers/rtc/rtc-jz4740.c                     |    6 ++--
 drivers/rtc/rtc-lib.c                        |   37 ++++++++++++++-----
 drivers/rtc/rtc-lpc32xx.c                    |    6 ++--
 drivers/rtc/rtc-ls1x.c                       |    4 +--
 drivers/rtc/rtc-mc13xxx.c                    |    6 ++--
 drivers/rtc/rtc-mpc5121.c                    |    4 +--
 drivers/rtc/rtc-mv.c                         |    2 +-
 drivers/rtc/rtc-mxc.c                        |   12 +++----
 drivers/rtc/rtc-pcap.c                       |    6 ++--
 drivers/rtc/rtc-pl030.c                      |    8 ++---
 drivers/rtc/rtc-pl031.c                      |   12 +++----
 drivers/rtc/rtc-pm8xxx.c                     |    8 ++---
 drivers/rtc/rtc-ps3.c                        |    4 +--
 drivers/rtc/rtc-puv3.c                       |    8 ++---
 drivers/rtc/rtc-rs5c348.c                    |    4 +--
 drivers/rtc/rtc-rx8025.c                     |    2 +-
 drivers/rtc/rtc-sa1100.c                     |    6 ++--
 drivers/rtc/rtc-sh.c                         |    2 +-
 drivers/rtc/rtc-sirfsoc.c                    |   10 +++---
 drivers/rtc/rtc-snvs.c                       |    8 ++---
 drivers/rtc/rtc-starfire.c                   |    2 +-
 drivers/rtc/rtc-stk17ta8.c                   |    2 +-
 drivers/rtc/rtc-stmp3xxx.c                   |    6 ++--
 drivers/rtc/rtc-sun4v.c                      |    4 +--
 drivers/rtc/rtc-sun6i.c                      |    6 ++--
 drivers/rtc/rtc-sunxi.c                      |    4 +--
 drivers/rtc/rtc-sysfs.c                      |   10 +++---
 drivers/rtc/rtc-tegra.c                      |    8 ++---
 drivers/rtc/rtc-test.c                       |    2 +-
 drivers/rtc/rtc-tps6586x.c                   |   10 +++---
 drivers/rtc/rtc-tx4939.c                     |    6 ++--
 drivers/rtc/rtc-vr41xx.c                     |   12 +++----
 drivers/rtc/rtc-wm831x.c                     |    8 ++---
 drivers/rtc/rtc-xgene.c                      |    6 ++--
 drivers/rtc/systohc.c                        |    4 +--
 drivers/staging/android/alarm-dev.c          |   10 ++++--
 include/linux/rtc.h                          |    6 ++--
 include/linux/time.h                         |   10 ++++--
 include/linux/time64.h                       |    6 ++--
 include/linux/timekeeping.h                  |    2 +-
 kernel/compat.c                              |    4 ++-
 kernel/power/suspend_test.c                  |    4 +--
 kernel/time/time.c                           |   50 ++++++++++++++++++--------
 kernel/time/timekeeping.c                    |   15 ++++----
 103 files changed, 350 insertions(+), 288 deletions(-)

-- 
1.7.9.5

