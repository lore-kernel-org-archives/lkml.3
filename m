Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbaKEKLo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 05:11:44 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:40434 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754342AbaKEKLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 05:11:39 -0500
Date: Wed, 5 Nov 2014 11:08:27 +0100
From: Johan Hovold <johan@kernel.org>
To: Romain Perier <romain.perier@gmail.com>
Cc: heiko@sntech.de, grant.likely@linaro.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org, lgirdwood@gmail.com, broonie@kernel.org,
        johan@kernel.org, mark.rutland@arm.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH v2 1/4] of: Rename "poweroff-source" property to
 "system-power-controller"
Message-ID: <20141105100827.GP31358@localhost>
References: <1414568135-8311-1-git-send-email-romain.perier@gmail.com>
 <1414568135-8311-2-git-send-email-romain.perier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414568135-8311-2-git-send-email-romain.perier@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Resend with lkml, arm, Felipe on CC -- why were these dropped from CC? ]

On Wed, Oct 29, 2014 at 07:35:32AM +0000, Romain Perier wrote:
> As discussed on the mailing list, it makes more sense to rename this property
> to "system-power-controller". 

Please also refer to the commit in the regulator tree renaming it to
"poweroff-source", and that this in effect is a revert to the old name
but without the vendor prefix.

> Problem being that the word "source" usually tends
> to be used for inputs and that is out of control of the OS. The poweroff
> capability is an output which simply turns the system-power off. Also, this
> property might be used by drivers which power-off the system and power back on
> subsequent RTC alarms. This seems to suggest to remove "poweroff" from the
> property name and to choose "system-power-controller" as the more generic name.
> This patchs adds the required renaming changes and defines an helper function
> which is compatible with both properties, the old one prefixed by a vendor name
> and the new one without any prefix.
> 
> Signed-off-by: Romain Perier <romain.perier@gmail.com>

First of all, always run your patches through checkpatch.pl before
submitting. There's a few warnings there for you to fix.

> ---
>  .../devicetree/bindings/power/power-controller.txt | 18 ++++++++++++
>  .../devicetree/bindings/power/poweroff.txt         | 18 ------------
>  drivers/of/base.c                                  | 34 ++++++++++++++++++++++
>  include/linux/of.h                                 | 10 ++-----
>  4 files changed, 55 insertions(+), 25 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/power/power-controller.txt
>  delete mode 100644 Documentation/devicetree/bindings/power/poweroff.txt
> 
> diff --git a/Documentation/devicetree/bindings/power/power-controller.txt b/Documentation/devicetree/bindings/power/power-controller.txt
> new file mode 100644
> index 0000000..942f955
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/power/power-controller.txt
> @@ -0,0 +1,18 @@
> +* Generic system power control capability
> +
> +Power-management integrated circuits or miscellaneous harware components are
> +sometimes able to control the system power. The device driver associated to these

s/to/with/

> +components might needs to define this capability, 

s/needs/need/

> which tells to the kernel

s/to the/the/

> howto switch off the system. 

this should be something like "that it can be used to switch off...".

> The corresponding driver must have the standard

It's the device that has the property, not the driver.

> +property "system-power-controller" in its device node. This property marks the
> +device as able to controller the system-power. In order to test if this property

s/controller/control/
s/system-power/system power/

> +is found programmatically, use the helper function "of_is_system_power_controller"
> +from of.h .
> +
> +Example:
> +
> +act8846: act8846@5 {
> +	 compatible = "active-semi,act8846";
> +	 status = "okay";
> +	 system-power-controller;
> +}
> diff --git a/Documentation/devicetree/bindings/power/poweroff.txt b/Documentation/devicetree/bindings/power/poweroff.txt
> deleted file mode 100644
> index 845868b..0000000
> --- a/Documentation/devicetree/bindings/power/poweroff.txt
> +++ /dev/null
> @@ -1,18 +0,0 @@
> -* Generic Poweroff capability
> -
> -Power-management integrated circuits or miscellaneous harware components are
> -sometimes able to control the system power. The device driver associated to these
> -components might needs to define poweroff capability, which tells to the kernel
> -how to switch off the system. The corresponding driver must have the standard
> -property "poweroff-source" in its device node. This property marks the device as
> -able to shutdown the system. In order to test if this property is found
> -programmatically, use the helper function "of_system_has_poweroff_source" from
> -of.h .
> -
> -Example:
> -
> -act8846: act8846@5 {
> -	 compatible = "active-semi,act8846";
> -	 status = "okay";
> -	 poweroff-source;
> -}
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index 74ab1b8..438e405 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -2260,3 +2260,37 @@ struct device_node *of_graph_get_remote_port(const struct device_node *node)
>  	return of_get_next_parent(np);
>  }
>  EXPORT_SYMBOL(of_graph_get_remote_port);
> +
> +/**
> + * of_is_system_power_controller() - Tells if the property for controlling system
> + * power is found in device_node.
> + * @np: Pointer to the given device_node
> + *
> + * Return: true if present false otherwise
> + */
> +bool of_is_system_power_controller(const struct device_node *np)
> +{
> +	struct property *pp;
> +	unsigned long flags;
> +	char *sep;
> +	bool found = false;
> +
> +	raw_spin_lock_irqsave(&devtree_lock, flags);
> +	for_each_property_of_node(np, pp) {
> +		if (of_prop_cmp(pp->name, "system-power-controller") == 0) {
> +			found = true;
> +			break;
> +		}
> +		/* Backward compatibility with previous property "vendor,system-power-controller",
> +		 * we just check that an non-empty vendor-prefix exists here
> +		 */
> +		sep = strchr(pp->name, ',');
> +		if (sep && sep - pp->name && of_prop_cmp(sep + 1, "system-power-controller") == 0) {
> +			found = true;
> +			break;
> +		}
> +	}
> +	raw_spin_unlock_irqrestore(&devtree_lock, flags);
> +	return found;
> +}
> +EXPORT_SYMBOL(of_is_system_power_controller);

I think this is the wrong approach. This way any driver will recognise
the old deprecated vendor prefixes. But not only those -- also
misspelled vendor prefixes.

Keep it simple and only parse the new property name (inline in the
header file).

If we need to support the old property names with vendor prefix (we have
dropped vendor prefixes in the past), then you could add a second helper

	of_is_system_power_controller_compat(np, compat_propname)

where you pass in the whole old property name (e.g.
"ti,system-power-controller") and use that name as a fall back.

This way it will be clear which drivers are still supporting the
deprecated property names, and we can make sure that no new ones will.

> diff --git a/include/linux/of.h b/include/linux/of.h
> index 868fdad..e7177b3 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -910,15 +910,11 @@ static inline int of_changeset_update_property(struct of_changeset *ocs,
>  /* CONFIG_OF_RESOLVE api */
>  extern int of_resolve_phandles(struct device_node *tree);
>  
> -/**
> - * of_system_has_poweroff_source - Tells if poweroff-source is found for device_node
> - * @np: Pointer to the given device_node
> - *
> - * return true if present false otherwise
> - */
> +bool of_is_system_power_controller(const struct device_node *np);
> +
>  static inline bool of_system_has_poweroff_source(const struct device_node *np)
>  {
> -	return of_property_read_bool(np, "poweroff-source");
> +	return of_is_system_power_controller(np);
>  }
>  
>  #endif /* _LINUX_OF_H */

Johan
