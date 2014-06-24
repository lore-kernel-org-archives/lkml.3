Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbaFXRei (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 13:34:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3240 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754598AbaFXReg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 13:34:36 -0400
Date: Tue, 24 Jun 2014 12:58:21 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Minchan Kim <minchan@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 04/13] mm, compaction: move pageblock checks up from
 isolate_migratepages_range()
Message-ID: <20140624165821.GC18289@nhori.bos.redhat.com>
References: <1403279383-5862-1-git-send-email-vbabka@suse.cz>
 <1403279383-5862-5-git-send-email-vbabka@suse.cz>
 <20140624045252.GA18289@nhori.bos.redhat.com>
 <53A99A88.1040500@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A99A88.1040500@suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 05:34:32PM +0200, Vlastimil Babka wrote:
> On 06/24/2014 06:52 AM, Naoya Horiguchi wrote:
> >>-	low_pfn = isolate_migratepages_range(zone, cc, low_pfn, end_pfn, false);
> >>-	if (!low_pfn || cc->contended)
> >>-		return ISOLATE_ABORT;
> >>+		/* Do not scan within a memory hole */
> >>+		if (!pfn_valid(low_pfn))
> >>+			continue;
> >>+
> >>+		page = pfn_to_page(low_pfn);
> >
> >Can we move (page_zone != zone) check here as isolate_freepages() does?
> 
> Duplicate perhaps, not sure about move.

Sorry for my unclearness.
I meant that we had better do this check in per-pageblock loop (as the free
scanner does) instead of in per-pfn loop (as we do now.)

> Does CMA make sure that all pages
> are in the same zone?

It seems not, CMA just specifies start pfn and end pfn, so it can cover
multiple zones.
And we also have a case of node overlapping as commented in commit dc9086004
"mm: compaction: check for overlapping nodes during isolation for migration".
So we need this check in compaction side.

Thanks,
Naoya Horiguchi

> Common sense tells me it would be useless otherwise,
> but I haven't checked if we can rely on it.
