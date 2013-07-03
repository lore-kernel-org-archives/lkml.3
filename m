Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932767Ab3GCNl2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 09:41:28 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:39438 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755922Ab3GCNl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 09:41:26 -0400
Date: Wed, 3 Jul 2013 14:41:19 +0100
From: Steve Capper <steve.capper@linaro.org>
To: Joern Engel <joern@logfs.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] hugetlb: properly account rss
Message-ID: <20130703134118.GA4978@linaro.org>
References: <1371581225-27535-1-git-send-email-joern@logfs.org>
 <1371581225-27535-2-git-send-email-joern@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371581225-27535-2-git-send-email-joern@logfs.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 02:47:04PM -0400, Joern Engel wrote:
> When moving a program from mmap'ing small pages to mmap'ing huge pages,
> a remarkable drop in rss ensues.  For some reason hugepages were never
> accounted for in rss, which in my book is a clear bug.  Sadly this bug
> has been present in hugetlbfs since it was merged back in 2002.  There
> is every chance existing programs depend on hugepages not being counted
> as rss.
> 
> I think the correct solution is to fix the bug and wait for someone to
> complain.  It is just as likely that noone cares - as evidenced by the
> fact that noone seems to have noticed for ten years.
> 
> Signed-off-by: Joern Engel <joern@logfs.org>
> ---
>  mm/hugetlb.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 

Hi,
This patch has caused a few warnings for me today when it was integrated into
linux-next. The libhugetlbfs test suite gave me:
[ 94.320661] BUG: Bad rss-counter state mm:ffff880119461040 idx:1 val:-512
[ 94.330346] BUG: Bad rss-counter state mm:ffff880119460680 idx:1 val:-2560
[ 94.341746] BUG: Bad rss-counter state mm:ffff880119460d00 idx:1 val:-512
[ 94.347518] BUG: Bad rss-counter state mm:ffff880119460d00 idx:1 val:-512
[ 94.415203] BUG: Bad rss-counter state mm:ffff8801194f9040 idx:1 val:-1024

[ ...]

I think I've found the cause; MAP_SHARED mappings.
alloc_huge_page and __unmap_hugepage_range are called for shared pages. Also,
__unmap_hugepage_range is called more times than alloc_huge_page (which makes
sense as multiple views of a shared mapping are unmapped) leading to negative
counter values.

Excluding VM_SHARED VMAs from the counter increment/decrement stopped the
warnings for me. Although this may not be the best way to address the issue.

Cheers,
-- 
Steve
