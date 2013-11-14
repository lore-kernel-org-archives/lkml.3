Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903Ab3KNQVZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:21:25 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:59906 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755845Ab3KNQVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:21:13 -0500
Date: Thu, 14 Nov 2013 10:21:03 -0600
From: Seth Jennings <sjennings@variantweb.net>
To: Hugh Dickins <hughd@google.com>
Cc: Minchan Kim <minchan@kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>, lliubbo@gmail.com,
        jmarchan@redhat.com, mgorman@suse.de, riel@redhat.com,
        linux-mm@kvack.org, linux-kernel <linux-kernel@vger.kernel.org>,
        Luigi Semenzato <semenzato@google.com>
Subject: Re: [PATCH] staging: zsmalloc: Ensure handle is never 0 on success
Message-ID: <20131114162103.GA4370@cerebellum.variantweb.net>
References: <20131107070451.GA10645@bbox>
 <20131112154137.GA3330@gmail.com>
 <alpine.LNX.2.00.1311131811030.1120@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1311131811030.1120@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 08:00:34PM -0800, Hugh Dickins wrote:
> On Wed, 13 Nov 2013, Minchan Kim wrote:
> > On Thu, Nov 07, 2013 at 04:04:51PM +0900, Minchan Kim wrote:
> > > On Wed, Nov 06, 2013 at 07:05:11PM -0800, Greg KH wrote:
> > > > On Wed, Nov 06, 2013 at 03:46:19PM -0800, Nitin Gupta wrote:
> > > >  > I'm getting really tired of them hanging around in here for many years
> > > > > > now...
> > > > > >
> > > > > 
> > > > > Minchan has tried many times to promote zram out of staging. This was
> > > > > his most recent attempt:
> > > > > 
> > > > > https://lkml.org/lkml/2013/8/21/54
> ...
> > 
> > Hello Andrew,
> > 
> > I'd like to listen your opinion.
> > 
> > The zram promotion trial started since Aug 2012 and I already have get many
> > Acked/Reviewed feedback and positive feedback from Rik and Bob in this thread.
> > (ex, Jens Axboe[1], Konrad Rzeszutek Wilk[2], Nitin Gupta[3], Pekka Enberg[4])
> > In Linuxcon, Hugh gave positive feedback about zram(Hugh, If I misunderstood,
> > please correct me!). And there are lots of users already in embedded industry
> > ex, (most of TV in the world, Chromebook, CyanogenMod, Android Kitkat.)
> > They are not idiot. Zram is really effective for embedded world.
> 
> Sorry for taking so long to respond, Minchan: no, you do not misrepresent
> me at all.  Promotion of zram and zsmalloc from staging is way overdue:
> they long ago proved their worth, look tidy, and have an active maintainer.
> 
> Putting them into drivers/staging was always a mistake, and I quite
> understand Greg's impatience with them by now; but please let's move
> them to where they belong instead of removing them.
> 
> I would not have lent support to zswap if I'd thought that was going to
> block zram.  And I was not the only one surprised when zswap replaced its
> use of zsmalloc by zbud: we had rather expected a zbud option to be added,
> and I still assume that zsmalloc support will be added back to zswap later.

Yes, it is still the plan to reintroduce zsmalloc as an option (possibly
_the_ option) for zswap.

An idea being tossed around is making zswap writethrough instead of
delayed writeback.

Doing this would be mean that zswap would no longer reduce swap out
traffic, but would continue to reduce swap in latency by reading out of
the compressed cache instead of the swap device.

For that loss, we gain a benefit: the compressed pages in the cache are
clean, meaning we can reclaim them at any time with no writeback
cost.  This addresses Mel's initial concern (the one that led to zswap
moving to zbud) about writeback latency when the zswap pool is full.

If there is no writeback cost for reclaiming space in the compressed
pool, then we can use higher density packing like zsmalloc.

Making zswap writethough would also make the difference between zswap
and zram, both in terms of operation and application, more apparent,
demonstrating the need for both.

Seth
