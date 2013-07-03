Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932661Ab3GCIrZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 04:47:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51292 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755768Ab3GCIrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 04:47:20 -0400
Date: Wed, 3 Jul 2013 09:47:15 +0100
From: Mel Gorman <mgorman@suse.de>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Dave Chinner <david@fromorbit.com>, Rob van der Heij <rvdheij@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yannick Brosseau <yannick.brosseau@gmail.com>, stable@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "lttng-dev@lists.lttng.org" <lttng-dev@lists.lttng.org>
Subject: Re: [-stable 3.8.1 performance regression] madvise
 POSIX_FADV_DONTNEED
Message-ID: <20130703084715.GF1875@suse.de>
References: <20130617141357.GA6034@Krystal>
 <20130617142459.1d563072231ba269cdac8f11@linux-foundation.org>
 <20130618092925.GI1875@suse.de>
 <20130618101147.GA7436@suse.de>
 <20130619192508.GA666@Krystal>
 <CAJCc=kijujORhPUmPvzHj-MMdyVbf-iHEK0Jx-VHbTO8q4ESFA@mail.gmail.com>
 <20130620122016.GA12700@Krystal>
 <20130625015648.GO29376@dastard>
 <20130702135858.GA30837@Krystal>
 <20130703005514.GA17149@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20130703005514.GA17149@Krystal>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 02, 2013 at 08:55:14PM -0400, Mathieu Desnoyers wrote:
> * Mathieu Desnoyers (mathieu.desnoyers@efficios.com) wrote:
> > * Dave Chinner (david@fromorbit.com) wrote:
> > > On Thu, Jun 20, 2013 at 08:20:16AM -0400, Mathieu Desnoyers wrote:
> > > > * Rob van der Heij (rvdheij@gmail.com) wrote:
> > > > > Wouldn't you batch the calls to drop the pages from cache rather than drop
> > > > > one packet at a time?
> > > > 
> > > > By default for kernel tracing, lttng's trace packets are 1MB, so I
> > > > consider the call to fadvise to be already batched by applying it to 1MB
> > > > packets rather than indivitual pages. Even there, it seems that the
> > > > extra overhead added by the lru drain on each CPU is noticeable.
> > > > 
> > > > Another reason for not batching this in larger chunks is to limit the
> > > > impact of the tracer on the kernel page cache. LTTng limits itself to
> > > > its own set of buffers, and use the page cache for what is absolutely
> > > > needed to perform I/O, but no more.
> > > 
> > > I think you are doing it wrong. This is a poster child case for
> > > using Direct IO and completely avoiding the page cache altogether....
> > 
> > I just tried replacing my sync_file_range()+fadvise() calls and instead
> > pass the O_DIRECT flag to open(). Unfortunately, I must be doing
> > something very wrong, because I get only 1/3rd of the throughput, and
> > the page cache fills up. Any idea why ?
> 
> Since O_DIRECT does not seem to provide acceptable throughput, it may be
> interesting to investigate other ways to lessen the latency impact of
> the fadvise DONTNEED hint.
> 

There are cases where O_DIRECT falls back to buffered IO which is why you
might have found that page cache was still filling up. There are a few
reasons why this can happen but I would guess the common cause is that
the range of pages being written was in the page cache already and could
not be invalidated for some reason. I'm guessing this is the common case
for page cache filling even with O_DIRECT but would not bet money on it
as it's not a problem I investigated before.

> Given it is just a hint, we should be allowed to perform page
> deactivation lazily. Is there any fundamental reason to wait for worker
> threads on each CPU to complete their lru drain before returning from
> fadvise() to user-space ?
> 

Only to make sure they pages are actually dropped as requested. The reason
the wait was introduced in the first place was that page cache was filling
up even with the fadvise calls and causing disruption. In 3.11 disruption
due to this sort of parallel IO should be reduced but making fadvise work
properly is reasonable in itself. Was that patch I posted ever tested or
did I manage to miss it?

-- 
Mel Gorman
SUSE Labs
