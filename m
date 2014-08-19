Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946AbaHSIuf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 04:50:35 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:41168 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804AbaHSIub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 04:50:31 -0400
Message-ID: <53F30FCD.3080109@linux.vnet.ibm.com>
Date: Tue, 19 Aug 2014 16:50:21 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>, David Matlack <dmatlack@google.com>
CC: Gleb Natapov <gleb@kernel.org>, Avi Kivity <avi.kivity@gmail.com>,
        mtosatti@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: fix cache stale memslot info with correct mmio
 generation number
References: <1407999713-3726-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <53F20653.2030204@redhat.com> <9AD43423-2FF3-422D-A5AD-61CAE6339CCC@linux.vnet.ibm.com> <53F24A49.2010807@redhat.com> <A07DA8BD-8756-427D-9925-B8696E47C73A@gmail.com> <CALzav=fNoXeStA6ETDW0tNqyXBxWN0i8N5P-Ht7jtwgS_r7qmw@mail.gmail.com> <53F2C997.6070605@linux.vnet.ibm.com> <53F30AA4.4050803@redhat.com>
In-Reply-To: <53F30AA4.4050803@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081908-5564-0000-0000-000000D948FE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2014 04:28 PM, Paolo Bonzini wrote:
> Il 19/08/2014 05:50, Xiao Guangrong ha scritto:
>>
>> Note in the step *, my approach detects the invalid generation-number which
>> will invalidate the mmio spte properly .
> 
> You are right, in fact my mail included another part: "Another 
> alternative could be to use the low bit to mark an in-progress change, 
> *and skip the caching if the low bit is set*."

Okay, what confused me it that it seems that the single line patch
is ok to you. :)

Now, do we really need to care the case 2? like David said:
"Sorry I didn't explain myself very well: Since we can get a single wrong
mmio exit no matter what, it has to be handled in userspace. So my point
was, it doesn't really help to fix that one very specific way that it can
happen, because it can just happen in other ways. (E.g. update memslots
occurs after is_noslot_pfn() and before mmio exit)."

What's your idea?

> 
> I think if you always treat the low bit as zero in mmio sptes, you can 
> do that without losing a bit of the generation.

What's you did is avoiding cache a invalid generation number into spte, but
actually if we can figure it out when we check mmio access, it's ok. Like the
updated patch i posted should fix it, that way avoids doubly increase the number.

Okay, if you're interested increasing the number doubly, there is the simpler
one:

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 9314678..bf49170 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -236,6 +236,9 @@ static unsigned int get_mmio_spte_generation(u64 spte)

 static unsigned int kvm_current_mmio_generation(struct kvm *kvm)
 {
+       /* The initialized generation number should be even. */
+       BUILD_BUG_ON((MMIO_MAX_GEN - 150) & 0x1);
+
        /*
         * Init kvm generation close to MMIO_MAX_GEN to easily test the
         * code of handling generation number wrap-around.
@@ -292,6 +295,14 @@ static bool check_mmio_spte(struct kvm *kvm, u64 spte)
        kvm_gen = kvm_current_mmio_generation(kvm);
        spte_gen = get_mmio_spte_generation(spte);

+       /*
+        * Aha, we cached a being-updated generation number or
+        * generation number is currnetly being updated, let do the
+        * real check for mmio access.
+        */
+       if ((kvm_gen | spte_gen) & 0x1)
+               return false;
+
        trace_check_mmio_spte(spte, kvm_gen, spte_gen);
        return likely(kvm_gen == spte_gen);
 }
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 33712fb..5c3f7b7 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -725,7 +725,7 @@ static struct kvm_memslots *install_new_memslots(struct kvm *kvm,
        update_memslots(slots, new, kvm->memslots->generation);
        rcu_assign_pointer(kvm->memslots, slots);
        synchronize_srcu_expedited(&kvm->srcu);
-
+       kvm->memslots->generation++;
        kvm_arch_memslots_updated(kvm);

        return old_memslots;

