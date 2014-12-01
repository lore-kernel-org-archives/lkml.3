Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932717AbaLAWwp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 17:52:45 -0500
Received: from gum.cmpxchg.org ([85.214.110.215]:51187 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932637AbaLAWwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 17:52:44 -0500
Date: Mon, 1 Dec 2014 17:52:34 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Hugh Dickins <hughd@google.com>,
        Michel Lespinasse <walken@google.com>, Jan Kara <jack@suse.cz>,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [rfc patch] mm: protect set_page_dirty() from ongoing truncation
Message-ID: <20141201225234.GA4559@phnom.home.cmpxchg.org>
References: <1416944921-14164-1-git-send-email-hannes@cmpxchg.org>
 <20141126140006.d6f71f447b69cd4fadc42c26@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141126140006.d6f71f447b69cd4fadc42c26@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 02:00:06PM -0800, Andrew Morton wrote:
> On Tue, 25 Nov 2014 14:48:41 -0500 Johannes Weiner <hannes@cmpxchg.org> wrote:
> >  The
> > same btw applies for the page_mkwrite case: how is mapping safe to
> > pass to balance_dirty_pages() after unlocking page table and page?
> 
> I'm not sure which code you're referring to here, but it's likely that
> the switch-balancing-to-bdi approach will address that as well?

This code in do_wp_page():

		pte_unmap_unlock(page_table, ptl);
[...]
		put_page(dirty_page);
		if (page_mkwrite) {
			struct address_space *mapping = dirty_page->mapping;

			set_page_dirty(dirty_page);
			unlock_page(dirty_page);
			page_cache_release(dirty_page);
			if (mapping)	{
				/*
				 * Some device drivers do not set page.mapping
				 * but still dirty their pages
				 */
				balance_dirty_pages_ratelimited(mapping);
			}
		}

And there is also this code in do_shared_fault():

	pte_unmap_unlock(pte, ptl);

	if (set_page_dirty(fault_page))
		dirtied = 1;
	mapping = fault_page->mapping;
	unlock_page(fault_page);
	if ((dirtied || vma->vm_ops->page_mkwrite) && mapping) {
		/*
		 * Some device drivers do not set page.mapping but still
		 * dirty their pages
		 */
		balance_dirty_pages_ratelimited(mapping);
	}

I don't see anything that ensures mapping stays alive by the time it's
passed to balance_dirty_pages() in either case.

Argh, but of course there is.  The mmap_sem.  That pins the vma, which
pins the file, which pins the inode.  In all cases.  So I think we can
just stick with passing mapping to balance_dirty_pages() for now.
