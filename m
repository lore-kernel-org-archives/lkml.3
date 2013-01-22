Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab3AVJK1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 04:10:27 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:60773 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462Ab3AVJKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 04:10:23 -0500
X-AuditID: 9c930197-b7ca4ae000006ba8-96-50fe575e7cc8
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 00/19] perf report: Add support for event group view (v9)
Date: Tue, 22 Jan 2013 18:09:28 +0900
Message-Id: <1358845787-1350-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is a 9th attempt to enable event group view support to perf report.

The basic idea is link group member's hist entries to a leader so that
they can be shown with leader's output together. The output is sorted
by the leader's period and in turn first group member's and so on.

To use it, 'perf record' should group events when recording. And then
perf report parses the saved group relation from file header and
prints them together if --group option is provided.  You can use 'perf
evlist' command to see event group information:

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
  #
  # Samples: 3K of event 'ref-cycles'
  # Event count (approx.): 3153797218
  #
  # Overhead  Command      Shared Object                      Symbol
  # ........  .......  .................  ..........................
  #
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
  #
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
  #
  # Samples: 7K of event 'anon group { ref-cycles, cycles }'
  # Event count (approx.): 6876107743
  #
  #         Overhead  Command      Shared Object                      Symbol
  # ................  .......  .................  ..........................
  #
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


You can also get this on my 'perf/group-v9' branch in

  git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git


Any comments are welcome, thanks.
Namhyung


Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Pekka Enberg <penberg@kernel.org>


v8 -> v9:
 * split patches have multiple changes (Arnaldo)
 * add --group option to perf evlist (Arnaldo)

v7 -> v8:
 * rebase onto acme/perf/core
 * patch 3 in the previous version is merged
 * add Jiri's Acked-by's

v6 -> v7:
 * hists__{match,link} changes are merged separately
 * factor out inc_group_count() from parsing group_def (Jiri)
 * add checking for group fields in evlist/evsel (Jiri)
 * check return value of during header processing (Arnaldo)
 * get rid of a temporal array in hpp functions (Arnaldo)
 * convert hpp macros to static inline functions (Jiri)

v5 -> v6:
 * set ->leader alse for leader evsel (Arnaldo)
 * use hists__{match,link} (Arnaldo)

v4 -> v5:
 * rebase onto acme/perf/core

v3 -> v4:
 * patch 1-9 in previous post are merged.
 * add Jiri's Acked-by
 * add report.group config option

v2 -> v3:
 * drop patch 1 since it's merged into acme/perf/core
 * cherry-pick Jiri's hpp changes
 * add missing bswap_32 on reading nr_groups (Jiri)
 * remove perf_evlist__recalc_nr_groups() in favor of list_is_last (Jiri)

v1 -> v2:
 * save group relation to header (Jiri)


Namhyung Kim (19):
  perf tools: Keep group information
  perf tests: Add group test conditions
  perf header: Add HEADER_GROUP_DESC feature
  perf report: Make another loop for linking group hists
  perf hists: Resort hist entries using group members for output
  perf ui/hist: Consolidate hpp helpers
  perf hist browser: Convert hpp helpers to a function
  perf gtk/browser: Convert hpp helpers to a function
  perf ui/hist: Add support for event group view
  perf hist browser: Move coloring logic to hpp functions
  perf hist browser: Add suppport for event group view
  perf gtk/browser: Add support for event group view
  perf tools: Move ltrim() to util/string.c
  perf gtk/browser: Trim column header string when event group enabled
  perf report: Bypass non-leader events when event group is enabled
  perf report: Show group description when event group is enabled
  perf report: Add --group option
  perf report: Add report.group config option
  perf evlist: Add --group option

 tools/perf/Documentation/perf-evlist.txt |   4 +
 tools/perf/Documentation/perf-report.txt |   3 +
 tools/perf/builtin-evlist.c              |   7 +
 tools/perf/builtin-record.c              |   3 +
 tools/perf/builtin-report.c              |  47 ++++-
 tools/perf/builtin-script.c              |  12 --
 tools/perf/tests/parse-events.c          |  28 +++
 tools/perf/ui/browsers/hists.c           | 217 ++++++++++++++++++----
 tools/perf/ui/gtk/hists.c                | 130 ++++++++++---
 tools/perf/ui/hist.c                     | 306 +++++++++++++++----------------
 tools/perf/ui/stdio/hist.c               |   2 +
 tools/perf/util/evlist.c                 |   7 +-
 tools/perf/util/evlist.h                 |   1 +
 tools/perf/util/evsel.c                  |  49 ++++-
 tools/perf/util/evsel.h                  |  16 ++
 tools/perf/util/header.c                 | 164 +++++++++++++++++
 tools/perf/util/header.h                 |   2 +
 tools/perf/util/hist.c                   |  59 +++++-
 tools/perf/util/parse-events.c           |   1 +
 tools/perf/util/parse-events.h           |   1 +
 tools/perf/util/parse-events.y           |  10 +
 tools/perf/util/string.c                 |  18 ++
 tools/perf/util/symbol.h                 |   3 +-
 tools/perf/util/util.h                   |   1 +
 24 files changed, 855 insertions(+), 236 deletions(-)

-- 
1.7.11.7

