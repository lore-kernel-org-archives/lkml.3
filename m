Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189AbbASK6T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 05:58:19 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:37725 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbbASK6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 05:58:17 -0500
Date: Mon, 19 Jan 2015 10:57:53 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, John Crispin <blogic@openwrt.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 4/8] gpio-mm-lantiq: Use of_propery_read_u16
Message-ID: <20150119105753.GC21553@leverpostej>
References: <1421581173-28416-1-git-send-email-ricardo.ribalda@gmail.com>
 <1421581173-28416-5-git-send-email-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421581173-28416-5-git-send-email-ricardo.ribalda@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2015 at 11:39:29AM +0000, Ricardo Ribalda Delgado wrote:
> Instead of parsing manually the shadow content, use the much simpler
> helper of_property_read_u16.
> 
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Alexandre Courbot <gnurou@gmail.com>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: John Crispin <blogic@openwrt.org>
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>  drivers/gpio/gpio-mm-lantiq.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-mm-lantiq.c b/drivers/gpio/gpio-mm-lantiq.c
> index 7d55161..b511a6b 100644
> --- a/drivers/gpio/gpio-mm-lantiq.c
> +++ b/drivers/gpio/gpio-mm-lantiq.c
> @@ -105,7 +105,6 @@ static void ltq_mm_save_regs(struct of_mm_gpio_chip *mm_gc)
>  static int ltq_mm_probe(struct platform_device *pdev)
>  {
>  	struct ltq_mm *chip;
> -	const __be32 *shadow;
>  
>  	chip = devm_kzalloc(&pdev->dev, sizeof(*chip), GFP_KERNEL);
>  	if (!chip)
> @@ -117,9 +116,8 @@ static int ltq_mm_probe(struct platform_device *pdev)
>  	chip->mmchip.save_regs = ltq_mm_save_regs;
>  
>  	/* store the shadow value if one was passed by the devicetree */
> -	shadow = of_get_property(pdev->dev.of_node, "lantiq,shadow", NULL);
> -	if (shadow)
> -		chip->shadow = be32_to_cpu(*shadow);
> +	of_property_read_u16(pdev->dev.of_node, "lantiq,shadow",
> +			     &chip->shadow);

The old code and new code aren't equivalent:

The binding doesn't specify the use of /bits/ 16 <...>, nor does the
only in-tree dts use it:

arch/mips/boot/dts/easy50712.dts:               lantiq,shadow = <0xfff>;

So in the DTB, lantiq-shadow will be stored as a be32 value. The byte
stream will look like: [00 00 0f ff].

The existing code reads all 4 bytes, and converts them as required,
reading the expected value of 0xfff. If you use of_property_read_u16,
this will only take the first 2 bytes, and will incorrectly read 0.

You can instead use of_property_read_u32, which will function
equivalently to the existing code.

Thanks,
Mark.
