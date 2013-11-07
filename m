Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab3KGW1t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 17:27:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49519 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab3KGW1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 17:27:41 -0500
Date: Thu, 7 Nov 2013 14:27:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>, Ron van der Wees <rvdwees@redhat.com>,
        Erik Mouw <erik.mouw_2@nxp.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, walken@google.com,
        Shaohua Li <shli@kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: Re: [RFC PATCH v2 -mm] provide estimated available memory in
 /proc/meminfo
Message-Id: <20131107142740.3cb3679dd778b501d27c2f73@linux-foundation.org>
In-Reply-To: <20131107212132.GA1092@cmpxchg.org>
References: <ECFC0369-0745-44AB-9858-E689F41CCB4D@nxp.com>
	<5256D4C7.90301@redhat.com>
	<DB649DE8-5595-4370-912B-BDC6BD5FF8C3@nxp.com>
	<20131025120752.GB2415@rh0004426.ams.redhat.com>
	<20131105173852.709a103b@annuminas.surriel.com>
	<20131105144526.49a233ca19298808e54ff900@linux-foundation.org>
	<20131107101345.14d7be90@annuminas.surriel.com>
	<20131107212132.GA1092@cmpxchg.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Nov 2013 16:21:32 -0500 Johannes Weiner <hannes@cmpxchg.org> wrote:

> > Subject: provide estimated available memory in /proc/meminfo
> > 
> > Many load balancing and workload placing programs check /proc/meminfo
> > to estimate how much free memory is available. They generally do this
> > by adding up "free" and "cached", which was fine ten years ago, but
> > is pretty much guaranteed to be wrong today.
> > 
> > It is wrong because Cached includes memory that is not freeable as
> > page cache, for example shared memory segments, tmpfs, and ramfs,
> > and it does not include reclaimable slab memory, which can take up
> > a large fraction of system memory on mostly idle systems with lots
> > of files.
> > 
> > Currently, the amount of memory that is available for a new workload,
> > without pushing the system into swap, can be estimated from MemFree,
> > Active(file), Inactive(file), and SReclaimable, as well as the "low"
> > watermarks from /proc/zoneinfo.
> > 
> > However, this may change in the future, and user space really should
> > not be expected to know kernel internals to come up with an estimate
> > for the amount of free memory.
> > 
> > It is more convenient to provide such an estimate in /proc/meminfo.
> > If things change in the future, we only have to change it in one place.
> > 
> > Signed-off-by: Rik van Riel <riel@redhat.com>
> > Reported-by: Erik Mouw <erik.mouw_2@nxp.com>
> 
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> I have a suspicion that people will end up relying on this number to
> start new workloads in situations where lots of the page cache is
> actually heavily used.  We might not swap, but there will still be IO
> from thrashing cache.
> 
> Maybe we'll have to subtract mapped cache pages in the future to
> mitigate this risk somehow...
> 
> Anyway, we can defer this to when it's proven to be an actual problem.

Well not really.  Once we release this thing with a particular
implementation, we are constrained in making any later changes.  If we
change it to produce larger numbers, someone's workload will start
swapping.  If we change it to produce smaller numbers, someone's
workload will refuse to start.

It all needs a bit of thought, and even some testing!  I labelled this
one for-3.14.
