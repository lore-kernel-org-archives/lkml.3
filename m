Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001Ab3I3RmA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 13:42:00 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:62478 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755632Ab3I3Rl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 13:41:58 -0400
Message-ID: <5249B7E2.5060201@linaro.org>
Date: Mon, 30 Sep 2013 19:41:54 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@kernel.org>, John Stultz <john.stultz@linaro.org>,
        mlichvar@redhat.com, prarit@redhat.com,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        zoran markovic <zoran.markovic@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: [GIT PULL]: clocksource: new material for 3.13
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Thomas,

this pull request is based on 3.12-rc3 with the following content:

  - Miroslav improved the RTC update by increasing the interval 
acceptable for an update in the sync_cmos_clock workqueue callback

  - Prarit added a missing function declaration to fix a compilation 
issue on x86. Please *note*, this patch is coming from a pull from 
John's tree, it would make sense to cherry-pick this fix into timers/urgent

  - Soren added FEAT_PERCPU to a clock device when it is local per cpu. 
This feature prevents the clock framework to choose a per cpu timer as a 
broadcast timer. This problem arised when the ARM global timer is used 
which is the case now on Xillinx.

  - Stephen extended the generic sched_clock code to support 64bit 
counters and removes the setup_sched_clock deprecation, as that causes 
lots of warnings since there's still users in the arch/arm tree.

  - Will and Sudeep implemented the event stream for architected timer. 
The event streams can be used to impose a timeout on a wfe, to safeguard 
against any programming error in case an expected event is not generated 
or even to implement wfe-based timeouts for userspace locking 
implementations.

  - Zoran prevents to enter suspend mode if there are pending RTC timers 
to be handled, avoiding these ones to be delayed as well as the 
subsequent possible time critical code tied with them.

Thanks
   -- Daniel

The following changes since commit 15c03dd4859ab16f9212238f29dd315654aa94f6:

   Linux 3.12-rc3 (2013-09-29 15:02:38 -0700)

are available in the git repository at:

   git://git.linaro.org/people/dlezcano/linux.git clockevents/3.13

for you to fetch changes up to 7267c876a4784f9b9a75d057bc487b6a5e01ced9:

   Merge branch 'clockevents/3-13.arch-timer' into clockevents/3.13 
(2013-09-30 16:37:56 +0200)

----------------------------------------------------------------

Daniel Lezcano (3):
       Merge branch 'fordlezcano/3.13/sched-clock64-conversion' of 
git://git.linaro.org/people/jstultz/linux into clockevents/3.13
       Merge branch 'clockevents/3-13.global-timer' into clockevents/3.13
       Merge branch 'clockevents/3-13.arch-timer' into clockevents/3.13

John Stultz (3):
       Merge branch 'fortglx/3.12/sched-clock64-base' into fortglx/3.13/time
       Merge branch 'fortglx/3.12/time' into fortglx/3.13/time
       Merge remote-tracking branch 'tip/timers/core' into 
fordlezcano/3.13/sched-clock64-conversion

Miroslav Lichvar (1):
       ntp: Make periodic RTC update more reliable

Prarit Bhargava (1):
       clocksource: Fix !CONFIG_CLOCKSOURCE_WATCHDOG compile

Soren Brinkmann (4):
       clockchips: Add FEAT_PERCPU clockevent flag
       clocksource/arm_global_timer: Set FEAT_PERCPU flag
       tick: broadcast: Deny per-cpu clockevents from being broadcast 
sources
       arm: zynq: Enable arm_global_timer

Stephen Boyd (14):
       clocksource: Extract max nsec calculation into separate function
       sched_clock: Use seqcount instead of rolling our own
       sched_clock: Use an hrtimer instead of timer
       sched_clock: Add support for >32 bit sched_clock
       clocksource: bcm2835: Switch to sched_clock_register()
       clocksource: dbx500-prcmu: Switch to sched_clock_register()
       clocksource: dw_apb_timer_of: Switch to sched_clock_register()
       clocksource: mxs_timer: Switch to sched_clock_register()
       clocksource: nomadik: Switch to sched_clock_register()
       clocksource: samsung_pwm_timer: Switch to sched_clock_register()
       clocksource: tegra: Switch to sched_clock_register()
       clocksource: time-armada-370-xp: Switch to sched_clock_register()
       clocksource: sirf: Switch to sched_clock_register() and use 64 bits
       clocksource: vf_pit_timer: Switch to sched_clock_register()

Sudeep KarkadaNagesha (4):
       ARM/ARM64: arch_timer: add macros for bits in control register
       ARM: arch_timer: add support to configure and enable event stream
       ARM64: arch_timer: add support to configure and enable event stream
       drivers: clocksource: add CPU PM notifier for ARM architected timer

Will Deacon (1):
       drivers: clocksource: add support for ARM architected timer event 
stream

Zoran Markovic (1):
       rtc: Keep system awake until all expired RTC timers are handled

  arch/arm/boot/dts/zynq-7000.dtsi          |    8 +++
  arch/arm/include/asm/arch_timer.h         |   36 ++++++++--
  arch/arm/include/uapi/asm/hwcap.h         |    1 +
  arch/arm/kernel/setup.c                   |    1 +
  arch/arm/mach-zynq/Kconfig                |    1 +
  arch/arm64/include/asm/arch_timer.h       |   42 +++++++++--
  arch/arm64/include/asm/hwcap.h            |   11 +--
  arch/arm64/include/uapi/asm/hwcap.h       |    1 +
  arch/arm64/kernel/setup.c                 |   11 +++
  drivers/clocksource/Kconfig               |   15 ++++
  drivers/clocksource/arm_arch_timer.c      |   49 +++++++++++++
  drivers/clocksource/arm_global_timer.c    |    3 +-
  drivers/clocksource/bcm2835_timer.c       |    4 +-
  drivers/clocksource/clksrc-dbx500-prcmu.c |    5 +-
  drivers/clocksource/dw_apb_timer_of.c     |    4 +-
  drivers/clocksource/mxs_timer.c           |    4 +-
  drivers/clocksource/nomadik-mtu.c         |    4 +-
  drivers/clocksource/samsung_pwm_timer.c   |    4 +-
  drivers/clocksource/tegra20_timer.c       |    4 +-
  drivers/clocksource/time-armada-370-xp.c  |    4 +-
  drivers/clocksource/timer-prima2.c        |    6 +-
  drivers/clocksource/vf_pit_timer.c        |    4 +-
  drivers/rtc/interface.c                   |   13 ++--
  include/clocksource/arm_arch_timer.h      |   10 +++
  include/linux/clockchips.h                |    1 +
  include/linux/clocksource.h               |    2 +
  include/linux/sched_clock.h               |    2 +
  kernel/time/clocksource.c                 |   46 ++++++++----
  kernel/time/ntp.c                         |    3 +-
  kernel/time/sched_clock.c                 |  111 
++++++++++++++++-------------
  kernel/time/tick-broadcast.c              |    1 +
  31 files changed, 302 insertions(+), 109 deletions(-)


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

