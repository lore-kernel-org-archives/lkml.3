Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751348Ab3LJWYa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 17:24:30 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:17689
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751028Ab3LJWY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 17:24:29 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(z579ehzbb2dI98dI936eI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098hz2dh2a8h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h1155h)
Message-ID: <1386714253.10013.123.camel@snotra.buserror.net>
Subject: Re: [PATCH v2] powerpc 8xx: Loading kernels over 8Mbytes without
 CONFIG_PIN_TLB
From: Scott Wood <scottwood@freescale.com>
To: Christophe Leroy <christophe.leroy@c-s.fr>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>
Date: Tue, 10 Dec 2013 16:24:13 -0600
In-Reply-To: <20131210112945.E4E311A2BF3@localhost.localdomain>
References: <20131210112945.E4E311A2BF3@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-10 at 12:29 +0100, Christophe Leroy wrote:
> Today, the only way to load kernels whose size is greater than 8Mbytes is to
> activate CONFIG_PIN_TLB. Otherwise, the physical memory initially mapped is
> limited to 8Mbytes. This patch adds the capability to select the size of initial
> memory between 8/16/24 Mbytes and this is regardless of whether CONFIG_PIN_TLB
> is active or not. It allows to load "big" kernels (for instance when activating
> CONFIG_LOCKDEP_SUPPORT) without having to activate CONFIG_PIN_TLB.
> 
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> 
> diff -ur a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -980,6 +980,29 @@
>  config PIN_TLB
>  	bool "Pinned Kernel TLBs (860 ONLY)"
>  	depends on ADVANCED_OPTIONS && 8xx
> +
> +choice
> +	prompt "Initial Data Memory Mapped on 8xx"
> +	default 8xx_MAP_8M
> +	depends on ADVANCED_OPTIONS && 8xx
> +
> +config	8xx_INIT_MAP_8M
> +	bool "8 Mbytes"
> +
> +config	8xx_INIT_MAP_16M
> +	bool "16 Mbytes"
> +
> +config	8xx_INIT_MAP_24M
> +	bool "24 Mbytes"

Are you working with a loader that passes initial-mapped-area size in r7
as per ePAPR?  If so, we could rely on that at runtime.  If you're using
a non-ancient U-Boot, it should qualify here even if it's not fully
ePAPR compliant (it passes the value of the bootm_mapsize variable in
r7).

> -#ifdef CONFIG_PIN_TLB
> +#if defined (CONFIG_8xx_INIT_MAP_16M) || defined (CONFIG_8xx_INIT_MAP_24M)
>  	/* Map two more 8M kernel data pages.
>  	*/
> +#ifdef CONFIG_PIN_TLB
>  	addi	r10, r10, 0x0100
>  	mtspr	SPRN_MD_CTR, r10
> +#endif
>  
>  	lis	r8, KERNELBASE@h	/* Create vaddr for TLB */
>  	addis	r8, r8, 0x0080		/* Add 8M */
> @@ -858,15 +860,19 @@
>  	addis	r11, r11, 0x0080	/* Add 8M */
>  	mtspr	SPRN_MD_RPN, r11
>  
> +#ifdef CONFIG_8xx_INIT_MAP_24M
> +#ifdef CONFIG_PIN_TLB
>  	addi	r10, r10, 0x0100
>  	mtspr	SPRN_MD_CTR, r10
> +#endif

Are these ifdefs for CONFIG_PIN_TLB really needed?  It shouldn't harm
anything to use those entries even if they're not being pinned.
 
-Scott



