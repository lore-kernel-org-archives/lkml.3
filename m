Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083AbaFJS35 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 14:29:57 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:39636 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbaFJS3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 14:29:55 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <CA+BWVUTxE=dzGthxPXq9JHnW0rqhBhqmz5gTZ-PpiHhxnmSupA@mail.gmail.com>
References: <1401750890-31854-1-git-send-email-reyad.attiyat@gmail.com> <1401750890-31854-4-git-send-email-reyad.attiyat@gmail.com> <5396111B.6090109@kernel.org> <CA+BWVUTxE=dzGthxPXq9JHnW0rqhBhqmz5gTZ-PpiHhxnmSupA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCHv2 3/3] IIO: hid-sensor-magn-3d: Add in support for True/Magnetic North HID usages
From: Jonathan Cameron <jic23@kernel.org>
Date: Tue, 10 Jun 2014 19:29:49 +0100
To: Reyad Attiyat <reyad.attiyat@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Message-ID: <ee475858-f061-4129-97e9-073c0030ff9c@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On June 10, 2014 6:33:25 PM GMT+01:00, Reyad Attiyat <reyad.attiyat@gmail.com> wrote:
>Hey Jonathan,
>
>I will make the changes you suggested thanks for reviewing this. Any
>conclusions on the naming, did you want me to change the sysfs name to
>"in_rot_from_north_true/magnetic"?
Yes. I think that is the cleanest option from those we have considered!
>
>On Mon, Jun 9, 2014 at 2:55 PM, Jonathan Cameron <jic23@kernel.org>
>wrote:
>> On 03/06/14 00:14, Reyad Attiyat wrote:
>>>
>>> Updated magn_3d_channel enum for all possible north channels
>>>
>>> Added functions to setup iio_chan_spec array depending on which hid
>usage
>>> reports are found
>>>
>>> Renamed magn_val to iio_val to differentiate the index being used
>>>
>>> Updated magn_3d_state struct to hold pointer array (magn_val_addr[])
>which
>>> points to iio_val[]
>>>
>>> Updated magn_3d_parse_report to scan for all compass usages and
>create iio
>>> channels for each
>>>
>>> Signed-off-by: Reyad Attiyat <reyad.attiyat@gmail.com>
>>
>> Hi Reyad,
>>
>> I've taken a rather quick look at this.  Will probably want to take
>> one more close look at a newer version.
>>
>> Various bits and bobs inline - mostly fine!
>> Jonathan
>>
>>> ---
>>>   drivers/iio/magnetometer/hid-sensor-magn-3d.c | 271
>>> +++++++++++++++++---------
>>>   1 file changed, 177 insertions(+), 94 deletions(-)
>>>
>>> diff --git a/drivers/iio/magnetometer/hid-sensor-magn-3d.c
>>> b/drivers/iio/magnetometer/hid-sensor-magn-3d.c
>>> index 6d162b7..32f4d90 100644
>>> --- a/drivers/iio/magnetometer/hid-sensor-magn-3d.c
>>> +++ b/drivers/iio/magnetometer/hid-sensor-magn-3d.c
>>> @@ -34,63 +34,54 @@ enum magn_3d_channel {
>>>         CHANNEL_SCAN_INDEX_X,
>>>         CHANNEL_SCAN_INDEX_Y,
>>>         CHANNEL_SCAN_INDEX_Z,
>>> +       CHANNEL_SCAN_INDEX_NORTH_MAGN,
>>> +       CHANNEL_SCAN_INDEX_NORTH_TRUE,
>>> +       CHANNEL_SCAN_INDEX_NORTH_TILT_COMP,
>>> +       CHANNEL_SCAN_INDEX_NORTH_TRUE_TILT_COMP,
>>>         MAGN_3D_CHANNEL_MAX,
>>>   };
>>>
>>> +#define IIO_CHANNEL_MAX MAGN_3D_CHANNEL_MAX
>>
>> Please don't define a generic sounding name for a local
>> constant.  Why not use MAGN_3D_CHANNEL_MAX everywhere?
>>
>>> +
>>>   struct magn_3d_state {
>>>         struct hid_sensor_hub_callbacks callbacks;
>>>         struct hid_sensor_common common_attributes;
>>>         struct hid_sensor_hub_attribute_info
>magn[MAGN_3D_CHANNEL_MAX];
>>> -       u32 magn_val[MAGN_3D_CHANNEL_MAX];
>>> -};
>>> +       u32 *magn_val_addr[MAGN_3D_CHANNEL_MAX];
>>>
>>> -static const u32 magn_3d_addresses[MAGN_3D_CHANNEL_MAX] = {
>>> -       HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_X_AXIS,
>>> -       HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_Y_AXIS,
>>> -       HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_Z_AXIS
>>> +       u32 iio_val[IIO_CHANNEL_MAX];
>>> +       int num_iio_channels;
>>>   };
>>>
>>> -/* Channel definitions */
>>> -static const struct iio_chan_spec magn_3d_channels[] = {
>>> -       {
>>> -               .type = IIO_MAGN,
>>> -               .modified = 1,
>>> -               .channel2 = IIO_MOD_X,
>>> -               .info_mask_shared_by_type =
>BIT(IIO_CHAN_INFO_OFFSET) |
>>> -               BIT(IIO_CHAN_INFO_SCALE) |
>>> -               BIT(IIO_CHAN_INFO_SAMP_FREQ) |
>>> -               BIT(IIO_CHAN_INFO_HYSTERESIS),
>>> -               .scan_index = CHANNEL_SCAN_INDEX_X,
>>> -       }, {
>>> -               .type = IIO_MAGN,
>>> -               .modified = 1,
>>> -               .channel2 = IIO_MOD_Y,
>>> -               .info_mask_shared_by_type =
>BIT(IIO_CHAN_INFO_OFFSET) |
>>> -               BIT(IIO_CHAN_INFO_SCALE) |
>>> -               BIT(IIO_CHAN_INFO_SAMP_FREQ) |
>>> -               BIT(IIO_CHAN_INFO_HYSTERESIS),
>>> -               .scan_index = CHANNEL_SCAN_INDEX_Y,
>>> -       }, {
>>> -               .type = IIO_MAGN,
>>> -               .modified = 1,
>>> -               .channel2 = IIO_MOD_Z,
>>> -               .info_mask_shared_by_type =
>BIT(IIO_CHAN_INFO_OFFSET) |
>>> -               BIT(IIO_CHAN_INFO_SCALE) |
>>> -               BIT(IIO_CHAN_INFO_SAMP_FREQ) |
>>> -               BIT(IIO_CHAN_INFO_HYSTERESIS),
>>> -               .scan_index = CHANNEL_SCAN_INDEX_Z,
>>> +/* Find index into magn_3d_state magn[] and magn_val_addr[] from
>HID
>>> Usage  */
>>> +static int magn_3d_usage_id_to_chan_index(unsigned usage_id){
>>> +       int offset = -1;
>>
>> I'd personally prefer offset = -EINVAL and to have it assigned as
>> a default element in the switch statement rather that here.
>>
>>> +
>>> +       switch (usage_id) {
>>> +       case HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_X_AXIS:
>>> +               offset = CHANNEL_SCAN_INDEX_X;
>>> +               break;
>>> +       case HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_Y_AXIS:
>>> +               offset = CHANNEL_SCAN_INDEX_Y;
>>> +               break;
>>> +       case HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_Z_AXIS:
>>> +               offset = CHANNEL_SCAN_INDEX_Z;
>>> +               break;
>>> +       case HID_USAGE_SENSOR_ORIENT_COMP_MAGN_NORTH:
>>> +               offset = CHANNEL_SCAN_INDEX_NORTH_TILT_COMP;
>>> +               break;
>>> +       case HID_USAGE_SENSOR_ORIENT_COMP_TRUE_NORTH:
>>> +               offset = CHANNEL_SCAN_INDEX_NORTH_TRUE_TILT_COMP;
>>> +               break;
>>> +       case HID_USAGE_SENSOR_ORIENT_MAGN_NORTH:
>>> +               offset = CHANNEL_SCAN_INDEX_NORTH_MAGN;
>>> +               break;
>>> +       case HID_USAGE_SENSOR_ORIENT_TRUE_NORTH:
>>> +               offset = CHANNEL_SCAN_INDEX_NORTH_TRUE;
>>> +               break;
>>>         }
>>> -};
>>>
>>> -/* Adjust channel real bits based on report descriptor */
>>> -static void magn_3d_adjust_channel_bit_mask(struct iio_chan_spec
>>> *channels,
>>> -                                               int channel, int
>size)
>>> -{
>>> -       channels[channel].scan_type.sign = 's';
>>> -       /* Real storage bits will change based on the report desc.
>*/
>>> -       channels[channel].scan_type.realbits = size * 8;
>>> -       /* Maximum size of a sample to capture is u32 */
>>> -       channels[channel].scan_type.storagebits = sizeof(u32) * 8;
>>> +       return offset;
>>>   }
>>>
>>>   /* Channel read_raw handler */
>>> @@ -101,21 +92,31 @@ static int magn_3d_read_raw(struct iio_dev
>>> *indio_dev,
>>>   {
>>>         struct magn_3d_state *magn_state = iio_priv(indio_dev);
>>>         int report_id = -1;
>>> -       u32 address;
>>> +       unsigned usage_id;
>>> +       int chan_index = -1;
>>>         int ret;
>>>         int ret_type;
>>>
>>> +       dev_dbg(&indio_dev->dev, "magn_3d_read_raw\n");
>>> +
>>>         *val = 0;
>>>         *val2 = 0;
>>>         switch (mask) {
>>>         case 0:
>>> +               /* We store the HID usage ID of the iio channel
>>> +                * in its address field
>>> +                */
>>> +               usage_id = chan->address;
>>> +               chan_index =
>magn_3d_usage_id_to_chan_index(usage_id);
>>
>>
>>> +               if(chan_index < 0)
>>> +                       return -EINVAL;
>>> +
>>>                 report_id =
>>> -                      
>magn_state->magn[chan->scan_index].report_id;
>>> -               address = magn_3d_addresses[chan->scan_index];
>>> +                       magn_state->magn[chan_index].report_id;
>>>                 if (report_id >= 0)
>>>                         *val = sensor_hub_input_attr_get_raw_value(
>>>                                 magn_state->common_attributes.hsdev,
>>> -                               HID_USAGE_SENSOR_COMPASS_3D,
>address,
>>> +                               HID_USAGE_SENSOR_COMPASS_3D,
>usage_id,
>>>                                 report_id);
>>>                 else {
>>>                         *val = 0;
>>> @@ -202,12 +203,13 @@ static int magn_3d_proc_event(struct
>>> hid_sensor_hub_device *hsdev,
>>>                                
>magn_state->common_attributes.data_ready);
>>>         if (magn_state->common_attributes.data_ready)
>>>                 hid_sensor_push_data(indio_dev,
>>> -                               magn_state->magn_val,
>>> -                               sizeof(magn_state->magn_val));
>>> +                               &(magn_state->iio_val),
>>> +                               sizeof(magn_state->iio_val));
>>>
>>>         return 0;
>>>   }
>>>
>>> +
>>>   /* Capture samples in local storage */
>>>   static int magn_3d_capture_sample(struct hid_sensor_hub_device
>*hsdev,
>>>                                 unsigned usage_id,
>>> @@ -217,63 +219,143 @@ static int magn_3d_capture_sample(struct
>>> hid_sensor_hub_device *hsdev,
>>>         struct iio_dev *indio_dev = platform_get_drvdata(priv);
>>>         struct magn_3d_state *magn_state = iio_priv(indio_dev);
>>>         int offset;
>>> +       u32 *magn_val;
>>>         int ret = -EINVAL;
>>>
>>> -       switch (usage_id) {
>>> +       offset = magn_3d_usage_id_to_chan_index(usage_id);
>>> +       if(offset < 0)
>>> +               return ret;
>>> +
>>> +       magn_val = magn_state->magn_val_addr[offset];
>>> +       if(!magn_val)
>>> +               return ret;
>>> +
>>> +       *(magn_val) =  *(u32 *)raw_data;
>>> +
>>> +       return 0;
>>> +}
>>> +
>>> +/* Setup the iio_chan_spec for HID Usage ID */
>>> +static int magn_3d_setup_new_iio_chan(struct hid_sensor_hub_device
>>> *hsdev,
>>> +                               unsigned usage_id,
>>> +                               unsigned attr_usage_id,
>>> +                               struct iio_chan_spec *iio_chans,
>>> +                               struct magn_3d_state *st)
>>> +{
>>> +       int ret = -1;
>>
>> This is kind of backwards to normal practice for this sort of
>function.
>> Better to maintain ret in the correct state at all times.  Hence
>> start with it being 0 and set to negative when there is an error
>rather
>> than the other way around.
>>
>>> +       int iio_index;
>>> +       int magn_index;
>>> +       struct iio_chan_spec *channel;
>>> +
>>> +       /* Setup magn_3d_state for new channel */
>>> +       magn_index = magn_3d_usage_id_to_chan_index(attr_usage_id);
>>> +       if(magn_index < 0 || magn_index >= MAGN_3D_CHANNEL_MAX){
>>> +               return -1;
>>> +       }
>>> +
>>> +       /* Check if usage attribute exists in the sensor hub device
>*/
>>> +       ret = sensor_hub_input_get_attribute_info(hsdev,
>>> +               HID_INPUT_REPORT,
>>> +               usage_id,
>>> +               attr_usage_id,
>>> +               &(st->magn[magn_index]));
>>> +       if(ret != 0){
>>> +               /* Usage not found. Nothing to setup.*/
>>> +               return 0;
>>> +       }
>>> +
>>> +       iio_index = st->num_iio_channels;
>>> +       if(iio_index < 0 || iio_index >= IIO_CHANNEL_MAX){
>>
>> I'd be tempted to allocate space dynamically but I guess this works.
>>
>>
>>> +               return -2;
>>> +       }
>>> +
>>> +       /* Check if this usage hasn't been setup */
>>> +       if(st->magn_val_addr[magn_index] != NULL){
>>
>> Space before that bracket here and elsewhere.
>> Don't return your own error codes. Use standard ones.  I guess thees
>> are left from debugging.
>>
>>> +               return -3;
>>> +       }
>>> +       st->magn_val_addr[magn_index] = &(st->iio_val[iio_index]);
>>> +
>>> +       /* Setup IIO Channel spec */
>>> +       channel = &(iio_chans[iio_index]);
>>
>> Just pass this is in as a pointer in the first place?
>> That is a pointer to the current channel location, that may or may
>> not be filled by this function.
>>
>>> +
>>> +       channel->type = IIO_MAGN;
>>> +       channel->address = attr_usage_id;
>>> +       channel->modified = 1;
>>> +
>>> +       switch (attr_usage_id){
>>> +       case HID_USAGE_SENSOR_ORIENT_COMP_MAGN_NORTH:
>>> +               channel->channel2 = IIO_MOD_NORTH_MAGN_TILT_COMP;
>>> +               break;
>>> +       case HID_USAGE_SENSOR_ORIENT_COMP_TRUE_NORTH:
>>> +               channel->channel2 = IIO_MOD_NORTH_TRUE_TILT_COMP;
>>> +               break;
>>> +       case HID_USAGE_SENSOR_ORIENT_MAGN_NORTH:
>>> +               channel->channel2 = IIO_MOD_NORTH_MAGN;
>>> +               break;
>>> +       case HID_USAGE_SENSOR_ORIENT_TRUE_NORTH:
>>> +               channel->channel2 = IIO_MOD_NORTH_TRUE;
>>> +               break;
>>>         case HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_X_AXIS:
>>> +               channel->channel2 = IIO_MOD_X;
>>> +               break;
>>>         case HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_Y_AXIS:
>>> +               channel->channel2 = IIO_MOD_Y;
>>> +               break;
>>>         case HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_Z_AXIS:
>>> -               offset = usage_id -
>>> HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_X_AXIS;
>>> -               magn_state->magn_val[CHANNEL_SCAN_INDEX_X + offset]
>=
>>> -                                               *(u32 *)raw_data;
>>> -               ret = 0;
>>> -       break;
>>> -       default:
>>> +               channel->channel2 = IIO_MOD_Z;
>>>                 break;
>>> +       default:
>>> +               return -4;
>>
>> huh?  why -4. -EINVAL or -ENOSUP or something similar perhaps.
>>
>>>         }
>>>
>>> +       channel->info_mask_shared_by_type =
>>> +               BIT(IIO_CHAN_INFO_OFFSET) |
>>> +               BIT(IIO_CHAN_INFO_SCALE) |
>>> +               BIT(IIO_CHAN_INFO_SAMP_FREQ) |
>>> +               BIT(IIO_CHAN_INFO_HYSTERESIS);
>>> +
>>> +       channel->scan_type.sign = 's';
>>> +       /* Real storage bits will change based on the report desc.
>*/
>>> +       channel->scan_type.realbits = st->magn[magn_index].size * 8;
>>> +       /* Maximum size of a sample to capture is u32 */
>>> +       channel->scan_type.storagebits = sizeof(u32) * 8;
>>> +
>>
>> I'd keen num_iio_channels outside this function and increment it if
>> this function does not return an error.
>>>
>>> +       (st->num_iio_channels)++;
>>
>> Don't do this. ret should have been valid throughout... if not
>something
>> odd is going on with your use of ret.
>>
>> Hmm. I see it is in the original code :( feel free to clean this up.
>>
>>> +       ret = 0;
>>> +
>>>         return ret;
>>>   }
>>>
>>> -/* Parse report which is specific to an usage id*/
>>> +/* Read the HID reports and setup IIO Channels */
>>>   static int magn_3d_parse_report(struct platform_device *pdev,
>>>                                 struct hid_sensor_hub_device *hsdev,
>>> -                               struct iio_chan_spec *channels,
>>> +                               struct iio_chan_spec *iio_chans,
>>>                                 unsigned usage_id,
>>>                                 struct magn_3d_state *st)
>>>   {
>>> -       int ret;
>>> +       int ret = 0;
>>>         int i;
>>>
>>> -       for (i = 0; i <= CHANNEL_SCAN_INDEX_Z; ++i) {
>>> -               ret = sensor_hub_input_get_attribute_info(hsdev,
>>> -                               HID_INPUT_REPORT,
>>> -                               usage_id,
>>> -                              
>HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_X_AXIS +
>>> i,
>>> -                               &st->magn[CHANNEL_SCAN_INDEX_X +
>i]);
>>> -               if (ret < 0)
>>> -                       break;
>>> -               magn_3d_adjust_channel_bit_mask(channels,
>>> -                               CHANNEL_SCAN_INDEX_X + i,
>>> -                               st->magn[CHANNEL_SCAN_INDEX_X +
>i].size);
>>> -       }
>>> -       dev_dbg(&pdev->dev, "magn_3d %x:%x, %x:%x, %x:%x\n",
>>> -                       st->magn[0].index,
>>> -                       st->magn[0].report_id,
>>> -                       st->magn[1].index, st->magn[1].report_id,
>>> -                       st->magn[2].index, st->magn[2].report_id);
>>> -
>>> -       /* Set Sensitivity field ids, when there is no individual
>modifier
>>> */
>>> -       if (st->common_attributes.sensitivity.index < 0) {
>>> -               sensor_hub_input_get_attribute_info(hsdev,
>>> -                       HID_FEATURE_REPORT, usage_id,
>>> -                      
>HID_USAGE_SENSOR_DATA_MOD_CHANGE_SENSITIVITY_ABS |
>>> -                       HID_USAGE_SENSOR_DATA_ORIENTATION,
>>> -                       &st->common_attributes.sensitivity);
>>> -               dev_dbg(&pdev->dev, "Sensitivity index:report
>%d:%d\n",
>>> -                       st->common_attributes.sensitivity.index,
>>> -                      
>st->common_attributes.sensitivity.report_id);
>>> -       }
>>> +       dev_dbg(&pdev->dev, "magn_3d_parse_reports Usage ID: %x\n",
>>> usage_id);
>>> +       for(i = HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_X_AXIS;
>>> +           i <= HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_Z_AXIS && ret ==
>0;
>>> +               i++)
>>> +                       ret = magn_3d_setup_new_iio_chan(hsdev,
>>> +                                       usage_id,
>>> +                                       i,
>>> +                                       iio_chans,
>>> +                                       st);
>>> +
>>> +       dev_dbg(&pdev->dev, "magn_3d_parse_reports Found %d\n
>magnetic
>>> axis. Returned: %d", st->num_iio_channels, ret);
>>> +       for(i = HID_USAGE_SENSOR_ORIENT_COMP_MAGN_NORTH;
>>> +           i <= HID_USAGE_SENSOR_ORIENT_TRUE_NORTH && ret == 0;
>>> +               i++)
>>> +                       ret = magn_3d_setup_new_iio_chan(hsdev,
>>> +                                       usage_id,
>>> +                                       i,
>>> +                                       iio_chans,
>>> +                                       st);
>>
>> As stated above, I'd use whether this succeeds for a given channel to
>> increment the location in iio_chans and then pass in only the 'next'
>channel
>> location on each pass.  Moving the bounds checks out here as well
>would be
>> make for a cleaner magn_3d_setup_new_iio_chan function.
>>
>>
>>> +       dev_dbg(&pdev->dev, "magn_3d_parse_reports Found %d\n
>magnetic
>>> channels. Returned: %d", st->num_iio_channels, ret);
>>>
>>>         return ret;
>>>   }
>>> @@ -307,10 +389,11 @@ static int hid_magn_3d_probe(struct
>platform_device
>>> *pdev)
>>>                 return ret;
>>>         }
>>>
>>> -       channels = kmemdup(magn_3d_channels,
>sizeof(magn_3d_channels),
>>> -                          GFP_KERNEL);
>>> +       channels = kcalloc(MAGN_3D_CHANNEL_MAX,
>>> +                       sizeof(struct iio_chan_spec),
>>> +                       GFP_KERNEL);
>>>         if (!channels) {
>>> -               dev_err(&pdev->dev, "failed to duplicate
>channels\n");
>>> +               dev_err(&pdev->dev, "failed to allocate memory for
>iio
>>> channel\n");
>>>                 return -ENOMEM;
>>>         }
>>>
>>> @@ -322,7 +405,7 @@ static int hid_magn_3d_probe(struct
>platform_device
>>> *pdev)
>>>         }
>>>
>>>         indio_dev->channels = channels;
>>> -       indio_dev->num_channels = ARRAY_SIZE(magn_3d_channels);
>>> +       indio_dev->num_channels = magn_state->num_iio_channels;
>>
>> With a bit of rearranging it strikes me that you can fill
>num_channels
>> directly rather than having another copy of it....
>>
>>>         indio_dev->dev.parent = &pdev->dev;
>>>         indio_dev->info = &magn_3d_info;
>>>         indio_dev->name = name;
>>>
>>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-iio" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
