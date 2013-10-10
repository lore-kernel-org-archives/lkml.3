Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861Ab3JJKej (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 06:34:39 -0400
Received: from demumfd002.nsn-inter.net ([93.183.12.31]:14612 "EHLO
	demumfd002.nsn-inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab3JJKeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 06:34:37 -0400
Message-ID: <525682B5.20102@nsn.com>
Date: Thu, 10 Oct 2013 12:34:29 +0200
From: Alexander Sverdlin <alexander.sverdlin@nsn.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Ionut Nicu <ioan.nicu.ext@nsn.com>,
        Peter Korsgaard <peter.korsgaard@barco.com>
CC: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] i2c-mux-gpio: eliminate i2c channel order assumptions
References: <525667CA.3030504@nsn.com>
In-Reply-To: <525667CA.3030504@nsn.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-purgate-type: clean
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: clean
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate-size: 2652
X-purgate-ID: 151667::1381401270-00005753-40BEC738/0-0/0-0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On 10/10/2013 10:39 AM, Ionut Nicu wrote:
> The i2c-mux driver uses the chan_id parameter provided
> in i2c_add_mux_adapter as a parameter to the select
> and deselect callbacks while the i2c-mux-gpio driver
> uses the chan_id as an index in the mux->data.values
> array.
> 
> A simple example of where this doesn't work is when we
> have a device tree like this:
> 
> i2cmux {
> 	i2c@1 {
> 		reg = <1>;
> 		...
> 	};
> 
> 	i2c@0 {
> 		reg = <0>;
> 		...
> 	};
> };
> 
> The mux->data.values array will be { 1, 0 }, but when
> the i2-mux driver will try to select channel 0, the
> i2c-mux-gpio driver will actually use values[0], hence 1
> as the gpio selection value.

The patch itself is correct, but the description is not precise,
I suppose... i2c-mux-gpio is consistent inside itself, it will
receive for every child adapter the value it has configured.
The problem happens inside i2c-mux.c, i2c_add_mux_adapter():

               	for_each_child_of_node(mux_dev->of_node, child) {
                       	ret = of_property_read_u32(child, "reg", &reg);
                       	if (ret)
                               	continue;
                       	if (chan_id == reg) {
                               	priv->adap.dev.of_node = child;

Which means, i2c-mux-gpio MUST pass reg, not its logical index inside
array. Otherwise node will not be correctly assigned and i2c-mux will
have problems selecting right adapter for the multiplexed devices.

> Signed-off-by: Ionut Nicu <ioan.nicu.ext@nsn.com>

So, for the code itself

Acked-by: Alexander Sverdlin <alexander.sverdlin@nsn.com>

> ---
>  drivers/i2c/muxes/i2c-mux-gpio.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/i2c/muxes/i2c-mux-gpio.c b/drivers/i2c/muxes/i2c-mux-gpio.c
> index b5f17ef..3505d0e 100644
> --- a/drivers/i2c/muxes/i2c-mux-gpio.c
> +++ b/drivers/i2c/muxes/i2c-mux-gpio.c
> @@ -43,7 +43,7 @@ static int i2c_mux_gpio_select(struct i2c_adapter *adap, void *data, u32 chan)
>  {
>  	struct gpiomux *mux = data;
>  
> -	i2c_mux_gpio_set(mux, mux->data.values[chan]);
> +	i2c_mux_gpio_set(mux, chan);
>  
>  	return 0;
>  }
> @@ -233,7 +233,7 @@ static int i2c_mux_gpio_probe(struct platform_device *pdev)
>  		unsigned int class = mux->data.classes ? mux->data.classes[i] : 0;
>  
>  		mux->adap[i] = i2c_add_mux_adapter(parent, &pdev->dev, mux, nr,
> -						   i, class,
> +						   mux->data.values[i], class,
>  						   i2c_mux_gpio_select, deselect);
>  		if (!mux->adap[i]) {
>  			ret = -ENODEV;
> 

-- 
Best regards,
Alexander Sverdlin.
