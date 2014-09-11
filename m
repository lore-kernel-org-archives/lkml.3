Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbaIKLe0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 07:34:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15755 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753039AbaIKLeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 07:34:24 -0400
Date: Thu, 11 Sep 2014 13:33:36 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Borislav Petkov <bp@suse.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [RFC 00/14] perf pollfd v3
Message-ID: <20140911113336.GB13634@krava.brq.redhat.com>
References: <1410358129-9965-1-git-send-email-acme@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410358129-9965-1-git-send-email-acme@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 11:08:35AM -0300, Arnaldo Carvalho de Melo wrote:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> Hi,
> 
> 	Main different to what was discussed in v2[1]:
> 
> 	Poll all event file descriptors, not just the ones mmaped.
> 
> 	This is a bug that was present before, noticed by Adrian Hunter while
> reviewing this patchkit, i.e. we were polling just the mmaped ones, because
> then we would look at all the ring buffers when just one of the polled
> descriptors was ready to read.
> 
> 	But this could lead to delays in polling when one of the mmaped fds was
> closed and we would then not be notified when another, associated to it by
> means of PERF_EVENT_IOC_SET_OUTPUT, had events available.
> 
> 	Also refcount the mmaps associated by means of PERF_EVENT_IOC_SET_OUTPUT,
> so that we can properly unmap a ring buffer to which all its file descriptors
> had been closed, for longer running apps.
> 
> 	It is all available on my tree:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git perf/fdarray.v2
> 
> 	I kept the v3 for the series as I initially called it pollfd, but since the
> class that grew out of it was named fdarray, thus the fdarray.v2 branch name.
> 
> 	Please let me know if there are still any other problems, now back to
> fixing up my last perf/core pull req wrt those external proggies problems.
> 

hum got this one:

[jolsa@krava perf]$ ./perf record ls
Error:
The sys_perf_event_open() syscall returned with 22 (Invalid argument) for event (cycles).
/bin/dmesg may provide additional information.
No CONFIG_PERF_EVENTS=y kernel support configured?

*** Error in `./perf': free(): invalid next size (fast): 0x00000000020d2290 ***
*** Error in `./perf': malloc(): memory corruption: 0x00000000020d22b0 ***

[jolsa@krava perf]$ pstack 20706
#0  pthread_once () at ../nptl/sysdeps/unix/sysv/linux/x86_64/pthread_once.S:94
#1  0x0000003408109d1c in __GI___backtrace (array=array@entry=0x7fff5c073d60, size=size@entry=64) at ../sysdeps/x86_64/backtrace.c:103
#2  0x0000003408075d34 in __libc_message (do_abort=2, fmt=fmt@entry=0x340817e568 "*** Error in `%s': %s: 0x%s ***\n") at ../sysdeps/unix/sysv/linux/libc_fatal.c:176
#3  0x000000340807e21c in malloc_printerr (ptr=0x20d22b0, str=0x340817bcbf "malloc(): memory corruption", action=<optimized out>) at malloc.c:4937
#4  _int_malloc (av=0x34083ba780 <main_arena>, bytes=56) at malloc.c:3411
#5  0x000000340808002c in __GI___libc_malloc (bytes=56) at malloc.c:2863
#6  0x0000003407c0d379 in _dl_map_object_deps (map=map@entry=0x7fe140d0ba18, preloads=preloads@entry=0x0, npreloads=npreloads@entry=0, trace_mode=trace_mode@entry=0, open_mode=open_mode@entry=-2147483648) at dl-deps.c:515
#7  0x0000003407c138bc in dl_open_worker (a=a@entry=0x7fff5c0748f8) at dl-open.c:265
#8  0x0000003407c0f304 in _dl_catch_error (objname=objname@entry=0x7fff5c0748e8, errstring=errstring@entry=0x7fff5c0748f0, mallocedp=mallocedp@entry=0x7fff5c0748e0, operate=operate@entry=0x3407c13740 <dl_open_worker>, args=args@entry=0x7fff5c0748f8) at dl-error.c:177
#9  0x0000003407c131eb in _dl_open (file=0x340817aaa6 "libgcc_s.so.1", mode=-2147483647, caller_dlopen=0x3408109c05 <init+21>, nsid=-2, argc=3, argv=<optimized out>, env=0x20ae470) at dl-open.c:656
#10 0x00000034081305d2 in do_dlopen (ptr=ptr@entry=0x7fff5c074b00) at dl-libc.c:87
#11 0x0000003407c0f304 in _dl_catch_error (objname=0x7fff5c074ae0, errstring=0x7fff5c074af0, mallocedp=0x7fff5c074ad0, operate=0x3408130590 <do_dlopen>, args=0x7fff5c074b00) at dl-error.c:177
#12 0x0000003408130692 in dlerror_run (args=0x7fff5c074b00, operate=0x3408130590 <do_dlopen>) at dl-libc.c:46
#13 __GI___libc_dlopen_mode (name=name@entry=0x340817aaa6 "libgcc_s.so.1", mode=mode@entry=-2147483647) at dl-libc.c:163
#14 0x0000003408109c05 in init () at ../sysdeps/x86_64/backtrace.c:52
#15 0x0000003408c0ca40 in pthread_once () at ../nptl/sysdeps/unix/sysv/linux/x86_64/pthread_once.S:103
#16 0x0000003408109d1c in __GI___backtrace (array=array@entry=0x7fff5c074dc0, size=size@entry=64) at ../sysdeps/x86_64/backtrace.c:103
#17 0x0000003408075d34 in __libc_message (do_abort=do_abort@entry=2, fmt=fmt@entry=0x340817e568 "*** Error in `%s': %s: 0x%s ***\n") at ../sysdeps/unix/sysv/linux/libc_fatal.c:176
#18 0x000000340807d0b8 in malloc_printerr (ptr=<optimized out>, str=0x340817e690 "free(): invalid next size (fast)", action=3) at malloc.c:4937
#19 _int_free (av=0x34083ba780 <main_arena>, p=<optimized out>, have_lock=0) at malloc.c:3789
#20 0x0000000000465e72 in perf_evsel__free_fd (evsel=0x20af190) at util/evsel.c:786
#21 perf_evsel__close (evsel=evsel@entry=0x20af190, ncpus=<optimized out>, nthreads=nthreads@entry=1) at util/evsel.c:1139
#22 0x000000000045f77d in perf_evlist__close (evlist=0x20ae8b0) at util/evlist.c:1148
#23 perf_evlist__delete (evlist=0x20ae8b0) at util/evlist.c:114
#24 0x000000000042b878 in cmd_record (argc=<optimized out>, argv=<optimized out>, prefix=<optimized out>) at builtin-record.c:967
#25 0x000000000041c455 in run_builtin (p=p@entry=0x815e70 <commands+144>, argc=argc@entry=2, argv=argv@entry=0x7fff5c077c50) at perf.c:331
#26 0x000000000041bc70 in handle_internal_command (argv=0x7fff5c077c50, argc=2) at perf.c:390
#27 run_argv (argv=0x7fff5c0779d0, argcp=0x7fff5c0779dc) at perf.c:434
#28 main (argc=2, argv=0x7fff5c077c50) at perf.c:549

jirka
