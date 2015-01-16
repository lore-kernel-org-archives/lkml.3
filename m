Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162AbbAPNtm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 08:49:42 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:35995 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438AbbAPNtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 08:49:40 -0500
Date: Fri, 16 Jan 2015 13:49:10 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Will Deacon <Will.Deacon@arm.com>, Jiri Olsa <jolsa@kernel.org>,
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
        Ingo Molnar <mingo@kernel.org>,
        "msalter@redhat.com" <msalter@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "S. Lockwood-Childs" <sjl@vctlabs.com>,
        Sam Ravnborg <sam@ravnborg.org>, Sasha Levin <sasha.levin@oracle.com>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: Re: [PATCHv2 00/36] perf tools: New build framework
Message-ID: <20150116134910.GA22569@leverpostej>
References: <1421326532-25660-1-git-send-email-jolsa@kernel.org>
 <20150116113921.GL7091@arm.com>
 <20150116121214.GI21809@leverpostej>
 <20150116122221.GN7091@arm.com>
 <20150116123013.GB15672@krava.brq.redhat.com>
 <20150116124349.GA23967@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150116124349.GA23967@krava.brq.redhat.com>
Thread-Topic: [PATCHv2 00/36] perf tools: New build framework
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[...]

> > > > I just tried a cross-build for arm, and that blew up when trying to do
> > > > something with arch/arm/util/libperf-in.o (log below). I bisected that
> > > > to f169fbc4c59dd9d4 "perf build: Add arch x86 objects building". I'm
> > > > looking into why now.
> > > 
> > > I get a similar failure doing a native arm64 build. I think the problem is
> > > because the arch/ files for arm and arm64 aren't always required (i.e. there
> > > are configurations where nothing is built under there) and, consequently,
> > > libperf-in.o isn't actually needed and we try to link against something that
> > > doesn't exist.
> > 
> > exactly ;-) I'll spin v3 shortly..
> 
> this fixes the issue for me
> 
> jirka
> 
> 
> ---
> diff --git a/tools/build/Makefile.build b/tools/build/Makefile.build
> index d35b66014992..396b33b124d1 100644
> --- a/tools/build/Makefile.build
> +++ b/tools/build/Makefile.build
> @@ -52,7 +52,7 @@ quiet_cmd_cc_s_c = AS       $@
>  
>  # Link agregate command
>  quiet_cmd_ld_multi = LD       $@
> -      cmd_ld_multi = $(LD) -r -o $@ $^
> +      cmd_ld_multi = $(LD) -r -o $@ $(wildcard $^)
>  
>  # Build rules
>  $(OUTPUT)%.o: %.c FORCE
> 

Unfortunately that doesn't seem to be sufficient for me when
cross-compiling. It looks like it supresses the warning from Make, but
then LD explodes anyway because it wasn't provided any input files (log
below).

Thanks,
Mark.

[mark@leverpostej:~/src/linux/tools/perf]% uselinaro 14.09 make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-
  BUILD:   Doing 'make -j8' parallel build
config/Makefile:341: No libelf found, disables 'probe' tool, please install elfutils-libelf-devel/libelf-dev
config/Makefile:417: Disabling post unwind, no support found.
config/Makefile:458: No libaudit.h found, disables 'trace' tool, please install audit-libs-devel or libaudit-dev
config/Makefile:473: slang not found, disables TUI support. Please install slang-devel or libslang-dev
config/Makefile:487: GTK2 not found, disables GTK2 support. Please install gtk2-devel or libgtk2.0-dev
config/Makefile:515: Missing perl devel files. Disabling perl scripting support, consider installing perl-ExtUtils-Embed
config/Makefile:560: No Python.h (for Python 2.x) was found
config/Makefile:560: Python support will not be built
config/Makefile:653: No numa.h found, disables 'perf bench numa mem' benchmark, please install numactl-devel/libnuma-devel/libnuma-dev

