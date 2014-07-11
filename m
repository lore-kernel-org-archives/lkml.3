Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbaGKNoD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 09:44:03 -0400
Received: from www.linutronix.de ([62.245.132.108]:56023 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742AbaGKNoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 09:44:00 -0400
Message-Id: <20140711133623.530368377@linutronix.de>
User-Agent: quilt/0.63-1
Date: Fri, 11 Jul 2014 13:43:58 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [patch 00/55] timekeeping: 2038, optimizations, NMI safe accessors
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch series addresses the following points:

  1) Make the core timekeeping code ready for 2038

     This is work done by John Stultz with a few clenaups and
     modifications from me.

     This switches ktime_t to the scalar nanoseconds format.

     We can ged rid of the union now, but that wants to be done at rc1
     time with a coccinelle script.

  2) Optimize the timekeeper data structure

     Better cache layout

  3) Avoid timespec/ktime_t conversions in the core code.

     Results in smaller code for the ktime_t based interfaces.

  4) Add pure nanaoseconds based interfaces and cleanup places all
     over the tree which do silly back and forth conversions from
     timespecs to nanoseconds.

  5) Provide NMI safe accessors to clock monotonic and monotonic_raw

     Useful for instrumentation, tracing etc. as it allows correlated
     time information of kernel and user space.

The series is against tip/timers/core + 3.16-rc4 merged in. It's also
available in git at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git tglx/timers/core

Thanks,

	tglx
----

 arch/arm/Kconfig                              |    1 
 arch/arm/common/bL_switcher.c                 |   16 
 arch/hexagon/Kconfig                          |    1 
 arch/powerpc/platforms/cell/spu_base.c        |   11 
 arch/powerpc/platforms/cell/spufs/context.c   |    4 
 arch/powerpc/platforms/cell/spufs/file.c      |    4 
 arch/powerpc/platforms/cell/spufs/sched.c     |    4 
 arch/s390/Kconfig                             |    1 
 arch/tile/kernel/time.c                       |    9 
 arch/tile/kernel/vdso/vgettimeofday.c         |    7 
 arch/x86/Kconfig                              |    2 
 arch/x86/kernel/tsc.c                         |   14 
 arch/x86/kvm/x86.c                            |   50 -
 drivers/char/hangcheck-timer.c                |   10 
 drivers/connector/cn_proc.c                   |   36 -
 drivers/gpu/drm/drm_irq.c                     |   16 
 drivers/gpu/drm/i915/i915_drv.h               |    2 
 drivers/gpu/drm/i915/i915_gem.c               |   33 
 drivers/gpu/drm/i915/intel_pm.c               |   12 
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h           |    4 
 drivers/gpu/drm/vmwgfx/vmwgfx_marker.c        |   44 -
 drivers/hwmon/ibmaem.c                        |    6 
 drivers/input/evdev.c                         |    7 
 drivers/mfd/cros_ec_spi.c                     |    7 
 drivers/misc/ioc4.c                           |    7 
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c |   16 
 drivers/net/wireless/ath/ath9k/hw.c           |    7 
 fs/lockd/mon.c                                |    4 
 fs/proc/array.c                               |    7 
 fs/timerfd.c                                  |    6 
 include/linux/hrtimer.h                       |   14 
 include/linux/iio/iio.h                       |    9 
 include/linux/ktime.h                         |  228 +-----
 include/linux/mlx5/driver.h                   |    4 
 include/linux/sched.h                         |    8 
 include/linux/seqlock.h                       |   16 
 include/linux/time.h                          |   65 -
 include/linux/time64.h                        |  191 +++++
 include/linux/timekeeper_internal.h           |  108 +--
 include/linux/timekeeping.h                   |  204 ++++++
 kernel/acct.c                                 |   10 
 kernel/delayacct.c                            |   52 -
 kernel/fork.c                                 |    5 
 kernel/time/Kconfig                           |    9 
 kernel/time/clocksource.c                     |   12 
 kernel/time/hrtimer.c                         |   79 --
 kernel/time/ntp.c                             |   15 
 kernel/time/ntp_internal.h                    |    2 
 kernel/time/posix-timers.c                    |    2 
 kernel/time/tick-internal.h                   |    2 
 kernel/time/time.c                            |   64 +
 kernel/time/timekeeping.c                     |  881 +++++++++++++++-----------
 kernel/time/timekeeping.h                     |   20 
 kernel/time/timekeeping_debug.c               |    2 
 kernel/time/timekeeping_internal.h            |   17 
 kernel/trace/trace.c                          |   12 
 kernel/tsacct.c                               |   19 
 57 files changed, 1339 insertions(+), 1059 deletions(-)



