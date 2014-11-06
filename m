Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091AbaKFRcu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 12:32:50 -0500
Received: from mga14.intel.com ([192.55.52.115]:12407 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299AbaKFRcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 12:32:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,327,1413270000"; 
   d="scan'208";a="618345446"
Message-ID: <545BB08E.60408@intel.com>
Date: Thu, 06 Nov 2014 18:31:58 +0100
From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Organization: Intel Technology Poland Sp. z o. o., KRS 101882, ul. Slowackiego
 173, 80-298 Gdansk
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert+renesas@glider.be>,
        Bryan Wu <cooloney@gmail.com>
CC: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@linaro.org>,
        Richard Purdie <rpurdie@rpsys.net>,
        Linus Walleij <linus.walleij@linaro.org>, linux-leds@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] leds: leds-gpio: Fix legacy GPIO number case
References: <1415273003-27674-1-git-send-email-geert+renesas@glider.be>
In-Reply-To: <1415273003-27674-1-git-send-email-geert+renesas@glider.be>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/6/2014 12:23 PM, Geert Uytterhoeven wrote:
> In the legacy case, led_dat->gpiod is initialized correctly, but
> overwritten later by template->gpiod, which is NULL, causing leds-gpio
> to fail with:
>
>      gpiod_direction_output: invalid GPIO
>      leds-gpio: probe of leds-gpio failed with error -22
>
> Move the initialization of led_dat->gpiod from template->gpiod up, and
> always use led_dat->gpiod later, to fix this.
>
> Fixes: 5c51277a9ababfa4 ("leds: leds-gpio: Add support for GPIO descriptors")
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Since it fixes a bug in a patch going from my tree, the fix needs to go 
into my tree as well.
Thus I'm going to take into my device-properties branch.

Bryan, please let me know if there are any problems with that.

Rafael


> ---
>   drivers/leds/leds-gpio.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/leds/leds-gpio.c b/drivers/leds/leds-gpio.c
> index ba4698c32bb04bde..b3c5d9d6a42bcd8b 100644
> --- a/drivers/leds/leds-gpio.c
> +++ b/drivers/leds/leds-gpio.c
> @@ -92,7 +92,8 @@ static int create_gpio_led(const struct gpio_led *template,
>   {
>   	int ret, state;
>   
> -	if (!template->gpiod) {
> +	led_dat->gpiod = template->gpiod;
> +	if (!led_dat->gpiod) {
>   		/*
>   		 * This is the legacy code path for platform code that
>   		 * still uses GPIO numbers. Ultimately we would like to get
> @@ -122,8 +123,7 @@ static int create_gpio_led(const struct gpio_led *template,
>   
>   	led_dat->cdev.name = template->name;
>   	led_dat->cdev.default_trigger = template->default_trigger;
> -	led_dat->gpiod = template->gpiod;
> -	led_dat->can_sleep = gpiod_cansleep(template->gpiod);
> +	led_dat->can_sleep = gpiod_cansleep(led_dat->gpiod);
>   	led_dat->blinking = 0;
>   	if (blink_set) {
>   		led_dat->platform_gpio_blink_set = blink_set;

