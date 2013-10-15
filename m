Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758480Ab3JOKdm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 06:33:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:63555 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753669Ab3JOKdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 06:33:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,498,1378882800"; 
   d="scan'208";a="419333433"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Ning Qu <quning@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Hugh Dickins <hughd@google.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Hugh Dickins <hughd@google.com>, Wu Fengguang <fengguang.wu@intel.com>,
        Jan Kara <jack@suse.cz>, Mel Gorman <mgorman@suse.de>,
        linux-mm@kvack.org, Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Hillf Danton <dhillf@gmail.com>, Dave Hansen <dave@sr71.net>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ning Qu <quning@google.com>
In-Reply-To: <20131015001228.GE3432@hippobay.mtv.corp.google.com>
References: <20131015001228.GE3432@hippobay.mtv.corp.google.com>
Subject: RE: [PATCH 04/12] mm, thp, tmpfs: split huge page when moving from
 page cache to swap
Content-Transfer-Encoding: 7bit
Message-Id: <20131015103334.E3877E0090@blue.fi.intel.com>
Date: Tue, 15 Oct 2013 13:33:34 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ning Qu wrote:
> in shmem_writepage, we have to split the huge page when moving pages
> from page cache to swap because we don't support huge page in swap
> yet.
> 
> Signed-off-by: Ning Qu <quning@gmail.com>
> ---
>  mm/shmem.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 8fe17dd..68a0e1d 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -898,6 +898,13 @@ static int shmem_writepage(struct page *page, struct writeback_control *wbc)
>  	swp_entry_t swap;
>  	pgoff_t index;
>  
> +	/* TODO: we have to break the huge page at this point,
> +	 * since we have no idea how to recover a huge page from
> +	 * swap.
> +	 */
> +	if (PageTransCompound(page))
> +		split_huge_page(compound_trans_head(page));
> +

After the split you handle here only first small page of the huge page.
Is it what we want to do? Should we swap out all small pages of the huge
page?

-- 
 Kirill A. Shutemov
