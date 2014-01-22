Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226AbaAVLVf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 06:21:35 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:51601 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753419AbaAVLVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 06:21:32 -0500
Date: Wed, 22 Jan 2014 11:20:55 +0000
From: Will Deacon <will.deacon@arm.com>
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "patches@linaro.org" <patches@linaro.org>,
        "roy.franz@linaro.org" <roy.franz@linaro.org>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "msalter@redhat.com" <msalter@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 2/5] arm: add new asm macro update_sctlr
Message-ID: <20140122112055.GF1621@mudshark.cambridge.arm.com>
References: <1389445524-30623-1-git-send-email-leif.lindholm@linaro.org>
 <1389445524-30623-3-git-send-email-leif.lindholm@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389445524-30623-3-git-send-email-leif.lindholm@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 11, 2014 at 01:05:21PM +0000, Leif Lindholm wrote:
> A new macro for setting/clearing bits in the SCTLR.
> 
> Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
> Suggested-by: Will Deacon <will.deacon@arm.com>
> ---
>  arch/arm/include/asm/assembler.h |   13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/arch/arm/include/asm/assembler.h b/arch/arm/include/asm/assembler.h
> index 5c22851..aba6458 100644
> --- a/arch/arm/include/asm/assembler.h
> +++ b/arch/arm/include/asm/assembler.h
> @@ -383,4 +383,17 @@ THUMB(	orr	\reg , \reg , #PSR_T_BIT	)
>  #endif
>  	.endm
>  
> +#ifdef CONFIG_CPU_CP15
> +/* Macro for setting/clearing bits in sctlr */
> +	.macro update_sctlr, set:req, clear:req, tmp:req, tmp2:req
> +	mrc	p15, 0, \tmp, c1, c0, 0
> +	ldr	\tmp2, =\set
> +	orr	\tmp, \tmp, \tmp2
> +	ldr	\tmp2, =\clear
> +	mvn	\tmp2, \tmp2
> +	and	\tmp, \tmp, \tmp2
> +	mcr	p15, 0, \tmp, c1, c0, 0

I think this would be cleaner if you force the caller to put set and clear
into registers beforehand, rather than have to do the literal load every
time. Also, I don't think set and clear should be required (and then you can
lose tmp2 as well).

Will
