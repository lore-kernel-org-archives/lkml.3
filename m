Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909Ab3BZWRa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 17:17:30 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:51672 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053Ab3BZWR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 17:17:28 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: john.stultz@linaro.org, tglx@linutronix.de
Cc: viresh.kumar@linaro.org, jacob.jun.pan@linux.intel.com,
        linux-arm-kernel@lists.infradead.org, santosh.shilimkar@ti.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        linus.walleij@stericsson.com
Subject: [PATCH 0/4] time: dynamic irq affinity
Date: Tue, 26 Feb 2013 23:17:23 +0100
Message-Id: <1361917047-29230-1-git-send-email-daniel.lezcano@linaro.org>
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
to specify which clocksource can handle it.

Daniel Lezcano (3):
  time : pass broadcast parameter
  time : set broadcast irq affinity
  ARM: nomadik: add dynamic irq flag to the timer

Viresh Kumar (1):
  ARM: timer-sp: Set dynamic irq affinity

 arch/arm/common/timer-sp.c        |    3 ++-
 drivers/clocksource/nomadik-mtu.c |    3 ++-
 include/linux/clockchips.h        |    1 +
 kernel/time/tick-broadcast.c      |   40 +++++++++++++++++++++++++++++--------
 4 files changed, 37 insertions(+), 10 deletions(-)

-- 
1.7.9.5

