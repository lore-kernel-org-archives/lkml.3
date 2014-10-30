Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758187AbaJ3HVT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 03:21:19 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:57653 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752528AbaJ3HVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 03:21:17 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlRLAIDlUVR5LbBUPGdsb2JhbABcgw6BLIc9sl0BAQEBAQEGlV6FagICAQECgR0XAQEBAQEGAQEBATg7hAIBAQEDAScTHBESBQsIAxgJJQ8FJQMHGhOIOAjHbQEBCAIBHxiGHoluI0kHhEsFnWmBMoZ5kiEpL4EHCBeBJQEBAQ
Date: Thu, 30 Oct 2014 18:21:11 +1100
From: Dave Chinner <david@fromorbit.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jens Axboe <axboe@fb.com>, "Jason B. Akers" <jason.b.akers@intel.com>,
        IDE/ATA development list <linux-ide@vger.kernel.org>,
        "Karkra, Kapil" <kapil.karkra@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/5] Enable use of Solid State Hybrid Drives
Message-ID: <20141030072111.GJ13323@dastard>
References: <20141029180454.4879.75088.stgit@stg-AndroidDev-VirtualBox>
 <20141029201417.GK16186@dastard>
 <545157DB.70304@fb.com>
 <20141029220905.GL16186@dastard>
 <CAPcyv4iiqfeWQyZpzYwASFV+7Ztjcjrp0DEq3ThOmdwgWGGJUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4iiqfeWQyZpzYwASFV+7Ztjcjrp0DEq3ThOmdwgWGGJUw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 03:24:11PM -0700, Dan Williams wrote:
> On Wed, Oct 29, 2014 at 3:09 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Wed, Oct 29, 2014 at 03:10:51PM -0600, Jens Axboe wrote:
> >> As for the fs accessing this, the io nice fields are readily exposed
> >> through the ->bi_rw setting. So while the above example uses ionice to
> >> set a task io priority (that a bio will then inherit), nothing prevents
> >> you from passing it in directly from the kernel.
> >
> > Right, but now the filesystem needs to provide that on a per-inode
> > basis, not from the task structure as the task that is submitting
> > the bio is not necesarily the task doing the read/write syscall.
> >
> > e.g. the write case above doesn't actually inherit the task priority
> > at the bio level at all because the IO is being dispatched by a
> > background flusher thread, not the ioniced task calling write(2).
> 
> When the ioniced task calling write(2) inserts the page into the page
> cache then the current priority is recorded in the struct page.  The

It does? Can you point me to where the page cache code does this,
because I've clearly missed something important go by in the past
few months...

> background flusher likely runs at a lower / neutral caching priority
> and the priority carried in the page will be the effective caching
> priority applied to the bio.

How? The writepage code that adds the pages to the bio doesn't look
at priorities at all. If we're supposed to be doing this, then it
isn't being done in XFS when we are building bios, and nobody has
told me we need to do it...

Hmmm - ok, so what happens if an IO is made up of pages from
different tasks with different priorities? what then? ;)

> > from a user and application perspective as cache residency is a
> > property of the data being read/written, not the task doing the IO.
> > e.g. a database will want it's indexes in flash and bulk
> > data in non-cached storage.
> 
> Right, if those are doing direct-i/o then have a separate thread-id
> for those write(2) calls.

Which, again, is not how applications are designed or implemented.
If the current transaction needs to read/write index blocks, it does
it directly, not have to wait for some other dispatch thread to do
it for it....

> Otherwise if they are dirtying page cache
> the struct page carries the hint.
> 
> > IOWs, to make effective use of this the task will need different
> > cache hints for each different type of data needs to do IO on, and
> > so overloading IO priorities just seems the wrong direction to be
> > starting from.
> 
> There's also the fadvise() enabling that could be bolted on top of
> this capability.  But, before that step, is a thread-id per-caching
> context too much to ask?

If we do it that way, we are stuck with it forever. So let's get our
ducks in line first before pulling the trigger...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
