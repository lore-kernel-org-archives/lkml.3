Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab3JGXnP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 19:43:15 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:41325 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751475Ab3JGXnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 19:43:14 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsEHAJlGU1J5LPFV/2dsb2JhbABZgwc4gxK5JYU8gR4XdIIlAQEEATocIwULCAMOBAYJJQ8FJQMNFBOIAAUNuzIEFoxpgR+BMweEIwOYAJIBgzgogS0
Date: Tue, 8 Oct 2013 10:43:07 +1100
From: Dave Chinner <david@fromorbit.com>
To: Akira Hayakawa <ruby.wktk@gmail.com>
Cc: mpatocka@redhat.com, thornber@redhat.com, devel@driverdev.osuosl.org,
        snitzer@redhat.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com, agk@redhat.com,
        joe@perches.com, akpm@linux-foundation.org, dan.carpenter@oracle.com,
        ejt@redhat.com, cesarb@cesarb.net, m.chehab@samsung.com
Subject: Re: [dm-devel] Reworking dm-writeboost [was: Re: staging: Add
 dm-writeboost]
Message-ID: <20131007234307.GP4446@dastard>
References: <20130916215357.GA5015@redhat.com>
 <52384E66.6050101@gmail.com>
 <20130917205936.GB12001@redhat.com>
 <523E3522.2060607@gmail.com>
 <524183A2.9050301@gmail.com>
 <20130926034325.GO26872@dastard>
 <20131001082654.GA10326@debian>
 <alpine.LRH.2.02.1310021956130.22612@file01.intranet.prod.int.rdu2.redhat.com>
 <20131004020417.GF4446@dastard>
 <524FC4F4.6050401@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524FC4F4.6050401@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 05, 2013 at 04:51:16PM +0900, Akira Hayakawa wrote:
> Dave,
> 
> > That's where arbitrary delays in the storage stack below XFS cause
> > problems - if the first FUA log write is delayed, the next log
> > buffer will get filled, issued and delayed, and when we run out of
> > log buffers (there are 8 maximum) the entire log subsystem will
> > stall, stopping *all* log commit operations until log buffer
> > IOs complete and become free again. i.e. it can stall modifications
> > across the entire filesystem while we wait for batch timeouts to
> > expire and issue and complete FUA requests.
> To me, this sounds like design failure in XFS log subsystem.

If you say so. As it is, XFS is the best of all the linux
filesystems when it comes to performance under a heavy fsync
workload, so if you consider it broken by design then you've got a
horror show waiting for you on any other filesystem...

> Or just the limitation of metadata journal.

It's a recovery limitation - the more uncompleted log buffers we
have outstanding, the more space in the log will be considered
unrecoverable during a crash...

> > IMNSHO, REQ_FUA/REQ_FLUSH optimisations should be done at the
> > point where they are issued - any attempt to further optimise them
> > by adding delays down in the stack to aggregate FUA operations will
> > only increase latency of the operations that the issuer want to have
> > complete as fast as possible....
> That lower layer stack attempts to optimize further
> can benefit any filesystems.
> So, your opinion is not always correct although
> it is always correct in error handling or memory management.
> 
> I have proposed future plan of using persistent memory.
> I believe with this leap forward
> filesystems are free from doing such optimization
> relevant to write barriers. For more detail, please see my post.
> https://lkml.org/lkml/2013/10/4/186

Sure, we already do that in the storage stack to minimise the impact
of FUA operations - it's called a non-volatile write cache, and most
RAID controllers have them. They rely on immediate dispatch of FUA
operations to get them into the write cache as quickly as possible
(i.e. what filesystems do right now), and that is something your
proposed behaviour will prevent.

i.e. there's no point justifying a behaviour with "we could do this
in future so lets ignore the impact on current users"...

> However,
> I think I should leave option to disable the optimization
> in case the upper layer doesn't like it.
> Maybe, writeboost should disable deferring barriers
> if barrier_deadline_ms parameter is especially 0.
> Linux kernel's layered architecture is obviously not always perfect
> so there are similar cases in other boundaries
> such as O_DIRECT to bypass the page cache.

Right - but you can't detect O_DIRECT at the dm layer. IOWs, you're
relying on the user tweaking the corect knobs for their workload.

e.g. what happens if a user has a mixed workload - one where
performance benefits are only seen by delaying FUA, and another that
is seriously slowed down by delaying FUA requests?  This is where
knobs are problematic....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
