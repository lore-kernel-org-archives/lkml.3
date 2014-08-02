Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490AbaHBXzO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 19:55:14 -0400
Received: from mga03.intel.com ([143.182.124.21]:18827 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbaHBXzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 19:55:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,788,1400050800"; 
   d="scan'208";a="464343606"
Message-ID: <53DD7A5F.4000204@linux.intel.com>
Date: Sat, 02 Aug 2014 16:55:11 -0700
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Himangi Saraogi <himangi774@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Archana Patni <archana.patni@linux.intel.com>,
        Jonathan Cameron <jic23@kernel.org>, linux-kernel@vger.kernel.org
CC: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH] HID: hid-sensor-hub: use devm_ functions consistently
References: <20140802221135.GA18239@himangi-Dell>
In-Reply-To: <20140802221135.GA18239@himangi-Dell>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 08/02/2014 03:11 PM, Himangi Saraogi wrote:
> Use devm_kzalloc for all calls to kzalloc and not just the first.  Use
> devm functions for other allocations as well. The calls to free the
> allocated memory in the probe and remove functions are done away with
> and a label is removed in the probe function.
>
> The semantic match that finds the inconsistency is as follows:
>
> // <smpl>
> @@
> @@
>
> *devm_kzalloc(...)
> ...
> *kzalloc(...)
> // </smpl>
>
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>
  Reviewed-by: Srinivas Pandruvada <srinivas.pandruvada@intel.com>

> ---
>   drivers/hid/hid-sensor-hub.c | 33 +++++++++++----------------------
>   1 file changed, 11 insertions(+), 22 deletions(-)
>
> diff --git a/drivers/hid/hid-sensor-hub.c b/drivers/hid/hid-sensor-hub.c
> index e244e44..2ac2576 100644
> --- a/drivers/hid/hid-sensor-hub.c
> +++ b/drivers/hid/hid-sensor-hub.c
> @@ -604,9 +604,9 @@ static int sensor_hub_probe(struct hid_device *hdev,
>   		ret = -EINVAL;
>   		goto err_stop_hw;
>   	}
> -	sd->hid_sensor_hub_client_devs = kzalloc(dev_cnt *
> -						sizeof(struct mfd_cell),
> -						GFP_KERNEL);
> +	sd->hid_sensor_hub_client_devs = devm_kzalloc(&hdev->dev, dev_cnt *
> +						      sizeof(struct mfd_cell),
> +						      GFP_KERNEL);
>   	if (sd->hid_sensor_hub_client_devs == NULL) {
>   		hid_err(hdev, "Failed to allocate memory for mfd cells\n");
>   			ret = -ENOMEM;
> @@ -618,11 +618,12 @@ static int sensor_hub_probe(struct hid_device *hdev,
>   
>   		if (collection->type == HID_COLLECTION_PHYSICAL) {
>   
> -			hsdev = kzalloc(sizeof(*hsdev), GFP_KERNEL);
> +			hsdev = devm_kzalloc(&hdev->dev, sizeof(*hsdev),
> +					     GFP_KERNEL);
>   			if (!hsdev) {
>   				hid_err(hdev, "cannot allocate hid_sensor_hub_device\n");
>   				ret = -ENOMEM;
> -				goto err_no_mem;
> +				goto err_stop_hw;
>   			}
>   			hsdev->hdev = hdev;
>   			hsdev->vendor_id = hdev->vendor;
> @@ -631,13 +632,13 @@ static int sensor_hub_probe(struct hid_device *hdev,
>   			if (last_hsdev)
>   				last_hsdev->end_collection_index = i;
>   			last_hsdev = hsdev;
> -			name = kasprintf(GFP_KERNEL, "HID-SENSOR-%x",
> -					collection->usage);
> +			name = devm_kasprintf(&hdev->dev, GFP_KERNEL,
> +					      "HID-SENSOR-%x",
> +					      collection->usage);
>   			if (name == NULL) {
>   				hid_err(hdev, "Failed MFD device name\n");
>   					ret = -ENOMEM;
> -					kfree(hsdev);
> -					goto err_no_mem;
> +					goto err_stop_hw;
>   			}
>   			sd->hid_sensor_hub_client_devs[
>   				sd->hid_sensor_client_cnt].id =
> @@ -661,16 +662,10 @@ static int sensor_hub_probe(struct hid_device *hdev,
>   	ret = mfd_add_devices(&hdev->dev, 0, sd->hid_sensor_hub_client_devs,
>   		sd->hid_sensor_client_cnt, NULL, 0, NULL);
>   	if (ret < 0)
> -		goto err_no_mem;
> +		goto err_stop_hw;
>   
>   	return ret;
>   
> -err_no_mem:
> -	for (i = 0; i < sd->hid_sensor_client_cnt; ++i) {
> -		kfree(sd->hid_sensor_hub_client_devs[i].name);
> -		kfree(sd->hid_sensor_hub_client_devs[i].platform_data);
> -	}
> -	kfree(sd->hid_sensor_hub_client_devs);
>   err_stop_hw:
>   	hid_hw_stop(hdev);
>   
> @@ -681,7 +676,6 @@ static void sensor_hub_remove(struct hid_device *hdev)
>   {
>   	struct sensor_hub_data *data = hid_get_drvdata(hdev);
>   	unsigned long flags;
> -	int i;
>   
>   	hid_dbg(hdev, " hardware removed\n");
>   	hid_hw_close(hdev);
> @@ -691,11 +685,6 @@ static void sensor_hub_remove(struct hid_device *hdev)
>   		complete(&data->pending.ready);
>   	spin_unlock_irqrestore(&data->lock, flags);
>   	mfd_remove_devices(&hdev->dev);
> -	for (i = 0; i < data->hid_sensor_client_cnt; ++i) {
> -		kfree(data->hid_sensor_hub_client_devs[i].name);
> -		kfree(data->hid_sensor_hub_client_devs[i].platform_data);
> -	}
> -	kfree(data->hid_sensor_hub_client_devs);
>   	hid_set_drvdata(hdev, NULL);
>   	mutex_destroy(&data->mutex);
>   }

