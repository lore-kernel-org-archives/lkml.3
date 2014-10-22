Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986AbaJVGHt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 02:07:49 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:49134 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbaJVGHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 02:07:47 -0400
From: Mike Turquette <mturquette@linaro.org>
To: peterz@infradead.org, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, preeti@linux.vnet.ibm.com,
        Morten.Rasmussen@arm.com, kamalesh@linux.vnet.ibm.com, riel@redhat.com,
        efault@gmx.de, nicolas.pitre@linaro.org,
        linaro-kernel@lists.linaro.org, daniel.lezcano@linaro.org,
        dietmar.eggemann@arm.com, pjt@google.com, bsegall@google.com,
        vincent.guittot@linaro.org, patches@linaro.org,
        tuukka.tikkanen@linaro.org, amit.kucheria@linaro.org,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH RFC 0/7] scheduler-driven cpu frequency scaling
Date: Tue, 21 Oct 2014 23:07:24 -0700
Message-Id: <1413958051-7103-1-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series demonstrates cpu frequency scaling via a simple policy
driven by the scheduler. Specifically the policy evaluates cpu frequency
when cpu utilization is updated from enqueue_task_fair and
dequeue_task_fair. The policy itself uses a simple up/down threshold
scheme using the same 80%/20% cpu utilization boundaries that are used
by default in the ondemand cpufreq governor.

This series is not intended for merging, but instead to ignite some
discussion around scheduler-driven cpu frequency selection. Of
particular interest to me is the policy itself and how it might
integrate with task placement in CFS's load_balance. Additionally I'd
like to ask the scheduler experts about which call sites in CFS are
right for evaluating cpu frequency selection; maybe
{en,de}queue_task_fair are not such a good idea?

The messiest part of this series is the cpumask stuff, where I tried to
track which cpus have updated statistics in the case of a sched_entity
which contains several other sched_entities that are spread across cpus.
As discussed at Linux Plumbers Conference 2014, I will replace this
complexity with simpler logic that ignores scheduler cgroups in the next
version. In any case I am posting the code I have now.

This code is experiemental and bugs are Guaranteed.

These patches are based on the scale invariance series from Morten[0].
The variables names in this RFC will doubtless change once that work is
rebased onto Vincent's series[1].

[0] http://lkml.kernel.org/r/<1411403047-32010-1-git-send-email-morten.rasmussen@arm.com>
[1] http://lkml.kernel.org/r/<1412684017-16595-1-git-send-email-vincent.guittot@linaro.org>

Mike Turquette (6):
  sched: cfs: declare capacity_of in sched.h
  sched: fair: add usage_util_of helper
  cpufreq: add per-governor private data
  sched: cfs: cpu frequency scaling arch functions
  sched: cfs: cpu frequency scaling based on task placement
  sched: energy_model: simple cpu frequency scaling policy

Morten Rasmussen (1):
  sched: Make energy awareness a sched feature

 drivers/cpufreq/Kconfig     |  21 +++
 include/linux/cpufreq.h     |   6 +
 kernel/sched/Makefile       |   1 +
 kernel/sched/energy_model.c | 341 ++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/fair.c         |  69 ++++++++-
 kernel/sched/features.h     |   6 +
 kernel/sched/sched.h        |   3 +
 7 files changed, 445 insertions(+), 2 deletions(-)
 create mode 100644 kernel/sched/energy_model.c

-- 
1.8.3.2

