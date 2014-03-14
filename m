Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163AbaCNRIQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 13:08:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36017 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755497AbaCNRIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 13:08:12 -0400
Date: Fri, 14 Mar 2014 17:08:08 +0000
From: Mel Gorman <mgorman@suse.de>
To: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, mhocko@suse.cz
Subject: Re: [patch] mm: vmscan: do not swap anon pages just because
 free+file is low
Message-ID: <20140314170807.GW10663@suse.de>
References: <1394811302-30468-1-git-send-email-hannes@cmpxchg.org>
 <53232901.5030307@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <53232901.5030307@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 12:06:25PM -0400, Rik van Riel wrote:
> On 03/14/2014 11:35 AM, Johannes Weiner wrote:
> > Page reclaim force-scans / swaps anonymous pages when file cache drops
> > below the high watermark of a zone in order to prevent what little
> > cache remains from thrashing.
> > 
> > However, on bigger machines the high watermark value can be quite
> > large and when the workload is dominated by a static anonymous/shmem
> > set, the file set might just be a small window of used-once cache.  In
> > such situations, the VM starts swapping heavily when instead it should
> > be recycling the no longer used cache.
> > 
> > This is a longer-standing problem, but it's more likely to trigger
> > after 81c0a2bb515f ("mm: page_alloc: fair zone allocator policy")
> > because file pages can no longer accumulate in a single zone and are
> > dispersed into smaller fractions among the available zones.
> > 
> > To resolve this, do not force scan anon when file pages are low but
> > instead rely on the scan/rotation ratios to make the right prediction.
> 
> I am not entirely sure that the scan/rotation ratio will be
> meaningful when the page cache has been essentially depleted,
> but on larger systems the distance between the low and high
> watermark is gigantic, and I have no better idea on how to
> fix the bug you encountered, so ...
> 

I still agree with the direction in general even though I've not put
thought into this specific patch yet. We've observed a problem whereby force
reclaim was causing one or other LRU list to be trashed.  In one specific
case, the inactive file is low logic was causing problems because while
the relative size of inactive/active was taken into account, the absolute
size vs anon was not. It was not a mainline kernel and we do not have a
test configuration that properly illustrates the problem on mainline it's
on our radar that it's a potential problem. The scan/rotation ratio at the
moment does not take absolute sizes into account but we almost certainly
want to go in that direction at some stage. Hugh's patch on altering how
proportional shrinking works is also relevant.

-- 
Mel Gorman
SUSE Labs
