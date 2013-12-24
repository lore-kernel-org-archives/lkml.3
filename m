Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682Ab3LXIWc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 03:22:32 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:50238 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627Ab3LXIWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 03:22:31 -0500
X-AuditID: 9c930179-b7c89ae000006438-d9-52b94444a4fc
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: [PATCHSET 00/21] perf tools: Add support to accumulate hist periods (v4)
Date: Tue, 24 Dec 2013 17:22:06 +0900
Message-Id: <1387873347-28838-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is my third attempt to implement cumulative hist period report.
This work begins from Arun's SORT_INCLUSIVE patch [1] but I completely
rewrote it from scratch.

Please see the patch 01/21.  I refactored functions that add hist
entries with struct add_entry_iter.  While I converted all functions
carefully, it'd be better anyone can test and confirm that I didn't
mess up something - especially for branch stack and mem stuff.

This patchset basically adds period in a sample to every node in the
callchain.  A hist_entry now has an additional fields to keep the
cumulative period if --children option is given on perf report.

I changed the option as a separate --children and added a new
"Children" column (and renamed the default "Overhead" column into
"Self").  The output will be sorted by children (cumulative) overhead
for now.  The reason I changed to the --children is that I still think
it's much different from other --callchain options and I plan to add
support for showing (remaining) callchains to cumulative entries too
as Arun requested.  The --callchain option will take care of it even
with --children option.

I know that the UI should be changed also to be more flexible as Ingo
requested, but I'd like to do this first and then move to work on the
next.  I also added a new config option to enable it by default.

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

  $ perf report --stdio
      88.29%      abc  abc                [.] a                  
                  |
                  --- a
                      b
                      c
                      main
                      __libc_start_main

       9.43%      abc  ld-2.17.so         [.] _dl_relocate_object
                  |
                  --- _dl_relocate_object
                      dl_main
                      _dl_sysdep_start

       2.27%      abc  [kernel.kallsyms]  [k] page_fault         
                  |
                  --- page_fault
                     |          
                     |--95.94%-- _dl_sysdep_start
                     |          _dl_start_user
                     |          
                      --4.06%-- _start

       0.00%      abc  ld-2.17.so         [.] _start             
                  |
                  --- _start


When the -g cumulative option is given, it'll be shown like this:

  $ perf report --children --stdio

  #     Self  Children  Command      Shared Object                   Symbol
  # ........  ........  .......  .................  .......................
  #
       0.00%    88.29%      abc  libc-2.17.so       [.] __libc_start_main  
       0.00%    88.29%      abc  abc                [.] main               
       0.00%    88.29%      abc  abc                [.] c                  
       0.00%    88.29%      abc  abc                [.] b                  
      88.29%    88.29%      abc  abc                [.] a                  
       0.00%    11.61%      abc  ld-2.17.so         [.] _dl_sysdep_start   
       0.00%     9.43%      abc  ld-2.17.so         [.] dl_main            
       9.43%     9.43%      abc  ld-2.17.so         [.] _dl_relocate_object
       2.27%     2.27%      abc  [kernel.kallsyms]  [k] page_fault         
       0.00%     2.18%      abc  ld-2.17.so         [.] _dl_start_user     
       0.00%     0.10%      abc  ld-2.17.so         [.] _start             

As you can see __libc_start_main -> main -> c -> b -> a callchain show
up in the output.

I know it have some rough edges or even bugs, but I really want to
release it and get reviews.  It does not handle event groups and
annotations yet.

You can also get this series on 'perf/cumulate-v4' branch in my tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git


Any comments are welcome, thanks.
Namhyung


Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>

[1] https://lkml.org/lkml/2012/3/31/6


Namhyung Kim (21):
  perf tools: Introduce struct add_entry_iter
  perf hists: Convert hist entry functions to use struct he_stat
  perf hists: Add support for accumulated stat of hist entry
  perf hists: Check if accumulated when adding a hist entry
  perf hists: Accumulate hist entry stat based on the callchain
  perf tools: Update cpumode for each cumulative entry
  perf report: Cache cumulative callchains
  perf hists: Sort hist entries by accumulated period
  perf ui/hist: Add support to accumulated hist stat
  perf ui/browser: Add support to accumulated hist stat
  perf ui/gtk: Add support to accumulated hist stat
  perf tools: Apply percent-limit to cumulative percentage
  perf tools: Add more hpp helper functions
  perf report: Add --children option
  perf report: Add report.children config option
  perf tools: Factor out sample__resolve_callchain()
  perf tools: Factor out fill_callchain_info()
  perf top: Support callchain accumulation
  perf top: Add --children option
  perf top: Add top.children config option
  perf tools: Enable --children option by default

 tools/perf/Documentation/perf-report.txt |   5 +
 tools/perf/Documentation/perf-top.txt    |   6 +
 tools/perf/builtin-annotate.c            |   3 +-
 tools/perf/builtin-diff.c                |   2 +-
 tools/perf/builtin-report.c              | 534 +++++++++++++++++++++++++------
 tools/perf/builtin-top.c                 | 137 +++++++-
 tools/perf/tests/hists_link.c            |   4 +-
 tools/perf/ui/browsers/hists.c           |  51 ++-
 tools/perf/ui/gtk/hists.c                |  27 +-
 tools/perf/ui/hist.c                     |  62 ++++
 tools/perf/ui/stdio/hist.c               |  13 +-
 tools/perf/util/callchain.c              |  65 ++++
 tools/perf/util/callchain.h              |   8 +
 tools/perf/util/hist.c                   |  73 +++--
 tools/perf/util/hist.h                   |   7 +-
 tools/perf/util/sort.h                   |   1 +
 tools/perf/util/symbol.c                 |  11 +-
 tools/perf/util/symbol.h                 |   1 +
 18 files changed, 855 insertions(+), 155 deletions(-)

-- 
1.7.11.7

