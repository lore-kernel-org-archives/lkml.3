Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073AbaDVKUM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 06:20:12 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48244 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754432AbaDVKUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 06:20:07 -0400
Date: Tue, 22 Apr 2014 12:20:00 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: Fu Wei <fu.wei@linaro.org>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Robert Richter <rric@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 00/16] perf, persistent: Add persistent events
Message-ID: <20140422102000.GA15882@pd.tnic>
References: <1396883078-25320-1-git-send-email-jean.pihet@linaro.org>
 <CAFrcx1=0TddfPS322728w3AsK5SzJ1sq-7VTbE=+Pb-EqcrncQ@mail.gmail.com>
 <20140417125030.GA4321@pd.tnic>
 <CAFrcx1noiierVs1tpkoqQ=L-Si0Xt5yVBvG3jgpi4hXepcabrg@mail.gmail.com>
 <20140417132157.GC4321@pd.tnic>
 <CAFrcx1n4VrLt7Vg2Rq73qkZ57DDTDN5uNLNLEQ1-Wt43X3SgTQ@mail.gmail.com>
 <CAFrcx1nL3Sc=vsxUwFqnoqgaFQcwbGROku8jpaxV0zUR0Hk-1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAFrcx1nL3Sc=vsxUwFqnoqgaFQcwbGROku8jpaxV0zUR0Hk-1g@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 12:07:07PM +0200, Jean Pihet wrote:
> Hi,
> 
> -- adding Fu Wei in the loop--
> 
> Fu Wei is working on the RAS daemon, which is a user of libperf. It is

Good. :)

> crucial to agree on the libperf API in order to start with the correct
> implementation.

Again, it should be a libperf library which contains only the
perf-specific bits. I've done a rough carve out, see the mail below.

However, then we started a conversation in a smaller thread which lead
to

https://lkml.kernel.org/r/20140329094250.GA11987@nazgul.tnic

In any case, the basic perf tool functionality which we need right
now is in the last 4 patches of these 16 - we want to be able to
open/enable/close/... persistent events in the ras daemon without the
perf tool, i.e. link to as many libraries as needed in tools/.

Also, libperf should not be exposed to external users... for now.

And yes, carving out perf tool functionality is very tedious work -
that's why I've dropped to sending only a couple of patches at once so
that merge conflicts can be avoided.

What else,... hmm, yeah, that should be it. Just take a look at those
mails and let me know. Also, this whole thing is not the final design -
we're just hashing out ideas and changing things as we go.

Thanks!

--
>From bp@alien8.de Fri Nov 15 21:29:18 2013
Date: Fri, 15 Nov 2013 21:28:48 +0100
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>, Arnaldo Carvalho de Melo
 <acme@infradead.org>
Cc: Robert Richter <rric@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Jiri Olsa <jolsa@redhat.com>
Subject: Re: persistent events: Tooling support; perf tool splitup
Message-ID: <20131115202848.GK29277@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=utf-8
Status: RO

Hi guys,

I'm finally ready with the next attempt at a carve out of the facilities
in tools/perf/ into libraries for external use. I'm adding the diffstat
of the patches below with comments so that you can see how it would look
like. Once we all agree on the structure, I'll start feeding acme 1-2
patches at a time so that there are no big merge issues.

Comments and suggestions are, as always, very welcome and needed. :-)

* The first group are the kernel headers any tools in tools/
could/are/would be using. I've put them into tools/include/ because it
leaves the #include <linux...> directives unchanged.

But since we're making a liblk kernel library, I can imagine putting
them into tools/lib/lk/ and making all part of that generic library.

 tools/{perf/util => }/include/asm/bug.h            |    6 +-
 tools/{perf/util => }/include/linux/bitmap.h       |    7 +-
 tools/{perf/util => }/include/linux/bitops.h       |   12 +-
 tools/{perf/util => }/include/linux/compiler.h     |    8 +-
 tools/{perf/util => }/include/linux/kernel.h       |    6 +-
 tools/{perf/util => }/include/linux/list.h         |    9 +-
 tools/{perf/util => }/include/linux/types.h        |    6 +-
 tools/include/asm/byteorder.h                      |    2 +
 tools/include/linux/export.h                       |    6 +
 tools/include/linux/hash.h                         |    8 +
 tools/include/linux/poison.h                       |    1 +
 tools/include/linux/prefetch.h                     |    6 +
 tools/include/linux/rbtree.h                       |    3 +
 tools/include/linux/rbtree_augmented.h             |    2 +

