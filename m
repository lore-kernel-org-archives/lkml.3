Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757242Ab3HLP6X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 11:58:23 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:34286 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090Ab3HLP6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 11:58:21 -0400
X-IronPort-AV: E=Sophos;i="4.89,863,1367971200"; 
   d="scan'208";a="41400220"
Message-ID: <5209061A.4030304@citrix.com>
Date: Mon, 12 Aug 2013 16:58:18 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Andres Lagar-Cavilla <andreslc@gridcentric.ca>
CC: <linux-kernel@vger.kernel.orgg>, <xen-devel@lists.xen.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>,
        Andres Lagar-Cavilla <andres@lagarcavilla.org>,
        <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH] Xen: Fix retry calls into PRIVCMD_MMAPBATCH*.
References: <1376057488-1008-1-git-send-email-andreslc@gridcentric.ca>
In-Reply-To: <1376057488-1008-1-git-send-email-andreslc@gridcentric.ca>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/13 15:11, Andres Lagar-Cavilla wrote:
> From: Andres Lagar-Cavilla <andres@lagarcavilla.org>
> 
> When a foreign mapper attempts to map guest frames that are paged out,
> the mapper receives an ENOENT response and will have to try again
> while a helper process pages the target frame back in.
> 
> Gating checks on PRIVCMD_MMAPBATCH* ioctl args were preventing retries
> of mapping calls.
> 
> V2: Fixed autotranslated physmap mode breakage introduced by V1.
> V3: Enforce full range mapping for first ioctl call on a given VMA.
> 
> Signed-off-by: Andres Lagar-Cavilla <andres@lagarcavilla.org>
> ---
>  drivers/xen/privcmd.c |   58 +++++++++++++++++++++++++++++++++++++++---------
>  1 files changed, 47 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/xen/privcmd.c b/drivers/xen/privcmd.c
> index f8e5dd7..938e6e6 100644
> --- a/drivers/xen/privcmd.c
> +++ b/drivers/xen/privcmd.c
> @@ -43,9 +43,12 @@ MODULE_LICENSE("GPL");
>  
>  #define PRIV_VMA_LOCKED ((void *)1)
>  
> -#ifndef HAVE_ARCH_PRIVCMD_MMAP
>  static int privcmd_enforce_singleshot_mapping(struct vm_area_struct *vma);
> -#endif
> +
> +static int privcmd_enforce_singleshot_mapping_granular(
> +               struct vm_area_struct *vma,
> +               unsigned long addr,
> +               unsigned long nr_pages);
>  
>  static long privcmd_ioctl_hypercall(void __user *udata)
>  {
> @@ -422,19 +425,26 @@ static long privcmd_ioctl_mmap_batch(void __user *udata, int version)
>  	vma = find_vma(mm, m.addr);
>  	if (!vma ||
>  	    vma->vm_ops != &privcmd_vm_ops ||
> -	    (m.addr != vma->vm_start) ||
> -	    ((m.addr + (nr_pages << PAGE_SHIFT)) != vma->vm_end) ||
> -	    !privcmd_enforce_singleshot_mapping(vma)) {
> +	    (m.addr < vma->vm_start) ||
> +	    ((m.addr + (nr_pages << PAGE_SHIFT)) > vma->vm_end) ||
> +	    !privcmd_enforce_singleshot_mapping_granular(vma, m.addr, nr_pages)) {
>  		up_write(&mm->mmap_sem);
>  		ret = -EINVAL;
>  		goto out;

I think this unnecessarily calls
privcmd_enforce_singleshot_mapping_granular() on the first call.

If you change the tests to the following, does it work for you?

/* Suitable VMA? */
if (!vma || vma->vm_ops != &privcmd_vm_ops)
	// error

if (!privcmd_enforce_singleshot_mapping(..)) {
        /* Already populated into this VMA once, are we populating a
           subset that is not yet populated? */
	if (is_subset_of_vma(vma, m,addr, nr_pages)
            && privcmd_enforce_single_shot_mapping_granular())
        	// ok
	else
		// error
} else {
	/* Nothing populated in this VMA, must try to fully populate
	   it. */
	if (is_all_of_vma(vma, m.addr, nr_pages))
		// ok
	else
		// error
}


Thanks.

David
