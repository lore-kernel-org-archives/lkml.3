Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934205AbaKMUzf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 15:55:35 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:57337 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933975AbaKMUzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 15:55:32 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v4 1/2] of: Rename "poweroff-source" property to
 "system-power-controller"
To: Auto Configured <romain.perier@gmail.com>, heiko@sntech.de
Cc: robh@kernel.org, devicetree@vger.kernel.org, lgirdwood@gmail.com,
        broonie@kernel.org, johan@kernel.org, mark.rutland@arm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, balbi@ti.com,
        Romain Perier <romain.perier@gmail.com>
In-Reply-To: <1415885699-1465-2-git-send-email-user@radxa>
References: <1415885699-1465-1-git-send-email-user@radxa>
	<1415885699-1465-2-git-send-email-user@radxa>
Date: Thu, 13 Nov 2014 20:55:28 +0000
Message-Id: <20141113205528.77414C40BC2@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2014 13:34:58 +0000
, Auto Configured <romain.perier@gmail.com>
 wrote:
> From: Romain Perier <romain.perier@gmail.com>
> 
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

Acked-by: Grant Likely <grant.likely@linaro.org>

Please merge via whichever tree needs this change.

g.

> ---
>  .../bindings/power/{poweroff.txt => power-controller.txt}        | 0
>  .../devicetree/bindings/regulator/act8865-regulator.txt          | 4 ++--
>  drivers/mfd/tps65910.c                                           | 9 ++++++++-
>  drivers/regulator/act8865-regulator.c                            | 2 +-
>  include/linux/of.h                                               | 6 +++---
>  5 files changed, 14 insertions(+), 7 deletions(-)
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
> index b8dca8a..3a796a5 100644
> --- a/drivers/mfd/tps65910.c
> +++ b/drivers/mfd/tps65910.c
> @@ -386,6 +386,13 @@ static const struct of_device_id tps65910_of_match[] = {
>  };
>  MODULE_DEVICE_TABLE(of, tps65910_of_match);
>  
> +static inline bool tps65910_is_pm_off_found(struct device_node *np)
> +{
> +	if (of_property_read_bool(np, "ti,system-power-controller"))
> +		return true;
> +	return of_is_system_power_controller(np);
> +}
> +
>  static struct tps65910_board *tps65910_parse_dt(struct i2c_client *client,
>  						unsigned long *chip_id)
>  {
> @@ -423,7 +430,7 @@ static struct tps65910_board *tps65910_parse_dt(struct i2c_client *client,
>  
>  	board_info->irq = client->irq;
>  	board_info->irq_base = -1;
> -	board_info->pm_off = of_system_has_poweroff_source(np);
> +	board_info->pm_off = tps65910_is_pm_off_found(np);
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
> index d933717..f9541bc 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -965,14 +965,14 @@ static inline int of_changeset_update_property(struct of_changeset *ocs,
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
> +	return of_property_read_bool(np, "system-power-controller");
>  }
>  
>  #endif /* _LINUX_OF_H */
> -- 
> 1.9.1
> 

