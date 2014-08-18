Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026AbaHRT4Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 15:56:24 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:60834 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbaHRT4W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 15:56:22 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH 1/2] KVM: fix cache stale memslot info with correct mmio generation number
From: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
In-Reply-To: <53F24A49.2010807@redhat.com>
Date: Tue, 19 Aug 2014 03:56:11 +0800
Cc: gleb@kernel.org, avi.kivity@gmail.com, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org, David Matlack <dmatlack@google.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <A07DA8BD-8756-427D-9925-B8696E47C73A@gmail.com>
References: <1407999713-3726-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <53F20653.2030204@redhat.com> <9AD43423-2FF3-422D-A5AD-61CAE6339CCC@linux.vnet.ibm.com> <53F24A49.2010807@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 19, 2014, at 2:47 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:

> 
>> I think this patch is auditable, page-fault is always called by holding
>> srcu-lock so that a page fault can’t go across synchronize_srcu_expedited.
>> Only these cases can happen:
>> 
>> 1)  page fault occurs before synchronize_srcu_expedited.
>>    In this case, vcpu will generate mmio-exit for the memslot being registered
>>    by the ioctl. That’s ok since the ioctl have not finished.
>> 
>> 2) page fault occurs after synchronize_srcu_expedited and during
>>   increasing generation-number.
>>   In this case, userspace may get wrong mmio-exit (that happen if handing
>>   page-fault is slower that the ioctl), that’s ok too since userspace need do
>>  the check anyway like i said above.
>> 
>> 3) page fault occurs after generation-number update
>>   that’s definitely correct. :)
>> 
>>> Another alternative could be to use the low bit to mark an in-progress
>>> change, and skip the caching if the low bit is set.  Similar to a
>>> seqcount (except if read_seqcount_retry fails, we just punt and not
>>> retry anything), you could use it even though the memory barriers
>>> provided by write_seqcount_begin/end are not too useful in this case.
>> 
>> I do not know how the bit works, page fault will cache the memslot before
>> the bit set and cache the generation-number after the bit set.
>> 
>> Maybe i missed your idea, could you please detail it?
> 
> Something like this:
> 
> -	update_memslots(slots, new, kvm->memslots->generation);
> +	/* ensure generation number is always increased. */
> +	slots->generation = old_memslots->generation + 1;
> +	update_memslots(slots, new);
> 	rcu_assign_pointer(kvm->memslots, slots);
> 	synchronize_srcu_expedited(&kvm->srcu);
> +	slots->generation++;
> 
> Then case 1 and 2 will just have a cache miss.

So, case 2 is what you concerned? :) I still think it is ok but i do not have
strong opinion on that. How about simplify it like this:

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 9314678..9fabf6a 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -234,16 +234,22 @@ static unsigned int get_mmio_spte_generation(u64 spte)
 	return gen;
 }
 
-static unsigned int kvm_current_mmio_generation(struct kvm *kvm)
+static unsigned int __kvm_current_mmio_generation(struct kvm_memslots *slots)
 {
+
 	/*
 	 * Init kvm generation close to MMIO_MAX_GEN to easily test the
 	 * code of handling generation number wrap-around.
 	 */
-	return (kvm_memslots(kvm)->generation +
+	return (slots->generation +
 		      MMIO_MAX_GEN - 150) & MMIO_GEN_MASK;
 }
 
+static unsigned int kvm_current_mmio_generation(struct kvm *kvm)
+{
+	return __kvm_current_mmio_generation(kvm_memslots(kvm));
+}
+
 static void mark_mmio_spte(struct kvm *kvm, u64 *sptep, u64 gfn,
 			   unsigned access)
 {
@@ -287,9 +293,15 @@ static bool set_mmio_spte(struct kvm *kvm, u64 *sptep, gfn_t gfn,
 
 static bool check_mmio_spte(struct kvm *kvm, u64 spte)
 {
+	struct kvm_memslots *slots = kvm_memslots(kvm);
 	unsigned int kvm_gen, spte_gen;
 
-	kvm_gen = kvm_current_mmio_generation(kvm);
+	if (slots->updated)
+		return false;
+
+	smp_rmb();
+	
+	kvm_gen = __kvm_current_mmio_generation(slots);
 	spte_gen = get_mmio_spte_generation(spte);
 
 	trace_check_mmio_spte(spte, kvm_gen, spte_gen);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4b6c01b..1d4e78f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -96,7 +96,7 @@ static void hardware_disable_all(void);
 
 static void kvm_io_bus_destroy(struct kvm_io_bus *bus);
 static void update_memslots(struct kvm_memslots *slots,
-			    struct kvm_memory_slot *new, u64 last_generation);
+			    struct kvm_memory_slot *new);
 
 static void kvm_release_pfn_dirty(pfn_t pfn);
 static void mark_page_dirty_in_slot(struct kvm *kvm,
@@ -685,8 +685,7 @@ static void sort_memslots(struct kvm_memslots *slots)
 }
 
 static void update_memslots(struct kvm_memslots *slots,
-			    struct kvm_memory_slot *new,
-			    u64 last_generation)
+			    struct kvm_memory_slot *new)
 {
 	if (new) {
 		int id = new->id;
@@ -697,8 +696,6 @@ static void update_memslots(struct kvm_memslots *slots,
 		if (new->npages != npages)
 			sort_memslots(slots);
 	}
-
-	slots->generation = last_generation + 1;
 }
 
 static int check_memory_region_flags(struct kvm_userspace_memory_region *mem)
@@ -720,10 +717,17 @@ static struct kvm_memslots *install_new_memslots(struct kvm *kvm,
 {
 	struct kvm_memslots *old_memslots = kvm->memslots;
 
-	update_memslots(slots, new, kvm->memslots->generation);
+	/* ensure generation number is always increased. */
+	slots->updated = true;
+	slots->generation = old_memslots->generation;
+	update_memslots(slots, new);
 	rcu_assign_pointer(kvm->memslots, slots);
 	synchronize_srcu_expedited(&kvm->srcu);
 
+	slots->generation++;
+	smp_wmb();
+	slots->updated = false;
+
 	kvm_arch_memslots_updated(kvm);
 
 	return old_memslots;

