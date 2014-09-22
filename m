Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518AbaIVQYG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 12:24:06 -0400
Received: from service87.mimecast.com ([91.220.42.44]:60058 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988AbaIVQYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 12:24:04 -0400
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: peterz@infradead.org, mingo@redhat.com
Cc: dietmar.eggemann@arm.com, pjt@google.com, bsegall@google.com,
        vincent.guittot@linaro.org, nicolas.pitre@linaro.org,
        mturquette@linaro.org, rjw@rjwysocki.net, linux-kernel@vger.kernel.org,
        Morten Rasmussen <morten.rasmussen@arm.com>
Subject: [PATCH 0/7] sched: Scale-invariant per-entity load-tracking
Date: Mon, 22 Sep 2014 17:24:00 +0100
Message-Id: <1411403047-32010-1-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
X-OriginalArrivalTime: 22 Sep 2014 16:23:59.0159 (UTC) FILETIME=[9D157C70:01CFD681]
X-MC-Unique: 114092217240116601
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s8MGO9an029510

Per-entity load-tracking is currently unaware of frequency scaling and any
micro-architectural differences between cpus (e.g. big.LITTLE). To enable
better estimates of cpu utilization load-tracking needs to be scale-invariant.
Per-entity load-tracking needs to report the same load regardless of the cpu
and the current frequency of the cpu.

This patch-set introduces an architecture provided scale-invariance correction
factor for per-entity load-tracking which is applied when task load-tracking is
updated. The factor is in the range 0-1024, where 1024 is the scaling factor
when a task runs on the highest frequency on the fastest cpu in the system. It
means that a task can only reach 'full' load contribution when running at the
fastest cpu at the highest frequency. Without scale-invariance a task having a
load contribution of 50% on a cpu running a 50% frequency would change its
load-contribution to 25% if the frequency increased to 100%. With
scale-invariance, the load-contribution is 25% regardless of the frequency.
Hence, if we have two 25% tasks on different cpus, we know that their combined
load can be accommodated on any cpu running at least 50% frequency (assuming
the micro-architecture is the same).

Scaling the per-entity load-tracking is only a part of providing
scale-invariance. The cpu capacity used for load-balancing decisions needs to
be scaled as well to allow comparison between scale-invariant load and compute
capacity. This is not addressed yet. Vincent's recent patches [1] provide
micro-architectural scaling of compute capacity, but frequency scaling is still
missing and will have to be aligned with these patches.

This patch-set also includes a scale-invariant utilization metric which is
based on Paul Turner's original usage tracking which Vincent's patches also
reintroduces. Hence this patch set will need to be rebased on top of those.

Morten

[1] https://lkml.org/lkml/2014/8/26/288

Dietmar Eggemann (1):
  sched: Introduce scale-invariant load tracking

Morten Rasmussen (6):
  cpufreq: Architecture specific callback for frequency changes
  arm: Frequency invariant scheduler load-tracking support
  arm: Micro-architecture invariant load tracking support
  sched: Implement usage tracking
  sched: Make sched entity usage tracking scale-invariant
  sched: Track sched_entity usage contributions

 arch/arm/kernel/topology.c |   44 +++++++++++++++++++++++
 drivers/cpufreq/cpufreq.c  |   10 +++++-
 include/linux/sched.h      |    3 +-
 kernel/sched/debug.c       |    5 +++
 kernel/sched/fair.c        |   86 +++++++++++++++++++++++++++++++++++---------
 kernel/sched/sched.h       |    2 +-
 6 files changed, 131 insertions(+), 19 deletions(-)

-- 
1.7.9.5


