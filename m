Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509Ab3KOFq6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 00:46:58 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:60605 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932440Ab3KOFqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 00:46:15 -0500
Date: Fri, 15 Nov 2013 06:46:09 +0100
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH] perf top: Make -g refer to callchains
Message-ID: <20131115054609.GB4514@gmail.com>
References: <1384487490-6865-1-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384487490-6865-1-git-send-email-dsahern@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


btw., here's some 'perf top' call graph performance and profiling 
quality feedback, with the latest perf code:

'perf top --call-graph fp' now works very well, using just 0.2% 
of CPU time on a fast system:

 4676 mingo     20   0  612m  56m 9948 S     1  0.2   0:00.68 perf                                                                                                        

'perf top --call-graph dwarf' on the other hand is horrendously 
slow, using 20% of CPU time on a 4 GHz CPU:

  PID USER      PR  NI  VIRT  RES  SHR S  %CPU %MEM    TIME+  COMMAND                                                                                                     
 4646 mingo     20   0  658m  81m  12m R    19  0.3   0:18.17 perf    

On another system with a 2.4GHz CPU it's taking up 100% of CPU 
time (!):

  PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND                                                                                               
 8018 mingo     20   0  290320  45220   8520 R  99.5  0.3   0:58.81 perf      

Profiling 'perf top' shows all sorts of very high dwarf 
processing overhead:

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
     0.55%     perf  [kernel.kallsyms]          [k] copy_user_generic_string
     0.51%     perf  [kernel.kallsyms]          [k] __do_fault
     0.49%     perf  [kernel.kallsyms]          [k] find_vma
     0.47%     perf  libpthread-2.17.so         [.] __libc_close
     0.44%     perf  [kernel.kallsyms]          [k] __audit_syscall_entry
     0.44%     perf  [kernel.kallsyms]          [k] mmap_region
     0.42%     perf  [kernel.kallsyms]          [k] _raw_spin_lock
     0.41%     perf  [kernel.kallsyms]          [k] kmem_cache_free
     0.40%     perf  [kernel.kallsyms]          [k] kmem_cache_alloc
     0.40%     perf  libpthread-2.17.so         [.] pthread_mutex_unlock
     0.37%     perf  [kernel.kallsyms]          [k] perf_event_aux_ctx
     0.37%     perf  [kernel.kallsyms]          [k] do_munmap
     0.37%     perf  libc-2.17.so               [.] free
     [...]

Thanks,

	Ingo
