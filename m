Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934265Ab3FSLk1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 07:40:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13626 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756417Ab3FSLkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 07:40:25 -0400
Message-ID: <51C1989F.80503@redhat.com>
Date: Wed, 19 Jun 2013 13:40:15 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: gleb@redhat.com, avi.kivity@gmail.com, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 2/7] KVM: MMU: document clear_spte_count
References: <1371632965-20077-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1371632965-20077-3-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
In-Reply-To: <1371632965-20077-3-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 19/06/2013 11:09, Xiao Guangrong ha scritto:
> Document it to Documentation/virtual/kvm/mmu.txt

Edits inline, please ack.

> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  Documentation/virtual/kvm/mmu.txt | 4 ++++
>  arch/x86/include/asm/kvm_host.h   | 5 +++++
>  arch/x86/kvm/mmu.c                | 7 ++++---
>  3 files changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/virtual/kvm/mmu.txt b/Documentation/virtual/kvm/mmu.txt
> index 869abcc..ce6df51 100644
> --- a/Documentation/virtual/kvm/mmu.txt
> +++ b/Documentation/virtual/kvm/mmu.txt
> @@ -210,6 +210,10 @@ Shadow pages contain the following information:
>      A bitmap indicating which sptes in spt point (directly or indirectly) at
>      pages that may be unsynchronized.  Used to quickly locate all unsychronized
>      pages reachable from a given page.
> +  clear_spte_count:
> +    It is only used on 32bit host which helps us to detect whether updating the
> +    64bit spte is complete so that we can avoid reading the truncated value out
> +    of mmu-lock.

+    Only present on 32-bit hosts, where a 64-bit spte cannot be written
+    atomically.  The reader uses this while running out of the MMU lock
+    to detect in-progress updates and retry them until the writer has
+    finished the write.

>  Reverse map
>  ===========
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 966f265..1dac2c1 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -226,6 +226,11 @@ struct kvm_mmu_page {
>  	DECLARE_BITMAP(unsync_child_bitmap, 512);
>  
>  #ifdef CONFIG_X86_32
> +	/*
> +	 * Count after the page's spte has been cleared to avoid
> +	 * the truncated value is read out of mmu-lock.
> +	 * please see the comments in __get_spte_lockless().

+	 * Used out of the mmu-lock to avoid reading spte values while an
+	 * update is in progress; see the comments in __get_spte_lockless().

> +	 */
>  	int clear_spte_count;
>  #endif
>  
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index c87b19d..77d516c 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -464,9 +464,10 @@ static u64 __update_clear_spte_slow(u64 *sptep, u64 spte)
>  /*
>   * The idea using the light way get the spte on x86_32 guest is from
>   * gup_get_pte(arch/x86/mm/gup.c).
> - * The difference is we can not catch the spte tlb flush if we leave
> - * guest mode, so we emulate it by increase clear_spte_count when spte
> - * is cleared.
> + * The difference is we can not immediately catch the spte tlb since
> + * kvm may collapse tlb flush some times. Please see kvm_set_pte_rmapp.
> + *
> + * We emulate it by increase clear_spte_count when spte is cleared.

+ * An spte tlb flush may be pending, because kvm_set_pte_rmapp
+ * coalesces them and we are running out of the MMU lock.  Therefore
+ * we need to protect against in-progress updates of the spte, which
+ * is done using clear_spte_count.

>   */
>  static u64 __get_spte_lockless(u64 *sptep)
>  {
> 

