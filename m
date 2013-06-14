Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616Ab3FNXXg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 19:23:36 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:36623 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257Ab3FNXXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 19:23:34 -0400
Message-ID: <51BBA5E5.9070202@mentor.com>
Date: Sat, 15 Jun 2013 08:23:17 +0900
From: Jiada Wang <jiada_wang@mentor.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Alexander Shiyan <shc_work@mail.ru>
CC: <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <devel@driverdev.osuosl.org>, Sascha Hauer <s.hauer@pengutronix.de>,
        <linux-arm-kernel@lists.infradead.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: Re: [RFC] Staging: imx-drm: Do not use fractional part of divider
References: <1371195670.904413971@f400.i.mail.ru>
In-Reply-To: <1371195670.904413971@f400.i.mail.ru>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jun 2013 23:23:29.0011 (UTC) FILETIME=[2D665C30:01CE6956]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Alexander


Alexander Shiyan wrote:
> Hello.
>
> Analysis of driver imx-drm led me to believe that the use fractional part of the divider is not always a good idea.
> For example, for a parallel display bus connected to LVDS converter chip (DS90C363), in this case the use of
> fractional part, clock will unstable and the on-chip PLL is not working properly, or rather, does not work at all.
>
> Let me give a specific example.
> ipu_crtc_mode_set 0x36314752
> imx-ipuv3 40000000.ipu: clk_di_round_rate: inrate: 133000000 div: 0x00000035 outrate: 40150928 wanted: 40000000
> imx-ipuv3 40000000.ipu: clk_di_round_rate: inrate: 133000000 div: 0x00000035 outrate: 40150928 wanted: 40150928
> imx-ipuv3 40000000.ipu: clk_di_set_rate: inrate: 133000000 desired: 40150928 div: 0x00000035
>
> In this case the divider is 3.5, that result to clock is incorrect. See an attached oscillogram F0000TEK.jpg.
>
> After a patch the clocks is OK. Patch just uncomment some FSL code.
> imx-ipuv3 40000000.ipu: clk_di_round_rate: inrate: 133000000 div: 0x00000040 outrate: 33250000 wanted: 40000000
> imx-ipuv3 40000000.ipu: clk_di_round_rate: inrate: 133000000 div: 0x00000040 outrate: 33250000 wanted: 33250000
> imx-ipuv3 40000000.ipu: clk_di_set_rate: inrate: 133000000 desired: 33250000 div: 0x00000040
>
> See an attached oscillogram F0001TEK.jpg.
>
> So, I want to review this from developers and wait for comments.
>
>

Recently I am also looking at use of fractional part of CLKGEN0,
and want to discuss with you some information I found.

in our code we are using external PLL to drive DI pixel clock, although 
I haven't checked with oscilloscope, but it's apparently fractional part 
of CLKGEN0 doesn't work properly as it is described in reference manual. 
After some investigation I found 0x8 (0.5) seems works fine.

Our solution is try to set DI pixel clock's root clock to integer times 
of clk_di_pixel as close as possible, so that we can avoid using 
fractional part to get desired clock. if Pll -> ipu_di_podf could not 
provide the clock close enough, then try to set it to X.5 times of DI 
pixel clock, then only the "proved" 0x8 of fractional part will be used.

> diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-di.c b/drivers/stagineg/imx-drm/ipu-v3/ipu-di.c
> index 19d777e..d424c22 100644
> --- a/drivers/staging/imx-drm/ipu-v3/ipu-di.c
> +++ b/drivers/staging/imx-drm/ipu-v3/ipu-di.c
> @@ -154,22 +154,15 @@ static int ipu_di_clk_calc_div(unsigned long inrate, unsigned long outrate)
>
>   	if (div < 0x10)
>   		div = 0x10;
> -
> -#ifdef WTF_IS_THIS
> -	/*
> -	 * Freescale has this in their Kernel. It is neither clear what
> -	 * it does nor why it does it
> -	 */
> -	if (div & 0x10)
> -		div &= ~0x7;
>   	else {
>   		/* Round up divider if it gets us closer to desired pix clk */
> -		if ((div & 0xC) == 0xC) {
> +		if (div & 0x0f) {
>   			div += 0x10;
> -			div &= ~0xF;
> +			/* Strip fractional part of divider */
> +			div &= ~0x0f;
If div = 0x11, and the display is not forgiving enough, the pixel clock 
will probably not be accepted by it.

thanks,
jiada
>   		}
>   	}
> -#endif
> +
>   	return div;
>   }
>
>
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>

