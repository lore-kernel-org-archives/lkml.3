Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677Ab3AOOOt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 09:14:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47790 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752038Ab3AOOOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 09:14:47 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>,
        Ulrich Drepper <drepper@gmail.com>
Subject: [RFC 0/4] perf tool: Adding ratios support
Date: Tue, 15 Jan 2013 14:39:50 +0100
Message-Id: <1358257194-8204-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
adding support to predefine event ratios formulas so they could
be used easily in perf.

The formulas are handed in the config file with following format:

  set {
        events = {cycles,instructions,branch-instructions}:u

        cpi {
                formula = cycles / instructions
                desc = cycles per instruction
        }

	branch-rate {
                formula = branch-instructions / instructions
                desc = branch rate
        }
  }

  The 'set' defines set of counter that share same events.
  Each 'set' defines:
    events   - event string that would go into stat/record -e option
    counters - any number of counters based on above events

  Each counter (cpi/branch-rate) defines
    formula - formula with that produce the counter number
              event names and numbers could be used
    desc    - text description of the counter

The formula can currently contain any event from the set::events
plus any number (int). There'll be support in future for outside
values runtime and other if needed.

My current thinking is to have generic formulas file(s) for architectural
events and add arch-specific ones once when we have the support for
non-architectural events (already sent RFC, v2 is on its way..).

Example:

With following formula.conf config file:
---
  cpi {
          events = {cycles,instructions}:u

          CPI {
                  formula = cycles / instructions
                  desc = cycles per instruction
          }
  }

  branch {
          events = {instructions,branch-instructions,branch-misses}:u

          branch-rate {
                  formula = branch-instructions / instructions
                  desc = branch rate
          }

          branch-miss-rate {
                  formula = branch-misses / instructions
                  desc = branch misprediction rate
          }

          branch-miss-ratio{
                  formula = branch-misses / branch-instructions
                  desc = branch misprediction ratio
          }
  }
---

You'll get following result:

  $ perf stat -f formula.conf:branch kill
  usage: kill [ -s signal | -p ] [ -a ] pid ...
         kill -l [ signal ]

   Performance counter stats for 'kill':

             184,195 instructions              #    0.00  insns per cycle
              40,907 branch-instructions
               4,815 branch-misses             #   11.77% of all branches

         0.000655767 seconds time elapsed

          0.22208529 branch-rate               #  branch rate
          0.02614077 branch-miss-rate          #  branch misprediction rate
          0.11770602 branch-miss-ratio         #  branch misprediction ratio

  $ perf stat -f formula.conf:cpi kill
  usage: kill [ -s signal | -p ] [ -a ] pid ...
         kill -l [ signal ]

   Performance counter stats for 'kill':

             356,635 cycles                    #    0.000 GHz
             187,191 instructions              #    0.52  insns per cycle

         0.001907600 seconds time elapsed

          1.90519309 CPI                       #  cycles per instruction


Available also at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/linux.git
  perf/ratios2


thanks for any ideas,
jirka

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ulrich Drepper <drepper@gmail.com>
---
 tools/perf/Makefile                     |  11 +++
 tools/perf/builtin-stat.c               |  61 ++++++++++++++-
 tools/perf/formula.conf                 |  28 +++++++
 tools/perf/tests/evsel-roundtrip-name.c |   4 +-
 tools/perf/tests/hists_link.c           |   4 +-
 tools/perf/tests/parse-events.c         |   2 +-
 tools/perf/util/evlist.c                |  13 ++++
 tools/perf/util/evlist.h                |   4 +
 tools/perf/util/formula.c               | 387 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/formula.h               | 113 +++++++++++++++++++++++++++
 tools/perf/util/formula.l               | 119 ++++++++++++++++++++++++++++
 tools/perf/util/formula.y               | 248 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/parse-events.c          |   5 +-
 tools/perf/util/parse-events.h          |   3 +-
 14 files changed, 991 insertions(+), 11 deletions(-)

