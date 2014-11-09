Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484AbaKIHvv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 02:51:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57482 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138AbaKIHvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 02:51:50 -0500
Date: Sun, 9 Nov 2014 08:51:26 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Namhyung Kim <namhyung@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 14/18] perf tools: Make vmlinux short name more like
 kallsyms short name
Message-ID: <20141109075126.GB3366@krava.redhat.com>
References: <1415307879-912-1-git-send-email-acme@kernel.org>
 <1415307879-912-15-git-send-email-acme@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415307879-912-15-git-send-email-acme@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 06:04:35PM -0300, Arnaldo Carvalho de Melo wrote:
> From: Namhyung Kim <namhyung@kernel.org>
> 
> The previous patch changed kernel dso name from '[kernel.kallsyms]' to
> vmlinux.  However it might add confusion to old users accustomed to the
> old name.  So change the short name to '[kernel.vmlinux]' to reduce such
> confusion.
> 

SNIP

> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  tools/perf/util/machine.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
> index 53f90e9c65fe..52e94902afb1 100644
> --- a/tools/perf/util/machine.c
> +++ b/tools/perf/util/machine.c
> @@ -1106,6 +1106,9 @@ static int machine__process_kernel_mmap_event(struct machine *machine,
>  		if (__machine__create_kernel_maps(machine, kernel) < 0)
>  			goto out_problem;
>  
> +		if (strstr(dso->long_name, "vmlinux"))
> +			dso__set_short_name(dso, "[kernel.vmlinux]", false);
> +

heya,
I've got attached segfault in perf script because of this,
if I revert it's ok..

jirka

[jolsa@krava perf]$ ./perf record -e instructions -c 100000000 yes > /dev/null
^C[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.013 MB perf.data (~576 samples) ]
[jolsa@krava perf]$ gdb ./perf
GNU gdb (GDB) Fedora 7.7.1-21.fc20
Copyright (C) 2014 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
and "show warranty" for details.
This GDB was configured as "x86_64-redhat-linux-gnu".
Type "show configuration" for configuration details.
For bug reporting instructions, please see:
<http://www.gnu.org/software/gdb/bugs/>.
Find the GDB manual and other documentation resources online at:
<http://www.gnu.org/software/gdb/documentation/>.
For help, type "help".
Type "apropos word" to search for commands related to "word"...
Reading symbols from ./perf...done.
(gdb) r script
Starting program: /home/jolsa/kernel.org/linux-perf/tools/perf/perf script
warning: section  not found in /usr/lib/debug/lib/modules/3.16.6-203.fc20.x86_64/vdso/vdso64.so.debug
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib64/libthread_db.so.1".
Detaching after fork from child process 6849.
Program received signal SIGSEGV, Segmentation fault.
__strstr_sse42 (s1=0x0, s2=0x5db702 "vmlinux") at ../sysdeps/x86_64/multiarch/strstr.c:175
175       if (__builtin_expect (p1[0] == '\0', 0))
Missing separate debuginfos, use: debuginfo-install audit-libs-2.4-2.fc20.x86_64 elfutils-libelf-0.160-1.fc20.x86_64 elfutils-libs-0.160-1.fc20.x86_64 libunwind-1.1-3.fc20.x86_64 nss-softokn-freebl-3.17.2-1.fc20.x86_64 numactl-libs-2.0.9-2.fc20.x86_64 perl-libs-5.18.4-290.fc20.x86_64 python-libs-2.7.5-14.fc20.x86_64 slang-2.2.4-11.fc20.x86_64 xz-libs-5.1.2-12alpha.fc20.x86_64 zlib-1.2.8-3.fc20.x86_64
(gdb) bt
#0  __strstr_sse42 (s1=0x0, s2=0x5db702 "vmlinux") at ../sysdeps/x86_64/multiarch/strstr.c:175
#1  0x00000000004a881d in machine__process_kernel_mmap_event (machine=0x8d3e80, event=0x7ffff7ff50d8)
    at util/machine.c:1109
#2  0x00000000004a8b4f in machine__process_mmap_event (machine=0x8d3e80, event=0x7ffff7ff50d8,
    sample=0x7fffffffd280) at util/machine.c:1203
#3  0x0000000000470e7e in perf_event__process_mmap (tool=0x7fffffffd650, event=0x7ffff7ff50d8,
    sample=0x7fffffffd280, machine=0x8d3e80) at util/event.c:666
#4  0x00000000004af2fa in perf_session__deliver_event (session=0x8d3dc0, event=0x7ffff7ff50d8,
    sample=0x7fffffffd280, tool=0x7fffffffd650, file_offset=216) at util/session.c:845
#5  0x00000000004afa96 in perf_session__process_event (session=0x8d3dc0, event=0x7ffff7ff50d8,
    tool=0x7fffffffd650, file_offset=216) at util/session.c:1020
#6  0x00000000004b0451 in __perf_session__process_events (session=0x8d3dc0, data_offset=216, data_size=16240,
    file_size=16456, tool=0x7fffffffd650) at util/session.c:1292
#7  0x00000000004b061e in perf_session__process_events (session=0x8d3dc0, tool=0x7fffffffd650)
    at util/session.c:1337
#8  0x00000000004453d4 in __cmd_script (script=0x7fffffffd650) at builtin-script.c:803
#9  0x0000000000448858 in cmd_script (argc=0, argv=0x7fffffffe2e0, prefix=0x0) at builtin-script.c:1835
#10 0x000000000041c88c in run_builtin (p=0x856f70 <commands+336>, argc=1, argv=0x7fffffffe2e0) at perf.c:331
#11 0x000000000041caeb in handle_internal_command (argc=1, argv=0x7fffffffe2e0) at perf.c:390
#12 0x000000000041cc37 in run_argv (argcp=0x7fffffffe13c, argv=0x7fffffffe130) at perf.c:434
#13 0x000000000041cf8e in main (argc=1, argv=0x7fffffffe2e0) at perf.c:549
(gdb) q
A debugging session is active.
