Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756518AbaGSX1c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 19:27:32 -0400
Received: from mga03.intel.com ([143.182.124.21]:7772 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756433AbaGSX1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 19:27:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,693,1400050800"; 
   d="scan'208";a="459061557"
Message-ID: <53CAFEE0.1060004@linux.intel.com>
Date: Sat, 19 Jul 2014 16:27:28 -0700
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Reyad Attiyat <reyad.attiyat@gmail.com>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, jic23@kernel.org
Subject: Re: [PATCH v6 3/4] iio: hid-sensor-magn-3d: Scan for usage attributes
 before setting up iio channels
References: <1405621109-21147-1-git-send-email-reyad.attiyat@gmail.com> <1405621109-21147-4-git-send-email-reyad.attiyat@gmail.com>
In-Reply-To: <1405621109-21147-4-git-send-email-reyad.attiyat@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 07/17/2014 11:18 AM, Reyad Attiyat wrote:
> Scan for and count the HID usage attributes supported by the driver.
> This allows for the driver to only setup the IIO channels for the
> sensor usages present in the HID USB reports.
>
> Changes from v5
> -Fixed kernel panic from invalid pointer dereference
> -Fixed variable assignment style
>
> Signed-off-by: Reyad Attiyat <reyad.attiyat@gmail.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
> ---
>   drivers/iio/magnetometer/hid-sensor-magn-3d.c | 149 ++++++++++++++++++--------
>   1 file changed, 105 insertions(+), 44 deletions(-)
>
> diff --git a/drivers/iio/magnetometer/hid-sensor-magn-3d.c b/drivers/iio/magnetometer/hid-sensor-magn-3d.c
> index b2b0937..d3b9114 100644
> --- a/drivers/iio/magnetometer/hid-sensor-magn-3d.c
> +++ b/drivers/iio/magnetometer/hid-sensor-magn-3d.c
> @@ -42,7 +42,12 @@ struct magn_3d_state {
>   	struct hid_sensor_hub_callbacks callbacks;
>   	struct hid_sensor_common common_attributes;
>   	struct hid_sensor_hub_attribute_info magn[MAGN_3D_CHANNEL_MAX];
> -	u32 magn_val[MAGN_3D_CHANNEL_MAX];
> +
> +	/* dynamically sized array to hold sensor values */
> +	u32 *iio_vals;
> +	/* array of pointers to sensor value */
> +	u32 *magn_val_addr[MAGN_3D_CHANNEL_MAX];
> +
>   	int scale_pre_decml;
>   	int scale_post_decml;
>   	int scale_precision;
> @@ -66,7 +71,6 @@ static const struct iio_chan_spec magn_3d_channels[] = {
>   		BIT(IIO_CHAN_INFO_SCALE) |
>   		BIT(IIO_CHAN_INFO_SAMP_FREQ) |
>   		BIT(IIO_CHAN_INFO_HYSTERESIS),
> -		.scan_index = CHANNEL_SCAN_INDEX_X,
>   	}, {
>   		.type = IIO_MAGN,
>   		.modified = 1,
> @@ -76,7 +80,6 @@ static const struct iio_chan_spec magn_3d_channels[] = {
>   		BIT(IIO_CHAN_INFO_SCALE) |
>   		BIT(IIO_CHAN_INFO_SAMP_FREQ) |
>   		BIT(IIO_CHAN_INFO_HYSTERESIS),
> -		.scan_index = CHANNEL_SCAN_INDEX_Y,
>   	}, {
>   		.type = IIO_MAGN,
>   		.modified = 1,
> @@ -86,7 +89,6 @@ static const struct iio_chan_spec magn_3d_channels[] = {
>   		BIT(IIO_CHAN_INFO_SCALE) |
>   		BIT(IIO_CHAN_INFO_SAMP_FREQ) |
>   		BIT(IIO_CHAN_INFO_HYSTERESIS),
> -		.scan_index = CHANNEL_SCAN_INDEX_Z,
>   	}
>   };
>   
> @@ -126,8 +128,8 @@ static int magn_3d_read_raw(struct iio_dev *indio_dev,
>   		msleep_interruptible(poll_value * 2);
>   
>   		report_id =
> -			magn_state->magn[chan->scan_index].report_id;
> -		address = magn_3d_addresses[chan->scan_index];
> +			magn_state->magn[chan->address].report_id;
> +		address = magn_3d_addresses[chan->address];
>   		if (report_id >= 0)
>   			*val = sensor_hub_input_attr_get_raw_value(
>   				magn_state->common_attributes.hsdev,
> @@ -218,8 +220,8 @@ static int magn_3d_proc_event(struct hid_sensor_hub_device *hsdev,
>   	dev_dbg(&indio_dev->dev, "magn_3d_proc_event\n");
>   	if (atomic_read(&magn_state->common_attributes.data_ready))
>   		hid_sensor_push_data(indio_dev,
> -				magn_state->magn_val,
> -				sizeof(magn_state->magn_val));
> +				magn_state->iio_vals,
> +				sizeof(magn_state->iio_vals));
>   
>   	return 0;
>   }
> @@ -233,52 +235,119 @@ static int magn_3d_capture_sample(struct hid_sensor_hub_device *hsdev,
>   	struct iio_dev *indio_dev = platform_get_drvdata(priv);
>   	struct magn_3d_state *magn_state = iio_priv(indio_dev);
>   	int offset;
> -	int ret = -EINVAL;
> +	int ret = 0;
> +	u32 *iio_val = NULL;
>   
>   	switch (usage_id) {
>   	case HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_X_AXIS:
>   	case HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_Y_AXIS:
>   	case HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_Z_AXIS:
> -		offset = usage_id - HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_X_AXIS;
> -		magn_state->magn_val[CHANNEL_SCAN_INDEX_X + offset] =
> -						*(u32 *)raw_data;
> -		ret = 0;
> +		offset = (usage_id - HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_X_AXIS)
> +				+ CHANNEL_SCAN_INDEX_X;
>   	break;
>   	default:
> -		break;
> +		return -EINVAL;
>   	}
>   
> +	iio_val = magn_state->magn_val_addr[offset];
> +
> +	if (iio_val != NULL)
> +		*iio_val = *((u32 *)raw_data);
> +	else
> +		ret = -EINVAL;
> +
>   	return ret;
>   }
>   
>   /* Parse report which is specific to an usage id*/
>   static int magn_3d_parse_report(struct platform_device *pdev,
>   				struct hid_sensor_hub_device *hsdev,
> -				struct iio_chan_spec *channels,
> +				struct iio_chan_spec **channels,
> +				int *chan_count,
>   				unsigned usage_id,
>   				struct magn_3d_state *st)
>   {
> -	int ret;
>   	int i;
> +	int attr_count = 0;
> +	struct iio_chan_spec *_channels;
> +
> +	/* Scan for each usage attribute supported */
> +	for (i = 0; i < MAGN_3D_CHANNEL_MAX; i++) {
> +		int status;
> +		u32 address = magn_3d_addresses[i];
> +
> +		/* Check if usage attribute exists in the sensor hub device */
> +		status = sensor_hub_input_get_attribute_info(hsdev,
> +			HID_INPUT_REPORT,
> +			usage_id,
> +			address,
> +			&(st->magn[i]));
> +		if (!status)
> +			attr_count++;
> +	}
>   
> -	for (i = 0; i <= CHANNEL_SCAN_INDEX_Z; ++i) {
> -		ret = sensor_hub_input_get_attribute_info(hsdev,
> -				HID_INPUT_REPORT,
> -				usage_id,
> -				HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_X_AXIS + i,
> -				&st->magn[CHANNEL_SCAN_INDEX_X + i]);
> -		if (ret < 0)
> -			break;
> -		magn_3d_adjust_channel_bit_mask(channels,
> -				CHANNEL_SCAN_INDEX_X + i,
> -				st->magn[CHANNEL_SCAN_INDEX_X + i].size);
> +	if (attr_count <= 0) {
> +		dev_err(&pdev->dev,
> +			"failed to find any supported usage attributes in report\n");
> +		return  -EINVAL;
>   	}
> -	dev_dbg(&pdev->dev, "magn_3d %x:%x, %x:%x, %x:%x\n",
> +
> +	dev_dbg(&pdev->dev, "magn_3d Found %d usage attributes\n",
> +			attr_count);
> +	dev_dbg(&pdev->dev, "magn_3d X: %x:%x Y: %x:%x Z: %x:%x\n",
>   			st->magn[0].index,
>   			st->magn[0].report_id,
>   			st->magn[1].index, st->magn[1].report_id,
>   			st->magn[2].index, st->magn[2].report_id);
>   
> +	/* Setup IIO channel array */
> +	_channels = devm_kcalloc(&pdev->dev, attr_count,
> +				sizeof(struct iio_chan_spec),
> +				GFP_KERNEL);
> +	if (!_channels) {
> +		dev_err(&pdev->dev,
> +			"failed to allocate space for iio channels\n");
> +		return -ENOMEM;
> +	}
> +
> +	st->iio_vals = devm_kcalloc(&pdev->dev, attr_count,
> +				sizeof(u32),
> +				GFP_KERNEL);
> +	if (!st->iio_vals) {
> +		dev_err(&pdev->dev,
> +			"failed to allocate space for iio values array\n");
> +		return -ENOMEM;
> +	}
> +
> +	for (i = 0, *chan_count = 0;
> +	i < MAGN_3D_CHANNEL_MAX && *chan_count < attr_count;
> +	i++){
> +		if (st->magn[i].index >= 0) {
> +			/* Setup IIO channel struct */
> +			(_channels[*chan_count]) = magn_3d_channels[i];
> +			(_channels[*chan_count]).scan_index = *chan_count;
> +			(_channels[*chan_count]).address = i;
> +
> +			/* Set magn_val_addr to iio value address */
> +			st->magn_val_addr[i] = &(st->iio_vals[*chan_count]);
> +			magn_3d_adjust_channel_bit_mask(_channels,
> +							*chan_count,
> +							st->magn[i].size);
> +			(*chan_count)++;
> +		}
> +	}
> +
> +	if (*chan_count <= 0) {
> +		dev_err(&pdev->dev,
> +			"failed to find any magnetic channels setup\n");
> +		return -EINVAL;
> +	}
> +
> +	*channels = _channels;
> +
> +	dev_dbg(&pdev->dev, "magn_3d Setup %d IIO channels\n",
> +			*chan_count);
> +
>   	st->scale_precision = hid_sensor_format_scale(
>   				HID_USAGE_SENSOR_COMPASS_3D,
>   				&st->magn[CHANNEL_SCAN_INDEX_X],
> @@ -296,7 +365,7 @@ static int magn_3d_parse_report(struct platform_device *pdev,
>   			st->common_attributes.sensitivity.report_id);
>   	}
>   
> -	return ret;
> +	return 0;
>   }
>   
>   /* Function to initialize the processing for usage id */
> @@ -308,6 +377,7 @@ static int hid_magn_3d_probe(struct platform_device *pdev)
>   	struct magn_3d_state *magn_state;
>   	struct hid_sensor_hub_device *hsdev = pdev->dev.platform_data;
>   	struct iio_chan_spec *channels;
> +	int chan_count = 0;
>   
>   	indio_dev = devm_iio_device_alloc(&pdev->dev,
>   					  sizeof(struct magn_3d_state));
> @@ -328,22 +398,16 @@ static int hid_magn_3d_probe(struct platform_device *pdev)
>   		return ret;
>   	}
>   
> -	channels = kmemdup(magn_3d_channels, sizeof(magn_3d_channels),
> -			   GFP_KERNEL);
> -	if (!channels) {
> -		dev_err(&pdev->dev, "failed to duplicate channels\n");
> -		return -ENOMEM;
> -	}
> -
> -	ret = magn_3d_parse_report(pdev, hsdev, channels,
> +	ret = magn_3d_parse_report(pdev, hsdev,
> +				&channels, &chan_count,
>   				HID_USAGE_SENSOR_COMPASS_3D, magn_state);
>   	if (ret) {
> -		dev_err(&pdev->dev, "failed to setup attributes\n");
> -		goto error_free_dev_mem;
> +		dev_err(&pdev->dev, "failed to parse report\n");
> +		return ret;
>   	}
>   
>   	indio_dev->channels = channels;
> -	indio_dev->num_channels = ARRAY_SIZE(magn_3d_channels);
> +	indio_dev->num_channels = chan_count;
>   	indio_dev->dev.parent = &pdev->dev;
>   	indio_dev->info = &magn_3d_info;
>   	indio_dev->name = name;
> @@ -353,7 +417,7 @@ static int hid_magn_3d_probe(struct platform_device *pdev)
>   		NULL, NULL);
>   	if (ret) {
>   		dev_err(&pdev->dev, "failed to initialize trigger buffer\n");
> -		goto error_free_dev_mem;
> +		return ret;
>   	}
>   	atomic_set(&magn_state->common_attributes.data_ready, 0);
>   	ret = hid_sensor_setup_trigger(indio_dev, name,
> @@ -387,8 +451,6 @@ error_remove_trigger:
>   	hid_sensor_remove_trigger(&magn_state->common_attributes);
>   error_unreg_buffer_funcs:
>   	iio_triggered_buffer_cleanup(indio_dev);
> -error_free_dev_mem:
> -	kfree(indio_dev->channels);
>   	return ret;
>   }
>   
> @@ -403,7 +465,6 @@ static int hid_magn_3d_remove(struct platform_device *pdev)
>   	iio_device_unregister(indio_dev);
>   	hid_sensor_remove_trigger(&magn_state->common_attributes);
>   	iio_triggered_buffer_cleanup(indio_dev);
> -	kfree(indio_dev->channels);
>   
>   	return 0;
>   }

