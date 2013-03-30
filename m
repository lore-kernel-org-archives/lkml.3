Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284Ab3C3Gs6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 02:48:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:29577 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755057Ab3C3Gsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 02:48:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,377,1363158000"; 
   d="scan'208";a="313991870"
Date: Sat, 30 Mar 2013 08:53:03 +0200
From: Mika Westerberg <mika.westerberg@intel.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.jf.intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 1/6] dma: acpi-dma: introduce ACPI DMA helpers
Message-ID: <20130330065303.GD21804@intel.com>
References: <1364374682-8547-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1364374682-8547-2-git-send-email-andriy.shevchenko@linux.intel.com>
 <20130329203543.GY10326@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130329203543.GY10326@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 30, 2013 at 02:05:43AM +0530, Vinod Koul wrote:
> On Wed, Mar 27, 2013 at 10:57:57AM +0200, Andy Shevchenko wrote:
> > + * @dev:	struct device to get DMA request from
> > + * @index:	index of FixedDMA descriptor for @dev
> > + *
> > + * Returns pointer to appropriate dma channel on success or NULL on error.
> > + */
> > +struct dma_chan *acpi_dma_request_slave_chan_by_index(struct device *dev,
> > +		size_t index)
> > +{
> So i think this will be called by client driver to request a channel right?
> 
> If so how does client find the device pointer for dma controller.

It doesn't have to. the client passes pointer to it's own device to this
function.

> And index is a global one, right? What is it use ?

It is the index in the client device's ACPI DMA resources. It is explained
in the documentation but it refers to something like:

	Device (SPI0) 
	{
		Method (_CRS, 0, NotSerialized)
		{
			Name (RBUF, ResourceTemplate ()
			{
				// Bunch of resources...
				FixedDMA(...)	// This will be index 0
				FixedDMA(...)	// and this is 1
				// More resources..
			}

			Return (RBUF)
		}
	}

So we use the index to refer the correct DMA resource in the resource list.

> > +	struct acpi_dma_parser_data pdata;
> > +	struct acpi_dma_spec *dma_spec = &pdata.dma_spec;
> > +	struct list_head resource_list;
> > +	struct acpi_device *adev;
> > +	struct acpi_dma *adma;
> > +	struct dma_chan *chan;
> > +
> > +	/* Check if the device was enumerated by ACPI */
> > +	if (!dev || !ACPI_HANDLE(dev))
> > +		return NULL;
> > +
> > +	if (acpi_bus_get_device(ACPI_HANDLE(dev), &adev))
> > +		return NULL;
> > +
> > +	memset(&pdata, 0, sizeof(pdata));
> > +	pdata.index = index;
> > +
> > +	/* Initial values for the request line and channel */
> > +	dma_spec->chan_id = -1;
> > +	dma_spec->slave_id = -1;
> > +
> > +	INIT_LIST_HEAD(&resource_list);
> > +	acpi_dev_get_resources(adev, &resource_list,
> > +			acpi_dma_parse_fixed_dma, &pdata);
> > +	acpi_dev_free_resource_list(&resource_list);
> > +
> > +	if (dma_spec->slave_id < 0 || dma_spec->chan_id < 0)
> > +		return NULL;
> > +
> > +	mutex_lock(&acpi_dma_lock);
> > +
> > +	list_for_each_entry(adma, &acpi_dma_list, dma_controllers) {
> > +		dma_spec->dev = adma->dev;
> > +		chan = adma->acpi_dma_xlate(dma_spec, adma);
> > +		if (chan) {
> > +			mutex_unlock(&acpi_dma_lock);
> > +			return chan;
> > +		}
> > +	}
> > +
> > +	mutex_unlock(&acpi_dma_lock);
> > +	return NULL;
> in this and error handling you are not doing anything different so why code
> duplication?

There is no specific reason for that. We can change it to goto + return
chan in the next revision.

> 
> > +}
> > +EXPORT_SYMBOL_GPL(acpi_dma_request_slave_chan_by_index);
> > +
> > +/**
> > + * acpi_dma_request_slave_chan_by_name - Get the DMA slave channel
> > + * @dev:	struct device to get DMA request from
> > + * @name:	represents corresponding FixedDMA descriptor for @dev
> > + *
> > + * In order to support both Device Tree and ACPI in a single driver we
> > + * translate the names "tx" and "rx" here based on the most common case where
> > + * the first FixedDMA descriptor is TX and second is RX.
> > + *
> > + * Returns pointer to appropriate dma channel on success or NULL on error.
> > + */
> > +struct dma_chan *acpi_dma_request_slave_chan_by_name(struct device *dev,
> > +		const char *name)
> > +{
> > +	size_t index;
> > +
> > +	if (!strcmp(name, "tx"))
> > +		index = 0;
> > +	else if (!strcmp(name, "rx"))
> > +		index = 1;
> > +	else
> > +		return NULL;
> > +
> > +	return acpi_dma_request_slave_chan_by_index(dev, index);
> are you going to a have a different descriptor for tx and rx? Is index only for
> tx = 0 and rx =1 always. How would a controller be represented which has 8
> channels, each channel can do DMA in either direction

This is a special case so that we can cope with
dma_request_slave_channel().

But this has nothing to do with the controller. This is a client API and
the FixedDMA descriptors are only associated with clients.

For example on Lynxpoint we have a DMA controller you describe above and we
can use dma_request_slave_channel() with that for each client device
(HSUART, SPI and I2C) without problems.

> > +}
> > +EXPORT_SYMBOL_GPL(acpi_dma_request_slave_chan_by_name);
> > +
> > +/**
> > + * acpi_dma_simple_xlate - Simple ACPI DMA engine translation helper
> > + * @dma_spec: pointer to ACPI DMA specifier
> > + * @adma: pointer to ACPI DMA controller data
> > + *
> > + * A simple translation function for ACPI based devices. Passes &struct
> > + * dma_spec to the DMA controller driver provided filter function. Returns
> > + * pointer to the channel if found or %NULL otherwise.
> > + */
> > +struct dma_chan *acpi_dma_simple_xlate(struct acpi_dma_spec *dma_spec,
> > +		struct acpi_dma *adma)
> > +{
> > +	struct acpi_dma_filter_info *info = adma->data;
> what is the purpose of filter here?

It is pretty much the same as with DeviceTree version. There is an example
of that in the dw_dmac ACPI support patch include in this series.

Basically the controller driver passes the filter (well the
acpi_dma_filter_info) structure to acpi_dma_controller_register(). It can
then do the requred setup for the channel once it is found.

> > +
> > +	if (!info || !info->filter_fn)
> > +		return NULL;
> > +
> > +	return dma_request_channel(info->dma_cap, info->filter_fn, dma_spec);
> > +}
> > +EXPORT_SYMBOL_GPL(acpi_dma_simple_xlate);
> > diff --git a/include/linux/acpi_dma.h b/include/linux/acpi_dma.h
> > new file mode 100644
> > index 0000000..d09deab
> > --- /dev/null
> > +++ b/include/linux/acpi_dma.h
> > @@ -0,0 +1,116 @@
> > +/*
> > + * ACPI helpers for DMA request / controller
> > + *
> > + * Based on of_dma.h
> > + *
> > + * Copyright (C) 2013, Intel Corporation
> > + * Author: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + */
> > +
> > +#ifndef __LINUX_ACPI_DMA_H
> > +#define __LINUX_ACPI_DMA_H
> > +
> > +#include <linux/list.h>
> > +#include <linux/device.h>
> > +#include <linux/dmaengine.h>
> > +
> > +/**
> > + * struct acpi_dma_spec - slave device DMA resources
> > + * @chan_id:	channel unique id
> > + * @slave_id:	request line unique id
> > + * @dev:	struct device of the DMA controller to be used in the filter
> > + *		function
> > + */
> > +struct acpi_dma_spec {
> > +	int		chan_id;
> > +	int		slave_id;
> > +	struct device	*dev;
> > +};
> is this the representation of Fixed DMA, if so why have you omitted transfer widths?
> I can see obvious benefits of using that 

It is, yes. But we haven't been using the widths with our hardware. BIOS
seems to set it always 32-bit even though we should access the peripheral
FIFO using 8-bit transfers for example.

The client never sees these when it uses dma_request_slave_channel() API.
