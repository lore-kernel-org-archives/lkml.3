Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946145Ab3BHIun (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 03:50:43 -0500
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:40064 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946115Ab3BHIum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 03:50:42 -0500
X-Greylist: delayed 1181 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Feb 2013 03:50:41 EST
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.ucs.cam.ac.uk/email/scanner/
Message-ID: <5114B7B8.2080607@jic23.retrosnub.co.uk>
Date: Fri, 08 Feb 2013 08:30:48 +0000
From: Jonathan Cameron <jic23@jic23.retrosnub.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: linux-iio@vger.kernel.org, Jonathan Cameron <jic23@kernel.org>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Doug Anderson <dianders@chromium.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, Anton Vorontsov <cbou@mail.ru>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH v5] iio: Add OF support
References: <1360256940-19438-1-git-send-email-linux@roeck-us.net>
In-Reply-To: <1360256940-19438-1-git-send-email-linux@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/13 17:09, Guenter Roeck wrote:
> Provide bindings and parse OF data during initialization.
>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Looks fine to me.  Will give it a few more days to see what others
have to say.

Thanks Guenter
> ---
> v5:
> - Updated examples in bindings.
> v4:
> - Fixed wrong parameter to dummy of_iio_channel_get_by_name if CONFIG_OF is
>    undefined, and wrong return value.
> - Initialize indio_dev->of_node in iio_device_register if the calling driver
>    neglected to do it.
> v3:
> - Cleaned up documentation (formatting, left-over clock references)
> - Updated bindings description to permit sub-devices
> - When searching for iio devices, use the pointer to the iio device type instead
>    of strcmp. Rename iio_dev_type to iio_device_type (to match other device
>    types) and make it global for that purpose. Check the OF node first, then the
>    device type, as the node is less likely to match.
> - Move the common code in of_iio_channel_get and of_iio_channel_get_all to
>    __of_iio_channel_get.
> - Return NULL from of_iio_channel_get_by_name if nothing is found, or
>    an error if there is a problem with consistency or if the provider device is
>    not yet available.
> - In iio_channel_get, return if of_iio_channel_get_by_name() returns a channel
>    or an error, and continue otherwise.
> v2:
> - Rebased to iio/togreg
> - Documentation update per feedback
> - Dropped io-channel-output-names from the bindings document. The property is
>    not used in the code, and it is not entirely clear what it would be used for.
>    If there is a need for it, we can add it back in later on.
> - Don't export OF specific API calls
> - For OF support, no longer depend on iio_map
> - Add #ifdef CONFIG_OF where appropriate, and ensure that the code still builds
>    if it is not selected.
> - Change iio_channel_get to take device pointer as argument instead of device
>    name. Retain old API as of_iio_channel_get_sys.
> - iio_channel_get now works for both OF and non-OF configurations
> - Use regulator to get vref for max1363 driver.
>
>   .../devicetree/bindings/iio/iio-bindings.txt       |   97 +++++++++++
>   drivers/iio/iio_core.h                             |    1 +
>   drivers/iio/industrialio-core.c                    |    8 +-
>   drivers/iio/inkern.c                               |  171 ++++++++++++++++++++
>   4 files changed, 275 insertions(+), 2 deletions(-)
>   create mode 100644 Documentation/devicetree/bindings/iio/iio-bindings.txt
>
> diff --git a/Documentation/devicetree/bindings/iio/iio-bindings.txt b/Documentation/devicetree/bindings/iio/iio-bindings.txt
> new file mode 100644
> index 0000000..1182845
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/iio/iio-bindings.txt
> @@ -0,0 +1,97 @@
> +This binding is a work-in-progress. It is derived from clock bindings,
> +and based on suggestions from Lars-Peter Clausen [1].
> +
> +Sources of IIO channels can be represented by any node in the device
> +tree. Those nodes are designated as IIO providers. IIO consumer
> +nodes use a phandle and IIO specifier pair to connect IIO provider
> +outputs to IIO inputs. Similar to the gpio specifiers, an IIO
> +specifier is an array of one or more cells identifying the IIO
> +output on a device. The length of an IIO specifier is defined by the
> +value of a #io-channel-cells property in the IIO provider node.
> +
> +[1] http://marc.info/?l=linux-iio&m=135902119507483&w=2
> +
> +==IIO providers==
> +
> +Required properties:
> +#io-channel-cells: Number of cells in an IIO specifier; Typically 0 for nodes
> +		   with a single IIO output and 1 for nodes with multiple
> +		   IIO outputs.
> +
> +Example for a simple configuration with no trigger:
> +
> +	adc: voltage-sensor@35 {
> +		compatible = "maxim,max1139";
> +		reg = <0x35>;
> +		#io-channel-cells = <1>;
> +	};
> +
> +Example for a configuration with trigger:
> +
> +	adc@35 {
> +		compatible = "some-vendor,some-adc";
> +		reg = <0x35>;
> +
> +		adc1: iio-device@0 {
> +			#io-channel-cells = <1>;
> +			/* other properties */
> +		};
> +		adc2: iio-device@1 {
> +			#io-channel-cells = <1>;
> +			/* other properties */
> +		};
> +	};
> +
> +==IIO consumers==
> +
> +Required properties:
> +io-channels:	List of phandle and IIO specifier pairs, one pair
> +		for each IIO input to the device. Note: if the
> +		IIO provider specifies '0' for #io-channel-cells,
> +		then only the phandle portion of the pair will appear.
> +
> +Optional properties:
> +io-channel-names:
> +		List of IIO input name strings sorted in the same
> +		order as the io-channels property. Consumers drivers
> +		will use io-channel-names to match IIO input names
> +		with IIO specifiers.
> +io-channel-ranges:
> +		Empty property indicating that child nodes can inherit named
> +		IIO channels from this node. Useful for bus nodes to provide
> +		and IIO channel to their children.
> +
> +For example:
> +
> +	device {
> +		io-channels = <&adc 1>, <&ref 0>;
> +		io-channel-names = "vcc", "vdd";
> +	};
> +
> +This represents a device with two IIO inputs, named "vcc" and "vdd".
> +The vcc channel is connected to output 1 of the &adc device, and the
> +vdd channel is connected to output 0 of the &ref device.
> +
> +==Example==
> +
> +	adc: max1139@35 {
> +		compatible = "maxim,max1139";
> +		reg = <0x35>;
> +		#io-channel-cells = <1>;
> +	};
> +
> +	...
> +
> +	iio_hwmon {
> +		compatible = "iio-hwmon";
> +		io-channels = <&adc 0>, <&adc 1>, <&adc 2>,
> +			<&adc 3>, <&adc 4>, <&adc 5>,
> +			<&adc 6>, <&adc 7>, <&adc 8>,
> +			<&adc 9>;
> +	};
> +
> +	some_consumer {
> +		compatible = "some-consumer";
> +		io-channels = <&adc 10>, <&adc 11>;
> +		io-channel-names = "adc1", "adc2";
> +	};
> diff --git a/drivers/iio/iio_core.h b/drivers/iio/iio_core.h
> index f652e6a..05c1b74 100644
> --- a/drivers/iio/iio_core.h
> +++ b/drivers/iio/iio_core.h
> @@ -18,6 +18,7 @@
>   struct iio_chan_spec;
>   struct iio_dev;
>
> +extern struct device_type iio_device_type;
>
>   int __iio_add_chan_devattr(const char *postfix,
>   			   struct iio_chan_spec const *chan,
> diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
> index 8848f16..6d8b027 100644
> --- a/drivers/iio/industrialio-core.c
> +++ b/drivers/iio/industrialio-core.c
> @@ -847,7 +847,7 @@ static void iio_dev_release(struct device *device)
>   	kfree(indio_dev);
>   }
>
> -static struct device_type iio_dev_type = {
> +struct device_type iio_device_type = {
>   	.name = "iio_device",
>   	.release = iio_dev_release,
>   };
> @@ -869,7 +869,7 @@ struct iio_dev *iio_device_alloc(int sizeof_priv)
>
>   	if (dev) {
>   		dev->dev.groups = dev->groups;
> -		dev->dev.type = &iio_dev_type;
> +		dev->dev.type = &iio_device_type;
>   		dev->dev.bus = &iio_bus_type;
>   		device_initialize(&dev->dev);
>   		dev_set_drvdata(&dev->dev, (void *)dev);
> @@ -960,6 +960,10 @@ int iio_device_register(struct iio_dev *indio_dev)
>   {
>   	int ret;
>
> +	/* If the calling driver did not initialize of_node, do it here */
> +	if (!indio_dev->dev.of_node && indio_dev->dev.parent)
> +		indio_dev->dev.of_node = indio_dev->dev.parent->of_node;
> +
>   	/* configure elements for the chrdev */
>   	indio_dev->dev.devt = MKDEV(MAJOR(iio_devt), indio_dev->id);
>
> diff --git a/drivers/iio/inkern.c b/drivers/iio/inkern.c
> index b289915..795d100 100644
> --- a/drivers/iio/inkern.c
> +++ b/drivers/iio/inkern.c
> @@ -10,6 +10,7 @@
>   #include <linux/export.h>
>   #include <linux/slab.h>
>   #include <linux/mutex.h>
> +#include <linux/of.h>
>
>   #include <linux/iio/iio.h>
>   #include "iio_core.h"
> @@ -92,6 +93,164 @@ static const struct iio_chan_spec
>   	return chan;
>   }
>
> +#ifdef CONFIG_OF
> +
> +static int iio_dev_node_match(struct device *dev, void *data)
> +{
> +	return dev->of_node == data && dev->type == &iio_device_type;
> +}
> +
> +static int __of_iio_channel_get(struct iio_channel *channel,
> +				struct device_node *np, int index)
> +{
> +	struct device *idev;
> +	struct iio_dev *indio_dev;
> +	int err;
> +	struct of_phandle_args iiospec;
> +
> +	err = of_parse_phandle_with_args(np, "io-channels",
> +					 "#io-channel-cells",
> +					 index, &iiospec);
> +	if (err)
> +		return err;
> +
> +	idev = bus_find_device(&iio_bus_type, NULL, iiospec.np,
> +			       iio_dev_node_match);
> +	of_node_put(iiospec.np);
> +	if (idev == NULL)
> +		return -EPROBE_DEFER;
> +
> +	indio_dev = dev_to_iio_dev(idev);
> +	channel->indio_dev = indio_dev;
> +	index = iiospec.args_count ? iiospec.args[0] : 0;
> +	if (index >= indio_dev->num_channels) {
> +		return -EINVAL;
> +		goto err_put;
> +	}
> +	channel->channel = &indio_dev->channels[index];
> +
> +	return 0;
> +
> +err_put:
> +	iio_device_put(indio_dev);
> +	return err;
> +}
> +
> +static struct iio_channel *of_iio_channel_get(struct device_node *np, int index)
> +{
> +	struct iio_channel *channel;
> +	int err;
> +
> +	if (index < 0)
> +		return ERR_PTR(-EINVAL);
> +
> +	channel = kzalloc(sizeof(*channel), GFP_KERNEL);
> +	if (channel == NULL)
> +		return ERR_PTR(-ENOMEM);
> +
> +	err = __of_iio_channel_get(channel, np, index);
> +	if (err)
> +		goto err_free_channel;
> +
> +	return channel;
> +
> +err_free_channel:
> +	kfree(channel);
> +	return ERR_PTR(err);
> +}
> +
> +static struct iio_channel *of_iio_channel_get_by_name(struct device_node *np,
> +						      const char *name)
> +{
> +	struct iio_channel *chan = NULL;
> +
> +	/* Walk up the tree of devices looking for a matching iio channel */
> +	while (np) {
> +		int index = 0;
> +
> +		/*
> +		 * For named iio channels, first look up the name in the
> +		 * "io-channel-names" property.  If it cannot be found, the
> +		 * index will be an error code, and of_iio_channel_get()
> +		 * will fail.
> +		 */
> +		if (name)
> +			index = of_property_match_string(np, "io-channel-names",
> +							 name);
> +		chan = of_iio_channel_get(np, index);
> +		if (!IS_ERR(chan))
> +			break;
> +		else if (name && index >= 0) {
> +			pr_err("ERROR: could not get IIO channel %s:%s(%i)\n",
> +				np->full_name, name ? name : "", index);
> +			return chan;
> +		}
> +
> +		/*
> +		 * No matching IIO channel found on this node.
> +		 * If the parent node has a "io-channel-ranges" property,
> +		 * then we can try one of its channels.
> +		 */
> +		np = np->parent;
> +		if (np && !of_get_property(np, "io-channel-ranges", NULL))
> +			break;
> +	}
> +	return chan;
> +}
> +
> +static struct iio_channel *of_iio_channel_get_all(struct device *dev)
> +{
> +	struct iio_channel *chans;
> +	int i, mapind, nummaps = 0;
> +	int ret;
> +
> +	do {
> +		ret = of_parse_phandle_with_args(dev->of_node,
> +						 "io-channels",
> +						 "#io-channel-cells",
> +						 nummaps, NULL);
> +		if (ret < 0)
> +			break;
> +	} while (++nummaps);
> +
> +	if (nummaps == 0)	/* no error, return NULL to search map table */
> +		return NULL;
> +
> +	/* NULL terminated array to save passing size */
> +	chans = kcalloc(nummaps + 1, sizeof(*chans), GFP_KERNEL);
> +	if (chans == NULL)
> +		return ERR_PTR(-ENOMEM);
> +
> +	/* Search for OF matches */
> +	for (mapind = 0; mapind < nummaps; mapind++) {
> +		ret = __of_iio_channel_get(&chans[mapind], dev->of_node,
> +					   mapind);
> +		if (ret)
> +			goto error_free_chans;
> +	}
> +	return chans;
> +
> +error_free_chans:
> +	for (i = 0; i < mapind; i++)
> +		iio_device_put(chans[i].indio_dev);
> +	kfree(chans);
> +	return ERR_PTR(ret);
> +}
> +
> +#else /* CONFIG_OF */
> +
> +static inline struct iio_channel *
> +of_iio_channel_get_by_name(struct device_node *np, const char *name)
> +{
> +	return NULL;
> +}
> +
> +static inline struct iio_channel *of_iio_channel_get_all(struct device *dev)
> +{
> +	return NULL;
> +}
> +
> +#endif /* CONFIG_OF */
>
>   static struct iio_channel *iio_channel_get_sys(const char *name,
>   					       const char *channel_name)
> @@ -150,7 +309,14 @@ struct iio_channel *iio_channel_get(struct device *dev,
>   				    const char *channel_name)
>   {
>   	const char *name = dev ? dev_name(dev) : NULL;
> +	struct iio_channel *channel;
>
> +	if (dev) {
> +		channel = of_iio_channel_get_by_name(dev->of_node,
> +						     channel_name);
> +		if (channel != NULL)
> +			return channel;
> +	}
>   	return iio_channel_get_sys(name, channel_name);
>   }
>   EXPORT_SYMBOL_GPL(iio_channel_get);
> @@ -173,6 +339,11 @@ struct iio_channel *iio_channel_get_all(struct device *dev)
>
>   	if (dev == NULL)
>   		return ERR_PTR(-EINVAL);
> +
> +	chans = of_iio_channel_get_all(dev);
> +	if (chans)
> +		return chans;
> +
>   	name = dev_name(dev);
>
>   	mutex_lock(&iio_map_list_lock);
>

