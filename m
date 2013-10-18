Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495Ab3JRW5U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 18:57:20 -0400
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:59780
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754832Ab3JRW5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 18:57:19 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zcb8kz98dI936eI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bhz2dh2a8h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h1155h)
Message-ID: <1382137030.7979.914.camel@snotra.buserror.net>
Subject: Re: [v5][PATCH 3/6] book3e/kgdb: update thread's dbcr0
From: Scott Wood <scottwood@freescale.com>
To: Tiejun Chen <tiejun.chen@windriver.com>
CC: <benh@kernel.crashing.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Date: Fri, 18 Oct 2013 17:57:10 -0500
In-Reply-To: <1371724110-8250-4-git-send-email-tiejun.chen@windriver.com>
References: <1371724110-8250-1-git-send-email-tiejun.chen@windriver.com>
	 <1371724110-8250-4-git-send-email-tiejun.chen@windriver.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-20 at 18:28 +0800, Tiejun Chen wrote:
> gdb always need to generate a single step properly to invoke
> a kgdb state. But with lazy interrupt, book3e can't always
> trigger a debug exception with a single step since the current
> is blocked for handling those pending exception, then we miss
> that expected dbcr configuration at last to generate a debug
> exception.

What do you mean by "the current is blocked"?  Could you explain more
clearly what lazy EE has to do with MSR_DE and DBCR0?

> So here we also update thread's dbcr0 to make sure the current
> can go back with that missed dbcr0 configuration.
> 
> Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
> ---
>  arch/powerpc/kernel/kgdb.c |   13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/kgdb.c b/arch/powerpc/kernel/kgdb.c
> index c1eef24..55409ac 100644
> --- a/arch/powerpc/kernel/kgdb.c
> +++ b/arch/powerpc/kernel/kgdb.c
> @@ -410,7 +410,7 @@ int kgdb_arch_handle_exception(int vector, int signo, int err_code,
>  			       struct pt_regs *linux_regs)
>  {
>  	char *ptr = &remcom_in_buffer[1];
> -	unsigned long addr;
> +	unsigned long addr, dbcr0;
>  
>  	switch (remcom_in_buffer[0]) {
>  		/*
> @@ -427,8 +427,15 @@ int kgdb_arch_handle_exception(int vector, int signo, int err_code,
>  		/* set the trace bit if we're stepping */
>  		if (remcom_in_buffer[0] == 's') {
>  #ifdef CONFIG_PPC_ADV_DEBUG_REGS
> -			mtspr(SPRN_DBCR0,
> -			      mfspr(SPRN_DBCR0) | DBCR0_IC | DBCR0_IDM);
> +			dbcr0 = mfspr(SPRN_DBCR0) | DBCR0_IC | DBCR0_IDM;
> +			mtspr(SPRN_DBCR0, dbcr0);
> +#ifdef CONFIG_PPC_BOOK3E_64

This could as well be "CONFIG_PPC64" -- CONFIG_PPC_ADV_DEBUG_REGS
implies booke or 40x.  Lazy EE is a CONFIG_PPC64 thing, not specifically
CONFIG_PPC_BOOK3E_64.

> +			/* With lazy interrut we have to update thread dbcr0 here

s/interrut/interrupts/

> +			 * to make sure we can set debug properly at last to invoke
> +			 * kgdb again to work well.
> +			 */
> +			current->thread.dbcr0 = dbcr0;
> +#endif
>  			linux_regs->msr |= MSR_DE;
>  #else
>  			linux_regs->msr |= MSR_SE;

Hmm, what happens here if we enable KGDB on booke without
CONFIG_PPC_ADV_DEBUG_REGS?  Kconfig doesn't appear to prevent it.

-Scott