Auto-detecting system features:
...                         dwarf: [ OFF ]
...                         glibc: [ on  ]
...                          gtk2: [ OFF ]
...                      libaudit: [ OFF ]
...                        libbfd: [ OFF ]
...                        libelf: [ OFF ]
...                       libnuma: [ OFF ]
...                       libperl: [ OFF ]
...                     libpython: [ OFF ]
...                      libslang: [ OFF ]
...                     libunwind: [ OFF ]
...            libdw-dwarf-unwind: [ OFF ]
...                          zlib: [ OFF ]

  SUBDIR   /home/mark/src/linux/tools/lib/api/
  FLAGS:   * new build flags or prefix
  GEN      common-cmds.h
  MKDIR    libapi_dirs
  SUBDIR   /home/mark/src/linux/tools/lib/traceevent/
  CC       fs/debugfs.o
  CC       arch/common.o
  CC       fs/fs.o
  CC       fd/array.o
  CC       util/abspath.o
  FLAGS:   * new build flags or cross compiler
  CC       ui/setup.o
  CC       ui/helpline.o
  CC       ui/progress.o
  AR       libapikfs.a
  CC       util/alias.o
  CC       util/annotate.o
  CC       ui/util.o
  CC       ui/hist.o
  CC       ui/stdio/hist.o
  PERF_VERSION = 3.19.rc2.gb7973a
  CC       builtin-bench.o
  LD       arch/libperf-in.o
arm-linux-gnueabihf-ld: no input files
make[3]: *** [arch/libperf-in.o] Error 1
make[2]: *** [arch] Error 2
make[2]: *** Waiting for unfinished jobs....
  CC       builtin-annotate.o
  CC       util/build-id.o
  CC FPIC  event-parse.o
  CC FPIC  event-plugin.o
  CC FPIC  trace-seq.o
  CC       builtin-diff.o
  CC FPIC  parse-filter.o
  CC       builtin-evlist.o
  CC       util/config.o
  CC       util/ctype.o
  CC FPIC  parse-utils.o
  CC       util/db-export.o
  CC FPIC  kbuffer-parse.o
  CC       builtin-help.o
  CC       util/environment.o
  CC FPIC  plugin_jbd2.o
  CC FPIC  plugin_hrtimer.o
  CC       util/event.o
  CC FPIC  plugin_kmem.o
  CC FPIC  plugin_kvm.o
  CC FPIC  plugin_mac80211.o
  CC       util/evlist.o
  CC FPIC  plugin_sched_switch.o
  CC       builtin-sched.o
  CC       util/evsel.o
  CC       util/exec_cmd.o
  CC FPIC  plugin_function.o
  CC FPIC  plugin_xen.o
  CC       builtin-buildid-list.o
  CC FPIC  plugin_scsi.o
  CC FPIC  plugin_cfg80211.o
  CC       builtin-buildid-cache.o
  LINK     libtraceevent.a
  LINK     plugin_jbd2.so
  GEN      perf-archive
  CC       util/find_next_bit.o
  LINK     plugin_hrtimer.so
  LINK     plugin_kmem.so
  LINK     plugin_kvm.so
  CC       util/help.o
  LINK     plugin_mac80211.so
  CC       util/kallsyms.o
  LINK     plugin_sched_switch.so
  LINK     plugin_function.so
  LINK     plugin_xen.so
  LD       ui/libperf-in.o
  CC       builtin-list.o
arm-linux-gnueabihf-ld: no input files
make[3]: *** [ui/libperf-in.o] Error 1
make[2]: *** [ui] Error 2
  CC       builtin-record.o
  LINK     plugin_scsi.so
  LINK     plugin_cfg80211.so
  GEN      perf-with-kcore
  CC       builtin-report.o
  CC       builtin-stat.o
  CC       builtin-timechart.o
  CC       util/levenshtein.o
  CC       builtin-top.o
  CC       builtin-script.o
  CC       builtin-kmem.o
  CC       builtin-lock.o
  CC       util/parse-options.o
  CC       builtin-kvm.o
  CC       builtin-inject.o
  CC       builtin-mem.o
  CC       bench/sched-messaging.o
  CC       tests/builtin-test.o
  CC       perf.o
  BISON    util/parse-events-bison.c
  CC       util/path.o
  CC       util/rbtree.o
  CC       util/bitmap.o
  CC       tests/parse-events.o
  CC       bench/sched-pipe.o
  CC       util/hweight.o
  CC       util/run-command.o
  CC       bench/mem-memcpy.o
  CC       bench/futex-hash.o
  CC       bench/futex-wake.o
  CC       util/quote.o
  CC       bench/futex-requeue.o
  CC       tests/dso-data.o
  CC       util/strbuf.o
  CC       util/string.o
  CC       util/strlist.o
  CC       tests/attr.o
  CC       tests/vmlinux-kallsyms.o
  LD       bench/perf-in.o
