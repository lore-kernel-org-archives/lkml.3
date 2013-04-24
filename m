Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255Ab3DXAA7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 20:00:59 -0400
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:19707
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753368Ab3DXAA6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 20:00:58 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839h944hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h16a6h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
Date: Tue, 23 Apr 2013 19:00:49 -0500
From: Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCH v2 13/15] powerpc/85xx: add support for e6500 L1 cache
 operation
To: Zhao Chenhui <chenhui.zhao@freescale.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
References: <1366368468-29143-1-git-send-email-chenhui.zhao@freescale.com>
	<1366368468-29143-13-git-send-email-chenhui.zhao@freescale.com>
In-Reply-To: <1366368468-29143-13-git-send-email-chenhui.zhao@freescale.com>
	(from chenhui.zhao@freescale.com on Fri Apr 19 05:47:46 2013)
X-Mailer: Balsa 2.4.12
Message-ID: <1366761649.5825.20@snotra>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; delsp=Yes; format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2013 05:47:46 AM, Zhao Chenhui wrote:
> From: Chen-Hui Zhao <chenhui.zhao@freescale.com>
> 
> The L1 Data Cache of e6500 contains no modified data, no flush
> is required.
> 
> Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
> Signed-off-by: Li Yang <leoli@freescale.com>
> Signed-off-by: Andy Fleming <afleming@freescale.com>
> ---
>  arch/powerpc/kernel/fsl_booke_cache.S |   11 ++++++++++-
>  1 files changed, 10 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/fsl_booke_cache.S  
> b/arch/powerpc/kernel/fsl_booke_cache.S
> index 232c47b..24a52bb 100644
> --- a/arch/powerpc/kernel/fsl_booke_cache.S
> +++ b/arch/powerpc/kernel/fsl_booke_cache.S
> @@ -65,13 +65,22 @@ _GLOBAL(flush_dcache_L1)
> 
>  	blr
> 
> +#define PVR_E6500	0x8040
> +
>  /* Flush L1 d-cache, invalidate and disable d-cache and i-cache */
>  _GLOBAL(__flush_disable_L1)
> +/* L1 Data Cache of e6500 contains no modified data, no flush is  
> required */
> +	mfspr	r3, SPRN_PVR
> +	rlwinm	r4, r3, 16, 0xffff
> +	lis	r5, 0
> +	ori	r5, r5, PVR_E6500@l
> +	cmpw	r4, r5
> +	beq	2f
>  	mflr	r10
>  	bl	flush_dcache_L1	/* Flush L1 d-cache */
>  	mtlr	r10
> 
> -	msync
> +2:	msync
>  	mfspr	r4, SPRN_L1CSR0	/* Invalidate and disable d-cache */
>  	li	r5, 2
>  	rlwimi	r4, r5, 0, 3

Note that disabling the cache is a core operation, rather than a thread  
operation.  Is this only called when the second thread is disabled?

-Scott
