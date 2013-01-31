Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab3AaTeU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 14:34:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39223 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945Ab3AaTeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 14:34:17 -0500
Date: Thu, 31 Jan 2013 11:34:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>, Tony Luck <tony.luck@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HWPOISON: fix wrong num_poisoned_pages in handling
 memory error on thp
Message-Id: <20130131113416.963b5f07.akpm@linux-foundation.org>
In-Reply-To: <1359645958-9127-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1359645958-9127-1-git-send-email-n-horiguchi@ah.jp.nec.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2013 10:25:58 -0500
Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:

> num_poisoned_pages counts up the number of pages isolated by memory errors.
> But for thp, only one subpage is isolated because memory error handler
> splits it, so it's wrong to add (1 << compound_trans_order).
> 
> ...
>
> --- mmotm-2013-01-23-17-04.orig/mm/memory-failure.c
> +++ mmotm-2013-01-23-17-04/mm/memory-failure.c
> @@ -1039,7 +1039,14 @@ int memory_failure(unsigned long pfn, int trapno, int flags)
>  		return 0;
>  	}
>  
> -	nr_pages = 1 << compound_trans_order(hpage);
> +	/*
> +	 * If a thp is hit by a memory failure, it's supposed to be split.
> +	 * So we should add only one to num_poisoned_pages for that case.
> +	 */
> +	if (PageHuge(p))

/*
 * PageHuge() only returns true for hugetlbfs pages, but not for normal or
 * transparent huge pages.  See the PageTransHuge() documentation for more
 * details.
 */
int PageHuge(struct page *page)
{


> +		nr_pages = 1 << compound_trans_order(hpage);
> +	else /* normal page or thp */
> +		nr_pages = 1;
>  	atomic_long_add(nr_pages, &num_poisoned_pages);
>  
>  	/*

