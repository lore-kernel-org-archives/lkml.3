Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751815AbaIYE6B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 00:58:01 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:37115 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbaIYE6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 00:58:00 -0400
Date: Thu, 25 Sep 2014 06:57:55 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
Cc: hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Quark: Flush TLB via CR3 not CR4.PGE in setup_arch()
Message-ID: <20140925045755.GA20431@gmail.com>
References: <1411578452-4609-1-git-send-email-pure.logic@nexus-software.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411578452-4609-1-git-send-email-pure.logic@nexus-software.ie>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Bryan O'Donoghue <pure.logic@nexus-software.ie> wrote:

> Quark X1000 requires CR3 to be rewritten to flush TLB entries
> irrespective of the PGE bits in CR4 or PTE.PGE
> 
> This patch flushes the TLB in the required way for Quark in setup_arch()
> See Quark Core_DevMan_001.pdf section 6.4.11
> 
> Signed-off-by: Bryan O'Donoghue <pure.logic@nexus-software.ie>
> ---
>  arch/x86/kernel/setup.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 41ead8d..1d2396a 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -879,7 +879,10 @@ void __init setup_arch(char **cmdline_p)
>  			KERNEL_PGD_PTRS);
>  
>  	load_cr3(swapper_pg_dir);
> -	__flush_tlb_all();
> +	if (boot_cpu_data.x86 == 5 && boot_cpu_data.x86_model == 9)
> +		__flush_tlb();
> +	else
> +		__flush_tlb_all();

So why not make __flush_tlb_all() Quark-quirk-aware and be done 
with it, instead of having to validate every single 
__flush_tlb_all() user?

Quark breaks the x86 'flush all TLBs' semantics - the way to fix 
it is to restore those semantics, not to sprinkle the breakage 
all around the code ...

Thanks,

	Ingo
