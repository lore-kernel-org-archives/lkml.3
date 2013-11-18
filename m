Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559Ab3KRTSP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 14:18:15 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:58568 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371Ab3KRTSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 14:18:01 -0500
Date: Mon, 18 Nov 2013 20:17:56 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Jan Kratochvil <jan.kratochvil@redhat.com>
Subject: Re: [PATCH] perf top: Make -g refer to callchains
Message-ID: <20131118191756.GA29592@gmail.com>
References: <20131118142653.GA27191@gmail.com>
 <20131118174945.GD24375@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131118174945.GD24375@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Olsa <jolsa@redhat.com> wrote:

> On Mon, Nov 18, 2013 at 03:26:53PM +0100, Ingo Molnar wrote:
> > 
> > * Jiri Olsa <jolsa@redhat.com> wrote:
> > 
> > > On Mon, Nov 18, 2013 at 09:59:45AM -0300, Arnaldo Carvalho de Melo wrote:
> > > > Em Fri, Nov 15, 2013 at 06:46:09AM +0100, Ingo Molnar escreveu:
> > > > > btw., here's some 'perf top' call graph performance and profiling 
> > > > > quality feedback, with the latest perf code:
> > > > > 
> > > > > 'perf top --call-graph fp' now works very well, using just 0.2% 
> > > > > of CPU time on a fast system:
> > > > > 
> > > > >  4676 mingo     20   0  612m  56m 9948 S     1  0.2   0:00.68 perf                                                                                                        
> > > > > 
> > > > > 'perf top --call-graph dwarf' on the other hand is horrendously 
> > > > > slow, using 20% of CPU time on a 4 GHz CPU:
> > > > > 
> > > > >   PID USER      PR  NI  VIRT  RES  SHR S  %CPU %MEM    TIME+  COMMAND                                                                                                     
> > > > >  4646 mingo     20   0  658m  81m  12m R    19  0.3   0:18.17 perf    
> > > > > 
> > > > > On another system with a 2.4GHz CPU it's taking up 100% of CPU 
> > > > > time (!):
> > > > > 
> > > > >   PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND                                                                                               
> > > > >  8018 mingo     20   0  290320  45220   8520 R  99.5  0.3   0:58.81 perf      
> > > > > 
> > > > > Profiling 'perf top' shows all sorts of very high dwarf 
> > > > > processing overhead:
> > > > 
> > > > Yeah, top dwarf callchain has been so far a proof of concept, it 
> > > > exacerbates problems that can be seen on 'report', but since its 
> > > > live, we can see it more clearly.
> > > > 
> > > > The work on improving callchain processing, (rb_tree'ing, new comm 
> > > > infrastructure) alleviated the problem a bit.
> > > > 
> > > > Tuning the stack size requested from the kernel and using 
> > > > --max-stack can help when it is really needed, but yes, work on it 
> > > > is *badly* needed.
> > > 
> > > agreed ;-)
> > > 
> > > also there's new remote unwind interface recently added into libdw, 
> > > which seems to be faster than libunwind.
> > >
> > > I plan on adding this soon.
> > 
> > If the main source of overhead is libunwind (which needs 
> > independent confirmation) then would it make sense to implement 
> > dwarf stack unwind support ourselves?
> > 
> > I think SysProf does that and it appears to be faster - its 
> > unwind.c is only 400 lines long as it only implements the small 
> > subset needed to walk the stack - AFAICS.
> 
> I think it's an option.. but it'll simpler to try the libdw 
> interface first and see if it's good/fast enough..
> 
> also I recall discussing the speed with libdw developer Jan 
> Kratochvil (CC-ed) and AFAICS they're open for 
> suggestions/optimizations

So it's terribly difficult to measure the performance problems, do 
something like this on an idle system:

  $ perf top --call-graph dwarf

and unless you have a very, very fast CPU this is going to use up 100% 
of CPU time. 20% on a very fast system. Both are anomalous and show 
this kind of dwarf processing overhead:

