Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853AbaC1M3r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 08:29:47 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:62131 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbaC1M3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 08:29:45 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org
Cc: rjw@rjwysocki.net, nicolas.pitre@linaro.org, linux-pm@vger.kernel.org,
        alex.shi@linaro.org, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com
Subject: [RFC PATCHC 0/3] sched/idle : find the idlest cpu with cpuidle info
Date: Fri, 28 Mar 2014 13:29:53 +0100
Message-Id: <1396009796-31598-1-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patchset provides an interaction between cpuidle and the scheduler.

The first patch encapsulate the needed information for the scheduler in a
separate cpuidle structure. The second one stores the pointer to this structure
when entering idle. The third one, use this information to take the decision to
find the idlest cpu.

After some basic testing with hackbench, it appears there is an improvement for
the performances (small) and for the duration of the idle states (which provides
a better power saving).

The measurement has been done with the 'idlestat' tool previously posted in this
mailing list.

So the benefit is good for both sides performance and power saving.

The select_idle_sibling could be also improved in the same way.

====================== test with hackbench 3.14-rc8 =========================

/usr/bin/hackbench -l 10000 -s 4096

Running in process mode with 10 groups using 40 file descriptors each (== 400 tasks)
Each sender will pass 10000 messages of 4096 bytes

Time: 44.433

