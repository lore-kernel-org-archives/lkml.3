Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867AbaEHF07 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 01:26:59 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:36726 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbaEHF05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 01:26:57 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Thu, 8 May 2014 14:28:46 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Hugh Dickins <hughd@google.com>,
        Greg Thelen <gthelen@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Minchan Kim <minchan@kernel.org>,
        Mel Gorman <mgorman@suse.de>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH v2 2/2] mm/compaction: avoid rescanning pageblocks in
 isolate_freepages
Message-ID: <20140508052845.GB9161@js1304-P5Q-DELUXE>
References: <alpine.DEB.2.02.1405061922220.18635@chino.kir.corp.google.com>
 <1399464550-26447-1-git-send-email-vbabka@suse.cz>
 <1399464550-26447-2-git-send-email-vbabka@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399464550-26447-2-git-send-email-vbabka@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 02:09:10PM +0200, Vlastimil Babka wrote:
> The compaction free scanner in isolate_freepages() currently remembers PFN of
> the highest pageblock where it successfully isolates, to be used as the
> starting pageblock for the next invocation. The rationale behind this is that
> page migration might return free pages to the allocator when migration fails
> and we don't want to skip them if the compaction continues.
> 
> Since migration now returns free pages back to compaction code where they can
> be reused, this is no longer a concern. This patch changes isolate_freepages()
> so that the PFN for restarting is updated with each pageblock where isolation
> is attempted. Using stress-highalloc from mmtests, this resulted in 10%
> reduction of the pages scanned by the free scanner.

Hello,

Although this patch could reduce page scanned, it is possible to skip
scanning fresh pageblock. If there is zone lock contention and we are on
asyn compaction, we stop scanning this pageblock immediately. And
then, we will continue to scan next pageblock. With this patch,
next_free_pfn is updated in this case, so we never come back again to this
pageblock. Possibly this makes compaction success rate low, doesn't
it?

Thanks.

