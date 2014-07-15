Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760132AbaGOXRi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:17:38 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:57137 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759322AbaGOXRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:17:33 -0400
Date: Tue, 15 Jul 2014 16:17:31 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave.hansen@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Bob Liu <bob.liu@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] mm, thp: only collapse hugepages to nodes with
 affinity
In-Reply-To: <53C4B251.5000505@intel.com>
Message-ID: <alpine.DEB.2.02.1407151609120.32274@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1407141807030.8808@chino.kir.corp.google.com> <53C4B251.5000505@intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2014, Dave Hansen wrote:

> > +		if (node == NUMA_NO_NODE) {
> > +			node = page_to_nid(page);
> > +		} else {
> > +			int distance = node_distance(page_to_nid(page), node);
> > +
> > +			/*
> > +			 * Do not migrate to memory that would not be reclaimed
> > +			 * from.
> > +			 */
> > +			if (distance > RECLAIM_DISTANCE)
> > +				goto out_unmap;
> > +		}
> 
> Isn't the reclaim behavior based on zone_reclaim_mode and not
> RECLAIM_DISTANCE directly?  And isn't that reclaim behavior disabled by
> default?
> 

Seems that RECLAIM_DISTANCE has taken on a life of its own independent of 
zone_reclaim_mode as a heuristic, such as its use in creating sched 
domains which would be unrelated.

> I think you should at least be consulting zone_reclaim_mode.
> 

Good point, and it matches what the comment is saying about whether we'd 
actually reclaim from the remote node to allocate thp on fault or not.  
I'll add it.

After this change, we'll also need to consider the behavior of thp at 
fault and whether remote HPAGE_PMD_SIZE memory when local memory is 
low/fragmented is better than local PAGE_SIZE memory.  In my page fault 
latency testing on true NUMA machines it's convincing that it's not.

This makes me believe that, somewhat similar to this patch, when we 
allocate thp memory at fault and zone_reclaim_mode is non-zero that we 
should set only nodes with numa_node_id() <= RECLAIM_DISTANCE and then 
otherwise fallback to the PAGE_SIZE fault path.

I've been hesitant to make that exact change, though, because it's a 
systemwide setting and I really hope to avoid a prctl() that controls 
zone reclaim for a particular process.  Perhaps the NUMA balancing work 
makes this more dependable.
