Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951AbaKKPBq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 10:01:46 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:63510 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbaKKPBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 10:01:44 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v3 1/2] of: Rename "poweroff-source" property to
 "system-power-controller"
To: Romain Perier <romain.perier@gmail.com>, heiko@sntech.de
Cc: robh+dt@kernel.org, devicetree@vger.kernel.org, lgirdwood@gmail.com,
        broonie@kernel.org, johan@kernel.org, mark.rutland@arm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, balbi@ti.com
In-Reply-To: <1415283784-10885-2-git-send-email-romain.perier@gmail.com>
References: <1415283784-10885-1-git-send-email-romain.perier@gmail.com>
	<1415283784-10885-2-git-send-email-romain.perier@gmail.com>
Date: Tue, 11 Nov 2014 15:01:39 +0000
Message-Id: <20141111150139.A904BC416AF@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  6 Nov 2014 14:23:02 +0000
, Romain Perier <romain.perier@gmail.com>
 wrote:
> It reverts commit a4b4e0461ec5 ("of: Add standard property for poweroff capability").
> As discussed on the mailing list, it makes more sense to rename back to the
> old established property name, without the vendor prefix. Problem being that
> the word "source" usually tends to be used for inputs and that is out of control
> of the OS. The poweroff capability is an output which simply turns the
> system-power off. Also, this property might be used by drivers which power-off
> the system and power back on subsequent RTC alarms. This seems to suggest to
> remove "poweroff" from the property name and to choose "system-power-controller"
> as the more generic name. This patchs adds the required renaming changes and
> defines an helper function which is compatible with both properties, the old one
> which was only used by tps65910 and the new one without vendor-prefix.
> 
> Signed-off-by: Romain Perier <romain.perier@gmail.com>
> ---
>  .../bindings/power/{poweroff.txt => power-controller.txt}         | 0
>  Documentation/devicetree/bindings/regulator/act8865-regulator.txt | 4 ++--
>  drivers/mfd/tps65910.c                                            | 2 +-
>  drivers/regulator/act8865-regulator.c                             | 2 +-
>  include/linux/of.h                                                | 8 +++++---
>  5 files changed, 9 insertions(+), 7 deletions(-)
>  rename Documentation/devicetree/bindings/power/{poweroff.txt => power-controller.txt} (100%)
> 
> diff --git a/Documentation/devicetree/bindings/power/poweroff.txt b/Documentation/devicetree/bindings/power/power-controller.txt
> similarity index 100%
> rename from Documentation/devicetree/bindings/power/poweroff.txt
> rename to Documentation/devicetree/bindings/power/power-controller.txt
> diff --git a/Documentation/devicetree/bindings/regulator/act8865-regulator.txt b/Documentation/devicetree/bindings/regulator/act8865-regulator.txt
> index 01a5b07..dad6358 100644
> --- a/Documentation/devicetree/bindings/regulator/act8865-regulator.txt
> +++ b/Documentation/devicetree/bindings/regulator/act8865-regulator.txt
> @@ -6,8 +6,8 @@ Required properties:
>  - reg: I2C slave address
>  
>  Optional properties:
> -- poweroff-source: Telling whether or not this pmic is controlling
> -  the system power. See Documentation/devicetree/bindings/power/poweroff.txt .
> +- system-power-controller: Telling whether or not this pmic is controlling
> +  the system power. See Documentation/devicetree/bindings/power/power-controller.txt .
>  
>  Any standard regulator properties can be used to configure the single regulator.
>  
> diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
> index b8dca8a..77a7f78 100644
> --- a/drivers/mfd/tps65910.c
> +++ b/drivers/mfd/tps65910.c
> @@ -423,7 +423,7 @@ static struct tps65910_board *tps65910_parse_dt(struct i2c_client *client,
>  
>  	board_info->irq = client->irq;
>  	board_info->irq_base = -1;
> -	board_info->pm_off = of_system_has_poweroff_source(np);
> +	board_info->pm_off = of_is_system_power_controller(np);
>  
>  	return board_info;
>  }
> diff --git a/drivers/regulator/act8865-regulator.c b/drivers/regulator/act8865-regulator.c
> index 76301ed..435aba1 100644
> --- a/drivers/regulator/act8865-regulator.c
> +++ b/drivers/regulator/act8865-regulator.c
> @@ -365,7 +365,7 @@ static int act8865_pmic_probe(struct i2c_client *client,
>  		return ret;
>  	}
>  
> -	if (of_system_has_poweroff_source(dev->of_node)) {
> +	if (of_is_system_power_controller(dev->of_node)) {
>  		if (!pm_power_off) {
>  			act8865_i2c_client = client;
>  			act8865->off_reg = off_reg;
> diff --git a/include/linux/of.h b/include/linux/of.h
> index 868fdad..f3595ba 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -911,14 +911,16 @@ static inline int of_changeset_update_property(struct of_changeset *ocs,
>  extern int of_resolve_phandles(struct device_node *tree);
>  
>  /**
> - * of_system_has_poweroff_source - Tells if poweroff-source is found for device_node
> + * of_is_system_power_controller - Tells if system-power-controller is found for device_node
>   * @np: Pointer to the given device_node
>   *
>   * return true if present false otherwise
>   */
> -static inline bool of_system_has_poweroff_source(const struct device_node *np)
> +static inline bool of_is_system_power_controller(const struct device_node *np)
>  {
> -	return of_property_read_bool(np, "poweroff-source");
> +	if (of_property_read_bool(np, "system-power-controller"))
> +		return true;
> +	return of_property_read_bool(np, "ti,system-power-controller");

So, to be a little pendantic, the 'ti,' prefix is basically just for
backwards compatibility with the old binding, and that old binding is
only used on palmas.c, tps65*.c and twl4030-power.c, correct?

We don't actually want a ti comparison in the generic code. Normally
what you'd do here is have the fixup in the ti driver code, possibly
with a ti specific helper for those 4 files.

I'm not going to nak this patch and I know you need to get things cleaned
up, but the static inline really should be reduced back to just checking
only for "system-power-controller". The current mainline code does the
right thing anyway, and it is a *tiny* amount of extra code in 4 drivers
file.

g.


>  }
>  
>  #endif /* _LINUX_OF_H */
> -- 
> 1.9.1
> 

