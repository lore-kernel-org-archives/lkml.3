Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161022Ab3BGSQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 13:16:18 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:47872 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030193Ab3BGSQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 13:16:17 -0500
Message-ID: <5113EF59.80508@ti.com>
Date: Thu, 7 Feb 2013 23:45:53 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Kumar, Anil" <anilkumar.v@ti.com>
CC: <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux@arm.linux.org.uk>, <khilman@deeprootsystems.com>, <hs@denx.de>,
        <mporter@ti.com>, <broonie@opensource.wolfsonmicro.com>,
        <mchehab@redhat.com>, <vaibhav.bedia@ti.com>, <b-cousson@ti.com>,
        <tony@atomide.com>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>
Subject: Re: [PATCH V2 2/2] ARM: davinci: restart: fix wdt to machine restart
 with DT
References: <1360123204-9978-1-git-send-email-anilkumar.v@ti.com> <1360123204-9978-3-git-send-email-anilkumar.v@ti.com>
In-Reply-To: <1360123204-9978-3-git-send-email-anilkumar.v@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2/6/2013 9:30 AM, Kumar, Anil wrote:
> In non DT case da8xx_register_watchdog() is called to register platform device
> "da8xx_wdt_device" by board file. But in DT case it is not called and wdt
> device get registered via wdt DT node.
> 
> Currently code is passing platform device "da8xx_wdt_device" in
> "davinci_watchdog_reset" function in both DT and non DT case and that
> leads to crash in DT boot.
> 
> Update restart function to make it generic DaVinci machine restart

s/DaVinci/da8xx. Also, subject can simply be "ARM: davinci: da850 DT:
add support for machine reboot" since reboot never worked with DT
before, "fix" isn't really appropriate.

> in case of DT and non DT boot.
> 
> Signed-off-by: Kumar, Anil <anilkumar.v@ti.com>
> ---
> :100644 100644 2d5502d... 1df68fd... M	arch/arm/mach-davinci/devices-da8xx.c
> :100644 100644 700d311... ef9f70e... M	arch/arm/mach-davinci/include/mach/da8xx.h
>  arch/arm/mach-davinci/devices-da8xx.c      |   14 ++++++++++++--
>  arch/arm/mach-davinci/include/mach/da8xx.h |    1 -
>  2 files changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/mach-davinci/devices-da8xx.c b/arch/arm/mach-davinci/devices-da8xx.c
> index 2d5502d..1df68fd 100644
> --- a/arch/arm/mach-davinci/devices-da8xx.c
> +++ b/arch/arm/mach-davinci/devices-da8xx.c
> @@ -359,7 +359,7 @@ static struct resource da8xx_watchdog_resources[] = {
>  	},
>  };
>  
> -struct platform_device da8xx_wdt_device = {
> +static struct platform_device da8xx_wdt_device = {

Making of da8xx_wdt_device static should find a mention in description.

>  	.name		= "watchdog",
>  	.id		= -1,
>  	.num_resources	= ARRAY_SIZE(da8xx_watchdog_resources),
> @@ -368,7 +368,17 @@ struct platform_device da8xx_wdt_device = {
>  
>  void da8xx_restart(char mode, const char *cmd)
>  {
> -	davinci_watchdog_reset(&da8xx_wdt_device);
> +	struct device *dev = NULL;
> +	struct platform_device *wdt_device = NULL;

No need to initialize these variables here.

> +
> +	dev = bus_find_device_by_name(&platform_bus_type, NULL, "watchdog");
> +	if (!dev) {
> +		pr_err("wdt device not found to machine reboot\n");

Rather: "%s: failed to find watchdog device", __func__

Thanks,
Sekhar
