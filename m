Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760354AbaGYM3k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 08:29:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39963 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760182AbaGYM3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 08:29:38 -0400
Date: Fri, 25 Jul 2014 13:29:33 +0100
From: Mel Gorman <mgorman@suse.de>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        Minchan Kim <minchan@kernel.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [PATCH V4 06/15] mm, compaction: reduce zone checking frequency
 in the migration scanner
Message-ID: <20140725122933.GA10819@suse.de>
References: <1405518503-27687-1-git-send-email-vbabka@suse.cz>
 <1405518503-27687-7-git-send-email-vbabka@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1405518503-27687-7-git-send-email-vbabka@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 03:48:14PM +0200, Vlastimil Babka wrote:
> The unification of the migrate and free scanner families of function has
> highlighted a difference in how the scanners ensure they only isolate pages
> of the intended zone. This is important for taking zone lock or lru lock of
> the correct zone. Due to nodes overlapping, it is however possible to
> encounter a different zone within the range of the zone being compacted.
> 
> The free scanner, since its inception by commit 748446bb6b ("mm: compaction:
> memory compaction core"), has been checking the zone of the first valid page
> in a pageblock, and skipping the whole pageblock if the zone does not match.
> 
> This checking was completely missing from the migration scanner at first, and
> later added by commit dc9086004b ("mm: compaction: check for overlapping
> nodes during isolation for migration") in a reaction to a bug report.
> But the zone comparison in migration scanner is done once per a single scanned
> page, which is more defensive and thus more costly than a check per pageblock.
> 
> This patch unifies the checking done in both scanners to once per pageblock,
> through a new pageblock_within_zone() function, which also includes pfn_valid()
> checks. It is more defensive than the current free scanner checks, as it checks
> both the first and last page of the pageblock, but less defensive by the
> migration scanner per-page checks. It assumes that node overlapping may result
> (on some architecture) in a boundary between two nodes falling into the middle
> of a pageblock, but that there cannot be a node0 node1 node0 interleaving
> within a single pageblock.
> 
> The result is more code being shared and a bit less per-page CPU cost in the
> migration scanner.
> 
> Reported-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
