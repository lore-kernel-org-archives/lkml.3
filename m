Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801Ab3JKRTb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 13:19:31 -0400
Received: from service87.mimecast.com ([91.220.42.44]:48505 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453Ab3JKRTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 13:19:30 -0400
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: mingo@kernel.org, peterz@infradead.org
Cc: pjt@google.com, arjan@linux.intel.com, rjw@sisk.pl,
        dirk.j.brandewie@intel.com, vincent.guittot@linaro.org,
        alex.shi@linaro.org, preeti@linux.vnet.ibm.com, efault@gmx.de,
        corbet@lwn.net, tglx@linutronix.de, catalin.marinas@arm.com,
        morten.rasmussen@arm.com, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Subject: [RFC][PATCH 0/7] Power-aware scheduling v2
Date: Fri, 11 Oct 2013 18:19:10 +0100
Message-Id: <1381511957-29776-1-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
X-OriginalArrivalTime: 11 Oct 2013 17:19:24.0848 (UTC) FILETIME=[086BDB00:01CEC6A6]
X-MC-Unique: 113101118192702901
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r9BHJt3Y031555

Hi,

I have revised the previous power scheduler proposal[1] trying to address as
many of the comments as possible. The overall idea was discussed at LPC[2,3].
The revised design has removed the power scheduler and replaced it with a high
level power driver interface. An interface that allows the scheduler to query
the power driver for information and provide hints to guide power management
decisions in the power driver.

The power driver is going to be a unified platform power driver that can
replace cpufreq and cpuidle drivers. Generic power policies will be optional
helper functions called from the power driver. Platforms may choose to
implement their own policies as part of their power driver.

This RFC series prototypes a part of the power driver interface (cpu capacity
hints) and shows how they can be used from the scheduler. More extensive use of
the power driver hints and queries is left for later. The focus for now is the
power driver interface. The patch series includes a power driver/cpufreq
governor that can use existing cpufreq drivers as backend. It has been tested
(not thoroughly) on ARM TC2. The cpufreq governor power driver implementation
is rather horrible, but it illustrates how the power driver interface can be
used. Native power drivers is on the todo list.

The power driver interface is still missing quite a few calls to handle: Idle,
adding extra information to the sched_domain hierarchy to guide scheduling
decisions (packing), and possibly scaling of tracked load to compensate for
frequency changes and asymmetric systems (big.LITTLE).

This set is based on 3.11. I have done ARM TC2 testing based on linux-linaro
2013.08[4] to get cpufreq support for TC2.


Morten

[1] https://lkml.org/lkml/2013/7/9/314

[2] http://etherpad.osuosl.org/lpc2013-power-efficient-scheduling

[3] http://www.linuxplumbersconf.org/2013/ocw//system/presentations/1263/original/Unifying_Power_Policies_LPC.pdf

[4] http://git.linaro.org/gitweb?p=kernel/linux-linaro-tracking.git


Morten Rasmussen (7):
  Initial power driver interface infrastructure
  sched: power: Power driver late callback interface
  sched: power: go_faster/slower power driver hints
  sched: power: Remove power capacity hints for kworker threads
  sched: power: Increase cpu capacity based on rq tracked load
  sched: power: cpufreq: Initial schedpower cpufreq governor/power
    driver
  sched: power: Let the power driver choose the best wake-up cpu

 arch/arm/Kconfig                     |    4 +
 drivers/cpufreq/Kconfig              |   11 ++
 drivers/cpufreq/Makefile             |    1 +
 drivers/cpufreq/cpufreq_schedpower.c |  218 ++++++++++++++++++++++++++++++++++
 include/linux/sched/power.h          |   37 ++++++
 kernel/sched/Makefile                |    1 +
 kernel/sched/core.c                  |    1 +
 kernel/sched/fair.c                  |   53 ++++++++-
 kernel/sched/power.c                 |   73 ++++++++++++
 kernel/sched/sched.h                 |   32 +++++
 10 files changed, 430 insertions(+), 1 deletion(-)
 create mode 100644 drivers/cpufreq/cpufreq_schedpower.c
 create mode 100644 include/linux/sched/power.h
 create mode 100644 kernel/sched/power.c

-- 
1.7.9.5


