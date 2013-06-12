Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757919Ab3FLSOq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 14:14:46 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:62200 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755695Ab3FLSOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 14:14:44 -0400
Date: Wed, 12 Jun 2013 11:14:40 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org, linux-s390@vger.kernel.org, bcrl@kvack.org,
        schwidefsky@de.ibm.com, kirill.shutemov@linux.intel.com,
        zab@redhat.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH v3 next/akpm] aio: convert the ioctx list to radix tree
Message-ID: <20130612181440.GC6151@google.com>
References: <1366026055-28604-1-git-send-email-octavian.purdila@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366026055-28604-1-git-send-email-octavian.purdila@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 02:40:55PM +0300, Octavian Purdila wrote:
> When using a large number of threads performing AIO operations the
> IOCTX list may get a significant number of entries which will cause
> significant overhead. For example, when running this fio script:
> 
> rw=randrw; size=256k ;directory=/mnt/fio; ioengine=libaio; iodepth=1
> blocksize=1024; numjobs=512; thread; loops=100
> 
> on an EXT2 filesystem mounted on top of a ramdisk we can observe up to
> 30% CPU time spent by lookup_ioctx:
> 
>  32.51%  [guest.kernel]  [g] lookup_ioctx
>   9.19%  [guest.kernel]  [g] __lock_acquire.isra.28
>   4.40%  [guest.kernel]  [g] lock_release
>   4.19%  [guest.kernel]  [g] sched_clock_local
>   3.86%  [guest.kernel]  [g] local_clock
>   3.68%  [guest.kernel]  [g] native_sched_clock
>   3.08%  [guest.kernel]  [g] sched_clock_cpu
>   2.64%  [guest.kernel]  [g] lock_release_holdtime.part.11
>   2.60%  [guest.kernel]  [g] memcpy
>   2.33%  [guest.kernel]  [g] lock_acquired
>   2.25%  [guest.kernel]  [g] lock_acquire
>   1.84%  [guest.kernel]  [g] do_io_submit
> 
> This patchs converts the ioctx list to a radix tree. For a performance
> comparison the above FIO script was run on a 2 sockets 8 core
> machine. This are the results (average and %rsd of 10 runs) for the
> original list based implementation and for the radix tree based
> implementation:
> 
> cores         1         2         4         8         16        32
> list       109376 ms  69119 ms  35682 ms  22671 ms  19724 ms  16408 ms
> %rsd         0.69%      1.15%     1.17%     1.21%     1.71%     1.43%
> radix       73651 ms  41748 ms  23028 ms  16766 ms  15232 ms   13787 ms
> %rsd         1.19%      0.98%     0.69%     1.13%    0.72%      0.75%
> % of radix
> relative    66.12%     65.59%    66.63%    72.31%   77.26%     83.66%
> to list
> 
> To consider the impact of the patch on the typical case of having
> only one ctx per process the following FIO script was run:
> 
> rw=randrw; size=100m ;directory=/mnt/fio; ioengine=libaio; iodepth=1
> blocksize=1024; numjobs=1; thread; loops=100
> 
> on the same system and the results are the following:
> 
> list        58892 ms
> %rsd         0.91%
> radix       59404 ms
> %rsd         0.81%
> % of radix
> relative    100.87%
> to list

So, I was just doing some benchmarking/profiling to get ready to send
out the aio patches I've got for 3.11 - and it looks like your patch is
causing a ~1.5% throughput regression in my testing :/

I'm just benchmarking random 4k reads with fio, with a single job.
Looking at the profile it appears to all be radix_tree_lookup() - that's
more expensive than I'd expect for a tree with one element.

It's a shame we don't have resizable RCU hash tables, that's really what
we want for this. Actually, I think I might know how to make that work
by using cuckoo hashing...

Might also be worth trying a single element cache of the most recently
used ioctx. Anyways, I don't want to nack your patch over this (the
overhead this is fixing can be quite a bit worse) but I'd like to try
and see if we can fix or reduce the regression in the single ioctx case.
