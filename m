Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab3BUMdR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 07:33:17 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:49086 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337Ab3BUMdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 07:33:15 -0500
Date: Thu, 21 Feb 2013 07:33:06 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Samu Kallio <samu.kallio@aberdeencloud.com>, mingo@redhat.com,
        Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: x86: mm: Fix vmalloc_fault oops during lazy MMU updates.
Message-ID: <20130221123306.GA6781@phenom.dumpdata.com>
References: <1361068552-21529-1-git-send-email-samu.kallio@aberdeencloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361068552-21529-1-git-send-email-samu.kallio@aberdeencloud.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2013 at 02:35:52AM -0000, Samu Kallio wrote:
> In paravirtualized x86_64 kernels, vmalloc_fault may cause an oops
> when lazy MMU updates are enabled, because set_pgd effects are being
> deferred.
> 
> One instance of this problem is during process mm cleanup with memory
> cgroups enabled. The chain of events is as follows:
> 
> - zap_pte_range enables lazy MMU updates
> - zap_pte_range eventually calls mem_cgroup_charge_statistics,
>   which accesses the vmalloc'd mem_cgroup per-cpu stat area
> - vmalloc_fault is triggered which tries to sync the corresponding
>   PGD entry with set_pgd, but the update is deferred
> - vmalloc_fault oopses due to a mismatch in the PUD entries
> 
> Calling arch_flush_lazy_mmu_mode immediately after set_pgd makes the
> changes visible to the consistency checks.

How do you reproduce this? Is there a BUG() or WARN() trace that
is triggered when this happens?

Also pls next time also CC me.
> 
> Signed-off-by: Samu Kallio <samu.kallio@aberdeencloud.com>
> 
> ---
> arch/x86/mm/fault.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index 8e13ecb..0a45298 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -378,10 +378,12 @@ static noinline __kprobes int vmalloc_fault(unsigned long address)
>  	if (pgd_none(*pgd_ref))
>  		return -1;
>  
> -	if (pgd_none(*pgd))
> +	if (pgd_none(*pgd)) {
>  		set_pgd(pgd, *pgd_ref);
> -	else
> +		arch_flush_lazy_mmu_mode();
> +	} else {
>  		BUG_ON(pgd_page_vaddr(*pgd) != pgd_page_vaddr(*pgd_ref));
> +	}
>  
>  	/*
>  	 * Below here mismatches are bugs because these lower tables
