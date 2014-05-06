Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251AbaEFUaT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 16:30:19 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51461 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775AbaEFUaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 16:30:13 -0400
Date: Tue, 6 May 2014 22:30:06 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>,
        Jan Kara <jack@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 17/17] mm: filemap: Avoid unnecessary barries and
 waitqueue lookup in unlock_page fastpath
Message-ID: <20140506203006.GF1429@laptop.programming.kicks-ass.net>
References: <1398933888-4940-1-git-send-email-mgorman@suse.de>
 <1398933888-4940-18-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398933888-4940-18-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2014 at 09:44:48AM +0100, Mel Gorman wrote:
> +/*
> + * If PageWaiters was found to be set at unlock time, __wake_page_waiters
> + * should be called to actually perform the wakeup of waiters.
> + */
> +static inline void __wake_page_waiters(struct page *page)
> +{
> +	ClearPageWaiters(page);

-ENOCOMMENT

barriers should always come with a comment that explain the memory
ordering and reference the pairing barrier.

Also, FWIW, there's a mass rename queued for .16 that'll make this:

  smp_mb__after_atomic();

but for now it will also still provide the old names with a __deprecated
tag on, so no real harm.

> +	smp_mb__after_clear_bit();
> +	wake_up_page(page, PG_locked);
> +}
