Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071Ab3CYAeJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 20:34:09 -0400
Received: from ozlabs.org ([203.10.76.45]:41148 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754788Ab3CYAeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 20:34:07 -0400
From: Michael Neuling <mikey@neuling.org>
To: Stuart Yoder <stuart.yoder@freescale.com>
cc: chen.gang.flying.transformer@gmail.com, galak@kernel.crashing.org,
        gang.chen@asianux.com, benh@kernel.crashing.org, sfr@canb.auug.org.au,
        paulus@samba.org, matt@ozlabs.org, imunsie@au1.ibm.com,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PPC: define the conditions where the ePAPR idle hcall can be supported
In-reply-to: <1363979533-24485-1-git-send-email-stuart.yoder@freescale.com>
References: <1363979533-24485-1-git-send-email-stuart.yoder@freescale.com>
Comments: In-reply-to Stuart Yoder <stuart.yoder@freescale.com>
   message dated "Fri, 22 Mar 2013 14:12:13 -0500."
X-Mailer: MH-E 8.2; nmh 1.5; GNU Emacs 23.4.1
Date: Mon, 25 Mar 2013 11:34:04 +1100
Message-ID: <18100.1364171644@ale.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stuart Yoder <stuart.yoder@freescale.com> wrote:

> From: Stuart Yoder <stuart.yoder@freescale.com>
> 
> For 32-bit, CONFIG_EPAPR_PARAVIRT pulls in both epapr_paravirt.c
> and epapr_hcalls.c which contains the 32-bit paravirt idle loop.
> 
> For 64-bit, the paravirt idle loop is in idle_book3e.S and that
> source file is included only if CONFIG_PPC_BOOK3E_64 defined.
> 
> This patch makes that dependency for 64-bit explicit.
> 
> Signed-off-by: Stuart Yoder <stuart.yoder@freescale.com>

It works for me.  Thanks.


> ---
>  arch/powerpc/kernel/epapr_paravirt.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/powerpc/kernel/epapr_paravirt.c b/arch/powerpc/kernel/epapr_paravirt.c
> index f3eab85..d44a571 100644
> --- a/arch/powerpc/kernel/epapr_paravirt.c
> +++ b/arch/powerpc/kernel/epapr_paravirt.c
> @@ -23,8 +23,10 @@
>  #include <asm/code-patching.h>
>  #include <asm/machdep.h>
>  
> +#if !defined(CONFIG_64BIT) || defined(CONFIG_PPC_BOOK3E_64)
>  extern void epapr_ev_idle(void);
>  extern u32 epapr_ev_idle_start[];
> +#endif

You don't need this #ifdef

>  
>  bool epapr_paravirt_enabled;
>  
> @@ -47,11 +49,15 @@ static int __init epapr_paravirt_init(void)
>  
>  	for (i = 0; i < (len / 4); i++) {
>  		patch_instruction(epapr_hypercall_start + i, insts[i]);
> +#if !defined(CONFIG_64BIT) || defined(CONFIG_PPC_BOOK3E_64)
>  		patch_instruction(epapr_ev_idle_start + i, insts[i]);
> +#endif
>  	}
>  
> +#if !defined(CONFIG_64BIT) || defined(CONFIG_PPC_BOOK3E_64)
>  	if (of_get_property(hyper_node, "has-idle", NULL))
>  		ppc_md.power_save = epapr_ev_idle;
> +#endif
>  
>  	epapr_paravirt_enabled = true;
>  
> -- 
> 1.7.9.7
> 
> 
