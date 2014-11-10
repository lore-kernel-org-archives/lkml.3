Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751342AbaKJFrg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 00:47:36 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:43915 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbaKJFrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 00:47:33 -0500
From: Shilpasri G Bhat <shilpa.bhat@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, mturquette@linaro.org, amit.kucheria@linaro.org,
        vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        Morten.Rasmussen@arm.com, efault@gmx.de, nicolas.pitre@linaro.org,
        dietmar.eggemann@arm.com, pjt@google.com, bsegall@google.com,
        peterz@infradead.org, mingo@kernel.org, linaro-kernel@lists.linaro.org,
        Shilpasri G Bhat <shilpa.bhat@linux.vnet.ibm.com>
Subject: [RFC 0/2] CPU frequency scaled from a task's load on an idle wakeup
Date: Mon, 10 Nov 2014 11:15:56 +0530
Message-Id: <1415598358-26505-1-git-send-email-shilpa.bhat@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.3
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14111005-0025-0000-0000-00000077B640
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set aims to solve a problem in cpufreq governor's CPU
load calculation logic when the CPU wakes up after an idle period.
In the current logic when a CPU wakes up from an idle state the
'previous load' of the CPU is used as its current load on the
alternate wakeups.

A latency-sensitive-bursty task will be benefited from this logic if
it wakes up on a CPU on which it was initially running, with a
non-compromised CPU 'previous load' i.e, the 'previous load' holds
the last calculated CPU load before the task went to sleep. In such
a case, the cpufreq governor will account to high previous CPU load
and decides to run at high frequency.

The problem in this logic is that the 'previous load' which is meant
to help certain latency-sensitive-bursty tasks can get used by some
periodic-small tasks(like kernel daemons) to its advantage if the
small task woke up first on the CPU. This will deprive the the
latency-sensitive-bursty tasks from running at high frequency until
the cpufreq governor notices the 100% CPU utilization. If this pattern
gets repeated in the due course of bursty task's execution we will
land on the same problem which 'prev_load' had originally set forth to 
solve.

Probably we could reduce these inefficiencies if the cpufreq
governor was aware of the task's nature, while calculating the load
during an idle-wakeup scenario. So instead of using the previous
load for the CPU , the load can be deduced on the basis of incoming
task's load.

In this patch we use a metric built on top of 'load_avg_contrib'.
'load_avg_contrib' of a task's sched entity can describe the nature
of the task in terms of its CPU utilization. The properties of this
metric to encapsulate the CPU utilization of a task makes it a
potential candidate for scaling CPU frequency. However, due to the
nature of its design 'load_avg_contrib' cannot pick up the task's
load rapidly after a wakeup. As we are trying to solve the problem
on idle-wakeup case we cannot use this metric value as is to scale
the frequency. So we measure the cumulative moving average of
'load_avg_contrib'.

The cumulative average of 'load_avg_contrib' at a given point is the
average of all the values of 'load_avg_contrib' up until that point.
The current average of a new 'load_avg_contrib' value is as below:

Cumulative_average(n+1) = x(n+1) + Cumulative_average(n) * n
                        ---------------------------------------
                                        n+1
where,
Cumulative_average(n+1) is the current cumulative average
x(n+1) is the latest 'load_avg_contrib' value
Cumulative_average(n) is the previous cumulative average
n+1 is the number of 'load_avg_contrib' values so far

The cumulative average of 'load_avg_contrib' will help us smooth out
the short-term fluctuations and highlight long-term trend of
'load-avg_contrib' metric. So cumulative average of the task can
depict the nature of the task more effectively. Thus we can scale CPU
frequency based on the cumulative average of the task and make
calculative decisions whether to decrease or increase the frequency
depending on the nature of the task.

Shilpasri G Bhat (2):
  sched/fair: Add cumulative average of load_avg_contrib to a task
  cpufreq: governor: CPU frequency scaled from task's cumulative-load on
    an idle wakeup

 drivers/cpufreq/cpufreq_governor.c | 39 +++++++++++++++-----------------------
 drivers/cpufreq/cpufreq_governor.h |  9 ++-------
 include/linux/sched.h              |  4 ++++
 kernel/sched/core.c                | 35 ++++++++++++++++++++++++++++++++++
 kernel/sched/fair.c                |  6 +++++-
 kernel/sched/sched.h               |  2 +-
 6 files changed, 62 insertions(+), 33 deletions(-)

-- 
1.9.3

