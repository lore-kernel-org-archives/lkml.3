Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434Ab3FQVZD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 17:25:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41233 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab3FQVZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 17:25:00 -0400
Date: Mon, 17 Jun 2013 14:24:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Yannick Brosseau <yannick.brosseau@gmail.com>,
        Mel Gorman <mgorman@suse.de>, Rob van der Heij <rvdheij@gmail.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        "lttng-dev@lists.lttng.org" <lttng-dev@lists.lttng.org>
Subject: Re: [-stable 3.8.1 performance regression] madvise
 POSIX_FADV_DONTNEED
Message-Id: <20130617142459.1d563072231ba269cdac8f11@linux-foundation.org>
In-Reply-To: <20130617141357.GA6034@Krystal>
References: <51BE1828.3060206@gmail.com>
	<20130617141357.GA6034@Krystal>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Jun 2013 10:13:57 -0400 Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> Hi,
> 
> CCing lkml on this,
> 
> * Yannick Brosseau (yannick.brosseau@gmail.com) wrote:
> > Hi all,
> > 
> > We discovered a performance regression in recent kernels with LTTng
> > related to the use of fadvise DONTNEED.
> > A call to this syscall is present in the LTTng consumer.
> > 
> > The following kernel commit cause the call to fadvise to be sometime
> > really slower.
> > 
> > Kernel commit info:
> > mm/fadvise.c: drain all pagevecs if POSIX_FADV_DONTNEED fails to discard
> > all pages
> > main tree: (since 3.9-rc1)
> > commit 67d46b296a1ba1477c0df8ff3bc5e0167a0b0732
> > stable tree: (since 3.8.1)
> > https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit?id=bb01afe62feca1e7cdca60696f8b074416b0910d
> > 
> > On the workload test, we observe that the call to fadvise takes about
> > 4-5 us before this patch is applied. After applying the patch, The
> > syscall now takes values from 5 us up to 4 ms (4000 us) sometime. The
> > effect on lttng is that the consumer is frozen for this long period
> > which leads to dropped event in the trace.

That change wasn't terribly efficient - if there are any unpopulated
pages in the range (which is quite likely), fadvise() will now always
call invalidate_mapping_pages() a second time.

Perhaps this is fixable.  Say, make lru_add_drain_all() return a
success code, or even teach lru_add_drain_all() to return a code
indicating that one of the spilled pages was (or might have been) on a
particular mapping.


But I don't see why that would cause fadvise(POSIX_FADV_DONTNEED) to
sometimes take four milliseconds(!).  Is it possible that a context
switch is now occurring, so the fadvise()-calling task sometimes spends
a few milliseconds asleep?


> We use POSIX_FADV_DONTNEED in LTTng so the kernel know it's not useful
> to keep the trace data around after it is flushed to disk. From what I
> gather from the commit changelog, it seems that the POSIX_FADV_DONTNEED
> operation now touches kernel data structures shared amongst processors
> that have much higher contention/overhead than previously.
> 
> How does your page cache memory usage behave prior/after this kernel
> commit ?
> 
> Also, can you try instrumenting the "count", "start_index" and
> "end_index" values within fadvise64_64 with commit
> 67d46b296a1ba1477c0df8ff3bc5e0167a0b0732 applied and log this though
> LTTng ? This will tell us whether the lru_add_drain_all() hit is taken
> for a good reason, or due to an unforeseen off-by-one type of issue in
> the new test:
> 
>   if (count < (end_index - start_index + 1)) {
> 

