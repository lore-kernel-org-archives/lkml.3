Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309AbaDXI3F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 04:29:05 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:38527 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336AbaDXIYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:24:07 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: [PATCHSET 00/11] perf tools: Fixup for the --percentage change (v3)
Date: Thu, 24 Apr 2014 17:23:52 +0900
Message-Id: <1398327843-31845-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset tries to fix bugs in percentage handling which is
recently changed.  The perf top with symbol filter could cause a
segfault (NULL pointer dereference) if the filter found no entry.

In this patchset, I moved accounting of various histogram stats to be
calculated at the time it actually shown to users.  Although I tested
it on my system for a while, it needs more testing since it'll affect
behaviors of many commands/usages.

There're three main fields in the hists->stats to affect the output:
number of samples, number of hist entries and total periods.

Also there're three stages to process samples: at first, samples are
converted to a hist entry and added to the input tree, and then they are
moved to the collapsed tree if needed, and finally they're moved to the
output tree to be shown to user.

The (part of) stats are accounted when samples are added to the input
tree and then reset before moving to the output tree, and re-counted
during insertion to the output tree.

I can see some reason to do it this way but it's basically not necessary
and could make a problem in multi-threaded programs like perf top.

The perf report does all these passes sequentially in a single thread so
it seems no problem.  But perf top uses two threads - one for gathering
samples (in the input tree) and another for (collapsing and) moving them
to the output tree.  Thus accounting stat in parallel can result in an
inaccurate stats and the output.

So I'd like to get rid of the accounting on the input stage as you can
see it just gets dropped before doing output resort.  I originally make
the all three stats are accounted when doing output resort but changed
mind to account number of samples in the input stage and others in the
output stage.  Because it'd make more sense accounting number of events
(sample event) in the input stage (as all other events are also
accounted in the input stage) and it'd make less changes in code.

So yes, it has a same problem of inaccurate number of samples, but its
impact should be smaller than other stats - seeing increasing sample
count (could be slightly inaccurate) without new entries in the browser.

 * changes in v3)
  - split patch 2/7 into parts  (Jiri)
  - fix a segfault when filtering with unfolded entry  (Jiri)


You can get this on the 'perf/percentage-v12' branch (yes, v12 - as
it's continued from my previous series) in my tree

  git://git.kenrel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git


Any comments, review and testing are welcomed.

Thanks,
Namhyung


Namhyung Kim (11):
  perf report: Count number of entries separately
  perf hists: Rename hists__inc_stats()
  perf hists: Move column length calculation out of hists__inc_stats()
  perf hists: Add a couple of hists stat helper functions
  perf hists: Collapse expanded callchains after filter is applied
  perf tools: Account entry stats when it's added to the output tree
  perf hists: Add missing update on filtered stats in
    hists__decay_entries()
  perf ui/tui: Fix off-by-one in hist_browser__update_nr_entries()
  perf ui/tui: Rename hist_browser__update_nr_entries()
  perf top/tui: Update nr_entries properly after a filter is applied
  perf hists/tui: Count callchain rows separately

 tools/perf/builtin-annotate.c  |   3 +-
 tools/perf/builtin-diff.c      |  23 ++++----
 tools/perf/builtin-report.c    |  64 +++++++++++-----------
 tools/perf/ui/browsers/hists.c |  92 ++++++++++++++++++++++----------
 tools/perf/util/hist.c         |  83 ++++++++++++++++++++++++-------------
 tools/perf/util/hist.h         |   9 +++-
 6 files changed, 171 insertions(+), 103 deletions(-)

-- 
1.9.2

