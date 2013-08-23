Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243Ab3HWLJL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 07:09:11 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:39501 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630Ab3HWLJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 07:09:08 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Wei Yongjun <weiyj.lk@gmail.com>, yongjun_wei@trendmicro.com.cn
Cc: airlied@linux.ie, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] drm/rcar-du: fix return value check in rcar_du_lvdsenc_get_resources()
Date: Fri, 23 Aug 2013 13:10:23 +0200
Message-ID: <4578030.6vjUEPXppL@avalon>
User-Agent: KMail/4.10.5 (Linux/3.8.13-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAPgLHd9g4DPmTnj1bNcUQigUd3pWKfkbAoFFsig5_UR_w0vcAg@mail.gmail.com>
References: <CAPgLHd9g4DPmTnj1bNcUQigUd3pWKfkbAoFFsig5_UR_w0vcAg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Friday 23 August 2013 10:21:21 Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> In case of error, the function devm_ioremap_resource() returns ERR_PTR()
> and never returns NULL. The NULL test in the return value check should be
> replaced with IS_ERR(). Also remove the dev_err call to avoid redundant
> error message.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Thank you for the patch.

> ---
>  drivers/gpu/drm/rcar-du/rcar_du_lvdsenc.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/gpu/drm/rcar-du/rcar_du_lvdsenc.c
> b/drivers/gpu/drm/rcar-du/rcar_du_lvdsenc.c index a0f6a17..f59cbc4 100644
> --- a/drivers/gpu/drm/rcar-du/rcar_du_lvdsenc.c
> +++ b/drivers/gpu/drm/rcar-du/rcar_du_lvdsenc.c
> @@ -151,11 +151,8 @@ static int rcar_du_lvdsenc_get_resources(struct
> rcar_du_lvdsenc *lvds, }
> 
>  	lvds->mmio = devm_ioremap_resource(&pdev->dev, mem);

devm_ioremap_resource() prints an error message when the second argument is 
NULL, so we can remove the error check after the 
platform_get_resource_byname() call as well. The resulting code could look 
like

        mem = platform_get_resource_byname(pdev, IORESOURCE_MEM, name);
        lvds->mmio = devm_ioremap_resource(&pdev->dev, mem);
        if (IS_ERR(lvds->mmio))
                return PTR_ERR(lvds->mmio);

Could you please submit a v2 ?

> -	if (lvds->mmio == NULL) {
> -		dev_err(&pdev->dev, "failed to remap memory resource for %s\n",
> -			name);
> -		return -ENOMEM;
> -	}
> +	if (IS_ERR(lvds->mmio))
> +		return PTR_ERR(lvds->mmio);
> 
>  	lvds->clock = devm_clk_get(&pdev->dev, name);
>  	if (IS_ERR(lvds->clock)) {
-- 
Regards,

Laurent Pinchart

