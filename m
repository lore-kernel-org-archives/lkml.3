Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122AbaK3X4g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 18:56:36 -0500
Received: from lgeamrelo04.lge.com ([156.147.1.127]:44638 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940AbaK3X4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 18:56:34 -0500
X-Original-SENDERIP: 10.177.220.156
X-Original-MAILFROM: minchan@kernel.org
Date: Mon, 1 Dec 2014 08:56:52 +0900
From: Minchan Kim <minchan@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Michael Kerrisk <mtk.manpages@gmail.com>,
        linux-api@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Jason Evans <je@fb.com>,
        zhangyanfei@cn.fujitsu.com,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH v17 1/7] mm: support madvise(MADV_FREE)
Message-ID: <20141130235652.GA10333@bbox>
References: <1413799924-17946-1-git-send-email-minchan@kernel.org>
 <1413799924-17946-2-git-send-email-minchan@kernel.org>
 <20141127144725.GB19157@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141127144725.GB19157@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Michal,

On Thu, Nov 27, 2014 at 03:47:25PM +0100, Michal Hocko wrote:
> [Late but I didn't get to this soone - I hope this is still up-to-date
> version]
> 
> On Mon 20-10-14 19:11:58, Minchan Kim wrote:
> > Linux doesn't have an ability to free pages lazy while other OS
> > already have been supported that named by madvise(MADV_FREE).
> > 
> > The gain is clear that kernel can discard freed pages rather than
> > swapping out or OOM if memory pressure happens.
> > 
> > Without memory pressure, freed pages would be reused by userspace
> > without another additional overhead(ex, page fault + allocation
> > + zeroing).
> > 
> > How to work is following as.
> > 
> > When madvise syscall is called, VM clears dirty bit of ptes of
> > the range. If memory pressure happens, VM checks dirty bit of
> > page table and if it found still "clean", it means it's a
> > "lazyfree pages" so VM could discard the page instead of swapping out.
> > Once there was store operation for the page before VM peek a page
> > to reclaim, dirty bit is set so VM can swap out the page instead of
> > discarding.
> 
> Is there any patch for madvise man page? I guess the semantic will be
> same/similar to FreeBSD:
> http://www.freebsd.org/cgi/man.cgi?query=madvise&sektion=2

I postponed because I didn't know when we release the feature into mainline
but I should write down in man page ("MADV_FREE since Linux x.x.x").
However, early posting is not harmful.

Here it goes.
Most of content was copied from FreeBSD man page.

>From 2edd6890f92fa4943ce3c452194479458582d88c Mon Sep 17 00:00:00 2001
From: Minchan Kim <minchan@kernel.org>
Date: Mon, 1 Dec 2014 08:53:55 +0900
Subject: [PATCH] madvise.2: Document MADV_FREE

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 man2/madvise.2 | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/man2/madvise.2 b/man2/madvise.2
index 032ead7..33aa936 100644
--- a/man2/madvise.2
+++ b/man2/madvise.2
@@ -265,6 +265,19 @@ file (see
 .BR MADV_DODUMP " (since Linux 3.4)"
 Undo the effect of an earlier
 .BR MADV_DONTDUMP .
+.TP
+.BR MADV_FREE " (since Linux 3.19)"
+Gives the VM system the freedom to free pages, and tells the system that
+information in the specified page range is no longer important.
+This is an efficient way of allowing
+.BR malloc (3)
+to free pages anywhere in the address space, while keeping the address space
+valid. The next time that the page is referenced, the page might be demand
+zeroed, or might contain the data that was there before the MADV_FREE call.
+References made to that address space range will not make the VM system page the
+information back in from backing store until the page is modified again.
+It works only with private anonymous pages (see
+.BR mmap (2)).
 .SH RETURN VALUE
 On success
 .BR madvise ()
-- 
2.0.0


> 
> I guess the changelog should be more specific that this is only for the
> private MAP_ANON mappings (same applies to the patch for man).
> 
> > Firstly, heavy users would be general allocators(ex, jemalloc,
> > tcmalloc and hope glibc supports it) and jemalloc/tcmalloc already
> > have supported the feature for other OS(ex, FreeBSD)
> > 
> [...]
> > 
> > Cc: Michael Kerrisk <mtk.manpages@gmail.com>
> > Cc: Linux API <linux-api@vger.kernel.org>
> > Cc: Hugh Dickins <hughd@google.com>
> > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > Cc: Mel Gorman <mgorman@suse.de>
> > Cc: Jason Evans <je@fb.com>
> > Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > Acked-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
> > Acked-by: Rik van Riel <riel@redhat.com>
> > Signed-off-by: Minchan Kim <minchan@kernel.org>
> 
> Reviewed-by: Michal Hocko <mhocko@suse.cz>
> [...]
> -- 
> Michal Hocko
> SUSE Labs
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Kind regards,
Minchan Kim