Total trace buffer: 1846688 kB
clusterA@state	hits	      total(us)		avg(us)	min(us)	max(us)
         POLL	0	           0.00	           0.00	0.00	0.00
         C1-IVB	0	           0.00	           0.00	0.00	0.00
         C1E-VB	0	           0.00	           0.00	0.00	0.00
         C3-IVB	0	           0.00	           0.00	0.00	0.00
         C6-IVB	0	           0.00	           0.00	0.00	0.00
         C7-IVB	0	           0.00	           0.00	0.00	0.00
  core0@state	hits	      total(us)		avg(us)	min(us)	max(us)
        POLL	0	           0.00	           0.00	0.00	0.00
        C1-IVB	0	           0.00	           0.00	0.00	0.00
        C1E-IVB	0	           0.00	           0.00	0.00	0.00
        C3-IVB	0	           0.00	           0.00	0.00	0.00
        C6-IVB	0	           0.00	           0.00	0.00	0.00
        C7-IVB	1396	    87932131.00	       62988.63	0.00	320146.00
    cpu0@state	hits	      total(us)		avg(us)	min(us)	max(us)
         POLL	0	           0.00	           0.00	0.00	0.00
         C1-IVB	1	          14.00	          14.00	14.00	14.00
         C1E-VB	0	           0.00	           0.00	0.00	0.00
         C3-IVB	1	         262.00	         262.00	262.00	262.00
         C6-IVB	0	           0.00	           0.00	0.00	0.00
         C7-IVB	1180	    87938177.00	       74523.88	1.00	320147.00
         1701	0	           0.00	           0.00	0.00	0.00
         1700	0	           0.00	           0.00	0.00	0.00
         1600	0	           0.00	           0.00	0.00	0.00
         1500	0	           0.00	           0.00	0.00	0.00
         1400	0	           0.00	           0.00	0.00	0.00
         1300	0	           0.00	           0.00	0.00	0.00
         1200	0	           0.00	           0.00	0.00	0.00
         1100	0	           0.00	           0.00	0.00	0.00
         1000	0	           0.00	           0.00	0.00	0.00
         900	0	           0.00	           0.00	0.00	0.00
         800	0	           0.00	           0.00	0.00	0.00
         782	0	           0.00	           0.00	0.00	0.00
    cpu0 wakeups 	name 		count
         irq009	acpi           	1
    cpu1@state	hits	      total(us)		avg(us)	min(us)	max(us)
         POLL	0	           0.00	           0.00	0.00	0.00
         C1-IVB	0	           0.00	           0.00	0.00	0.00
         C1E-VB	0	           0.00	           0.00	0.00	0.00
         C3-IVB	0	           0.00	           0.00	0.00	0.00
         C6-IVB	0	           0.00	           0.00	0.00	0.00
         C7-IVB	475	    87941356.00	      185139.70	322.00	1500690.00
         1701	0	           0.00	           0.00	0.00	0.00
         1700	0	           0.00	           0.00	0.00	0.00
         1600	0	           0.00	           0.00	0.00	0.00
         1500	0	           0.00	           0.00	0.00	0.00
         1400	0	           0.00	           0.00	0.00	0.00
         1300	0	           0.00	           0.00	0.00	0.00
         1200	0	           0.00	           0.00	0.00	0.00
         1100	0	           0.00	           0.00	0.00	0.00
         1000	0	           0.00	           0.00	0.00	0.00
         900	0	           0.00	           0.00	0.00	0.00
         800	0	           0.00	           0.00	0.00	0.00
         782	0	           0.00	           0.00	0.00	0.00
    cpu1 wakeups 	name 		count
         irq009	acpi           	3
  core1@state	hits	      total(us)		avg(us)	min(us)	max(us)
        POLL	0	           0.00	           0.00	0.00	0.00
        C1-IVB	0	           0.00	           0.00	0.00	0.00
        C1E-IVB	0	           0.00	           0.00	0.00	0.00
        C3-IVB	0	           0.00	           0.00	0.00	0.00
        C6-IVB	0	           0.00	           0.00	0.00	0.00
        C7-IVB	0	           0.00	           0.00	0.00	0.00
    cpu2@state	hits	      total(us)		avg(us)	min(us)	max(us)
         POLL	0	           0.00	           0.00	0.00	0.00
         C1-IVB	11	      288157.00	       26196.09	16.00	200060.00
         C1E-VB	6	      221601.00	       36933.50	79.00	200066.00
         C3-IVB	0	           0.00	           0.00	0.00	0.00
         C6-IVB	0	           0.00	           0.00	0.00	0.00
         C7-IVB	950	    87417466.00	       92018.39	19.00	200074.00
         1701	0	           0.00	           0.00	0.00	0.00
         1700	0	           0.00	           0.00	0.00	0.00
         1600	0	           0.00	           0.00	0.00	0.00
         1500	2	          34.00	          17.00	11.00	23.00
         1400	0	           0.00	           0.00	0.00	0.00
         1300	0	           0.00	           0.00	0.00	0.00
         1200	0	           0.00	           0.00	0.00	0.00
         1100	0	           0.00	           0.00	0.00	0.00
         1000	0	           0.00	           0.00	0.00	0.00
         900	0	           0.00	           0.00	0.00	0.00
         800	0	           0.00	           0.00	0.00	0.00
         782	745	       18800.00	          25.23	2.00	156.00
    cpu2 wakeups 	name 		count
         irq019	ahci           	50
         irq009	acpi           	17
    cpu3@state	hits	      total(us)		avg(us)	min(us)	max(us)
         POLL	0	           0.00	           0.00	0.00	0.00
         C1-IVB	0	           0.00	           0.00	0.00	0.00
         C1E-VB	0	           0.00	           0.00	0.00	0.00
         C3-IVB	0	           0.00	           0.00	0.00	0.00
         C6-IVB	0	           0.00	           0.00	0.00	0.00
         C7-IVB	0	           0.00	           0.00	0.00	0.00
         1701	0	           0.00	           0.00	0.00	0.00
         1700	0	           0.00	           0.00	0.00	0.00
         1600	0	           0.00	           0.00	0.00	0.00
         1500	0	           0.00	           0.00	0.00	0.00
         1400	0	           0.00	           0.00	0.00	0.00
         1300	0	           0.00	           0.00	0.00	0.00
         1200	0	           0.00	           0.00	0.00	0.00
         1100	0	           0.00	           0.00	0.00	0.00
         1000	0	           0.00	           0.00	0.00	0.00
         900	0	           0.00	           0.00	0.00	0.00
         800	0	           0.00	           0.00	0.00	0.00
         782	0	           0.00	           0.00	0.00	0.00
    cpu3 wakeups 	name 		count

================ test with hackbench 3.14-rc8 + patchset ====================

/usr/bin/hackbench -l 10000 -s 4096

Running in process mode with 10 groups using 40 file descriptors each (== 400 tasks)
Each sender will pass 10000 messages of 4096 bytes

Time: 42.179

