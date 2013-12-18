Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957Ab3LRT3F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 14:29:05 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57102 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab3LRT3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 14:29:03 -0500
Date: Wed, 18 Dec 2013 20:28:55 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Darren Hart <dvhart@linux.intel.com>,
        Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 7/7] mm: thp: introduce compound_head_put_tail(),
 change get_futex_key() to use it
Message-ID: <20131218192855.GE16438@laptop.programming.kicks-ass.net>
References: <20131218191913.GA6464@redhat.com>
 <20131218192008.GA8343@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131218192008.GA8343@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 08:20:08PM +0100, Oleg Nesterov wrote:
> +struct page *compound_head_put_tail(struct page *page)
> +{
> +	struct page *page_head;
> +	unsigned long flags;
> +
> +	if (!PageTail(page))
> +		return page;
> +
> +	page_head = compound_trans_head(page);
> +
> +	if (!__compound_tail_refcounted(page_head)) {

This barrier is missing a comment describing the ordering and the
pairing.

> +		smp_rmb();
> +		if (likely(PageTail(page)))
> +			return page_head;
> +		else
> +			return page;
> +	}
> +
> +	if (likely(get_lock_thp_head(page_head, page, &flags))) {
> +		if (put_page_testzero(page_head))
> +			VM_BUG_ON(1);
> +		atomic_dec(&page->_mapcount);
> +		compound_unlock_irqrestore(page_head, flags);
> +
> +		return page_head;
> +	}
> +
> +	return page;
> +}
