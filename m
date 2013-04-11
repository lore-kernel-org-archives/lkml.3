Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964881Ab3DKUz4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:55:56 -0400
Received: from bitsync.net ([80.83.126.10]:59982 "EHLO bitsync.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934912Ab3DKUzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:55:17 -0400
Message-ID: <51672331.6070605@bitsync.net>
Date: Thu, 11 Apr 2013 22:55:13 +0200
From: Zlatko Calusic <zcalusic@bitsync.net>
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, Jiri Slaby <jslaby@suse.cz>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        dormando <dormando@rydia.net>, Satoru Moriya <satoru.moriya@hds.com>,
        Michal Hocko <mhocko@suse.cz>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/10] Reduce system disruption due to kswapd V2
References: <1365505625-9460-1-git-send-email-mgorman@suse.de>
In-Reply-To: <1365505625-9460-1-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09.04.2013 13:06, Mel Gorman wrote:
> Posting V2 of this series got delayed due to trying to pin down an unrelated
> regression in 3.9-rc where interactive performance is shot to hell. That
> problem still has not been identified as it's resisting attempts to be
> reproducible by a script for the purposes of bisection.
>
> For those that looked at V1, the most important difference in this version
> is how patch 2 preserves the proportional scanning of anon/file LRUs.
>
> The series is against 3.9-rc6.
>
> Changelog since V1
> o Rename ZONE_DIRTY to ZONE_TAIL_LRU_DIRTY			(andi)
> o Reformat comment in shrink_page_list				(andi)
> o Clarify some comments						(dhillf)
> o Rework how the proportional scanning is preserved
> o Add PageReclaim check before kswapd starts writeback
> o Reset sc.nr_reclaimed on every full zone scan
>

I believe this is what you had in your tree as kswapd-v2r9 branch? If 
I'm right, then I had this series under test for about 2 weeks on two 
different machines (one server, one desktop). Here's what I've found:

- while the series looks overwhelming, with a lot of intricate changes 
(at least from my POV), it proved completely stable and robust. I had 
ZERO issues with it. I'd encourage everybody to test it, even on the 
production!

- I've just sent to you and to the linux-mm list a longish report of the 
issue I tracked last few months that is unfortunately NOT solved with 
this patch series (although at first it looked like it would be). 
Occasionaly I still see large parts of memory freed for no good reason, 
except I explained in the report how it happens. What I still don't know 
is what's the real cause of the heavy imbalance in the pagecache 
utilization between DMA32/NORMAL zones. Seen only on 4GB RAM machines, 
but I suppose that is a quite popular configuration these days.

- The only slightly negative thing I observed is that with the patch 
applied kswapd burns 10x - 20x more CPU. So instead of about 15 seconds, 
it has now spent more than 4 minutes on one particular machine with a 
quite steady load (after about 12 days of uptime). Admittedly, that's 
still nothing too alarming, but...

- I like VERY much how you cleaned up the code so it is more readable 
now. I'd like to see it in the Linus tree as soon as possible. Very good 
job there!

Regards,
-- 
Zlatko

