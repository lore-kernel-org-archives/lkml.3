Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796AbaGPVDv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:03:51 -0400
Received: from www.linutronix.de ([62.245.132.108]:59574 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbaGPVDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:03:49 -0400
Message-Id: <20140716205018.175419210@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 16 Jul 2014 21:03:47 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [patch V2 00/64] timekeeping: 2038, optimizations, NMI safe accessors
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes versus V1 [http://lkml.kernel.org/r/20140711133623.530368377@linutronix.de]

  - Addressed review comments and testing fallout

  - Simplified update of the ktime_t data in the timekeeper

  - Replaced some more interfaces which are availabe as timespec and
    ktime_t by the ktime_t version to get rid of the duplicated data.

  - Restructured the timekeeper again to share code with the NMI safe
    accessor, which simplifies the update to pure memcpy().

  - Removed the monotonic raw fast accessor

I also verified the size impact of the whole endavour:

x86_64:
   text	   data	    bss	    dec	    hex	filename
before:
 992378	 104211	 454784	1551373	 17ac0d	../build/kernel/built-in.o
2038 changes only:
 992312	 104211	 454784	1551307	 17abcb	../build/kernel/built-in.o
full series applied:
 991724	 104210	 454976	1550910	 17aa3e	../build/kernel/built-in.o

i386:
   text	   data	    bss	    dec	    hex	filename
before:
 910278	  56201	 372436	1338915	 146e23	../build-i386/kernel/built-in.o
2038 changes only:
 912381	  56201	 372468	1341050	 14767a	../build-i386/kernel/built-in.o
full series applied:
 911607	  56200	 372596	1340403	 1473f3	../build-i386/kernel/built-in.o

arm:
   text	   data	    bss	    dec	    hex	filename
before:
 443444	  58965	7813144	8315553	 7ee2a1	../build-arm/kernel/built-in.o
2038 changes only:
 445205	  58965	7813176	8317346	 7ee9a2	../build-arm/kernel/built-in.o
full series applied:
 444708	  58964	7813368	8317040	 7ee870	../build-arm/kernel/built-in.o

So on x8664 the new functionality comes with smaller size. I whish I
could say the same for 32bit, but there we pay the prize for making
the core timekeeping code 2038 ready. But also there, while the 2038
stuff adds ~2k, the rest (cleanup and the new monotonic accessor)
removes ~0.5k again. So features are not necessarily bundled with
bloat :)

The series is against tip/timers/core. It's also available in git at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git tglx/timers/core

Thanks,

	tglx
----

 arch/arm/Kconfig                              |    1 
 arch/arm/common/bL_switcher.c                 |   16 
 arch/arm64/kernel/vdso.c                      |   10 
 arch/hexagon/Kconfig                          |    1 
 arch/ia64/kernel/time.c                       |    4 
 arch/powerpc/kernel/time.c                    |    4 
 arch/powerpc/platforms/cell/spu_base.c        |   11 
 arch/powerpc/platforms/cell/spufs/context.c   |    4 
 arch/powerpc/platforms/cell/spufs/file.c      |    4 
 arch/powerpc/platforms/cell/spufs/sched.c     |    4 
 arch/s390/Kconfig                             |    1 
 arch/s390/kernel/time.c                       |   16 
 arch/tile/kernel/time.c                       |   13 
 arch/tile/kernel/vdso/vgettimeofday.c         |    7 
 arch/x86/Kconfig                              |    2 
 arch/x86/kernel/tsc.c                         |   21 
 arch/x86/kernel/vsyscall_gtod.c               |   23 
 arch/x86/kvm/x86.c                            |   62 -
 drivers/char/hangcheck-timer.c                |   33 
 drivers/connector/cn_proc.c                   |   36 
 drivers/gpu/drm/drm_irq.c                     |   16 
 drivers/gpu/drm/i915/i915_drv.h               |    2 
 drivers/gpu/drm/i915/i915_gem.c               |   33 
 drivers/gpu/drm/i915/intel_pm.c               |   12 
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h           |    4 
 drivers/gpu/drm/vmwgfx/vmwgfx_marker.c        |   44 -
 drivers/hwmon/ibmaem.c                        |    6 
 drivers/input/evdev.c                         |    7 
 drivers/mfd/cros_ec_spi.c                     |    8 
 drivers/misc/ioc4.c                           |    7 
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c |   16 
 drivers/net/wireless/ath/ath9k/hw.c           |    7 
 fs/lockd/mon.c                                |    4 
 fs/proc/array.c                               |    7 
 fs/timerfd.c                                  |    6 
 include/linux/clocksource.h                   |    2 
 include/linux/hrtimer.h                       |   14 
 include/linux/iio/iio.h                       |    9 
 include/linux/ktime.h                         |  228 +-----
 include/linux/mlx5/driver.h                   |    4 
 include/linux/sched.h                         |    8 
 include/linux/seqlock.h                       |   27 
 include/linux/time.h                          |   65 -
 include/linux/time64.h                        |  191 +++++
 include/linux/timekeeper_internal.h           |  144 ++-
 include/linux/timekeeping.h                   |  209 +++++
 kernel/acct.c                                 |   10 
 kernel/delayacct.c                            |   52 -
 kernel/fork.c                                 |    5 
 kernel/time/Kconfig                           |    9 
 kernel/time/clocksource.c                     |   12 
 kernel/time/hrtimer.c                         |   80 --
 kernel/time/ntp.c                             |   15 
 kernel/time/ntp_internal.h                    |    2 
 kernel/time/posix-timers.c                    |    2 
 kernel/time/tick-internal.h                   |    2 
 kernel/time/time.c                            |   64 +
 kernel/time/timekeeping.c                     |  957 ++++++++++++++------------
 kernel/time/timekeeping.h                     |   20 
 kernel/time/timekeeping_debug.c               |    2 
 kernel/time/timekeeping_internal.h            |   17 
 kernel/trace/trace.c                          |   11 
 kernel/tsacct.c                               |   19 
 63 files changed, 1412 insertions(+), 1220 deletions(-)



