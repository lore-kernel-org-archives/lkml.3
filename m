Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965126AbaKNJ5S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 04:57:18 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:64565 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965061AbaKNJ5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 04:57:15 -0500
Message-ID: <5465D1F6.20205@redhat.com>
Date: Fri, 14 Nov 2014 10:57:10 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Igor Mammedov <imammedo@redhat.com>, linux-kernel@vger.kernel.org
CC: kvm@vger.kernel.org
Subject: Re: [PATCH v2] kvm: memslots: replace heap sort with insertion sort
References: <5464E336.7020402@redhat.com> <1415919613-24461-1-git-send-email-imammedo@redhat.com>
In-Reply-To: <1415919613-24461-1-git-send-email-imammedo@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 14/11/2014 00:00, Igor Mammedov wrote:
> memslots is a sorted array, when slot changes in it
> with current heapsort it would take O(n log n) time
> to update array, while using insertion sort like
> algorithm on array with 1 item out of order will
> take only O(n) time.
> 
> Replace current heapsort with custom sort that
> takes advantage of memslots usage pattern and known
> position of changed slot.
> 
> performance change of 128 memslots insersions with
> gradually increasing size (the worst case):
>       heap sort   custom sort
> max:  249747      2500 cycles
> with custom sort alg taking ~98% less then original
> update time.
> 
> Signed-off-by: Igor Mammedov <imammedo@redhat.com>
> ---
> v2:
>   - replace swap with slot shift, improves result 2x
>   - reprofile original/swap based and swapless 15 times
>       discarding spikes swap based takes ~5900 cycles max
>       and swapless ~2500 cycles.
> ---
>  virt/kvm/kvm_main.c | 54 ++++++++++++++++++++++++++---------------------------
>  1 file changed, 26 insertions(+), 28 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 25ffac9..49f896a 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -668,31 +668,35 @@ static int kvm_create_dirty_bitmap(struct kvm_memory_slot *memslot)
>  	return 0;
>  }
>  
> -static int cmp_memslot(const void *slot1, const void *slot2)
> -{
> -	struct kvm_memory_slot *s1, *s2;
> -
> -	s1 = (struct kvm_memory_slot *)slot1;
> -	s2 = (struct kvm_memory_slot *)slot2;
> -
> -	if (s1->npages < s2->npages)
> -		return 1;
> -	if (s1->npages > s2->npages)
> -		return -1;
> -
> -	return 0;
> -}
> -
>  /*
> - * Sort the memslots base on its size, so the larger slots
> - * will get better fit.
> + * Insert memslot and re-sort memslots based on their size,
> + * so the larger slots will get better fit. Sorting algorithm
> + * takes advantage of having initially sorted array and
> + * known changed memslot position.
>   */
> -static void sort_memslots(struct kvm_memslots *slots)
> +static void insert_memslot(struct kvm_memslots *slots,
> +			   struct kvm_memory_slot *new)
>  {
> -	int i;
> +	int i = slots->id_to_index[new->id];
> +	struct kvm_memory_slot *old = id_to_memslot(slots, new->id);
> +	struct kvm_memory_slot *mslots = slots->memslots;
> +

It is important to leave the "*old = *new" assignment here, see the 
comment in __kvm_set_memory_region:

        /*
         * We can re-use the old_memslots from above, the only difference
         * from the currently installed memslots is the invalid flag.  This
         * will get overwritten by update_memslots anyway.
         */

This small problem was already present in v1, but I didn't notice it
yesterday.  With the new code, we can add it inside this if:

> +	if (new->npages == old->npages)
> +		return;

Do you agree? (No need to send v3).

Paolo

> -	sort(slots->memslots, KVM_MEM_SLOTS_NUM,
> -	      sizeof(struct kvm_memory_slot), cmp_memslot, NULL);
> +	while (1) {
> +		if (i < (KVM_MEM_SLOTS_NUM - 1) &&
> +			new->npages < mslots[i + 1].npages) {
> +			mslots[i] = mslots[i + 1];
> +			i++;
> +		} else if (i > 0 && new->npages > mslots[i - 1].npages) {
> +			mslots[i] = mslots[i - 1];
> +			i--;
> +		} else {
> +			mslots[i] = *new;
> +			break;
> +		}
> +	}
>  
>  	for (i = 0; i < KVM_MEM_SLOTS_NUM; i++)
>  		slots->id_to_index[slots->memslots[i].id] = i;
> @@ -702,13 +706,7 @@ static void update_memslots(struct kvm_memslots *slots,
>  			    struct kvm_memory_slot *new)
>  {
>  	if (new) {
> -		int id = new->id;
> -		struct kvm_memory_slot *old = id_to_memslot(slots, id);
> -		unsigned long npages = old->npages;
> -
> -		*old = *new;
> -		if (new->npages != npages)
> -			sort_memslots(slots);
> +		insert_memslot(slots, new);
>  	}
>  }
>  
> 
