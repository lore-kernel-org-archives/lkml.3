Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351AbaLIDB5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 22:01:57 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:41394 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbaLIDBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 22:01:55 -0500
X-Original-SENDERIP: 10.177.220.156
X-Original-MAILFROM: minchan@kernel.org
Date: Tue, 9 Dec 2014 12:02:43 +0900
From: Minchan Kim <minchan@kernel.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: linux-mm@kvack.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, David Rientjes <rientjes@google.com>
Subject: Re: [RFC PATCH 1/3] mm: when stealing freepages, also take pages
 created by splitting buddy page
Message-ID: <20141209030243.GC3358@bbox>
References: <1417713178-10256-1-git-send-email-vbabka@suse.cz>
 <1417713178-10256-2-git-send-email-vbabka@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1417713178-10256-2-git-send-email-vbabka@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 06:12:56PM +0100, Vlastimil Babka wrote:
> When __rmqueue_fallback() is called to allocate a page of order X, it will
> find a page of order Y >= X of a fallback migratetype, which is different from
> the desired migratetype. With the help of try_to_steal_freepages(), it may
> change the migratetype (to the desired one) also of:
> 
> 1) all currently free pages in the pageblock containing the fallback page
> 2) the fallback pageblock itself
> 3) buddy pages created by splitting the fallback page (when Y > X)
> 
> These decisions take the order Y into account, as well as the desired
> migratetype, with the goal of preventing multiple fallback allocations that
> could e.g. distribute UNMOVABLE allocations among multiple pageblocks.
> 
> Originally, decision for 1) has implied the decision for 3). Commit
> 47118af076f6 ("mm: mmzone: MIGRATE_CMA migration type added") changed that
> (probably unintentionally) so that the buddy pages in case 3) are always
> changed to the desired migratetype, except for CMA pageblocks.
> 
> Commit fef903efcf0c ("mm/page_allo.c: restructure free-page stealing code and
> fix a bug") did some refactoring and added a comment that the case of 3) is
> intended. Commit 0cbef29a7821 ("mm: __rmqueue_fallback() should respect
> pageblock type") removed the comment and tried to restore the original behavior
> where 1) implies 3), but due to the previous refactoring, the result is instead
> that only 2) implies 3) - and the conditions for 2) are less frequently met
> than conditions for 1). This may increase fragmentation in situations where the
> code decides to steal all free pages from the pageblock (case 1)), but then
> gives back the buddy pages produced by splitting.
> 
> This patch restores the original intended logic where 1) implies 3). During
> testing with stress-highalloc from mmtests, this has shown to decrease the
> number of events where UNMOVABLE and RECLAIMABLE allocations steal from MOVABLE
> pageblocks, which can lead to permanent fragmentation. It has increased the
> number of events when MOVABLE allocations steal from UNMOVABLE or RECLAIMABLE
> pageblocks, but these are fixable by sync compaction and thus less harmful.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Minchan Kim <minchan@kernel.org>

I expect you will Cc -stable when you respin with fixing pointed out
by Joonsoo.

-- 
Kind regards,
Minchan Kim
