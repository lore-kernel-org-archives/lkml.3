Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800Ab3IZLbK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 07:31:10 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:53601 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756419Ab3IZLbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 07:31:08 -0400
MIME-Version: 1.0
In-Reply-To: <1380113447-17144-1-git-send-email-jolsa@redhat.com>
References: <1380113447-17144-1-git-send-email-jolsa@redhat.com>
Date: Thu, 26 Sep 2013 13:31:06 +0200
Message-ID: <CABPqkBR3cYDdwynxSvdjnWGaJqJ6iDR=J_sbuMs-7V5yEsMzGw@mail.gmail.com>
Subject: Re: [RFC 00/21] perf tools: Add toggling events support
From: Stephane Eranian <eranian@google.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Don Zickus <dzickus@redhat.com>, Andi Kleen <ak@linux.jf.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri,

On Wed, Sep 25, 2013 at 2:50 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> hi,
> sending *RFC* for toggling events support.
>
> Adding perf interface that allows to create toggle events, which can
> enable or disable another event. Whenever the toggle event is triggered
> (has overflow), it toggles another event state and either starts or
> stops it.
>
> The goal is to be able to create toggling tracepoint events to enable and
> disable HW counters, but the interface is generic enough to be used for
> any kind of event.
>
> It's based on the Frederic's patchset:
> https://lkml.org/lkml/2011/3/14/346
>
> Most of the changelogs info is on wiki:
> https://perf.wiki.kernel.org/index.php/Jolsa_Features_Togle_Event
>
> In a nutshell:
>   The interface is added to the sys_perf_event_open syscall
>   and new ioctl was added for completeness, check:
>     perf: Add event toggle sys_perf_event_open interface
>     perf: Add event toggle ioctl interface
>
>   The perf tool interface is pretty rough at the moment. We use
>   'on' and 'off' terms to specify the toggling event, like:
>     -e 'cycles,irq_entry/on=cycles/,irq_exit/off=cycles/'
>
>   Meaning:
>     - irq_entry toggles on (starts) cycles, and irq_exit toggled off (stops) cycles.
>     - cycles is started as paused
>
>    Looking forward to some ideas for better interface in here ;-)
>
> The patchset is available at:
> git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
> perf/core_toggle
>
> thanks for comments,

Such interface is indeed desirable. I received several requests for
this feature internally and externally.
I think it would need to be generalized for user-level code also, same
user API, different trigger points.
I would assume they would be uprobes instead of tracepoints.

And I agree with you, the current cmdline interface is not good
enough, how about something more
aligned with the current syntax:
    -e cpu/event=0x3c,trigger_on=irq_entry,trigger_off=irq_exit/,

Thanks.