Total trace buffer: 1846688 kB
clusterA@state	hits	      total(us)		avg(us)	min(us)	max(us)
         POLL	0	           0.00	           0.00	0.00	0.00
         C1-IVB	0	           0.00	           0.00	0.00	0.00
         C1E-VB	0	           0.00	           0.00	0.00	0.00
         C3-IVB	0	           0.00	           0.00	0.00	0.00
         C6-IVB	0	           0.00	           0.00	0.00	0.00
         C7-IVB	0	           0.00	           0.00	0.00	0.00
  core0@state	hits	      total(us)		avg(us)	min(us)	max(us)
        POLL	0	           0.00	           0.00	0.00	0.00
        C1-IVB	0	           0.00	           0.00	0.00	0.00
        C1E-IVB	0	           0.00	           0.00	0.00	0.00
        C3-IVB	0	           0.00	           0.00	0.00	0.00
        C6-IVB	0	           0.00	           0.00	0.00	0.00
        C7-IVB	880	    89157590.00	      101315.44	0.00	400184.00
    cpu0@state	hits	      total(us)		avg(us)	min(us)	max(us)
         POLL	0	           0.00	           0.00	0.00	0.00
         C1-IVB	0	           0.00	           0.00	0.00	0.00
         C1E-VB	1	         233.00	         233.00	233.00	233.00
         C3-IVB	1	         260.00	         260.00	260.00	260.00
         C6-IVB	0	           0.00	           0.00	0.00	0.00
         C7-IVB	700	    89162006.00	      127374.29	182.00	400187.00
         1701	0	           0.00	           0.00	0.00	0.00
         1700	0	           0.00	           0.00	0.00	0.00
         1600	0	           0.00	           0.00	0.00	0.00
         1500	0	           0.00	           0.00	0.00	0.00
         1400	0	           0.00	           0.00	0.00	0.00
         1300	0	           0.00	           0.00	0.00	0.00
         1200	0	           0.00	           0.00	0.00	0.00
         1100	0	           0.00	           0.00	0.00	0.00
         1000	0	           0.00	           0.00	0.00	0.00
         900	0	           0.00	           0.00	0.00	0.00
         800	0	           0.00	           0.00	0.00	0.00
         782	0	           0.00	           0.00	0.00	0.00
    cpu0 wakeups 	name 		count
         irq009	acpi           	2
    cpu1@state	hits	      total(us)		avg(us)	min(us)	max(us)
         POLL	0	           0.00	           0.00	0.00	0.00
         C1-IVB	0	           0.00	           0.00	0.00	0.00
         C1E-VB	0	           0.00	           0.00	0.00	0.00
         C3-IVB	0	           0.00	           0.00	0.00	0.00
         C6-IVB	0	           0.00	           0.00	0.00	0.00
         C7-IVB	334	    89164805.00	      266960.49	1.00	1500677.00
         1701	0	           0.00	           0.00	0.00	0.00
         1700	0	           0.00	           0.00	0.00	0.00
         1600	0	           0.00	           0.00	0.00	0.00
         1500	0	           0.00	           0.00	0.00	0.00
         1400	0	           0.00	           0.00	0.00	0.00
         1300	0	           0.00	           0.00	0.00	0.00
         1200	0	           0.00	           0.00	0.00	0.00
         1100	0	           0.00	           0.00	0.00	0.00
         1000	0	           0.00	           0.00	0.00	0.00
         900	0	           0.00	           0.00	0.00	0.00
         800	0	           0.00	           0.00	0.00	0.00
         782	0	           0.00	           0.00	0.00	0.00
    cpu1 wakeups 	name 		count
         irq009	acpi           	6
  core1@state	hits	      total(us)		avg(us)	min(us)	max(us)
        POLL	0	           0.00	           0.00	0.00	0.00
        C1-IVB	0	           0.00	           0.00	0.00	0.00
        C1E-IVB	0	           0.00	           0.00	0.00	0.00
        C3-IVB	0	           0.00	           0.00	0.00	0.00
        C6-IVB	0	           0.00	           0.00	0.00	0.00
        C7-IVB	0	           0.00	           0.00	0.00	0.00
    cpu2@state	hits	      total(us)		avg(us)	min(us)	max(us)
         POLL	0	           0.00	           0.00	0.00	0.00
         C1-IVB	19	     2169047.00	      114160.37	18.00	999129.00
         C1E-IB	0	           0.00	           0.00	0.00	0.00
         C3-IVB	0	           0.00	           0.00	0.00	0.00
         C6-IVB	0	           0.00	           0.00	0.00	0.00
         C7-IVB	376	    86993307.00	      231365.18	20.00	1500682.00
         1701	0	           0.00	           0.00	0.00	0.00
         1700	0	           0.00	           0.00	0.00	0.00
         1600	0	           0.00	           0.00	0.00	0.00
         1500	0	           0.00	           0.00	0.00	0.00
         1400	0	           0.00	           0.00	0.00	0.00
         1300	0	           0.00	           0.00	0.00	0.00
         1200	0	           0.00	           0.00	0.00	0.00
         1100	0	           0.00	           0.00	0.00	0.00
         1000	0	           0.00	           0.00	0.00	0.00
         900	0	           0.00	           0.00	0.00	0.00
         800	0	           0.00	           0.00	0.00	0.00
         782	0	           0.00	           0.00	0.00	0.00
    cpu2 wakeups 	name 		count
         irq009	acpi           	32
         irq019	ahci           	45
    cpu3@state	hits	      total(us)		avg(us)	min(us)	max(us)
         POLL	0	           0.00	           0.00	0.00	0.00
         C1-IVB	0	           0.00	           0.00	0.00	0.00
         C1E-VB	0	           0.00	           0.00	0.00	0.00
         C3-IVB	0	           0.00	           0.00	0.00	0.00
         C6-IVB	0	           0.00	           0.00	0.00	0.00
         C7-IVB	0	           0.00	           0.00	0.00	0.00
         1701	0	           0.00	           0.00	0.00	0.00
         1700	0	           0.00	           0.00	0.00	0.00
         1600	0	           0.00	           0.00	0.00	0.00
         1500	0	           0.00	           0.00	0.00	0.00
         1400	0	           0.00	           0.00	0.00	0.00
         1300	0	           0.00	           0.00	0.00	0.00
         1200	0	           0.00	           0.00	0.00	0.00
         1100	0	           0.00	           0.00	0.00	0.00
         1000	0	           0.00	           0.00	0.00	0.00
         900	0	           0.00	           0.00	0.00	0.00
         800	0	           0.00	           0.00	0.00	0.00
         782	0	           0.00	           0.00	0.00	0.00
    cpu3 wakeups 	name 		count


