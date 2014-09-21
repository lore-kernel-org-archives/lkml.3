Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751509AbaIUN3o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 09:29:44 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:49387 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbaIUN3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 09:29:42 -0400
Message-ID: <541ED2C0.4040801@kernel.org>
Date: Sun, 21 Sep 2014 14:29:36 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Stanimir Varbanov <svarbanov@mm-sol.com>
CC: Hartmut Knaack <knaack.h@gmx.de>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Angelo Compagnucci <angelo.compagnucci@gmail.com>,
        Doug Anderson <dianders@chromium.org>,
        Fugang Duan <B38611@freescale.com>,
        Johannes Thumshirn <johannes.thumshirn@men.de>,
        Jean Delvare <jdelvare@suse.de>, Philippe Reynes <tremyfr@yahoo.fr>,
        Lee Jones <lee.jones@linaro.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        David Collins <collinsd@codeaurora.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>, "Kim, Milo" <Milo.Kim@ti.com>
Subject: Re: [PATCH v2 1/2] iio: vadc: Qualcomm SPMI PMIC voltage ADC driver
References: <1410448403-19402-1-git-send-email-svarbanov@mm-sol.com> <1410448403-19402-2-git-send-email-svarbanov@mm-sol.com> <54138151.8010902@gmx.de> <54147E97.60808@kernel.org> <5416F3E2.3030009@mm-sol.com> <4dbc485f-599a-4b50-854c-c2e1c44d4810@email.android.com> <541AAC80.1090708@mm-sol.com>
In-Reply-To: <541AAC80.1090708@mm-sol.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/09/14 10:57, Stanimir Varbanov wrote:
> Hi Jonathan,
> 
> On 09/15/2014 07:11 PM, Jonathan Cameron wrote:
>>
>>
>> On September 15, 2014 3:12:50 PM GMT+01:00, Stanimir Varbanov <svarbanov@mm-sol.com> wrote:
>>> Hi Jonathan,
>>>
>>> Thanks for the review!
>>>
>>> On 09/13/2014 08:27 PM, Jonathan Cameron wrote:
>>>> On 13/09/14 00:27, Hartmut Knaack wrote:
>>>>> Stanimir Varbanov schrieb, Am 11.09.2014 17:13:
>>>>>> The voltage ADC is peripheral of Qualcomm SPMI PMIC chips. It has
>>>>>> 15bits resolution and register space inside PMIC accessible across
>>>>>> SPMI bus.
>>>>>>
>>>>>> The vadc driver registers itself through IIO interface.
>>>>>>
>>>>> Looks already pretty good. Things you should consider in regard of
>>> common coding style are to use the variable name ret instead of rc,
>>> since it is used in almost all adc drivers and thus makes reviewing a
>>> bit easier. Besides that, you seem to use unsigned as well as unsigned
>>> int, so to be consistent, please stick to one of them. Other comments
>>> in line.
>>>>
>>>> A few additional comments from me.  My biggest question is whether
>>>> you are actually making life difficult for yourself by having
>>>> vadc_channels and vadc->channels (don't like the similar naming btw!)
>>>> in different orders.  I think you can move the ordering into the
>>> device
>>>> tree reading code rather than doing it in lots of other places. 
>>> Hence
>>>> rather than an order based on the device tree description, put the
>>>> data into a fixed ofer in vadc->channels.
>>>>
>>>> Entirely possible I'm missing something though :)
>>>>>> Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
>>>>>> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
>>>>>> ---
>>>>>>  drivers/iio/adc/Kconfig                       |   11 +
>>>>>>  drivers/iio/adc/Makefile                      |    1 +
>>>>>>  drivers/iio/adc/qcom-spmi-vadc.c              |  999
>>> +++++++++++++++++++++++++
>>>>>>  include/dt-bindings/iio/qcom,spmi-pmic-vadc.h |  119 +++
>>>>>>  4 files changed, 1130 insertions(+), 0 deletions(-)
>>>>>>  create mode 100644 drivers/iio/adc/qcom-spmi-vadc.c
>>>>>>  create mode 100644 include/dt-bindings/iio/qcom,spmi-pmic-vadc.h
> 
> <snip>
> 
>>>>>> +	vchan = vadc_find_channel(vadc, chan->channel);
>>>>>> +	if (!vchan)
>>>>>> +		return -EINVAL;
>>>>>> +
>>>>>> +	if (!vadc->is_ref_measured) {
>>>>>> +		rc = vadc_measure_reference_points(vadc);
>>>>>> +		if (rc)
>>>>>> +			return rc;
>>>>>> +
>>>>>> +		vadc->is_ref_measured = true;
>>>>>> +	}
>>>>>> +
>>>>>> +	switch (mask) {
>>>>>> +	case IIO_CHAN_INFO_PROCESSED:
>>>>>> +		rc = vadc_do_conversion(vadc, vchan, &result.adc_code);
>>>>>> +		if (rc)
>>>>>> +			return rc;
>>>>>> +
>>>>>> +		vadc_calibrate(vadc, vchan, &result);
>>>>>> +
>>>>>> +		*val = result.physical;
>>>> I'm a little suspicious here.  Are the resulting values in milivolts
>>> for
>>>> all the channels?  Very handy if so, but seems a little unlikely with
>>> 15 bit
>>>> ADC that you'd have no part of greater accuracy than a milivolt.
>>>
>>> In fact *val is in microvolts. What is the expected unit from IIO ADC
>>> users?
>> See Documentation/ABI/sysfs-bus-iio
>> Millivolts I think... We copied hwmon where possible.
> 
> I'm a bit confused about these units. I searched references of
> iio_read_channel_processed() and found a few.
> 
> The iio_hwmon expecting milivolts. On the other side lp8788-charger.c
> registers a get_property method in charger-manager.c, which expects
> microvolts in get_batt_uV().
It's definitely meant to be millivolts (lifted from hwmon a while back).
See Documentation/ABI/testing/sysfs-bus-iio

Looks like we have a bug in lp8788-charger - it might be matched with
one in lp8788-adc, but then there will be a bug there...

Cc'd Milo Kim.

> 
> I also wonder how to implement IIO read_raw() method so as not to lose
> precision (if assume we must return millivolts). As far I can see it
> should be some combination of IIO_CHAN_INFO_RAW and IIO_CHAN_INFO_SCALE
> masks. Any hints?

Use val and val2 and a return type of IIO_VAL_INT_PLUS_MICRO.
So if you have n microvolts

val = n div 1000;
val2 = n mod 1000 * 1000;
This makes sense if you are returning a processed value.
Otherwise, use a scale infomask element (and support in read raw) to
ensure that rawvalue*scale is in millivolts
So if n is in microvolts it would simply be 1000.
(this would all have been more obvious if we hadn't copied hwmon and
had just used volts, but such is history).

As for in kernel users...
iio_read_channel_raw and iio_read_channel_processed assume we are looking
for an integer value out, so you'll want to call iio_read_channel_raw and
apply iio_convert_raw_to_processed with appropriately adjusted scale value.

> 
>>>
>>>>>> +		rc = IIO_VAL_INT;
>>>>> return IIO_VAL_INT;
>>>>>> +		break;
>>>>>> +	default:
>>>>>> +		rc = -EINVAL;
>>>>>> +		break;
>>>>> Drop default case, or leave empty.
>>>>>> +	}
>>>>>> +
>>>>>> +	return rc;
>>>>> return -EINVAL;
>>>>>> +}
> 
> 
