Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757573Ab3K0QrW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 11:47:22 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:13741 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757016Ab3K0QrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 11:47:20 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 27 Nov 2013 08:41:00 -0800
Message-ID: <52962214.9030203@nvidia.com>
Date: Wed, 27 Nov 2013 11:47:16 -0500
From: Rhyland Klein <rklein@nvidia.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linus Walleij <linus.walleij@linaro.org>, Chris Ball <cjb@laptop.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alex Courbot <acourbot@nvidia.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Rob Landley <rob@landley.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/6] ARM: tegra: add gpiod_lookup table for paz00
References: <1385460350-17543-1-git-send-email-mika.westerberg@linux.intel.com> <1385460350-17543-2-git-send-email-mika.westerberg@linux.intel.com>
In-Reply-To: <1385460350-17543-2-git-send-email-mika.westerberg@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2013 5:05 AM, Mika Westerberg wrote:
> From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> 
> This makes it possible to request the gpio descriptors in
> rfkill_gpio driver regardless of the platform.
> 
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Tested-by: Stephen Warren <swarren@nvidia.com>
> ---
>  arch/arm/mach-tegra/board-paz00.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/arch/arm/mach-tegra/board-paz00.c b/arch/arm/mach-tegra/board-paz00.c
> index 06f024070dab..a309795da665 100644
> --- a/arch/arm/mach-tegra/board-paz00.c
> +++ b/arch/arm/mach-tegra/board-paz00.c
> @@ -18,6 +18,7 @@
>   */
>  
>  #include <linux/platform_device.h>
> +#include <linux/gpio/driver.h>
>  #include <linux/rfkill-gpio.h>
>  #include "board.h"
>  
> @@ -36,7 +37,13 @@ static struct platform_device wifi_rfkill_device = {
>  	},
>  };
>  
> +static struct gpiod_lookup wifi_gpio_lookup[] = {
> +	GPIO_LOOKUP_IDX("tegra-gpio", 25, "rfkill_gpio", NULL, 0, 0),
> +	GPIO_LOOKUP_IDX("tegra-gpio", 85, "rfkill_gpio", NULL, 1, 0),
> +};

I wouldn't think this table would match for the gpios as the driver
currently is. From what I see, the driver calls into gpiod_get_index,
which will try 1 of 3 ways of getting the gpios:

of-enabled: of_find_gpio
	- which I believe wouldn't work for paz00, since rfkill
	  doesn't support dt?
acpi: acpi_find_gpio
	- I assume this does work, but I didn't dive into it
gpiod lookup table: gpiod_find
	- I think this is the path we expect to be taken, given the addition of
the lookup table here, but I don't think it would actually match.
Looking at the code for gpiod_find, it seems like it would try to match
the con_id, but would fail. Patch 2/6 is passing the reset_name and
shutdown_name for the con_ids, which isn't what is registered in this
table.

Shouldn't it look more like this?

+static struct gpiod_lookup wifi_gpio_lookup[] = {
+	GPIO_LOOKUP_IDX("tegra-gpio", 25, "rfkill_gpio_reset", NULL, 0, 0),
+	GPIO_LOOKUP_IDX("tegra-gpio", 85, "rfkill_gpio_shutdown", NULL, 1, 0),
+};

Sorry if I am missing something...

-rhyland

-- 
nvpublic
