Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769Ab3FNNRk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 09:17:40 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:37826 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884Ab3FNNRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 09:17:38 -0400
Date: Fri, 14 Jun 2013 15:17:35 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: David Daney <ddaney.cavm@gmail.com>
Cc: linux-mips@linux-mips.org, kvm@vger.kernel.org,
        Sanjay Lal <sanjayl@kymasys.com>, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH 05/31] mips/kvm: Use generic cache flushing functions.
Message-ID: <20130614131735.GG15775@linux-mips.org>
References: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
 <1370646215-6543-6-git-send-email-ddaney.cavm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370646215-6543-6-git-send-email-ddaney.cavm@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 04:03:09PM -0700, David Daney wrote:

> From: David Daney <david.daney@cavium.com>
> 
> We don't know if we have the r4k specific functions available, so use
> universally available __flush_cache_all() instead.  This takes longer
> as it flushes both i-cache and d-cache, but is available for all CPUs.
> 
> Signed-off-by: David Daney <david.daney@cavium.com>
> ---
>  arch/mips/kvm/kvm_mips_emul.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/mips/kvm/kvm_mips_emul.c b/arch/mips/kvm/kvm_mips_emul.c
> index af9a661..a2c6687 100644
> --- a/arch/mips/kvm/kvm_mips_emul.c
> +++ b/arch/mips/kvm/kvm_mips_emul.c
> @@ -916,8 +916,6 @@ kvm_mips_emulate_cache(uint32_t inst, uint32_t *opc, uint32_t cause,
>  		       struct kvm_run *run, struct kvm_vcpu *vcpu)
>  {
>  	struct mips_coproc *cop0 = vcpu->arch.cop0;
> -	extern void (*r4k_blast_dcache) (void);
> -	extern void (*r4k_blast_icache) (void);
>  	enum emulation_result er = EMULATE_DONE;
>  	int32_t offset, cache, op_inst, op, base;
>  	struct kvm_vcpu_arch *arch = &vcpu->arch;
> @@ -954,9 +952,9 @@ kvm_mips_emulate_cache(uint32_t inst, uint32_t *opc, uint32_t cause,
>  		     arch->gprs[base], offset);
>  
>  		if (cache == MIPS_CACHE_DCACHE)
> -			r4k_blast_dcache();

Only nukes the D-cache.

> +			__flush_cache_all();

This is also going to blow away the I-cache, so will be slower.

>  		else if (cache == MIPS_CACHE_ICACHE)
> -			r4k_blast_icache();

Only nukes the I-cache.

> +			__flush_cache_all();

This is also going to blow away the D-cache, so will be slower.

  Ralf
