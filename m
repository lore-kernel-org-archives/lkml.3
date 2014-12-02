Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867AbaLBOHB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 09:07:01 -0500
Received: from service87.mimecast.com ([91.220.42.44]:39589 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbaLBOG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 09:06:58 -0500
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: peterz@infradead.org, mingo@redhat.com
Cc: dietmar.eggemann@arm.com, vincent.guittot@linaro.org, pjt@google.com,
        bsegall@google.com, mturquette@linaro.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Morten Rasmussen <morten.rasmussen@arm.com>
Subject: [RFC PATCH 00/10] sched: frequency and cpu invariant per-entity load-tracking and other load-tracking bits
Date: Tue,  2 Dec 2014 14:06:22 +0000
Message-Id: <1417529192-11579-1-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.9.1
X-OriginalArrivalTime: 02 Dec 2014 14:06:53.0932 (UTC) FILETIME=[39CBB2C0:01D00E39]
X-MC-Unique: 114120214065603801
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id sB2E8rCj016984

Numerous proposals for various changes to per-entity load-tracking have
been posted in the past to introduce various forms of scale invariance,
utilization tracking, and taking blocked load into account. This RFC
patch set has attempts to merge the features of these proposals.

The patch set is based on top of Vincent's cpu capacity and usage patch
set [1] which introduces the scheduler side of frequency invariant
utilization tracking. This patch set adds:

Patches:

1: Adds frequency scale invariance to runnable load tracking
(weighted_cpuload() and friends). Like utilization in [1], load is now
also scaled with frequency relative to the max frequency.

2: Adds cpu scale invariance to both load and utilization. This second
scaling compensates for differences in max performance between cpus,
e.g. cpus with different max OPPs or different cpu uarchs (ARM
big.LITTLE).

3-5: ARM arch implementation of arch_scale_freq_capacity() to enable
frequency invariance of both utilization and load.

6: Update ARM arch implementation of arch_scale_cpu_capacity().

7: Remove scaling of cpu usage by capacity_orig. With introduction of
cpu scale-invariance the per-entity tracking already does this scaling.

Experimental patches:

8: Add tracking of blocked utilization (usage) to the utilization
introduced in [1].

9: Change get_cpu_usage() to include blocked utilization (usage).

10: Change weighted_cpuload() to include blocked load. The implications of
this change needs further testing and very likely more changes.


The last three patches are quite likely to cause some trouble and
require some modifications to the users of get_cpu_usage() and
weighted_cpuload(). An audit of the load-balance code is needed. The
blocked load/utilization patches should be considered experimental, but
they are part of what is needed to add invariance and blocked
load/utilization to per-entity load-tracking.

The purpose of this whole exercise is to get more accurate load and
utilization tracking for systems with frequency scaling and/or cpus with
different uarchs.

[1] https://lkml.org/lkml/2014/11/3/535

Dietmar Eggemann (5):
  sched: Make load tracking frequency scale-invariant
  sched: Make usage and load tracking cpu scale-invariant
  ARM: vexpress: Add CPU clock-frequencies to TC2 device-tree
  arm: Cpu invariant scheduler load-tracking support
  sched: Get rid of scaling usage by cpu_capacity_orig

Morten Rasmussen (5):
  cpufreq: Architecture specific callback for frequency changes
  arm: Frequency invariant scheduler load-tracking support
  sched: Track blocked utilization contributions
  sched: Include blocked utilization in usage tracking
  sched: Include blocked load in weighted_cpuload

 arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts |  5 ++
 arch/arm/kernel/topology.c                 | 97 +++++++++++++++++-------------
 drivers/cpufreq/cpufreq.c                  | 10 ++-
 kernel/sched/fair.c                        | 91 ++++++++++++++++++++++------
 kernel/sched/sched.h                       |  8 ++-
 5 files changed, 147 insertions(+), 64 deletions(-)

-- 
1.9.1