This is tools/lib/lk/liblk.a which contains only compilation units which
contain generic code. The idea behind this library is to be used by all
tools in tools/.

 tools/{perf/util => lib/lk}/color.c                |   69 +-
 tools/{perf/util => lib/lk}/color.h                |   34 +-
 tools/{perf/util => lib/lk}/cpumap.c               |    9 +-
 tools/{perf/util => lib/lk}/cpumap.h               |    4 +
 tools/{perf/util => lib/lk}/ctype.c                |    2 +-
 tools/{perf/util => lib/lk}/hweight.c              |    1 +
 tools/{perf/util => lib/lk}/include/linux/magic.h  |    0
 tools/{perf/util => lib/lk}/parse-options.c        |    6 +-
 tools/{perf/util => lib/lk}/parse-options.h        |   13 +-
 tools/{perf/util => lib/lk}/rblist.c               |    0
 tools/{perf/util => lib/lk}/rblist.h               |    6 +-
 tools/{perf/util => lib/lk}/strbuf.c               |    3 +-
 tools/{perf/util => lib/lk}/strbuf.h               |   15 +-
 tools/{perf/util => lib/lk}/string.c               |   42 +-
 tools/{perf/util => lib/lk}/strlist.c              |    0
 tools/{perf/util => lib/lk}/strlist.h              |    6 +-
 tools/{perf/util => lib/lk}/sysfs.c                |    4 +
 tools/{perf/util => lib/lk}/thread_map.c           |    0
 tools/{perf/util => lib/lk}/thread_map.h           |    6 +-
 tools/{perf/util => lib/lk}/types.h                |    6 +-
 tools/{perf/util => lib/lk}/usage.c                |    2 +-
 tools/{perf/util => lib/lk}/wrapper.c              |    3 +-
 tools/{perf/util => lib/lk}/xyarray.c              |    0
 tools/{perf/util => lib/lk}/xyarray.h              |    6 +-
 tools/lib/lk/Makefile                              |   62 +-
 tools/lib/lk/config.c                              |  370 ++++++
 tools/lib/lk/config.h                              |   13 +
 tools/lib/lk/ctype.h                               |   37 +
 tools/lib/lk/hweight.h                             |   13 +
 tools/lib/lk/string.h                              |   21 +
 tools/lib/lk/sysfs.h                               |   12 +
 tools/lib/lk/usage.h                               |   34 +
 tools/lib/lk/util.c                                |   18 +
 tools/lib/lk/util.h                                |   38 +
 tools/lib/lk/wrapper.h                             |   27 +