> Example:
>   Define toggle(on/off) events:
>     # perf probe -a fork_entry=do_fork
>     # perf probe -a fork_exit=do_fork%return
>
>   Following record session samples only within do_fork function:
>     # perf record -g -e '{cycles,cache-misses}:k,probe:fork_entry/on=cycles/,probe:fork_exit/off=cycles/' \
>       perf bench sched messaging
>
>   Following stat session measure cycles within do_fork function:
>     # perf stat -e '{cycles,cache-misses}:k,probe:fork_entry/on=cycles/,probe:fork_exit/off=cycles/' \
>       perf bench sched messaging
>
>       # Running sched/messaging benchmark...
>       # 20 sender and receiver processes per group
>       # 1 groups == 40 processes run
>
>            Total time: 0.073 [sec]
>
>        Performance counter stats for './perf bench sched messaging -g 1':
>
>               20,935,464 cycles                    #    0.000 GHz
>                   18,897 cache-misses
>                       40 probe:fork_entry
>                       40 probe:fork_exit
>
>              0.086319682 seconds time elapsed
>
> Example:
>   Measure interrupts cycles:
>   # ./perf stat -e 'cycles,cycles/name=cycles_irq/,irq:irq_handler_entry/on=cycles_irq/,irq:irq_handler_exit/off=cycles_irq/' -a sleep 10
>
>    Performance counter stats for 'sleep 10':
>
>       50,680,084,994 cycles                    #    0.000 GHz                     [100.00%]
>              652,690 cycles_irq                #    0.000 GHz
>                   33 irq:irq_handler_entry                                        [100.00%]
>                   33 irq:irq_handler_exit
>
>         10.002084400 seconds time elapsed
>
> Check uprobes example at:
> https://perf.wiki.kernel.org/index.php/Jolsa_Features_Togle_Event#Example_-_using_u.28ret.29probes
>
>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Don Zickus <dzickus@redhat.com>
> Cc: Andi Kleen <ak@linux.jf.intel.com>
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Cc: Stephane Eranian <eranian@google.com>
> ---
> Frederic Weisbecker (2):
>       perf: Be more specific on pmu related event init naming
>       perf: Split allocation and initialization code
>
> Jiri Olsa (19):
>       perf tools: Introduce perf_evlist__wait_workload function
>       perf tools: Separate sys_perf_event_open call into evsel_open
>       perf x86: Update event count properly for read syscall
>       perf: Move event state initialization before/behind the pmu add/del calls
>       perf: Add event toggle sys_perf_event_open interface
>       perf: Add event toggle ioctl interface
>       perf: Toggle whole group in toggle event overflow
>       perf: Add new 'paused' attribute
>       perf: Account toggle masters for toggled event
>       perf: Support event inheritance for toggle feature
>       perf tests: Adding event simple toggling test
>       perf tests: Adding event group toggling test
>       perf tests: Adding event inherit toggling test
>       perf tools: Allow numeric event to change name via name term
>       perf tools: Add event_config_optional parsing rule
>       perf tools: Rename term related parsing function/variable properly
>       perf tools: Carry term string value for symbols events
>       perf tools: Add support to parse event on/off toggle terms
>       perf tools: Add record/stat support for toggling events
>
>  arch/x86/kernel/cpu/perf_event.c                |   6 +-
>  include/linux/perf_event.h                      |  12 +++
>  include/uapi/linux/perf_event.h                 |   7 +-
>  kernel/events/core.c                            | 396 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------
>  tools/perf/Makefile                             |   6 ++
>  tools/perf/arch/x86/tests/toggle-event-raw-64.S |  28 ++++++
>  tools/perf/builtin-record.c                     |   7 ++
>  tools/perf/builtin-stat.c                       |  12 +++
>  tools/perf/tests/builtin-test.c                 |  12 +++
>  tools/perf/tests/perf-record.c                  |   1 +
>  tools/perf/tests/task-exit.c                    |   5 ++
>  tools/perf/tests/tests.h                        |   3 +
>  tools/perf/tests/toggle-event-group.c           | 195 +++++++++++++++++++++++++++++++++++++++++
>  tools/perf/tests/toggle-event-inherit.c         | 132 ++++++++++++++++++++++++++++
>  tools/perf/tests/toggle-event-raw.c             | 106 ++++++++++++++++++++++
>  tools/perf/util/evlist.c                        |  97 +++++++++++++++++++++
>  tools/perf/util/evlist.h                        |   3 +
>  tools/perf/util/evsel.c                         |  53 ++++++-----
>  tools/perf/util/evsel.h                         |   4 +
>  tools/perf/util/parse-events.c                  | 131 +++++++++++++++++++---------
>  tools/perf/util/parse-events.h                  |   9 +-
>  tools/perf/util/parse-events.l                  |   6 +-
>  tools/perf/util/parse-events.y                  |  68 +++++++++------
>  tools/perf/util/record.c                        |   2 +
>  24 files changed, 1167 insertions(+), 134 deletions(-)
>  create mode 100644 tools/perf/arch/x86/tests/toggle-event-raw-64.S
>  create mode 100644 tools/perf/tests/toggle-event-group.c
>  create mode 100644 tools/perf/tests/toggle-event-inherit.c
>  create mode 100644 tools/perf/tests/toggle-event-raw.c
