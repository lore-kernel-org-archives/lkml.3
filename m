Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986AbaBJXaf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 18:30:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59792 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbaBJXae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 18:30:34 -0500
Date: Mon, 10 Feb 2014 15:30:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Luiz Capitulino <lcapitulino@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, mtosatti@redhat.com,
        mgorman@suse.de, aarcange@redhat.com, andi@firstfloor.org,
        riel@redhat.com
Subject: Re: [PATCH 4/4] hugetlb: hugepagesnid=: add 1G huge page support
Message-Id: <20140210153032.ac9325938264a3894dc83f8b@linux-foundation.org>
In-Reply-To: <1392053268-29239-5-git-send-email-lcapitulino@redhat.com>
References: <1392053268-29239-1-git-send-email-lcapitulino@redhat.com>
	<1392053268-29239-5-git-send-email-lcapitulino@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Feb 2014 12:27:48 -0500 Luiz Capitulino <lcapitulino@redhat.com> wrote:

> 
> ...
>
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -2051,6 +2051,29 @@ void __init hugetlb_add_hstate(unsigned order)
>  	parsed_hstate = h;
>  }
>  
> +static void __init hugetlb_hstate_alloc_pages_nid(struct hstate *h,
> +						int nid,
> +						unsigned long nr_pages)
> +{
> +	struct huge_bootmem_page *m;
> +	unsigned long i;
> +	void *addr;
> +
> +	for (i = 0; i < nr_pages; i++) {
> +		addr = memblock_virt_alloc_nid_nopanic(
> +				huge_page_size(h), huge_page_size(h),
> +				0, BOOTMEM_ALLOC_ACCESSIBLE, nid);
> +		if (!addr)
> +			break;
> +		m = addr;
> +		BUG_ON((unsigned long)virt_to_phys(m) & (huge_page_size(h) - 1));

IS_ALIGNED()?

> +		list_add(&m->list, &huge_boot_pages);
> +		m->hstate = h;
> +	}
> +
> +	h->max_huge_pages += i;
> +}
> +
>  void __init hugetlb_add_nrpages_nid(unsigned order, unsigned long nid,
>  				unsigned long nr_pages)
>  {

Please cc Yinghai Lu <yinghai@kernel.org> on these patches - he
understands memblock well and is a strong reviewer.

