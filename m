Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786AbaA3SPi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 13:15:38 -0500
Received: from mail-yk0-f169.google.com ([209.85.160.169]:53824 "EHLO
	mail-yk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704AbaA3SPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 13:15:36 -0500
Date: Thu, 30 Jan 2014 15:15:30 -0300
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
Message-ID: <20140130181530.GC8098@ghostprotocols.net>
References: <1391004884-10334-1-git-send-email-adrian.hunter@intel.com>
 <1391004884-10334-2-git-send-email-adrian.hunter@intel.com>
 <20140129185747.GE3998@ghostprotocols.net>
 <52E9FD31.108@intel.com>
 <20140130085940.GA2643@gmail.com>
 <52EA1988.9050100@intel.com>
 <20140130092036.GA2862@gmail.com>
 <20140130180823.GA8098@ghostprotocols.net>
 <20140130181232.GB8098@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140130181232.GB8098@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jan 30, 2014 at 03:12:32PM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Thu, Jan 30, 2014 at 03:08:23PM -0300, Arnaldo Carvalho de Melo escreveu:
> > Getting segfaults with:
>  
> > [acme@ssdandy linux]$ git log --oneline | head -10
> > c059c953531f perf tests: vmlinux-kallsyms test does not need to set up ref_reloc_sym
> > be2530836ebe perf symbols: Prevent the use of kcore if the kernel has moved
> > 9b2fd7840cb0 perf record: Get ref_reloc_sym from kernel map
> > bcf5e06a0c75 perf symbols: Add kallsyms__get_function_start()
> > 94591ed0963e perf machine: Add machine__get_kallsyms_filename()
> > 18923cddb839 perf symbols: Fix symbol annotation for relocated kernel
> 
> Program received signal SIGSEGV, Segmentation fault.
> perf_event__synthesize_kernel_mmap (tool=0x81fd20 <record>, process=0x42ad51 <process_synthesized_event>, machine=0x916380) at util/event.c:520
> 520		size = snprintf(event->mmap.filename, sizeof(event->mmap.filename),
> 521				"%s%s", mmap_name, kmap->ref_reloc_sym->name) + 1;
> (gdb) p mmap_name
> $4 = 0x7fffffffabd0 "[kernel.kallsyms]"
> (gdb) p kmap->ref_reloc_sym
> $5 = (struct ref_reloc_sym *) 0x0
> (gdb)

This is the buggy one:

[acme@ssdandy linux]$ perf record usleep 1
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.018 MB perf.data (~770 samples) ]
[acme@ssdandy linux]$ git show 9b2fd7840cb0d23068bc97e08db46f57f41021fe
commit 9b2fd7840cb0d23068bc97e08db46f57f41021fe
Author: Adrian Hunter <adrian.hunter@intel.com>
Date:   Wed Jan 29 16:14:40 2014 +0200

    perf record: Get ref_reloc_sym from kernel map
    
    Now that ref_reloc_sym is set up when the kernel map is created, 'perf
    record' does not need to pass the symbol names to
    perf_event__synthesize_kernel_mmap() which can read the values needed
    from ref_reloc_sym directly.
