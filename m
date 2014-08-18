Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293AbaHRVPj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 17:15:39 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:49440 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbaHRVPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 17:15:37 -0400
MIME-Version: 1.0
In-Reply-To: <A07DA8BD-8756-427D-9925-B8696E47C73A@gmail.com>
References: <1407999713-3726-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <53F20653.2030204@redhat.com> <9AD43423-2FF3-422D-A5AD-61CAE6339CCC@linux.vnet.ibm.com>
 <53F24A49.2010807@redhat.com> <A07DA8BD-8756-427D-9925-B8696E47C73A@gmail.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 18 Aug 2014 14:15:10 -0700
Message-ID: <CALzav=fNoXeStA6ETDW0tNqyXBxWN0i8N5P-Ht7jtwgS_r7qmw@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: fix cache stale memslot info with correct mmio
 generation number
To: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Avi Kivity <avi.kivity@gmail.com>, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 12:56 PM, Xiao Guangrong
<xiaoguangrong.eric@gmail.com> wrote:
> @@ -287,9 +293,15 @@ static bool set_mmio_spte(struct kvm *kvm, u64 *sptep, gfn_t gfn,
>
>  static bool check_mmio_spte(struct kvm *kvm, u64 spte)
>  {
> +       struct kvm_memslots *slots = kvm_memslots(kvm);
>         unsigned int kvm_gen, spte_gen;
>
> -       kvm_gen = kvm_current_mmio_generation(kvm);
> +       if (slots->updated)
> +               return false;
> +
> +       smp_rmb();
> +
> +       kvm_gen = __kvm_current_mmio_generation(slots);
>         spte_gen = get_mmio_spte_generation(spte);
>

What does this fix? Case 2 can still happen. (Case 2 is unavoidable unless we
block during memslot updates, which I don't think we should :).

>         trace_check_mmio_spte(spte, kvm_gen, spte_gen);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 4b6c01b..1d4e78f 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -96,7 +96,7 @@ static void hardware_disable_all(void);
>
>  static void kvm_io_bus_destroy(struct kvm_io_bus *bus);
>  static void update_memslots(struct kvm_memslots *slots,
> -                           struct kvm_memory_slot *new, u64 last_generation);
> +                           struct kvm_memory_slot *new);
>
>  static void kvm_release_pfn_dirty(pfn_t pfn);
>  static void mark_page_dirty_in_slot(struct kvm *kvm,
> @@ -685,8 +685,7 @@ static void sort_memslots(struct kvm_memslots *slots)
>  }
>
>  static void update_memslots(struct kvm_memslots *slots,
> -                           struct kvm_memory_slot *new,
> -                           u64 last_generation)
> +                           struct kvm_memory_slot *new)
>  {
>         if (new) {
>                 int id = new->id;
> @@ -697,8 +696,6 @@ static void update_memslots(struct kvm_memslots *slots,
>                 if (new->npages != npages)
>                         sort_memslots(slots);
>         }
> -
> -       slots->generation = last_generation + 1;
>  }
>
>  static int check_memory_region_flags(struct kvm_userspace_memory_region *mem)
> @@ -720,10 +717,17 @@ static struct kvm_memslots *install_new_memslots(struct kvm *kvm,
>  {
>         struct kvm_memslots *old_memslots = kvm->memslots;
>
> -       update_memslots(slots, new, kvm->memslots->generation);
> +       /* ensure generation number is always increased. */
> +       slots->updated = true;
> +       slots->generation = old_memslots->generation;
> +       update_memslots(slots, new);
>         rcu_assign_pointer(kvm->memslots, slots);
>         synchronize_srcu_expedited(&kvm->srcu);
>
> +       slots->generation++;
> +       smp_wmb();
> +       slots->updated = false;
> +
>         kvm_arch_memslots_updated(kvm);
>
>         return old_memslots;
>

This is effectively the same as the first approach.

I just realized how simple Paolo's idea is. I think it can be a one line
patch (without comments):

[...]
        update_memslots(slots, new, kvm->memslots->generation);
        rcu_assign_pointer(kvm->memslots, slots);
        synchronize_srcu_expedited(&kvm->srcu);
+       slots->generation++;

        kvm_arch_memslots_updated(kvm);
[...]
