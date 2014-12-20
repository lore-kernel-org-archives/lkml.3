Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859AbaLTJZP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 04:25:15 -0500
Received: from mx2.parallels.com ([199.115.105.18]:33919 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774AbaLTJZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 04:25:09 -0500
Date: Sat, 20 Dec 2014 12:24:54 +0300
From: Vladimir Davydov <vdavydov@parallels.com>
To: Vlastimil Babka <vbabka@suse.cz>
CC: Michal Hocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        <stable@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 1/2] mm, vmscan: prevent kswapd livelock due to
 pfmemalloc-throttled process being killed
Message-ID: <20141220092454.GL18274@esperanza>
References: <1418994116-23665-1-git-send-email-vbabka@suse.cz>
 <20141219155747.GA31756@dhcp22.suse.cz>
 <20141219182815.GK18274@esperanza>
 <5494AF56.9070001@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5494AF56.9070001@suse.cz>
X-Originating-IP: [81.5.99.36]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 20, 2014 at 12:05:58AM +0100, Vlastimil Babka wrote:
> On 19.12.2014 19:28, Vladimir Davydov wrote:
> >So AFAIU the problem does exist. However, I think it could be fixed by
> >simply waking up all processes waiting on pfmemalloc_wait before putting
> >kswapd to sleep:
> 
> Hm I don't see how it helps? If any of the waiting processes were killed
> and wants to run on kswapd's CPU to remove itself from the waitqueue,
> it will still remain on the waitqueue, no?

Yes, but do we really want all waiting processes to be removed from the
wait queue? AFAIU we just want them to be awake before putting kswapd to
sleep. If there's a process killed (and therefore woken) by the OOM
killer left on the wait queue after we called wake_up_all, it will see
pgdat_balanced=true as soon as it gets scheduled and pass away quickly.
All we have to do is drop the waitqueue_active check from kswapd.

Thanks,
Vladimir
