Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810AbaANF0E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 00:26:04 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:46794 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbaANF0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 00:26:00 -0500
X-AuditID: 9c93016f-b7b1aae000000f15-83-52d4ca663d09
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Andi Kleen <andi@firstfloor.org>,
        Arun Sharma <asharma@fb.com>, Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCHSET 00/24] perf tools: Add support to accumulate hist periods (v6)
Date: Tue, 14 Jan 2014 14:25:33 +0900
Message-Id: <1389677157-30513-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is a new attempt to implement cumulative hist period report.
This work begins from Arun's SORT_INCLUSIVE patch [1] but I completely
rewrote it from scratch.

This patchset is based on my previous patchset [2] but I think it's
almost independent so that it can be applied separately.

Please see the patch 03/24.  I refactored functions that add hist
entries with struct hist_entry_iter.  While I converted all functions
carefully, it'd be better anyone can test and confirm that I didn't
mess up something - especially for branch stack and mem stuff.

This patchset basically adds period in a sample to every node in the
callchain.  A hist_entry now has an additional fields to keep the
cumulative period if --children option is given on perf report.

I changed the option as a separate --children and added a new
"Children" column (and renamed the default "Overhead" column into
"Self").  The output will be sorted by children (cumulative) overhead
for now.  The reason I changed to the --children is that I still think
it's much different from other --call-graph options.  The --call-graph
option will take care of it even with --children option.

I know that the UI should be changed also to be more flexible as Ingo
requested, but I'd like to do this first and then move to work on the
next.  I also added a new config option to enable it by default.

 * changes in v6:
  - separate struct hist_iter_ops (Jiri)
  - check iter->he before calling ->add_entry_cb (Jiri)
  - fix locking issue on perf top (Jiri)

 * changes in v5:
  - support both of --children and --call-graph (Arun)
  - refactor hist_entry_iter to share with perf top (Jiri)
  - various cleanups and fixes (Jiri)
  - add ack's from Jiri

 * changes in v4:
  - change to --children option (Ingo)
  - rebased on new annotation change (Arnaldo)
  - support perf top also
  - enable --children option by default (Ingo)

 * changes in v3:
  - change to --cumulate option
  - fix a couple of bugs (Jiri, Rodrigo)
  - rename some help functions (Arnaldo)
  - cache previous hist entries rathen than just symbol and dso
  - add some preparatory cleanups
  - add report.cumulate config option


Let me show you an example:

  $ cat abc.c
  #define barrier() asm volatile("" ::: "memory")

  void a(void)
  {
  	int i;
  	for (i = 0; i < 1000000; i++)
  		barrier();
  }
  void b(void)
  {
  	a();
  }
  void c(void)
  {
  	b();
  }
  int main(void)
  {
  	c();
  	return 0;
  }

With this simple program I ran perf record and report:

  $ perf record -g -e cycles:u ./abc


Case 1.

  $ perf report --stdio --no-call-graph --no-children

  # Overhead  Command      Shared Object          Symbol
  # ........  .......  .................  ..............
  #
      91.50%      abc  abc                [.] a         
       8.18%      abc  ld-2.17.so         [.] strlen    
       0.31%      abc  [kernel.kallsyms]  [k] page_fault
       0.01%      abc  ld-2.17.so         [.] _start    


Case 2. (current default behavior)

  $ perf report --stdio --call-graph --no-children

  # Overhead  Command      Shared Object          Symbol
  # ........  .......  .................  ..............
  #
      91.50%      abc  abc                [.] a         
                  |
                  --- a
                      b
                      c
                      main
                      __libc_start_main

       8.18%      abc  ld-2.17.so         [.] strlen    
                  |
                  --- strlen
                      _dl_sysdep_start

       0.31%      abc  [kernel.kallsyms]  [k] page_fault
                  |
                  --- page_fault
                      _start

       0.01%      abc  ld-2.17.so         [.] _start    
                  |
                  --- _start


Case 3.

  $ perf report --no-call-graph --children --stdio

  #     Self  Children  Command      Shared Object                 Symbol
  # ........  ........  .......  .................  .....................
  #
       0.00%    91.50%      abc  libc-2.17.so       [.] __libc_start_main
       0.00%    91.50%      abc  abc                [.] main             
       0.00%    91.50%      abc  abc                [.] c                
       0.00%    91.50%      abc  abc                [.] b                
      91.50%    91.50%      abc  abc                [.] a                
       0.00%     8.18%      abc  ld-2.17.so         [.] _dl_sysdep_start 
       8.18%     8.18%      abc  ld-2.17.so         [.] strlen           
       0.01%     0.33%      abc  ld-2.17.so         [.] _start           
       0.31%     0.31%      abc  [kernel.kallsyms]  [k] page_fault       

