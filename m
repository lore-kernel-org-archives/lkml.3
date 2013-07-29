Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163Ab3G2JUt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 05:20:49 -0400
Received: from smtp1-1.goneo.de ([212.90.139.81]:44694 "EHLO smtp1-1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778Ab3G2JUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 05:20:47 -0400
X-Greylist: delayed 619 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Jul 2013 05:20:47 EDT
X-Spam-Flag: NO
X-Spam-Score: -2.891
From: Lars Poeschel <poeschel@lemonage.de>
To: "Daniel M. Weeks" <dan@danweeks.net>
Subject: Re: gpio-mcp23s08: i2c: auto-select base if no DT match or platform data
Date: Mon, 29 Jul 2013 11:10:19 +0200
User-Agent: KMail/1.13.7 (Linux/3.9-1-amd64; KDE/4.8.4; x86_64; ; )
Cc: Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
References: <20130719041952.GA29001@dev.danweeks.net>
In-Reply-To: <20130719041952.GA29001@dev.danweeks.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201307291110.19990.poeschel@lemonage.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 July 2013 at 06:19:58, Daniel M. Weeks wrote:
> The call to gpiochip_add made by this driver is capable of
> auto-selecting a base if one is not provided. However, it was not
> called unless there was already a DT entry or platform data. This patch
> calls it even if the base is not already known so that gpiochip_add can
> attempt to find a usable base.

Nitpick:
You describe what your patch changes in the commit message. This is good, 
but I can see the changes looking at the code. Can you please add a few 
lines describing WHY your patch is needed ? (That'd be to be able to 
instantiate a device from userspace with sysfs, right ?)

The code is ok, so with a modified commit message feel free to add my

Acked-by: Lars Poeschel <poeschel@lemonage.de>

> Signed-off-by: Daniel M. Weeks <dan@danweeks.net>
> 
> ---
> drivers/gpio/gpio-mcp23s08.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-mcp23s08.c b/drivers/gpio/gpio-mcp23s08.c
> index 6a4470b..87ed6bf 100644
> --- a/drivers/gpio/gpio-mcp23s08.c
> +++ b/drivers/gpio/gpio-mcp23s08.c
> @@ -520,14 +520,13 @@ static int mcp230xx_probe(struct i2c_client
> *client,
> 
>  	match = of_match_device(of_match_ptr(mcp23s08_i2c_of_match),
>  					&client->dev);
> -	if (match) {
> +	pdata = client->dev.platform_data;
> +	if (match || !pdata) {
>  		base = -1;
>  		pullups = 0;
>  	} else {
> -		pdata = client->dev.platform_data;
> -		if (!pdata || !gpio_is_valid(pdata->base)) {
> -			dev_dbg(&client->dev,
> -					"invalid or missing platform data\n");
> +		if (!gpio_is_valid(pdata->base)) {
> +			dev_dbg(&client->dev, "invalid platform data\n");
>  			return -EINVAL;
>  		}
>  		base = pdata->base;

Thanks,
Lars