This is lib/perf/libperfevent.a which got initiated from exporting
evsel.* and evlist.* which I'm going to need for other tools to use.
Diffstat shows what moves in there, I've tried to keep it as small as
possible.

 tools/{perf/util => lib/perf}/callchain.c          |    4 +-
 tools/{perf/util => lib/perf}/callchain.h          |   12 +-
 tools/{perf/util => lib/perf}/cgroup.c             |    8 +-
 tools/{perf/util => lib/perf}/cgroup.h             |    7 +-
 tools/{perf/util => lib/perf}/debug.c              |   29 +-
 tools/{perf/util => lib/perf}/debug.h              |   19 +-
 tools/{perf/util => lib/perf}/dso.c                |    8 +-
 tools/{perf/util => lib/perf}/dso.h                |   11 +-
 tools/{perf/util => lib/perf}/event.c              |  109 +-
 tools/{perf/util => lib/perf}/event.h              |   12 +-
 tools/{perf/util => lib/perf}/evlist.c             |   37 +-
 tools/{perf/util => lib/perf}/evlist.h             |   15 +-
 tools/{perf/util => lib/perf}/evsel.c              |   38 +-
 tools/{perf/util => lib/perf}/evsel.h              |   33 +-
 tools/{perf/util => lib/perf}/map.c                |   10 +-
 tools/{perf/util => lib/perf}/map.h                |    9 +-
 tools/{perf/util => lib/perf}/path.c               |   28 +-
 tools/{perf/util => lib/perf}/perf_regs.h          |    6 +-
 tools/{perf/util => lib/perf}/symbol.c             |    6 +-
 tools/{perf/util => lib/perf}/symbol.h             |   10 +-
 tools/{perf/util => lib/perf}/target.c             |    3 -
 tools/{perf/util => lib/perf}/target.h             |   12 +-
 tools/{perf/util => lib/perf}/thread.h             |    7 +-
 tools/{perf/util => lib/perf}/tool.h               |    6 +-
 tools/{perf/util => lib/perf}/vdso.c               |    4 +-
 tools/{perf/util => lib/perf}/vdso.h               |    6 +-
 tools/lib/perf/Makefile                            |   83 ++
 tools/lib/perf/arch.h                              |  112 ++
 tools/lib/perf/build-id.c                          |  102 ++
 tools/lib/perf/build-id.h                          |   32 +
 tools/lib/perf/hist.h                              |   69 ++
 tools/lib/perf/machine.c                           | 1268 ++++++++++++++++++++
 tools/lib/perf/machine.h                           |  168 +++
 tools/lib/perf/path.h                              |   29 +
 tools/lib/perf/perf.c                              |   29 +
 tools/lib/perf/perf.h                              |  105 ++
 tools/lib/perf/thread.c                            |  187 +++

