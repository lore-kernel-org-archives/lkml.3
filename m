Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932795Ab3CZMGA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 08:06:00 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:50143 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932577Ab3CZMF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 08:05:57 -0400
Date: Tue, 26 Mar 2013 17:30:21 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Anton Arapov <anton@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Josh Stone <jistone@redhat.com>, Frank Eigler <fche@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        adrian.m.negreanu@intel.com, Torsten.Polle@gmx.de
Subject: Re: [PATCH 2/5] uprobes: Change __copy_insn() to use
 copy_from_page()
Message-ID: <20130326120021.GD639@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20130324182040.GA13078@redhat.com>
 <20130324182115.GA13308@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20130324182115.GA13308@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032612-3620-0000-0000-000001C5CAA6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2013-03-24 19:21:15]:

> Change __copy_insn() to use copy_from_page() and simplify the code.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

> ---
>  kernel/events/uprobes.c |   13 ++-----------
>  1 files changed, 2 insertions(+), 11 deletions(-)
> 
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index d6891cb..0a759c6 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -477,30 +477,21 @@ __copy_insn(struct address_space *mapping, struct file *filp, char *insn,
>  			unsigned long nbytes, loff_t offset)
>  {
>  	struct page *page;
> -	void *vaddr;
> -	unsigned long off;
> -	pgoff_t idx;
> 
>  	if (!filp)
>  		return -EINVAL;
> 
>  	if (!mapping->a_ops->readpage)
>  		return -EIO;
> -
> -	idx = offset >> PAGE_CACHE_SHIFT;
> -	off = offset & ~PAGE_MASK;
> -
>  	/*
>  	 * Ensure that the page that has the original instruction is
>  	 * populated and in page-cache.
>  	 */
> -	page = read_mapping_page(mapping, idx, filp);
> +	page = read_mapping_page(mapping, offset >> PAGE_CACHE_SHIFT, filp);
>  	if (IS_ERR(page))
>  		return PTR_ERR(page);
> 
> -	vaddr = kmap_atomic(page);
> -	memcpy(insn, vaddr + off, nbytes);
> -	kunmap_atomic(vaddr);
> +	copy_from_page(page, offset, insn, nbytes);
>  	page_cache_release(page);
> 
>  	return 0;
> -- 
> 1.5.5.1
> 

-- 
Thanks and Regards
Srikar Dronamraju

