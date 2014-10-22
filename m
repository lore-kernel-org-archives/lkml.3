Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933551AbaJVXhs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 19:37:48 -0400
Received: from galahad.ideasonboard.com ([185.26.127.97]:43236 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932666AbaJVXhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 19:37:46 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Cc: linux-media@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        wsa@the-dreams.de, lars@metafoo.de
Subject: Re: [PATCH 1/2] i2c: Add generic support passing secondary devices addresses
Date: Thu, 23 Oct 2014 02:37:41 +0300
Message-ID: <1923603.aWjhqbNgon@avalon>
User-Agent: KMail/4.12.5 (Linux/3.14.14-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <1413991848-28495-1-git-send-email-jean-michel.hautbois@vodalys.com>
References: <1413991848-28495-1-git-send-email-jean-michel.hautbois@vodalys.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean-Michel,

Thank you for the patch.

On Wednesday 22 October 2014 17:30:47 Jean-Michel Hautbois wrote:
> Some I2C devices have multiple addresses assigned, for example each address
> corresponding to a different internal register map page of the device.
> So far drivers which need support for this have handled this with a driver
> specific and non-generic implementation, e.g. passing the additional address
> via platform data.
> 
> This patch provides a new helper function called i2c_new_secondary_device()
> which is intended to provide a generic way to get the secondary address
> as well as instantiate a struct i2c_client for the secondary address.
> 
> The function expects a pointer to the primary i2c_client, a name
> for the secondary address and an optional default address. The name is used
> as a handle to specify which secondary address to get.
> 
> The default address is used as a fallback in case no secondary address
> was explicitly specified. In case no secondary address and no default
> address were specified the function returns NULL.
> 
> For now the function only supports look-up of the secondary address
> from devicetree, but it can be extended in the future
> to for example support board files and/or ACPI.

As this is core code I believe the DT bindings should be documented somewhere 
in Documentation/devicetree/bindings/i2c/.

> Signed-off-by: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
> ---
>  drivers/i2c/i2c-core.c | 40 ++++++++++++++++++++++++++++++++++++++++
>  include/linux/i2c.h    |  8 ++++++++
>  2 files changed, 48 insertions(+)
> 
> diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
> index 2f90ac6..fd3b07c 100644
> --- a/drivers/i2c/i2c-core.c
> +++ b/drivers/i2c/i2c-core.c
> @@ -1166,6 +1166,46 @@ struct i2c_client *i2c_new_dummy(struct i2c_adapter
> *adapter, u16 address) }
>  EXPORT_SYMBOL_GPL(i2c_new_dummy);
> 
> +/**
> + * i2c_new_secondary_device - Helper to get the instantiated secondary
> address

It does more than that, it also creates the device.

> + * @client: Handle to the primary client
> + * @name: Handle to specify which secondary address to get
> + * @default_addr: Used as a fallback if no secondary address was specified
> + * Context: can sleep
> + *
> + * This returns an I2C client bound to the "dummy" driver based on DT
> parsing.

Could you elaborate on that ? I would explain that the address is retrieved 
from the firmware based on the name, and that default_addr is used in case the 
firmware doesn't provide any information.

> + *
> + * This returns the new i2c client, which should be saved for later use
> with
> + * i2c_unregister_device(); or NULL to indicate an error.
> + */
> +struct i2c_client *i2c_new_secondary_device(struct i2c_client *client,
> +						const char *name,
> +						u16 default_addr)
> +{
> +	int i;
> +	u32 addr;
> +	struct device_node *np;
> +
> +	np = client->dev.of_node;
> +
> +	if (np) {
> +		i = of_property_match_string(np, "reg-names", name);
> +		if (i >= 0)
> +			of_property_read_u32_index(np, "reg", i, &addr);

This call could fail in which case addr will be uninitialized.

> +		else if (default_addr != 0)
> +			addr = default_addr;
> +		else
> +			addr = NULL;

addr isn't a pointer. I'm surprised the compiler hasn't warned you.

> +	} else {
> +		addr = default_addr;
> +	}

The whole logic can be simplified to

	struct device_node *np = client->dev.of_node;
	u32 addr = default_addr;
	int i;

	if (np) {
		i = of_property_match_string(np, "reg-names", name);
		if (i >= 0)
			of_property_read_u32_index(np, "reg", i, &addr);
	}


> +
> +	dev_dbg(&client->adapter->dev, "Address for %s : 0x%x\n", name, addr);
> +	return i2c_new_dummy(client->adapter, addr);
> +}
> +EXPORT_SYMBOL_GPL(i2c_new_secondary_device);
> +
> +
>  /*
> -------------------------------------------------------------------------
> */
> 
>  /* I2C bus adapters -- one roots each I2C or SMBUS segment */
> diff --git a/include/linux/i2c.h b/include/linux/i2c.h
> index b556e0a..8629287 100644
> --- a/include/linux/i2c.h
> +++ b/include/linux/i2c.h
> @@ -322,6 +322,14 @@ extern int i2c_probe_func_quick_read(struct i2c_adapter
> *, unsigned short addr); extern struct i2c_client *
>  i2c_new_dummy(struct i2c_adapter *adap, u16 address);
> 
> +/* Helper function providing a generic way to get the secondary address
> + * as well as a client handle to this extra address.
> + */

The function is already documented in i2c-core.c, I would ditch this comment.

> +extern struct i2c_client *
> +i2c_new_secondary_device(struct i2c_client *client,
> +				const char *name,
> +				u16 default_addr);
> +
>  extern void i2c_unregister_device(struct i2c_client *);
>  #endif /* I2C */

-- 
Regards,

Laurent Pinchart

