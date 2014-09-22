Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511AbaIVKSO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 06:18:14 -0400
Received: from mx2.parallels.com ([199.115.105.18]:57379 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbaIVKSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 06:18:12 -0400
Date: Mon, 22 Sep 2014 14:18:03 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Johannes Weiner <hannes@cmpxchg.org>
CC: <linux-mm@kvack.org>, Michal Hocko <mhocko@suse.cz>,
        Greg Thelen <gthelen@google.com>, Dave Hansen <dave@sr71.net>,
        <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [patch] mm: memcontrol: support transparent huge pages under
 pressure
Message-ID: <20140922101803.GB20398@esperanza>
References: <1411132840-16025-1-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1411132840-16025-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 09:20:40AM -0400, Johannes Weiner wrote:
> In a memcg with even just moderate cache pressure, success rates for
> transparent huge page allocations drop to zero, wasting a lot of
> effort that the allocator puts into assembling these pages.
> 
> The reason for this is that the memcg reclaim code was never designed
> for higher-order charges.  It reclaims in small batches until there is
> room for at least one page.  Huge pages charges only succeed when
> these batches add up over a series of huge faults, which is unlikely
> under any significant load involving order-0 allocations in the group.
> 
> Remove that loop on the memcg side in favor of passing the actual
> reclaim goal to direct reclaim, which is already set up and optimized
> to meet higher-order goals efficiently.
> 
> This brings memcg's THP policy in line with the system policy: if the
> allocator painstakingly assembles a hugepage, memcg will at least make
> an honest effort to charge it.  As a result, transparent hugepage
> allocation rates amid cache activity are drastically improved:
> 
>                                       vanilla                 patched
> pgalloc                 4717530.80 (  +0.00%)   4451376.40 (  -5.64%)
> pgfault                  491370.60 (  +0.00%)    225477.40 ( -54.11%)
> pgmajfault                    2.00 (  +0.00%)         1.80 (  -6.67%)
> thp_fault_alloc               0.00 (  +0.00%)       531.60 (+100.00%)
> thp_fault_fallback          749.00 (  +0.00%)       217.40 ( -70.88%)
> 
> [ Note: this may in turn increase memory consumption from internal
>   fragmentation, which is an inherent risk of transparent hugepages.
>   Some setups may have to adjust the memcg limits accordingly to
>   accomodate this - or, if the machine is already packed to capacity,
>   disable the transparent huge page feature. ]
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Looks like a really nice change to me. FWIW,

Reviewed-by: Vladimir Davydov <vdavydov@parallels.com>
