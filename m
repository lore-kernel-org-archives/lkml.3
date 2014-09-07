Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751331AbaIGGco (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 02:32:44 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:48303 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbaIGGcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 02:32:43 -0400
MIME-Version: 1.0
X-Originating-IP: [212.25.79.130]
In-Reply-To: <20140905101451.GF17501@suse.de>
References: <1404893588-21371-1-git-send-email-mgorman@suse.de>
 <1404893588-21371-7-git-send-email-mgorman@suse.de> <53E4EC53.1050904@suse.cz>
 <20140811121241.GD7970@suse.de> <53E8B83D.1070004@suse.cz>
 <20140902140116.GD29501@cmpxchg.org> <20140905101451.GF17501@suse.de>
From: Leon Romanovsky <leon@leon.nu>
Date: Sun, 7 Sep 2014 09:32:20 +0300
Message-ID: <CALq1K=JO2b-=iq40RRvK8JFFbrzyH5EyAp5jyS50CeV0P3eQcA@mail.gmail.com>
Subject: Re: [PATCH] mm: page_alloc: Fix setting of ZONE_FAIR_DEPLETED on UP
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel,
>         __mod_zone_page_state(zone, NR_ALLOC_BATCH, -(1 << order));
> -       if (zone_page_state(zone, NR_ALLOC_BATCH) == 0 &&
> +       if (zone_page_state(zone, NR_ALLOC_BATCH) <= 0 &&
zone_page_state is declared to return unsigned long value [1], so it
should never be below 0.
So interesting question: what zone_page_state will return for negative
atomic_long_read(&zone->vm_stat[item]) ?

130 static inline unsigned long zone_page_state(struct zone *zone,
131                                         enum zone_stat_item item)
132 {
133         long x = atomic_long_read(&zone->vm_stat[item]);
134 #ifdef CONFIG_SMP
135         if (x < 0)
136                 x = 0;
137 #endif
138         return x;
139 }

[1] https://git.kernel.org/cgit/linux/kernel/git/mhocko/mm.git/tree/include/linux/vmstat.h#n130

-- 
Leon Romanovsky | Independent Linux Consultant
        www.leon.nu | leon@leon.nu
