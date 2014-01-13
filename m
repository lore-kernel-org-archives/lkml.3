Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906AbaAMKqY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 05:46:24 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:58243 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377AbaAMKqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 05:46:20 -0500
Message-ID: <52D3C3EB.6000104@ti.com>
Date: Mon, 13 Jan 2014 16:16:03 +0530
From: Archit Taneja <archit@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>, <tomi.valkeinen@ti.com>
CC: <plagnioj@jcrosoft.com>, <pali.rohar@gmail.com>, <pavel@ucw.cz>,
        <linux-omap@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Ivaylo Dimitrov <freemangordon@abv.bg>
Subject: Re: [PATCH] OMAPDSS: DISPC: Fix 34xx overlay scaling calculation
References: <1389444125-5000-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
In-Reply-To: <1389444125-5000-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.24.145.166]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Saturday 11 January 2014 06:12 PM, Ivaylo Dimitrov wrote:
> From: Ivaylo Dimitrov <freemangordon@abv.bg>
>
> commit 7faa92339bbb1e6b9a80983b206642517327eb75 OMAPDSS: DISPC: Handle
> synclost errors in OMAP3 introduces limits check to prevent SYNCLOST errors
> on OMAP3. However, it misses the logic found in Nokia kernels that is
> needed to correctly calculate whether 3 tap or 5 tap rescaler to be used as
> well as the logic to fallback to 3 taps if 5 taps clock results in too
> tight horizontal timings. Without that patch "horizontal timing too tight"
> errors are seen when a video with resolution above 640x350 is tried to be
> played. The patch is a forward-ported logic found in Nokia N900 and N9/50
> kernels.
>
> Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
> ---
>   drivers/video/omap2/dss/dispc.c |   36 +++++++++++++++++++++++++-----------
>   1 files changed, 25 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/video/omap2/dss/dispc.c b/drivers/video/omap2/dss/dispc.c
> index 67e413e..9d1aa25 100644
> --- a/drivers/video/omap2/dss/dispc.c
> +++ b/drivers/video/omap2/dss/dispc.c
> @@ -1999,7 +1999,8 @@ static void calc_tiler_rotation_offset(u16 screen_width, u16 width,
>    */
>   static int check_horiz_timing_omap3(unsigned long pclk, unsigned long lclk,
>   		const struct omap_video_timings *t, u16 pos_x,
> -		u16 width, u16 height, u16 out_width, u16 out_height)
> +		u16 width, u16 height, u16 out_width, u16 out_height,
> +		bool five_taps)
>   {
>   	const int ds = DIV_ROUND_UP(height, out_height);
>   	unsigned long nonactive;
> @@ -2019,6 +2020,10 @@ static int check_horiz_timing_omap3(unsigned long pclk, unsigned long lclk,
>   	if (blank <= limits[i])
>   		return -EINVAL;
>
> +	/* FIXME add checks for 3-tap filter once the limitations are known */
> +	if (!five_taps)
> +		return 0;
> +
>   	/*
>   	 * Pixel data should be prepared before visible display point starts.
>   	 * So, atleast DS-2 lines must have already been fetched by DISPC
> @@ -2191,24 +2196,33 @@ static int dispc_ovl_calc_scaling_34xx(unsigned long pclk, unsigned long lclk,
>   	const int maxsinglelinewidth =
>   			dss_feat_get_param_max(FEAT_PARAM_LINEWIDTH);
>
> +	*five_taps = height > out_height;
> +

We should consider the decimated height when calculating the five taps. 
I suggest the change below:

>   	do {
>   		in_height = DIV_ROUND_UP(height, *decim_y);
>   		in_width = DIV_ROUND_UP(width, *decim_x);
> -		*core_clk = calc_core_clk_five_taps(pclk, mgr_timings,
> -			in_width, in_height, out_width, out_height, color_mode);
> -
> -		error = check_horiz_timing_omap3(pclk, lclk, mgr_timings,
> -				pos_x, in_width, in_height, out_width,
> -				out_height);
>

set "*five_taps = in_height > out_height;" here. The rest of the code 
remains the same.

>   		if (in_width > maxsinglelinewidth)
>   			if (in_height > out_height &&
>   						in_height < out_height * 2)
>   				*five_taps = false;
> -		if (!*five_taps)
> +again:
> +		if (*five_taps)
> +			*core_clk = calc_core_clk_five_taps(pclk, mgr_timings,
> +						in_width, in_height, out_width,
> +						out_height, color_mode);
> +		else
>   			*core_clk = dispc.feat->calc_core_clk(pclk, in_width,
> -					in_height, out_width, out_height,
> -					mem_to_mem);
> +				in_height, out_width, out_height,
> +				mem_to_mem);
> +
> +		error = check_horiz_timing_omap3(pclk, lclk, mgr_timings,
> +				pos_x, in_width, in_height, out_width,
> +				out_height, *five_taps);
> +		if (error && *five_taps) {
> +			*five_taps = false;
> +			goto again;
> +		}
>
>   		error = (error || in_width > maxsinglelinewidth * 2 ||
>   			(in_width > maxsinglelinewidth && *five_taps) ||
> @@ -2226,7 +2240,7 @@ static int dispc_ovl_calc_scaling_34xx(unsigned long pclk, unsigned long lclk,
>   	} while (*decim_x <= *x_predecim && *decim_y <= *y_predecim && error);
>
>   	if (check_horiz_timing_omap3(pclk, lclk, mgr_timings, pos_x, width,
> -				height, out_width, out_height)){
> +				height, out_width, out_height, *five_taps)) {
>   			DSSERR("horizontal timing too tight\n");
>   			return -EINVAL;
>   	}
>

Thanks,
Archit

