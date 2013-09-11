Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408Ab3IKWhN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 18:37:13 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:39210
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751313Ab3IKWhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 18:37:06 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI936eI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275dhz2dh2a8h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h1155h)
Message-ID: <1378939017.12204.409.camel@snotra.buserror.net>
Subject: Re: [PATCH] powerpc 8xx: Fixing issue with CONFIG_PIN_TLB
From: Scott Wood <scottwood@freescale.com>
To: Christophe Leroy <christophe.leroy@c-s.fr>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Date: Wed, 11 Sep 2013 17:36:57 -0500
In-Reply-To: <201309111644.r8BGiuDZ016325@localhost.localdomain>
References: <201309111644.r8BGiuDZ016325@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-09-11 at 18:44 +0200, Christophe Leroy wrote:
> Activating CONFIG_PIN_TLB is supposed to pin the IMMR and the first three
> 8Mbytes pages. But the setting of the MD_CTR was missing so as the index is
> decremented every DTLB update, the pinning of the third 8Mbytes page was
> overwriting the DTLB entry for IMMR.
> 
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> 
> diff -ur linux-3.11.org/arch/powerpc/kernel/head_8xx.S linux-3.11/arch/powerpc/kernel/head_8xx.S
> --- linux-3.11.org/arch/powerpc/kernel/head_8xx.S	2013-09-02 22:46:10.000000000 +0200
> +++ linux-3.11/arch/powerpc/kernel/head_8xx.S	2013-09-09 11:28:54.000000000 +0200
> @@ -862,6 +862,9 @@
>  	addis	r11, r11, 0x0080	/* Add 8M */
>  	mtspr	SPRN_MD_RPN, r11
>  
> +	addi	r10, r10, 0x0100
> +	mtspr	SPRN_MD_CTR, r10
> +
>  	addis	r8, r8, 0x0080		/* Add 8M */
>  	mtspr	SPRN_MD_EPN, r8
>  	mtspr	SPRN_MD_TWC, r9

I wonder why we don't start from entry 31 so we can actually make use of
that autodecrement.  What will happen when we load the first normal TLB
entry later on?  I don't see any setting of SPRN_MD_CTR after this code,
so won't it overwrite entry 30 (the middle 8M) in the CONFIG_PIN_TLB
case?

Ben, would patches like this be considered bugfixes as far as merging
goes, or would they be for next given that it's something that's never
really worked right and hasn't been touched in years?

-Scott



