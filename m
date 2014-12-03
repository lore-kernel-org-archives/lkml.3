Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556AbaLCCEU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 21:04:20 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:41720 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaLCCER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 21:04:17 -0500
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Michael Ellerman <michaele@au1.ibm.com>,
        Paul Mackerras <paulus@samba.org>
Cc: dev@codyps.com, peterz@infradead.org, hbabu@us.ibm.com,
        <linux-kernel@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v5 0/6]: Make 24x7 and GPCI events available in sysfs
Date: Tue,  2 Dec 2014 18:03:49 -0800
Message-Id: <1417572235-8197-1-git-send-email-sukadev@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120302-0025-0000-0000-0000069349B1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current support for the 24x7 and GPCI counters in the kernel requires
users to specify the domain and offset of the event numerically, which is
obviously hard to use:

    perf stat -C 0 -e	\
        'hv_24x7/domain=2,offset=0xd58,starting_index=0,lpar=0xffffffff/' \
	sleep 1

This patchset exports the 24x7 and GPCI counters info in sysfs so users can
specify the events by name:

    $ cd /sys/bus/event_source/devices/hv_24x7/events

    $ cat HPM_CS_FROM_L4_LDATA__PHYS_CORE
    domain=0x2,offset=0xd58,starting_index=$core,lpar=0x0

    $ cat HPM_TLBIE__VCPU_HOME_CHIP
    domain=0x4,offset=0x358,starting_index=$vcpu,lpar=$sibling_guest_id

    perf stat -C 0 -e \
        'hv_24x7/HPM_CS_FROM_L4_LDATA__PHYS_CORE,starting_index=0'
        sleep 1

This patchset adds the kernel support to export events in sysfs.  A follow-on
patchset will add support to the perf tool to parse the event parameters like
'lpar=$sibling_guest_id' and display them via 'perf list'.

Changelog[v5]
	- [Jiri Olsa, Peter Zijlstra] Use '$arg' notation rather than ?
	  to indicate event parameters.
	- [Michael Ellerman] Separate the kernel and tool patches in the
	  patchset into different patchsets.

Changelog[v4]
	- [Jiri Olsa Rebase to perf/core tree to fix small merge conflict.

Changelog[v3]
        - [Jiri Olsa] Changed the event parameters are specified. If
          event file specifes 'param=val' make the usage 'param=123'
          rather than 'val=123'. (patch 1,2/10)
        - Shortened event names using "PHYS" and "VCPU" (patch 4/10)
        - Print help message if invalid parameter is specified or required
          parameter is missing.
        - Moved 3 patches that are unrelated to parametrized events into
          a separate patchset.
        - Reordered patches so code changes come first.

Changelog[v2]
        - [Joe Perches, David Laight] Use beNN_to_cpu() instead of guessing
          the size from type.
        - Use kmem_cache_free() to free page allocated with kmem_cache_alloc().
        - Rebase to recent kernel


Cody P Schafer (6):
  perf: provide sysfs_show for struct perf_pmu_events_attr
  perf: add PMU_EVENT_ATTR_STRING() helper
  powerpc/perf/hv-24x7: parse catalog and populate sysfs with events
  powerpc/perf/{hv-gpci, hv-common}: generate requests with counters
    annotated
  powerpc/perf/hv-gpci: add the remaining gpci requests
  powerpc/perf/hv-24x7: Document sysfs event description entries

 .../testing/sysfs-bus-event_source-devices-hv_24x7 |  22 +
 arch/powerpc/perf/hv-24x7-catalog.h                |  25 +
 arch/powerpc/perf/hv-24x7-domains.h                |  28 +
 arch/powerpc/perf/hv-24x7.c                        | 787 ++++++++++++++++++++-
 arch/powerpc/perf/hv-24x7.h                        |  12 +-
 arch/powerpc/perf/hv-common.c                      |  10 +-
 arch/powerpc/perf/hv-gpci-requests.h               | 262 +++++++
 arch/powerpc/perf/hv-gpci.c                        |   8 +
 arch/powerpc/perf/hv-gpci.h                        |  37 +-
 arch/powerpc/perf/req-gen/_begin.h                 |  13 +
 arch/powerpc/perf/req-gen/_clear.h                 |   5 +
 arch/powerpc/perf/req-gen/_end.h                   |   4 +
 arch/powerpc/perf/req-gen/_request-begin.h         |  15 +
 arch/powerpc/perf/req-gen/_request-end.h           |   8 +
 arch/powerpc/perf/req-gen/perf.h                   | 155 ++++
 include/linux/perf_event.h                         |  10 +
 kernel/events/core.c                               |   8 +
 17 files changed, 1365 insertions(+), 44 deletions(-)
 create mode 100644 arch/powerpc/perf/hv-24x7-domains.h
 create mode 100644 arch/powerpc/perf/hv-gpci-requests.h
 create mode 100644 arch/powerpc/perf/req-gen/_begin.h
 create mode 100644 arch/powerpc/perf/req-gen/_clear.h
 create mode 100644 arch/powerpc/perf/req-gen/_end.h
 create mode 100644 arch/powerpc/perf/req-gen/_request-begin.h
 create mode 100644 arch/powerpc/perf/req-gen/_request-end.h
 create mode 100644 arch/powerpc/perf/req-gen/perf.h

-- 
1.8.3.1

