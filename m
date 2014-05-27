Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbaE0XUb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 19:20:31 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:55842 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073AbaE0XU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 19:20:29 -0400
Date: Tue, 27 May 2014 16:19:12 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Konstantin Khlebnikov <koct9i@gmail.com>
cc: Dave Chinner <david@fromorbit.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Bob Liu <bob.liu@oracle.com>, Jan Kara <jack@suse.cz>,
        Rik van Riel <riel@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 0/3] Shrinkers and proportional reclaim
In-Reply-To: <CALYGNiPZXnTG+vxg5tr+jnaDSvHRArJq=fmQ4bPD-m-iJU9jqA@mail.gmail.com>
Message-ID: <alpine.LSU.2.11.1405271618360.5019@eggly.anvils>
References: <1400749779-24879-1-git-send-email-mgorman@suse.de> <alpine.LSU.2.11.1405261441320.7154@eggly.anvils> <20140527023751.GB8554@dastard> <alpine.LSU.2.11.1405271406520.4317@eggly.anvils>
 <CALYGNiPZXnTG+vxg5tr+jnaDSvHRArJq=fmQ4bPD-m-iJU9jqA@mail.gmail.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 May 2014, Konstantin Khlebnikov wrote:
> On Wed, May 28, 2014 at 1:17 AM, Hugh Dickins <hughd@google.com> wrote:
> > On Tue, 27 May 2014, Dave Chinner wrote:
> >> On Mon, May 26, 2014 at 02:44:29PM -0700, Hugh Dickins wrote:
> >> >
> >> > [PATCH 4/3] fs/superblock: Avoid counting without __GFP_FS
> >> >
> >> > Don't waste time counting objects in super_cache_count() if no __GFP_FS:
> >> > super_cache_scan() would only back out with SHRINK_STOP in that case.
> >> >
> >> > Signed-off-by: Hugh Dickins <hughd@google.com>
> >>
> >> While you might think that's a good thing, it's not.  The act of
> >> shrinking is kept separate from the accounting of how much shrinking
> >> needs to take place.  The amount of work the shrinker can't do due
> >> to the reclaim context is deferred until the shrinker is called in a
> >> context where it can do work (eg. kswapd)
> >>
> >> Hence not accounting for work that can't be done immediately will
> >> adversely impact the balance of the system under memory intensive
> >> filesystem workloads. In these worklaods, almost all allocations are
> >> done in the GFP_NOFS or GFP_NOIO contexts so not deferring the work
> >> will will effectively stop superblock cache reclaim entirely....
> >
> > Thanks for filling me in on that.  At first I misunderstood you,
> > and went off looking in the wrong direction.  Now I see what you're
> > referring to: the quantity that shrink_slab_node() accumulates in
> > and withdraws from shrinker->nr_deferred[nid].
> 
> Maybe shrinker could accumulate fraction nr_pages_scanned / lru_pages
> instead of exact amount of required work? Count of shrinkable objects
> might be calculated later, when shrinker is called from a suitable context
> and can actualy do something.

Good idea, probably a worthwhile optimization to think through further.
(Though experience says that Dave will explain how that can never work.)

Hugh
