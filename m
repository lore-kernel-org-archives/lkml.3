Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397AbaCFABy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 19:01:54 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:57383 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757169AbaCFABv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 19:01:51 -0500
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Linux PPC <linuxppc-dev@lists.ozlabs.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <michael@ellerman.id.au>, scottwood@freescale.com,
        Peter Zijlstra <peterz@infradead.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH v4 00/11] powerpc: Add support for Power Hypervisor supplied performance counters
Date: Wed,  5 Mar 2014 16:00:59 -0800
Message-Id: <1394064082-6242-1-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.0
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14030600-5806-0000-0000-000024488EF6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches add basic pmus for 2 powerpc hypervisor interfaces to obtain
performance counters: gpci ("get performance counter info") and 24x7.

The counters supplied by these interfaces are continually counting and never
need to be (and cannot be) disabled or enabled. They additionally do not
generate any interrupts. This makes them in some regards similar to software
counters, and as a result their implimentation shares some common code (which
an initial patch exposes) with the sw counters.

These 2 PMUs end up providing access to some cpu, core, and chip level counters
not exposed via other interfaces, and additionally allow monitoring the
performance of other lpars (guests) on the same host system. Because it
provides access to core and chip level counters, this pair of PMUs could be
thought of as powerpc's counterpart to x86's uncore events.

GPCI is an interface that already exists on some power6 and power7 machines
(depending on the fw version), but is rather in-flexible and code intensive to
add additional counters to.  The 24x7 interfaces currently are designed to
co-exist with the gpci interface while replacing most of gpci's functionality
on newer systems. Right now, the 24x7 code I've submitted uses the gpci calls
to check if it has permission to access certain classes of counters.

--

Since v3:
 - PMU_FORMAT_RANGE*()
	- add BUILD_BUG_ON() invalid bit indexes
	- rename event_get_##name(ev) to format_get(name, ev) [Michael Ellerman]
	- similarly, rename event_get_##name##_max() to format_max(name)
	  [Michael Ellerman]
	- fix format_max() [Michael Ellerman]

Since v2:
 - "sysfs: create bin_attributes under the requested group" is now in
	git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git driver-core-next
	with commit-id: aabaf4c2050d21d39fe11eec889c508e84d6a328

 - Split hv-24x7.h catalog definition into hv-24x7-catalog.h
 - Remove unused 24x7 and gpci interface structures and enums (Michael Ellerman)
 - Update docs to point to an external source for the full catalog docs
 - Extend some of the patch changelogs (Peter Z)
 - Remove hrtimer usage and just extern the event_idx helper (now renamed) (Peter Z)
 - s/PMU_RANGE_ATTR/PMU_FORMAT_RANGE/ (and similar RESERVED rename) (Michael
   Ellerman)
 - hv_24x7: small clarifications in read_offset_data()'s comment
 - hv_gpci: remove h_gpci_event_read() and h_gpci_event_del(), call _stop and
   _update() directly (Michael Ellerman)
 - Kconfig relocation, dependency changes, and rewording (Scott Wood and
   Michael Ellerman)

Since v1:
 - add a few attributes to hv_gpci and hv_24x7 that expose some info about the interfaces
 - so the attributes show up in the right place, fix bin_attr creation in sysfs groups.
 - move hv_gpci.h and hv_24x7.h interface headers into arch/powerpc/perf
 - fix bit ordering in hv_gpci.h
 - split out hv_perf_caps_get() and use it to probe for the interface before registering
 - ensure proper alignment of hypervisor args
 - add a few missing counter requests to hv_gpci.h
 - s/CIR_xxx/CIR_XXX/ in hv_gpci.h
 - s/modules_init/device_initcall/
 - Don't set event->cpu, use the user provided one
 - remove the union of gpci events, just give the user 1024 bytes to play with
 - clarify some comments (the list of fw versions is now labeled)
 - provide and event_24x7_request() that wraps single_24x7_request()
 - probably some other small fixes I'm forgetting.


Cody P Schafer (11):
  sysfs: create bin_attributes under the requested group
  perf: add PMU_FORMAT_RANGE() helper for use by sw-like pmus
  perf: provide a common perf_event_nop_0() for use with .event_idx
  powerpc: add hvcalls for 24x7 and gpci (get performance counter info)
  powerpc/perf: add hv_gpci interface header
  powerpc/perf: add 24x7 interface headers
  powerpc/perf: add a shared interface to get gpci version and
    capabilities
  powerpc/perf: add support for the hv gpci (get performance counter
    info) interface
  powerpc/perf: add support for the hv 24x7 interface
  powerpc/perf: add kconfig option for hypervisor provided counters
  powerpc/perf/hv_{gpci,24x7}: add documentation of device attributes

 .../testing/sysfs-bus-event_source-devices-hv_24x7 |  23 +
 .../testing/sysfs-bus-event_source-devices-hv_gpci |  43 ++
 arch/powerpc/include/asm/hvcall.h                  |   5 +
 arch/powerpc/perf/Makefile                         |   2 +
 arch/powerpc/perf/hv-24x7-catalog.h                |  33 ++
 arch/powerpc/perf/hv-24x7.c                        | 493 +++++++++++++++++++++
 arch/powerpc/perf/hv-24x7.h                        | 109 +++++
 arch/powerpc/perf/hv-common.c                      |  39 ++
 arch/powerpc/perf/hv-common.h                      |  17 +
 arch/powerpc/perf/hv-gpci.c                        | 277 ++++++++++++
 arch/powerpc/perf/hv-gpci.h                        |  73 +++
 arch/powerpc/platforms/pseries/Kconfig             |  12 +
 fs/sysfs/group.c                                   |   7 +-
 include/linux/perf_event.h                         |  24 +
 kernel/events/core.c                               |  10 +-
 15 files changed, 1160 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-event_source-devices-hv_24x7
 create mode 100644 Documentation/ABI/testing/sysfs-bus-event_source-devices-hv_gpci
 create mode 100644 arch/powerpc/perf/hv-24x7-catalog.h
 create mode 100644 arch/powerpc/perf/hv-24x7.c
 create mode 100644 arch/powerpc/perf/hv-24x7.h
 create mode 100644 arch/powerpc/perf/hv-common.c
 create mode 100644 arch/powerpc/perf/hv-common.h
 create mode 100644 arch/powerpc/perf/hv-gpci.c
 create mode 100644 arch/powerpc/perf/hv-gpci.h

-- 
1.9.0