Rest is changes to tools/perf/

 tools/perf/MANIFEST                                |    3 -
 tools/perf/Makefile                                |  136 +--
 tools/perf/arch/common.c                           |    4 +-
 tools/perf/arch/x86/include/perf_regs.h            |    2 +-
 tools/perf/arch/x86/util/header.c                  |    2 +-
 tools/perf/arch/x86/util/tsc.c                     |    4 +-
 tools/perf/arch/x86/util/tsc.h                     |    2 +-
 tools/perf/bench/mem-memcpy.c                      |    8 +-
 tools/perf/bench/mem-memset.c                      |    8 +-
 tools/perf/bench/numa.c                            |    6 +-
 tools/perf/bench/sched-messaging.c                 |    4 +-
 tools/perf/bench/sched-pipe.c                      |    4 +-
 tools/perf/builtin-annotate.c                      |   21 +-
 tools/perf/builtin-bench.c                         |    4 +-
 tools/perf/builtin-buildid-cache.c                 |   12 +-
 tools/perf/builtin-buildid-list.c                  |   19 +-
 tools/perf/builtin-diff.c                          |   14 +-
 tools/perf/builtin-evlist.c                        |    8 +-
 tools/perf/builtin-help.c                          |   15 +-
 tools/perf/builtin-inject.c                        |   18 +-
 tools/perf/builtin-kmem.c                          |   16 +-
 tools/perf/builtin-kvm.c                           |   20 +-
 tools/perf/builtin-lock.c                          |   20 +-
 tools/perf/builtin-mem.c                           |    6 +-
 tools/perf/builtin-probe.c                         |   10 +-
 tools/perf/builtin-record.c                        |  162 ++-
 tools/perf/builtin-report.c                        |   26 +-
 tools/perf/builtin-sched.c                         |   21 +-
 tools/perf/builtin-script.c                        |   18 +-
 tools/perf/builtin-stat.c                          |   29 +-
 tools/perf/builtin-timechart.c                     |   21 +-
 tools/perf/builtin-top.c                           |   27 +-
 tools/perf/builtin-trace.c                         |   41 +-
 tools/perf/builtin.h                               |    2 +-
 tools/perf/config/Makefile                         |    4 +-
 tools/perf/perf.c                                  |   18 +-
 tools/perf/perf.h                                  |  187 +--
 tools/perf/tests/attr.c                            |    5 +-
 tools/perf/tests/bp_signal.c                       |    2 +-
 tools/perf/tests/bp_signal_overflow.c              |    2 +-
 tools/perf/tests/builtin-test.c                    |   15 +-
 tools/perf/tests/code-reading.c                    |   14 +-
 tools/perf/tests/dso-data.c                        |    6 +-
 tools/perf/tests/evsel-roundtrip-name.c            |    6 +-
 tools/perf/tests/evsel-tp-sched.c                  |    2 +-
 tools/perf/tests/hists_link.c                      |   12 +-
 tools/perf/tests/keep-tracking.c                   |    8 +-
 tools/perf/tests/mmap-basic.c                      |    9 +-
 tools/perf/tests/open-syscall-all-cpus.c           |    8 +-
 tools/perf/tests/open-syscall-tp-fields.c          |    6 +-
 tools/perf/tests/open-syscall.c                    |    6 +-
 tools/perf/tests/parse-events.c                    |    9 +-
 tools/perf/tests/parse-no-sample-id-all.c          |    4 +-
 tools/perf/tests/perf-record.c                     |    6 +-
 tools/perf/tests/perf-time-to-tsc.c                |    8 +-
 tools/perf/tests/python-use.c                      |    2 -
 tools/perf/tests/rdpmc.c                           |    4 +-
 tools/perf/tests/sample-parsing.c                  |    5 +-
 tools/perf/tests/sw-clock.c                        |    8 +-
 tools/perf/tests/task-exit.c                       |    8 +-
 tools/perf/tests/tests.h                           |    4 +
 tools/perf/tests/vmlinux-kallsyms.c                |    7 +-
 tools/perf/ui/browser.c                            |    2 +-
 tools/perf/ui/browser.h                            |    2 +-
 tools/perf/ui/browsers/annotate.c                  |    8 +-
 tools/perf/ui/browsers/hists.c                     |    6 +-
 tools/perf/ui/browsers/map.c                       |    4 +-
 tools/perf/ui/browsers/scripts.c                   |    7 +-
 tools/perf/ui/gtk/annotate.c                       |    4 +-
 tools/perf/ui/gtk/browser.c                        |    6 +-
 tools/perf/ui/gtk/helpline.c                       |    2 +-
 tools/perf/ui/gtk/hists.c                          |    6 +-
 tools/perf/ui/gtk/setup.c                          |    2 +-
 tools/perf/ui/gtk/util.c                           |    2 +-
 tools/perf/ui/helpline.c                           |    2 +-
 tools/perf/ui/helpline.h                           |    1 -
 tools/perf/ui/hist.c                               |    4 +-
 tools/perf/ui/progress.h                           |    2 +-
 tools/perf/ui/setup.c                              |    4 +-
 tools/perf/ui/stdio/hist.c                         |    4 +-
 tools/perf/ui/tui/helpline.c                       |    2 +-
 tools/perf/ui/tui/setup.c                          |    3 +-
 tools/perf/ui/tui/util.c                           |    2 +-
 tools/perf/ui/ui.h                                 |    4 +-
 tools/perf/ui/util.c                               |    2 +-
 tools/perf/util/abspath.c                          |    2 +
 tools/perf/util/alias.c                            |    2 +-
 tools/perf/util/annotate.c                         |   14 +-
 tools/perf/util/annotate.h                         |    4 +-
 tools/perf/util/build-id.c                         |  129 +-
 tools/perf/util/build-id.h                         |   24 +-
 tools/perf/util/cache.h                            |   45 +-
 tools/perf/util/config.c                           |  463 +------
 tools/perf/util/dwarf-aux.c                        |    2 +-
 tools/perf/util/exec_cmd.c                         |   10 +-
 tools/perf/util/exec_cmd.h                         |    6 +-
 tools/perf/util/header.c                           |   30 +-
 tools/perf/util/header.h                           |   16 +-
 tools/perf/util/help.c                             |    2 +-
 tools/perf/util/hist.c                             |   70 +-
 tools/perf/util/hist.h                             |  195 ++-
 tools/perf/util/include/asm/byteorder.h            |    2 -
 tools/perf/util/include/asm/hweight.h              |    8 -
 tools/perf/util/include/linux/export.h             |    6 -
 tools/perf/util/include/linux/hash.h               |    5 -
 tools/perf/util/include/linux/poison.h             |    1 -
 tools/perf/util/include/linux/prefetch.h           |    6 -
 tools/perf/util/include/linux/rbtree.h             |    2 -
 tools/perf/util/include/linux/rbtree_augmented.h   |    2 -
 tools/perf/util/include/linux/string.h             |    4 -
 tools/perf/util/intlist.h                          |    2 +-
 tools/perf/util/machine.c                          | 1258 +------------------
 tools/perf/util/machine.h                          |  163 +--
 tools/perf/util/pager.c                            |   15 +-
 tools/perf/util/parse-events.c                     |   12 +-
 tools/perf/util/parse-events.h                     |    3 +-
 tools/perf/util/parse-events.y                     |    2 +-
 tools/perf/util/pmu.c                              |    4 +-
 tools/perf/util/probe-event.c                      |   14 +-
 tools/perf/util/probe-event.h                      |    2 +-
 tools/perf/util/probe-finder.c                     |    7 +-
 tools/perf/util/probe-finder.h                     |    2 +
 tools/perf/util/python-ext-sources                 |   22 +-
 tools/perf/util/python.c                           |   12 +-
 tools/perf/util/record.c                           |    8 +-
 .../perf/util/scripting-engines/trace-event-perl.c |    6 +-
 .../util/scripting-engines/trace-event-python.c    |    6 +-
 tools/perf/util/session.c                          |   17 +-
 tools/perf/util/session.h                          |    8 +-
 tools/perf/util/setup.py                           |    3 +-
 tools/perf/util/sort.c                             |    8 +-
 tools/perf/util/sort.h                             |   83 +-
 tools/perf/util/stat.h                             |    2 +-
 tools/perf/util/strfilter.c                        |    2 +
 tools/perf/util/svghelper.h                        |    2 +-
 tools/perf/util/symbol-elf.c                       |    4 +-
 tools/perf/util/symbol-minimal.c                   |    2 +-
 tools/perf/util/sysfs.h                            |    6 -
 tools/perf/util/thread.c                           |   91 --
 tools/perf/util/top.c                              |   10 +-
 tools/perf/util/top.h                              |    6 +-
 tools/perf/util/trace-event-info.c                 |    2 +-
 tools/perf/util/trace-event-read.c                 |    2 -
 tools/perf/util/unwind.c                           |    4 +-
 tools/perf/util/unwind.h                           |    6 +-
 tools/perf/util/util.c                             |   98 +-
 tools/perf/util/util.h                             |  193 ++-
 tools/perf/util/values.h                           |    2 +-
 238 files changed, 4299 insertions(+), 3722 deletions(-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--




> 
> Jean
> 
> On 22 April 2014 10:20, Jean Pihet <jean.pihet@linaro.org> wrote:
> > Hi Borislav,
> >
> > On 17 April 2014 15:21, Borislav Petkov <bp@alien8.de> wrote:
> >> Hi Jean,
> >>
> >> On Thu, Apr 17, 2014 at 03:17:01PM +0200, Jean Pihet wrote:
> >>> Yes indeed!
> >>>
> >>> Ingo,
> >>> Is the perf support for persistent event needed, or can this series be
> >>> reviewed as is?
> >>>
> >>> In the meantime I am now working on the perf tool:
> >>> - add persistent events,
> >>> - factor out the code and provide a library (libperf) for other tool
> >>> to use it (e.g. monitoring daemon).
> >>
> >> Ok, good. I'm doing a bit too:
> >>
> >> https://lkml.org/lkml/2014/4/13/20
> >>
> >> so let's synchronize and get this thing going. I'll add you to my CC
> >> list on future submissions.
> > Ok, great!
> >
> > About libperf and the persistent events, do you know more details
> > about the status and the proposed API? I have no info about the work
> > that was started previously.
> >
> > Regards,
> > Jean
> >
> >>
> >> Thanks.
> >>
> >> --
> >> Regards/Gruss,
> >>     Boris.
> >>
> >> Sent from a fat crate under my desk. Formatting is fine.
> >> --
> 

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
