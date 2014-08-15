Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422AbaHOH0a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 03:26:30 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:34775 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054AbaHOH03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 03:26:29 -0400
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, ak@linux.intel.com,
        Jiri Olsa <jolsa@redhat.com>, peterz@infradead.org, eranian@google.com
Cc: dev@codyps.com, Michael Ellerman <michaele@au1.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        <linux-kernel@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 00/14] Add support for parameterized events from sysfs
Date: Fri, 15 Aug 2014 00:26:09 -0700
Message-Id: <1408087583-32239-1-git-send-email-sukadev@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081507-7182-0000-0000-000000359F8B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cody P Schafer <dev@codyps.com>

What this patchset does:

 - the first patch (override sysfs in tools/perf via SYSFS_PATH) was sent out
   previously, but needed a resend anyhow. Having it is useful for testing the
   later changes to tools/perf.
 - the second patch is a bugfix to the powerpc hv-24x7 code which was
   previously sent out, which is a good idea to have when testing these patches
   on POWER8 hardware.

 - document perf sysfs and the changes to add parameterized events
   - semi-notably: removes the growing list of specific POWER cpu events and
     begins documenting them generically, much like the docs for
     /sys/modules/MODULENAME do for modules.
 - tools/perf changes to support parameterized events
 - export some parameterized events from the powerpc pmus hv_24x7 and hv_gpci

Description of "event parameters" from the documentation patch:

    Event parameters are a basic way for partial events to be specified in
    sysfs with per-event names given to the fields that need to be filled in
    when using a particular event.

    It is intended for supporting cases where the single 'cpu' parameter is
    insufficient. For example, POWER 8 has events for physical
    sockets/cores/cpus that are accessible from with virtual machines. To
    keep using the single 'cpu' parameter we'd need to perform a mapping
    between Linux's cpus and the physical machine's cpus (in this case
    Linux is running under a hypervisor). This isn't possible because
    bindings between our cpus and physical cpus may not be fixed, and we
    probably won't have a "cpu" on each physical cpu.

Description of the sysfs contents when events are parameterized (copied from an
included patch):

	Examples:

		domain=0x1,offset=0x8,starting_index=phys_cpu

	In the case of the last example, a value replacing "phys_cpu"
	would need to be provided by the user selecting the particular
	event. This is refered to as "event parameterization". All
	non-numerical values indicate an event parameter.

Notes on how perf-list displays parameterized events (and how to use them,
again culled from an included patch):

	PARAMETERIZED EVENTS
	--------------------

	Some pmu events listed by 'perf-list' will be displayed with '?' in
	them. For example:

	  hv_gpci/dtbp_ptitc,phys_processor_idx=?/

	This means that when provided as an event, a value for
	phys_processor_idx must also be supplied. For example:

	  perf stat -e 'hv_gpci/dtbp_ptitc,phys_processor_idx=0x2/' ...

Changelog[v2]
	- [Joe Perches, David Laight] Use beNN_to_cpu() instead of guessing
	  the size from type.
	- Use kmem_cache_free() to free page allocated with kmem_cache_alloc().
	- Rebase to recent kernel

Cody P Schafer (14):
  powerpc/perf/hv-24x7: use kmem_cache instead of aligned stack
    allocations
  perf Documentation: sysfs events/ interfaces
  perf Documentation: remove duplicated docs for powerpc cpu specific
    events
  perf Documentation: add event parameters
  tools/perf: annotate list_head with type info
  tools/perf: support parsing parameterized events
  tools/perf: extend format_alias() to include event parameters
  tools/perf: document parameterized events and note symbolically formed
    events
  perf: provide sysfs_show for struct perf_pmu_events_attr
  powerpc/perf/hv-24x7: parse catalog and populate sysfs with events
  powerpc/perf/hv-24x7: Documentaion for new sysfs entries which expose
    descriptions
  perf: add PMU_EVENT_ATTR_STRING() helper
  powerpc/perf/{hv-gpci,hv-common}: generate requests with counters
    annotated
  powerpc/perf/hv-gpci: add the remaining gpci requests

 .../testing/sysfs-bus-event_source-devices-events  | 617 ++--------------
 .../testing/sysfs-bus-event_source-devices-hv_24x7 |  22 +
 arch/powerpc/perf/hv-24x7-catalog.h                |  25 +
 arch/powerpc/perf/hv-24x7-domains.h                |  19 +
 arch/powerpc/perf/hv-24x7.c                        | 816 ++++++++++++++++++++-
 arch/powerpc/perf/hv-24x7.h                        |  12 +-
 arch/powerpc/perf/hv-common.c                      |  10 +-
 arch/powerpc/perf/hv-gpci-requests.h               | 258 +++++++
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
 tools/perf/Documentation/perf-list.txt             |  13 +
 tools/perf/Documentation/perf-record.txt           |   5 +
 tools/perf/util/parse-events.h                     |   1 +
 tools/perf/util/pmu.c                              |  85 ++-
 tools/perf/util/pmu.h                              |   6 +-
 23 files changed, 1515 insertions(+), 637 deletions(-)
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

