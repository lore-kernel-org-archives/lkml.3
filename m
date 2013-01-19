Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290Ab3AST6W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 14:58:22 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:39594 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751572Ab3AST6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 14:58:21 -0500
Message-ID: <50FAFB32.6040203@metafoo.de>
Date: Sat, 19 Jan 2013 20:59:46 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Icedove/3.0.11
MIME-Version: 1.0
To: christophe leroy <christophe.leroy@c-s.fr>
CC: Jonathan Cameron <jic23@cam.ac.uk>, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, patrick.vasseur@c-s.fr
Subject: Re: [PATCH] IIO ADC support for AD7923
References: <201301080842.r088gKWO031124@localhost.localdomain> <50EBF48E.4040607@metafoo.de> <50FAB623.5070006@c-s.fr>
In-Reply-To: <50FAB623.5070006@c-s.fr>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 01/19/2013 04:05 PM, christophe leroy wrote:
> Hi Lars,
> 
> Sorry to respond so late, I've been very busy lately.
> Please see answers/questions below
> 
> Main point is that our driver is mainly copied and adapted from AD7298
> driver, and your comments are on things that we have not modified from
> AD7298, so what should we do really ?

The AD7288 driver has recently seen some updates. The issues which your driver
inherited from the AD7288 driver have been fixed in the original driver. See:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blob;f=drivers/iio/adc/ad7298.c;h=b34d754994d50d53f60fee694440658ba0b137dd;hb=HEAD

> 
> We are a bit new comers in Kernel Development, so thanks for your help.
> 
> Christophe
> 
> Le 08/01/2013 11:27, Lars-Peter Clausen a écrit :
>> On 01/08/2013 09:42 AM, Christophe Leroy wrote:
>>> This patch adds support for Analog Devices AD7923 ADC in the IIO
>>> Subsystem.
>>>
>>> Signed-off-by: Patrick Vasseur <patrick.vasseur@c-s.fr>
>>> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
>> Hi,
>>
>> Thanks for the driver, looks pretty good. Some comments inline.
>>
>> - Lars
>>
>>> diff -uN linux-3.7.1/drivers/staging/iio/adc/Kconfig
>>> linux/drivers/staging/iio/adc/Kconfig
>>> --- linux-3.7.1/drivers/staging/iio/adc/Kconfig    2012-12-17
>>> 20:14:54.000000000 +0100
>>> +++ linux/drivers/staging/iio/adc/Kconfig    2012-12-13
>>> 19:52:10.000000000 +0100
>> New IIO drivers should not be added to staging, unless there is a very
>> good
>> reason. Since this driver does not have any major issues it should
>> directly go
>> into drivers/iio/
> Our driver is based on AD7298 driver, which is today in staging. Should
> we put ours in drivers/iio/ directly anyway ?
>>
>> [...]
>>
[...]
>>> diff -uN linux-3.7.1/drivers/staging/iio/adc/ad7923_core.c
>>> linux/drivers/staging/iio/adc/ad7923_core.c
>>> --- linux-3.7.1/drivers/staging/iio/adc/ad7923_core.c    1970-01-01
>>> 01:00:00.000000000 +0100
>>> +++ linux/drivers/staging/iio/adc/ad7923_core.c    2013-01-05
>> [...]
>>> +
>>> +static int ad7923_read_raw(struct iio_dev *indio_dev,
>>> +               struct iio_chan_spec const *chan,
>>> +               int *val,
>>> +               int *val2,
>>> +               long m)
>>> +{
>>> +    int ret;
>>> +    struct ad7923_state *st = iio_priv(indio_dev);
>>> +
>>> +    switch (m) {
>>> +    case IIO_CHAN_INFO_RAW:
>>> +        mutex_lock(&indio_dev->mlock);
>>> +        if (iio_buffer_enabled(indio_dev))
>>> +            ret = -EBUSY;
>>> +        else
>>> +            ret = ad7923_scan_direct(st, chan->address);
>>> +        mutex_unlock(&indio_dev->mlock);
>>> +
>>> +        if (ret < 0)
>>> +            return ret;
>>> +        if (chan->address == EXTRACT(ret, 12, 4)) {
>>> +            *val = EXTRACT(ret, 0, 12);
>>> +            *val2 = EXTRACT_PERCENT(*val, 12);
>> val2 is never used in the upper layers in this case.
> I don't understand what you mean.

Just drop the *val2 = ... line. It doesn't make any sense in this context. Also
make sure to remove the EXTRACT_PERCENT macro since it wont be used anymore.

> Again, this is copied from AD7298
>>
[...]
>>> +/**
>>> + * ad7923_update_scan_mode() setup the spi transfer buffer for the
>>> new scan mask
>>> + **/
>>> +int ad7923_update_scan_mode(struct iio_dev *indio_dev,
>>> +    const unsigned long *active_scan_mask)
>>> +{
>>> +    struct ad7923_state *st = iio_priv(indio_dev);
>>> +    int i, cmd, channel;
>>> +    int scan_count;
>>> +
>>> +    /* Now compute overall size */
>>> +    for (i = 0, channel = 0; i < AD7923_MAX_CHAN; i++)
>>> +        if (test_bit(i, active_scan_mask))
>>> +            channel = i;
>>> +
>>> +    cmd = AD7923_WRITE_CR | AD7923_CODING | AD7923_RANGE |
>>> +        AD7923_PM_MODE_WRITE(AD7923_PM_MODE_OPS) |
>>> +        AD7923_SEQUENCE_WRITE(AD7923_SEQUENCE_ON) |
>>> +        AD7923_CHANNEL_WRITE(channel);
>> Hm, ok this looks a bit strange. You lookup the first channel which is
>> selected
>> and then also sample all channels which come before it. E.g. if only
>> channel 2
>> is selected you sample channel 0, 1 and 2. In the trigger handler you
>> push the
>> buffer to the IIO core. But in your buffer you have the result of
>> channel 0 in
>> the position where IIO would expect channel 2.
>> I think it is better if you send a cmd for each channel that needs to be
>> samples. E.g.:
>>
>>     if (for_each_set_bit(i, active_scan_mask, AD7923_MAX_CHAN)) {
>>         cmd = AD7923_WRITE_CR | AD7923_CODING | AD7923_RANGE |
>>             AD7923_PM_MODE_WRITE(AD7923_PM_MODE_OPS) |
>>             AD7923_SEQUENCE_WRITE(AD7923_SEQUENCE_OFF) |
>>             AD7923_CHANNEL_WRITE(i);
>>         cmd <<= AD7923_SHIFT_REGISTER;
>>         st->tx_buf[j++] = cpu_to_be16(cmd);
>>     }
> Ok, here we are trying to use the sequence mode. But unlike the AD7298,
> here sequence mode is only able to go from channel 0 to a given channel.
> Hence the reason why we try to identify the highest requested channel,
> then we do a sequential read of all from 0 to this one.
> 

The issue is that this doesn't work for all configurations. E.g. imagine
channel 0 is not selected and channel 1 is selected. You are now going to
sample both channel 0 and channel 1. Although you should only sample channel 1.

> Wouldn't the use on non sequential mode be less performant ?

I'm not sure whether the sequential mode actually gives you better performance
or whether it's just for convenience. But you can add a special case to the
sample function where it will use the sequential mode when possible.

- Lars
