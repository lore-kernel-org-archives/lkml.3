Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965659AbaKNNfS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 08:35:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50095 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965443AbaKNNfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 08:35:14 -0500
Date: Fri, 14 Nov 2014 14:34:55 +0100
From: Igor Mammedov <imammedo@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        yoshikawa_takuya_b1@lab.ntt.co.jp
Subject: Re: [PATCH 1/3] kvm: memslots: track id_to_index changes during the
 insertion sort
Message-ID: <20141114143455.452defa1@igors-macbook-pro.local>
In-Reply-To: <1415963522-5255-2-git-send-email-pbonzini@redhat.com>
References: <1415963522-5255-1-git-send-email-pbonzini@redhat.com>
	<1415963522-5255-2-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2014 12:12:00 +0100
Paolo Bonzini <pbonzini@redhat.com> wrote:

> This completes the optimization from the previous patch, by
> removing the KVM_MEM_SLOTS_NUM-iteration loop from insert_memslot.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  virt/kvm/kvm_main.c | 39 +++++++++++++++++++--------------------
>  1 file changed, 19 insertions(+), 20 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index c0c2202e6c4f..c8ff99cc0ccb 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -677,31 +677,30 @@ static int kvm_create_dirty_bitmap(struct
> kvm_memory_slot *memslot) static void insert_memslot(struct
> kvm_memslots *slots, struct kvm_memory_slot *new)
>  {
> -	int i = slots->id_to_index[new->id];
> -	struct kvm_memory_slot *old = id_to_memslot(slots, new->id);
> +	int id = new->id;
> +	int i = slots->id_to_index[id];
>  	struct kvm_memory_slot *mslots = slots->memslots;
>  
> -	if (new->npages == old->npages) {
> -		*old = *new;
> -		return;
> -	}
> -
> -	while (1) {
> -		if (i < (KVM_MEM_SLOTS_NUM - 1) &&
> -			new->npages < mslots[i + 1].npages) {
> -			mslots[i] = mslots[i + 1];
> -			i++;
> -		} else if (i > 0 && new->npages > mslots[i -
> 1].npages) {
> -			mslots[i] = mslots[i - 1];
> -			i--;
> -		} else {
> -			mslots[i] = *new;
> -			break;
> +	WARN_ON(mslots[i].id != id);
> +	if (new->npages != mslots[i].npages) {
> +		while (1) {
> +			if (i < (KVM_MEM_SLOTS_NUM - 1) &&
> +    			    new->npages < mslots[i + 1].npages) {
> +				mslots[i] = mslots[i + 1];
> +				slots->id_to_index[mslots[i].id] = i;
> +				i++;
> +			} else if (i > 0 &&
> +				   new->npages > mslots[i -
> 1].npages) {
> +				mslots[i] = mslots[i - 1];
> +				slots->id_to_index[mslots[i].id] = i;
> +				i--;
> +			} else
> +				break;
>  		}
>  	}
>  
> -	for (i = 0; i < KVM_MEM_SLOTS_NUM; i++)
> -		slots->id_to_index[slots->memslots[i].id] = i;
> +	mslots[i] = *new;
> +	slots->id_to_index[mslots[i].id] = i;
>  }
>  
>  static void update_memslots(struct kvm_memslots *slots,

Reviewed-by: Igor Mammedov <imammedo@redhat.com>
