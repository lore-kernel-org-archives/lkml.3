Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278AbaDNVDO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 17:03:14 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:58132 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935AbaDNVCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 17:02:07 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <2f4487f4-71fd-49fc-97ed-61a3dd117ac6@email.android.com>
References: <1397004988-31550-1-git-send-email-srinivas.pandruvada@linux.intel.com> <1397004988-31550-2-git-send-email-srinivas.pandruvada@linux.intel.com> <53496F52.9040802@kernel.org> <534B3F1A.60003@linux.intel.com> <2f4487f4-71fd-49fc-97ed-61a3dd117ac6@email.android.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [Patch v3 2/6] IIO: core: Introduce read_raw_multi
From: Jonathan Cameron <jic23@kernel.org>
Date: Mon, 14 Apr 2014 22:02:03 +0100
To: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <3300ea6c-90a3-4732-a26f-a03f13938c2f@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On April 14, 2014 8:02:29 AM GMT+01:00, Jonathan Cameron <jic23@kernel.org> wrote:
>
>
>On April 14, 2014 2:51:22 AM GMT+01:00, Srinivas Pandruvada
><srinivas.pandruvada@linux.intel.com> wrote:
>>
>>On 04/12/2014 09:52 AM, Jonathan Cameron wrote:
>>> On 09/04/14 01:56, Srinivas Pandruvada wrote:
>>>> This callback is introduced to overcome some limitations of
>existing
>>>> read_raw callback. The functionality of both existing read_raw and
>>>> read_raw_multi is similar, both are used to request values from the
>>>> device. The current read_raw callback allows only two return
>values.
>>>> The new read_raw_multi allows returning multiple values. Instead of
>>>> passing just address of val and val2, it passes length and pointer
>>>> to values. Depending on the type and length of passed buffer, iio
>>>> client drivers can return multiple values.
>>>>
>>>> Signed-off-by: Srinivas Pandruvada
>><srinivas.pandruvada@linux.intel.com>
>>> Hi Srinivas.
>>>
>>> This has come together pretty much how I thought it would. Very
>nice.
>>> Only comment inline is that I'd prefer we took care now with
>>possiblity
>>> of really long sets of values so that we don't get bitten by it
>>sometime
>>> in the future.
>>>
>>I was thinking of using snprintf, but buf had no length passed. If we 
>>assume PAGE_SIZE as max length
>>then I can do what you suggested below,
>IIRC sysfs buffers are always PAGE_SIZE long. Easy enough to check I
>guess.
Yup. See fs/sysfs/file.c
sysfs_kf_seq_show.

