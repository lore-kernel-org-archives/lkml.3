Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab3JDCEk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 22:04:40 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:63332 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752010Ab3JDCEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 22:04:39 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnAGAKshTlJ5LPFV/2dsb2JhbABagweDSrlJhT6BHBd0giUBAQU6HCMQCAMOCgklDwUlAyETiAW8ehaOCIEzB4MfgQQDmACSAIM2KoEt
Date: Fri, 4 Oct 2013 12:04:17 +1000
From: Dave Chinner <david@fromorbit.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Joe Thornber <thornber@redhat.com>, devel@driverdev.osuosl.org,
        snitzer@redhat.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, Akira Hayakawa <ruby.wktk@gmail.com>,
        dm-devel@redhat.com, agk@redhat.com, joe@perches.com,
        akpm@linux-foundation.org, dan.carpenter@oracle.com, ejt@redhat.com,
        cesarb@cesarb.net, m.chehab@samsung.com
Subject: Re: [dm-devel] Reworking dm-writeboost [was: Re: staging: Add
 dm-writeboost]
Message-ID: <20131004020417.GF4446@dastard>
References: <5223208D.4000008@gmail.com>
 <20130916215357.GA5015@redhat.com>
 <52384E66.6050101@gmail.com>
 <20130917205936.GB12001@redhat.com>
 <523E3522.2060607@gmail.com>
 <524183A2.9050301@gmail.com>
 <20130926034325.GO26872@dastard>
 <20131001082654.GA10326@debian>
 <alpine.LRH.2.02.1310021956130.22612@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1310021956130.22612@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 08:01:45PM -0400, Mikulas Patocka wrote:
> 
> 
> On Tue, 1 Oct 2013, Joe Thornber wrote:
> 
> > > Alternatively, delaying them will stall the filesystem because it's
> > > waiting for said REQ_FUA IO to complete. For example, journal writes
> > > in XFS are extremely IO latency sensitive in workloads that have a
> > > signifincant number of ordering constraints (e.g. O_SYNC writes,
> > > fsync, etc) and delaying even one REQ_FUA/REQ_FLUSH can stall the
> > > filesystem for the majority of that barrier_deadline_ms.
> > 
> > Yes, this is a valid concern, but I assume Akira has benchmarked.
> > With dm-thin, I delay the REQ_FUA/REQ_FLUSH for a tiny amount, just to
> > see if there are any other FUA requests on my queue that can be
> > aggregated into a single flush.  I agree with you that the target
> > should never delay waiting for new io; that's asking for trouble.
> > 
> > - Joe
> 
> You could send the first REQ_FUA/REQ_FLUSH request directly to the disk 
> and aggregate all the requests that were received while you processed the 
> initial request. This way, you can do request batching without introducing 
> artifical delays.

Yes, that's what XFS does with it's log when lots of fsync requests
come in. i.e. the first is dispatched immmediately, and the others
are gathered into the next log buffer until it is either full or the
original REQ_FUA log write completes.

That's where arbitrary delays in the storage stack below XFS cause
problems - if the first FUA log write is delayed, the next log
buffer will get filled, issued and delayed, and when we run out of
log buffers (there are 8 maximum) the entire log subsystem will
stall, stopping *all* log commit operations until log buffer
IOs complete and become free again. i.e. it can stall modifications
across the entire filesystem while we wait for batch timeouts to
expire and issue and complete FUA requests.

IMNSHO, REQ_FUA/REQ_FLUSH optimisations should be done at the
point where they are issued - any attempt to further optimise them
by adding delays down in the stack to aggregate FUA operations will
only increase latency of the operations that the issuer want to have
complete as fast as possible....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
