Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839Ab3BXIss (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 03:48:48 -0500
Received: from softlayer.compulab.co.il ([50.23.254.55]:49841 "EHLO
	compulab.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754478Ab3BXIsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 03:48:47 -0500
Message-ID: <5129D3E6.5040409@compulab.co.il>
Date: Sun, 24 Feb 2013 10:48:38 +0200
From: Igor Grinberg <grinberg@compulab.co.il>
Organization: CompuLab Ltd.
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130123 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
CC: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com
Subject: Re: [PATCH V2] rtc: rtc-v3020: use gpio_request_array()
References: <00cb01ce100d$dc282200$94786600$%han@samsung.com> <008a01ce10a3$02d28db0$0877a910$%han@samsung.com>
In-Reply-To: <008a01ce10a3$02d28db0$0877a910$%han@samsung.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Get-Message-Sender-Via: softlayer.compulab.co.il: acl_c_relayhosts_text_entry: grinberg@compulab.co.il|compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/22/13 04:19, Jingoo Han wrote:
> Using gpio_request_array()/gpio_free_array() can make the code
> simpler because it can set the direction and initial value
> in one shot and the for loop is unnecessary.
> 
> Also, struct v3020_gpio is removed, because the struct v3020_gpio
> is replaced with struct gpio.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
> Changes since v1:
> - Replace gpio_request_one() with gpio_request_array()

Thanks for addressing this!
It looks much better now, although one comment below.

> 
>  drivers/rtc/rtc-v3020.c |   37 ++++++++++++-------------------------
>  1 files changed, 12 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/rtc/rtc-v3020.c b/drivers/rtc/rtc-v3020.c
> index bca5d67..600798c 100644
> --- a/drivers/rtc/rtc-v3020.c
> +++ b/drivers/rtc/rtc-v3020.c

[...]

> @@ -107,48 +102,40 @@ static struct v3020_chip_ops v3020_mmio_ops = {
>  	.write_bit	= v3020_mmio_write_bit,
>  };
>  
> -static struct v3020_gpio v3020_gpio[] = {
> -	{ "RTC CS", 0 },
> -	{ "RTC WR", 0 },
> -	{ "RTC RD", 0 },
> -	{ "RTC IO", 0 },
> +static struct gpio v3020_gpio[] = {
> +	{ 0, GPIOF_OUT_INIT_HIGH, "RTC CS"},
> +	{ 0, GPIOF_OUT_INIT_HIGH, "RTC WR"},
> +	{ 0, GPIOF_OUT_INIT_HIGH, "RTC RD"},
> +	{ 0, GPIOF_OUT_INIT_HIGH, "RTC IO"},
>  };
>  
>  static int v3020_gpio_map(struct v3020 *chip, struct platform_device *pdev,
>  			  struct v3020_platform_data *pdata)
>  {
> -	int i, err;
> +	int err;
>  
>  	v3020_gpio[V3020_CS].gpio = pdata->gpio_cs;
>  	v3020_gpio[V3020_WR].gpio = pdata->gpio_wr;
>  	v3020_gpio[V3020_RD].gpio = pdata->gpio_rd;
>  	v3020_gpio[V3020_IO].gpio = pdata->gpio_io;
>  
> -	for (i = 0; i < ARRAY_SIZE(v3020_gpio); i++) {
> -		err = gpio_request(v3020_gpio[i].gpio, v3020_gpio[i].name);
> -		if (err)
> -			goto err_request;
> -
> -		gpio_direction_output(v3020_gpio[i].gpio, 1);
> -	}
> +	err = gpio_request_array(v3020_gpio, ARRAY_SIZE(v3020_gpio));
> +	if (err)
> +		goto err_request;
>  
>  	chip->gpio = v3020_gpio;
>  
>  	return 0;
>  
>  err_request:
> -	while (--i >= 0)
> -		gpio_free(v3020_gpio[i].gpio);
> +	gpio_free_array(v3020_gpio, ARRAY_SIZE(v3020_gpio));

Once you use the gpio_request_array(), you don't need to care
about the error.
If gpio_request_array() fails, it does the roll back for you.
So, you just need to return err and remove the whole err_request label.

>  
>  	return err;
>  }
>  
>  static void v3020_gpio_unmap(struct v3020 *chip)
>  {
> -	int i;
> -
> -	for (i = 0; i < ARRAY_SIZE(v3020_gpio); i++)
> -		gpio_free(v3020_gpio[i].gpio);
> +	gpio_free_array(v3020_gpio, ARRAY_SIZE(v3020_gpio));
>  }
>  
>  static void v3020_gpio_write_bit(struct v3020 *chip, unsigned char bit)
> 

-- 
Regards,
Igor.