arm-linux-gnueabihf-ld: no input files
make[3]: *** [bench/perf-in.o] Error 1
make[2]: *** [bench] Error 2
make[2]: *** Waiting for unfinished jobs....
  CC       tests/open-syscall.o
  CC       util/strfilter.o
  CC       util/top.o
  CC       util/usage.o
  CC       tests/open-syscall-all-cpus.o
  CC       tests/open-syscall-tp-fields.o
  CC       tests/mmap-basic.o
  CC       tests/perf-record.o
  CC       util/wrapper.o
  CC       tests/rdpmc.o
  CC       util/sigchain.o
  CC       tests/evsel-roundtrip-name.o
  CC       tests/evsel-tp-sched.o
  CC       tests/fdarray.o
  CC       util/dso.o
  CC       tests/pmu.o
  CC       tests/hists_common.o
  CC       util/symbol.o
  CC       tests/hists_link.o
  CC       tests/hists_filter.o
  CC       tests/hists_output.o
  CC       tests/hists_cumulate.o
  CC       tests/python-use.o
  CC       tests/bp_signal.o
  CC       util/color.o
  CC       tests/bp_signal_overflow.o
  CC       tests/task-exit.o
  CC       util/pager.o
  CC       util/header.o
  CC       util/callchain.o
  CC       tests/sw-clock.o
  CC       tests/mmap-thread-lookup.o
  CC       util/values.o
  CC       tests/thread-mg-share.o
  CC       tests/switch-tracking.o
  CC       tests/keep-tracking.o
  CC       tests/code-reading.o
  CC       util/debug.o
  CC       tests/sample-parsing.o
  CC       util/machine.o
  CC       tests/parse-no-sample-id-all.o
  CC       util/map.o
  CC       util/pstack.o
  CC       util/session.o
  CC       util/ordered-events.o
  LD       tests/perf-in.o
arm-linux-gnueabihf-ld: no input files
make[3]: *** [tests/perf-in.o] Error 1
make[2]: *** [tests] Error 2
make[1]: *** [perf-in.o] Error 2
make[1]: *** Waiting for unfinished jobs....
  CC       util/comm.o
  CC       util/thread.o
  CC       util/thread_map.o
  CC       util/trace-event-parse.o
  CC       util/parse-events-bison.o
  BISON    util/pmu-bison.c
  CC       util/trace-event-read.o
  CC       util/trace-event-info.o
  CC       util/trace-event-scripting.o
  CC       util/trace-event.o
  CC       util/svghelper.o
  CC       util/sort.o
  CC       util/hist.o
  CC       util/util.o
  CC       util/xyarray.o
  CC       util/cpumap.o
  CC       util/cgroup.o
  CC       util/target.o
  CC       util/rblist.o
  CC       util/intlist.o
  CC       util/vdso.o
  CC       util/stat.o
  CC       util/record.o
  CC       util/srcline.o
  CC       util/data.o
  CC       util/tsc.o
  CC       util/cloexec.o
  CC       util/thread-stack.o
  CC       util/symbol-minimal.o
  CC       util/perf_regs.o
  FLEX     util/parse-events-flex.c
  FLEX     util/pmu-flex.c
  CC       util/pmu-bison.o
  CC       util/parse-events.o
  CC       util/parse-events-flex.o
  CC       util/pmu.o
  CC       util/pmu-flex.o
  LD       util/libperf-in.o
arm-linux-gnueabihf-ld: no input files
make[3]: *** [util/libperf-in.o] Error 1
make[2]: *** [util] Error 2
make[1]: *** [libperf-in.o] Error 2
make: *** [all] Error 2
