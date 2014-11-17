Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337AbaKQBtd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 20:49:33 -0500
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:59443 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbaKQBtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 20:49:31 -0500
Message-ID: <54695438.2060408@lab.ntt.co.jp>
Date: Mon, 17 Nov 2014 10:49:44 +0900
From: Takuya Yoshikawa <yoshikawa_takuya_b1@lab.ntt.co.jp>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
CC: imammedo@redhat.com
Subject: Re: [PATCH 2/3] kvm: commonize allocation of the new memory slots
References: <1415963522-5255-1-git-send-email-pbonzini@redhat.com> <1415963522-5255-3-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1415963522-5255-3-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/14 20:12, Paolo Bonzini wrote:
> The two kmemdup invocations can be unified.  I find that the new
> placement of the comment makes it easier to see what happens.

A lot easier to follow the logic.

Reviewed-by: Takuya Yoshikawa <yoshikawa_takuya_b1@lab.ntt.co.jp>

> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   virt/kvm/kvm_main.c | 28 +++++++++++-----------------
>   1 file changed, 11 insertions(+), 17 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index c8ff99cc0ccb..7bfc842b96d7 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -865,11 +865,12 @@ int __kvm_set_memory_region(struct kvm *kvm,
>   			goto out_free;
>   	}
>   
> +	slots = kmemdup(kvm->memslots, sizeof(struct kvm_memslots),
> +			GFP_KERNEL);
> +	if (!slots)
> +		goto out_free;
> +
>   	if ((change == KVM_MR_DELETE) || (change == KVM_MR_MOVE)) {
> -		slots = kmemdup(kvm->memslots, sizeof(struct kvm_memslots),
> -				GFP_KERNEL);
> -		if (!slots)
> -			goto out_free;
>   		slot = id_to_memslot(slots, mem->slot);
>   		slot->flags |= KVM_MEMSLOT_INVALID;
>   
> @@ -885,6 +886,12 @@ int __kvm_set_memory_region(struct kvm *kvm,
>   		 * 	- kvm_is_visible_gfn (mmu_check_roots)
>   		 */
>   		kvm_arch_flush_shadow_memslot(kvm, slot);
> +
> +		/*
> +		 * We can re-use the old_memslots from above, the only difference
> +		 * from the currently installed memslots is the invalid flag.  This
> +		 * will get overwritten by update_memslots anyway.
> +		 */
>   		slots = old_memslots;
>   	}
>   
> @@ -892,19 +899,6 @@ int __kvm_set_memory_region(struct kvm *kvm,
>   	if (r)
>   		goto out_slots;
>   
> -	r = -ENOMEM;
> -	/*
> -	 * We can re-use the old_memslots from above, the only difference
> -	 * from the currently installed memslots is the invalid flag.  This
> -	 * will get overwritten by update_memslots anyway.
> -	 */
> -	if (!slots) {
> -		slots = kmemdup(kvm->memslots, sizeof(struct kvm_memslots),
> -				GFP_KERNEL);
> -		if (!slots)
> -			goto out_free;
> -	}
> -
>   	/* actual memory is freed via old in kvm_free_physmem_slot below */
>   	if (change == KVM_MR_DELETE) {
>   		new.dirty_bitmap = NULL;
> 


