Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988Ab3GEBmW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 21:42:22 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:62337 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751781Ab3GEBmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 21:42:20 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuILAAMk1lF5LNm+/2dsb2JhbABagwmDGr4YBAGBABd0giMBAQQBOhwjEAgDGAklDwUlAyEKCYgJBbkaFo4dG4EdB4NtA5dIih+HJ4MjKoEs
Date: Fri, 5 Jul 2013 11:42:14 +1000
From: Dave Chinner <david@fromorbit.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Rob van der Heij <rvdheij@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yannick Brosseau <yannick.brosseau@gmail.com>, stable@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "lttng-dev@lists.lttng.org" <lttng-dev@lists.lttng.org>
Subject: Re: [-stable 3.8.1 performance regression] madvise
 POSIX_FADV_DONTNEED
Message-ID: <20130705014214.GT14996@dastard>
References: <20130619192508.GA666@Krystal>
 <CAJCc=kijujORhPUmPvzHj-MMdyVbf-iHEK0Jx-VHbTO8q4ESFA@mail.gmail.com>
 <20130620122016.GA12700@Krystal>
 <20130625015648.GO29376@dastard>
 <20130702135858.GA30837@Krystal>
 <20130703005514.GA17149@Krystal>
 <20130703084715.GF1875@suse.de>
 <x49wqp7puej.fsf@segfault.boston.devel.redhat.com>
 <20130704000344.GG4072@dastard>
 <20130704003103.GA13899@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130704003103.GA13899@Krystal>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 03, 2013 at 08:31:03PM -0400, Mathieu Desnoyers wrote:
> * Dave Chinner (david@fromorbit.com) wrote:
> > On Wed, Jul 03, 2013 at 10:53:08AM -0400, Jeff Moyer wrote:
> > > Mel Gorman <mgorman@suse.de> writes:
> > > 
> > > >> > I just tried replacing my sync_file_range()+fadvise() calls and instead
> > > >> > pass the O_DIRECT flag to open(). Unfortunately, I must be doing
> > > >> > something very wrong, because I get only 1/3rd of the throughput, and
> > > >> > the page cache fills up. Any idea why ?
> > > >> 
> > > >> Since O_DIRECT does not seem to provide acceptable throughput, it may be
> > > >> interesting to investigate other ways to lessen the latency impact of
> > > >> the fadvise DONTNEED hint.
> > > >> 
> > > >
> > > > There are cases where O_DIRECT falls back to buffered IO which is why you
> > > > might have found that page cache was still filling up. There are a few
> > > > reasons why this can happen but I would guess the common cause is that
> > > > the range of pages being written was in the page cache already and could
> > > > not be invalidated for some reason. I'm guessing this is the common case
> > > > for page cache filling even with O_DIRECT but would not bet money on it
> > > > as it's not a problem I investigated before.
> > > 
> > > Even when O_DIRECT falls back to buffered I/O for writes, it will
> > > invalidate the page cache range described by the buffered I/O once it
> > > completes.  For reads, the range is written out synchronously before the
> > > direct I/O is issued.  Either way, you shouldn't see the page cache
> > > filling up.
> > 
> > <sigh>
> > 
> > I keep forgetting that filesystems other than XFS have sub-optimal
> > direct IO implementations. I wish that "silent fallback to buffered
> > IO" idea had never seen the light of day, and that filesystems
> > implemented direct IO properly.
> > 
> > > Switching to O_DIRECT often incurs a performance hit, especially if the
> > > application does not submit more than one I/O at a time.  Remember,
> > > you're not getting readahead, and you're not getting the benefit of the
> > > writeback code submitting batches of I/O.
> > 
> > With the way IO is being done, there won't be any readahead (write
> > only workload) and they are directly controlling writeback one chunk
> > at a time, so there's not writeback caching to do batching, either.
> > There's no obvious reason that direct IO should be any slower
> > assuming that the application is actually doing 1MB sized and
> > aligned IOs like was mentioned, because both methods are directly
> > dispatching and then waiting for IO completion.
> 
> As a clarification, I use 256kB "chunks" (sub-buffers) in my tests, not
> 1MB. Also, please note that since I'm using splice(), each individual
> splice call is internally limited to 16 pages worth of data transfer
> (64kB).

So you are doing 4 write() calls to a single sync_file_range(), not
1:1?

> > What filesystem is in use here?
> 
> My test was performed on ext3 filesystem, that was itself sitting on
> raid-1 software raid.

Yup, ext3 has limitations on direct IO that requires block
allocation and will often fall back to buffered IO. ext4  and XFS
should not have the same problems...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
