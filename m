Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbaGJMSf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 08:18:35 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:53645 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681AbaGJMSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 08:18:34 -0400
Date: Thu, 10 Jul 2014 08:18:30 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 6/6] mm: page_alloc: Reduce cost of the fair zone
 allocation policy
Message-ID: <20140710121830.GN29639@cmpxchg.org>
References: <1404893588-21371-1-git-send-email-mgorman@suse.de>
 <1404893588-21371-7-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404893588-21371-7-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 09:13:08AM +0100, Mel Gorman wrote:
> The fair zone allocation policy round-robins allocations between zones
> within a node to avoid age inversion problems during reclaim. If the
> first allocation fails, the batch counts is reset and a second attempt
> made before entering the slow path.
> 
> One assumption made with this scheme is that batches expire at roughly the
> same time and the resets each time are justified. This assumption does not
> hold when zones reach their low watermark as the batches will be consumed
> at uneven rates.  Allocation failure due to watermark depletion result in
> additional zonelist scans for the reset and another watermark check before
> hitting the slowpath.
> 
> On UMA, the benefit is negligible -- around 0.25%. On 4-socket NUMA
> machine it's variable due to the variability of measuring overhead with
> the vmstat changes. The system CPU overhead comparison looks like
> 
>           3.16.0-rc3  3.16.0-rc3  3.16.0-rc3
>              vanilla   vmstat-v5 lowercost-v5
> User          746.94      774.56      802.00
> System      65336.22    32847.27    40852.33
> Elapsed     27553.52    27415.04    27368.46
> 
> However it is worth noting that the overall benchmark still completed
> faster and intuitively it makes sense to take as few passes as possible
> through the zonelists.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
