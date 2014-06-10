Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751741AbaFJJYR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 05:24:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:24250 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735AbaFJJYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 05:24:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,1008,1392192000"; 
   d="scan'208";a="545614618"
Date: Tue, 10 Jun 2014 12:24:11 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: wsa@the-dreams.de, linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH 1/2] i2c/ACPI: Support for multiple serial bus addresses
Message-ID: <20140610092411.GM1657@lahna.fi.intel.com>
References: <1397189717-30657-1-git-send-email-srinivas.pandruvada@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397189717-30657-1-git-send-email-srinivas.pandruvada@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 09:15:16PM -0700, Srinivas Pandruvada wrote:
> ACPI specification allows multiple i2c addresses defined under one
> ACPI device object. These addresses are defined using _CRS method.
> The current implementation will pickup the last entry in _CRS, and
> create an i2C device, ignoring all other previous entries for addresses.
> 
> The ACPI specification does not define, whether these addresses for one
> i2c device or for multiple i2c devices, which are defined under the same
> ACPI device object. We need some appoach where i2c clients can enumerate
> on each of the i2C address and/or have access to those extra addresses.
> 
> This change addresses both cases:
> - Create a new i2c device for each i2c address
> - Allow each i2 client to get addresses of all other devices under
> the same ACPI device object (companions or siblings)
> 
> Example 1:
> Here in the following example, there are two i2C address in _CRS.
> They belong to two different physical chipsets, with two different i2c
> address but part of a module.
> Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
> {
>         Name (RBUF, ResourceTemplate ()
>         {
> 		I2cSerialBus (0x0068, ControllerInitiated, 0x00061A80,
> 			AddressingMode7Bit, "\\_SB.I2C5",
> 			0x00, ResourceConsumer, ,
> 		)
> 		I2cSerialBus (0x000C, ControllerInitiated, 0x00061A80,
> 			AddressingMode7Bit, "\\_SB.I2C5",
> 			0x00, ResourceConsumer, ,
> 		)
> 		Interrupt (ResourceConsumer, Level, ActiveHigh, Shared, ,, )
> 		{
> 			0x00000044,
> 		}
> 	})
> 	Return (RBUF)
> }
> This change adds i2c_new_device for each i2c address. Here contents of
> /sys/bus/i2c/devices will
> 	i2c-some_acpi_dev_name:00:068
> 	i2c-some_acpi_dev_name::00:00c
> 
> Example 2
> 
> Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
>                 {
>                     Name (SBUF, ResourceTemplate ()
>                     {
>                         GpioIo (Exclusive, PullDefault, 0x0000, 0x0000, IoRestrictionOutputOnly,
>                             "\\_SB.GPO1", 0x00, ResourceConsumer, ,
>                             )
>                             {   // Pin list
>                                 0x0018
>                             }
>                         I2cSerialBus (0x0010, ControllerInitiated, 0x00061A80,
>                             AddressingMode7Bit, "\\_SB.I2C4",
>                             0x00, ResourceConsumer, ,
>                             )
>                         I2cSerialBus (0x000C, ControllerInitiated, 0x00061A80,
>                             AddressingMode7Bit, "\\_SB.I2C4",
>                             0x00, ResourceConsumer, ,
>                             )
>                         I2cSerialBus (0x0054, ControllerInitiated, 0x00061A80,
>                             AddressingMode7Bit, "\\_SB.I2C4",
>                             0x00, ResourceConsumer, ,
>                             )
>                     })
>                     Return (SBUF) /* \_SB_.I2C4.CAM1._CRS.SBUF */
>                 }
> }
> Here there are three i2c addresses for this device.

How does the client driver see this?

If I have a device that has multiple addresses but it is the same
physical device, how does the driver deal with it? For example how
drivers/misc/eeprom/at24.c could take advantage of this?

