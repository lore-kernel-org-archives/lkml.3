Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934732Ab3FSM0X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 08:26:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36211 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934595Ab3FSM0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 08:26:22 -0400
Message-ID: <51C1A327.90900@redhat.com>
Date: Wed, 19 Jun 2013 14:25:11 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: gleb@redhat.com, avi.kivity@gmail.com, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 6/7] KVM: MMU: document fast invalidate all pages
References: <1371632965-20077-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1371632965-20077-7-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
In-Reply-To: <1371632965-20077-7-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 19/06/2013 11:09, Xiao Guangrong ha scritto:
> Document it to Documentation/virtual/kvm/mmu.txt
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  Documentation/virtual/kvm/mmu.txt | 23 +++++++++++++++++++++++
>  arch/x86/include/asm/kvm_host.h   |  5 +++++
>  2 files changed, 28 insertions(+)
> 
> diff --git a/Documentation/virtual/kvm/mmu.txt b/Documentation/virtual/kvm/mmu.txt
> index b5ce7dd..f5c4de9 100644
> --- a/Documentation/virtual/kvm/mmu.txt
> +++ b/Documentation/virtual/kvm/mmu.txt
> @@ -210,6 +210,10 @@ Shadow pages contain the following information:
>      A bitmap indicating which sptes in spt point (directly or indirectly) at
>      pages that may be unsynchronized.  Used to quickly locate all unsychronized
>      pages reachable from a given page.
> +  mmu_valid_gen:
> +    It is the generation number of the page which cooperates with
> +    kvm->arch.mmu_valid_gen to fast invalidate all pages.
> +    (see "Fast invalidate all pages" below.)

+  mmu_valid_gen:
+    Generation number of the page.  It is compared with kvm->arch.mmu_valid_gen
+    during hash table lookup, and used to skip invalidated shadow pages (see
+    "Zapping all pages" below.)

>    clear_spte_count:
>      It is only used on 32bit host which helps us to detect whether updating the
>      64bit spte is complete so that we can avoid reading the truncated value out
> @@ -373,6 +377,25 @@ causes its write_count to be incremented, thus preventing instantiation of
>  a large spte.  The frames at the end of an unaligned memory slot have
>  artificially inflated ->write_counts so they can never be instantiated.
>  
> +Fast invalidate all pages
> +===========
> +For the large memory and large vcpus guests, zapping all pages is a challenge
> +since they have large number of pages need to be zapped, walking and zapping
> +these pages are really slow and it should hold mmu-lock which stops the memory
> +access on all vcpus.
> +
> +To make it be more scalable, kvm maintains a global mmu valid
> +generation-number which is stored in kvm->arch.mmu_valid_gen and every shadow
> +page stores the current global generation-number into sp->mmu_valid_gen when
> +it is created.
> +
> +When KVM need zap all shadow pages sptes, it just simply increases the global
> +generation-number then reload root shadow pages on all vcpus. Vcpu will create
> +a new shadow page table according to current kvm's generation-number. It
> +ensures the old pages are not used any more. The invalid-gen pages
> +(sp->mmu_valid_gen != kvm->arch.mmu_valid_gen) are zapped by using lock-break
> +technique.
> +

+Zapping all pages (page generation count)
+=========================================
+
+For the large memory guests, walking and zapping all pages is really slow
+(because there are a lot of pages), and also blocks memory accesses of
+all VCPUs because it needs to hold the MMU lock.
+
+To make it be more scalable, kvm maintains a global generation number
+which is stored in kvm->arch.mmu_valid_gen.  Every shadow page stores
+the current global generation-number into sp->mmu_valid_gen when it
+is created.  Pages with a mismatching generation number are "obsolete".
+
+When KVM need zap all shadow pages sptes, it just simply increases the global
+generation-number then reload root shadow pages on all vcpus.  As the VCPUs
+create new shadow page tables, the old pages are not used because of the
+mismatching generation number.
+
+KVM then walks through all pages and zaps obsolete pages.  While the zap
+operation needs to take the MMU lock, the lock can be released periodically
+so that the VCPUs can make progress.
+

>  Further reading
>  ===============
>  
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 5eb5382..c4f90f6 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -222,6 +222,11 @@ struct kvm_mmu_page {
>  	int root_count;          /* Currently serving as active root */
>  	unsigned int unsync_children;
>  	unsigned long parent_ptes;	/* Reverse mapping for parent_pte */
> +
> +	/*
> +	 * the generation number of the page which cooperates with
> +	 * kvm->arch.mmu_valid_gen to fast invalidate all pages.
> +	 */

+	/* The page is obsolete if mmu_valid_gen != kvm->arch.mmu_valid_gen.  */

Paolo

>  	unsigned long mmu_valid_gen;
>  	DECLARE_BITMAP(unsync_child_bitmap, 512);
>  
> 

