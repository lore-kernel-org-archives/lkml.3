Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273AbaBXIJl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 03:09:41 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:45658 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbaBXIJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 03:09:32 -0500
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCHSET 0/8] perf tools: Update on filtered entries' percentage output (v5)
Date: Mon, 24 Feb 2014 17:09:20 +0900
Message-Id: <1393229368-31412-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
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
original value before and after the filter applied.  In patch 8/8, I
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


You can get this on the 'perf/percentage-v5' branch in my tree

  git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git

Any comments are welcome, thanks
Namhyung


Namhyung Kim (8):
  perf tools: Count periods of filtered entries separately
  perf hists: Add support for showing relative percentage
  perf report: Add --percentage option
  perf top: Add --percentage option
  perf diff: Add --percentage option
  perf tools: Add hist.percentage config option
  perf ui/tui: Add 'F' hotkey to toggle percentage output
  perf tools: Show absolute percentage by default

 tools/perf/Documentation/perf-diff.txt   | 21 +++++++++--
 tools/perf/Documentation/perf-report.txt | 24 +++++++++---
 tools/perf/Documentation/perf-top.txt    | 18 +++++++--
 tools/perf/builtin-diff.c                | 35 ++++++++++++++---
 tools/perf/builtin-report.c              | 24 ++++++++++--
 tools/perf/builtin-top.c                 |  2 +
 tools/perf/ui/browsers/hists.c           | 47 +++++++++++++++++------
 tools/perf/ui/gtk/hists.c                | 19 +++++-----
 tools/perf/ui/hist.c                     |  8 ++--
 tools/perf/util/config.c                 |  4 ++
 tools/perf/util/event.c                  | 22 +++++------
 tools/perf/util/hist.c                   | 65 +++++++++++++++++++++-----------
 tools/perf/util/hist.h                   | 19 ++++++++++
 tools/perf/util/symbol.h                 |  5 ++-
 14 files changed, 233 insertions(+), 80 deletions(-)

-- 
1.7.11.7

