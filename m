Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304AbbAPMab (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 07:30:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56939 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644AbbAPMa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 07:30:29 -0500
Date: Fri, 16 Jan 2015 13:29:00 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will.deacon@arm.com>, Jiri Olsa <jolsa@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexis Berlemont <alexis.berlemont@gmail.com>,
        Andi Kleen <ak@linux.intel.com>, Anton Blanchard <anton@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Borislav Petkov <bp@suse.de>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Florian Fainelli <florian@openwrt.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        "msalter@redhat.com" <msalter@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "S. Lockwood-Childs" <sjl@vctlabs.com>,
        Sam Ravnborg <sam@ravnborg.org>, Sasha Levin <sasha.levin@oracle.com>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: Re: [PATCHv2 00/36] perf tools: New build framework
Message-ID: <20150116122900.GA15672@krava.brq.redhat.com>
References: <1421326532-25660-1-git-send-email-jolsa@kernel.org>
 <20150116113921.GL7091@arm.com>
 <20150116121214.GI21809@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150116121214.GI21809@leverpostej>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2015 at 12:12:14PM +0000, Mark Rutland wrote:
> On Fri, Jan 16, 2015 at 11:39:22AM +0000, Will Deacon wrote:
> > On Thu, Jan 15, 2015 at 12:54:56PM +0000, Jiri Olsa wrote:
> > > hi,
> > > I'm following up on latest post from Alexis:
> > >   http://marc.info/?l=linux-kernel&m=141427580405357&w=2
> > > 
> > > v2 changes:
> > >   - build Makefiles librarized and moved to 'tools/build' [Ingo]
> > >   - several minor fixies [Namhyung]
> > >   - tested on other archs now - x86_64, i386, powerpc
> > >   - moved tools/lib/* under new build framework to show
> > >     that it's possible ;-)
> > >     included traceevent/lockdep maintainers to get the feedback
> > >   - omitted last 2 patches
> > > 
> > > The patchset is also available in:
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
> > >   perf/build
> > > 
> > > All tests/make tests passed.
> > > 
> > > Any feedback from ARM guys would be great ;-)
> > 
> > [adding Mark Rutland to Cc]
> 
> Cheers.
> 
> I just tried a cross-build for arm, and that blew up when trying to do
> something with arch/arm/util/libperf-in.o (log below). I bisected that
> to f169fbc4c59dd9d4 "perf build: Add arch x86 objects building". I'm
> looking into why now.

hum, looks like you dont have anything to be built in arch directory,
so the libperf-in.o is not created:

arch/arm/Build:
  libperf-y += util/
  libperf-$(CONFIG_DWARF_UNWIND) += tests/

arch/arm/util/Build:
  libperf-$(CONFIG_DWARF) += dwarf-regs.o

  libperf-$(CONFIG_LIBUNWIND)          += unwind-libunwind.o
  libperf-$(CONFIG_LIBDW_DWARF_UNWIND) += unwind-libdw.o

if none of CONFIG_DWARF_UNWIND,CONFIG_LIBUNWIND,CONFIG_LIBDW_DWARF_UNWIND
is defined then the final 'arch/arm/util/libperf-in.o' is not created,
because there are no objects for it.. and build fails

I'll come up with the fix

thanks for testing,
jirka



> 
> Thanks,
> Mark.
> 
> [mark@leverpostej:~/src/linux/tools/perf]% make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-
>   BUILD:   Doing 'make -j8' parallel build
> config/Makefile:341: No libelf found, disables 'probe' tool, please install elfutils-libelf-devel/libelf-dev
> config/Makefile:417: Disabling post unwind, no support found.
> config/Makefile:458: No libaudit.h found, disables 'trace' tool, please install audit-libs-devel or libaudit-dev
> config/Makefile:473: slang not found, disables TUI support. Please install slang-devel or libslang-dev
> config/Makefile:487: GTK2 not found, disables GTK2 support. Please install gtk2-devel or libgtk2.0-dev
> config/Makefile:515: Missing perl devel files. Disabling perl scripting support, consider installing perl-ExtUtils-Embed
> config/Makefile:560: No Python.h (for Python 2.x) was found
> config/Makefile:560: Python support will not be built
> config/Makefile:653: No numa.h found, disables 'perf bench numa mem' benchmark, please install numactl-devel/libnuma-devel/libnuma-dev
> 
> Auto-detecting system features:
> ...                         dwarf: [ OFF ]
> ...                         glibc: [ on  ]
> ...                          gtk2: [ OFF ]
> ...                      libaudit: [ OFF ]
> ...                        libbfd: [ OFF ]
> ...                        libelf: [ OFF ]
> ...                       libnuma: [ OFF ]
> ...                       libperl: [ OFF ]
> ...                     libpython: [ OFF ]
> ...                      libslang: [ OFF ]
> ...                     libunwind: [ OFF ]
> ...            libdw-dwarf-unwind: [ OFF ]
> ...                          zlib: [ OFF ]
> 
>   CC       arch/common.o
>   CC       util/alias.o
>   CC       util/abspath.o
>   CC       ui/setup.o
>   CC       event-parse.o
>   CC       fd/array.o
>   LD       arch/arm/libperf-in.o
> arm-linux-gnueabihf-ld: cannot find arch/arm/util/libperf-in.o: No such file or directory
> make[4]: *** [arch/arm/libperf-in.o] Error 1
> make[3]: *** [arm] Error 2
> make[3]: *** Waiting for unfinished jobs....
>   GEN      common-cmds.h
>   LD       fd/libapi-in.o
>   CC       fs/fs.o
>   CC       fs/debugfs.o
>   CC       util/annotate.o
>   CC       ui/helpline.o
>   CC       ui/progress.o
>   CC       ui/util.o
>   LD       fs/libapi-in.o
>   LD       libapi-in.o
>   AR       libapi.a
>   CC       ui/hist.o
> make[2]: *** [arch] Error 2
> make[2]: *** Waiting for unfinished jobs....
>   CC       ui/stdio/hist.o
>   CC       plugin_jbd2.o
>   PERF_VERSION = 3.19.rc2.gcdb397
>   CC       plugin_hrtimer.o
>   CC       plugin_kmem.o
>   LD       plugin_jbd2-in.o
>   CC       plugin_kvm.o
>   LD       plugin_hrtimer-in.o
>   CC       plugin_mac80211.o
>   CC       event-plugin.o
>   LD       plugin_kmem-in.o
>   CC       trace-seq.o
>   LD       plugin_mac80211-in.o
>   LD       plugin_kvm-in.o
>   CC       parse-filter.o
>   CC       plugin_sched_switch.o
>   CC       parse-utils.o
>   CC       kbuffer-parse.o
>   CC       plugin_function.o
>   LD       plugin_sched_switch-in.o
>   CC       plugin_xen.o
>   CC       plugin_scsi.o
>   LD       plugin_xen-in.o
>   LD       plugin_function-in.o
>   CC       plugin_cfg80211.o
>   LINK     plugin_jbd2.so
>   LINK     plugin_hrtimer.so
>   LINK     plugin_kmem.so
>   LINK     plugin_kvm.so
>   LD       plugin_cfg80211-in.o
>   CC       builtin-bench.o
>   LD       plugin_scsi-in.o
>   LINK     plugin_mac80211.so
>   LINK     plugin_sched_switch.so
>   CC       builtin-annotate.o
>   LD       libtraceevent-in.o
>   LINK     plugin_function.so
>   LINK     plugin_xen.so
>   LINK     plugin_scsi.so
>   LINK     plugin_cfg80211.so
>   CC       util/build-id.o
>   CC       util/config.o
>   LINK     libtraceevent.a
>   GEN      perf-archive
>   GEN      perf-with-kcore
>   CC       util/ctype.o
>   CC       builtin-diff.o
>   CC       util/db-export.o
>   CC       util/environment.o
>   CC       builtin-evlist.o
>   CC       util/event.o
>   CC       util/evlist.o
>   CC       util/evsel.o
>   CC       util/exec_cmd.o
>   CC       builtin-help.o
>   CC       util/find_next_bit.o
>   CC       builtin-sched.o
>   CC       util/help.o
>   CC       builtin-buildid-list.o
>   CC       builtin-buildid-cache.o
>   CC       util/kallsyms.o
>   CC       builtin-list.o
>   CC       util/levenshtein.o
>   CC       util/parse-options.o
>   LD       ui/libperf-in.o
>   BISON    util/parse-events-bison.c
>   CC       builtin-record.o
>   CC       builtin-report.o
>   CC       util/path.o
>   CC       util/rbtree.o
>   CC       util/bitmap.o
>   CC       util/hweight.o
>   CC       util/run-command.o
>   CC       util/quote.o
>   CC       builtin-stat.o
>   CC       util/strbuf.o
>   CC       builtin-timechart.o
>   CC       builtin-top.o
>   CC       util/string.o
>   CC       util/strlist.o
>   CC       builtin-script.o
>   CC       builtin-kmem.o
>   CC       util/strfilter.o
>   CC       util/top.o
>   CC       builtin-lock.o
>   CC       util/usage.o
>   CC       util/wrapper.o
>   CC       util/sigchain.o
>   CC       builtin-kvm.o
>   CC       util/dso.o
>   CC       util/symbol.o
>   CC       util/color.o
>   CC       builtin-inject.o
>   CC       util/pager.o
>   CC       util/header.o
>   CC       builtin-mem.o
>   CC       util/callchain.o
>   CC       bench/sched-messaging.o
>   CC       bench/sched-pipe.o
>   CC       util/values.o
>   CC       util/debug.o
>   CC       util/machine.o
>   CC       tests/builtin-test.o
>   CC       bench/mem-memcpy.o
>   CC       util/map.o
>   CC       util/pstack.o
>   CC       tests/parse-events.o
>   CC       bench/futex-hash.o
>   CC       perf.o
>   CC       util/session.o
>   CC       bench/futex-wake.o
>   CC       util/ordered-events.o
>   CC       bench/futex-requeue.o
>   CC       tests/dso-data.o
>   CC       tests/attr.o
>   CC       util/comm.o
>   CC       util/thread.o
>   LD       bench/perf-in.o
>   CC       util/thread_map.o
>   CC       util/trace-event-parse.o
>   CC       tests/vmlinux-kallsyms.o
>   CC       tests/open-syscall.o
>   CC       tests/open-syscall-all-cpus.o
>   CC       util/parse-events-bison.o
>   BISON    util/pmu-bison.c
>   CC       util/trace-event-read.o
>   CC       tests/open-syscall-tp-fields.o
>   CC       util/trace-event-info.o
>   CC       util/trace-event-scripting.o
>   CC       util/trace-event.o
>   CC       util/svghelper.o
>   CC       tests/mmap-basic.o
>   CC       util/sort.o
>   CC       util/hist.o
>   CC       util/util.o
>   CC       util/xyarray.o
>   CC       tests/perf-record.o
>   CC       util/cpumap.o
>   CC       tests/rdpmc.o
>   CC       util/cgroup.o
>   CC       util/target.o
>   CC       tests/evsel-roundtrip-name.o
>   CC       tests/evsel-tp-sched.o
>   CC       util/rblist.o
>   CC       util/intlist.o
>   CC       util/vdso.o
>   CC       tests/fdarray.o
>   CC       util/stat.o
>   CC       util/record.o
>   CC       util/srcline.o
>   CC       tests/pmu.o
>   CC       util/data.o
>   CC       util/tsc.o
>   CC       util/cloexec.o
>   CC       util/thread-stack.o
>   CC       tests/hists_common.o
>   CC       util/symbol-minimal.o
>   CC       util/perf_regs.o
>   FLEX     util/parse-events-flex.c
>   CC       tests/hists_link.o
>   FLEX     util/pmu-flex.c
>   CC       util/pmu-bison.o
>   CC       util/parse-events.o
>   CC       util/parse-events-flex.o
>   CC       util/pmu.o
>   CC       tests/hists_filter.o
>   CC       util/pmu-flex.o
>   CC       tests/hists_output.o
>   CC       tests/hists_cumulate.o
>   CC       tests/python-use.o
>   CC       tests/bp_signal.o
>   CC       tests/bp_signal_overflow.o
>   CC       tests/task-exit.o
>   CC       tests/sw-clock.o
>   CC       tests/mmap-thread-lookup.o
>   CC       tests/thread-mg-share.o
>   CC       tests/switch-tracking.o
>   CC       tests/keep-tracking.o
>   CC       tests/code-reading.o
>   CC       tests/sample-parsing.o
>   CC       tests/parse-no-sample-id-all.o
>   LD       util/libperf-in.o
> make[1]: *** [libperf-in.o] Error 2
> make[1]: *** Waiting for unfinished jobs....
>   LD       tests/perf-in.o
>   LD       perf-in.o
> make: *** [all] Error 2
> [
