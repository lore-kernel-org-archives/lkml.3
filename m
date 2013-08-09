Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966949Ab3HIKaf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 06:30:35 -0400
Received: from smtp.citrix.com ([66.165.176.89]:15163 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966467Ab3HIKae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 06:30:34 -0400
X-IronPort-AV: E=Sophos;i="4.89,845,1367971200"; 
   d="scan'208";a="42837718"
Message-ID: <5204C4C6.4060605@citrix.com>
Date: Fri, 9 Aug 2013 11:30:30 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Andres Lagar-Cavilla <andreslc@gridcentric.ca>
CC: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xen.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andres Lagar-Cavilla <andres@lagarcavilla.org>,
        <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH] Xen: Fix retry calls into PRIVCMD_MMAPBATCH*.
References: <1375367170-13151-1-git-send-email-andreslc@gridcentric.ca>
In-Reply-To: <1375367170-13151-1-git-send-email-andreslc@gridcentric.ca>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/13 15:26, Andres Lagar-Cavilla wrote:
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
> 
> Signed-off-by: Andres Lagar-Cavilla <andres@lagarcavilla.org>
> ---
>  drivers/xen/privcmd.c |   41 +++++++++++++++++++++++++++++++++++------
>  1 files changed, 35 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/xen/privcmd.c b/drivers/xen/privcmd.c
> index f8e5dd7..6ebdf98 100644
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
> @@ -422,14 +425,15 @@ static long privcmd_ioctl_mmap_batch(void __user *udata, int version)
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

This change to the range checks allows the user to partially populate
the VMA on the first call which will result in too few pages being
allocated in the auto_translated_physmap case.

Can you do the following behaviour instead?

On the first call, require the user to try to populate fully the VMA.

On subsequent calls, allow the user to specify a subset of pages
(sub-range) provided all the pages in the subset are not populated.

David
