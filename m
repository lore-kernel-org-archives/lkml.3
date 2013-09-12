Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576Ab3ILSom (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:44:42 -0400
Received: from mail-db9lp0253.outbound.messaging.microsoft.com ([213.199.154.253]:21206
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754497Ab3ILSok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 14:44:40 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI936eI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275dhz2dh2a8h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h1155h)
Message-ID: <1379011469.2536.45.camel@snotra.buserror.net>
Subject: Re: [PATCH v2] powerpc 8xx: Fixing issue with CONFIG_PIN_TLB
From: Scott Wood <scottwood@freescale.com>
To: Christophe Leroy <christophe.leroy@c-s.fr>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Thu, 12 Sep 2013 13:44:29 -0500
In-Reply-To: <201309121825.r8CIPrkI005690@localhost.localdomain>
References: <201309121825.r8CIPrkI005690@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-09-12 at 20:25 +0200, Christophe Leroy wrote:
> This is a reorganisation of the setup of the TLB at kernel startup, in order
> to handle the CONFIG_PIN_TLB case in accordance with chapter 8.10.3 of MPC866
> and MPC885 reference manuals.
>
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> 
> diff -ur linux-3.11.org/arch/powerpc/kernel/head_8xx.S linux-3.11/arch/powerpc/kernel/head_8xx.S
> --- linux-3.11.org/arch/powerpc/kernel/head_8xx.S	2013-09-02 22:46:10.000000000 +0200
> +++ linux-3.11/arch/powerpc/kernel/head_8xx.S	2013-09-09 11:28:54.000000000 +0200
> @@ -785,27 +785,24 @@
>   * these mappings is mapped by page tables.
>   */
>  initial_mmu:
> -	tlbia			/* Invalidate all TLB entries */
> -/* Always pin the first 8 MB ITLB to prevent ITLB
> -   misses while mucking around with SRR0/SRR1 in asm
> -*/
> -	lis	r8, MI_RSV4I@h
> -	ori	r8, r8, 0x1c00
> -
> +	lis	r8, MI_RESETVAL@h
>  	mtspr	SPRN_MI_CTR, r8	/* Set instruction MMU control */
>  
> -#ifdef CONFIG_PIN_TLB
> -	lis	r10, (MD_RSV4I | MD_RESETVAL)@h
> -	ori	r10, r10, 0x1c00
> -	mr	r8, r10
> -#else
>  	lis	r10, MD_RESETVAL@h
> -#endif
>  #ifndef CONFIG_8xx_COPYBACK
>  	oris	r10, r10, MD_WTDEF@h
>  #endif
>  	mtspr	SPRN_MD_CTR, r10	/* Set data TLB control */
>  
> +	tlbia			/* Invalidate all TLB entries */

Is this change to make sure we invalidate everything even if the
bootloader set RSV4I?

> +	ori	r8, r8, 0x1c00
> +	mtspr	SPRN_MI_CTR, r8	/* Set instruction MMU control */
> +#ifdef CONFIG_PIN_TLB
> +	ori	r10, r10, 0x1c00
> +	mtspr	SPRN_MD_CTR, r10	/* Set data TLB control */
> +#endif

Still 0x1c00?

>  	/* Now map the lower 8 Meg into the TLBs.  For this quick hack,
>  	 * we can load the instruction and data TLB registers with the
>  	 * same values.
> @@ -825,6 +822,12 @@
>  	mtspr	SPRN_MI_AP, r8
>  	mtspr	SPRN_MD_AP, r8
>  
> +	/* Always pin the first 8 MB ITLB to prevent ITLB
> +	 * misses while mucking around with SRR0/SRR1 in asm
> +	 */
> +	lis	r8, (MI_RSV4I | MI_RESETVAL)@h
> +	mtspr	SPRN_MI_CTR, r8	/* Set instruction MMU control */

Entry 0 is not pinnable.

-Scott



