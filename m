Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753Ab3EUGOm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 02:14:42 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:46119 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024Ab3EUGOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 02:14:41 -0400
X-AuditID: 9c93017d-b7b64ae000000e51-72-519b10cffb20
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: [RFC 0/7] perf report/gtk: Add support for hierarchy view
Date: Tue, 21 May 2013 15:14:31 +0900
Message-Id: <1369116878-12489-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

This patchset implements a new feature that collects hist entries in a
hierachical manner.  That means lower-level entries are belonged to an
upper-level entry.  The entry hierachy is built on the sort keys
given, so users can set it whatever they want.  It only shows
top-level entries first, and user can expand/collapse it dynamically.

This is only implemented in --gtk currently, since it's well-matched
to the GTK tree view widget and I didn't want to be bothered with the
TUI browser code at this stage. :)

I don't attach a screenshot now, but this is an hypothetical example
on stdio.  An usual output of perf report look like:

  Overhead  Command      Shared Object                                    Symbol
  ........  .......  .................  ........................................
    22.70%  swapper  [kernel.kallsyms]  [k] intel_idle
     8.36%  swapper  [kernel.kallsyms]  [k] irqtime_acouunt_process_tick.isra.74
     1.33%  swapper  [kernel.kallsyms]  [k] __schedule


If --hierarchy (-H) option is given, it'll look like (after expanding
all children):

  Overhead  Command / Shared Object / Symbol
  ........  ..............................................
    32.39%  - swapper
    32.39%    - [kernel.kallsyms]
    22.70%        [k] intel_idle
     8.36%        [k] irqtime_acouunt_process_tick.isra.74
     1.33%        [k] __schedule

(The overhead of an upper-level entry is the sum of lower-level
entries' overhead).

You can get it from 'perf/hierarchy-v1' branch on my tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/namhyung-perf.git


Any comments are welcome, thanks!
Namhyung


Namhyung Kim (7):
  perf hists: Basic support of hierarchical view
  perf gtk/hists: Use GtkTreeStore instead of GtkListStore
  perf gtk/hists: Factor out perf_gtk__add_entries()
  perf gtk/hists: Add support for hierachical output
  perf report: Add -H (--hierarchy) option
  perf gtk/hists: Add a double-click handler for hierarchy mode
  perf gtk/hists: Set rules hint for the hist browser

 tools/perf/Documentation/perf-report.txt |   5 +
 tools/perf/builtin-report.c              |   6 +
 tools/perf/ui/gtk/hists.c                | 192 ++++++++++++++----
 tools/perf/util/hist.c                   | 325 +++++++++++++++++++++++++++----
 tools/perf/util/sort.h                   |   3 +
 tools/perf/util/symbol.h                 |   3 +-
 6 files changed, 460 insertions(+), 74 deletions(-)

-- 
1.7.11.7