>>
>>Thanks,
>>Srinivas
>>> If you want to drop the reference to 0 having special meaning in the
>>> comment as well, thats fine by me.
>>>
>>> Jonathan
>>>> ---
>>>>   drivers/iio/iio_core.h           |  2 +-
>>>>   drivers/iio/industrialio-core.c  | 65 
>>>> ++++++++++++++++++++++++++--------------
>>>>   drivers/iio/industrialio-event.c |  6 ++--
>>>>   drivers/iio/inkern.c             | 16 ++++++++--
>>>>   include/linux/iio/iio.h          | 17 +++++++++++
>>>>   include/linux/iio/types.h        |  1 +
>>>>   6 files changed, 80 insertions(+), 27 deletions(-)
>>>>
>>>> diff --git a/drivers/iio/iio_core.h b/drivers/iio/iio_core.h
>>>> index f6db6af..30327ad 100644
>>>> --- a/drivers/iio/iio_core.h
>>>> +++ b/drivers/iio/iio_core.h
>>>> @@ -35,7 +35,7 @@ int __iio_add_chan_devattr(const char *postfix,
>>>>                  struct list_head *attr_list);
>>>>   void iio_free_chan_devattr_list(struct list_head *attr_list);
>>>>
>>>> -ssize_t iio_format_value(char *buf, unsigned int type, int val,
>int
>>
>>>> val2);
>>>> +ssize_t iio_format_value(char *buf, unsigned int type, int size,
>>int 
>>>> *val);
>>>>
>>>>   /* Event interface flags */
>>>>   #define IIO_BUSY_BIT_POS 1
>>>> diff --git a/drivers/iio/industrialio-core.c 
>>>> b/drivers/iio/industrialio-core.c
>>>> index ede16aec..3bd565c 100644
>>>> --- a/drivers/iio/industrialio-core.c
>>>> +++ b/drivers/iio/industrialio-core.c
>>>> @@ -373,41 +373,53 @@ EXPORT_SYMBOL_GPL(iio_enum_write);
>>>>    * @buf: The buffer to which the formated value gets written
>>>>    * @type: One of the IIO_VAL_... constants. This decides how the 
>>>> val and val2
>>>>    *        parameters are formatted.
>>>> - * @val: First part of the value, exact meaning depends on the
>type
>>
>>>> parameter.
>>>> - * @val2: Second part of the value, exact meaning depends on the 
>>>> type parameter.
>>>> + * @vals: pointer to the values, exact meaning depends on the type
>
>>>> parameter.
>>>>    */
>>>> -ssize_t iio_format_value(char *buf, unsigned int type, int val,
>int
>>
>>>> val2)
>>>> +ssize_t iio_format_value(char *buf, unsigned int type, int size,
>>int 
>>>> *vals)
>>>>   {
>>>>       unsigned long long tmp;
>>>>       bool scale_db = false;
>>>>
>>>>       switch (type) {
>>>>       case IIO_VAL_INT:
>>>> -        return sprintf(buf, "%d\n", val);
>>>> +        return sprintf(buf, "%d\n", vals[0]);
>>>>       case IIO_VAL_INT_PLUS_MICRO_DB:
>>>>           scale_db = true;
>>>>       case IIO_VAL_INT_PLUS_MICRO:
>>>> -        if (val2 < 0)
>>>> -            return sprintf(buf, "-%ld.%06u%s\n", abs(val), -val2,
>>>> +        if (vals[1] < 0)
>>>> +            return sprintf(buf, "-%ld.%06u%s\n", abs(vals[0]),
>>>> +                    -vals[1],
>>>>                   scale_db ? " dB" : "");
>>>>           else
>>>> -            return sprintf(buf, "%d.%06u%s\n", val, val2,
>>>> +            return sprintf(buf, "%d.%06u%s\n", vals[0], vals[1],
>>>>                   scale_db ? " dB" : "");
>>>>       case IIO_VAL_INT_PLUS_NANO:
>>>> -        if (val2 < 0)
>>>> -            return sprintf(buf, "-%ld.%09u\n", abs(val), -val2);
>>>> +        if (vals[1] < 0)
>>>> +            return sprintf(buf, "-%ld.%09u\n", abs(vals[0]),
>>>> +                    -vals[1]);
>>>>           else
>>>> -            return sprintf(buf, "%d.%09u\n", val, val2);
>>>> +            return sprintf(buf, "%d.%09u\n", vals[0], vals[1]);
>>>>       case IIO_VAL_FRACTIONAL:
>>>> -        tmp = div_s64((s64)val * 1000000000LL, val2);
>>>> -        val2 = do_div(tmp, 1000000000LL);
>>>> -        val = tmp;
>>>> -        return sprintf(buf, "%d.%09u\n", val, val2);
>>>> +        tmp = div_s64((s64)vals[0] * 1000000000LL, vals[1]);
>>>> +        vals[1] = do_div(tmp, 1000000000LL);
>>>> +        vals[0] = tmp;
>>>> +        return sprintf(buf, "%d.%09u\n", vals[0], vals[1]);
>>>>       case IIO_VAL_FRACTIONAL_LOG2:
>>>> -        tmp = (s64)val * 1000000000LL >> val2;
>>>> -        val2 = do_div(tmp, 1000000000LL);
>>>> -        val = tmp;
>>>> -        return sprintf(buf, "%d.%09u\n", val, val2);
>>>> +        tmp = (s64)vals[0] * 1000000000LL >> vals[1];
>>>> +        vals[1] = do_div(tmp, 1000000000LL);
>>>> +        vals[0] = tmp;
>>>> +        return sprintf(buf, "%d.%09u\n", vals[0], vals[1]);
>>>> +    case IIO_VAL_INT_MULTIPLE:
>>>> +    {
>>>> +        int i;
>>>> +        int len = 0;
>>>> +
>>>> +        for (i = 0; i < size; ++i)
>>>> +            len += sprintf(&buf[len], "%d ", vals[i]);
>>>> +        buf[len++] = '\n';
>>>> +        buf[len++] = '\0';
>>> Whilst we know this is of a fixed maxium length, I think we
>>> want to take more care to ensure that we don't overrun the maximum
>>> sysfs length. I'd also prefer specific use of snprintf for the new
>>> line as well to make sure that doesn't cause trouble. i.e.
>>>
>>> for (i = 0; i < size; ++i)
>>>     len += snprintf(&buf[len], PAGE_SIZE - len, "%d ", vals[i]);
>>> len += snprintf(&buf[len], PAGE_SIZE - len, "/n");
>>>
>>> The reasoning being that we could easily mess something up and hit
>>these
>>> limits sometime in the future.  Also not using the explicit
>character
>>> settting, but doing it with snprintf is easier to read (slightly ;)
>>>
>>>
>>>> +        return len;
>>>> +    }
>>>>       default:
>>>>           return 0;
>>>>       }
>>>> @@ -419,14 +431,23 @@ static ssize_t iio_read_channel_info(struct 
>>>> device *dev,
>>>>   {
>>>>       struct iio_dev *indio_dev = dev_to_iio_dev(dev);
>>>>       struct iio_dev_attr *this_attr = to_iio_dev_attr(attr);
>>>> -    int val, val2;
>>>> -    int ret = indio_dev->info->read_raw(indio_dev, this_attr->c,
>>>> -                        &val, &val2, this_attr->address);
>>>> +    int vals[INDIO_MAX_RAW_ELEMENTS];
>>>> +    int ret;
>>>> +    int val_len = 2;
>>>> +
>>>> +    if (indio_dev->info->read_raw_multi)
>>>> +        ret = indio_dev->info->read_raw_multi(indio_dev,
>>this_attr->c,
>>>> +                            INDIO_MAX_RAW_ELEMENTS,
>>>> +                            vals, &val_len,
>>>> +                            this_attr->address);
>>>> +    else
>>>> +        ret = indio_dev->info->read_raw(indio_dev, this_attr->c,
>>>> +                    &vals[0], &vals[1], this_attr->address);
>>>>
>>>>       if (ret < 0)
>>>>           return ret;
>>>>
>>>> -    return iio_format_value(buf, ret, val, val2);
>>>> +    return iio_format_value(buf, ret, val_len, vals);
>>>>   }
>>>>
>>>>   /**
>>>> diff --git a/drivers/iio/industrialio-event.c 
>>>> b/drivers/iio/industrialio-event.c
>>>> index ea6e06b..1b4f31b 100644
>>>> --- a/drivers/iio/industrialio-event.c
>>>> +++ b/drivers/iio/industrialio-event.c
>>>> @@ -270,7 +270,7 @@ static ssize_t iio_ev_value_show(struct device
>>*dev,
>>>>   {
>>>>       struct iio_dev *indio_dev = dev_to_iio_dev(dev);
>>>>       struct iio_dev_attr *this_attr = to_iio_dev_attr(attr);
>>>> -    int val, val2;
>>>> +    int val, val2, val_arr[2];
>>>>       int ret;
>>>>
>>>>       ret = indio_dev->info->read_event_value(indio_dev,
>>>> @@ -279,7 +279,9 @@ static ssize_t iio_ev_value_show(struct device
>>*dev,
>>>>           &val, &val2);
>>>>       if (ret < 0)
>>>>           return ret;
>>>> -    return iio_format_value(buf, ret, val, val2);
>>>> +    val_arr[0] = val;
>>>> +    val_arr[1] = val2;
>>>> +    return iio_format_value(buf, ret, 2, val_arr);
>>>>   }
>>>>
>>>>   static ssize_t iio_ev_value_store(struct device *dev,
>>>> diff --git a/drivers/iio/inkern.c b/drivers/iio/inkern.c
>>>> index 0cf5f8e..75e5386 100644
>>>> --- a/drivers/iio/inkern.c
>>>> +++ b/drivers/iio/inkern.c
>>>> @@ -417,12 +417,24 @@ static int iio_channel_read(struct
>iio_channel
>>
>>>> *chan, int *val, int *val2,
>>>>       enum iio_chan_info_enum info)
>>>>   {
>>>>       int unused;
>>>> +    int vals[INDIO_MAX_RAW_ELEMENTS];
>>>> +    int ret;
>>>> +    int val_len = 2;
>>>>
>>>>       if (val2 == NULL)
>>>>           val2 = &unused;
>>>>
>>>> -    return chan->indio_dev->info->read_raw(chan->indio_dev, 
>>>> chan->channel,
>>>> -                        val, val2, info);
>>>> +    if (chan->indio_dev->info->read_raw_multi) {
>>>> +        ret =
>>chan->indio_dev->info->read_raw_multi(chan->indio_dev,
>>>> +                    chan->channel, INDIO_MAX_RAW_ELEMENTS,
>>>> +                    vals, &val_len, info);
>>>> +        *val = vals[0];
>>>> +        *val2 = vals[1];
>>>> +    } else
>>>> +        ret = chan->indio_dev->info->read_raw(chan->indio_dev,
>>>> +                    chan->channel, val, val2, info);
>>>> +
>>>> +    return ret;
>>>>   }
>>>>
>>>>   int iio_read_channel_raw(struct iio_channel *chan, int *val)
>>>> diff --git a/include/linux/iio/iio.h b/include/linux/iio/iio.h
>>>> index 5f2d00e..5629c92 100644
>>>> --- a/include/linux/iio/iio.h
>>>> +++ b/include/linux/iio/iio.h
>>>> @@ -288,6 +288,8 @@ static inline s64 iio_get_time_ns(void)
>>>>   #define INDIO_ALL_BUFFER_MODES                    \
>>>>       (INDIO_BUFFER_TRIGGERED | INDIO_BUFFER_HARDWARE)
>>>>
>>>> +#define INDIO_MAX_RAW_ELEMENTS        4
>>>> +
>>>>   struct iio_trigger; /* forward declaration */
>>>>   struct iio_dev;
>>>>
>>>> @@ -302,6 +304,14 @@ struct iio_dev;
>>>>    *            the channel in question.  Return value will specify
>>the
>>>>    *            type of value returned by the device. val and val2
>>will
>>>>    *            contain the elements making up the returned value.
>>>> + * @read_raw_multi:    function to return values from the device.
>>>> + *            mask specifies which value. Note 0 means a reading
>of
>>> This note 0 bit wants to go now it is much more explicit in the way 
>>> the code
>>> works, but leave it here for now and we can tidy up both this and
>the
>>
>>> read_raw
>>> callback at the same time.
>>>> + *            the channel in question. Return value will specify
>>the
>>>> + *            type of value returned by the device. vals pointer
>>>> + *            contain the elements making up the returned value.
>>>> + *            max_len specifies maximum number of elements
>>>> + *            vals pointer can contain. val_len is used to return
>>>> + *            length of valid elements in vals.
>>>>    * @write_raw:        function to write a value to the device.
>>>>    *            Parameters are the same as for read_raw.
>>>>    * @write_raw_get_fmt:    callback function to query the expected
>>>> @@ -328,6 +338,13 @@ struct iio_info {
>>>>               int *val2,
>>>>               long mask);
>>>>
>>>> +    int (*read_raw_multi)(struct iio_dev *indio_dev,
>>>> +            struct iio_chan_spec const *chan,
>>>> +            int max_len,
>>>> +            int *vals,
>>>> +            int *val_len,
>>>> +            long mask);
>>>> +
>>>>       int (*write_raw)(struct iio_dev *indio_dev,
>>>>                struct iio_chan_spec const *chan,
>>>>                int val,
>>>> diff --git a/include/linux/iio/types.h b/include/linux/iio/types.h
>>>> index 084d882..a13c224 100644
>>>> --- a/include/linux/iio/types.h
>>>> +++ b/include/linux/iio/types.h
>>>> @@ -79,6 +79,7 @@ enum iio_event_direction {
>>>>   #define IIO_VAL_INT_PLUS_MICRO 2
>>>>   #define IIO_VAL_INT_PLUS_NANO 3
>>>>   #define IIO_VAL_INT_PLUS_MICRO_DB 4
>>>> +#define IIO_VAL_INT_MULTIPLE 5
>>>>   #define IIO_VAL_FRACTIONAL 10
>>>>   #define IIO_VAL_FRACTIONAL_LOG2 11
>>>>
>>>>
>>>
>>> -- 
>>> To unsubscribe from this list: send the line "unsubscribe linux-iio"
>>in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
