Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763852AbbA2DOB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:14:01 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:59984 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757063AbbA2DN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 22:13:58 -0500
Message-ID: <54C8EBB2.10101@linaro.org>
Date: Wed, 28 Jan 2015 14:01:22 +0000
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>
CC: devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-mmc@vger.kernel.org, Doug Anderson <dianders@chromium.org>,
        linux-kernel@vger.kernel.org, Kukjin Kim <kgene@kernel.org>,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/5] mmc: pwrseq_simple: Extend to support more pins
References: <1422439819-29854-1-git-send-email-javier.martinez@collabora.co.uk> <1422439819-29854-3-git-send-email-javier.martinez@collabora.co.uk>
In-Reply-To: <1422439819-29854-3-git-send-email-javier.martinez@collabora.co.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Javier,

You are in a lead of 3 hrs from me..
Surprisingly I send very much same patch just few Mins ago :-)
May be we can merge goods in both :-)

On 28/01/15 10:10, Javier Martinez Canillas wrote:
> Many WLAN attached to a SDIO/MMC interface, needs more than one pin for
> their reset sequence. For example, is very common for chips to have two
> pins: one for reset and one for power enable.
>
> This patch adds support for more reset pins to the pwrseq_simple driver
> and instead hardcoding a fixed number, it uses the of_gpio_named_count()
> since the MMC power sequence is only built when CONFIG_OF is enabled.
>
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> ---
>   drivers/mmc/core/pwrseq_simple.c | 54 ++++++++++++++++++++++++++++++----------
>   1 file changed, 41 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/mmc/core/pwrseq_simple.c b/drivers/mmc/core/pwrseq_simple.c
> index 0958c696137f..9e51fe1051c5 100644
> --- a/drivers/mmc/core/pwrseq_simple.c
> +++ b/drivers/mmc/core/pwrseq_simple.c
> @@ -11,6 +11,7 @@
>   #include <linux/slab.h>
>   #include <linux/device.h>
>   #include <linux/err.h>
> +#include <linux/of_gpio.h>
>   #include <linux/gpio/consumer.h>
>
>   #include <linux/mmc/host.h>
> @@ -19,34 +20,44 @@
>
>   struct mmc_pwrseq_simple {
>   	struct mmc_pwrseq pwrseq;
> -	struct gpio_desc *reset_gpio;
> +	struct gpio_desc **reset_gpio;

May be renaming it to reset_gpios makes more sense..

If you make this struct gpio_desc *reset_gpios[0]; You can aviod an 
extra kmalloc and free ..


> +	int nr_gpios;
>   };
>
>   static void mmc_pwrseq_simple_pre_power_on(struct mmc_host *host)
>   {

[...
>   	struct mmc_pwrseq_simple *pwrseq = container_of(host->pwrseq,
>   					struct mmc_pwrseq_simple, pwrseq);
> +	int i;
>
> -	if (!IS_ERR(pwrseq->reset_gpio))
> -		gpiod_set_value_cansleep(pwrseq->reset_gpio, 1);
> +	for (i = 0; i < pwrseq->nr_gpios; i++)
> +		if (!IS_ERR(pwrseq->reset_gpio[i]))
> +			gpiod_set_value_cansleep(pwrseq->reset_gpio[i], 1);

...]

>   }
>
>   static void mmc_pwrseq_simple_post_power_on(struct mmc_host *host)
>   {

[...

>   	struct mmc_pwrseq_simple *pwrseq = container_of(host->pwrseq,
>   					struct mmc_pwrseq_simple, pwrseq);
> +	int i;
>
> -	if (!IS_ERR(pwrseq->reset_gpio))
> -		gpiod_set_value_cansleep(pwrseq->reset_gpio, 0);
> +	for (i = 0; i < pwrseq->nr_gpios; i++)
> +		if (!IS_ERR(pwrseq->reset_gpio[i]))
> +			gpiod_set_value_cansleep(pwrseq->reset_gpio[i], 0);
...]

Now that we have more code in mmc_pwrseq_simple_post_power_on() and 
mmc_pwrseq_simple_pre_power_on(), Just move most of them into a common 
function like:

static void __mmc_pwrseq_simple_power_on_off(struct mmc_host *host,
						      bool on)
{
	struct mmc_pwrseq_simple *pwrseq = container_of(host->pwrseq,
					struct mmc_pwrseq_simple, pwrseq);
	int i;

	if (!IS_ERR(pwrseq->reset_gpios)) {
		for (i = 0; i < pwrseq->ngpios; i++)
			gpiod_set_value_cansleep(pwrseq->reset_gpios[i],
						 on ? : 0);
	}
}

static void mmc_pwrseq_simple_pre_power_on(struct mmc_host *host)
{
	__mmc_pwrseq_simple_power_on_off(host, true);
}

static void mmc_pwrseq_simple_post_power_on(struct mmc_host *host)
{
	__mmc_pwrseq_simple_power_on_off(host, false);
}


>   }
>
>   static void mmc_pwrseq_simple_free(struct mmc_host *host)
>   {
>   	struct mmc_pwrseq_simple *pwrseq = container_of(host->pwrseq,
>   					struct mmc_pwrseq_simple, pwrseq);
> +	int i;
>
> -	if (!IS_ERR(pwrseq->reset_gpio))
> -		gpiod_put(pwrseq->reset_gpio);
> +	if (pwrseq->nr_gpios > 0) {
> +		for (i = 0; i < pwrseq->nr_gpios; i++)
> +			if (!IS_ERR(pwrseq->reset_gpio[i]))
> +				gpiod_put(pwrseq->reset_gpio[i]);
> +		kfree(pwrseq->reset_gpio);
> +	}
>
>   	kfree(pwrseq);
>   	host->pwrseq = NULL;
> @@ -63,17 +74,27 @@ int mmc_pwrseq_simple_alloc(struct mmc_host *host, struct device *dev)
>   {
>   	struct mmc_pwrseq_simple *pwrseq;
>   	int ret = 0;
> +	int i;
>
>   	pwrseq = kzalloc(sizeof(struct mmc_pwrseq_simple), GFP_KERNEL);
>   	if (!pwrseq)
>   		return -ENOMEM;
>
> -	pwrseq->reset_gpio = gpiod_get_index(dev, "reset", 0, GPIOD_OUT_HIGH);
> -	if (IS_ERR(pwrseq->reset_gpio) &&
> -		PTR_ERR(pwrseq->reset_gpio) != -ENOENT &&
> -		PTR_ERR(pwrseq->reset_gpio) != -ENOSYS) {
> -		ret = PTR_ERR(pwrseq->reset_gpio);
> -		goto free;
> +	pwrseq->nr_gpios = of_gpio_named_count(dev->of_node, "reset-gpios");
> +	if (pwrseq->nr_gpios > 0) {

What happens if there are no gpios? This fuction should return -ENOENT 
and should not even try to allocate pwrseq?
Probably you should do of_gpio_named_count before allocating memory.

> +		pwrseq->reset_gpio = kzalloc(sizeof(struct gpio_desc *) *
> +					     pwrseq->nr_gpios, GFP_KERNEL);
> +
> +		for (i = 0; i < pwrseq->nr_gpios; i++) {
> +			pwrseq->reset_gpio[i] = gpiod_get_index(dev, "reset", i,
> +								GPIOD_OUT_HIGH);
> +			if (IS_ERR(pwrseq->reset_gpio[i]) &&
> +			    PTR_ERR(pwrseq->reset_gpio[i]) != -ENOENT &&
> +			    PTR_ERR(pwrseq->reset_gpio[i]) != -ENOSYS) {
> +				ret = PTR_ERR(pwrseq->reset_gpio[i]);

is simple to add:
	while(--i)
		gpiod_put(pwrseq->reset_gpio[i])


		
> +				goto free;
> +			}
> +		}


>   	}
>
>   	pwrseq->pwrseq.ops = &mmc_pwrseq_simple_ops;
> @@ -81,6 +102,13 @@ int mmc_pwrseq_simple_alloc(struct mmc_host *host, struct device *dev)
>
>   	return 0;
>   free:
> +	if (pwrseq->nr_gpios > 0) {
> +		for (i = 0; i < pwrseq->nr_gpios; i++)
> +			if (!IS_ERR_OR_NULL(pwrseq->reset_gpio[i]))
> +				gpiod_put(pwrseq->reset_gpio[i]);
> +		kfree(pwrseq->reset_gpio);
> +	}
> +
>   	kfree(pwrseq);
>   	return ret;
>   }
>

I get a feeling that am just dumping my patch here.. If possible could 
you have look at it too.

Thanks,
srini
