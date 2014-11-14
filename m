Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890AbaKNOVv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 09:21:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754511AbaKNOVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 09:21:49 -0500
Date: Fri, 14 Nov 2014 15:21:43 +0100
From: Igor Mammedov <imammedo@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        yoshikawa_takuya_b1@lab.ntt.co.jp
Subject: Re: [PATCH 2/3] kvm: commonize allocation of the new memory slots
Message-ID: <20141114152143.623d62f5@igors-macbook-pro.local>
In-Reply-To: <1415963522-5255-3-git-send-email-pbonzini@redhat.com>
References: <1415963522-5255-1-git-send-email-pbonzini@redhat.com>
	<1415963522-5255-3-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2014 12:12:01 +0100
Paolo Bonzini <pbonzini@redhat.com> wrote:

> The two kmemdup invocations can be unified.  I find that the new
> placement of the comment makes it easier to see what happens.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  virt/kvm/kvm_main.c | 28 +++++++++++-----------------
>  1 file changed, 11 insertions(+), 17 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index c8ff99cc0ccb..7bfc842b96d7 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -865,11 +865,12 @@ int __kvm_set_memory_region(struct kvm *kvm,
>  			goto out_free;
>  	}
>  
> +	slots = kmemdup(kvm->memslots, sizeof(struct kvm_memslots),
> +			GFP_KERNEL);
> +	if (!slots)
> +		goto out_free;
> +
>  	if ((change == KVM_MR_DELETE) || (change == KVM_MR_MOVE)) {
> -		slots = kmemdup(kvm->memslots, sizeof(struct
> kvm_memslots),
> -				GFP_KERNEL);
> -		if (!slots)
> -			goto out_free;
>  		slot = id_to_memslot(slots, mem->slot);
>  		slot->flags |= KVM_MEMSLOT_INVALID;
>  
> @@ -885,6 +886,12 @@ int __kvm_set_memory_region(struct kvm *kvm,
>  		 * 	- kvm_is_visible_gfn (mmu_check_roots)
>  		 */
>  		kvm_arch_flush_shadow_memslot(kvm, slot);
> +
> +		/*
> +		 * We can re-use the old_memslots from above, the
> only difference
> +		 * from the currently installed memslots is the
> invalid flag.  This
> +		 * will get overwritten by update_memslots anyway.
> +		 */
>  		slots = old_memslots;
>  	}
>  
> @@ -892,19 +899,6 @@ int __kvm_set_memory_region(struct kvm *kvm,
>  	if (r)
>  		goto out_slots;
>  
> -	r = -ENOMEM;
> -	/*
> -	 * We can re-use the old_memslots from above, the only
> difference
> -	 * from the currently installed memslots is the invalid
> flag.  This
> -	 * will get overwritten by update_memslots anyway.
> -	 */
> -	if (!slots) {
> -		slots = kmemdup(kvm->memslots, sizeof(struct
> kvm_memslots),
> -				GFP_KERNEL);
> -		if (!slots)
> -			goto out_free;
> -	}
> -
>  	/* actual memory is freed via old in kvm_free_physmem_slot
> below */ if (change == KVM_MR_DELETE) {
>  		new.dirty_bitmap = NULL;

Reviewed-by: Igor Mammedov <imammedo@redhat.com>
