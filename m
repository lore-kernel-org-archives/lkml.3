Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbaLAN1X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 08:27:23 -0500
Received: from webbox1416.server-home.net ([77.236.96.61]:42185 "EHLO
	webbox1416.server-home.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753897AbaLAN1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 08:27:19 -0500
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: plagnioj@jcrosoft.com, tomi.valkeinen@ti.com, shawn.guo@linaro.org,
        linux-fbdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] video: fsl-dcfb: Add dcfb framebuffer driver for LS1021A platform
Date: Mon, 01 Dec 2014 14:29:23 +0100
Message-ID: <1645594.e2cfs6JOiv@ws-stein>
User-Agent: KMail/4.12.5 (Linux/3.16.5-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <1416824454-28156-2-git-send-email-Li.Xiubo@freescale.com>
References: <1416824454-28156-1-git-send-email-Li.Xiubo@freescale.com> <1416824454-28156-2-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 24 November 2014 18:20:51, Xiubo Li wrote:
> [...]
> +static int fsl_dcfb_init_fbinfo(struct fb_info *info)
> +{
> +	struct fsl_dcfb_mfb_info *mfbi = info->par;
> +	struct fb_var_screeninfo *var = &info->var;
> +	struct fsl_dcfb_fb_private *dcfb = mfbi->parent;
> +	struct device_node *np = dcfb->dev->of_node;
> +	struct device_node *dnp, *tnp;
> +	struct display_timings *timings;
> +	int i, ret;
> +
> +	dnp = of_parse_phandle(np, "display", 0);
> +	if (!dnp) {
> +		dev_err(dcfb->dev, "failed to find \"display\" phandle.\n");
> +		return -ENODEV;
> +	}
> +
> +	ret = of_property_read_u32(dnp, "bits-per-pixel",
> +				   &var->bits_per_pixel);
> +	if (ret < 0) {
> +		dev_err(dcfb->dev, "failed to get \"bits-per-pixel\" property.\n");
> +		goto put_dnp;
> +	}
> +
> +	timings = of_get_display_timings(dnp);
> +	if (!timings) {
> +		dev_err(dcfb->dev, "failed to get display timings\n");
> +		return -ENODEV;
> +		goto put_dnp;
> +	}
> +
> +	tnp = of_find_node_by_name(dnp, "display-timings");
> +	if (!tnp) {
> +		dev_err(dcfb->dev, "failed to find \"display-timings\" node\n");
> +		return -ENODEV;
> +		goto put_dnp;
> +	}
> +
> +	for (i = 0; i < of_get_child_count(tnp); i++) {
> +		struct videomode vm;
> +		struct fb_videomode fb_vm;
> +
> +		ret = videomode_from_timings(timings, &vm, i);
> +		if (ret < 0)
> +			goto put_tnp;
> +
> +		ret = fb_videomode_from_videomode(&vm, &fb_vm);
> +		if (ret < 0)
> +			goto put_tnp;
> +
> +		fb_add_videomode(&fb_vm, &info->modelist);
> +	}

Adding each display timing to the modelist here...

> [...]
> +	ret = fsl_dcfb_init_fbinfo(info);
> +	if (ret)
> +		goto err_cmap;
> +
> +	modelist = list_first_entry(&info->modelist,
> +			struct fb_modelist, list);
> +	fb_videomode_to_var(&info->var, &modelist->mode);

... and just picking the first here, essentially renders the "native-mode" property in device tree as useless, since only the first in that list is picked (which seems to be the last one inserted).

Best regards,
Alexander
-- 
Dipl.-Inf. Alexander Stein

SYS TEC electronic GmbH
Am Windrad 2
08468 Heinsdorfergrund
Tel.: 03765 38600-1156
Fax: 03765 38600-4100
Email: alexander.stein@systec-electronic.com
Website: www.systec-electronic.com
 
Managing Director: Dipl.-Phys. Siegmar Schmidt
Commercial registry: Amtsgericht Chemnitz, HRB 28082