Daniel Lezcano (3):
  cpuidle: encapsulate power info in a separate structure
  idle: store the idle state the cpu is
  sched/fair: use the idle state info to choose the idlest cpu

 arch/arm/include/asm/cpuidle.h       |    6 +-
 arch/arm/mach-exynos/cpuidle.c       |    4 +-
 drivers/acpi/processor_idle.c        |    4 +-
 drivers/base/power/domain.c          |    6 +-
 drivers/cpuidle/cpuidle-at91.c       |    4 +-
 drivers/cpuidle/cpuidle-big_little.c |    9 +--
 drivers/cpuidle/cpuidle-calxeda.c    |    6 +-
 drivers/cpuidle/cpuidle-kirkwood.c   |    4 +-
 drivers/cpuidle/cpuidle-powernv.c    |    8 +--
 drivers/cpuidle/cpuidle-pseries.c    |   12 ++--
 drivers/cpuidle/cpuidle-ux500.c      |   14 ++---
 drivers/cpuidle/cpuidle-zynq.c       |    4 +-
 drivers/cpuidle/driver.c             |    6 +-
 drivers/cpuidle/governors/ladder.c   |   14 +++--
 drivers/cpuidle/governors/menu.c     |    8 +--
 drivers/cpuidle/sysfs.c              |    2 +-
 drivers/idle/intel_idle.c            |  112 +++++++++++++++++-----------------
 include/linux/cpuidle.h              |   10 ++-
 kernel/sched/fair.c                  |   46 ++++++++++++--
 kernel/sched/idle.c                  |   17 +++++-
 kernel/sched/sched.h                 |    5 ++
 21 files changed, 180 insertions(+), 121 deletions(-)

-- 
1.7.9.5

