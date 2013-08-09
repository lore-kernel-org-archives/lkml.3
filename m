Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030216Ab3HIGRb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 02:17:31 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:46098 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966056Ab3HIGR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 02:17:29 -0400
X-AuditID: 9c93016f-b7cf0ae00000518f-d9-5204897768d1
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Jiri Olsa <jolsa@redhat.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/3] perf tools: Separate out GTK codes to libperf-gtk.so
References: <1375943650-2273-1-git-send-email-namhyung@kernel.org>
	<1375943650-2273-2-git-send-email-namhyung@kernel.org>
	<20130808152116.GG6102@ghostprotocols.net>
Date: Fri, 09 Aug 2013 15:17:27 +0900
In-Reply-To: <20130808152116.GG6102@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Thu, 8 Aug 2013 12:21:16 -0300")
Message-ID: <874nazxua0.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

On Thu, 8 Aug 2013 12:21:16 -0300, Arnaldo Carvalho de Melo wrote:
> Em Thu, Aug 08, 2013 at 03:34:08PM +0900, Namhyung Kim escreveu:
>> Separate out GTK codes to a shared object called libperf-gtk.so.  This
>> time only GTK codes are built with -fPIC and libperf remains as is.
>
> [acme@sandy linux]$ cat /etc/fedora-release 
> Fedora release 18 (Spherical Cow)
> [acme@sandy linux]$ 
>
> Applying: perf tools: Separate out GTK codes to libperf-gtk.so
> [perf/core c1ca5ea] perf tools: Separate out GTK codes to libperf-gtk.so
>  Author: Namhyung Kim <namhyung@kernel.org>
>  2 files changed, 38 insertions(+), 15 deletions(-)
> [acme@sandy linux]$ make -j8 O=/tmp/build/perf -C tools/perf/ install-bin
>     CHK -fstack-protector-all
> <SNIP>
>     CC /tmp/build/perf/scripts/perl/Perf-Trace-Util/Context.o
>     CC /tmp/build/perf/util/scripting-engines/trace-event-python.o
>     CC /tmp/build/perf/scripts/python/Perf-Trace-Util/Context.o
>     GEN perf-archive
>     GEN /tmp/build/perf/python/perf.so
>     CC /tmp/build/perf/perf.o
>     AR /tmp/build/perf/libperf.a
>     LINK /tmp/build/perf/perf
>     LINK /tmp/build/perf/libperf-gtk.so
> /usr/bin/ld: /tmp/build/perf/ui/gtk/browser.o: relocation R_X86_64_32 against `.rodata.str1.1' can not be used when making a shared object; recompile with -fPIC
> /tmp/build/perf/ui/gtk/browser.o: could not read symbols: Bad value

Hmm.. this looks like the browser.o previously built without -fPIC.


> collect2: error: ld returned 1 exit status
> make: *** [/tmp/build/perf/libperf-gtk.so] Error 1
> make: *** Waiting for unfinished jobs....
> make: Leaving directory `/home/acme/git/linux/tools/perf'
> [acme@sandy linux]$
>
> And if I just do:
>
> [acme@sandy linux]$ rm -rf /tmp/build/perf
> [acme@sandy linux]$ mkdir /tmp/build/perf
> [acme@sandy linux]$ make -j8 O=/tmp/build/perf -C tools/perf/ install-bin
>     CHK -fstack-protector-all
>     CHK -Wstack-protector
>     CHK -Wvolatile-register-var
>     CHK -D_FORTIFY_SOURCE=2
>     CHK bionic
>     CHK libelf
>     CHK libdw
>     CHK -DLIBELF_MMAP
>     CHK -DLIBELF_MMAP
>     CHK libunwind
>     CHK libaudit
>     CHK libslang
>     CHK gtk2
>     CHK -DHAVE_GTK_INFO_BAR
>     CHK perl
>     CHK python
>     CHK python version
>     CHK libbfd
>     CHK -DHAVE_STRLCPY
>     CHK -DHAVE_ON_EXIT
>     CHK -DBACKTRACE_SUPPORT
>     CHK libnuma
> make: Entering directory `/home/acme/git/linux/tools/perf'
>     MKDIR /tmp/build/perf/arch/
>     MKDIR /tmp/build/perf/arch/x86/util/
>     MKDIR /tmp/build/perf/bench/
>     MKDIR /tmp/build/perf/scripts/perl/Perf-Trace-Util/
>     MKDIR /tmp/build/perf/scripts/python/Perf-Trace-Util/
>     MKDIR /tmp/build/perf/ui/
>     MKDIR /tmp/build/perf/ui/browsers/
>     MKDIR /tmp/build/perf/tests/
>     MKDIR /tmp/build/perf/ui/stdio/
>     MKDIR /tmp/build/perf/ui/tui/
>     MKDIR /tmp/build/perf/util/
>     MKDIR /tmp/build/perf/util/scripting-engines/
>     * new build flags or prefix
>     BISON /tmp/build/perf/util/pmu-bison.c
>     CC /tmp/build/perf/util/environment.o
> <SNIP>
>     CC /tmp/build/perf/builtin-buildid-cache.o
> Assembler messages:
> Fatal error: can't create /tmp/build/perf/ui/gtk/setup.o: No such file or directory
> make: *** [/tmp/build/perf/ui/gtk/setup.o] Error 1
> make: *** Waiting for unfinished jobs....
> Assembler messages:
> Fatal error: can't create /tmp/build/perf/ui/gtk/util.o: No such file or directory
> make: *** [/tmp/build/perf/ui/gtk/util.o] Error 1
> Assembler messages:
> Fatal error: can't create /tmp/build/perf/ui/gtk/progress.o: No such file or directory
> make: *** [/tmp/build/perf/ui/gtk/progress.o] Error 1
> Assembler messages:
> Fatal error: can't create /tmp/build/perf/ui/gtk/browser.o: No such file or directory
> make: *** [/tmp/build/perf/ui/gtk/browser.o] Error 1
> Assembler messages:
> Fatal error: can't create /tmp/build/perf/ui/gtk/helpline.o: No such file or directory
> make: *** [/tmp/build/perf/ui/gtk/helpline.o] Error 1
> Assembler messages:
> Fatal error: can't create /tmp/build/perf/ui/gtk/annotate.o: No such file or directory
> make: *** [/tmp/build/perf/ui/gtk/annotate.o] Error 1
> Assembler messages:
> Fatal error: can't create /tmp/build/perf/ui/gtk/hists.o: No such file or directory
> make: *** [/tmp/build/perf/ui/gtk/hists.o] Error 1
> make: Leaving directory `/home/acme/git/linux/tools/perf'
> [acme@sandy linux]$ 

Argh... sorry about that.  I forgot to add GTK_OBJS to DIRECTORY_DEPS.
Will send v4 soon.

Thanks,
Namhyung
