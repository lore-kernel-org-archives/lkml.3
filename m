Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736AbaJVN57 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 09:57:59 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:49106 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbaJVN55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 09:57:57 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, rafael.j.wysocki@intel.com, mingo@kernel.org,
        peterz@infradead.org, preeti@linux.vnet.ibm.com,
        Morten.Rasmussen@arm.com, mturquette@linaro.org,
        tuukka.tikkanen@linaro.org, nicolas.pitre@linaro.org,
        patches@linaro.org
Subject: [RFD PATCH 00/10] cpuidle: Predict the next events with the IO latencies
Date: Wed, 22 Oct 2014 15:57:43 +0200
Message-Id: <1413986273-28522-1-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is not intended to be merged upstream as it is. It is a
proof of concept giving the rough idea of the concept.

In the discussions on how to make the scheduler energy aware, we tried
to make the different PM subsystems to communicate with the scheduler.

We realized that some code is duplicated across the PM subsystems and
the scheduler leading to an inconsistent way to integrate the PM
informations.

Ingo Molnar put a line in the sand [1] and clearly worded that no more
PM stuff will be integrated into the scheduler until the different PM
blocks are not redesigned to be part of the scheduler.

This patchset is a sub part of this integration work. How to integrate
Cpuidle with the scheduler ?

The idea is to get rid of the governors and let the scheduler to tell
the Cpuidle framework : "I expect to sleep <x> nsec and I have a <y>
nsec latency requirement" as stated by Peter Zijlstra [2].

How to achieve this ?

We want to prevent to just move code around and put the prediction of
the next event inside the scheduler directly with a legacy menu
governor. After investigating, it appears the menu governor is not
behaving in a stable way, it is erratic. Using the IO latencies +
the timers give much better results than the menu governor which takes
into account all the source of wakeups [3].

After discussing at the LPC2014 Dusseldorf, it appears the idea is
good but the approach is wrong. The latency tracking must be done at
the device level, per device and not in the task as what is doing this
patchset.

Any comment, suggestion or help is welcome !

If I missed anyone who may be interested in this feature, please let
me know.

Thanks.

  -- Daniel

[1] http://lwn.net/Articles/552885/
[2] https://lkml.org/lkml/2013/11/11/353
[3] http://events.linuxfoundation.org/sites/events/files/slides/IOlatencyPrediction.pdf

Daniel Lezcano (10):
  sched: add io latency framework
  cpuidle: Checking the zero latency inside the governors does not make
    sense.
  sched: idle: cpudidle: Pass the latency req from idle.c
  sched: idle: Compute next timer event and pass it the cpuidle
    framework
  cpuidle: Remove unused headers for tick
  sched: idle: Add io latency information for the next event
  cpuidle: Add a simple select governor
  cpuidle: select: hack - increase rating to have this governor as
    default
  cpuidle: sysfs: Add per cpu idle state prediction statistics
  sched: io_latency: Tracking via buckets

 drivers/cpuidle/Kconfig            |   4 +
 drivers/cpuidle/cpuidle.c          |  17 +-
 drivers/cpuidle/governors/Makefile |   1 +
 drivers/cpuidle/governors/ladder.c |  11 +-
 drivers/cpuidle/governors/menu.c   |  15 +-
 drivers/cpuidle/governors/select.c |  55 +++++
 drivers/cpuidle/sysfs.c            | 156 +++++++++++++
 include/linux/cpuidle.h            |  22 +-
 include/linux/sched.h              |  21 ++
 init/Kconfig                       |  11 +
 kernel/exit.c                      |   1 +
 kernel/fork.c                      |   5 +-
 kernel/sched/Makefile              |   1 +
 kernel/sched/core.c                |   7 +
 kernel/sched/idle.c                |  27 ++-
 kernel/sched/io_latency.c          | 441 +++++++++++++++++++++++++++++++++++++
 kernel/sched/io_latency.h          |  38 ++++
 17 files changed, 800 insertions(+), 33 deletions(-)
 create mode 100644 drivers/cpuidle/governors/select.c
 create mode 100644 kernel/sched/io_latency.c
 create mode 100644 kernel/sched/io_latency.h

-- 
1.9.1

