Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484AbaKJEWu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 23:22:50 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:19226 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751101AbaKJEWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 23:22:47 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ako/ALs8YFR5LbBUPGdsb2JhbABbgw6BLYI2hQewWQaVLoVsAgIBAQKBGRcBAQEBAQYBAQEBODuEAwEBBCcTHCMQCAMYCSUPBSUDBxoTiEDNMQEBCAIBHxiGIolvbAeESwWeJIE1hwGGeItBKS+BD4E8AQEB
Date: Mon, 10 Nov 2014 15:22:44 +1100
From: Dave Chinner <david@fromorbit.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jens Axboe <axboe@fb.com>, "Jason B. Akers" <jason.b.akers@intel.com>,
        IDE/ATA development list <linux-ide@vger.kernel.org>,
        "Karkra, Kapil" <kapil.karkra@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/5] Enable use of Solid State Hybrid Drives
Message-ID: <20141110042244.GN23575@dastard>
References: <20141029180454.4879.75088.stgit@stg-AndroidDev-VirtualBox>
 <20141029201417.GK16186@dastard>
 <545157DB.70304@fb.com>
 <20141029220905.GL16186@dastard>
 <CAPcyv4iiqfeWQyZpzYwASFV+7Ztjcjrp0DEq3ThOmdwgWGGJUw@mail.gmail.com>
 <20141030072111.GJ13323@dastard>
 <CAPcyv4i1hNUSyTuQUuShBHqXcejLwEq3UcK1W01WCswGL-MoMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4i1hNUSyTuQUuShBHqXcejLwEq3UcK1W01WCswGL-MoMQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Been distrcted with other issues, so just getting back to this.]

On Thu, Oct 30, 2014 at 10:07:47AM -0700, Dan Williams wrote:
> On Thu, Oct 30, 2014 at 12:21 AM, Dave Chinner <david@fromorbit.com> wrote:
> > On Wed, Oct 29, 2014 at 03:24:11PM -0700, Dan Williams wrote:
> >> On Wed, Oct 29, 2014 at 3:09 PM, Dave Chinner <david@fromorbit.com> wrote:
> >> > On Wed, Oct 29, 2014 at 03:10:51PM -0600, Jens Axboe wrote:
> >> >> As for the fs accessing this, the io nice fields are readily exposed
> >> >> through the ->bi_rw setting. So while the above example uses ionice to
> >> >> set a task io priority (that a bio will then inherit), nothing prevents
> >> >> you from passing it in directly from the kernel.
> >> >
> >> > Right, but now the filesystem needs to provide that on a per-inode
> >> > basis, not from the task structure as the task that is submitting
> >> > the bio is not necesarily the task doing the read/write syscall.
> >> >
> >> > e.g. the write case above doesn't actually inherit the task priority
> >> > at the bio level at all because the IO is being dispatched by a
> >> > background flusher thread, not the ioniced task calling write(2).
> >>
> >> When the ioniced task calling write(2) inserts the page into the page
> >> cache then the current priority is recorded in the struct page.  The
> >
> > It does? Can you point me to where the page cache code does this,
> > because I've clearly missed something important go by in the past
> > few months...
> 
> Sorry, should have been more clear that this patch set added that
> capability in patch-4.  The idea is to claim some unused extended page
> flags to stash priority bits.  Yes, the PageSetAdvice() helper needs
> to be fixed up to do the flags update atomically, and yes this
> precludes hinting on 32-bit platforms.  I also think that
> bio_add_page() is the better place to read the per-page priority into
> the bio.  We felt ok deferring these items until after the initial
> RFC.

I think that using page flags for this is a 'orrible idea. Yeah,
it's a neat hack that you can use for proff of concept
demonstrations, but my biggest concern is that it isn't a scalable
channel for carrying IO priority information through the page cache.
e.g. it can't carry existing ionice priority scheduling information,
it can't carry blkcg IO control information, etc.

So, really, I think that this buffered write IO priority issue is
bigger than this patch series, and we need to solve it properly
rather than hack ugly special cases into core infrastructure
that are an evolutionary dead-end....

> >> > IOWs, to make effective use of this the task will need different
> >> > cache hints for each different type of data needs to do IO on, and
> >> > so overloading IO priorities just seems the wrong direction to be
> >> > starting from.
> >>
> >> There's also the fadvise() enabling that could be bolted on top of
> >> this capability.  But, before that step, is a thread-id per-caching
> >> context too much to ask?
> >
> > If we do it that way, we are stuck with it forever. So let's get our
> > ducks in line first before pulling the trigger...
> 
> Are you objecting to ionice as the interface or per-pid based hinting
> in general?

Neither. It's the implementation I don't like.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
