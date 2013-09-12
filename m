Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756469Ab3ILU3z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 16:29:55 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:64464 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753Ab3ILU3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 16:29:50 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 0/4] perf tools: New comm infrastructure 
Date: Thu, 12 Sep 2013 22:29:39 +0200
Message-Id: <1379017783-27032-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The way we handle hists sorted by comm is to first gather them by tid then
in the end merge/collapse hists that end up with the same comm.

But merging hists has shown some performances issues, especially with callchain
where the operation can be very heavy.

So this new comm infrastructure aims at removing comm collapses. It brings
two features:

1) Keep track of comms lifecycle by storing timestamps when the comms
are set. This way we can map the precise comm to any thread:time couple.
This only works if the PERF_SAMPLE_ID comes along comm and fork events,
otherwise we only track the latest comm set for a thread.

This can provide us more precise comm sorted hists by distinguishing pre and
post exec timeframes into seperate hists for a single thread.

Note that although the comm infrastructure is ready to do this, I haven't
yet made the perf tools support that. It's a TODO entry.


2) Allocate comms only once instead of duplicating them for all threads sharing
a same one. Two threads having the same comm should now point to the same string.
As a result we can compare hists thread comm by address.

The big upside is that we can now live sort comm hists instead of collapsing
them in the end of the processing.

I've seen very nice performance results on perf report. Roughly a 1.5x to 2x
on perf report default stdio output with callchains.

You can try this branch:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	perf/comm

May be merging that with Namhyung callchains patches could provide some
cumulative nice results.

thanks.

---

Frederic Weisbecker (4):
      perf tools: Use an accessor to read thread comm
      perf tools: Add time argument on comm setting
      perf tools: Add new comm infrastructure
      perf tools: Compare hists comm by addresses


 tools/perf/Makefile                                |    2 +
 tools/perf/builtin-kmem.c                          |    2 +-
 tools/perf/builtin-lock.c                          |    2 +-
 tools/perf/builtin-sched.c                         |   16 ++--
 tools/perf/builtin-script.c                        |    6 +-
 tools/perf/builtin-top.c                           |    2 +-
 tools/perf/builtin-trace.c                         |   14 ++--
 tools/perf/tests/code-reading.c                    |    2 +-
 tools/perf/tests/hists_link.c                      |    6 +-
 tools/perf/ui/browsers/hists.c                     |   10 +-
 tools/perf/util/comm.c                             |  107 ++++++++++++++++++++
 tools/perf/util/comm.h                             |   20 ++++
 tools/perf/util/event.c                            |   28 +++---
 tools/perf/util/machine.c                          |   34 ++++---
 tools/perf/util/machine.h                          |   18 ++-
 .../perf/util/scripting-engines/trace-event-perl.c |    2 +-
 .../util/scripting-engines/trace-event-python.c    |    4 +-
 tools/perf/util/session.c                          |    2 +-
 tools/perf/util/sort.c                             |   13 ++-
 tools/perf/util/thread.c                           |   95 +++++++++++++----
 tools/perf/util/thread.h                           |    8 +-
 21 files changed, 293 insertions(+), 100 deletions(-)
