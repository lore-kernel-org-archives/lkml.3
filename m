Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587AbaJVP3b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:29:31 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:53672 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212AbaJVP33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:29:29 -0400
From: Robert Bragg <robert@sixbynine.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Rob Clark <robdclark@gmail.com>,
        Samuel Pitoiset <samuel.pitoiset@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>, Robert Bragg <robert@sixbynine.org>
Subject: [RFC PATCH 0/3] Expose gpu counters via perf pmu driver
Date: Wed, 22 Oct 2014 16:28:48 +0100
Message-Id: <1413991731-20628-1-git-send-email-robert@sixbynine.org>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although I haven't seen any precedent for drivers using perf pmus to
expose device metrics, I've been experimenting with exposing some of the
performance counters of Intel Gen graphics hardware recently and looking
to see if it makes sense to build on the perf infrastructure for our use
cases.

I've got a basic pmu driver working to expose our Observation
Architecture counters, and it seems like a fairly good fit. The main
caveat is that to allow the permission model we would like I needed to
make some changes in events/core which I'd really appreciate some
feedback on...

In this case we're using the driver to support some performance
monitoring extensions in Mesa (AMD_performance_monitor +
INTEL_performance_query) and we don't want to require OpenGL clients to
run as root to be able to monitor a gpu context they own.

Our desired permission model seems consistent with perf's current model
whereby you would need privileges if you want to profile across all gpu
contexts but not need special permissions to profile your own context.

The awkward part is that it doesn't make sense for us to have userspace
open a perf event with a specific pid as the way to avoid needing root
permissions because a side effect of doing this is that the events will
be dynamically added/deleted so as to only monitor while that process is
scheduled and that's not really meaningful when we're monitoring the
gpu.

Conceptually I suppose we want to be able to open an event that's not
associated with any cpu or process, but to keep things simple and fit
with perf's current design, the pmu I have a.t.m expects an event to be
opened for a specific cpu and unspecified process.

To then subvert the cpu centric permission checks, I added a
PERF_PMU_CAP_IS_DEVICE capability that a pmu driver can use to tell
events/core that a pmu doesn't collect any cpu metrics and it can
therefore skip its usual checks and assume the driver will implement its
own checks as appropriate.

In addition I also explicitly black list numerous attributes and
PERF_SAMPLE_ flags that I don't think make sense for a device pmu. This
could be handled in the pmu driver but it seemed better to do in
events/core, avoiding duplication in case we later have multiple device
pmus.

I'd be interested to hear whether is sounds reasonable to others for us
to expose gpu device metrics via a perf pmu and whether adding the
PERF_PMU_CAP_IS_DEVICE flag as in my following patch could be
acceptable.

Patches:

[RFC PATCH 1/3] perf: export perf_event_overflow
[RFC PATCH 2/3] perf: Add PERF_PMU_CAP_IS_DEVICE flag
  The main change to core/events I'd really appreciate feedback on.

[RFC PATCH 3/3] i915: Expose PMU for Observation Architecture
  My current pmu driver, provided for context (work in progress). Early,
  high-level, feedback would be appreciated, though I think it could be
  good to focus on the core/events change first. I also plan to send
  this to the intel-gfx list for review.

  Essentially, this pmu allows us to configure the gpu to periodically
  write snapshots of performance counters (up to 64 32bit counters per
  snapshot) into a circular buffer. It then uses a 200Hz hrtimer to
  forward those snapshots to userspace as perf samples, with the counter
  snapshots written by the gpu attached as 'raw' data.

If anyone is interested in more details about Haswell's gpu performance
counters, the PRM can be found here:

  https://01.org/linuxgraphics/sites/default/files/documentation/
  observability_performance_counters_haswell.pdf

To see how I'm currently using this from userspace, I have a couple of
intel-gpu-tools utilities; intel_oacounter_top_pmu + intel_gpu_trace_pmu:

  https://github.com/rib/intel-gpu-tools/commits/wip/rib/intel-i915-oa-pmu

And the current code I have to use this in Mesa is here:

  https://github.com/rib/mesa/commits/wip/rib/i915_oa_perf

Regards,
- Robert

 drivers/gpu/drm/i915/Makefile       |   1 +
 drivers/gpu/drm/i915/i915_dma.c     |   2 +
 drivers/gpu/drm/i915/i915_drv.h     |  33 ++
 drivers/gpu/drm/i915/i915_oa_perf.c | 675 ++++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/i915/i915_reg.h     |  87 +++++
 include/linux/perf_event.h          |   1 +
 include/uapi/drm/i915_drm.h         |  21 ++
 kernel/events/core.c                |  40 ++-
 8 files changed, 854 insertions(+), 6 deletions(-)
 create mode 100644 drivers/gpu/drm/i915/i915_oa_perf.c

-- 
2.1.2

