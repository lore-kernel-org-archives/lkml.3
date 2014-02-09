Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813AbaBIRfS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 12:35:18 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:59421 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516AbaBIRfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 12:35:14 -0500
Date: Sun, 9 Feb 2014 12:34:18 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Rafael Aquini <aquini@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Bob Liu <bob.liu@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>, Greg Thelen <gthelen@google.com>,
        Hugh Dickins <hughd@google.com>, Jan Kara <jack@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Luigi Semenzato <semenzato@google.com>, Mel Gorman <mgorman@suse.de>,
        Metin Doslu <metin@citusdata.com>,
        Michel Lespinasse <walken@google.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Ozgun Erdogan <ozgun@citusdata.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Roman Gushchin <klamm@yandex-team.ru>, Ryan Mallon <rmallon@gmail.com>,
        Tejun Heo <tj@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 02/10] fs: cachefiles: use add_to_page_cache_lru()
Message-ID: <20140209173418.GH4407@cmpxchg.org>
References: <1391475222-1169-1-git-send-email-hannes@cmpxchg.org>
 <1391475222-1169-3-git-send-email-hannes@cmpxchg.org>
 <20140208114334.GA25841@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140208114334.GA25841@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 08, 2014 at 09:43:35AM -0200, Rafael Aquini wrote:
> On Mon, Feb 03, 2014 at 07:53:34PM -0500, Johannes Weiner wrote:
> > This code used to have its own lru cache pagevec up until a0b8cab3
> > ("mm: remove lru parameter from __pagevec_lru_add and remove parts of
> > pagevec API").  Now it's just add_to_page_cache() followed by
> > lru_cache_add(), might as well use add_to_page_cache_lru() directly.
> >
> 
> Just a heads-up, here: take a look at https://lkml.org/lkml/2014/2/7/587

Ah, yes.  That patch replaced a private pagevec, which consumes the
references you pass in, with add_to_page_cache_lru(), which gets its
own references.

My patch changes

    add_to_page_cache()
    lru_cache_add()

to

    add_to_page_cache_lru()
      add_to_page_cache()
      lru_cache_add()

so the refcounting does not change for the caller.

Thanks for pointing it out, though, it never hurts to double check
stuff like that.
