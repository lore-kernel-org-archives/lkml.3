Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093AbaBNWCd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 17:02:33 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:33693 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031AbaBNWCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 17:02:31 -0500
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Linux PPC <linuxppc-dev@lists.ozlabs.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH v2 00/11] powerpc: Add support for Power Hypervisor supplied performance counters
Date: Fri, 14 Feb 2014 14:02:04 -0800
Message-Id: <1392415338-16288-1-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.5.4
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021422-0320-0000-0000-000002781650
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

There is ongoing work to support transactions for each of these pmus.

These 2 PMUs end up providing access to some cpu, core, and chip level counters
not exposed via other interfaces, and additionally allow monitoring the
performance of other lpars (guests) on the same host system. Because it
provides access to core and chip level counters, this pair of PMUs could be
thought of as powerpc's counterpart to x86's uncore events.

As an example, "processor_bus_utilization_abc" and
"processor_bus_utilization_wxyz" (in hv_gpci.h) allow retreval of total cycles
and idle cycles for various inter-chip buses.

GPCI is an interface that already exists on some power6 and power7 machines
(depending on the fw version), but is rather in-flexible and code intensive to
add additional counters to.  The 24x7 interfaces currently are designed to
co-exist with the gpci interface while replacing most of gpci's functionality
on newer systems. Right now, the 24x7 code I've submitted uses the gpci calls
to check if it has permission to access certain classes of counters.

Example perf usage:

perf stat -e 'hv_gpci/counter_info_version=3,offset=0,length=8,secondary_index=0,starting_index=0xffffffff,request=0x10/' -r 0 -C 0 -x ' ' sleep 0.1

perf stat -e 'hv_24x7/domain=2,offset=8,starting_index=0,lpar=0xffffffff/' -r 0 -C 0 -x ' ' sleep 0.1

--

Changes since v1:
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
  perf: add PMU_RANGE_ATTR() helper for use by sw-like pmus
  perf core: export swevent hrtimer helpers
  sysfs: create bin_attributes under the requested group
  powerpc: add hvcalls for 24x7 and gpci (get performance counter info)
  powerpc: add hv_gpci interface header
  powerpc: add 24x7 interface header
  powerpc: add a shared interface to get gpci version and capabilities
  powerpc/perf: add support for the hv gpci (get performance counter
    info) interface
  powerpc/perf: add support for the hv 24x7 interface
  powerpc/perf: add kconfig option for hypervisor provided counters
  powerpc/perf/hv_{gpci,24x7}: add documentation of device attributes

 .../testing/sysfs-bus-event_source-devices-hv_24x7 |  22 +
 .../testing/sysfs-bus-event_source-devices-hv_gpci |  43 ++
 arch/powerpc/include/asm/hvcall.h                  |   5 +
 arch/powerpc/perf/Makefile                         |   2 +
 arch/powerpc/perf/hv-24x7.c                        | 491 +++++++++++++++++++
 arch/powerpc/perf/hv-24x7.h                        | 239 ++++++++++
 arch/powerpc/perf/hv-common.c                      |  39 ++
 arch/powerpc/perf/hv-common.h                      |  17 +
 arch/powerpc/perf/hv-gpci.c                        | 290 ++++++++++++
 arch/powerpc/perf/hv-gpci.h                        | 521 +++++++++++++++++++++
 arch/powerpc/platforms/Kconfig.cputype             |   6 +
 fs/sysfs/group.c                                   |   7 +-
 include/linux/perf_event.h                         |  22 +-
 kernel/events/core.c                               |   8 +-
 14 files changed, 1705 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-event_source-devices-hv_24x7
 create mode 100644 Documentation/ABI/testing/sysfs-bus-event_source-devices-hv_gpci
 create mode 100644 arch/powerpc/perf/hv-24x7.c
 create mode 100644 arch/powerpc/perf/hv-24x7.h
 create mode 100644 arch/powerpc/perf/hv-common.c
 create mode 100644 arch/powerpc/perf/hv-common.h
 create mode 100644 arch/powerpc/perf/hv-gpci.c
 create mode 100644 arch/powerpc/perf/hv-gpci.h

-- 
1.8.5.4

