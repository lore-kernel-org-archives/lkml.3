Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988Ab3CBKKP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 05:10:15 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:49720 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab3CBKKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 05:10:12 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: john.stultz@linaro.org, tglx@linutronix.de
Cc: viresh.kumar@linaro.org, jacob.jun.pan@linux.intel.com,
        linux-arm-kernel@lists.infradead.org, santosh.shilimkar@ti.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        rickard.andersson@stericsson.com, vincent.guittot@linaro.org,
        linus.walleij@stericsson.com
Subject: [PATCH 0/4][V2] time: dynamic irq affinity
Date: Sat,  2 Mar 2013 11:10:09 +0100
Message-Id: <1362219013-18173-1-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a cpu goes to a deep idle state where its local timer is shutdown,
it notifies the time framework to use the broadcast timer instead.

Unfortunately, the broadcast device could wake up any CPU, including an
idle one which is not concerned by the wake up at all.

This implies, in the worst case, an idle CPU will wake up to send an IPI
to another idle cpu.

This patch solves this by setting the irq affinity to the cpu concerned
by the nearest timer event, by this way, the CPU which is wake up is
guarantee to be the one concerned by the next event and we are safe with
unnecessary wakeup for another idle CPU.

As the irq affinity is not supported by all the archs, a flag is needed
to specify which clocksource can handle it : CLOCK_EVT_FEAT_DYNIRQ.

Tested on a u8500 board with a test program doing indefinitely usleep 10000
wired on each CPU.

With dynamic irq affinity:
Log is 10.042298 secs long with 4190 events
cpu0/state0, 24 hits, total 2718.00us, avg 113.25us, min 0.00us, max 854.00us
cpu0/state1, 994 hits, total 9874827.00us, avg 9934.43us, min 30.00us, max 10346.00us
cpu1/state0, 73 hits, total 17001.00us, avg 232.89us, min 0.00us, max 10040.00us
cpu1/state1, 1002 hits, total 9883840.00us, avg 9864.11us, min 0.00us, max 10742.00us
cluster/state0, 0 hits, total 0.00us, avg 0.00us, min 0.00us, max 0.00us
cluster/state1, 1931 hits, total 9762328.00us, avg 5055.58us, min 30.00us, max 9308.00us

Without dynamic irq affinity:
Log is 10.036834 secs long with 6574 events
cpu0/state0, 114 hits, total 20107.00us, avg 176.38us, min 0.00us, max 7233.00us
cpu0/state1, 1951 hits, total 9833836.00us, avg 5040.41us, min 0.00us, max 9217.00us
cpu1/state0, 223 hits, total 21140.00us, avg 94.80us, min 0.00us, max 2960.00us
cpu1/state1, 997 hits, total 9879748.00us, avg 9909.48us, min 0.00us, max 10346.00us
cluster/state0, 5 hits, total 5462.00us, avg 1092.40us, min 580.00us, max 2899.00us
cluster/state1, 2298 hits, total 9740988.00us, avg 4238.90us, min 30.00us, max 9217.00us

Results for the specific test case 'usleep 10000'
 * reduced by 40% the number of wake up on the system
 * reduced by 49% the number of wake up for CPU0
 * increased by factor two idle time for CPU0
 * increase by 16% package idle hits + 16% average package idle time

Changelog:

V2 :
 * mentioned CLOCK_EVT_FEAT_DYNIRQ flag name in patch description
 * added comments for CLOCK_EVT_FEAT_DYNIRQ
 * replaced tick_broadcast_set_affinity parameter to use a cpumask

V1 : initial post

Daniel Lezcano (3):
  time : pass broadcast parameter
  time : set broadcast irq affinity
  ARM: nomadik: add dynamic irq flag to the timer

Viresh Kumar (1):
  ARM: timer-sp: Set dynamic irq affinity

 arch/arm/common/timer-sp.c        |    3 ++-
 drivers/clocksource/nomadik-mtu.c |    3 ++-
 include/linux/clockchips.h        |    5 +++++
 kernel/time/tick-broadcast.c      |   41 +++++++++++++++++++++++++++++--------
 4 files changed, 42 insertions(+), 10 deletions(-)

-- 
1.7.9.5

