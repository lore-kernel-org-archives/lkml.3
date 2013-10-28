Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795Ab3J1JCl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 05:02:41 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:50218 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105Ab3J1JCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 05:02:39 -0400
Date: Mon, 28 Oct 2013 10:02:36 +0100
From: ------------------------------ Markus Trippelsdorf 
	<markus@trippelsdorf.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [GIT PULL] perf fixes
Message-ID: <20131028090236.GA274@x4>
References: <20131026122414.GA25026@gmail.com>
 <20131028082848.GA276@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131028082848.GA276@x4>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013.10.28 at 09:28 +0100, Markus Trippelsdorf wrote:
> On 2013.10.26 at 14:24 +0200, Ingo Molnar wrote:
> >  - Reversal of the new 'MMAP2' extended mmap record ABI, introduced 
> >    in this merge window. (Patches were proposed to fix it but it was
> >    all a bit late and we felt it's safer to just delay the ABI one
> >    more kernel release and do it right.)
> 
> commit 3090ffb5a2515990182f3f55b0688a7817325488
> Author: Stephane Eranian <eranian@google.com>
> Date:   Thu Oct 17 19:32:15 2013 +0200
> 
>     perf: Disable PERF_RECORD_MMAP2 support
> 
> The commit above breaks "perf top" on my system, because it causes only
> [kernel] symbols to show up in the list. When I revert the commit I get
> the usual mixture of userspace and kernel symbols in the list.

Forgot to mention that this happens on an otherwise idle machine. If I
run CPU intensive apps they'll show up eventually.

Example (current Linus tree):

   PerfTop:     593 irqs/sec  kernel:80.6%  exact:  0.0% [4000Hz cycles],  (all, 4 CPUs)
----------------------------------------------------------------------------------------------

    57.75%  [kernel]          [k] amd_e400_idle
    28.66%  [unknown]         [.] 0x0000000000450bc8
     1.51%  [kernel]          [k] kallsyms_expand_symbol.const
     1.22%  [kernel]          [k] cpu_startup_entry
     1.13%  [kernel]          [k] number.isra.1
     0.77%  [kernel]          [k] clear_page_c
     0.74%  [kernel]          [k] memcpy
     0.46%  [kernel]          [k] task_waking_fair
     0.45%  [kernel]          [k] _raw_spin_lock_irqsave
     0.42%  [kernel]          [k] _raw_spin_unlock_irqrestore
     0.39%  [kernel]          [k] format_decode
     0.34%  [kernel]          [k] do_sys_poll
     0.31%  [kernel]          [k] current_kernel_time
     0.30%  [kernel]          [k] vsnprintf
     0.29%  [kernel]          [k] native_apic_mem_write
     0.28%  [kernel]          [k] select_task_rq_fair
     0.26%  [kernel]          [k] swiotlb_free_coherent
     0.26%  [kernel]          [k] irq_entries_start
     0.2n%  [kernel]          [k] strnlen

With the commit above reverted:

   PerfTop:     907 irqs/sec  kernel:73.3%  exact:  0.0% [4000Hz cycles],  (all, 4 CPUs)
-----------------------------------------------------------------------------------------------

    30.89%  [kernel]                    [k] amd_e400_idle
     6.88%  [unknown]                   [.] 0x00007f346f2ef3a6
     5.22%  libc-2.18.90.so             [.] strcmp
     3.65%  libc-2.18.90.so             [.] strstr
     2.65%  libbfd-2.24.51.20131018.so  [.] d_print_comp.part.8
     2.61%  perf                        [.] symbols__insert
     2.18%  [kernel]                    [k] cpu_startup_entry
     1.82%  perf                        [.] symbol_filter
     1.73%  perf                        [.] rb_next
     1.58%  libc-2.18.90.so             [.] critical_factorization
     1.34%  libelf-0.156.so             [.] gelf_getsym
     1.28%  libQtGui.so.4.8.5           [.] qt_alphargbblit_quint32(QRasterBuffer*, int, int, unsigned int, unsigned int const*, int, int, int, QClipData
     1.25%  libc-2.18.90.so             [.] __libc_calloc
     1.17%  libc-2.18.90.so             [.] _int_malloc
     1.15%  libc-2.18.90.so             [.] strchr
     0.97%  xmobar                      [.] 0x000000000000c922
     0.97%  [kernel]                    [k] number.isra.1
     0.96%  libpthread-2.18.90.so       [.] pthread_rwlock_rdlock
     0.96%  libc-2.18.90.so             [.] memcpy@@GLIBC_2.14
     0.94%  perf                        [.] dso__load_sym
     0.93%  libc-2.18.90.so             [.] memchr
     0.84%  libbfd-2.24.51.20131018.so  [.] d_name
     0.75%  [kernel]                    [k] clear_page_c
     0.73%  libpthread-2.18.90.so       [.] pthread_rwlock_unlock
     0.66%  libc-2.18.90.so             [.] memset

-- 
Markus
