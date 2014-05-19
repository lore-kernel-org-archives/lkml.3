Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932803AbaESTQL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 15:16:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59287 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932709AbaESTOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 15:14:41 -0400
From: Don Zickus <dzickus@redhat.com>
To: jolsa@redhat.com
Cc: acme@ghostprotocols.net, peterz@infradead.org,
        LKML <linux-kernel@vger.kernel.org>, namhyung@gmail.com,
        eranian@google.com, Andi Kleen <andi@firstfloor.org>,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 0/7 V3] x86, nmi: Various fixes and cleanups
Date: Mon, 19 May 2014 15:13:46 -0400
Message-Id: <1400526833-141779-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I started this patch by fixing a performance problem with the GHES
NMI handler and then things evolved to more patches as I was poking
around in the code.

The main focus was moving the GHES NMI driver to its own NMI subtype
to avoid slowing down perf handling.  Then I decided to move the
default external NMI handler to its own routine.  Then finally, I
needed to see which NMI handlers were registered so I hacked up
/proc/interrupts to show me.

Tested mostly on HP boxes that have GHES enabled and having the iLO
send NMIs to panic the box (using hpwdt driver).  Ran perf on other
GHES enabled boxes to test performance results.

Note: I haven't been able to reproduce Jiri's perf hang yet, so I don't
have a patch for that particular problem yet.

V3: added patch to get cacheline size at runtime
    updated some changelogs
    fix a test failure (after install libunwind-devel)
    fix header column length

V2: adding irq_work items to handled possible lost NMIs (new patch 1)
    modified output of /proc/interrupts based on feedback (patch 6)

Don Zickus (5):
  x86, nmi:  Add new nmi type 'external'
  x86, nmi: Add boot line option 'panic_on_unrecovered_nmi' and
    'panic_on_io_nmi'
  x86, nmi: Remove 'reason' value from unknown nmi output
  x86, nmi: Move default external NMI handler to its own routine
  x86, nmi: Add better NMI stats to /proc/interrupts and show handlers

 Documentation/kernel-parameters.txt |    9 ++
 arch/x86/include/asm/nmi.h          |    5 +
 arch/x86/kernel/irq.c               |    3 +
 arch/x86/kernel/nmi.c               |  199 ++++++++++++++++++++++++++--------
 drivers/acpi/apei/ghes.c            |    4 +-
 drivers/watchdog/hpwdt.c            |   24 +++--
 6 files changed, 187 insertions(+), 57 deletions(-)

*** BLURB HERE ***

Don Zickus (6):
  x86, nmi:  Implement delayed irq_work mechanism to handle lost NMIs
  x86, nmi:  Add new nmi type 'external'
  x86, nmi: Add boot line option 'panic_on_unrecovered_nmi' and
    'panic_on_io_nmi'
  x86, nmi: Remove 'reason' value from unknown nmi output
  x86, nmi: Move default external NMI handler to its own routine
  x86, nmi: Add better NMI stats to /proc/interrupts and show handlers

 Documentation/kernel-parameters.txt |    9 +
 arch/x86/include/asm/nmi.h          |    5 +
 arch/x86/kernel/irq.c               |    3 +
 arch/x86/kernel/nmi.c               |  302 +++++++++++++++++++++++++++++-----
 drivers/acpi/apei/ghes.c            |    4 +-
 drivers/watchdog/hpwdt.c            |   24 ++-
 6 files changed, 292 insertions(+), 55 deletions(-)

Don Zickus (7):
  events, perf: Pass protection and flags bits through mmap2 interface
  Revert "perf: Disable PERF_RECORD_MMAP2 support"
  perf: Update mmap2 interface with protection and flag bits
  perf report: Add mem-mode documentation to report command
  perf: Add cpumode to struct hist_entry
  perf: Add support to dynamically get cacheline size
  perf: Add dcacheline sort

 include/uapi/linux/perf_event.h          |   1 +
 kernel/events/core.c                     |  37 ++++++++--
 tools/perf/Documentation/perf-report.txt |  23 +++++++
 tools/perf/builtin-report.c              |   2 +-
 tools/perf/tests/dwarf-unwind.c          |   2 +-
 tools/perf/util/cpumap.c                 |  31 +++++++++
 tools/perf/util/cpumap.h                 |  12 ++++
 tools/perf/util/event.c                  |  59 ++++++++++------
 tools/perf/util/event.h                  |   2 +
 tools/perf/util/evsel.c                  |   1 +
 tools/perf/util/hist.c                   |   9 ++-
 tools/perf/util/hist.h                   |   1 +
 tools/perf/util/machine.c                |   4 +-
 tools/perf/util/map.c                    |   4 +-
 tools/perf/util/map.h                    |   4 +-
 tools/perf/util/sort.c                   | 112 +++++++++++++++++++++++++++++++
 tools/perf/util/sort.h                   |   2 +
 17 files changed, 275 insertions(+), 31 deletions(-)

-- 
1.7.11.7

