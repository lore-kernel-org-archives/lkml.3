Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932181Ab3E1Wht (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 18:37:49 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:59807 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757438Ab3E1Whf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 18:37:35 -0400
Message-ID: <51A531A9.4030800@gmail.com>
Date: Wed, 29 May 2013 00:37:29 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: grant.likely@linaro.org, tony@atomide.com, balbi@ti.com, arnd@arndb.de,
        swarren@nvidia.com, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, rob.herring@calxeda.com, rob@landley.net,
        b-cousson@ti.com, linux@arm.linux.org.uk, gregkh@linuxfoundation.org,
        benoit.cousson@linaro.org, mchehab@redhat.com,
        akpm@linux-foundation.org, cesarb@cesarb.net, davem@davemloft.net,
        rnayak@ti.com, shawn.guo@linaro.org, santosh.shilimkar@ti.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        nsekhar@ti.com
Subject: Re: [PATCH v6 1/9] drivers: phy: add generic PHY framework
References: <1367229812-30574-1-git-send-email-kishon@ti.com> <1367229812-30574-2-git-send-email-kishon@ti.com>
In-Reply-To: <1367229812-30574-2-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,

On 04/29/2013 12:03 PM, Kishon Vijay Abraham I wrote:
> The PHY framework provides a set of APIs for the PHY drivers to
> create/destroy a PHY and APIs for the PHY users to obtain a reference to the
> PHY with or without using phandle. For dt-boot, the PHY drivers should
> also register *PHY provider* with the framework.
>
> PHY drivers should create the PHY by passing id and ops like init, exit,
> power_on and power_off. This framework is also pm runtime enabled.
>
> The documentation for the generic PHY framework is added in
> Documentation/phy.txt and the documentation for dt binding can be found at
> Documentation/devicetree/bindings/phy/phy-bindings.txt
>
> Signed-off-by: Kishon Vijay Abraham I<kishon@ti.com>

Thanks for working on this. For the record, I plan to give this a try
in the end of this week, with my simple MIPI CSI/DSI PHY driver. I might
have some more comments then. For now just couple of remarks after
reading the documentation.

> ---
>   .../devicetree/bindings/phy/phy-bindings.txt       |   66 +++
>   Documentation/phy.txt                              |  123 +++++
>   MAINTAINERS                                        |    7 +
>   drivers/Kconfig                                    |    2 +
>   drivers/Makefile                                   |    2 +
>   drivers/phy/Kconfig                                |   13 +
>   drivers/phy/Makefile                               |    5 +
>   drivers/phy/phy-core.c                             |  539 ++++++++++++++++++++
>   include/linux/phy/phy.h                            |  248 +++++++++
>   9 files changed, 1005 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/phy/phy-bindings.txt
>   create mode 100644 Documentation/phy.txt
>   create mode 100644 drivers/phy/Kconfig
>   create mode 100644 drivers/phy/Makefile
>   create mode 100644 drivers/phy/phy-core.c
>   create mode 100644 include/linux/phy/phy.h
>
> diff --git a/Documentation/devicetree/bindings/phy/phy-bindings.txt b/Documentation/devicetree/bindings/phy/phy-bindings.txt
> new file mode 100644
> index 0000000..8ae844f
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/phy/phy-bindings.txt
> @@ -0,0 +1,66 @@
> +This document explains only the device tree data binding. For general
> +information about PHY subsystem refer to Documentation/phy.txt
> +
> +PHY device node
> +===============
> +
> +Required Properties:
> +#phy-cells:	Number of cells in a PHY specifier;  The meaning of all those
> +		cells is defined by the binding for the phy node. The PHY
> +		provider can use the values in cells to find the appropriate
> +		PHY.
> +
> +For example:
> +
> +phys: phy {
> +    compatible = "xxx";
> +    reg =<...>;
> +    .
> +    .
> +    #phy-cells =<1>;
> +    .
> +    .
> +};
> +
> +That node describes an IP block (PHY provider) that implements 2 different PHYs.
> +In order to differentiate between these 2 PHYs, an additonal specifier should be
> +given while trying to get a reference to it.
> +
> +PHY user node
> +=============
> +
> +Required Properties:
> +phys : the phandle for the PHY device (used by the PHY subsystem)
> +phy-names : the names of the PHY corresponding to the PHYs present in the
> +	    *phys* phandle
> +
> +Example 1:
> +usb1: usb_otg_ss@xxx {
> +    compatible = "xxx";
> +    reg =<xxx>;
> +    .
> +    .
> +    phys =<&usb2_phy>,<&usb3_phy>;
> +    phy-names = "usb2phy", "usb3phy";
> +    .
> +    .
> +};
> +
> +This node represents a controller that uses two PHYs, one for usb2 and one for
> +usb3.
> +
> +Example 2:
> +usb2: usb_otg_ss@xxx {
> +    compatible = "xxx";
> +    reg =<xxx>;
> +    .
> +    .
> +    phys =<&phys 1>;
> +    phy-names = "usbphy";
> +    .
> +    .
> +};
> +
> +This node represents a controller that uses one of the PHYs of the PHY provider
> +device defined previously. Note that the phy handle has an additional specifier
> +"1" to differentiate between the two PHYs.
> diff --git a/Documentation/phy.txt b/Documentation/phy.txt
> new file mode 100644
> index 0000000..408d25f
> --- /dev/null
> +++ b/Documentation/phy.txt
> @@ -0,0 +1,123 @@
> +			    PHY SUBSYSTEM
> +		  Kishon Vijay Abraham I<kishon@ti.com>
> +
> +This document explains the Generic PHY Framework along with the APIs provided,
> +and how-to-use.
> +
> +1. Introduction
> +
> +*PHY* is the abbreviation for physical layer. It is used to connect a device
> +to the physical medium e.g., the USB controller has a PHY to provide functions
> +such as serialization, de-serialization, encoding, decoding and is responsible
> +for obtaining the required data transmission rate. Note that some USB
> +controller has PHY functionality embedded into it and others use an external

"Note that some USB
controllers have PHY functionality embedded into them..." ?

> +PHY. Other peripherals that uses a PHY include Wireless LAN, Ethernet,

s/uses/use ?

> +SATA etc.
> +
> +The intention of creating this framework is to bring the phy drivers spread

s/phy/PHY ?

> +all over the Linux kernel to drivers/phy to increase code re-use and for
> +better code maintainability.
> +
> +This framework will be of use only to devices that uses external PHY (PHY

s/that uses/that use ?

> +functionality is not embedded within the controller).
> +
> +2. Registering/UnRegistering the PHY provider

s/UnRegistering/Unregistering ?

> +
> +PHY provider refers to an entity that implements one or more PHY instances.
> +For the simple case where the PHY provider implements only a single instance of
> +the PHY, the framework provides its own implementation of of_xlate in
> +of_phy_simple_xlate. If the PHY provider implements multiple instances, it
> +should provide it's own implementation of of_xlate. of_xlate is used only for

s/it's/its

> +dt boot case.
> +
> +struct phy_provider *of_phy_provider_register(struct device *dev,
> +	struct module *owner, struct phy * (*of_xlate)(struct device *dev,
> +	struct of_phandle_args *args));
> +struct phy_provider *devm_of_phy_provider_register(struct device *dev,
> +	struct module *owner, struct phy * (*of_xlate)(struct device *dev,
> +	struct of_phandle_args *args))
> +
> +of_phy_provider_register and devm_of_phy_provider_register can be used to
> +register the phy_provider and it takes device, owner and of_xlate as
> +arguments. For the dt boot case, all PHY providers should use one of the above
> +2 APIs to register the PHY provider.
> +
> +void devm_of_phy_provider_unregister(struct device *dev,
> +	struct phy_provider *phy_provider);
> +void of_phy_provider_unregister(struct phy_provider *phy_provider);
> +
> +devm_of_phy_provider_unregister and of_phy_provider_unregister can be used to
> +unregister the PHY.
> +
> +3. Creating the PHY
> +
> +The PHY driver should create the PHY in order for other peripheral controllers
> +to make use of it. The PHY framework provides 2 APIs to create the PHY.
> +
> +struct phy *phy_create(struct device *dev, int id, const struct phy_ops *ops,
> +	void *priv);
> +struct phy *devm_phy_create(struct device *dev, int id,
> +	const struct phy_ops *ops, void *priv);
> +
> +The PHY drivers can use one of the above 2 APIs to create the PHY by passing
> +the device pointer, id, phy ops and a driver data.
> +phy_ops is a set of function pointers for performing PHY operations such as
> +init, exit, power_on and power_off.
> +
> +4. Getting a reference to the PHY
> +
> +Before the controller can make use of the PHY, it has to get a reference to
> +it. This framework provides the following APIs to get a reference to the PHY.
> +
> +struct phy *phy_get(struct device *dev, const char *string);
> +struct phy *devm_phy_get(struct device *dev, const char *string);
> +
> +phy_get and devm_phy_get can be used to get the PHY. In the case of dt boot,
> +the string arguments should contain the phy name as given in the dt data and
> +in the case of non-dt boot, it should contain the device name of the PHY.

How about allowing null strings ? At least it seems not difficult for dt 
boot.
But there would have been some asymmetry, for non-dt an error would have to
be returned when the passed string is null.

> +The only difference between the two APIs is that devm_phy_get associates the
> +device with the PHY using devres on successful PHY get. On driver detach,
> +release function is invoked on the the devres data and devres data is freed.
> +
> +5. Releasing a reference to the PHY
> +
> +When the controller no longer needs the PHY, it has to release the reference
> +to the PHY it has obtained using the APIs mentioned in the above section. The
> +PHY framework provides 2 APIS to release a reference to the PHY.

APIs ?

> +void phy_put(struct phy *phy);
> +void devm_phy_put(struct device *dev, struct phy *phy);
> +
> +Both these APIs are used to release a reference to the PHY and devm_phy_put
> +destroys the devres associated with this PHY.
> +
> +6. Destroying the PHY
> +
> +When the driver that created the PHY is unloaded, it should destroy the PHY it
> +created using one of the following 2 APIs.
> +
> +void phy_destroy(struct phy *phy);
> +void devm_phy_destroy(struct device *dev, struct phy *phy);
> +
> +Both these APIs destroys the PHY and devm_phy_destroy destroys the devres

s/APIs destroys/APIs destroy ?

> +associated with this PHY.
> +
> +7. PM Runtime
> +
> +This subsystem is pm runtime enabled. So while creating the PHY,
> +pm_runtime_enable of the phy device created by this subsystem is called and
> +while destroying the PHY, pm_runtime_disable is called. Note that the phy
> +device created by this subsystem will be a child of the device that calls
> +phy_create (PHY provider device).
> +
> +During phy_init, the clocks are enabled by calling get_sync and the clocks are

I think, if you mean pm_runtime_get_sync(), it should be said precisely 
here.

> +disable by calling put_sync during phy_exit. get_sync of the phy_device

Ditto.

s/disable/disabled

> +created by this susbsystem will invoke get_sync of PHY provider device because

s/susbsystem/subsystem

> +of parent-child relationship. For all other pm operations, there are exported
> +APIs like phy_pm_runtime_get, phy_pm_runtime_get_sync, phy_pm_runtime_put,
> +phy_pm_runtime_put_sync, phy_pm_runtime_allow and phy_pm_runtime_forbid.
> +
> +8. DeviceTree Binding
> +
> +The documentation for PHY dt binding can be found @
> +Documentation/devicetree/bindings/phy/phy-bindings.txt

> +/**
> + * phy_release() - release the phy
> + * @dev: the dev member within phy
> + *
> + * when the last reference to the device is removed; it is called

s/when/When
s/removed;/removed ?

> + * from the embedded kobject as release method.
> + */

> +/**
> + * struct phy - represent the phy device

s/represent/represents ?

> + * @dev: phy device
> + * @id: id of the phy
> + * @ops: function pointers for performing phy operations
> + */
> +struct phy {
> +	struct device		dev;
> +	int			id;
> +	const struct phy_ops	*ops;
> +};
> +
> +/**
> + * struct phy_provider - represent the phy provider

s/represent/represents ?

> + * @dev: phy provider device
> + * @owner: the module owner having of_xlate
> + * @of_xlate: function pointer to obtain phy instance from phy pointer
> + * @list: to maintain a linked list of PHY provider

s/provider/providers ?

> + */
> +struct phy_provider {
> +	struct device		*dev;
> +	struct module		*owner;
> +	struct list_head	list;
> +	struct phy * (*of_xlate)(struct device *dev,
> +		struct of_phandle_args *args);
> +};

Regards,
Sylwester
