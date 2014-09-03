Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849AbaICIez (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 04:34:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32137 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755456AbaICIew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 04:34:52 -0400
Message-ID: <5406D293.3060404@redhat.com>
Date: Wed, 03 Sep 2014 10:34:27 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Laurent Dufour <ldufour@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org
CC: kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Paul Mackerras <paulus@samba.org>, Alexander Graf <agraf@suse.de>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] powerpc/kvm/cma: Fix panic introduces by signed shift
 operation
References: <1409674381-29465-1-git-send-email-ldufour@linux.vnet.ibm.com>
In-Reply-To: <1409674381-29465-1-git-send-email-ldufour@linux.vnet.ibm.com>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 02/09/2014 18:13, Laurent Dufour ha scritto:
> fc95ca7284bc54953165cba76c3228bd2cdb9591 introduces a memset in
> kvmppc_alloc_hpt since the general CMA doesn't clear the memory it
> allocates.
> 
> However, the size argument passed to memset is computed from a signed value
> and its signed bit is extended by the cast the compiler is doing. This lead
> to extremely large size value when dealing with order value >= 31, and
> almost all the memory following the allocated space is cleaned. As a
> consequence, the system is panicing and may even fail spawning the kdump
> kernel.
> 
> This fix makes use of an unsigned value for the memset's size argument to
> avoid sign extension. Among this fix, another shift operation which may
> lead to signed extended value too is also fixed.
> 
> Cc: Alexey Kardashevskiy <aik@ozlabs.ru>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Alexander Graf <agraf@suse.de>
> Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Signed-off-by: Laurent Dufour <ldufour@linux.vnet.ibm.com>
> ---
>  arch/powerpc/kvm/book3s_64_mmu_hv.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
> index 72c20bb16d26..79294c4c5015 100644
> --- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
> +++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
> @@ -62,10 +62,10 @@ long kvmppc_alloc_hpt(struct kvm *kvm, u32 *htab_orderp)
>  	}
>  
>  	kvm->arch.hpt_cma_alloc = 0;
> -	page = kvm_alloc_hpt(1 << (order - PAGE_SHIFT));
> +	page = kvm_alloc_hpt(1ul << (order - PAGE_SHIFT));
>  	if (page) {
>  		hpt = (unsigned long)pfn_to_kaddr(page_to_pfn(page));
> -		memset((void *)hpt, 0, (1 << order));
> +		memset((void *)hpt, 0, (1ul << order));
>  		kvm->arch.hpt_cma_alloc = 1;
>  	}
>  
> 

Thanks, applied to kvm/master.

Paolo
