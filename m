Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265AbaBKVYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 16:24:20 -0500
Received: from forward20.mail.yandex.net ([95.108.253.145]:35407 "EHLO
	forward20.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993AbaBKVYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 16:24:18 -0500
X-Greylist: delayed 631 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Feb 2014 16:24:18 EST
From: Kirill Tkhai <tkhai@yandex.ru>
To: Allen Pais <allen.pais@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "bigeasy@linutronix.de" <bigeasy@linutronix.de>
In-Reply-To: <1388980510-10190-4-git-send-email-allen.pais@oracle.com>
References: <1388980510-10190-1-git-send-email-allen.pais@oracle.com> <1388980510-10190-4-git-send-email-allen.pais@oracle.com>
Subject: Re: [PATCH 3/4] sparc64: convert spinlock_t to raw_spinlock_t in  mmu_context_t
MIME-Version: 1.0
Message-Id: <341392153219@web17g.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Wed, 12 Feb 2014 01:13:39 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



06.01.2014, 07:56, "Allen Pais" <allen.pais@oracle.com>:
> In the attempt of get PREEMPT_RT working on sparc64 using
> linux-stable-rt version 3.10.22-rt19+, the kernel crash
> with the following trace:
>
> [ 1487.027884] I7: <rt_mutex_setprio+0x3c/0x2c0>
> [ 1487.027885] Call Trace:
> [ 1487.027887] š[00000000004967dc] rt_mutex_setprio+0x3c/0x2c0
> [ 1487.027892] š[00000000004afe20] task_blocks_on_rt_mutex+0x180/0x200
> [ 1487.027895] š[0000000000819114] rt_spin_lock_slowlock+0x94/0x300
> [ 1487.027897] š[0000000000817ebc] __schedule+0x39c/0x53c
> [ 1487.027899] š[00000000008185fc] schedule+0x1c/0xc0
> [ 1487.027908] š[000000000048fff4] smpboot_thread_fn+0x154/0x2e0
> [ 1487.027913] š[000000000048753c] kthread+0x7c/0xa0
> [ 1487.027920] š[00000000004060c4] ret_from_syscall+0x1c/0x2c
> [ 1487.027922] š[0000000000000000] šššššššššš(null)
>
> Thomas debugged this issue and pointed to switch_mm
>
> ššššššššspin_lock_irqsave(&mm->context.lock, flags);
>
> context.lock needs to be a raw_spinlock.
>
> Acked-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Allen Pais <allen.pais@oracle.com>
> ---
> šarch/sparc/include/asm/mmu_64.h šššššššš| ššš2 +-
> šarch/sparc/include/asm/mmu_context_64.h | ššš8 ++++----
> šarch/sparc/kernel/smp_64.c ššššššššššššš| ššš4 ++--
> šarch/sparc/mm/init_64.c šššššššššššššššš| ššš4 ++--
> šarch/sparc/mm/tsb.c šššššššššššššššššššš| šš16 ++++++++--------
> š5 files changed, 17 insertions(+), 17 deletions(-)
>
> diff --git a/arch/sparc/include/asm/mmu_64.h b/arch/sparc/include/asm/mmu_64.h
> index 76092c4..e945ddb 100644
> --- a/arch/sparc/include/asm/mmu_64.h
> +++ b/arch/sparc/include/asm/mmu_64.h
> @@ -90,7 +90,7 @@ struct tsb_config {
> š#endif
>
> štypedef struct {
> - spinlock_t lock;
> + raw_spinlock_t lock;
> šššššššššunsigned long sparc64_ctx_val;
> šššššššššunsigned long huge_pte_count;
> šššššššššstruct page *pgtable_page;
> diff --git a/arch/sparc/include/asm/mmu_context_64.h b/arch/sparc/include/asm/mmu_context_64.h
> index 3d528f0..3a85624 100644
> --- a/arch/sparc/include/asm/mmu_context_64.h
> +++ b/arch/sparc/include/asm/mmu_context_64.h
> @@ -77,7 +77,7 @@ static inline void switch_mm(struct mm_struct *old_mm, struct mm_struct *mm, str
> šššššššššif (unlikely(mm == &init_mm))
> šššššššššššššššššreturn;
>
> - spin_lock_irqsave(&mm->context.lock, flags);
> + raw_spin_lock_irqsave(&mm->context.lock, flags);
> šššššššššctx_valid = CTX_VALID(mm->context);
> šššššššššif (!ctx_valid)
> šššššššššššššššššget_new_mmu_context(mm);
> @@ -125,7 +125,7 @@ static inline void switch_mm(struct mm_struct *old_mm, struct mm_struct *mm, str
> ššššššššššššššššš__flush_tlb_mm(CTX_HWBITS(mm->context),
> ššššššššššššššššššššššššššššššššSECONDARY_CONTEXT);
> ššššššššš}
> - spin_unlock_irqrestore(&mm->context.lock, flags);
> + raw_spin_unlock_irqrestore(&mm->context.lock, flags);
> š}
>
> š#define deactivate_mm(tsk,mm) do { } while (0)
> @@ -136,7 +136,7 @@ static inline void activate_mm(struct mm_struct *active_mm, struct mm_struct *mm
> šššššššššunsigned long flags;
> šššššššššint cpu;
>
> - spin_lock_irqsave(&mm->context.lock, flags);
> + raw_spin_lock_irqsave(&mm->context.lock, flags);
> šššššššššif (!CTX_VALID(mm->context))
> šššššššššššššššššget_new_mmu_context(mm);
> šššššššššcpu = smp_processor_id();
> @@ -146,7 +146,7 @@ static inline void activate_mm(struct mm_struct *active_mm, struct mm_struct *mm
> šššššššššload_secondary_context(mm);
> ššššššššš__flush_tlb_mm(CTX_HWBITS(mm->context), SECONDARY_CONTEXT);
> ššššššššštsb_context_switch(mm);
> - spin_unlock_irqrestore(&mm->context.lock, flags);
> + raw_spin_unlock_irqrestore(&mm->context.lock, flags);
> š}
>
> š#endif /* !(__ASSEMBLY__) */
> diff --git a/arch/sparc/kernel/smp_64.c b/arch/sparc/kernel/smp_64.c
> index 77539ed..f42e1a7 100644
> --- a/arch/sparc/kernel/smp_64.c
> +++ b/arch/sparc/kernel/smp_64.c
> @@ -975,12 +975,12 @@ void __irq_entry smp_new_mmu_context_version_client(int irq, struct pt_regs *reg
> šššššššššif (unlikely(!mm || (mm == &init_mm)))
> šššššššššššššššššreturn;
>
> - spin_lock_irqsave(&mm->context.lock, flags);
> + raw_spin_lock_irqsave(&mm->context.lock, flags);
>
> šššššššššif (unlikely(!CTX_VALID(mm->context)))
> šššššššššššššššššget_new_mmu_context(mm);
>
> - spin_unlock_irqrestore(&mm->context.lock, flags);
> + raw_spin_unlock_irqrestore(&mm->context.lock, flags);
>
> šššššššššload_secondary_context(mm);
> ššššššššš__flush_tlb_mm(CTX_HWBITS(mm->context),
> diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
> index 04fd55a..bd5253d 100644
> --- a/arch/sparc/mm/init_64.c
> +++ b/arch/sparc/mm/init_64.c
> @@ -350,7 +350,7 @@ void update_mmu_cache(struct vm_area_struct *vma, unsigned long address, pte_t *
>
> šššššššššmm = vma->vm_mm;
>
> - spin_lock_irqsave(&mm->context.lock, flags);
> + raw_spin_lock_irqsave(&mm->context.lock, flags);
>
> š#if defined(CONFIG_HUGETLB_PAGE) || defined(CONFIG_TRANSPARENT_HUGEPAGE)
> šššššššššif (mm->context.huge_pte_count && is_hugetlb_pte(pte))
> @@ -361,7 +361,7 @@ void update_mmu_cache(struct vm_area_struct *vma, unsigned long address, pte_t *
> ššššššššššššššššš__update_mmu_tsb_insert(mm, MM_TSB_BASE, PAGE_SHIFT,
> šššššššššššššššššššššššššššššššššššššššššaddress, pte_val(pte));
>
> - spin_unlock_irqrestore(&mm->context.lock, flags);
> + raw_spin_unlock_irqrestore(&mm->context.lock, flags);
> š}

We also should do the same in update_mmu_cache_pmd().

>
> švoid flush_dcache_page(struct page *page)
> diff --git a/arch/sparc/mm/tsb.c b/arch/sparc/mm/tsb.c
> index 2cc3bce..d84d4ea 100644
> --- a/arch/sparc/mm/tsb.c
> +++ b/arch/sparc/mm/tsb.c
> @@ -73,7 +73,7 @@ void flush_tsb_user(struct tlb_batch *tb)
> šššššššššstruct mm_struct *mm = tb->mm;
> šššššššššunsigned long nentries, base, flags;
>
> - spin_lock_irqsave(&mm->context.lock, flags);
> + raw_spin_lock_irqsave(&mm->context.lock, flags);
>
> šššššššššbase = (unsigned long) mm->context.tsb_block[MM_TSB_BASE].tsb;
> šššššššššnentries = mm->context.tsb_block[MM_TSB_BASE].tsb_nentries;
> @@ -90,14 +90,14 @@ void flush_tsb_user(struct tlb_batch *tb)
> ššššššššššššššššš__flush_tsb_one(tb, HPAGE_SHIFT, base, nentries);
> ššššššššš}
> š#endif
> - spin_unlock_irqrestore(&mm->context.lock, flags);
> + raw_spin_unlock_irqrestore(&mm->context.lock, flags);
> š}
>
> švoid flush_tsb_user_page(struct mm_struct *mm, unsigned long vaddr)
> š{
> šššššššššunsigned long nentries, base, flags;
>
> - spin_lock_irqsave(&mm->context.lock, flags);
> + raw_spin_lock_irqsave(&mm->context.lock, flags);
>
> šššššššššbase = (unsigned long) mm->context.tsb_block[MM_TSB_BASE].tsb;
> šššššššššnentries = mm->context.tsb_block[MM_TSB_BASE].tsb_nentries;
> @@ -114,7 +114,7 @@ void flush_tsb_user_page(struct mm_struct *mm, unsigned long vaddr)
> ššššššššššššššššš__flush_tsb_one_entry(base, vaddr, HPAGE_SHIFT, nentries);
> ššššššššš}
> š#endif
> - spin_unlock_irqrestore(&mm->context.lock, flags);
> + raw_spin_unlock_irqrestore(&mm->context.lock, flags);
> š}
>
> š#define HV_PGSZ_IDX_BASE HV_PGSZ_IDX_8K
> @@ -392,7 +392,7 @@ retry_tsb_alloc:
> šššššššššš* the lock and ask all other cpus running this address space
> šššššššššš* to run tsb_context_switch() to see the new TSB table.
> šššššššššš*/
> - spin_lock_irqsave(&mm->context.lock, flags);
> + raw_spin_lock_irqsave(&mm->context.lock, flags);
>
> šššššššššold_tsb = mm->context.tsb_block[tsb_index].tsb;
> šššššššššold_cache_index =
> @@ -407,7 +407,7 @@ retry_tsb_alloc:
> šššššššššš*/
> šššššššššif (unlikely(old_tsb &&
> šššššššššššššššššššššš(rss < mm->context.tsb_block[tsb_index].tsb_rss_limit))) {
> - spin_unlock_irqrestore(&mm->context.lock, flags);
> + raw_spin_unlock_irqrestore(&mm->context.lock, flags);
>
> ššššššššššššššššškmem_cache_free(tsb_caches[new_cache_index], new_tsb);
> šššššššššššššššššreturn;
> @@ -433,7 +433,7 @@ retry_tsb_alloc:
> šššššššššmm->context.tsb_block[tsb_index].tsb = new_tsb;
> šššššššššsetup_tsb_params(mm, tsb_index, new_size);
>
> - spin_unlock_irqrestore(&mm->context.lock, flags);
> + raw_spin_unlock_irqrestore(&mm->context.lock, flags);
>
> ššššššššš/* If old_tsb is NULL, we're being invoked for the first time
> šššššššššš* from init_new_context().
> @@ -459,7 +459,7 @@ int init_new_context(struct task_struct *tsk, struct mm_struct *mm)
> š#endif
> šššššššššunsigned int i;
>
> - spin_lock_init(&mm->context.lock);
> + raw_spin_lock_init(&mm->context.lock);
>
> šššššššššmm->context.sparc64_ctx_val = 0UL;
>
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at šhttp://vger.kernel.org/majordomo-info.html
> Please read the FAQ at šhttp://www.tux.org/lkml/
