Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391Ab3LRFVw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 00:21:52 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:54467 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab3LRFVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 00:21:30 -0500
X-AuditID: 9c93017d-b7c5eae000004296-1c-52b130d8895c
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Arun Sharma <asharma@fb.com>,
        Jiri Olsa <jolsa@redhat.com>, Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: [RFC/PATCHSET 00/18] perf report: Add support to accumulate hist periods (v3)
Date: Wed, 18 Dec 2013 14:21:08 +0900
Message-Id: <1387344086-12744-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is my third attempt to implement cumulative hist period report.
This work begins from Arun's SORT_INCLUSIVE patch [1] but I completely
rewrote it from scratch.

Please see the patch 04/18.  I refactored functions that add hist
entries with struct add_entry_iter.  While I converted all functions
carefully, it'd be better anyone can test and confirm that I didn't
mess up something - especially for branch stack and mem stuff.

This patchset basically adds period in a sample to every node in the
callchain.  A hist_entry now has an additional fields to keep the
cumulative period if --cumulate option is given on perf report.

I changed the option as a separate --cumulate and added a new "Total"
column (and renamed the default "Overhead" column into "Self").  The
output will be sorted by total (cumulative) overhead for now.  The
reason I changed to the --cumulate is that I still think it's much
different from other --callchain options and I plan to add support for
showing (remaining) callchains to cumulative entries too.  The
--callchain option will take care of it even with --cumulate option.

I know that the UI should be changed also to be more flexible as Ingo
requested, but I'd like to do this first and then move to work on the
next.  I also added a new config option to enable it by default.

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

  $ perf report --cumulate --stdio

  #     Self     Total  Command      Shared Object                   Symbol
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

You can also get this series on 'perf/cumulate-v3' branch in my tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git


Any comments are welcome, thanks.
Namhyung


Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>

[1] https://lkml.org/lkml/2012/3/31/6


Namhyung Kim (18):
  perf sort: Compare addresses if no symbol info
  perf sort: Do not compare dso again
  perf tools: Do not pass period and weight to add_hist_entry()
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
  perf report: Add --cumulate option
  perf report: Add report.cumulate config option

 tools/perf/Documentation/perf-report.txt |   5 +
 tools/perf/builtin-annotate.c            |   3 +-
 tools/perf/builtin-diff.c                |   2 +-
 tools/perf/builtin-report.c              | 679 ++++++++++++++++++++++++-------
 tools/perf/builtin-top.c                 |   2 +-
 tools/perf/tests/hists_link.c            |   4 +-
 tools/perf/ui/browsers/hists.c           |  51 ++-
 tools/perf/ui/gtk/hists.c                |  27 +-
 tools/perf/ui/hist.c                     |  62 +++
 tools/perf/ui/stdio/hist.c               |  13 +-
 tools/perf/util/hist.c                   |  79 +++-
 tools/perf/util/hist.h                   |   7 +-
 tools/perf/util/sort.c                   |  22 +-
 tools/perf/util/sort.h                   |   1 +
 tools/perf/util/symbol.h                 |   1 +
 15 files changed, 761 insertions(+), 197 deletions(-)

-- 
1.7.11.7

