Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128Ab3JaG4W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 02:56:22 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:42171 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab3JaG4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 02:56:21 -0400
X-AuditID: 9c930197-b7b3eae00000122e-bd-5271ff11fb17
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Arun Sharma <asharma@fb.com>
Subject: [RFC/PATCHSET 00/14] perf report: Add support to accumulate hist periods (v2)
Date: Thu, 31 Oct 2013 15:56:02 +0900
Message-Id: <1383202576-28141-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is my second attempt to implement cumulative hist period report.
This work begins from Arun's SORT_INCLUSIVE patch [1] but I completely
rewrote it from scratch.

Please see first two patches.  I refactored functions that add hist
entries with struct add_entry_iter.  While I converted all functions
carefully, it'd be better anyone can test and confirm that I didn't
mess up something - especially for branch stack and mem stuff.

This patchset basically adds period in a sample to every node in the
callchain.  A hist_entry now has an additional fields to keep the
cumulative period if -g cumulative option is given on perf report.

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

  $ perf report -g cumulative --stdio

  # Overhead  Overhead (Acc)  Command      Shared Object                   Symbol
  # ........  ..............  .......  .................  .......................
  #
       0.00%          88.29%      abc  libc-2.17.so       [.] __libc_start_main  
       0.00%          88.29%      abc  abc                [.] main               
       0.00%          88.29%      abc  abc                [.] c                  
       0.00%          88.29%      abc  abc                [.] b                  
      88.29%          88.29%      abc  abc                [.] a                  
       0.00%          11.61%      abc  ld-2.17.so         [k] _dl_sysdep_start   
       0.00%           9.43%      abc  ld-2.17.so         [.] dl_main            
       9.43%           9.43%      abc  ld-2.17.so         [.] _dl_relocate_object
       2.27%           2.27%      abc  [kernel.kallsyms]  [k] page_fault         
       0.00%           2.18%      abc  ld-2.17.so         [k] _dl_start_user     
       0.00%           0.10%      abc  ld-2.17.so         [.] _start             

As you can see __libc_start_main -> main -> c -> b -> a callchain show
up in the output.

I know it have some rough edges or even bugs, but I really want to
release it and get reviews.  It does not handle event groups and
annotations and it has a bug on TUI.

You can also get this series on 'perf/cumulate-v2' branch in my tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git


Any comments are welcome, thanks.
Namhyung


Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>

[1] https://lkml.org/lkml/2012/3/31/6

Namhyung Kim (14):
  perf tools: Consolidate __hists__add_*entry()
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
  perf report: Add -g cumulative option

 tools/perf/Documentation/perf-report.txt |   2 +
 tools/perf/builtin-annotate.c            |   3 +-
 tools/perf/builtin-diff.c                |   3 +-
 tools/perf/builtin-report.c              | 659 ++++++++++++++++++++++++-------
 tools/perf/builtin-top.c                 |   5 +-
 tools/perf/tests/hists_link.c            |   6 +-
 tools/perf/ui/browsers/hists.c           |  32 +-
 tools/perf/ui/gtk/hists.c                |  20 +
 tools/perf/ui/hist.c                     |  41 ++
 tools/perf/ui/stdio/hist.c               |   5 +
 tools/perf/util/callchain.c              |  12 +
 tools/perf/util/callchain.h              |   3 +-
 tools/perf/util/hist.c                   | 142 +++----
 tools/perf/util/hist.h                   |  22 +-
 tools/perf/util/sort.h                   |   1 +
 15 files changed, 701 insertions(+), 255 deletions(-)

-- 
1.7.11.7