#
# Overhead  Command              Shared Object                                             Symbol
# ........  .......  .........................  .................................................
#
     7.08%     perf  perf                       [.] access_mem
     7.03%     perf  perf                       [.] dso__data_read_offset
     5.83%     perf  perf                       [.] maps__find
     5.64%     perf  libunwind-x86_64.so.8.0.1  [.] 0x000000000000ba25
     4.75%     perf  perf                       [.] thread__find_addr_map
     3.81%     perf  [kernel.kallsyms]          [k] unmap_single_vma
     2.57%     perf  perf                       [.] map__map_ip
     2.48%     perf  libelf-0.156.so            [.] 0x0000000000003a84
     2.12%     perf  [kernel.kallsyms]          [k] memset
     2.12%     perf  perf                       [.] dso__data_read_addr
     2.10%     perf  libc-2.17.so               [.] __memcpy_sse2
     1.72%     perf  libc-2.17.so               [.] __memset_sse2
     1.58%     perf  [kernel.kallsyms]          [k] page_fault
     1.56%     perf  libc-2.17.so               [.] __memset_x86_64
     1.44%     perf  perf                       [.] find_proc_info
     1.25%     perf  libelf-0.156.so            [.] elf_end
     1.19%     perf  [kernel.kallsyms]          [k] flush_tlb_mm_range
     1.06%     perf  libc-2.17.so               [.] vfprintf
     1.04%     perf  libunwind-x86_64.so.8.0.1  [.] _Ux86_64_dwarf_search_unwind_table
     1.00%     perf  [kernel.kallsyms]          [k] __audit_syscall_exit
     0.94%     perf  libc-2.17.so               [.] _int_free
     0.92%     perf  libc-2.17.so               [.] _int_malloc
     0.84%     perf  libc-2.17.so               [.] __memcmp_sse2
     0.81%     perf  [kernel.kallsyms]          [k] unmapped_area_topdown
     0.71%     perf  [kernel.kallsyms]          [k] system_call
     0.71%     perf  [kernel.kallsyms]          [k] system_call_after_swapgs
     0.65%     perf  [kernel.kallsyms]          [k] sysret_check
     0.63%     perf  perf                       [.] dso__find_symbol
     0.58%     perf  [kernel.kallsyms]          [k] clear_page_c
     0.58%     perf  [kernel.kallsyms]          [k] handle_mm_fault
     0.56%     perf  libc-2.17.so               [.] __sigprocmask

the libunwind and libelf entries didn't get resolved because I didn't 
have a debug version of the libraries installed:

     5.64%     perf  libunwind-x86_64.so.8.0.1  [.] 0x000000000000ba25
     2.48%     perf  libelf-0.156.so            [.] 0x0000000000003a84

Btw., tools like GDB are able to resolve symbols in such cases even 
without debug packages installed:

(gdb) bt
#0  0x0000003e5908edf9 in __memcpy_sse2 () from /lib64/libc.so.6
#1  0x000000000046b61c in memcpy (__len=8, __src=<optimized out>, __dest=0x7fffc80b09b8) at /usr/include/bits/string3.h:51
#2  dso_cache__memcpy (size=8, data=0x7fffc80b09b8 "@\325\357\377\344\001", offset=1840096, cache=<optimized out>) at util/dso.c:259
#3  dso_cache_read (size=8, data=0x7fffc80b09b8 "@\325\357\377\344\001", offset=1840096, machine=0x9a2a48, dso=0x9b21a0) at util/dso.c:316
#4  dso__data_read_offset (dso=0x9b21a0, machine=0x9a2a48, offset=1840096, data=data@entry=0x7fffc80b09b8 "@\325\357\377\344\001", size=size@entry=8) at util/dso.c:330
#5  0x000000000046b7a5 in dso__data_read_addr (dso=<optimized out>, map=<optimized out>, machine=<optimized out>, addr=addr@entry=6034400, 
    data=data@entry=0x7fffc80b09b8 "@\325\357\377\344\001", size=size@entry=8) at util/dso.c:355
#6  0x00000000004bea3c in access_dso_mem (ui=0x7fffc80b18b0, ui=0x7fffc80b18b0, data=0x7fffc80b09b8, addr=6034400) at util/unwind.c:404
#7  access_mem (as=<optimized out>, addr=6034400, valp=0x7fffc80b09b8, __write=<optimized out>, arg=0x7fffc80b18b0) at util/unwind.c:455
#8  0x00007f885af02f2d in _Ux86_64_dwarf_read_encoded_pointer () from /lib64/libunwind-x86_64.so.8
#9  0x00007f885aeff992 in _Ux86_64_dwarf_extract_proc_info_from_fde () from /lib64/libunwind-x86_64.so.8
#10 0x00007f885af03e75 in _Ux86_64_dwarf_search_unwind_table () from /lib64/libunwind-x86_64.so.8
#11 0x00000000004bedbc in find_proc_info (as=0x1445560, ip=4975163, pi=0x7fffc80b15b0, need_unwind_info=1, arg=0x7fffc80b18b0) at util/unwind.c:335
#12 0x00007f885af00205 in fetch_proc_info () from /lib64/libunwind-x86_64.so.8
#13 0x00007f885af0246b in _Ux86_64_dwarf_find_save_locs () from /lib64/libunwind-x86_64.so.8
#14 0x00007f885af03769 in _Ux86_64_dwarf_step () from /lib64/libunwind-x86_64.so.8
#15 0x00007f885aefb3f1 in _Ux86_64_step () from /lib64/libunwind-x86_64.so.8

All those entries are within libunwind - and GDB was able to resolve 
them.

How do they do it and shouldn't perf be able to do such magick?

Thanks,

	Ingo
