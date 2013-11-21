Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002Ab3KURFl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 12:05:41 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:5661 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211Ab3KURFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 12:05:39 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 21 Nov 2013 09:03:33 -0800
Message-ID: <528E3D5E.20907@nvidia.com>
Date: Thu, 21 Nov 2013 12:05:34 -0500
From: Rhyland Klein <rklein@nvidia.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
CC: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linus Walleij <linus.walleij@linaro.org>, Chris Ball <cjb@laptop.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alex Courbot <acourbot@nvidia.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Rob Landley <rob@landley.net>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] net: rfkill: gpio: convert to descriptor-based GPIO
 interface
References: <1385045153-25160-1-git-send-email-mika.westerberg@linux.intel.com> <1385045153-25160-2-git-send-email-mika.westerberg@linux.intel.com> <20131121152425.GA5557@xps8300>
In-Reply-To: <20131121152425.GA5557@xps8300>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2013 10:24 AM, Heikki Krogerus wrote:
> Hi Rhyland,
> 
> On Thu, Nov 21, 2013 at 04:45:49PM +0200, Mika Westerberg wrote:
>> +static int rfkill_gpio_convert_to_desc(struct platform_device *pdev,
>> +				       struct rfkill_gpio_data *rfkill)
>> +{
>> +	struct rfkill_gpio_platform_data *pdata = pdev->dev.platform_data;
>> +	int ret = 0;
>> +
>> +	if (gpio_is_valid(pdata->reset_gpio)) {
>> +		ret = devm_gpio_request_one(&pdev->dev, pdata->reset_gpio,
>> +					    0, rfkill->reset_name);
>> +		if (ret) {
>> +			pr_warn("%s: failed to get reset gpio.\n", __func__);
>> +			return ret;
>> +		}
>> +		rfkill->reset_gpio = gpio_to_desc(pdata->reset_gpio);
>> +	}
>> +
>> +	if (gpio_is_valid(pdata->shutdown_gpio)) {
>> +		ret = devm_gpio_request_one(&pdev->dev, pdata->shutdown_gpio,
>> +					    0, rfkill->shutdown_name);
>> +		if (ret) {
>> +			pr_warn("%s: failed to get shutdown gpio.\n", __func__);
>> +			return ret;
>> +		}
>> +		rfkill->shutdown_gpio = gpio_to_desc(pdata->shutdown_gpio);
>> +	}
>> +
>> +	return 0;
>> +}
> 
> We could drop this conversion if you guys added gpiod_lookup table to
> your platform code. I think something like this is enough. Please note
> that I have not even tried compile it but you get the idea from it.
> 
> diff --git a/arch/arm/mach-tegra/board-paz00.c b/arch/arm/mach-tegra/board-paz00.c
> index 06f0240..19bce88 100644
> --- a/arch/arm/mach-tegra/board-paz00.c
> +++ b/arch/arm/mach-tegra/board-paz00.c
> @@ -18,13 +18,12 @@
>   */
>  
>  #include <linux/platform_device.h>
> +#include <linux/gpio/driver.h>
>  #include <linux/rfkill-gpio.h>
>  #include "board.h"
>  
>  static struct rfkill_gpio_platform_data wifi_rfkill_platform_data = {
>         .name           = "wifi_rfkill",
> -       .reset_gpio     = 25, /* PD1 */
> -       .shutdown_gpio  = 85, /* PK5 */
>         .type   = RFKILL_TYPE_WLAN,
>  };
>  
> @@ -36,7 +35,13 @@ static struct platform_device wifi_rfkill_device = {
>         },
>  };
>  
> +static struct gpiod_lookup wifi_gpio_lookup[] = {
> +       GPIO_LOOKUP_IDX("tegra-gpio", 25, "rfkill_gpio", NULL, 0, NULL),
> +       GPIO_LOOKUP_IDX("tegra-gpio", 85, "rfkill_gpio", NULL, 1, NULL),
> +};
> +
>  void __init tegra_paz00_wifikill_init(void)
>  {
> +       gpiod_add_table(wifi_lookup, ARRAY_SIZE(wifi_gpio_lookup));
>         platform_device_register(&wifi_rfkill_device);
>  }
> 
> 

This seems like a reasonable patch, and likely a good way to go. I don't
have a AC100 to test this with though, so I can't verify this
personally. Also, would the paz00 patch become a dependency of this
patchset? Mika, maybe you can therefore include a patch for paz00 in
your patchset?

-rhyland

-- 
nvpublic
