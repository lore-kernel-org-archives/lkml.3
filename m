Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbaHML4e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 07:56:34 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:46981 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbaHML4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 07:56:32 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Alexander Graf <agraf@suse.de>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Michael Ellerman <mpe@ellerman.id.au>, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, stable@vger.kernel.org
Subject: Re: [PATCH] PC, KVM, CMA: Fix regression caused by wrong get_order() use
In-Reply-To: <1407903739-7064-1-git-send-email-aik@ozlabs.ru>
References: <1407903739-7064-1-git-send-email-aik@ozlabs.ru>
User-Agent: Notmuch/0.18.1 (http://notmuchmail.org) Emacs/24.3.91.1 (x86_64-unknown-linux-gnu)
Date: Wed, 13 Aug 2014 17:26:13 +0530
Message-ID: <87mwb861sy.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081311-3568-0000-0000-00000011DBDF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Kardashevskiy <aik@ozlabs.ru> writes:

> fc95ca7284bc54953165cba76c3228bd2cdb9591 claims that there is no
> functional change but this is not true as it calls get_order() (which
> takes bytes) where it should have called ilog2() and the kernel stops
> on VM_BUG_ON().
>
> This replaces get_order() with ilog2().

Should we round it up ? ie, ilog2(kvm_rma_pages - 1) + 1 ?

>
> Suggested-by: Paul Mackerras <paulus@samba.org>
> Cc: Alexander Graf <agraf@suse.de>
> Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: <stable@vger.kernel.org>

Why stable ? We merged it this merge window.

> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> ---
>  arch/powerpc/kvm/book3s_hv_builtin.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/arch/powerpc/kvm/book3s_hv_builtin.c b/arch/powerpc/kvm/book3s_hv_builtin.c
> index 329d7fd..bfe9f01 100644
> --- a/arch/powerpc/kvm/book3s_hv_builtin.c
> +++ b/arch/powerpc/kvm/book3s_hv_builtin.c
> @@ -101,7 +101,7 @@ struct kvm_rma_info *kvm_alloc_rma()
>  	ri = kmalloc(sizeof(struct kvm_rma_info), GFP_KERNEL);
>  	if (!ri)
>  		return NULL;
> -	page = cma_alloc(kvm_cma, kvm_rma_pages, get_order(kvm_rma_pages));
> +	page = cma_alloc(kvm_cma, kvm_rma_pages, ilog2(kvm_rma_pages));
>  	if (!page)
>  		goto err_out;
>  	atomic_set(&ri->use_count, 1);
> @@ -135,12 +135,12 @@ struct page *kvm_alloc_hpt(unsigned long nr_pages)
>  {
>  	unsigned long align_pages = HPT_ALIGN_PAGES;
>
> -	VM_BUG_ON(get_order(nr_pages) < KVM_CMA_CHUNK_ORDER - PAGE_SHIFT);
> +	VM_BUG_ON(ilog2(nr_pages) < KVM_CMA_CHUNK_ORDER - PAGE_SHIFT);
>
>  	/* Old CPUs require HPT aligned on a multiple of its size */
>  	if (!cpu_has_feature(CPU_FTR_ARCH_206))
>  		align_pages = nr_pages;
> -	return cma_alloc(kvm_cma, nr_pages, get_order(align_pages));
> +	return cma_alloc(kvm_cma, nr_pages, ilog2(align_pages));
>  }
>  EXPORT_SYMBOL_GPL(kvm_alloc_hpt);
>
> -- 
> 2.0.0

