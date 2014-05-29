Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932349AbaE2D6k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 23:58:40 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:53164 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967AbaE2D6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 23:58:34 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Arun Sharma <asharma@fb.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Don Zickus <dzickus@redhat.com>
Subject: [PATCHSET 00/27] perf tools: Add support to accumulate hist periods (v11)
Date: Thu, 29 May 2014 12:58:03 +0900
Message-Id: <1401335910-16832-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is a new attempt to implement cumulative hist period report.
This work begins from Arun's SORT_INCLUSIVE patch [1] but I completely
rewrote it from scratch.

This patchset basically adds period in a sample to every node in the
callchain.  A hist_entry now has an additional fields to keep the
cumulative period if --children option is given on perf report.

I changed the option as a separate --children and added a new
"Children" column (and renamed the default "Overhead" column into
"Self").  The output will be sorted by children (cumulative) overhead
for now.  It also adds 'overhead_children' field to -F/--fields option
to be selected by user and it'll show you "N/A" if the cumulation is
not supported (due to missing callchain).

I added Tested-by from Rodrigo Campos since this version is basically
rebase of previous series + bugfix.  But it still needs to be tested
more intensively IMHO.  Also note that, this will change default
behavior of perf report/top if callchain is recorded, so might confuse
old users.  Let's see how many of them come to shout. :)  I think we
need to merge Jiri's TUI column header patch at least.


 * changes in v11:
  - factor out hists__inc_nr_samples  (Jiri)
  - remove unrelated change  (Jiri)
  - disable accumulation on branch or mem mode
  - slightly refactor hist_iter code

 * changes in v10:
  - fix callchain display bug in stdio, gtk
  - add a testcase
  - add Tested-by from Rodrigo

 * changes in v9:
  - support output field option
  - add Acked-by tags from Jiri

 * changes in v8:
  - not depends on --percentage patchkit
  - fix callchain resolving bug (Jiri)
  - convert to sample__resolve_{mem,bstack}
  - eliminate 'event' field from hist_entry_iter

 * changes in v7:
  - add Tested-by tags from Arun
  - rebase onto current acme/perf/core

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

It does not handle all kind of cases like event annotation yet, but I
really want to release it and get reviews.

You can also get this series on 'perf/cumulate-v11' branch in my tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git


Any comments are welcome, thanks.
Namhyung


Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>

[1] https://lkml.org/lkml/2012/3/31/6


Namhyung Kim (27):
  perf tools: Introduce hists__inc_nr_samples()
  perf tools: Introduce struct hist_entry_iter
  perf hists: Add support for accumulated stat of hist entry
  perf hists: Check if accumulated when adding a hist entry
  perf hists: Accumulate hist entry stat based on the callchain
  perf tools: Update cpumode for each cumulative entry
  perf report: Cache cumulative callchains
  perf callchain: Add callchain_cursor_snapshot()
  perf tools: Save callchain info for each cumulative entry
  perf ui/hist: Add support to accumulated hist stat
  perf ui/browser: Add support to accumulated hist stat
  perf ui/gtk: Add support to accumulated hist stat
  perf tools: Apply percent-limit to cumulative percentage
  perf tools: Add more hpp helper functions
  perf report: Add --children option
  perf report: Add report.children config option
  perf tools: Do not auto-remove Children column if --fields given
  perf tools: Add callback function to hist_entry_iter
  perf top: Convert to hist_entry_iter
  perf top: Add --children option
  perf top: Add top.children config option
  perf tools: Enable --children option by default
  perf ui/stdio: Fix invalid percentage value of cumulated hist entries
  perf ui/gtk: Fix callchain display
  perf tools: Reset output/sort order to default
  perf tests: Define and use symbolic names for fake symbols
  perf tests: Add a test case for cumulating callchains

 tools/perf/Documentation/perf-report.txt |   7 +-
 tools/perf/Documentation/perf-top.txt    |   8 +-
 tools/perf/Makefile.perf                 |   1 +
 tools/perf/builtin-annotate.c            |   5 +-
 tools/perf/builtin-diff.c                |   2 +-
 tools/perf/builtin-report.c              | 200 ++-------
 tools/perf/builtin-sched.c               |   2 +-
 tools/perf/builtin-top.c                 |  89 ++--
 tools/perf/tests/builtin-test.c          |   4 +
 tools/perf/tests/hists_common.c          |  52 ++-
 tools/perf/tests/hists_common.h          |  32 +-
 tools/perf/tests/hists_cumulate.c        | 726 +++++++++++++++++++++++++++++++
 tools/perf/tests/hists_filter.c          |  39 +-
 tools/perf/tests/hists_link.c            |  36 +-
 tools/perf/tests/hists_output.c          |  31 +-
 tools/perf/tests/tests.h                 |   1 +
 tools/perf/ui/browsers/hists.c           |  65 +--
 tools/perf/ui/gtk/hists.c                |  33 +-
 tools/perf/ui/hist.c                     | 119 +++++
 tools/perf/ui/stdio/hist.c               |   8 +-
 tools/perf/util/callchain.c              |  45 +-
 tools/perf/util/callchain.h              |  11 +
 tools/perf/util/hist.c                   | 513 +++++++++++++++++++++-
 tools/perf/util/hist.h                   |  49 ++-
 tools/perf/util/sort.c                   |   4 +
 tools/perf/util/sort.h                   |  18 +-
 tools/perf/util/symbol.c                 |  11 +-
 tools/perf/util/symbol.h                 |   1 +
 28 files changed, 1780 insertions(+), 332 deletions(-)
 create mode 100644 tools/perf/tests/hists_cumulate.c

-- 
1.9.2

