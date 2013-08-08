Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966568Ab3HHUvJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 16:51:09 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:38020 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966544Ab3HHUvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 16:51:07 -0400
Message-ID: <1375994967.29639.4.camel@concerto>
Subject: Re: [PATCH 22/23] thp, mm: split huge page on mmap file page
From: Khalid Aziz <khalid.aziz@oracle.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, Dave Hansen <dave@sr71.net>,
        Ning Qu <quning@google.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 08 Aug 2013 14:49:27 -0600
In-Reply-To: <1375582645-29274-23-git-send-email-kirill.shutemov@linux.intel.com>
References: <1375582645-29274-1-git-send-email-kirill.shutemov@linux.intel.com>
	 <1375582645-29274-23-git-send-email-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-08-04 at 05:17 +0300, Kirill A. Shutemov wrote:
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> 
> We are not ready to mmap file-backed tranparent huge pages. Let's split
> them on fault attempt.
> 
> Later we'll implement mmap() properly and this code path be used for
> fallback cases.
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> ---
>  mm/filemap.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index ed65af5..f7857ef 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1743,6 +1743,8 @@ retry_find:
>  			goto no_cached_page;
>  	}
>  
> +	if (PageTransCompound(page))
> +		split_huge_page(compound_trans_head(page));

Since PageTransCompound(page) returns true for transparent huge pages as
well as hugetlbfs pages, could this code split hugetlbfs pages on an
mmap() on to hugetlbfs pages? hugetlbfs pages are not supposed to be
split, right?

>  	if (!lock_page_or_retry(page, vma->vm_mm, vmf->flags)) {
>  		page_cache_release(page);
>  		return ret | VM_FAULT_RETRY;

--
Khalid

