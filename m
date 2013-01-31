Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063Ab3AaR0i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 12:26:38 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48085 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843Ab3AaRZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 12:25:49 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andi Kleen <ak@linux.intel.com>, Anton Blanchard <anton@au1.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        linuxppc-dev@ozlabs.org, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        acme@ghostprotocols.net, Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 00/25] perf/core improvements and fixes
Date: Thu, 31 Jan 2013 14:25:03 -0300
Message-Id: <1359653128-10433-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Please consider pulling,

- Arnaldo

The following changes since commit 152fefa921535665f95840c08062844ab2f5593e:

  Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/core (2013-01-31 10:20:14 +0100)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo

for you to fetch changes up to 2ac3634a7e1c8eedc961030c87c5c36ebd5bbf8e:

  perf: Document the ABI of perf sysfs entries (2013-01-31 13:07:51 -0300)

----------------------------------------------------------------
perf/core improvements and fixes:

. Make some POWER7 events available in sysfs, equivalent to
  what was done on x86, from Sukadev Bhattiprolu.

. Add event group view, from Namyung Kim:

  To use it, 'perf record' should group events when recording. And then perf
  report parses the saved group relation from file header and prints them
  together if --group option is provided.  You can use 'perf evlist' command to
  see event group information:

    $ perf record -e '{ref-cycles,cycles}' noploop 1
    [ perf record: Woken up 2 times to write data ]
    [ perf record: Captured and wrote 0.385 MB perf.data (~16807 samples) ]

    $ perf evlist --group
    {ref-cycles,cycles}

  With this example, default perf report will show you each event
  separately like this:

    $ perf report
    ...
    # group: {ref-cycles,cycles}
    # ========
    # Samples: 3K of event 'ref-cycles'
    # Event count (approx.): 3153797218
    #
    # Overhead  Command      Shared Object                      Symbol
    # ........  .......  .................  ..........................
        99.84%  noploop  noploop            [.] main
         0.07%  noploop  ld-2.15.so         [.] strcmp
         0.03%  noploop  [kernel.kallsyms]  [k] timerqueue_del
         0.03%  noploop  [kernel.kallsyms]  [k] sched_clock_cpu
         0.02%  noploop  [kernel.kallsyms]  [k] account_user_time
         0.01%  noploop  [kernel.kallsyms]  [k] __alloc_pages_nodemask
         0.00%  noploop  [kernel.kallsyms]  [k] native_write_msr_safe

    # Samples: 3K of event 'cycles'
    # Event count (approx.): 3722310525
    #
    # Overhead  Command      Shared Object                     Symbol
    # ........  .......  .................  .........................
        99.76%  noploop  noploop            [.] main
         0.11%  noploop  [kernel.kallsyms]  [k] _raw_spin_lock
         0.06%  noploop  [kernel.kallsyms]  [k] find_get_page
         0.03%  noploop  [kernel.kallsyms]  [k] sched_clock_cpu
         0.02%  noploop  [kernel.kallsyms]  [k] rcu_check_callbacks
         0.02%  noploop  [kernel.kallsyms]  [k] __current_kernel_time
         0.00%  noploop  [kernel.kallsyms]  [k] native_write_msr_safe

  In this case the event group information will be shown in the end of
  header area.  So you can use --group option to enable event group view.

    $ perf report --group
    ...
    # group: {ref-cycles,cycles}
    # ========
    # Samples: 7K of event 'anon group { ref-cycles, cycles }'
    # Event count (approx.): 6876107743
    #
    #         Overhead  Command      Shared Object                      Symbol
    # ................  .......  .................  ..........................
        99.84%  99.76%  noploop  noploop            [.] main
         0.07%   0.00%  noploop  ld-2.15.so         [.] strcmp
         0.03%   0.00%  noploop  [kernel.kallsyms]  [k] timerqueue_del
         0.03%   0.03%  noploop  [kernel.kallsyms]  [k] sched_clock_cpu
         0.02%   0.00%  noploop  [kernel.kallsyms]  [k] account_user_time
         0.01%   0.00%  noploop  [kernel.kallsyms]  [k] __alloc_pages_nodemask
         0.00%   0.00%  noploop  [kernel.kallsyms]  [k] native_write_msr_safe
         0.00%   0.11%  noploop  [kernel.kallsyms]  [k] _raw_spin_lock
         0.00%   0.06%  noploop  [kernel.kallsyms]  [k] find_get_page
         0.00%   0.02%  noploop  [kernel.kallsyms]  [k] rcu_check_callbacks
         0.00%   0.02%  noploop  [kernel.kallsyms]  [k] __current_kernel_time

  As you can see the Overhead column now contains both of ref-cycles and
  cycles and header line shows group information also - 'anon group {
  ref-cycles, cycles }'.  The output is sorted by period of group leader
  first.

  If perf.data file doesn't contain group information, this --group
  option does nothing.  So if you want enable event group view by
  default you can set it in ~/.perfconfig file:

    $ cat ~/.perfconfig
    [report]
    group = true

  It can be overridden with command line if you want:

    $ perf report --no-group

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Arnaldo Carvalho de Melo (2):
      perf top: Stop using exit()
      perf top: Delete maps on exit

