Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642Ab3FQOOG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 10:14:06 -0400
Received: from mail.openrapids.net ([64.15.138.104]:47411 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751140Ab3FQOOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 10:14:02 -0400
Date: Mon, 17 Jun 2013 10:13:57 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Yannick Brosseau <yannick.brosseau@gmail.com>,
        Mel Gorman <mgorman@suse.de>, Rob van der Heij <rvdheij@gmail.com>,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: "lttng-dev@lists.lttng.org" <lttng-dev@lists.lttng.org>
Subject: [-stable 3.8.1 performance regression] madvise POSIX_FADV_DONTNEED
Message-ID: <20130617141357.GA6034@Krystal>
References: <51BE1828.3060206@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51BE1828.3060206@gmail.com>
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

CCing lkml on this,

* Yannick Brosseau (yannick.brosseau@gmail.com) wrote:
> Hi all,
> 
> We discovered a performance regression in recent kernels with LTTng
> related to the use of fadvise DONTNEED.
> A call to this syscall is present in the LTTng consumer.
> 
> The following kernel commit cause the call to fadvise to be sometime
> really slower.
> 
> Kernel commit info:
> mm/fadvise.c: drain all pagevecs if POSIX_FADV_DONTNEED fails to discard
> all pages
> main tree: (since 3.9-rc1)
> commit 67d46b296a1ba1477c0df8ff3bc5e0167a0b0732
> stable tree: (since 3.8.1)
> https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit?id=bb01afe62feca1e7cdca60696f8b074416b0910d
> 
> On the workload test, we observe that the call to fadvise takes about
> 4-5 us before this patch is applied. After applying the patch, The
> syscall now takes values from 5 us up to 4 ms (4000 us) sometime. The
> effect on lttng is that the consumer is frozen for this long period
> which leads to dropped event in the trace.

We use POSIX_FADV_DONTNEED in LTTng so the kernel know it's not useful
to keep the trace data around after it is flushed to disk. From what I
gather from the commit changelog, it seems that the POSIX_FADV_DONTNEED
operation now touches kernel data structures shared amongst processors
that have much higher contention/overhead than previously.

How does your page cache memory usage behave prior/after this kernel
commit ?

Also, can you try instrumenting the "count", "start_index" and
"end_index" values within fadvise64_64 with commit
67d46b296a1ba1477c0df8ff3bc5e0167a0b0732 applied and log this though
LTTng ? This will tell us whether the lru_add_drain_all() hit is taken
for a good reason, or due to an unforeseen off-by-one type of issue in
the new test:

  if (count < (end_index - start_index + 1)) {

Thanks,

Mathieu

> 
> If we remove the call to fadvise in src/common/consumer.c, we don't
> have any dropped event and we don't observe any bad side effect.
> (The added latency seem to come from the new call to
> lru_add_drain_all(). We removed this line and the performance went back
> to normal.)
> 
> It's obviously a problem in the kernel, but since it impacts LTTng, we
> wanted to report it here first and ask advice on what should be the
> next step to solve this problem.
> 
> If you want to see for youself, you can find the trace with the long
> call to fadvise here:
> http://www.dorsal.polymtl.ca/~rbeamonte/3.8.0~autocreated-4469887.tar.gz
> 
> Yannick and Raphael
> 
> _______________________________________________
> lttng-dev mailing list
> lttng-dev@lists.lttng.org
> http://lists.lttng.org/cgi-bin/mailman/listinfo/lttng-dev

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
