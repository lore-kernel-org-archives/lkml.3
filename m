Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227AbaIBPVv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 11:21:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44517 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735AbaIBPVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 11:21:50 -0400
Date: Tue, 2 Sep 2014 16:21:43 +0100
From: Mel Gorman <mgorman@suse.de>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Fengguang Wu <fengguang.wu@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: page_alloc: Default to node-ordering on 64-bit NUMA
 machines
Message-ID: <20140902152143.GL12424@suse.de>
References: <20140901125551.GI12424@suse.de>
 <20140902135120.GC29501@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20140902135120.GC29501@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 09:51:20AM -0400, Johannes Weiner wrote:
> On Mon, Sep 01, 2014 at 01:55:51PM +0100, Mel Gorman wrote:
> > Zones are allocated by the page allocator in either node or zone order.
> > Node ordering is preferred in terms of locality and is applied automatically
> > in one of three cases.
> > 
> >   1. If a node has only low memory
> > 
> >   2. If DMA/DMA32 is a high percentage of memory
> > 
> >   3. If low memory on a single node is greater than 70% of the node size
> > 
> > Otherwise zone ordering is used to preserve low memory. Unfortunately
> > a consequence of this is that a machine with balanced NUMA nodes will
> > experience different performance characteristics depending on which node
> > they happen to start from.
> > 
> > The point of zone ordering is to protect lower nodes for devices that require
> > DMA/DMA32 memory. When NUMA was first introduced, this was critical as 32-bit
> > NUMA machines commonly suffered from low memory exhaustion problems. On
> > 64-bit machines the primary concern is devices that are 32-bit only which
> > is less severe than the low memory exhaustion problem on 32-bit NUMA. It
> > seems there are really few devices that depends on it.
> > 
> > AGP -- I assume this is getting more rare but even then I think the allocations
> > 	happen early in boot time where lowmem pressure is less of a problem
> > 
> > DRM -- If the device is 32-bit only then there may be low pressure. I didn't
> > 	evaluate these in detail but it looks like some of these are mobile
> > 	graphics card. Not many NUMA laptops out there. DRM folk should know
> > 	better though.
> > 
> > Some TV cards -- Much demand for 32-bit capable TV cards on NUMA machines?
> > 
> > B43 wireless card -- again not really a NUMA thing.
> > 
> > I cannot find a good reason to incur a performance penalty on all 64-bit NUMA
> > machines in case someone throws a brain damanged TV or graphics card in there.
> > This patch defaults to node-ordering on 64-bit NUMA machines. I was tempted
> > to make it default everywhere but I understand that some embedded arches may
> > be using 32-bit NUMA where I cannot predict the consequences.
> 
> This patch is a step in the right direction, but I'm not too fond of
> further fragmenting this code and where it applies, while leaving all
> the complexity from the heuristics and the zonelist building in, just
> on spec.  Could we at least remove the heuristics too?  If anybody is
> affected by this, they can always override the default on the cmdline.

I see no problem with deleting the heuristics. Default node for 64-bit
and default zone for 32-bit sound ok to you?

-- 
Mel Gorman
SUSE Labs
