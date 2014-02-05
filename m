Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751628AbaBEB6l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 20:58:41 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:57015 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbaBEB6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 20:58:39 -0500
X-AuditID: 9c93016f-b7b7aae0000036de-58-52f19acd2ad6
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [RFC 00/22] perf tools: Display tracepoint enahncements
References: <1391377150-23920-1-git-send-email-jolsa@redhat.com>
Date: Wed, 05 Feb 2014 10:58:37 +0900
In-Reply-To: <1391377150-23920-1-git-send-email-jolsa@redhat.com> (Jiri Olsa's
	message of "Sun, 2 Feb 2014 22:38:48 +0100")
Message-ID: <87eh3i1fsi.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  2 Feb 2014 22:38:48 +0100, Jiri Olsa wrote:
> hi,
> sending out tracepoint (mostly) events display enahncements.
>
> * adding the '--tp' option for report command to show
>   tracepoint related info. Use can specify following switches:
>     fields: shows separated tracepoint fields
>     format: shows tracepoints 'print fmt' in single column
>              (This is default if no switch is given.)

Looks like an useful feature.. but unfortunately it seems not to work
well with --children and (especially) --group options.  Do you have an
idea?

Also as Ingo requested I plan to extend controlling output column with
-F/--field option.  I think I need to more consideration..

Thanks,
Namhyung


