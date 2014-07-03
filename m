Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759171AbaGCRvp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 13:51:45 -0400
Received: from p01c11o141.mxlogic.net ([208.65.144.64]:34934 "EHLO
	p01c11o141.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbaGCRvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 13:51:43 -0400
X-MXL-Hash: 53b5982f4b9d8e4e-e80afa6c621f15338be8746946bf132a08b8cea1
X-MXL-Hash: 53b597b116f0f2d6-06a96abf051ce09f343549b15c8d5c04a940d114
Date: Thu, 3 Jul 2014 13:49:29 -0400
From: Joe Lawrence <joe.lawrence@stratus.com>
X-X-Sender: jlaw@jlaw-desktop.mno.stratus.com
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
CC: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, <DL-MPTFusionLinux@lsi.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers: message: fusion: Simplify rounding
In-Reply-To: <1404219380-2712-1-git-send-email-linux@rasmusvillemoes.dk>
Message-ID: <alpine.DEB.2.02.1407031300280.9641@jlaw-desktop.mno.stratus.com>
References: <1404219380-2712-1-git-send-email-linux@rasmusvillemoes.dk>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [134.111.199.152]
X-AnalysisOut: [v=2.1 cv=FuCL/gbq c=1 sm=1 tr=0 a=VNTQBUOG7PJoPU2GWtE7Ww==]
X-AnalysisOut: [:117 a=VNTQBUOG7PJoPU2GWtE7Ww==:17 a=nXGuE6rTyBAA:10 a=Wz6]
X-AnalysisOut: [OvkS5RLgA:10 a=_KQqW7t0BisA:10 a=CdzKgOd8jloA:10 a=BLceEmw]
X-AnalysisOut: [cHowA:10 a=kj9zAlcOel0A:10 a=uelBKuKpAAAA:8 a=YlVTAMxIAAAA]
X-AnalysisOut: [:8 a=VwQbUJbxAAAA:8 a=vcr42lU8XPD7nsxI_OUA:9 a=CjuIK1q_8ug]
X-AnalysisOut: [A:10 a=x8gzFH9gYPwA:10 a=kSViFEBMy1sA:10]
X-Spam: [F=0.5000000000; CM=0.500; MH=0.500(2014070310); S=0.200(2014051901)]
X-MAIL-FROM: <joe.lawrence@stratus.com>
X-SOURCE-IP: [134.111.1.17]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ALIGN is certainly more readable to me.

Reviewed-by: Joe Lawrence <joe.lawrence@stratus.com>

-- Joe

On Tue, 1 Jul 2014, Rasmus Villemoes wrote:

> Rounding up to a multiple of 4 should be done using the ALIGN
> macro. As a bonus, this also makes the generated code smaller.
> 
> In GetIocFacts(), sz is assigned to a few lines below without being
> read in the meantime, so it is ok that it doesn't end up with the same
> value as facts->FWImageSize.
> 
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> ---
>  drivers/message/fusion/mptbase.c | 7 +------
>  drivers/message/fusion/mptctl.c  | 7 +------
>  2 files changed, 2 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
> index ebc0af7..10b16a1 100644
> --- a/drivers/message/fusion/mptbase.c
> +++ b/drivers/message/fusion/mptbase.c
> @@ -3175,12 +3175,7 @@ GetIocFacts(MPT_ADAPTER *ioc, int sleepFlag, int reason)
>  			facts->FWImageSize = le32_to_cpu(facts->FWImageSize);
>  		}
>  
> -		sz = facts->FWImageSize;
> -		if ( sz & 0x01 )
> -			sz += 1;
> -		if ( sz & 0x02 )
> -			sz += 2;
> -		facts->FWImageSize = sz;
> +		facts->FWImageSize = ALIGN(facts->FWImageSize, 4);
>  
>  		if (!facts->RequestFrameSize) {
>  			/*  Something is wrong!  */
> diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
> index 8a050e8..1004392 100644
> --- a/drivers/message/fusion/mptctl.c
> +++ b/drivers/message/fusion/mptctl.c
> @@ -1749,12 +1749,7 @@ mptctl_replace_fw (unsigned long arg)
>  
>  	/* Allocate memory for the new FW image
>  	 */
> -	newFwSize = karg.newImageSize;
> -
> -	if (newFwSize & 0x01)
> -		newFwSize += 1;
> -	if (newFwSize & 0x02)
> -		newFwSize += 2;
> +	newFwSize = ALIGN(karg.newImageSize, 4);
>  
>  	mpt_alloc_fw_memory(ioc, newFwSize);
>  	if (ioc->cached_fw == NULL)
> -- 
> 1.9.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
