Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107AbaKNOYf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 09:24:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58096 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755057AbaKNOYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 09:24:33 -0500
Date: Fri, 14 Nov 2014 15:24:26 +0100
From: Igor Mammedov <imammedo@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        yoshikawa_takuya_b1@lab.ntt.co.jp
Subject: Re: [PATCH 3/3] kvm: simplify update_memslots invocation
Message-ID: <20141114152426.397aa1d8@igors-macbook-pro.local>
In-Reply-To: <1415963522-5255-4-git-send-email-pbonzini@redhat.com>
References: <1415963522-5255-1-git-send-email-pbonzini@redhat.com>
	<1415963522-5255-4-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2014 12:12:02 +0100
Paolo Bonzini <pbonzini@redhat.com> wrote:

> The update_memslots invocation is only needed in one case.  Make
> the code clearer by moving it to __kvm_set_memory_region, and
> removing the wrapper around insert_memslot.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  virt/kvm/kvm_main.c | 20 ++++++--------------
>  1 file changed, 6 insertions(+), 14 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 7bfc842b96d7..a5ed3a9f7522 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -674,8 +674,8 @@ static int kvm_create_dirty_bitmap(struct
> kvm_memory_slot *memslot)
>   * takes advantage of having initially sorted array and
>   * known changed memslot position.
>   */
> -static void insert_memslot(struct kvm_memslots *slots,
> -			   struct kvm_memory_slot *new)
> +static void update_memslots(struct kvm_memslots *slots,
> +			    struct kvm_memory_slot *new)
>  {
>  	int id = new->id;
>  	int i = slots->id_to_index[id];
> @@ -703,14 +703,6 @@ static void insert_memslot(struct kvm_memslots
> *slots, slots->id_to_index[mslots[i].id] = i;
>  }
>  
> -static void update_memslots(struct kvm_memslots *slots,
> -			    struct kvm_memory_slot *new)
> -{
> -	if (new) {
> -		insert_memslot(slots, new);
> -	}
> -}
> -
>  static int check_memory_region_flags(struct
> kvm_userspace_memory_region *mem) {
>  	u32 valid_flags = KVM_MEM_LOG_DIRTY_PAGES;
> @@ -726,7 +718,7 @@ static int check_memory_region_flags(struct
> kvm_userspace_memory_region *mem) }
>  
>  static struct kvm_memslots *install_new_memslots(struct kvm *kvm,
> -		struct kvm_memslots *slots, struct kvm_memory_slot
> *new)
> +		struct kvm_memslots *slots)
>  {
>  	struct kvm_memslots *old_memslots = kvm->memslots;
>  
> @@ -737,7 +729,6 @@ static struct kvm_memslots
> *install_new_memslots(struct kvm *kvm,
> WARN_ON(old_memslots->generation & 1); slots->generation =
> old_memslots->generation + 1; 
> -	update_memslots(slots, new);
>  	rcu_assign_pointer(kvm->memslots, slots);
>  	synchronize_srcu_expedited(&kvm->srcu);
>  
> @@ -874,7 +865,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
>  		slot = id_to_memslot(slots, mem->slot);
>  		slot->flags |= KVM_MEMSLOT_INVALID;
>  
> -		old_memslots = install_new_memslots(kvm, slots,
> NULL);
> +		old_memslots = install_new_memslots(kvm, slots);
>  
>  		/* slot was deleted or moved, clear iommu mapping */
>  		kvm_iommu_unmap_pages(kvm, &old);
> @@ -905,7 +896,8 @@ int __kvm_set_memory_region(struct kvm *kvm,
>  		memset(&new.arch, 0, sizeof(new.arch));
>  	}
>  
> -	old_memslots = install_new_memslots(kvm, slots, &new);
> +	update_memslots(slots, &new);
> +	old_memslots = install_new_memslots(kvm, slots);
>  
>  	kvm_arch_commit_memory_region(kvm, mem, &old, change);
>  

Reviewed-by: Igor Mammedov <imammedo@redhat.com>
