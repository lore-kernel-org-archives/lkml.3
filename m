Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758537AbaDJQCK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 12:02:10 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:56899 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006AbaDJQCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 12:02:07 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <ak@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCHSET 0/7] perf tools: Update on filtered entries' percentage output (v8)
Date: Fri, 11 Apr 2014 01:01:53 +0900
Message-Id: <1397145720-8063-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I added --percentage option to perf report to control display of
percentage of filtered entries.

 usage: perf report [<options>]

        --percentage <relative|absolute>
                          how to display percentage of filtered entries

"relative" means it's relative to filtered entries only so that the
sum of shown entries will be always 100%.  "absolute" means it retains
original value before and after the filter applied.  In patch 9/9, I
made the "absolute" as default since it makes more sense IMHO.

      $ perf report -s comm
      # Overhead       Command
      # ........  ............
      #
          74.19%           cc1
           7.61%           gcc
           6.11%            as
           4.35%            sh
           4.14%          make
           1.13%        fixdep
      ...

      $ perf report -s comm -c cc1,gcc --percentage absolute
      # Overhead       Command
      # ........  ............
      #
          74.19%           cc1
           7.61%           gcc

      $ perf report -s comm -c cc1,gcc --percentage relative
      # Overhead       Command
      # ........  ............
      #
          90.69%           cc1
           9.31%           gcc

Note that it has zero effect if no filter was applied.

 * changes in v8:
  - don't touch irrelavant code (Arnaldo)
  - rebase to jolsa/perf/core_new

 * changes in v7:
  - rename ->nr_filtered_* to ->nr_non_filtered_* (Arnaldo)
  - remove an unneeded alignment change (Arnaldo)

 * changes in v6:
  - fix a bug in --stdio group report
  - reuse __hpp__fmt() function in TUI/GTK
  - add Acked-by from Jiri

 * changes in v5:
  - fix 0 samples in relative percent output (Jiri)
  - factor hists__total_period function (Jiri)
  - share config parsing code with option parser (Jiri)

 * changes in v4:
  - support perf top and perf diff also  (Jiri)
  - add HIST_FILTER__HOST/GUEST  (Jiri)
  - retain both of filtered and total stats  (Arnaldo)
  - add 'F' hotkey on TUI  (Jiri)
  - rename config variable to have "hist." prefix


You can get this on the 'perf/percentage-v8' branch in my tree

  git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git

Any comments are welcome, thanks
Namhyung


Namhyung Kim (7):
  perf hists: Add support for showing relative percentage
  perf report: Add --percentage option
  perf top: Add --percentage option
  perf diff: Add --percentage option
  perf tools: Add hist.percentage config option
  perf ui/tui: Add 'F' hotkey to toggle percentage output
  perf tools: Show absolute percentage by default

 tools/perf/Documentation/perf-diff.txt   |   21 +++++++++--
 tools/perf/Documentation/perf-report.txt |   24 +++++++++---
 tools/perf/Documentation/perf-top.txt    |   18 +++++++--
 tools/perf/builtin-diff.c                |   32 ++++++++++++----
 tools/perf/builtin-report.c              |   22 ++++++++++-
 tools/perf/builtin-top.c                 |    8 +++-
 tools/perf/ui/browsers/hists.c           |   39 ++++++++++++++++----
 tools/perf/ui/gtk/hists.c                |   11 +++---
 tools/perf/ui/hist.c                     |    8 ++--
 tools/perf/util/config.c                 |    4 ++
 tools/perf/util/hist.c                   |   59 +++++++++++++++++++++++-------
 tools/perf/util/hist.h                   |   10 +++++
 tools/perf/util/symbol.h                 |    3 +-
 13 files changed, 203 insertions(+), 56 deletions(-)

-- 
1.7.9.2

