Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751701AbaEZUst (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 16:48:49 -0400
Received: from g5t1626.atlanta.hp.com ([15.192.137.9]:45795 "EHLO
	g5t1626.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbaEZUss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 16:48:48 -0400
Message-ID: <1401137322.12982.5.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 4/5] mm/rmap: share the i_mmap_rwsem
From: Davidlohr Bueso <davidlohr@hp.com>
To: Hugh Dickins <hughd@google.com>
Cc: akpm@linux-foundation.org, mingo@kernel.org, peterz@infradead.org,
        riel@redhat.com, mgorman@suse.de, aswin@hp.com, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 26 May 2014 13:48:42 -0700
In-Reply-To: <alpine.LSU.2.11.1405261216460.3411@eggly.anvils>
References: <1400816006-3083-1-git-send-email-davidlohr@hp.com>
	 <1400816006-3083-5-git-send-email-davidlohr@hp.com>
	 <alpine.LSU.2.11.1405261216460.3411@eggly.anvils>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-26 at 12:35 -0700, Hugh Dickins wrote:
> On Thu, 22 May 2014, Davidlohr Bueso wrote:
> 
> > Similarly to rmap_walk_anon() and collect_procs_anon(),
> > there is opportunity to share the lock in rmap_walk_file()
> > and collect_procs_file() for file backed pages.
> 
> And lots of other places, no?  I welcome i_mmap_rwsem, but I think
> you're approaching it wrongly to separate this off from 2/5, then
> follow anon_vma for the places that can be converted to lock_read().

Sure, but as you can imagine, the reasoning behind it is simplicity and
bisectability. 2/5 is easy to commit typo-like errors, and end up
locking instead of unlocking and vice versa. I ran into a few while
testing and wanted to make life easier for reviewers.

> If you go back through 2/5 and study the context of each, I think
> you'll find most make no modification to the tree, and can well
> use the lock_read() rather than the lock_write().

I was planning on revisiting some of that. I have no concrete examples
yet, but I agree, there could very well be further opportunity to share
the lock in read-only paths. This 4/5 is just the first, and most
obvious, step towards improving the usage of the i_mmap lock.

> I could be wrong, but I don't think there are any hidden gotchas.
> There certainly are in the anon_vma case (where THP makes special
> use of the anon_vma lock), and used to be in the i_mmap_lock case
> (when invalidation had to be single-threaded across cond_rescheds),
> but I think i_mmap_rwsem should be straightforward.
> 
> Sure, it's safe to use the lock_write() variant, but please don't
> prefer it to lock_read() without good reason.

I will dig deeper (probably for 3.17 now), but I really believe this is
the correct way of splitting the patches for this particular series.

Thanks,
Davidlohr

