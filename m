Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833Ab3A2N2q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 08:28:46 -0500
Received: from mga14.intel.com ([143.182.124.37]:24920 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681Ab3A2N2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 08:28:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,559,1355126400"; 
   d="scan'208";a="196248744"
Date: Tue, 29 Jan 2013 15:14:58 +0200
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Hugh Dickins <hughd@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <5107cb52e07b1_376199eb7059997@blue.mail>
In-Reply-To: <alpine.LNX.2.00.1301282041280.27186@eggly.anvils>
References: <1359365068-10147-1-git-send-email-kirill.shutemov@linux.intel.com> <alpine.LNX.2.00.1301282041280.27186@eggly.anvils>
Subject: Re: [PATCH, RFC 00/16] Transparent huge page cache
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Mon, 28 Jan 2013, Kirill A. Shutemov wrote:
> > From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> > 
> > Here's first steps towards huge pages in page cache.
> > 
> > The intend of the work is get code ready to enable transparent huge page
> > cache for the most simple fs -- ramfs.
> > 
> > It's not yet near feature-complete. It only provides basic infrastructure.
> > At the moment we can read, write and truncate file on ramfs with huge pages in
> > page cache. The most interesting part, mmap(), is not yet there. For now
> > we split huge page on mmap() attempt.
> > 
> > I can't say that I see whole picture. I'm not sure if I understand locking
> > model around split_huge_page(). Probably, not.
> > Andrea, could you check if it looks correct?
> > 
> > Next steps (not necessary in this order):
> >  - mmap();
> >  - migration (?);
> >  - collapse;
> >  - stats, knobs, etc.;
> >  - tmpfs/shmem enabling;
> >  - ...
> > 
> > Kirill A. Shutemov (16):
> >   block: implement add_bdi_stat()
> >   mm: implement zero_huge_user_segment and friends
> >   mm: drop actor argument of do_generic_file_read()
> >   radix-tree: implement preload for multiple contiguous elements
> >   thp, mm: basic defines for transparent huge page cache
> >   thp, mm: rewrite add_to_page_cache_locked() to support huge pages
> >   thp, mm: rewrite delete_from_page_cache() to support huge pages
> >   thp, mm: locking tail page is a bug
> >   thp, mm: handle tail pages in page_cache_get_speculative()
> >   thp, mm: implement grab_cache_huge_page_write_begin()
> >   thp, mm: naive support of thp in generic read/write routines
> >   thp, libfs: initial support of thp in
> >     simple_read/write_begin/write_end
> >   thp: handle file pages in split_huge_page()
> >   thp, mm: truncate support for transparent huge page cache
> >   thp, mm: split huge page on mmap file page
> >   ramfs: enable transparent huge page cache
> > 
> >  fs/libfs.c                  |   54 +++++++++---
> >  fs/ramfs/inode.c            |    6 +-
> >  include/linux/backing-dev.h |   10 +++
> >  include/linux/huge_mm.h     |    8 ++
> >  include/linux/mm.h          |   15 ++++
> >  include/linux/pagemap.h     |   14 ++-
> >  include/linux/radix-tree.h  |    3 +
> >  lib/radix-tree.c            |   32 +++++--
> >  mm/filemap.c                |  204 +++++++++++++++++++++++++++++++++++--------
> >  mm/huge_memory.c            |   62 +++++++++++--
> >  mm/memory.c                 |   22 +++++
> >  mm/truncate.c               |   12 +++
> >  12 files changed, 375 insertions(+), 67 deletions(-)
> 
> Interesting.
> 
> I was starting to think about Transparent Huge Pagecache a few
> months ago, but then got washed away by incoming waves as usual.
> 
> Certainly I don't have a line of code to show for it; but my first
> impression of your patches is that we have very different ideas of
> where to start.
> 
> Perhaps that's good complementarity, or perhaps I'll disagree with
> your approach.  I'll be taking a look at yours in the coming days,
> and trying to summon back up my own ideas to summarize them for you.

Yeah, it would be nice to see alternative design ideas. Looking forward.

> Perhaps I was naive to imagine it, but I did intend to start out
> generically, independent of filesystem; but content to narrow down
> on tmpfs alone where it gets hard to support the others (writeback
> springs to mind).  khugepaged would be migrating little pages into
> huge pages, where it saw that the mmaps of the file would benefit
> (and for testing I would hack mmap alignment choice to favour it).

I don't think all fs at once would fly, but it's wonderful, if I'm
wrong :)

> I had arrived at a conviction that the first thing to change was
> the way that tail pages of a THP are refcounted, that it had been a
> mistake to use the compound page method of holding the THP together.
> But I'll have to enter a trance now to recall the arguments ;)

THP refcounting looks reasonable for me, if take split_huge_page() in
account.

-- 
 Kirill A. Shutemov
