Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760AbaA3SMp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 13:12:45 -0500
Received: from mail-yk0-f172.google.com ([209.85.160.172]:55400 "EHLO
	mail-yk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbaA3SMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 13:12:43 -0500
Date: Thu, 30 Jan 2014 15:12:32 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V2 1/9] perf tools: Fix symbol annotation for relocated
 kernel
Message-ID: <20140130181232.GB8098@ghostprotocols.net>
References: <1391004884-10334-1-git-send-email-adrian.hunter@intel.com>
 <1391004884-10334-2-git-send-email-adrian.hunter@intel.com>
 <20140129185747.GE3998@ghostprotocols.net>
 <52E9FD31.108@intel.com>
 <20140130085940.GA2643@gmail.com>
 <52EA1988.9050100@intel.com>
 <20140130092036.GA2862@gmail.com>
 <20140130180823.GA8098@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140130180823.GA8098@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jan 30, 2014 at 03:08:23PM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Thu, Jan 30, 2014 at 10:20:36AM +0100, Ingo Molnar escreveu:
> > I'd suggest the whole fix series if perf/urgent material.
 
> Getting segfaults with:
 
> [acme@ssdandy linux]$ git log --oneline | head -10
> c059c953531f perf tests: vmlinux-kallsyms test does not need to set up ref_reloc_sym
> be2530836ebe perf symbols: Prevent the use of kcore if the kernel has moved
> 9b2fd7840cb0 perf record: Get ref_reloc_sym from kernel map
> bcf5e06a0c75 perf symbols: Add kallsyms__get_function_start()
> 94591ed0963e perf machine: Add machine__get_kallsyms_filename()
> 18923cddb839 perf symbols: Fix symbol annotation for relocated kernel

Program received signal SIGSEGV, Segmentation fault.
perf_event__synthesize_kernel_mmap (tool=0x81fd20 <record>, process=0x42ad51 <process_synthesized_event>, machine=0x916380) at util/event.c:520
520		size = snprintf(event->mmap.filename, sizeof(event->mmap.filename),
Missing separate debuginfos, use: debuginfo-install audit-libs-2.3.2-1.fc18.x86_64 bzip2-libs-1.0.6-7.fc18.x86_64 elfutils-libelf-0.155-1.fc18.x86_64 elfutils-libs-0.155-1.fc18.x86_64 libunwind-1.0.1-5.fc18.x86_64 nss-softokn-freebl-3.15.2-2.fc18.x86_64 numactl-libs-2.0.7-7.fc18.x86_64 perl-libs-5.16.3-245.fc18.x86_64 python-libs-2.7.3-13.fc18.x86_64 slang-2.2.4-5.fc18.x86_64 xz-libs-5.1.2-2alpha.fc18.x86_64
(gdb) bt
#0  perf_event__synthesize_kernel_mmap (tool=0x81fd20 <record>, process=0x42ad51 <process_synthesized_event>, machine=0x916380) at util/event.c:520
#1  0x000000000042bc24 in __cmd_record (rec=0x81fd20 <record>, argc=2, argv=0x7fffffffe160) at builtin-record.c:456
#2  0x000000000042c960 in cmd_record (argc=2, argv=0x7fffffffe160, prefix=0x0) at builtin-record.c:971
#3  0x000000000041a181 in run_builtin (p=0x81ee30 <commands+144>, argc=3, argv=0x7fffffffe160) at perf.c:319
#4  0x000000000041a3b9 in handle_internal_command (argc=3, argv=0x7fffffffe160) at perf.c:376
#5  0x000000000041a505 in run_argv (argcp=0x7fffffffe03c, argv=0x7fffffffe030) at perf.c:420
#6  0x000000000041a7ec in main (argc=3, argv=0x7fffffffe160) at perf.c:529
(gdb) list
515			event->header.misc = PERF_RECORD_MISC_GUEST_KERNEL;
516		}
517	
518		map = machine->vmlinux_maps[MAP__FUNCTION];
519		kmap = map__kmap(map);
520		size = snprintf(event->mmap.filename, sizeof(event->mmap.filename),
521				"%s%s", mmap_name, kmap->ref_reloc_sym->name) + 1;
522		size = PERF_ALIGN(size, sizeof(u64));
523		event->mmap.header.type = PERF_RECORD_MMAP;
524		event->mmap.header.size = (sizeof(event->mmap) -
(gdb) p mmap_name
$4 = 0x7fffffffabd0 "[kernel.kallsyms]"
(gdb) p kmap->ref_reloc_sym
$5 = (struct ref_reloc_sym *) 0x0
(gdb)
