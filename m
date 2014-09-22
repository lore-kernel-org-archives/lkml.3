Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814AbaIVKqD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 06:46:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:14269 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753642AbaIVKqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 06:46:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,571,1406617200"; 
   d="scan'208";a="576847208"
Date: Mon, 22 Sep 2014 13:45:55 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Cc: wsa@the-dreams.de, linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, lars@metafoo.de,
        srinivas.pandruvada@linux.intel.com
Subject: Re: [PATCH] i2c: Add generic support passing secondary devices
 addresses
Message-ID: <20140922104555.GQ1786@lahna.fi.intel.com>
References: <1409925739-28188-1-git-send-email-jean-michel.hautbois@vodalys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409925739-28188-1-git-send-email-jean-michel.hautbois@vodalys.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 04:02:19PM +0200, Jean-Michel Hautbois wrote:
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
> 
> Signed-off-by: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>

Sorry, just noticed this one.

Srinivas (CC'd) and I did similar patch series here:

http://patchwork.ozlabs.org/patch/338342/

We should probably collaborate on this one to get both DT and ACPI
supported.

> ---
>  drivers/i2c/i2c-core.c | 40 ++++++++++++++++++++++++++++++++++++++++
>  include/linux/i2c.h    |  8 ++++++++
>  2 files changed, 48 insertions(+)
> 
> diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
> index 632057a..ef31d6f 100644
> --- a/drivers/i2c/i2c-core.c
> +++ b/drivers/i2c/i2c-core.c
> @@ -798,6 +798,46 @@ struct i2c_client *i2c_new_dummy(struct i2c_adapter *adapter, u16 address)
>  }
>  EXPORT_SYMBOL_GPL(i2c_new_dummy);
>  
> +/**
> + * i2c_new_secondary_device - Helper to get the instantiated secondary address
> + * @client: Handle to the primary client
> + * @name: Handle to specify which secondary address to get
> + * @default_addr: Used as a fallback if no secondary address was specified
> + * Context: can sleep
> + *
> + * This returns an I2C client bound to the "dummy" driver based on DT parsing.
> + *
> + * This returns the new i2c client, which should be saved for later use with
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
> +		else if (default_addr != 0)
> +			addr = default_addr;
> +		else
> +			addr = NULL;
> +	} else {
> +		addr = default_addr;
> +	}
> +
> +	dev_dbg(&client->adapter->dev, "Address for %s : 0x%x\n", name, addr);
> +	return i2c_new_dummy(client->adapter, addr);
> +}
> +EXPORT_SYMBOL_GPL(i2c_new_secondary_device);
> +
> +
>  /* ------------------------------------------------------------------------- */
>  
>  /* I2C bus adapters -- one roots each I2C or SMBUS segment */
> diff --git a/include/linux/i2c.h b/include/linux/i2c.h
> index a95efeb..0f190e6 100644
> --- a/include/linux/i2c.h
> +++ b/include/linux/i2c.h
> @@ -322,6 +322,14 @@ extern int i2c_probe_func_quick_read(struct i2c_adapter *, unsigned short addr);
>  extern struct i2c_client *
>  i2c_new_dummy(struct i2c_adapter *adap, u16 address);
>  
> +/* Helper function providing a generic way to get the secondary address
> + * as well as a client handle to this extra address.
> + */
> +extern struct i2c_client *
> +i2c_new_secondary_device(struct i2c_client *client,
> +				const char *name,
> +				u32 default_addr);
> +
>  extern void i2c_unregister_device(struct i2c_client *);
>  #endif /* I2C */
>  
> -- 
> 2.0.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-i2c" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
