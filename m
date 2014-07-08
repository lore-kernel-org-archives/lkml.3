Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbaGHQAB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 12:00:01 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:47571 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbaGHP77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 11:59:59 -0400
MIME-Version: 1.0
In-Reply-To: <53BACE70.3070901@kernel.org>
References: <1404097119-19922-1-git-send-email-reyad.attiyat@gmail.com>
 <1404097119-19922-4-git-send-email-reyad.attiyat@gmail.com> <53BACE70.3070901@kernel.org>
From: Reyad Attiyat <reyad.attiyat@gmail.com>
Date: Tue, 8 Jul 2014 10:59:37 -0500
Message-ID: <CA+BWVURrNpJZ2sUr7=nysf22LEc_eT-w1GQM8zDu7C_-ti7qmA@mail.gmail.com>
Subject: Re: [PATCH v4 3/4] iio: hid-sensor-magn-3d: Scan for usage attributes
 before setting up iio channels
To: Jonathan Cameron <jic23@kernel.org>
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Jonathan,

Thanks for the review. I'll be sure to fix up all the formatting you
mentioned and run it through the checkpatch.pl script.

> There should be an explanation here of what has changed from one version to
> the
> next.
Will include updates in future patch notes.

> The patches should have been run through checkpatch.pl (at least one place
> below
> indicates that didn't happen).
>
> Mostly little bits left.  Now I would definitely like an ack or reviewed-by
> from Srinivas for this one if at all possible.
> Any tested-bys, particularly with parts that don't have the new channel
> types, would also be good.
>
> Jonathan
>
>>   drivers/iio/magnetometer/hid-sensor-magn-3d.c | 111
>> +++++++++++++++++---------
>>   1 file changed, 75 insertions(+), 36 deletions(-)
>>
>> diff --git a/drivers/iio/magnetometer/hid-sensor-magn-3d.c
>> b/drivers/iio/magnetometer/hid-sensor-magn-3d.c
>> index 41cf29e..070d20e 100644
>> --- a/drivers/iio/magnetometer/hid-sensor-magn-3d.c
>> +++ b/drivers/iio/magnetometer/hid-sensor-magn-3d.c
>> @@ -42,7 +42,8 @@ struct magn_3d_state {
>>         struct hid_sensor_hub_callbacks callbacks;
>>         struct hid_sensor_common common_attributes;
>>         struct hid_sensor_hub_attribute_info magn[MAGN_3D_CHANNEL_MAX];
>> -       u32 magn_val[MAGN_3D_CHANNEL_MAX];
>> +       u32 *magn_val_addr[MAGN_3D_CHANNEL_MAX];
>> +       u32 *iio_val;
>>         int scale_pre_decml;
>>         int scale_post_decml;
>>         int scale_precision;
>> @@ -221,8 +222,8 @@ static int magn_3d_proc_event(struct
>> hid_sensor_hub_device *hsdev,
>>         dev_dbg(&indio_dev->dev, "magn_3d_proc_event\n");
>>         if (atomic_read(&magn_state->common_attributes.data_ready))
>>                 hid_sensor_push_data(indio_dev,
>> -                               magn_state->magn_val,
>> -                               sizeof(magn_state->magn_val));
>> +                               magn_state->iio_val,
>> +                               sizeof(magn_state->iio_val));
>>
>>         return 0;
>>   }
>> @@ -236,52 +237,99 @@ static int magn_3d_capture_sample(struct
>> hid_sensor_hub_device *hsdev,
>>         struct iio_dev *indio_dev = platform_get_drvdata(priv);
>>         struct magn_3d_state *magn_state = iio_priv(indio_dev);
>>         int offset;
>> -       int ret = -EINVAL;
>> +       int ret = 0;
>> +       u32 *iio_val = NULL;
>
> This has me a little confused.  You have an iio_val in your state
> structure and in this function.  I can't actually find anywhere where
> the elements of the one in the state structure are ever assigned to
> anything.
>
>

I assign the pointer location of iio_vals to:
 u32 *magn_val_addr[MAGN_3D_CHANNEL_MAX];

I also added this array just for the locations. The assignment occurs
in the parse_report
function, after iio_vals is allocated, like this  st->magn_val_addr[i]
= &(st->iio_val[*chan_count]).
I'll add a comment to explain the usage better.


>>
>>         switch (usage_id) {
>>         case HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_X_AXIS:
>>         case HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_Y_AXIS:
>>         case HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_Z_AXIS:
>>                 offset = usage_id -
>> HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_X_AXIS;
>> -               magn_state->magn_val[CHANNEL_SCAN_INDEX_X + offset] =
>> -                                               *(u32 *)raw_data;
>> -               ret = 0;
>> +               iio_val = magn_state->magn_val_addr[CHANNEL_SCAN_INDEX_X +
>> offset];
>> +
>>         break;
>>         default:
>> -               break;
>> +               return -EINVAL;
>>         }
>>
>> +       if(iio_val)
>
> white space after if please.
>
>> +               *iio_val = *(u32 *)raw_data;
>> +       else
>> +               ret = -EINVAL;
>> +
>>         return ret;
>>   }
>>
>>   /* Parse report which is specific to an usage id*/
>>   static int magn_3d_parse_report(struct platform_device *pdev,
>>                                 struct hid_sensor_hub_device *hsdev,
>> -                               struct iio_chan_spec *channels,
>> +                               struct iio_chan_spec **channels,
>> +                               int *chan_count,
>>                                 unsigned usage_id,
>>                                 struct magn_3d_state *st)
>>   {
>> -       int ret;
>> +       int ret = 0;
>>         int i;
>> +       int attr_count = 0;
>> +
>> +       /* Scan for each usage attribute supported */
>> +       for (i = 0; i < MAGN_3D_CHANNEL_MAX; i++) {
>> +               u32 address = magn_3d_addresses[i];
>>
>> -       for (i = 0; i <= CHANNEL_SCAN_INDEX_Z; ++i) {
>> +               /* Check if usage attribute exists in the sensor hub
>> device */
>>                 ret = sensor_hub_input_get_attribute_info(hsdev,
>> -                               HID_INPUT_REPORT,
>> -                               usage_id,
>> -                               HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_X_AXIS +
>> i,
>> -                               &st->magn[CHANNEL_SCAN_INDEX_X + i]);
>> -               if (ret < 0)
>> -                       break;
>> -               magn_3d_adjust_channel_bit_mask(channels,
>> -                               CHANNEL_SCAN_INDEX_X + i,
>> -                               st->magn[CHANNEL_SCAN_INDEX_X + i].size);
>
> I would have preferred you kept the indenting the same as before. That would
> make it more obvious what changed.
>
>> +                       HID_INPUT_REPORT,
>> +                       usage_id,
>> +                       address,
>> +                       &(st->magn[i]));
>> +               if (!ret)
>> +                       attr_count++;
>>         }
>> -       dev_dbg(&pdev->dev, "magn_3d %x:%x, %x:%x, %x:%x\n",
>> +
>> +       dev_dbg(&pdev->dev, "magn_3d Found %d usage attributes\n",
>> +                       attr_count);
>> +       dev_dbg(&pdev->dev, "magn_3d X: %x:%x Y: %x:%x Z: %x:%x\n",
>>                         st->magn[0].index,
>>                         st->magn[0].report_id,
>>                         st->magn[1].index, st->magn[1].report_id,
>>                         st->magn[2].index, st->magn[2].report_id);
>>
>> +       if (attr_count > 0)
>> +               ret = 0;
>
> This would suggest to me that you want to rename the ret above (used
> to indicate if a channel is there) as something more specific so you
> don't end up appearing to squash and error here...
>

The ret value above needs to be zeroed out as it is used to break out
of the for loop when scanning for usage attributes.
I will use a different variable name perhaps to distinguish the two.
>> +       else
>> +               return  -EINVAL;
>
> Again your spacing is messed up. Please fix.
>
>> +
>> +       /* Setup IIO channel array */
>> +       *channels = devm_kcalloc(&pdev->dev, attr_count,
>> +
>
> The resulting indenting here is a complete mess. Please fix.
>
>
> sizeof(struct iio_chan_spec),
>>
>> +
>> GFP_KERNEL);
>> +       if (!*channels) {
>> +               dev_err(&pdev->dev, "failed to allocate space for iio
>> channels\n");
>> +               return -ENOMEM;
>> +       }
>> +
>> +       st->iio_val = devm_kcalloc(&pdev->dev, attr_count,
>> +
>> sizeof(u32),
>> +
>> GFP_KERNEL);
>> +       if (!st->iio_val) {
>> +               dev_err(&pdev->dev, "failed to allocate space for iio
>> values array\n");
>> +               return -ENOMEM;
>> +       }
>> +
>> +       for (i = 0, *chan_count = 0;
>> +           i < MAGN_3D_CHANNEL_MAX && *chan_count < attr_count;
>> +               i++)
>> +       {
>> +               if (st->magn[i].index >= 0) {
>> +                       /* Setup IIO channel struct */
>> +                       *channels[*chan_count] = magn_3d_channels[i];
>> +
>> +                       st->magn_val_addr[i] =
>> &(st->iio_val[*chan_count]);
>> +                       magn_3d_adjust_channel_bit_mask(*channels,
>> *chan_count, st->magn[i].size);
>
> The above should be wrapped appropriately.
>
>> +                       (*chan_count)++;
>> +               }
>> +       }
>> +
>>         st->scale_precision = hid_sensor_format_scale(
>>                                 HID_USAGE_SENSOR_COMPASS_3D,
>>                                 &st->magn[CHANNEL_SCAN_INDEX_X],
>> @@ -311,6 +359,7 @@ static int hid_magn_3d_probe(struct platform_device
>> *pdev)
>>         struct magn_3d_state *magn_state;
>>         struct hid_sensor_hub_device *hsdev = pdev->dev.platform_data;
>>         struct iio_chan_spec *channels;
>> +       int chan_count = 0;
>>
>>         indio_dev = devm_iio_device_alloc(&pdev->dev,
>>                                           sizeof(struct magn_3d_state));
>> @@ -331,22 +380,15 @@ static int hid_magn_3d_probe(struct platform_device
>> *pdev)
>>                 return ret;
>>         }
>>
>> -       channels = kmemdup(magn_3d_channels, sizeof(magn_3d_channels),
>> -                          GFP_KERNEL);
>> -       if (!channels) {
>> -               dev_err(&pdev->dev, "failed to duplicate channels\n");
>> -               return -ENOMEM;
>> -       }
>> -
>> -       ret = magn_3d_parse_report(pdev, hsdev, channels,
>> -                               HID_USAGE_SENSOR_COMPASS_3D, magn_state);
>> +       ret = magn_3d_parse_report(pdev, hsdev, &channels,
>> +                               &chan_count, HID_USAGE_SENSOR_COMPASS_3D,
>> magn_state);
>>         if (ret) {
>>                 dev_err(&pdev->dev, "failed to setup attributes\n");
>> -               goto error_free_dev_mem;
>> +               return ret;
>>         }
>>
>>         indio_dev->channels = channels;
>> -       indio_dev->num_channels = ARRAY_SIZE(magn_3d_channels);
>> +       indio_dev->num_channels = chan_count;
>>         indio_dev->dev.parent = &pdev->dev;
>>         indio_dev->info = &magn_3d_info;
>>         indio_dev->name = name;
>> @@ -356,7 +398,7 @@ static int hid_magn_3d_probe(struct platform_device
>> *pdev)
>>                 NULL, NULL);
>>         if (ret) {
>>                 dev_err(&pdev->dev, "failed to initialize trigger
>> buffer\n");
>> -               goto error_free_dev_mem;
>> +               return ret;
>>         }
>>         atomic_set(&magn_state->common_attributes.data_ready, 0);
>>         ret = hid_sensor_setup_trigger(indio_dev, name,
>> @@ -390,8 +432,6 @@ error_remove_trigger:
>>         hid_sensor_remove_trigger(&magn_state->common_attributes);
>>   error_unreg_buffer_funcs:
>>         iio_triggered_buffer_cleanup(indio_dev);
>> -error_free_dev_mem:
>> -       kfree(indio_dev->channels);
>>         return ret;
>>   }
>>
>> @@ -406,7 +446,6 @@ static int hid_magn_3d_remove(struct platform_device
>> *pdev)
>>         iio_device_unregister(indio_dev);
>>         hid_sensor_remove_trigger(&magn_state->common_attributes);
>>         iio_triggered_buffer_cleanup(indio_dev);
>> -       kfree(indio_dev->channels);
>>
>>         return 0;
>>   }
>>
>
