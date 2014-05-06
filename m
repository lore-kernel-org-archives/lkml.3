Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757884AbaEFPzG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 11:55:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41765 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752029AbaEFPzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 11:55:04 -0400
Date: Tue, 6 May 2014 16:55:00 +0100
From: Mel Gorman <mgorman@suse.de>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Jan Kara <jack@suse.cz>,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 15/17] mm: Do not use unnecessary atomic operations when
 adding pages to the LRU
Message-ID: <20140506155500.GA23991@suse.de>
References: <1398933888-4940-1-git-send-email-mgorman@suse.de>
 <1398933888-4940-16-git-send-email-mgorman@suse.de>
 <5369002D.7030600@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <5369002D.7030600@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2014 at 05:30:53PM +0200, Vlastimil Babka wrote:
> On 05/01/2014 10:44 AM, Mel Gorman wrote:
> >When adding pages to the LRU we clear the active bit unconditionally. As the
> >page could be reachable from other paths we cannot use unlocked operations
> >without risk of corruption such as a parallel mark_page_accessed. This
> >patch test if is necessary to clear the atomic flag before using an atomic
> 
>                                           active
> 

Thanks. Clearly I had atomic on the brain.

> >operation. In the unlikely even this races with mark_page_accesssed the
> >consequences are simply that the page may be promoted to the active list
> >that might have been left on the inactive list before the patch. This is
> >a marginal consequence.
> 
> Well if this is racy, then even before the patch, mark_page_accessed
> might have come right after ClearPageActive(page) anyway?
> Or is the
> changelog saying that this change only extended the race window that
> already existed? If yes it could be more explicit, as now it might
> sound as if the race was introduced.
> 

When adding pages to the LRU we clear the active bit unconditionally. As the
page could be reachable from other paths we cannot use unlocked operations
without risk of corruption such as a parallel mark_page_accessed. This
patch tests if is necessary to clear the active flag before using an atomic
operation. This potentially opens a tiny race when PageActive is checked
as mark_page_accessed could be called after PageActive was checked. The
race already exists but this patch changes it slightly. The consequence
is that that the page may be promoted to the active list that might have
been left on the inactive list before the patch. It's too tiny a race and
too marginal a consequence to always use atomic operations for.

?

-- 
Mel Gorman
SUSE Labs
