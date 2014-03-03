Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbaCCI2O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 03:28:14 -0500
Received: from lgeamrelo04.lge.com ([156.147.1.127]:43467 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbaCCI2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 03:28:12 -0500
X-Original-SENDERIP: 10.177.220.200
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Mon, 3 Mar 2014 17:28:46 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan@kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH 6/6] mm: use atomic bit operations in
 set_pageblock_flags_group()
Message-ID: <20140303082846.GB28899@lge.com>
References: <1393596904-16537-1-git-send-email-vbabka@suse.cz>
 <1393596904-16537-7-git-send-email-vbabka@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393596904-16537-7-git-send-email-vbabka@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 03:15:04PM +0100, Vlastimil Babka wrote:
> set_pageblock_flags_group() is used to set either migratetype or skip bit of a
> pageblock. Setting migratetype is done under zone->lock (except from __init
> code), however changing the skip bits is not protected and the pageblock flags
> bitmap packs migratetype and skip bits together and uses non-atomic bit ops.
> Therefore, races between setting migratetype and skip bit are possible and the
> non-atomic read-modify-update of the skip bit may cause lost updates to
> migratetype bits, resulting in invalid migratetype values, which are in turn
> used to e.g. index free_list array.
> 
> The race has been observed to happen and cause panics, albeit during
> development of series that increases frequency of migratetype changes through
> {start,undo}_isolate_page_range() calls.
> 
> Two possible solutions were investigated: 1) using zone->lock for changing
> pageblock_skip bit and 2) changing the bitmap operations to be atomic. The
> problem of 1) is that zone->lock is already contended and almost never held in
> the compaction code that updates pageblock_skip bits. Solution 2) should scale
> better, but adds atomic operations also to migratype changes which are already
> protected by zone->lock.

How about 3) introduce new bitmap for pageblock_skip?
I guess that migratetype bitmap is read-intensive and set/clear pageblock_skip
could make performance degradation.

> 
> Using mmtests' stress-highalloc benchmark, little difference was found between
> the two solutions. The base is 3.13 with recent compaction series by myself and
> Joonsoo Kim applied.
> 
>                 3.13        3.13        3.13
>                 base     2)atomic     1)lock
> User         6103.92     6072.09     6178.79
> System       1039.68     1033.96     1042.92
> Elapsed      2114.27     2090.20     2110.23
> 

I really wonder how 2) is better than base although there is a little difference.
Is it the avg result of 10 runs? Do you have any idea what happens?

Thanks.

