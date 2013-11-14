Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab3KNRwz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 12:52:55 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:64558 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504Ab3KNRwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 12:52:47 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19+Cpzk/lwvg2pyFzCYxpPH
Date: Thu, 14 Nov 2013 09:52:27 -0800
From: Tony Lindgren <tony@atomide.com>
To: Sebastian Reichel <sre@debian.org>
Cc: Anton Vorontsov <anton@enomsg.org>, David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Subject: Re: [PATCH 1/2] isp1704_charger: Add DT support
Message-ID: <20131114175227.GH10317@atomide.com>
References: <1384432734-1490-1-git-send-email-sre@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384432734-1490-1-git-send-email-sre@debian.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Reichel <sre@debian.org> [131114 04:40]:
> This patch introduces device tree support to the isp1704
> charger driver. Adding support involved moving the handling
> of the enable GPIO from board code into the driver.
> 
> Signed-off-by: Sebastian Reichel <sre@debian.org>
> ---
>  arch/arm/mach-omap2/board-rx51-peripherals.c | 10 +----
>  drivers/power/isp1704_charger.c              | 56 +++++++++++++++++++++++++---
>  include/linux/power/isp1704_charger.h        |  2 +-
>  3 files changed, 52 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
> index a791fef..2986d16 100644
> --- a/arch/arm/mach-omap2/board-rx51-peripherals.c
> +++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
> @@ -273,13 +273,8 @@ static struct platform_device rx51_battery_device = {
>  	.id	= -1,
>  };
>  
> -static void rx51_charger_set_power(bool on)
> -{
> -	gpio_set_value(RX51_USB_TRANSCEIVER_RST_GPIO, on);
> -}
> -
>  static struct isp1704_charger_data rx51_charger_data = {
> -	.set_power	= rx51_charger_set_power,
> +	.enable_gpio	= RX51_USB_TRANSCEIVER_RST_GPIO,
>  };
>  
>  static struct platform_device rx51_charger_device = {
> @@ -291,9 +286,6 @@ static struct platform_device rx51_charger_device = {
>  
>  static void __init rx51_charger_init(void)
>  {
> -	WARN_ON(gpio_request_one(RX51_USB_TRANSCEIVER_RST_GPIO,
> -		GPIOF_OUT_INIT_HIGH, "isp1704_reset"));
> -
>  	platform_device_register(&rx51_battery_device);
>  	platform_device_register(&rx51_charger_device);
>  }

Can you please separate out the changes to board-rx51-peripherals.c
as they have a huge chance of merge conflicts for v3.14 when
we're planning to flip omap3 to be device tree only?

To remove the dependency, how about add .enable_gpio to the
isp1704_charger.h and to the board-rx51-peripherals.c without
removing .set_power in the first patch?

Then we can set up an immutable branch that can be merged both
to linux-omap tree and Anton's tree to avoid merge conflicts.

Then the rest of the patches can go via Anton's tree and you
can just have .set_power do nothing, and then it can be
removed later on when no longer used at all.

Regards,

Tony
