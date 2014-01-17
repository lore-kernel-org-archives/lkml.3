Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbaAQO2f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 09:28:35 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:46569 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbaAQO2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 09:28:31 -0500
Date: Fri, 17 Jan 2014 11:28:23 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Ahern <dsahern@gmail.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Jean Pihet <jean.pihet@linaro.org>
Subject: Re: [PATCH 00/16] perf tools: Add libdw DWARF unwind support
Message-ID: <20140117142823.GA3207@ghostprotocols.net>
References: <1389098853-14466-1-git-send-email-jolsa@redhat.com>
 <20140117122431.GC1130@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140117122431.GC1130@krava.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jan 17, 2014 at 01:24:31PM +0100, Jiri Olsa escreveu:
> ping ;-)

I'll try and test this this afternoon to possibly get it in the next
pull req, after the one I'll do shortly
 
> thanks,
> jirka
> 
> On Tue, Jan 07, 2014 at 01:47:17PM +0100, Jiri Olsa wrote:
> > hi,
> > adding libdw DWARF unwind support, which is part of just released
> > elfutils package 0.158.
> > 
> > We can now compile perf to have either libunwind DWARF unwind,
> > (which is still default) or the new one libdw unwind.
> > 
> > Examples:
> >   - compile in libdw unwinder if present:
> >     $ make NO_LIBUNWIND=1
> > 
> >   - compile in libdw (with libdw installation directory) unwinder if present:
> >     $ make LIBDW_DIR=/opt/elfutils/ NO_LIBUNWIND=1
> > 
> >   - disable post dwarf unwind completely:
> >     $ make NO_LIBUNWIND=1 NO_LIBDW_DWARF_UNWIND=1
> > 
> > Performance wise the libdw unwinder seems to be faster.
> > Following results are from 2GB perf.data file with 249156
> > samples:
> > 
> >   The libdw unwind perf:
> >   $ time perf report -i ~/perf.data > perf.data.ldw
> > 
> >   real    0m35.746s
> >   user    0m24.211s
> >   sys     0m11.214s
> > 
> >   The libunwind unwind perf:
> >   $ time perf report -i ~/perf.data > perf.data.unw
> > 
> >   real    1m41.149s
> >   user    1m9.694s
> >   sys     0m30.595s
> > 
> > In example above I've got 2206 differences (perf.data.ldw and
> > perf.data.unw files) in the callchains output out of the 249156
> > samples which is below 1%. Together with some other tips for speed
> > increase it's on my TODO list for future.
> > 
> > Git tree:
> >   https://git.kernel.org/cgit/linux/kernel/git/jolsa/perf.git/
> >   perf/core_libdw_unwind
> > 
> > Kudos to Jan Kratochvil for helping me with the new interface.
> > 
> > Jean,
> > I haven't tested on arm.. so not sure I broke anything there.
> > Any chance you could test for me, and maybe make the automated
> > test I added work there? ;-)
> > 
> > thanks,
> > jirka
> > 
> > 
> > Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> > Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Namhyung Kim <namhyung@kernel.org>
> > Cc: Paul Mackerras <paulus@samba.org>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> > Cc: David Ahern <dsahern@gmail.com>
> > Cc: Jan Kratochvil <jan.kratochvil@redhat.com>
> > Cc: Jean Pihet <jean.pihet@linaro.org>
> > ---
> > Jiri Olsa (16):
> >       perf tools: Automate setup of FEATURE_CHECK_(C|LD)FLAGS-all variables
> >       perf tools: Fix machine initialization
> >       perf tools: Make perf_event__synthesize_mmap_events global
> >       perf tests x86: Introduce perf_regs_load function
> >       perf tests x86: Add dwarf unwind test
> >       perf tools: Fix dwarf unwind max_stack processing
> >       perf tools: Do not report zero address in unwind
> >       perf tools: Add mask into struct regs_dump
> >       perf tools: Separate libunwind code to special object
> >       perf tools: Rename unwind__arch_reg_id into libunwind__arch_reg_id
> >       perf tools: Introduce HAVE_DWARF_UNWIND_SUPPORT macro
> >       perf tools: Separate perf_reg_value function in perf_regs object
> >       perf tools: Add feature check for libdw dwarf unwind
> >       perf tools: Add libdw DWARF post unwind support
> >       perf tools: Setup default dwarf post unwinder
> >       perf tests: Add NO_LIBDW_DWARF_UNWIND make test
> > 
> >  tools/perf/Makefile.perf                                   |  19 ++++++-
> >  tools/perf/arch/arm/Makefile                               |   2 +-
> >  tools/perf/arch/arm/util/{unwind.c => unwind-libunwind.c}  |   2 +-
> >  tools/perf/arch/x86/Makefile                               |   9 +++-
> >  tools/perf/arch/x86/include/perf_regs.h                    |   6 +++
> >  tools/perf/arch/x86/tests/dwarf-unwind.c                   |  59 ++++++++++++++++++++
> >  tools/perf/arch/x86/tests/regs_load.S                      |  92 ++++++++++++++++++++++++++++++++
> >  tools/perf/arch/x86/util/unwind-libdw.c                    |  51 ++++++++++++++++++
> >  tools/perf/arch/x86/util/{unwind.c => unwind-libunwind.c}  |   4 +-
> >  tools/perf/builtin-inject.c                                |   1 -
> >  tools/perf/builtin-record.c                                |  10 ++--
> >  tools/perf/config/Makefile                                 |  94 +++++++++++++++++++++++---------
> >  tools/perf/config/feature-checks/Makefile                  |   6 ++-
> >  tools/perf/config/feature-checks/test-all.c                |   5 ++
> >  tools/perf/config/feature-checks/test-libdw-dwarf-unwind.c |  13 +++++
> >  tools/perf/tests/builtin-test.c                            |   8 +++
> >  tools/perf/tests/dwarf-unwind.c                            | 144 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  tools/perf/tests/make                                      |  63 +++++++++++-----------
> >  tools/perf/tests/sample-parsing.c                          |  17 +++---
> >  tools/perf/tests/tests.h                                   |   9 ++++
> >  tools/perf/util/event.c                                    |  12 ++---
> >  tools/perf/util/event.h                                    |  12 ++++-
> >  tools/perf/util/evsel.c                                    |  13 ++---
> >  tools/perf/util/machine.c                                  |   4 +-
> >  tools/perf/util/perf_regs.c                                |  19 +++++++
> >  tools/perf/util/perf_regs.h                                |  13 +++++
> >  tools/perf/util/session.c                                  |   5 +-
> >  tools/perf/util/unwind-libdw.c                             | 210 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tools/perf/util/unwind-libdw.h                             |  21 ++++++++
> >  tools/perf/util/{unwind.c => unwind-libunwind.c}           |  50 ++++++-----------
> >  tools/perf/util/unwind.h                                   |  11 ++--
> >  31 files changed, 849 insertions(+), 135 deletions(-)
> >  rename tools/perf/arch/arm/util/{unwind.c => unwind-libunwind.c} (95%)
> >  create mode 100644 tools/perf/arch/x86/tests/dwarf-unwind.c
> >  create mode 100644 tools/perf/arch/x86/tests/regs_load.S
> >  create mode 100644 tools/perf/arch/x86/util/unwind-libdw.c
> >  rename tools/perf/arch/x86/util/{unwind.c => unwind-libunwind.c} (95%)
> >  create mode 100644 tools/perf/config/feature-checks/test-libdw-dwarf-unwind.c
> >  create mode 100644 tools/perf/tests/dwarf-unwind.c
> >  create mode 100644 tools/perf/util/perf_regs.c
> >  create mode 100644 tools/perf/util/unwind-libdw.c
> >  create mode 100644 tools/perf/util/unwind-libdw.h
> >  rename tools/perf/util/{unwind.c => unwind-libunwind.c} (92%)
