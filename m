Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968Ab3KVSkS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 13:40:18 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:58839 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554Ab3KVSkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 13:40:14 -0500
Message-ID: <528FA509.6080907@wwwdotorg.org>
Date: Fri, 22 Nov 2013 11:40:09 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-acpi@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <acourbot@nvidia.com>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Chris Ball <cjb@laptop.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Rhyland Klein <rklein@nvidia.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Rob Landley <rob@landley.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Thierry Reding <thierry.reding@gmail.com>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/7] ARM: tegra: add gpiod_lookup table for paz00
References: <1385122474-14926-1-git-send-email-mika.westerberg@linux.intel.com> <1385122474-14926-3-git-send-email-mika.westerberg@linux.intel.com>
In-Reply-To: <1385122474-14926-3-git-send-email-mika.westerberg@linux.intel.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2013 05:14 AM, Mika Westerberg wrote:
> From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> 
> This makes it possible to request the gpio descriptors in
> rfkill-gpio driver regardless of the platform.

Patches 1-3,
Tested-by: Stephen Warren <swarren@nvidia.com>

All the testing I did was to "cat /sys/kernel/debug/gpios" to make sure
those two GPIOs had been correctly acquired by the driver, and that they
changed state as expected via the command-line "rfkill {un,}block" commands.

However, please note that I had to apply a couple fixes to the gpiolib
core to get this working:

1)

To solve the following build warning:

> In file included from arch/arm/mach-tegra/board-paz00.c:21:0:
> include/linux/gpio/driver.h:102:17: warning: ‘struct of_phandle_args’ declared inside parameter list [enabled by default]
> include/linux/gpio/driver.h:102:17: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]

I applied:


> diff --git a/include/linux/gpio/driver.h b/include/linux/gpio/driver.h
> index 82eac610ce1a..5133cf29803a 100644
> --- a/include/linux/gpio/driver.h
> +++ b/include/linux/gpio/driver.h
> @@ -5,6 +5,7 @@
>
>  struct device;
>  struct gpio_desc;
> +struct of_phandle_args;
>  struct seq_file;
>
>  /**

2)

In order to get the GPIO lookups from the rfkill driver working, I applied:

> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index ac53a9593662..b73c39f99858 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -2368,7 +2368,7 @@ static struct gpio_desc *gpiod_find(struct device *dev, const char *con_id,
>  				continue;
>  			}
>  
> -			if (chip->ngpio >= p->chip_hwnum) {
> +			if (chip->ngpio <= p->chip_hwnum) {
>  				dev_warn(dev, "GPIO chip %s has %d GPIOs\n",
>  					 chip->label, chip->ngpio);
>  				continue;

