Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbaBJRoa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:44:30 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:63558 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752253AbaBJRo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:44:29 -0500
From: Mark Rutland <mark.rutland@arm.com>
To: linux-kernel@vger.kernel.org
Cc: will.deacon@arm.com, dave.martin@arm.com,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 0/7] Perf core cleanups for shared perf_event_contexts
Date: Mon, 10 Feb 2014 17:44:17 +0000
Message-Id: <1392054264-23570-1-git-send-email-mark.rutland@arm.com>
X-Mailer: git-send-email 1.8.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've been working on adding support for heterogeneous pmus (as would be found
in big.LITTLE systems) to the arm perf backend, and in the process of doing so
I've noticed a few issues in the core perf code that would be nice to have
fixed up. The heterogeneous pmu support is not quite ready, but the core
changes are independent, so I'm posting them today.

The first three patches fix up some basic issues which are relevant regardless
of whether you wish to deal with heterogeneous pmus, though patch two also
fixes a potential bug when perf_event_contexts are shared by multiple pmus.

The remaining four patches attempt to fix some inconsistencies in perf core
with regard to multiple pmus sharing perf_event_contexts, taken to the extreme
of removing perf_event_context::pmu. These result in an odd edge-case with a
shared hrtimer_interval_ms being exported per-pmu, and also highlight how odd
it is to have a group of events from multiple pmus (given that should mean the
group can never be scheduled).

Based on commit 443772776c69 (perf: Disable all pmus on unthrottling and
rescheduling) I believe that pmus sharing a context is the expected behaviour,
but given the edge cases this series highlights I think it would make more
sense to disallow context sharing and allocate a unique context per-pmu instead
(which would also make ctx->pmu sane again). I'm happy to rework the series to
that effect if people agree with the approach.

Patch 4 of this series (be less pessimistic when scheduling events) can be
improved with some standardisation of error codes returned by pmu::add, but for
the moment I've kept myself away from the architecture backends.

The current heterogeneous pmu series based atop of this can be found on my
linux-arm git repo [1].

Patches are based on v3.14-rc1.

Thanks,
Mark.

[1] git://linux-arm.org/linux-mr.git devel/perf/multi-pmu

Mark Rutland (7):
  perf: fix prototype of find_pmu_context
  perf: remove redundant pmu assignment
  perf: kill perf_event_context_type
  perf: be less pessimistic when scheduling events
  perf: kill pmu::hrtimer_interval_ms
  perf: Centralise context pmu disabling
  perf: kill perf_event_context::pmu

 include/linux/perf_event.h |  10 +--
 kernel/events/core.c       | 162 +++++++++++++++++++++++----------------------
 2 files changed, 85 insertions(+), 87 deletions(-)

-- 
1.8.1.1

