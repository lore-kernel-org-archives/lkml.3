Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580Ab3GVWgs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 18:36:48 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:33910 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab3GVWgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 18:36:45 -0400
X-Auth-Info: zC3O2kvO+jm8uCiyuOUPxsuG/aDtw86H/rK0nJd8dSo=
From: Marek Vasut <marex@denx.de>
To: Hector Palacios <hector.palacios@digi.com>
Subject: Re: [PATCH v3 4/5] iio: mxs-lradc: add scale_available file to channels
Date: Tue, 23 Jul 2013 00:36:41 +0200
User-Agent: KMail/1.13.7 (Linux/3.9-1-amd64; KDE/4.8.4; x86_64; ; )
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        alexandre.belloni@free-electrons.com, jic23@kernel.org,
        lars@metafoo.de, fabio.estevam@freescale.com
References: <1374501843-19651-1-git-send-email-hector.palacios@digi.com> <1374501843-19651-5-git-send-email-hector.palacios@digi.com>
In-Reply-To: <1374501843-19651-5-git-send-email-hector.palacios@digi.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201307230036.42046.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Hector Palacios,

> Adds in_voltageX_scale_available file for every channel to read
> the different available scales.
> There are two scales per channel:
>  [0] = divider_by_two disabled (default)
>  [1] = divider_by_two enabled
> The scale is a struct made of integer and nano parts to build
> a long decimal number.
> 
> Signed-off-by: Hector Palacios <hector.palacios@digi.com>
> ---

[...]

> @@ -1008,6 +1098,26 @@ static int mxs_lradc_probe(struct platform_device
> *pdev) if (ret)
>  		goto err_trig;
> 
> +	/* Populate available ADC input ranges */
> +	for (i = 0; i < LRADC_MAX_TOTAL_CHANS; i++) {
> +		for (s = 0; s < ARRAY_SIZE(lradc->scale_avail[i]); s++) {
> +			/*
> +			 * [s=0] = optional divider by two disabled (default)
> +			 * [s=1] = optional divider by two enabled
> +			 *
> +			 * The scale is calculated by doing:
> +			 *   Vref >> (realbits - s)
> +			 * which multiplies by two on the second component
> +			 * of the array.
> +			 */
> +			scale_uv = ((u64)lradc->vref_mv[i] * 100000000) >>
> +				   (iio->channels[i].scan_type.realbits - s);

Thinking about this, this is basically

            vref_mv[CHANNEL] * 100 000 000
scale_uv = --------------------------------
                      2^(12 - s)

Where s can be either 0 or 1.

Why do you multiply it by 100000000 I don't quite understand, but maybe it's 
fully obvious. It should be documented though.



> +			lradc->scale_avail[i][s].nano =
> +					do_div(scale_uv, 100000000) * 10;

Are we not loosing precission here?

> +			lradc->scale_avail[i][s].integer = scale_uv;
> +		}
> +	}
> +
>  	/* Configure the hardware. */
>  	mxs_lradc_hw_init(lradc);

Best regards,
Marek Vasut
