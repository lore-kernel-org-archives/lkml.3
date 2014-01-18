Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbaARLi0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 06:38:26 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:38187 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841AbaARLiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 06:38:25 -0500
Message-ID: <52DA67BF.3040405@kernel.org>
Date: Sat, 18 Jan 2014 11:38:39 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Meerwald <pmeerw@pmeerw.net>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
CC: pali.rohar@gmail.com, pavel@ucw.cz, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ivaylo Dimitrov <freemangordon@abv.bg>
Subject: Re: [PATCH] iio: tsl2563: Use the correct channel2 member
References: <52D30BF7.90107@kernel.org> <1389633859-5972-1-git-send-email-ivo.g.dimitrov.75@gmail.com> <alpine.DEB.2.01.1401132222150.3351@pmeerw.net> <52DA6789.4000500@kernel.org>
In-Reply-To: <52DA6789.4000500@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 18/01/14 11:37, Jonathan Cameron wrote:
>
>
> On 13/01/14 21:25, Peter Meerwald wrote:
>>
>>> Use the correct channel2 member instead of channel when dealing with sysfs
>>> reads/writes
>>
>>> Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
>>
>> as a bonus, m is renamed to mask
> Which would have been relevant back when it was a mask.  Still it doesn't
> make things worse, so never mind ;)  One day someone might be bored enough
> to clean up all the places in read_raw etc where the variable is called mask
> but is infact a straight number.
>>
>> Acked-by: Peter Meerwald <pmeerw@pmeerw.net>
> Applied to the fixes-togreg branch of iio.git  - initially pushed out as testing
> for the autobuilders to thoroughly hammer.
I'm dozing this morning.  This of course the fixes-togreg branch which doesn't get
separately pushed out for autobuilding fun and goes straight out as fixes-togreg!


>>
>>> ---
>>>   drivers/iio/light/tsl2563.c |   16 ++++++++++------
>>>   1 files changed, 10 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/drivers/iio/light/tsl2563.c b/drivers/iio/light/tsl2563.c
>>> index 5e5d9de..2be6df3 100644
>>> --- a/drivers/iio/light/tsl2563.c
>>> +++ b/drivers/iio/light/tsl2563.c
>>> @@ -460,10 +460,14 @@ static int tsl2563_write_raw(struct iio_dev *indio_dev,
>>>   {
>>>       struct tsl2563_chip *chip = iio_priv(indio_dev);
>>>
>>> -    if (chan->channel == IIO_MOD_LIGHT_BOTH)
>>> +    if (mask != IIO_CHAN_INFO_CALIBSCALE)
>>> +        return -EINVAL;
>>> +    if (chan->channel2 == IIO_MOD_LIGHT_BOTH)
>>>           chip->calib0 = calib_from_sysfs(val);
>>> -    else
>>> +    else if (chan->channel2 == IIO_MOD_LIGHT_IR)
>>>           chip->calib1 = calib_from_sysfs(val);
>>> +    else
>>> +        return -EINVAL;
>>>
>>>       return 0;
>>>   }
>>> @@ -472,14 +476,14 @@ static int tsl2563_read_raw(struct iio_dev *indio_dev,
>>>                   struct iio_chan_spec const *chan,
>>>                   int *val,
>>>                   int *val2,
>>> -                long m)
>>> +                long mask)
>>>   {
>>>       int ret = -EINVAL;
>>>       u32 calib0, calib1;
>>>       struct tsl2563_chip *chip = iio_priv(indio_dev);
>>>
>>>       mutex_lock(&chip->lock);
>>> -    switch (m) {
>>> +    switch (mask) {
>>>       case IIO_CHAN_INFO_RAW:
>>>       case IIO_CHAN_INFO_PROCESSED:
>>>           switch (chan->type) {
>>> @@ -498,7 +502,7 @@ static int tsl2563_read_raw(struct iio_dev *indio_dev,
>>>               ret = tsl2563_get_adc(chip);
>>>               if (ret)
>>>                   goto error_ret;
>>> -            if (chan->channel == 0)
>>> +            if (chan->channel2 == IIO_MOD_LIGHT_BOTH)
>>>                   *val = chip->data0;
>>>               else
>>>                   *val = chip->data1;
>>> @@ -510,7 +514,7 @@ static int tsl2563_read_raw(struct iio_dev *indio_dev,
>>>           break;
>>>
>>>       case IIO_CHAN_INFO_CALIBSCALE:
>>> -        if (chan->channel == 0)
>>> +        if (chan->channel2 == IIO_MOD_LIGHT_BOTH)
>>>               *val = calib_to_sysfs(chip->calib0);
>>>           else
>>>               *val = calib_to_sysfs(chip->calib1);
>>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