Namhyung Kim (18):
      perf tools: Keep group information
      perf tests: Add group test conditions
      perf header: Add HEADER_GROUP_DESC feature
      perf report: Make another loop for linking group hists
      perf hists: Resort hist entries using group members for output
      perf ui/hist: Consolidate hpp helpers
      perf hists browser: Convert hpp helpers to a function
      perf gtk/browser: Convert hpp helpers to a function
      perf ui/hist: Add support for event group view
      perf hists browser: Move coloring logic to hpp functions
      perf hists browser: Add suppport for event group view
      perf gtk/browser: Add support for event group view
      perf gtk/browser: Trim column header string when event group enabled
      perf report: Bypass non-leader events when event group is enabled
      perf report: Show group description when event group is enabled
      perf report: Add --group option
      perf report: Add report.group config option
      perf evlist: Add --group option

Sukadev Bhattiprolu (5):
      perf/Power7: Use macros to identify perf events
      perf: Make EVENT_ATTR global
      perf/POWER7: Make generic event translations available in sysfs
      perf/POWER7: Make some POWER7 events available in sysfs
      perf: Document the ABI of perf sysfs entries

 .../testing/sysfs-bus-event_source-devices-events  |  62 +++++
 arch/powerpc/include/asm/perf_event_server.h       |  26 ++
 arch/powerpc/perf/core-book3s.c                    |  12 +
 arch/powerpc/perf/power7-pmu.c                     |  80 +++++-
 arch/x86/kernel/cpu/perf_event.c                   |  13 +-
 include/linux/perf_event.h                         |  11 +
 tools/perf/Documentation/perf-evlist.txt           |   4 +
 tools/perf/Documentation/perf-report.txt           |   3 +
 tools/perf/builtin-evlist.c                        |   7 +
 tools/perf/builtin-record.c                        |   3 +
 tools/perf/builtin-report.c                        |  47 +++-
 tools/perf/builtin-top.c                           |  62 +++--
 tools/perf/tests/parse-events.c                    |  28 ++
 tools/perf/ui/browsers/hists.c                     | 217 ++++++++++++---
 tools/perf/ui/gtk/hists.c                          | 130 +++++++--
 tools/perf/ui/hist.c                               | 306 ++++++++++-----------
 tools/perf/ui/stdio/hist.c                         |   2 +
 tools/perf/util/evlist.c                           |   7 +-
 tools/perf/util/evlist.h                           |   1 +
 tools/perf/util/evsel.c                            |  49 +++-
 tools/perf/util/evsel.h                            |  16 ++
 tools/perf/util/header.c                           | 164 +++++++++++
 tools/perf/util/header.h                           |   2 +
 tools/perf/util/hist.c                             |  59 +++-
 tools/perf/util/parse-events.c                     |   1 +
 tools/perf/util/parse-events.h                     |   1 +
 tools/perf/util/parse-events.y                     |  10 +
 tools/perf/util/symbol.h                           |   3 +-
 28 files changed, 1059 insertions(+), 267 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-event_source-devices-events
