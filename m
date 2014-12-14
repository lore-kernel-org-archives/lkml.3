Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769AbaLNDYO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 22:24:14 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:53111 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431AbaLNDYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 22:24:13 -0500
Date: Sat, 13 Dec 2014 19:24:03 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Davidlohr Bueso <dave@stgolabs.net>
cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, hughd@google.com,
        mel@csn.ul.ie, riel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 45/99] mm: unmapped page migration avoid unmap+remap
 overhead
In-Reply-To: <1418526487.1928.1.camel@stgolabs.net>
Message-ID: <alpine.LSU.2.11.1412131919270.3428@eggly.anvils>
References: <548b8eb3.mP5dt9zrTrZO7rLj%akpm@linux-foundation.org> <1418526487.1928.1.camel@stgolabs.net>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Dec 2014, Davidlohr Bueso wrote:
> On Fri, 2014-12-12 at 16:56 -0800, akpm@linux-foundation.org wrote:
> > From: Hugh Dickins <hughd@google.com>
> > Subject: mm: unmapped page migration avoid unmap+remap overhead
> > 
> > Page migration's __unmap_and_move(), and rmap's try_to_unmap(), were
> > created for use on pages almost certainly mapped into userspace.  But
> > nowadays compaction often applies them to unmapped page cache pages: which
> > may exacerbate contention on i_mmap_rwsem quite unnecessarily, since
> > try_to_unmap_file() makes no preliminary page_mapped() check.
> > 
> > Now check page_mapped() in __unmap_and_move(); and avoid repeating the
> > same overhead in rmap_walk_file() - don't remove_migration_ptes() when we
> > never inserted any.
> > 
> > (The PageAnon(page) comment blocks now look even sillier than before, but
> > clean that up on some other occasion.  And note in passing that
> > try_to_unmap_one() does not use a migration entry when PageSwapCache, so
> > remove_migration_ptes() will then not update that swap entry to newpage
> > pte: not a big deal, but something else to clean up later.)
> > 
> > Davidlohr remarked in "mm,fs: introduce helpers around the i_mmap_mutex"
> > conversion to i_mmap_rwsem, that "The biggest winner of these changes is
> > migration": a part of the reason might be all of that unnecessary taking
> > of i_mmap_mutex in page migration; 
> 
> Yeah, this is making a lot of sense.
> 
> > and it's rather a shame that I didn't
> > get around to sending this patch in before his - this one is much less
> > useful after Davidlohr's conversion to rwsem, but still good.
> 
> Now that I have some free hardware, I did some testing to consider this
> patch for some SLE kernels (which still has the i_mmap mutex), and it
> sure relieves a lot of the overhead/contention. On a 60-core box with a
> file server benchmark we increase throughput by up to 60-70%:
> 
> new_fserver-61     21456.59 (  0.00%)    35875.59 ( 67.20%)
> new_fserver-121    22335.16 (  0.00%)    38037.28 ( 70.30%)
> new_fserver-181    23280.22 (  0.00%)    39518.54 ( 69.75%)
> new_fserver-241    23194.88 (  0.00%)    39065.85 ( 68.42%)
> new_fserver-301    23135.30 (  0.00%)    38464.88 ( 66.26%)
> new_fserver-361    22922.97 (  0.00%)    38115.74 ( 66.28%)
> new_fserver-421    22841.84 (  0.00%)    37859.06 ( 65.74%)
> new_fserver-481    22643.83 (  0.00%)    37751.59 ( 66.72%)
> new_fserver-541    22620.21 (  0.00%)    37036.09 ( 63.73%)
> new_fserver-601    22593.85 (  0.00%)    36959.11 ( 63.58%)
> new_fserver-661    22434.81 (  0.00%)    36629.28 ( 63.27%)
> new_fserver-721    22219.68 (  0.00%)    36128.16 ( 62.60%)
> new_fserver-781    22134.90 (  0.00%)    35893.50 ( 62.16%)
> new_fserver-841    21901.59 (  0.00%)    35826.33 ( 63.58%)
> new_fserver-901    21911.80 (  0.00%)    35285.66 ( 61.03%)
> new_fserver-961    21810.72 (  0.00%)    35253.62 ( 61.63%)
> 
> Anyway, it's already picked up by Linus, but thought it would be nice to
> have actual data.

Wow, thanks a lot, Davidlohr: that's really helpful and interesting.
I just did the patch as a source-inspection thing, and never got to
measure anything.  Well worth backporting, yes.

Hugh
