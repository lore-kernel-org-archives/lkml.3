Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721Ab3GBN7F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 09:59:05 -0400
Received: from mail.openrapids.net ([64.15.138.104]:60466 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750869Ab3GBN7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 09:59:03 -0400
Date: Tue, 2 Jul 2013 09:58:58 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Rob van der Heij <rvdheij@gmail.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yannick Brosseau <yannick.brosseau@gmail.com>, stable@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "lttng-dev@lists.lttng.org" <lttng-dev@lists.lttng.org>
Subject: Re: [-stable 3.8.1 performance regression] madvise
	POSIX_FADV_DONTNEED
Message-ID: <20130702135858.GA30837@Krystal>
References: <51BE1828.3060206@gmail.com> <20130617141357.GA6034@Krystal> <20130617142459.1d563072231ba269cdac8f11@linux-foundation.org> <20130618092925.GI1875@suse.de> <20130618101147.GA7436@suse.de> <20130619192508.GA666@Krystal> <CAJCc=kijujORhPUmPvzHj-MMdyVbf-iHEK0Jx-VHbTO8q4ESFA@mail.gmail.com> <20130620122016.GA12700@Krystal> <20130625015648.GO29376@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130625015648.GO29376@dastard>
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dave Chinner (david@fromorbit.com) wrote:
> On Thu, Jun 20, 2013 at 08:20:16AM -0400, Mathieu Desnoyers wrote:
> > * Rob van der Heij (rvdheij@gmail.com) wrote:
> > > Wouldn't you batch the calls to drop the pages from cache rather than drop
> > > one packet at a time?
> > 
> > By default for kernel tracing, lttng's trace packets are 1MB, so I
> > consider the call to fadvise to be already batched by applying it to 1MB
> > packets rather than indivitual pages. Even there, it seems that the
> > extra overhead added by the lru drain on each CPU is noticeable.
> > 
> > Another reason for not batching this in larger chunks is to limit the
> > impact of the tracer on the kernel page cache. LTTng limits itself to
> > its own set of buffers, and use the page cache for what is absolutely
> > needed to perform I/O, but no more.
> 
> I think you are doing it wrong. This is a poster child case for
> using Direct IO and completely avoiding the page cache altogether....

I just tried replacing my sync_file_range()+fadvise() calls and instead
pass the O_DIRECT flag to open(). Unfortunately, I must be doing
something very wrong, because I get only 1/3rd of the throughput, and
the page cache fills up. Any idea why ?

Here are my results:

heavy-syscall.c: 30M sigaction() syscall with bad parameters (returns
immediately). Used as high-throughput stress-test for the tracer.
Tracing to disk with LTTng, all kernel tracepoints activated, including
system calls.

Tracer configuration: per-core buffers split into 4 sub-buffers of
262kB. splice() is used to transfer data from buffers to disk. Runs on a
8-core Intel machine.

Writing to a software raid-1 ext3 partition.
ext3 mount options: rw,errors=remount-ro

* sync_file_range+fadvise 3.9.8
  - with lru drain on fadvise

Kernel cache usage:
Before tracing: 56272k cached
After tracing:  56388k cached

939M	/root/lttng-traces/auto-20130702-090430
time ./heavy-syscall 
real	0m21.910s
throughput: 42MB/s


* sync_file_range+fadvise 3.9.8
  - without lru drain on fadvise: manually reverted

Kernel cache usage:
Before tracing: 67968k cached
After tracing:  67984k cached

945M	/root/lttng-traces/auto-20130702-092505
time ./heavy-syscall 
real	0m21.872s
throughput: 43MB/s


* O_DIRECT 3.9.8
  - O_DIRECT flag on open(), removed fadvise and sync_file_range calls

Kernel cache usage:
Before tracing:  99480k cached
After tracing:  360132k cached

258M	/root/lttng-traces/auto-20130702-090603
time ./heavy-syscall 
real	0m19.627s
throughput: 13MB/s


* No cache hints 3.9.8
  - only removed fadvise and sync_file_range calls

Kernel cache usage:
Before tracing: 103556k cached
After tracing:  363712k cached

945M	/root/lttng-traces/auto-20130702-092505
time ./heavy-syscall 
real	0m19.672s
throughput: 48MB/s

Thoughts ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
