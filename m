Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761567Ab3DCNZy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 09:25:54 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:35174 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759070Ab3DCNZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 09:25:53 -0400
Message-ID: <515C2DF0.7000501@oracle.com>
Date: Wed, 03 Apr 2013 09:26:08 -0400
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: hpa@zytor.com
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        mingo@redhat.com, tglx@linutronix.de, rostedt@goodmis.org,
        kraman@redhat.com, gregkh@linuxfoundation.org, bp@alien8.de,
        samu.kallio@aberdeencloud.com
Subject: Re: [PATCH 2/2] mm/x86: Patch out arch_flush_lazy_mmu_mode() when
 running on bare metal
References: <9a798a0e-bc39-40db-be7f-b5e6fcc382d9@email.android.com> <1364045796-10720-1-git-send-email-konrad.wilk@oracle.com> <1364045796-10720-2-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1364045796-10720-2-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2013 09:36 AM, Konrad Rzeszutek Wilk wrote:
> From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
>
> Invoking arch_flush_lazy_mmu_mode() results in calls to
> preempt_enable()/disable() which may have performance impact.
>
> Since lazy MMU is not used on bare metal we can patch away
> arch_flush_lazy_mmu_mode() so that it is never called in such
> environment.
>
> Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> Tested-by: Josh Boyer <jwboyer@redhat.com>
> Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Acked-by: Borislav Petkov <bp@suse.de>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Peter, what's the status of these two patches? They are not going into
3.9, right?

Thanks.
-boris


> ---
>   arch/x86/include/asm/paravirt.h       |  5 ++++-
>   arch/x86/include/asm/paravirt_types.h |  2 ++
>   arch/x86/kernel/paravirt.c            | 25 +++++++++++++------------
>   arch/x86/lguest/boot.c                |  1 +
>   arch/x86/xen/mmu.c                    |  1 +
>   5 files changed, 21 insertions(+), 13 deletions(-)
>
> diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
> index 5edd174..7361e47 100644
> --- a/arch/x86/include/asm/paravirt.h
> +++ b/arch/x86/include/asm/paravirt.h
> @@ -703,7 +703,10 @@ static inline void arch_leave_lazy_mmu_mode(void)
>   	PVOP_VCALL0(pv_mmu_ops.lazy_mode.leave);
>   }
>   
> -void arch_flush_lazy_mmu_mode(void);
> +static inline void arch_flush_lazy_mmu_mode(void)
> +{
> +	PVOP_VCALL0(pv_mmu_ops.lazy_mode.flush);
> +}
>   
>   static inline void __set_fixmap(unsigned /* enum fixed_addresses */ idx,
>   				phys_addr_t phys, pgprot_t flags)
> diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
> index 142236e..b3b0ec1 100644
> --- a/arch/x86/include/asm/paravirt_types.h
> +++ b/arch/x86/include/asm/paravirt_types.h
> @@ -91,6 +91,7 @@ struct pv_lazy_ops {
>   	/* Set deferred update mode, used for batching operations. */
>   	void (*enter)(void);
>   	void (*leave)(void);
> +	void (*flush)(void);
>   };
>   
>   struct pv_time_ops {
> @@ -679,6 +680,7 @@ void paravirt_end_context_switch(struct task_struct *next);
>   
>   void paravirt_enter_lazy_mmu(void);
>   void paravirt_leave_lazy_mmu(void);
> +void paravirt_flush_lazy_mmu(void);
>   
>   void _paravirt_nop(void);
>   u32 _paravirt_ident_32(u32);
> diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
> index 17fff18..8bfb335 100644
> --- a/arch/x86/kernel/paravirt.c
> +++ b/arch/x86/kernel/paravirt.c
> @@ -263,6 +263,18 @@ void paravirt_leave_lazy_mmu(void)
>   	leave_lazy(PARAVIRT_LAZY_MMU);
>   }
>   
> +void paravirt_flush_lazy_mmu(void)
> +{
> +	preempt_disable();
> +
> +	if (paravirt_get_lazy_mode() == PARAVIRT_LAZY_MMU) {
> +		arch_leave_lazy_mmu_mode();
> +		arch_enter_lazy_mmu_mode();
> +	}
> +
> +	preempt_enable();
> +}
> +
>   void paravirt_start_context_switch(struct task_struct *prev)
>   {
>   	BUG_ON(preemptible());
> @@ -292,18 +304,6 @@ enum paravirt_lazy_mode paravirt_get_lazy_mode(void)
>   	return this_cpu_read(paravirt_lazy_mode);
>   }
>   
> -void arch_flush_lazy_mmu_mode(void)
> -{
> -	preempt_disable();
> -
> -	if (paravirt_get_lazy_mode() == PARAVIRT_LAZY_MMU) {
> -		arch_leave_lazy_mmu_mode();
> -		arch_enter_lazy_mmu_mode();
> -	}
> -
> -	preempt_enable();
> -}
> -
>   struct pv_info pv_info = {
>   	.name = "bare hardware",
>   	.paravirt_enabled = 0,
> @@ -475,6 +475,7 @@ struct pv_mmu_ops pv_mmu_ops = {
>   	.lazy_mode = {
>   		.enter = paravirt_nop,
>   		.leave = paravirt_nop,
> +		.flush = paravirt_nop,
>   	},
>   
>   	.set_fixmap = native_set_fixmap,
> diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
> index 1cbd89c..7114c63 100644
> --- a/arch/x86/lguest/boot.c
> +++ b/arch/x86/lguest/boot.c
> @@ -1334,6 +1334,7 @@ __init void lguest_init(void)
>   	pv_mmu_ops.read_cr3 = lguest_read_cr3;
>   	pv_mmu_ops.lazy_mode.enter = paravirt_enter_lazy_mmu;
>   	pv_mmu_ops.lazy_mode.leave = lguest_leave_lazy_mmu_mode;
> +	pv_mmu_ops.lazy_mode.flush = paravirt_flush_lazy_mmu;
>   	pv_mmu_ops.pte_update = lguest_pte_update;
>   	pv_mmu_ops.pte_update_defer = lguest_pte_update;
>   
> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> index e8e3493..f4f4105 100644
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -2197,6 +2197,7 @@ static const struct pv_mmu_ops xen_mmu_ops __initconst = {
>   	.lazy_mode = {
>   		.enter = paravirt_enter_lazy_mmu,
>   		.leave = xen_leave_lazy_mmu,
> +		.flush = paravirt_flush_lazy_mmu,
>   	},
>   
>   	.set_fixmap = xen_set_fixmap,

