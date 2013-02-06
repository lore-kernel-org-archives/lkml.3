Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574Ab3BFAW3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 19:22:29 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:56562 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729Ab3BFAW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 19:22:28 -0500
Message-ID: <5111A23F.50300@wwwdotorg.org>
Date: Tue, 05 Feb 2013 17:22:23 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Sean Paul <seanpaul@chromium.org>
CC: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, dri-devel@lists.freedesktop.org,
        t.stanislaws@samsung.com, kgene.kim@samsung.com,
        linux-kernel@vger.kernel.org, tomasz.figa@gmail.com,
        inki.dae@samsung.com, sylvester.nawrocki@gmail.com, olofj@chromium.org,
        rahul.sharma@samsung.com
Subject: Re: [PATCH v3 1/3] drm/exynos: Get HDMI version from device tree
References: <1360107777-17490-1-git-send-email-seanpaul@chromium.org> <1360107777-17490-2-git-send-email-seanpaul@chromium.org>
In-Reply-To: <1360107777-17490-2-git-send-email-seanpaul@chromium.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

n 02/05/2013 04:42 PM, Sean Paul wrote:
> Use the compatible string in the device tree to determine which
> registers/functions to use in the HDMI driver. Also changes the
> references from v13 to 4210 and v14 to 4212 to reflect the IP
> block version instead of the HDMI version.

> diff --git a/Documentation/devicetree/bindings/drm/exynos/hdmi.txt b/Documentation/devicetree/bindings/drm/exynos/hdmi.txt

Binding looks sane to me.

> diff --git a/drivers/gpu/drm/exynos/exynos_hdmi.c b/drivers/gpu/drm/exynos/exynos_hdmi.c

>  #ifdef CONFIG_OF
>  static struct of_device_id hdmi_match_types[] = {
>  	{
> -		.compatible = "samsung,exynos5-hdmi",
> -		.data	= (void	*)HDMI_TYPE14,
> +		.compatible = "samsung,exynos4-hdmi",
>  	}, {
>  		/* end node */
>  	}

Why not fill in all the "base" compatible values there (I think you need
this anyway so that DTs don't all have to be compatible with
samsung,exynos4-hdmi), with .data containing the HDMI_VER_EXYNOS*
values, then ...

> @@ -2218,17 +2217,18 @@ static int hdmi_probe(struct platform_device *pdev)

> +
> +	if (of_device_is_compatible(dev->of_node, "samsung,exynos4210-hdmi"))
> +		hdata->version |= HDMI_VER_EXYNOS4210;
> +	if (of_device_is_compatible(dev->of_node, "samsung,exynos4212-hdmi"))
> +		hdata->version |= HDMI_VER_EXYNOS4212;
> +	if (of_device_is_compatible(dev->of_node, "samsung,exynos5250-hdmi"))
> +		hdata->version |= HDMI_VER_EXYNOS5250;

Instead of that, do roughly:

    match = of_match_device(hdmi_match_types, &pdev->dev);
    if (match)
        hdata->version |= (int)match->data;

That way, it's all table-based. Any future additions to
hdmi_match_types[] won't require another if statement to be added to
probe().
