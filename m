Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbaEOOof (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 10:44:35 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:62777 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312AbaEOOoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 10:44:34 -0400
Date: Thu, 15 May 2014 15:44:25 +0100
From: Steve Capper <steve.capper@linaro.org>
To: Mark Salter <msalter@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm64: fix pud_huge() for 2-level pagetables
Message-ID: <20140515144424.GA23884@linaro.org>
References: <1400163562-7481-1-git-send-email-msalter@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400163562-7481-1-git-send-email-msalter@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 10:19:22AM -0400, Mark Salter wrote:
> The following happens when trying to run a kvm guest on a kernel
> configured for 64k pages. This doesn't happen with 4k pages:
> 
>   BUG: failure at include/linux/mm.h:297/put_page_testzero()!
>   Kernel panic - not syncing: BUG!
>   CPU: 2 PID: 4228 Comm: qemu-system-aar Tainted: GF            3.13.0-0.rc7.31.sa2.k32v1.aarch64.debug #1
>   Call trace:
>   [<fffffe0000096034>] dump_backtrace+0x0/0x16c
>   [<fffffe00000961b4>] show_stack+0x14/0x1c
>   [<fffffe000066e648>] dump_stack+0x84/0xb0
>   [<fffffe0000668678>] panic+0xf4/0x220
>   [<fffffe000018ec78>] free_reserved_area+0x0/0x110
>   [<fffffe000018edd8>] free_pages+0x50/0x88
>   [<fffffe00000a759c>] kvm_free_stage2_pgd+0x30/0x40
>   [<fffffe00000a5354>] kvm_arch_destroy_vm+0x18/0x44
>   [<fffffe00000a1854>] kvm_put_kvm+0xf0/0x184
>   [<fffffe00000a1938>] kvm_vm_release+0x10/0x1c
>   [<fffffe00001edc1c>] __fput+0xb0/0x288
>   [<fffffe00001ede4c>] ____fput+0xc/0x14
>   [<fffffe00000d5a2c>] task_work_run+0xa8/0x11c
>   [<fffffe0000095c14>] do_notify_resume+0x54/0x58
> 
> In arch/arm/kvm/mmu.c:unmap_range(), we end up doing an extra put_page()
> on the stage2 pgd which leads to the BUG in put_page_testzero(). This
> happens because a pud_huge() test in unmap_range() returns true when it
> should always be false with 2-level pages tables used by 64k pages.
> This patch removes support for huge puds if 2-level pagetables are
> being used.

Hi Mark,
I'm still catching up with myself, sorry  (was off sick for a couple
of days)...

I thought unmap_range was going to be changed?
Does the following help things?
https://lists.cs.columbia.edu/pipermail/kvmarm/2014-May/009388.html

Cheers,
-- 
Steve

> 
> Signed-off-by: Mark Salter <msalter@redhat.com>
> ---
>  arch/arm64/mm/hugetlbpage.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
> index 5e9aec3..9bed38f 100644
> --- a/arch/arm64/mm/hugetlbpage.c
> +++ b/arch/arm64/mm/hugetlbpage.c
> @@ -51,7 +51,11 @@ int pmd_huge(pmd_t pmd)
>  
>  int pud_huge(pud_t pud)
>  {
> +#ifndef __PAGETABLE_PMD_FOLDED
>  	return !(pud_val(pud) & PUD_TABLE_BIT);
> +#else
> +	return 0;
> +#endif
>  }
>  
>  int pmd_huge_support(void)
> @@ -64,8 +68,10 @@ static __init int setup_hugepagesz(char *opt)
>  	unsigned long ps = memparse(opt, &opt);
>  	if (ps == PMD_SIZE) {
>  		hugetlb_add_hstate(PMD_SHIFT - PAGE_SHIFT);
> +#ifndef __PAGETABLE_PMD_FOLDED
>  	} else if (ps == PUD_SIZE) {
>  		hugetlb_add_hstate(PUD_SHIFT - PAGE_SHIFT);
> +#endif
>  	} else {
>  		pr_err("hugepagesz: Unsupported page size %lu M\n", ps >> 20);
>  		return 0;
> -- 
> 1.9.0
> 
