Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964782Ab3CHQRE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 11:17:04 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:41001 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933093Ab3CHQRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 11:17:03 -0500
Date: Fri, 8 Mar 2013 11:16:43 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Howard Chu <hyc@symas.com>
Cc: Chris Friesen <chris.friesen@genband.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: mmap vs fs cache
Message-ID: <20130308161643.GE23767@cmpxchg.org>
References: <5136320E.8030109@symas.com>
 <20130307154312.GG6723@quack.suse.cz>
 <20130308020854.GC23767@cmpxchg.org>
 <5139975F.9070509@symas.com>
 <20130308084246.GA4411@shutemov.name>
 <5139B214.3040303@symas.com>
 <5139FA13.8090305@genband.com>
 <5139FD27.1030208@symas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5139FD27.1030208@symas.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 08, 2013 at 07:00:55AM -0800, Howard Chu wrote:
> Chris Friesen wrote:
> >On 03/08/2013 03:40 AM, Howard Chu wrote:
> >
> >>There is no way that a process that is accessing only 30GB of a mmap
> >>should be able to fill up 32GB of RAM. There's nothing else running on
> >>the machine, I've killed or suspended everything else in userland
> >>besides a couple shells running top and vmstat. When I manually
> >>drop_caches repeatedly, then eventually slapd RSS/SHR grows to 30GB and
> >>the physical I/O stops.
> >
> >Is it possible that the kernel is doing some sort of automatic
> >readahead, but it ends up reading pages corresponding to data that isn't
> >ever queried and so doesn't get mapped by the application?
> 
> Yes, that's what I was thinking. I added a
> posix_madvise(..POSIX_MADV_RANDOM) but that had no effect on the
> test.
> 
> First obvious conclusion - kswapd is being too aggressive. When free
> memory hits the low watermark, the reclaim shrinks slapd down from
> 25GB to 18-19GB, while the page cache still contains ~7GB of
> unmapped pages. Ideally I'd like a tuning knob so I can say to keep
> no more than 2GB of unmapped pages in the cache. (And the desired
> effect of that would be to allow user processes to grow to 30GB
> total, in this case.)

We should find out where the unmapped page cache is coming from if you
are only accessing mapped file cache and disabled readahead.

How do you arrive at this number of unmapped page cache?

What could happen is that previously used and activated pages do not
get evicted anymore since there is a constant supply of younger
reclaimable cache that is actually thrashing.  Whenever you drop the
caches, you get rid of those stale active pages and allow the
previously thrashing cache to get activated.  However, that would
require that there is already a significant amount of active file
pages before your workload starts (check the nr_active_file number in
/proc/vmstat before launching slapd, try sync; echo 3 >drop_caches
before launching to eliminate this option) OR that the set of pages
accessed during your workload changes and the combined set of pages
accessed by your workload is bigger than available memory -- which you
claimed would not happen because you only access the 30GB file area on
that system.
