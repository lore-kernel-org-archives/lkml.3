Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045AbaHSOkr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 10:40:47 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:54937 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752198AbaHSOkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 10:40:45 -0400
Date: Tue, 19 Aug 2014 15:40:32 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pawel Moll <Pawel.Moll@arm.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] video: ARM CLCD: Ensure bits-per-pixel is a power of 2
	and <= 32
Message-ID: <20140819144032.GD30401@n2100.arm.linux.org.uk>
References: <1408453651.3746.41.camel@linaro1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1408453651.3746.41.camel@linaro1.home>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 02:07:31PM +0100, Jon Medhurst (Tixy) wrote:
> If the device-tree specifies a max-memory-bandwidth property then
> the CLCD driver uses that to calculate the bits-per-pixel supported,
> however, it doesn't ensure that the result is a sane value, i.e. a
> power of 2 and <= 32 as the rest of the code assumes.
> 
> Acked-by: Pawel Moll <pawel.moll@arm.com>
> Signed-off-by: Jon Medhurst <tixy@linaro.org>
> ---
> 
> This fixes code which is new in 3.17 (commit d10715be03) and so I assume
> is a candidate for adding to a coming -rc ? Without the fix, people can
> be left (as I was) with a blank non-functioning screen even if they
> create a valid device-tree for the new driver functionality.
> 
>  drivers/video/fbdev/amba-clcd.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/video/fbdev/amba-clcd.c b/drivers/video/fbdev/amba-clcd.c
> index beadd3e..98b66b7 100644
> --- a/drivers/video/fbdev/amba-clcd.c
> +++ b/drivers/video/fbdev/amba-clcd.c
> @@ -24,6 +24,7 @@
>  #include <linux/list.h>
>  #include <linux/amba/bus.h>
>  #include <linux/amba/clcd.h>
> +#include <linux/bitops.h>
>  #include <linux/clk.h>
>  #include <linux/hardirq.h>
>  #include <linux/dma-mapping.h>
> @@ -650,6 +651,7 @@ static int clcdfb_of_init_display(struct clcd_fb *fb)
>  {
>  	struct device_node *endpoint;
>  	int err;
> +	int bpp;
>  	u32 max_bandwidth;
>  	u32 tft_r0b0g0[3];
>  
> @@ -667,11 +669,15 @@ static int clcdfb_of_init_display(struct clcd_fb *fb)
>  
>  	err = of_property_read_u32(fb->dev->dev.of_node, "max-memory-bandwidth",
>  			&max_bandwidth);
> -	if (!err)
> -		fb->panel->bpp = 8 * max_bandwidth / (fb->panel->mode.xres *
> +	if (!err) {
> +		bpp = 8 * max_bandwidth / (fb->panel->mode.xres *
>  				fb->panel->mode.yres * fb->panel->mode.refresh);

This calculation is wrong in any case - this is the naïeve calculation
which assumes that the bandwidth is:

	x * y * (bpp / 8) * refresh

That isn't the maximum bandwidth, it's the average bandwidth across a
full frame.

If we're interested in limiting the maximum bandwidth, because the
hardware can't cope with fetching the data above a certain rate, then
we need a different method.

We know the pixel rate.  We know how many memory bits are fetched for
each pixel.  So:

	peak_bandwidth = pixel_clock * bpp / 8

Let's take 32bpp, 1024x768@60Hz, which has a pixel clock of 65MHz.  Using
the first, we get:

	1024 * 768 * 4 * 60 = 180MiB/s.

Using the second:

	65 * 4 = 248MiB/s.

To see why there's this discrepency, realise that there's 320 clocks where
there's no pixel activity (so no memory fetches) per line, and 38 lines
where there are no memory fetches.  That's 320 * 768 + 1344 * 38 = 296832
pixel clocks where there's no memory fetches, out of a total of 1344 * 806
= 1083264 total pixel clocks in a frame.  So, that's about 27% of the frame
where the memory subsystem is inactive - which accounts for the difference
in the above figure.

So, if you are limiting the bandwidth of the mode due to the available bus
bandwidth to the controller (which is implied by the property name), then
you want to use the second equation to limit the peak bandwidth, and not
the average bandwidth.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
