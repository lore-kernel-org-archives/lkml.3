Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264Ab3LTDfJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 22:35:09 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:15914 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753042Ab3LTDfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 22:35:07 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmIHACO6s1J5LHyk/2dsb2JhbABZgwu0YoVdgRgXdIIlAQEBAwE6HCMQCAMOCgklDwUlAyETG4dhB8pzFxaOfAeDI4ETBJgVikyHSYM/KA
Date: Fri, 20 Dec 2013 14:35:02 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Lameter <cl@linux.com>
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [fs] inode_lru_isolate(): Move counter increment into spinlock
 section
Message-ID: <20131220033502.GF31386@dastard>
References: <00000143072add16-956bfa6c-d7d5-4df9-aabc-05a904a0edc4-000000@email.amazonses.com>
 <20131219042322.GX31386@dastard>
 <alpine.DEB.2.10.1312190921450.4238@nuc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1312190921450.4238@nuc>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 09:26:12AM -0600, Christoph Lameter wrote:
> On Thu, 19 Dec 2013, Dave Chinner wrote:
> 
> > On Wed, Dec 18, 2013 at 07:24:46PM +0000, Christoph Lameter wrote:
> > > The counter increment in inode_lru_isolate is happening after
> > > spinlocks have been dropped with preemption on using __count_vm_events
> > > making counter increment races possible.
> >
> > That's a nasty, undocumented problem that __count_vm_events() has.
> 
> AFACIT that is a pretty well established and known issue. It only
> affects cases where the fallback code for the counter increments is used.

Maybe for mm developers. Not so filesystem people, and certainly not
the person who made the last set of modifications, even though I do
spend a fair bit of time around the fringes of the MM code...

> > Nobody who is modifying the fs/inode.c code is likely to know about
> > this, so just moving the code under an unrelated lock is not
> > sufficient to prevent this from happening again. Hence I'd prefer
> > that you just change it to use count_vm_events() rather than try to
> > be tricksy by replacing the landmine in the code that we've already
> > stepped on once.
> 
> I have a patchset here that is supposed to be merged soon that will detect
> these cases.
> 
> Moving the code is IMHO the simplest solution. count_vm_events
> will have to disable interrupts on platforms that do not support fast RMV
> operations otherwise.

If count_vm_events requires irqs to be disabled to behave correctly,
then putting __count_vm_events under a spin lock is still not irq
safe. Either way, this isn't in a performance critical path, so I'd
much prefer the simpler, safer option be used rather than leave a
landmine for other unsuspecting developers.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
