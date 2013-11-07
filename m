Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000Ab3KGVYf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 16:24:35 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:35494 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754139Ab3KGVY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 16:24:27 -0500
Date: Thu, 7 Nov 2013 16:21:32 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Ron van der Wees <rvdwees@redhat.com>, Erik Mouw <erik.mouw_2@nxp.com>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        walken@google.com, Shaohua Li <shli@kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: Re: [RFC PATCH v2 -mm] provide estimated available memory in
 /proc/meminfo
Message-ID: <20131107212132.GA1092@cmpxchg.org>
References: <ECFC0369-0745-44AB-9858-E689F41CCB4D@nxp.com>
 <5256D4C7.90301@redhat.com>
 <DB649DE8-5595-4370-912B-BDC6BD5FF8C3@nxp.com>
 <20131025120752.GB2415@rh0004426.ams.redhat.com>
 <20131105173852.709a103b@annuminas.surriel.com>
 <20131105144526.49a233ca19298808e54ff900@linux-foundation.org>
 <20131107101345.14d7be90@annuminas.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131107101345.14d7be90@annuminas.surriel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 07, 2013 at 10:13:45AM -0500, Rik van Riel wrote:
> 
> > >  fs/proc/meminfo.c | 36 ++++++++++++++++++++++++++++++++++++
> > >  1 file changed, 36 insertions(+)
> > 
> > Documentation/filesystems/proc.txt told me it's feeling all offended.
> 
> You're right, of course.  Here is version 2 :)
> 
> ---8<---
> 
> Subject: provide estimated available memory in /proc/meminfo
> 
> Many load balancing and workload placing programs check /proc/meminfo
> to estimate how much free memory is available. They generally do this
> by adding up "free" and "cached", which was fine ten years ago, but
> is pretty much guaranteed to be wrong today.
> 
> It is wrong because Cached includes memory that is not freeable as
> page cache, for example shared memory segments, tmpfs, and ramfs,
> and it does not include reclaimable slab memory, which can take up
> a large fraction of system memory on mostly idle systems with lots
> of files.
> 
> Currently, the amount of memory that is available for a new workload,
> without pushing the system into swap, can be estimated from MemFree,
> Active(file), Inactive(file), and SReclaimable, as well as the "low"
> watermarks from /proc/zoneinfo.
> 
> However, this may change in the future, and user space really should
> not be expected to know kernel internals to come up with an estimate
> for the amount of free memory.
> 
> It is more convenient to provide such an estimate in /proc/meminfo.
> If things change in the future, we only have to change it in one place.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> Reported-by: Erik Mouw <erik.mouw_2@nxp.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

I have a suspicion that people will end up relying on this number to
start new workloads in situations where lots of the page cache is
actually heavily used.  We might not swap, but there will still be IO
from thrashing cache.

Maybe we'll have to subtract mapped cache pages in the future to
mitigate this risk somehow...

Anyway, we can defer this to when it's proven to be an actual problem.
