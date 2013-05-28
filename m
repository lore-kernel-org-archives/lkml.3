Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934028Ab3E1NFq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 09:05:46 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:52041 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933919Ab3E1NFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 09:05:45 -0400
Date: Tue, 28 May 2013 14:05:02 +0100
From: Will Deacon <will.deacon@arm.com>
To: Po-Yu Chuang <ratbert.chuang@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "nico@linaro.org" <nico@linaro.org>
Subject: Re: [PATCH] ARM: map_init_section flushes incorrect pmd
Message-ID: <20130528130502.GA28971@mudshark.cambridge.arm.com>
References: <1369738100-11152-1-git-send-email-ratbert.chuang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369738100-11152-1-git-send-email-ratbert.chuang@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, 2013 at 11:48:20AM +0100, Po-Yu Chuang wrote:
> This bug was introduced in commit e651eab0.
> Some v4/v5 platforms failed to boot due to this.
> 
> Signed-off-by: Po-Yu Chuang <ratbert.chuang@gmail.com>
> ---
>  arch/arm/mm/mmu.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
> index e0d8565..19a43f8 100644
> --- a/arch/arm/mm/mmu.c
> +++ b/arch/arm/mm/mmu.c
> @@ -620,6 +620,8 @@ static void __init map_init_section(pmd_t *pmd, unsigned long addr,
>  			unsigned long end, phys_addr_t phys,
>  			const struct mem_type *type)
>  {
> +	pmd_t *p = pmd;
> +
>  #ifndef CONFIG_ARM_LPAE
>  	/*
>  	 * In classic MMU format, puds and pmds are folded in to
> @@ -638,7 +640,7 @@ static void __init map_init_section(pmd_t *pmd, unsigned long addr,
>  		phys += SECTION_SIZE;
>  	} while (pmd++, addr += SECTION_SIZE, addr != end);
>  
> -	flush_pmd_entry(pmd);
> +	flush_pmd_entry(p);

Wait, shouldn't this flush be *inside* the loop anyway? Otherwise we just
flush the cacheline containing the first pmd. The flushing code could also
flush to PoU instead of PoC for UP ARMv7, but that's an unrelated optimisation.

Will