>
>   $ perf report --tp --no-children
>   Samples: 4K of event 'sched:sched_switch', Event count (approx.): 4788
>    Overhead          Command      Shared Object          Symbol  Print fmt
>   +  26.27%          swapper  [kernel.kallsyms]  [k] __schedule  swapper/2:0 [120] R ==> offlineimap:22134 [120]
>   +  26.27%      offlineimap  [kernel.kallsyms]  [k] __schedule  offlineimap:22134 [120] S ==> swapper/2:0 [120]
>   -   8.15%          swapper  [kernel.kallsyms]  [k] __schedule  swapper/3:0 [120] R ==> offlineimap:22134 [120]
>        __schedule
>        schedule_preempt_disabled
>        cpu_startup_entry
>        start_secondary
>   +   8.15%      offlineimap  [kernel.kallsyms]  [k] __schedule  offlineimap:22134 [120] S ==> swapper/3:0 [120]
>
>   $ perf report --tp=fields --no-children
>   Samples: 4K of event 'sched:sched_switch', Event count (approx.): 4788
>     Overhead          Command      Shared Object          Symbol                       prev_comm    prev_pid   prev_prio          prev_state                       next_comm    next_pid   next_prio
>   +   26.27%          swapper  [kernel.kallsyms]  [k] __schedule                       swapper/2           0         120                   0                     offlineimap       22134         120
>   +   26.27%      offlineimap  [kernel.kallsyms]  [k] __schedule                     offlineimap       22134         120                   1                       swapper/2           0         120
>   -    8.15%          swapper  [kernel.kallsyms]  [k] __schedule                       swapper/3           0         120                   0                     offlineimap       22134         120
>        __schedule
>        schedule_preempt_disabled
>        cpu_startup_entry
>        start_secondary
>   +    8.15%      offlineimap  [kernel.kallsyms]  [k] __schedule                     offlineimap       22134         120                   1                       swapper/3           0         120
>
>
> * adding '--list' report option to display entries sequentialy:
>
>   Samples: 2K of event 'sched:sched_switch', Event count (approx.): 2450
>         Self  Children                              Time          Command                Shared Object                                                       Symbol  Print fmt
>   +    0.04%     0.04%        9582.431783 +000000.000000          swapper  [kernel.kallsyms]            [k] __schedule                                               swapper/1:0 [120] R ==> perf:11168 [120]
>   -    0.00%     0.04%        9582.431783 +000000.000000          swapper  [kernel.kallsyms]            [k] __schedule                                               swapper/1:0 [120] R ==> perf:11168 [120]
>        __schedule
>        schedule
>        cpu_idle
>        start_secondary
>   +    0.00%     0.04%        9582.431783 +000000.000000          swapper  [kernel.kallsyms]            [k] schedule                                                 swapper/1:0 [120] R ==> perf:11168 [120]
>   +    0.00%     0.04%        9582.431783 +000000.000000          swapper  [kernel.kallsyms]            [k] cpu_idle                                                 swapper/1:0 [120] R ==> perf:11168 [120]
>
> * adding 'H' key handler to togle header columns
>
>
> thanks for comments,
> jirka
>
>
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: David Ahern <dsahern@gmail.com>
> ---
> Jiri Olsa (22):
>       perf tools: Fix memory leak in event_format__print function
>       perf tools: Add time sort entry
>       perf tools: Add idx sort entry
>       perf tools: Add --list report option
>       perf tools: Add sort_entry struct into sort entries callbacks
>       perf tools: Add selected bool into se_snprintf sort entries callback
>       perf tools: Implement selected bool se_snprintf callback logic
>       perf tools: Implement selected logic for time sort entry
>       perf tools: Factor ui_browser ops out of ui_browser struct
>       perf tools: Add header callback into ui_browser_ops struct
>       perf tools: Remove ev_name argument from perf_evsel__hists_browse
>       perf tools: Add header callback to hist browser
>       perf tools: Factor hpp_arg struct to carry hist_browser
>       perf tools tui: Display columns header text on 'H' press
>       tools lib traceevent: Factor print_event_fields function
>       tools lib traceevent: Make the name output optional in pevent_field_info
>       tools lib traceevent: Add pevent_field_cmp function
>       perf tools: Factor sort entries loops
>       perf tools: Add local hists sort entry list
>       perf tools: Make hists col_len dynamicaly alocated
>       perf tools: Add raw info into hist entry
>       perf tools: Add support for tracepoint fields
>
>  tools/lib/traceevent/event-parse.c       | 181 +++++++++++++++++++++----------
>  tools/lib/traceevent/event-parse.h       |  10 ++
>  tools/perf/Documentation/perf-report.txt |   6 ++
>  tools/perf/Makefile.perf                 |   1 +
>  tools/perf/builtin-annotate.c            |   4 +-
>  tools/perf/builtin-diff.c                |   4 +-
>  tools/perf/builtin-report.c              |  52 ++++++++-
>  tools/perf/tests/hists_link.c            |   6 +-
>  tools/perf/ui/browser.c                  | 101 ++++++++++++-----
>  tools/perf/ui/browser.h                  |  31 ++++--
>  tools/perf/ui/browsers/annotate.c        |  19 ++--
>  tools/perf/ui/browsers/header.c          |   8 +-
>  tools/perf/ui/browsers/hists.c           | 168 ++++++++++++++++++++++-------
>  tools/perf/ui/browsers/map.c             |   8 +-
>  tools/perf/ui/browsers/scripts.c         |   2 +-
>  tools/perf/ui/gtk/hists.c                |   8 +-
>  tools/perf/ui/hist.c                     |  10 +-
>  tools/perf/ui/stdio/hist.c               |   6 +-
>  tools/perf/ui/tui/util.c                 |   8 +-
>  tools/perf/util/evsel.c                  |  24 +++--
>  tools/perf/util/evsel.h                  |   6 +-
>  tools/perf/util/hist.c                   |  65 ++++++++---
>  tools/perf/util/hist.h                   |  20 +++-
>  tools/perf/util/python.c                 |   3 +-
>  tools/perf/util/report-tp.c              | 244 +++++++++++++++++++++++++++++++++++++++++
>  tools/perf/util/report-tp.h              |  18 ++++
>  tools/perf/util/sort.c                   | 370 +++++++++++++++++++++++++++++++++++++++++++++++++--------------
>  tools/perf/util/sort.h                   |  29 ++++-
>  tools/perf/util/symbol.h                 |   3 +-
>  tools/perf/util/trace-event-parse.c      |   1 +
>  tools/perf/util/util.h                   |  17 +++
>  31 files changed, 1144 insertions(+), 289 deletions(-)
>  create mode 100644 tools/perf/util/report-tp.c
>  create mode 100644 tools/perf/util/report-tp.h