I also think that this needs to documented somewhere under
Documentation/i2c/* or so.

> When there is only I2cSerialBus address is present then there is no
> change. The device name will not include address. In this way if
> some device is using hardcoded path, this change will not impact them.
> 
> Here any i2c client driver simply need to add ACPI bindings. They will
> be probed multiple times, the client will bind to correct i2c device,
> based on checking its identity and returning error for other.
> At the same time, any i2c client can call i2c_for_each_acpi_comp_client
> to get the i2c client instances of companion addresses defined
> under the same ACPI device.
> 
> Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
> ---
>  drivers/i2c/i2c-core.c | 111 ++++++++++++++++++++++++++++++++++++++++++-------
>  include/linux/i2c.h    |  13 ++++++
>  2 files changed, 109 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
> index 5fb80b8..a69a7b4 100644
> --- a/drivers/i2c/i2c-core.c
> +++ b/drivers/i2c/i2c-core.c
> @@ -627,7 +627,7 @@ static void i2c_dev_set_name(struct i2c_adapter *adap,
>  	struct acpi_device *adev = ACPI_COMPANION(&client->dev);
>  
>  	if (adev) {
> -		dev_set_name(&client->dev, "i2c-%s", acpi_dev_name(adev));
> +		dev_set_name(&client->dev, "i2c-%s", client->name);
>  		return;
>  	}
>  
> @@ -1080,24 +1080,44 @@ static void of_i2c_register_devices(struct i2c_adapter *adap) { }
>  /* ACPI support code */
>  
>  #if IS_ENABLED(CONFIG_ACPI)
> +/*
> + * acpi_i2c_add_resource is a callback, which is called while walking
> + * name spaces, adding a limit allows for faster processing, without
> + * using reallocation,
> + * Adding some limit for max adresses in resource. Currently we see
> + * max only 3 addresses, so 20 is more than enough
> + */
> +#define MAX_CRS_ELEMENTS	20
> +struct i2c_resource_info {
> +	unsigned short addr[MAX_CRS_ELEMENTS];
> +	unsigned short flags[MAX_CRS_ELEMENTS];
> +	int count;
> +	int common_irq;
> +};
> +
>  static int acpi_i2c_add_resource(struct acpi_resource *ares, void *data)
>  {
> -	struct i2c_board_info *info = data;
> +	struct i2c_resource_info *rcs_info = data;
>  
>  	if (ares->type == ACPI_RESOURCE_TYPE_SERIAL_BUS) {
>  		struct acpi_resource_i2c_serialbus *sb;
>  
>  		sb = &ares->data.i2c_serial_bus;
>  		if (sb->type == ACPI_RESOURCE_SERIAL_TYPE_I2C) {
> -			info->addr = sb->slave_address;
> +			if (rcs_info->count >= MAX_CRS_ELEMENTS)
> +				return 1; /* Simply ignore adding */
> +			rcs_info->addr[rcs_info->count] =
> +							sb->slave_address;
>  			if (sb->access_mode == ACPI_I2C_10BIT_MODE)
> -				info->flags |= I2C_CLIENT_TEN;
> +				rcs_info->flags[rcs_info->count] =
> +								I2C_CLIENT_TEN;
> +			rcs_info->count++;
>  		}
> -	} else if (info->irq < 0) {
> +	} else if (rcs_info->common_irq < 0) {
>  		struct resource r;
>  
>  		if (acpi_dev_resource_interrupt(ares, 0, &r))
> -			info->irq = r.start;
> +			rcs_info->common_irq = r.start;
>  	}
>  
>  	/* Tell the ACPI core to skip this resource */
> @@ -1111,7 +1131,10 @@ static acpi_status acpi_i2c_add_device(acpi_handle handle, u32 level,
>  	struct list_head resource_list;
>  	struct i2c_board_info info;
>  	struct acpi_device *adev;
> +	struct i2c_resource_info rcs_info;
> +	struct i2c_client *i2c_client;
>  	int ret;
> +	int i;
>  
>  	if (acpi_bus_get_device(handle, &adev))
>  		return AE_OK;
> @@ -1120,23 +1143,42 @@ static acpi_status acpi_i2c_add_device(acpi_handle handle, u32 level,
>  
>  	memset(&info, 0, sizeof(info));
>  	info.acpi_node.companion = adev;
> -	info.irq = -1;
> +
> +	memset(&rcs_info, 0, sizeof(rcs_info));
> +	rcs_info.common_irq = -1;
>  
>  	INIT_LIST_HEAD(&resource_list);
>  	ret = acpi_dev_get_resources(adev, &resource_list,
> -				     acpi_i2c_add_resource, &info);
> +				     acpi_i2c_add_resource, &rcs_info);
>  	acpi_dev_free_resource_list(&resource_list);
>  
> -	if (ret < 0 || !info.addr)
> +	if (ret < 0)
>  		return AE_OK;
>  
>  	adev->power.flags.ignore_parent = true;
> -	strlcpy(info.type, dev_name(&adev->dev), sizeof(info.type));
> -	if (!i2c_new_device(adapter, &info)) {
> -		adev->power.flags.ignore_parent = false;
> -		dev_err(&adapter->dev,
> -			"failed to add I2C device %s from ACPI\n",
> -			dev_name(&adev->dev));
> +	info.irq = rcs_info.common_irq;
> +	for (i = 0; i < rcs_info.count; ++i) {

Instead of this, would it make sense if you do the device creation in
acpi_i2c_add_resource() for each enumerated device?

At least it would look better than this ;-)

> +		if (!rcs_info.addr[i])
> +			continue;
> +		info.addr = rcs_info.addr[i];
> +		info.flags = rcs_info.flags[i];
> +		/* Status quo, when only one address is present */
> +		if (rcs_info.count > 1)
> +			snprintf(info.type, sizeof(info.type), "%s:%03x",
> +						dev_name(&adev->dev),
> +						info.addr);
> +		else
> +			strlcpy(info.type, dev_name(&adev->dev),
> +							sizeof(info.type));
> +		i2c_client = i2c_new_device(adapter, &info);
> +		if (!i2c_client) {
> +			if (!i)
> +				adev->power.flags.ignore_parent = false;
> +			dev_err(&adapter->dev,
> +				"failed to add I2C device %s from ACPI\n",
> +					dev_name(&adev->dev));
> +			break;
> +		}
>  	}
>  
>  	return AE_OK;
> @@ -1168,6 +1210,45 @@ static void acpi_i2c_register_devices(struct i2c_adapter *adap)
>  	if (ACPI_FAILURE(status))
>  		dev_warn(&adap->dev, "failed to enumerate I2C slaves\n");
>  }
> +
> +/* Helper functions to get companion addresses */
> +struct acpi_comp_arg {
> +	struct acpi_device *acpi_dev;
> +	void (*callback)(struct i2c_client *);
> +};
> +
> +static int i2c_acpi_companion(struct device *dev, void *_arg)
> +{
> +	struct acpi_comp_arg *arg = _arg;
> +
> +	if (arg->acpi_dev == ACPI_COMPANION(dev)) {
> +		struct i2c_client *client;
> +
> +		client = to_i2c_client(dev);
> +		arg->callback(client);
> +	}
> +
> +	return 0;
> +}
> +

Missing kernel doc here.

> +int i2c_for_each_acpi_comp_client(struct i2c_client *client,
> +					void (*callback)(struct i2c_client *))
> +{
> +	struct acpi_comp_arg arg;
> +	int found;
> +
> +	if (!client)
> +		return -EINVAL;
> +
> +	arg.acpi_dev = ACPI_COMPANION(&client->dev);
> +	arg.callback = callback;
> +	found = device_for_each_child(&client->adapter->dev, &arg,
> +							i2c_acpi_companion);
> +
> +	return found;
> +}
> +EXPORT_SYMBOL_GPL(i2c_for_each_acpi_comp_client);

Since devices with multiple addresses seem to exist in real world, I
think it would be beneficial to add a bit more generic implementation of
the above to the I2C core instead. Then non-ACPI systems could also take
advantage of it.

> +
>  #else
>  static inline void acpi_i2c_register_devices(struct i2c_adapter *adap) {}
>  #endif /* CONFIG_ACPI */
> diff --git a/include/linux/i2c.h b/include/linux/i2c.h
> index deddeb8..ce75c73 100644
> --- a/include/linux/i2c.h
> +++ b/include/linux/i2c.h
> @@ -323,6 +323,19 @@ extern struct i2c_client *
>  i2c_new_dummy(struct i2c_adapter *adap, u16 address);
>  
>  extern void i2c_unregister_device(struct i2c_client *);
> +
> +#if IS_ENABLED(CONFIG_ACPI)
> +/* Callback to get i2c_client instance for ACPI i2 resource */
> +int i2c_for_each_acpi_comp_client(struct i2c_client *client,
> +					void (*callback)(struct i2c_client *));
> +#else
> +int i2c_for_each_acpi_comp_client(struct i2c_client *client,
> +					int (*callback)(struct i2c_client *))
> +{
> +	return 0;
> +}
> +#endif
> +
>  #endif /* I2C */
>  
>  /* Mainboard arch_initcall() code should register all its I2C devices.
> -- 
> 1.7.11.7
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
