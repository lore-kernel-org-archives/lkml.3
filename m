Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709Ab3FYB44 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 21:56:56 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:33794 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751063Ab3FYB4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 21:56:54 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnQOANT3yFF5LPX0/2dsb2JhbABagwmDFrdrhSsEAYEGF3SCIwEBBAE6HCMQCAMYCSUPBQ0YAyETh3wDCQWyLA2IUhaMUoEwGoEdB4NjA5VcgWaKH4IChSSDIiqBLQ
Date: Tue, 25 Jun 2013 11:56:48 +1000
From: Dave Chinner <david@fromorbit.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Rob van der Heij <rvdheij@gmail.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yannick Brosseau <yannick.brosseau@gmail.com>, stable@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "lttng-dev@lists.lttng.org" <lttng-dev@lists.lttng.org>
Subject: Re: [-stable 3.8.1 performance regression] madvise
 POSIX_FADV_DONTNEED
Message-ID: <20130625015648.GO29376@dastard>
References: <51BE1828.3060206@gmail.com>
 <20130617141357.GA6034@Krystal>
 <20130617142459.1d563072231ba269cdac8f11@linux-foundation.org>
 <20130618092925.GI1875@suse.de>
 <20130618101147.GA7436@suse.de>
 <20130619192508.GA666@Krystal>
 <CAJCc=kijujORhPUmPvzHj-MMdyVbf-iHEK0Jx-VHbTO8q4ESFA@mail.gmail.com>
 <20130620122016.GA12700@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130620122016.GA12700@Krystal>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 08:20:16AM -0400, Mathieu Desnoyers wrote:
> * Rob van der Heij (rvdheij@gmail.com) wrote:
> > Wouldn't you batch the calls to drop the pages from cache rather than drop
> > one packet at a time?
> 
> By default for kernel tracing, lttng's trace packets are 1MB, so I
> consider the call to fadvise to be already batched by applying it to 1MB
> packets rather than indivitual pages. Even there, it seems that the
> extra overhead added by the lru drain on each CPU is noticeable.
> 
> Another reason for not batching this in larger chunks is to limit the
> impact of the tracer on the kernel page cache. LTTng limits itself to
> its own set of buffers, and use the page cache for what is absolutely
> needed to perform I/O, but no more.

I think you are doing it wrong. This is a poster child case for
using Direct IO and completely avoiding the page cache altogether....

> > Your effort to help Linux mm seems a bit overkill,
> 
> Without performing this, I have a situation similar as yours, where
> LTTng fills up the page cache very quickly, until it gets to a point
> where memory pressure level increase enough that the consumerd is
> blocked until some pages are reclaimed. I really don't care about making
> the consumerd "as fast as possible for a while" if it means its
> throughput will drop when the page cache is filled. I prefer a constant
> slower pace to a short burst followed by slower throughput.
> 
> > and you don't want every application to do it like that himself.
> 
> Indeed, tracing has always been slightly odd in the sense that it's not
> the workload the system is meant to run, but rather a tool that should
> have the smallest impact on the usual system's run when it is used.
> 
> > The
> > fadvise will not even work when the page is still to be flushed out.
> > Without the patch that started the thread, it would 'at random' not work
> > due to SMP race condition (not multi-threading).
> 
> This is why the lttng consumerd calls:
> 
> sync_file_range with flags:
>     SYNC_FILE_RANGE_WAIT_BEFORE
>     SYNC_FILE_RANGE_WRITE
>     SYNC_FILE_RANGE_WAIT_AFTER
> 
> on the page range. The purpose of this call is to flush the pages to
> disk before calling fadvise(POSIX_FADV_DONTNEED) on the page range.

Yup, you're emulating direct IO semantics with buffered IO.

This seems to be an emerging trend I'm seeing a lot of over the past
few months - I'm hearing about it because of all the wierd corner
case behaviours it causes because sync_file_range() doesn't provide
data integrity guarantees and fadvise(DONTNEED) can randomly issue
lots of IO, block for long periods of time, silently do nothing,
remove pages from the page cache and/or some or all of the above.

Direct IO is a model of sanity compared to that mess....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
