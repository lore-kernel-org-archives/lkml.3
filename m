Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab3FNU1A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 16:27:00 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:54796 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204Ab3FNU07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 16:26:59 -0400
Date: Fri, 14 Jun 2013 13:26:56 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@gentwo.org>
cc: Roman Gushchin <klamm@yandex-team.ru>, penberg@kernel.org, mpm@selenic.com,
        akpm@linux-foundation.org, mgorman@suse.de, glommer@parallels.com,
        hannes@cmpxchg.org, minchan@kernel.org, jiang.liu@huawei.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slub: Avoid direct compaction if possible
In-Reply-To: <0000013f4319cb46-a5a3de58-1207-4037-ae39-574b58135ea2-000000@email.amazonses.com>
Message-ID: <alpine.DEB.2.02.1306141322490.17237@chino.kir.corp.google.com>
References: <51BB1802.8050108@yandex-team.ru> <0000013f4319cb46-a5a3de58-1207-4037-ae39-574b58135ea2-000000@email.amazonses.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Jun 2013, Christoph Lameter wrote:

> > It's possible to avoid such problems (or at least to make them less probable)
> > by avoiding direct compaction. If it's not possible to allocate a contiguous
> > page without compaction, slub will fall back to order 0 page(s). In this case
> > kswapd will be woken to perform asynchronous compaction. So, slub can return
> > to default order allocations as soon as memory will be de-fragmented.
> 
> Sounds like a good idea. Do you have some numbers to show the effect of
> this patch?
> 

I'm surprised you like this patch, it basically makes slub allocations to 
be atomic and doesn't try memory compaction nor reclaim.  Asynchronous 
compaction certainly isn't aggressive enough to mimick the effects of the 
old lumpy reclaim that would have resulted in less fragmented memory.  If 
slub is the only thing that is doing high-order allocations, it will start 
falling back to the smallest page order much much more often.

I agree that this doesn't seem like a slub issue at all but rather a page 
allocator issue; if we have many simultaneous thp faults at the same time 
and /sys/kernel/mm/transparent_hugepage/defrag is "always" then you'll get 
the same problem if deferred compaction isn't helping.

So I don't think we should be patching slub in any special way here.

Roman, are you using the latest kernel?  If so, what does
grep compact_ /proc/vmstat show after one or more of these events?