As you can see __libc_start_main -> main -> c -> b -> a callchain show
up in the output.

Finally, it looks like below with both option enabled:

Case 4. (default behavior?)

  $ perf report --call-graph --children --stdio

  #     Self  Children  Command      Shared Object                 Symbol
  # ........  ........  .......  .................  .....................
  #
       0.00%    91.50%      abc  libc-2.17.so       [.] __libc_start_main
                  |
                  --- __libc_start_main

       0.00%    91.50%      abc  abc                [.] main             
                  |
                  --- main
                      __libc_start_main

       0.00%    91.50%      abc  abc                [.] c                
                  |
                  --- c
                      main
                      __libc_start_main

       0.00%    91.50%      abc  abc                [.] b                
                  |
                  --- b
                      c
                      main
                      __libc_start_main

      91.50%    91.50%      abc  abc                [.] a                
                  |
                  --- a
                      b
                      c
                      main
                      __libc_start_main
  ...


Currently the perf enables both of --call-graph and --children when it
finds callchains in the samples.  While this is useful for TUI or GTK,
I'm not sure for stdio as it'd consume so much lines.

It does not handle all kind of cases like event groups and annotations
yet, but I really want to release it and get reviews.

You can also get this series on 'perf/cumulate-v6' branch in my tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git


Any comments are welcome, thanks.
Namhyung


Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>

[1] https://lkml.org/lkml/2012/3/31/6
[2] https://lkml.org/lkml/2014/1/13/1122


Namhyung Kim (24):
  perf tools: Remove symbol_conf.use_callchain check
  perf tools: Factor out sample__resolve_callchain()
  perf tools: Introduce struct hist_entry_iter
  perf hists: Convert hist entry functions to use struct he_stat
  perf hists: Add support for accumulated stat of hist entry
  perf hists: Check if accumulated when adding a hist entry
  perf hists: Accumulate hist entry stat based on the callchain
  perf tools: Update cpumode for each cumulative entry
  perf report: Cache cumulative callchains
  perf callchain: Add callchain_cursor_snapshot()
  perf tools: Save callchain info for each cumulative entry
  perf hists: Sort hist entries by accumulated period
  perf ui/hist: Add support to accumulated hist stat
  perf ui/browser: Add support to accumulated hist stat
  perf ui/gtk: Add support to accumulated hist stat
  perf tools: Apply percent-limit to cumulative percentage
  perf tools: Add more hpp helper functions
  perf report: Add --children option
  perf report: Add report.children config option
  perf tools: Add callback function to hist_entry_iter
  perf top: Convert to hist_entry_iter
  perf top: Add --children option
  perf top: Add top.children config option
  perf tools: Enable --children option by default

 tools/perf/Documentation/perf-report.txt |   5 +
 tools/perf/Documentation/perf-top.txt    |   6 +
 tools/perf/builtin-annotate.c            |   3 +-
 tools/perf/builtin-diff.c                |   2 +-
 tools/perf/builtin-report.c              | 202 +++---------
 tools/perf/builtin-top.c                 | 107 ++++---
 tools/perf/tests/hists_link.c            |   4 +-
 tools/perf/ui/browsers/hists.c           |  50 +--
 tools/perf/ui/gtk/hists.c                |  20 +-
 tools/perf/ui/hist.c                     |  62 ++++
 tools/perf/ui/stdio/hist.c               |   4 +-
 tools/perf/util/callchain.c              |  65 ++++
 tools/perf/util/callchain.h              |  17 +
 tools/perf/util/hist.c                   | 526 +++++++++++++++++++++++++++++--
 tools/perf/util/hist.h                   |  47 ++-
 tools/perf/util/machine.c                |   2 -
 tools/perf/util/sort.h                   |  18 +-
 tools/perf/util/symbol.c                 |  11 +-
 tools/perf/util/symbol.h                 |   1 +
 19 files changed, 890 insertions(+), 262 deletions(-)

-- 
1.7.11.7

