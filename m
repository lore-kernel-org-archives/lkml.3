Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325AbaEIIky (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 04:40:54 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:62506 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756309AbaEIIku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 04:40:50 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, arvind.chauhan@arm.com, preeti@linux.vnet.ibm.com,
        khilman@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 0/2] tick: NO_HZ_FULL: get rid of unnecessary interruption
Date: Fri,  9 May 2014 14:10:21 +0530
Message-Id: <cover.1399623699.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This happened for me during my NO_HZ_FULL testing on isolated CPU, but may
happen otherwise as well.

When the last htimer of a CPU is cancelled (For example: for NO_HZ_FULL when
expires == KTIME_MAX), we do not SHUTDOWN the event device. And because of that
we will get interrupted unnecessarily on the isolated core as event device will
interrupt as per the last value it is configured with.

The implementation of event device's driver may make it worse. For example:
drivers/clocksource/arm_arch_timer.c disables the event device only on
SHUTDOWN/UNUSED requests in set-mode. Otherwise, it will keep giving interrupts
at tick interval even if hrtimer_interrupt() didn't reprogram tick (When expires
== KTIME_MAX). And so we will keep getting interrupt every few milliseconds. To
confirm this I added a small hack in hrtimer.c [1] and got these results [2] as
soon as the CPU got isolated with NO_HZ_FULL and cpusets.

Probably the right solution to fix this is to disable the event device for such
cases, i.e. expires == KTIME_MAX and restart it later when required. This will
get rid of unnecessary interruption which can be avoided.

Tested over 3.15-rc4 on ARM Exynos5250 (Dual A15) board.

NOTE: Current implementation of NO_HZ_FULL has a limitation of 1 second and so
we might never end up cancelling sched_timer. I was using Kevin's debug patch:
https://lkml.org/lkml/2013/12/17/649, with which I am able to get expires to
KTIME_MAX and so ended up cancelling hrtimer.

[1] http://pastebin.com/MhDdawVd
[2] http://pastebin.com/5U5FBbTW

Viresh Kumar (2):
  hrtimer: reprogram event for expires=KTIME_MAX in
    hrtimer_force_reprogram()
  tick: SHUTDOWN event-dev if no events are required for KTIME_MAX

 include/linux/clockchips.h |  1 +
 kernel/hrtimer.c           |  3 +--
 kernel/time/tick-oneshot.c | 14 +++++++++++++-
 3 files changed, 15 insertions(+), 3 deletions(-)

-- 
2.0.0.rc2

