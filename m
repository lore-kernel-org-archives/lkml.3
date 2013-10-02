Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab3JBOzE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 10:55:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:18622 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752416Ab3JBOzB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 10:55:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1019,1371106800"; 
   d="scan'208";a="410421163"
From: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
To: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        infinipath <infinipath@intel.com>, Roland Dreier <roland@kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [PATCH 23/26] ib: Convert qib_get_user_pages() to
 get_user_pages_unlocked()
Thread-Topic: [PATCH 23/26] ib: Convert qib_get_user_pages() to
 get_user_pages_unlocked()
Thread-Index: AQHOv3vIHe5gOhmSsEGBHPLZHDmcI5nhfF3w
Date: Wed, 2 Oct 2013 14:54:59 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC211AEF75@FMSMSX107.amr.corp.intel.com>
References: <1380724087-13927-1-git-send-email-jack@suse.cz>
 <1380724087-13927-24-git-send-email-jack@suse.cz>
In-Reply-To: <1380724087-13927-24-git-send-email-jack@suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.200.108]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks!!

I would like to test these two patches and also do the stable work for the deadlock as well.  Do you have these patches in a repo somewhere to save me a bit of work?

We had been working on an internal version of the deadlock portion of this patch that uses get_user_pages_fast() vs. the new get_user_pages_unlocked().

The risk of GUP fast is the loss of the "force" arg on GUP fast, which I don't see as significant give our use case.

Some nits on the subject and commit message:
1. use IB/qib, IB/ipath vs. ib
2. use the correct ipath vs. qib in the commit message text

Mike

> -----Original Message-----
> From: Jan Kara [mailto:jack@suse.cz]
> Sent: Wednesday, October 02, 2013 10:28 AM
> To: LKML
> Cc: linux-mm@kvack.org; Jan Kara; infinipath; Roland Dreier; linux-
> rdma@vger.kernel.org
> Subject: [PATCH 23/26] ib: Convert qib_get_user_pages() to
> get_user_pages_unlocked()
> 
> Convert qib_get_user_pages() to use get_user_pages_unlocked().  This
> shortens the section where we hold mmap_sem for writing and also removes
> the knowledge about get_user_pages() locking from ipath driver. We also fix
> a bug in testing pinned number of pages when changing the code.
> 
> CC: Mike Marciniszyn <infinipath@intel.com>
> CC: Roland Dreier <roland@kernel.org>
> CC: linux-rdma@vger.kernel.org
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  drivers/infiniband/hw/qib/qib_user_pages.c | 62 +++++++++++++----------------
> -
>  1 file changed, 26 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/qib/qib_user_pages.c
> b/drivers/infiniband/hw/qib/qib_user_pages.c
> index 2bc1d2b96298..57ce83c2d1d9 100644
> --- a/drivers/infiniband/hw/qib/qib_user_pages.c
> +++ b/drivers/infiniband/hw/qib/qib_user_pages.c
> @@ -48,39 +48,55 @@ static void __qib_release_user_pages(struct page
> **p, size_t num_pages,
>  	}
>  }
> 
> -/*
> - * Call with current->mm->mmap_sem held.
> +/**
> + * qib_get_user_pages - lock user pages into memory
> + * @start_page: the start page
> + * @num_pages: the number of pages
> + * @p: the output page structures
> + *
> + * This function takes a given start page (page aligned user virtual
> + * address) and pins it and the following specified number of pages.
> +For
> + * now, num_pages is always 1, but that will probably change at some
> +point
> + * (because caller is doing expected sends on a single virtually
> +contiguous
> + * buffer, so we can do all pages at once).
>   */
> -static int __qib_get_user_pages(unsigned long start_page, size_t
> num_pages,
> -				struct page **p, struct vm_area_struct
> **vma)
> +int qib_get_user_pages(unsigned long start_page, size_t num_pages,
> +		       struct page **p)
>  {
>  	unsigned long lock_limit;
>  	size_t got;
>  	int ret;
> +	struct mm_struct *mm = current->mm;
> 
> +	down_write(&mm->mmap_sem);
>  	lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
> 
> -	if (num_pages > lock_limit && !capable(CAP_IPC_LOCK)) {
> +	if (mm->pinned_vm + num_pages > lock_limit &&
> !capable(CAP_IPC_LOCK)) {
> +		up_write(&mm->mmap_sem);
>  		ret = -ENOMEM;
>  		goto bail;
>  	}
> +	mm->pinned_vm += num_pages;
> +	up_write(&mm->mmap_sem);
> 
>  	for (got = 0; got < num_pages; got += ret) {
> -		ret = get_user_pages(current, current->mm,
> -				     start_page + got * PAGE_SIZE,
> -				     num_pages - got, 1, 1,
> -				     p + got, vma);
> +		ret = get_user_pages_unlocked(current, mm,
> +					      start_page + got * PAGE_SIZE,
> +					      num_pages - got, 1, 1,
> +					      p + got);
>  		if (ret < 0)
>  			goto bail_release;
>  	}
> 
> -	current->mm->pinned_vm += num_pages;
> 
>  	ret = 0;
>  	goto bail;
> 
>  bail_release:
>  	__qib_release_user_pages(p, got, 0);
> +	down_write(&mm->mmap_sem);
> +	mm->pinned_vm -= num_pages;
> +	up_write(&mm->mmap_sem);
>  bail:
>  	return ret;
>  }
> @@ -117,32 +133,6 @@ dma_addr_t qib_map_page(struct pci_dev *hwdev,
> struct page *page,
>  	return phys;
>  }
> 
> -/**
> - * qib_get_user_pages - lock user pages into memory
> - * @start_page: the start page
> - * @num_pages: the number of pages
> - * @p: the output page structures
> - *
> - * This function takes a given start page (page aligned user virtual
> - * address) and pins it and the following specified number of pages.  For
> - * now, num_pages is always 1, but that will probably change at some point
> - * (because caller is doing expected sends on a single virtually contiguous
> - * buffer, so we can do all pages at once).
> - */
> -int qib_get_user_pages(unsigned long start_page, size_t num_pages,
> -		       struct page **p)
> -{
> -	int ret;
> -
> -	down_write(&current->mm->mmap_sem);
> -
> -	ret = __qib_get_user_pages(start_page, num_pages, p, NULL);
> -
> -	up_write(&current->mm->mmap_sem);
> -
> -	return ret;
> -}
> -
>  void qib_release_user_pages(struct page **p, size_t num_pages)  {
>  	if (current->mm) /* during close after signal, mm can be NULL */
> --
> 1.8.1.4

