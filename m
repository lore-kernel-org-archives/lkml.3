Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbaAOAEX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 19:04:23 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:61405 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750928AbaAOAEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 19:04:21 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsoVACzQ1VJ5LKVw/2dsb2JhbABagws4gwKjQgOPKIVZgREXdIIlAQEBAwE6HCMFCwgDDgoJDBkPBSUDIRMeh14HDsRNFo5xBwqELQSYHYExkGWDQSg
Date: Wed, 15 Jan 2014 11:04:08 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@vger.kernel.org, linux-kernel@vger.kernel.org,
        axboe@kernel.dk
Subject: Re: [PATCH 0/6] Page I/O
Message-ID: <20140115000408.GN3469@dastard>
References: <1389321591-25455-1-git-send-email-matthew.r.wilcox@intel.com>
 <x49ha9bhnc8.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49ha9bhnc8.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 10, 2014 at 10:24:07AM -0500, Jeff Moyer wrote:
> Matthew Wilcox <matthew.r.wilcox@intel.com> writes:
> 
> > This patch set implements pageio as I described in my talk at
> > Linux.Conf.AU.  It's for review more than application, I think
> > benchmarking is going to be required to see if it's a win.  We've done
> > some benchmarking with an earlier version of the patch and a Chatham card,
> > and it's a win for us.
> >
> > The fundamental point of these patches is that we *can* do I/O without
> > allocating a BIO (or request, or ...) and so we can end up doing fun
> > things like swapping out a page without allocating any memory.
> >
> > Possibly it would be interesting to do sub-page I/Os (ie change the
> > rw_page prototype to take a 'start' and 'length' instead of requiring the
> > I/O to be the entire page), but the problem then arises about what the
> > 'done' callback should be.
> 
> For those of us who were not fortunate enough to attend your talk, would
> mind providing some background, like why you went down this path in the
> first place, and maybe what benchmarks you ran where you found it "a
> win?"

No need to attend - the LCA A/V team live streamed it over the
intertubes and had the recording up on the mirror within 24 hours:

http://mirror.linux.org.au/pub/linux.conf.au/2014/Thursday/239-Further_adventures_in_non-volatile_memory_-_Matthew_Wilcox.mp4

> Another code path making an end-run around the block layer is
> interesting, but may keep cgroup I/O throttling from working properly,
> for example.

Well, this is really aimed at CPU cache coherent DRAM speed devices,
so I think the per-IO overhead of throttling would be prohibitive
for such devices. IMO, those devices will spend more CPU time in the
IO path than doing the IO (which is likely to be the CPU doing a
memcpy!), so IO rates will be more effectively controlled by
restricting CPU time rather than adding extra overhead into the
block layer to account for each individual IO....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
