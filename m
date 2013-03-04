Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758261Ab3CDPJt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 10:09:49 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:40773 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757835Ab3CDPJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 10:09:48 -0500
Date: Mon, 4 Mar 2013 10:09:37 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Li Haifeng <omycle@gmail.com>
Cc: "open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] mm: Fixup the condition whether the page cache is free
Message-ID: <20130304150937.GB23767@cmpxchg.org>
References: <CAFNq8R7tq9kvD9LyhZJ-Cj0kexQfDsPhB4iQYyZ9s9+8Jo82QA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFNq8R7tq9kvD9LyhZJ-Cj0kexQfDsPhB4iQYyZ9s9+8Jo82QA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 04, 2013 at 09:54:26AM +0800, Li Haifeng wrote:
> When a page cache is to reclaim, we should to decide whether the page
> cache is free.
> IMO, the condition whether a page cache is free should be 3 in page
> frame reclaiming. The reason lists as below.
> 
> When page is allocated, the page->_count is 1(code fragment is code-1 ).
> And when the page is allocated for reading files from extern disk, the
> page->_count will increment 1 by page_cache_get() in
> add_to_page_cache_locked()(code fragment is code-2). When the page is to
> reclaim, the isolated LRU list also increase the page->_count(code
> fragment is code-3).

The page count is initialized to 1, but that does not stay with the
object.  It's a reference that is passed to the allocating task, which
drops it again when it's done with the page.  I.e. the pattern is like
this:

instantiation:
page = page_cache_alloc()	/* instantiator reference -> 1 */
add_to_page_cache(page, mapping, offset)
  get_page(page)		/* page cache reference -> 2 */
lru_cache_add(page)
  get_page(page)		/* pagevec reference -> 3 */
/* ...initiate read, write, associate buffers, ... */
page_cache_release(page)	/* drop instantiator reference -> 2 + private */

reclaim:
lru_add_drain()
  page_cache_release(page)	/* drop pagevec reference -> 1 + private */
__isolate_lru_page(page)
  page_cache_get(page)		/* reclaim reference -> 2 + private */
is_page_cache_freeable(page)
try_to_free_buffers()		/* drop buffer ref -> 2 */
__remove_mapping()		/* drop page cache and isolator ref -> 0 */
free_hot_cold_page()
