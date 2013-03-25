Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757019Ab3CYKc7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 06:32:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42697 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756991Ab3CYKc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 06:32:58 -0400
Date: Mon, 25 Mar 2013 11:31:05 +0100
From: Anton Arapov <anton@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        adrian.m.negreanu@intel.com, Torsten.Polle@gmx.de
Subject: Re: [PATCH 2/5] uprobes: Change __copy_insn() to use copy_from_page()
Message-ID: <20130325103105.GC8163@bandura.brq.redhat.com>
References: <20130324182040.GA13078@redhat.com>
 <20130324182115.GA13308@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130324182115.GA13308@redhat.com>
X-PGP-Key: http://people.redhat.com/aarapov/gpg
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 24, 2013 at 07:21:15PM +0100, Oleg Nesterov wrote:
> Change __copy_insn() to use copy_from_page() and simplify the code.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
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
Acked-by: Anton Arapov <anton@redhat.com>
