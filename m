Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775AbaE1A0P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 20:26:15 -0400
Received: from mail-yk0-f177.google.com ([209.85.160.177]:63554 "EHLO
	mail-yk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731AbaE1A0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 20:26:12 -0400
From: Cody P Schafer <dev@codyps.com>
To: LKML <linux-kernel@vger.kernel.org>,
        Linux PPC <linuxppc-dev@lists.ozlabs.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Borislav Petkov <bp@suse.de>, Cody P Schafer <dev@codyps.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Michael Ellerman <mpe@ellerman.id.au>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Runzhen Wang <runzhen@linux.vnet.ibm.com>,
        Stephane Eranian <eranian@google.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: linux-doc@vger.kernel.org
Subject: [PATCH 00/16] perf: add support for parameterized events from sysfs (powerpc 24x7)
Date: Tue, 27 May 2014 17:21:55 -0700
Message-Id: <1401236684-10579-1-git-send-email-dev@codyps.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

	Some pmu events listed by 'perf-list' will be displayed with '?' in them. For
	example:

	  hv_gpci/dtbp_ptitc,phys_processor_idx=?/

	This means that when provided as an event, a value for phys_processor_idx must
	also be supplied. For example:

	  perf stat -e 'hv_gpci/dtbp_ptitc,phys_processor_idx=0x2/' ...


Cody P Schafer (16):
  tools/perf: allow overriding sysfs and proc finding with env var
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
  byteorder: provide a linux/byteorder.h with {be,le}_to_cpu() and
    cpu_to_{be,le}() macros
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
 arch/powerpc/perf/hv-24x7.c                        | 812 ++++++++++++++++++++-
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
 include/linux/byteorder.h                          |  34 +
 include/linux/perf_event.h                         |  10 +
 kernel/events/core.c                               |   8 +
 tools/lib/api/fs/fs.c                              |  43 +-
 tools/perf/Documentation/perf-list.txt             |  13 +
 tools/perf/Documentation/perf-record.txt           |   5 +
 tools/perf/util/parse-events.h                     |   1 +
 tools/perf/util/pmu.c                              |  85 ++-
 tools/perf/util/pmu.h                              |   6 +-
 25 files changed, 1589 insertions(+), 636 deletions(-)
 create mode 100644 arch/powerpc/perf/hv-24x7-domains.h
 create mode 100644 arch/powerpc/perf/hv-gpci-requests.h
 create mode 100644 arch/powerpc/perf/req-gen/_begin.h
 create mode 100644 arch/powerpc/perf/req-gen/_clear.h
 create mode 100644 arch/powerpc/perf/req-gen/_end.h
 create mode 100644 arch/powerpc/perf/req-gen/_request-begin.h
 create mode 100644 arch/powerpc/perf/req-gen/_request-end.h
 create mode 100644 arch/powerpc/perf/req-gen/perf.h
 create mode 100644 include/linux/byteorder.h

-- 
1.9.3

