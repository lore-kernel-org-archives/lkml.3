Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069AbaJUAHI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 20:07:08 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:53723 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867AbaJUAHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 20:07:06 -0400
Message-ID: <5445A3A6.2@amacapital.net>
Date: Mon, 20 Oct 2014 17:07:02 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, torvalds@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        akpm@linux-foundation.org, riel@redhat.com, mgorman@suse.de,
        oleg@redhat.com, mingo@redhat.com, minchan@kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, viro@zeniv.linux.org.uk,
        laijs@cn.fujitsu.com, dave@stgolabs.net
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC][PATCH 0/6] Another go at speculative page faults
References: <20141020215633.717315139@infradead.org>
In-Reply-To: <20141020215633.717315139@infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2014 02:56 PM, Peter Zijlstra wrote:
> Hi,
> 
> I figured I'd give my 2010 speculative fault series another spin:
> 
>   https://lkml.org/lkml/2010/1/4/257
> 
> Since then I think many of the outstanding issues have changed sufficiently to
> warrant another go. In particular Al Viro's delayed fput seems to have made it
> entirely 'normal' to delay fput(). Lai Jiangshan's SRCU rewrite provided us
> with call_srcu() and my preemptible mmu_gather removed the TLB flushes from
> under the PTL.
> 
> The code needs way more attention but builds a kernel and runs the
> micro-benchmark so I figured I'd post it before sinking more time into it.
> 
> I realize the micro-bench is about as good as it gets for this series and not
> very realistic otherwise, but I think it does show the potential benefit the
> approach has.

Does this mean that an entire fault can complete without ever taking
mmap_sem at all?  If so, that's a *huge* win.

I'm a bit concerned about drivers that assume that the vma is unchanged
during .fault processing.  In particular, is there a race between .close
and .fault?  Would it make sense to add a per-vma rw lock and hold it
during vma modification and .fault calls?

--Andy

> 
> (patches go against .18-rc1+)
> 
> ---
> 
> Using Kamezawa's multi-fault micro-bench from: https://lkml.org/lkml/2010/1/6/28
> 
> My Ivy Bridge EP (2*10*2) has a ~58% improvement in pagefault throughput:
> 
> PRE:
> 
> root@ivb-ep:~# perf stat -e page-faults,cache-misses --repeat 5 ./multi-fault 20
> 
>  Performance counter stats for './multi-fault 20' (5 runs):
> 
>        149,441,555      page-faults                  ( +-  1.25% )
>      2,153,651,828      cache-misses                 ( +-  1.09% )
> 
>       60.003082014 seconds time elapsed              ( +-  0.00% )
> 
> POST:
> 
> root@ivb-ep:~# perf stat -e page-faults,cache-misses --repeat 5 ./multi-fault 20
> 
>  Performance counter stats for './multi-fault 20' (5 runs):
> 
>        236,442,626      page-faults                  ( +-  0.08% )
>      2,796,353,939      cache-misses                 ( +-  1.01% )
> 
>       60.002792431 seconds time elapsed              ( +-  0.00% )
> 
> 
> My Ivy Bridge EX (4*15*2) has a ~78% improvement in pagefault throughput:
> 
> PRE:
> 
> root@ivb-ex:~# perf stat -e page-faults,cache-misses --repeat 5 ./multi-fault 60
> 
>  Performance counter stats for './multi-fault 60' (5 runs):
> 
>        105,789,078      page-faults                 ( +-  2.24% )
>      1,314,072,090      cache-misses                ( +-  1.17% )
> 
>       60.009243533 seconds time elapsed             ( +-  0.00% )
> 
> POST:
> 
> root@ivb-ex:~# perf stat -e page-faults,cache-misses --repeat 5 ./multi-fault 60
> 
>  Performance counter stats for './multi-fault 60' (5 runs):
> 
>        187,751,767      page-faults                 ( +-  2.24% )
>      1,792,758,664      cache-misses                ( +-  2.30% )
> 
>       60.011611579 seconds time elapsed             ( +-  0.00% )
> 
> (I've not yet looked at why the EX sucks chunks compared to the EP box, I
>  suspect we contend on other locks, but it could be anything.)
> 
> ---
> 
>  arch/x86/mm/fault.c      |  35 ++-
>  include/linux/mm.h       |  19 +-
>  include/linux/mm_types.h |   5 +
>  kernel/fork.c            |   1 +
>  mm/init-mm.c             |   1 +
>  mm/internal.h            |  18 ++
>  mm/memory.c              | 672 ++++++++++++++++++++++++++++-------------------
>  mm/mmap.c                | 101 +++++--
>  8 files changed, 544 insertions(+), 308 deletions(-)
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 

