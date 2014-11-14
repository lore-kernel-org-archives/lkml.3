Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965673AbaKNNfn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 08:35:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59334 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965640AbaKNNfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 08:35:16 -0500
Date: Fri, 14 Nov 2014 14:35:00 +0100
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        yoshikawa_takuya_b1@lab.ntt.co.jp, imammedo@redhat.com
Subject: Re: [PATCH 1/3] kvm: memslots: track id_to_index changes during the
 insertion sort
Message-ID: <20141114133500.GA10593@potion.brq.redhat.com>
References: <1415963522-5255-1-git-send-email-pbonzini@redhat.com>
 <1415963522-5255-2-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415963522-5255-2-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-11-14 12:12+0100, Paolo Bonzini:
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
> @@ -677,31 +677,30 @@ static int kvm_create_dirty_bitmap(struct kvm_memory_slot *memslot)
>  static void insert_memslot(struct kvm_memslots *slots,
>  			   struct kvm_memory_slot *new)
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
> -		} else if (i > 0 && new->npages > mslots[i - 1].npages) {
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
  (^^^^ whitespace error)
> +				mslots[i] = mslots[i + 1];
> +				slots->id_to_index[mslots[i].id] = i;
> +				i++;
> +			} else if (i > 0 &&
> +				   new->npages > mslots[i - 1].npages) {
> +				mslots[i] = mslots[i - 1];
> +				slots->id_to_index[mslots[i].id] = i;
> +				i--;
> +			} else
> +				break;

We are replacing in a sorted array, so the the direction of our
traversal doesn't change, (and we could lose one tab level here,)

	if (new->npages < mslots[i].npages) {
		while (i < (KVM_MEM_SLOTS_NUM - 1) &&
		       new->npages < mslots[i + 1].npages) {
			mslots[i] = mslots[i + 1];
			slots->id_to_index[mslots[i].id] = i;
			i++;
		}
	else if (new->npages > mslots[i].npages)
		while (i > 0 &&
		       new->npages > mslots[i - 1].npages) {
			mslots[i] = mslots[i - 1];
			slots->id_to_index[mslots[i].id] = i;
			i--;
		}

(I guess you don't want me to abstract these two loops further :)

If the probability of slots with same npages was high, we could also
move just the last one from each group, but I think that the current
algorithm is already faster than we need.

(We'll have to change it into an interval tree, or something, if the
 number of slots rises anyway.)
